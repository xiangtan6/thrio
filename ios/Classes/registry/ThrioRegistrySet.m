//
//  ThrioRegistrySet.m
//  thrio
//
//  Created by foxsofter on 2019/12/10.
//

#import "ThrioRegistrySet.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThrioRegistrySet ()

@property (nonatomic, strong) NSMutableSet *sets;

@end

@implementation ThrioRegistrySet

+ (instancetype)set {
  return [[self alloc] init];
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _sets = [NSMutableSet set];
  }
  return self;
}

- (ThrioVoidCallback)registry:(id)value {
  NSAssert(value, @"value must not be null.");
  
  [_sets addObject:value];

  __weak typeof(self) weakself = self;
  return ^{
    __strong typeof(self) strongSelf = weakself;
    
    [strongSelf.sets removeObject:value];
  };
}

- (ThrioVoidCallback)registryAll:(NSSet *)values {
  NSAssert(values || values.count < 1, @"values must not be null or empty.");

  [_sets unionSet:values];
  
  __weak typeof(self) weakself = self;
  return ^{
    __strong typeof(self) strongSelf = weakself;
    [strongSelf.sets minusSet:values];
  };
}

- (void)clear {
  [_sets removeAllObjects];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)enumerationState
                                  objects:(id __unsafe_unretained _Nullable [])buffer
                                    count:(NSUInteger) len {
    return [_sets countByEnumeratingWithState:enumerationState
                                      objects:buffer
                                        count:len];
}

@end

NS_ASSUME_NONNULL_END
