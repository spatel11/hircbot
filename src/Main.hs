-- | Main entry point to the application.
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Applicative
import Data.Configurator as C
import Data.Configurator.Types
import Data.Text
import Network
import Pipes
import Pipes.ByteString
import System.IO hiding (stdout)


-- | The main entry point.
main :: IO ()
main = withSocketsDo $ do
    (conf,_) <- autoReload reloadConfig [Required "conf.cfg"]
    server <- require conf "connection.server" :: IO String
    port <- PortNumber . fromIntegral <$> (require conf "connection.port" :: IO Int)
    handle <- connectTo server port
    runEffect (bot conf handle)
    putStrLn "Welcome to FP Haskell Center!"
    putStrLn "Have a good day!"

reloadConfig :: AutoConfig
reloadConfig = autoConfig {onError = print}

--bot :: Config -> Handle -> Consumer' ByteString IO ()
bot conf h = fromHandle h >-> stdout

