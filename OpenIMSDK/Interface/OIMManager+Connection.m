//
//  OIMManager+Connection.m
//  OpenIMSDK
//
//  Created by x on 2021/2/15.
//

#import "OIMManager+Connection.h"
#import "CallbackProxy.h"

@implementation OIMManager (Connection)

- (BOOL)initSDKWithApiAdrr:(NSString *)apiAddr
                    wsAddr:(NSString *)wsAddr
                   dataDir:(NSString *)dataDir
                  logLevel:(NSInteger)logLevel
             objectStorage:(NSString *)os
              onConnecting:(OIMVoidCallback)onConnecting
          onConnectFailure:(OIMFailureCallback)onConnectFailure
          onConnectSuccess:(OIMVoidCallback)onConnectSuccess
           onKickedOffline:(OIMVoidCallback)onKickedOffline
        onUserTokenExpired:(OIMVoidCallback)onUserTokenExpired {
    
    return [self initSDK: [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? iPad : iPhone
                 apiAdrr:apiAddr
                  wsAddr:wsAddr
                 dataDir:dataDir
                logLevel:logLevel
           objectStorage:os
            onConnecting:onConnecting
        onConnectFailure:onConnectFailure
        onConnectSuccess:onConnectSuccess
         onKickedOffline:onKickedOffline
      onUserTokenExpired:onUserTokenExpired];
}

- (BOOL)initSDK:(OIMPlatform)platform
        apiAdrr:(NSString *)apiAddr
         wsAddr:(NSString *)wsAddr
        dataDir:(NSString *)dataDir
       logLevel:(NSInteger)logLevel
  objectStorage:(NSString *)os
   onConnecting:(OIMVoidCallback)onConnecting
onConnectFailure:(OIMFailureCallback)onConnectFailure
onConnectSuccess:(OIMVoidCallback)onConnectSuccess
onKickedOffline:(OIMVoidCallback)onKickedOffline
onUserTokenExpired:(OIMVoidCallback)onUserTokenExpired {
    
    [self class].callbacker.connecting = onConnecting;
    [self class].callbacker.connectFailure = onConnectFailure;
    [self class].callbacker.connectSuccess = onConnectSuccess;
    [self class].callbacker.kickedOffline = onKickedOffline;
    [self class].callbacker.userTokenExpired = onUserTokenExpired;
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    NSString *path = dataDir;
    
    if (!dataDir) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [paths.firstObject stringByAppendingString:@"/"];
    }
    
    param[@"platform"] = @(platform);
    param[@"api_addr"] = apiAddr;
    param[@"ws_addr"]  = wsAddr;
    param[@"data_dir"] = path;
    param[@"log_level"] = logLevel == 0 ? @6 : @(logLevel);
    param[@"object_storage"] = os.length == 0 ? @"cos" : os;
    
    self.objectStorage = os.length == 0 ? @"cos" : os;
    
    return Open_im_sdkInitSDK([self class].callbacker, [self operationId], param.mj_JSONString);
}

- (void)setHeartbeatInterval:(NSInteger)heartbeatInterval {
    Open_im_sdkSetHeartbeatInterval(heartbeatInterval);
}

- (void)wakeUpWithOnSuccess:(OIMSuccessCallback)onSuccess
                  onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkWakeUp(callback, [self operationId]);
}

@end
