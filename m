Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab3H0Da4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:30:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27097 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab3H0Daz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:30:55 -0400
X-IronPort-AV: E=Sophos;i="4.89,965,1367942400"; 
   d="scan'208";a="8312631"
Message-ID: <521C1C6A.8090907@cn.fujitsu.com>
Date: Tue, 27 Aug 2013 11:26:34 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] driver core / ACPI: Avoid device removal locking problems
References: <1543475.L7gSB7lLAu@vostro.rjw.lan> <4785337.sqQqDSPcpL@vostro.rjw.lan> <3389643.Fdir3g6c6B@vostro.rjw.lan> <1430120.G7JdUKlgj6@vostro.rjw.lan>
In-Reply-To: <1430120.G7JdUKlgj6@vostro.rjw.lan>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/27 11:28:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/27 11:28:57,
	Serialize complete at 2013/08/27 11:28:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 08/26/2013 11:02 PM, Rafael J. Wysocki wrote:

> On Monday, August 26, 2013 04:43:26 PM Rafael J. Wysocki wrote:
>> On Monday, August 26, 2013 02:42:09 PM Rafael J. Wysocki wrote:
>>> On Monday, August 26, 2013 11:13:13 AM Gu Zheng wrote:
>>>> Hi Rafael,
> 
> [...]
> 
>>
>> OK, so the patch below is quick and dirty and overkill, but it should make the
>> splat go away at least.
> 
> And if this patch does make the splat go away for you, please also test the
> appended one (Tejun, thanks for the hint!).

Yes, this one works too, and as expected, the ACPI part is still there.

Thanks,
Gu

======================================================                                                              
[ INFO: possible circular locking dependency detected ]                                                             
3.11.0-rc6-fix-refeal-fix-01+ #171 Tainted: GF                                                                      
-------------------------------------------------------                                                             
kworker/0:1/96 is trying to acquire lock:                                                                           
 (s_active#245){++++.+}, at: [<ffffffff8121062b>] sysfs_addrm_finish+0x3b/0x70                                      
                                                                                                                    
but task is already holding lock:                                                                                   
 (device_hotplug_lock){+.+.+.}, at: [<ffffffff813a16b7>] lock_device_hotplug+0x17/0x20                              
                                                                                                                    
which lock already depends on the new lock.                                                                         
                                                                                                                    
                                                                                                                    
the existing dependency chain (in reverse order) is:                                                                
                                                                                                                    
-> #2 (device_hotplug_lock){+.+.+.}:                                                                                
       [<ffffffff810ba88c>] validate_chain+0x70c/0x870                                                              
       [<ffffffff810bad5f>] __lock_acquire+0x36f/0x5f0                                                              
       [<ffffffff810bb080>] lock_acquire+0xa0/0x130                                                                 
       [<ffffffff8159779b>] mutex_lock_nested+0x7b/0x3b0                                                            
       [<ffffffff813a16b7>] lock_device_hotplug+0x17/0x20                                                           
       [<ffffffff8131c131>] acpi_scan_bus_device_check+0x33/0x10f                                                   
       [<ffffffff8131c220>] acpi_scan_device_check+0x13/0x15                                                        
       [<ffffffff81315dac>] acpi_os_execute_deferred+0x27/0x34                                                      
       [<ffffffff8106bec8>] process_one_work+0x1e8/0x560                                                            
       [<ffffffff8106d0a0>] worker_thread+0x120/0x3a0                                                               
       [<ffffffff81073b5e>] kthread+0xee/0x100                                                                      
       [<ffffffff815a5fdc>] ret_from_fork+0x7c/0xb0                                                                 
                                                                                                                    
-> #1 (acpi_scan_lock){+.+.+.}:                                                                                     
       [<ffffffff810ba88c>] validate_chain+0x70c/0x870                                                              
       [<ffffffff810bad5f>] __lock_acquire+0x36f/0x5f0                                                              
       [<ffffffff810bb080>] lock_acquire+0xa0/0x130                                                                 
       [<ffffffff8159779b>] mutex_lock_nested+0x7b/0x3b0                                                            
       [<ffffffff8131a58a>] acpi_eject_store+0x88/0x170                                                             
       [<ffffffff813a0f40>] dev_attr_store+0x20/0x30                                                                
       [<ffffffff8120ed96>] sysfs_write_file+0xe6/0x170                                                             
       [<ffffffff81195bc8>] vfs_write+0xc8/0x170                                                                    
       [<ffffffff81196182>] SyS_write+0x62/0xb0                                                                     
       [<ffffffff815a6082>] system_call_fastpath+0x16/0x1b                                                          
                                                                                                                    
-> #0 (s_active#245){++++.+}:                                                                                       
       [<ffffffff810ba148>] check_prev_add+0x598/0x5d0                                                              
       [<ffffffff810ba88c>] validate_chain+0x70c/0x870                                                              
       [<ffffffff810bad5f>] __lock_acquire+0x36f/0x5f0                                                              
       [<ffffffff810bb080>] lock_acquire+0xa0/0x130                                                                 
       [<ffffffff8120fed7>] sysfs_deactivate+0x157/0x1c0                                                            
       [<ffffffff8121062b>] sysfs_addrm_finish+0x3b/0x70                                                            
       [<ffffffff8120e280>] sysfs_hash_and_remove+0x60/0xb0                                                         
       [<ffffffff8120f2a9>] sysfs_remove_file+0x39/0x50                                                             
       [<ffffffff813a28f7>] device_remove_file+0x17/0x20                                                            
       [<ffffffff8131a271>] acpi_device_remove_files+0xa9/0x14b                                                     
       [<ffffffff8131a377>] acpi_device_unregister+0x64/0xa6                                                        
       [<ffffffff8131a3e4>] acpi_bus_remove+0x2b/0x2f                                                               
       [<ffffffff8131a91b>] acpi_bus_trim+0x73/0x7a                                                                 
       [<ffffffff8131b4a5>] acpi_scan_hot_remove+0x160/0x281                                                        
       [<ffffffff8131b6ce>] acpi_bus_hot_remove_device+0x32/0x69                                                    
       [<ffffffff81315dac>] acpi_os_execute_deferred+0x27/0x34                                                      
       [<ffffffff8106bec8>] process_one_work+0x1e8/0x560                                                            
       [<ffffffff8106d0a0>] worker_thread+0x120/0x3a0                                                               
       [<ffffffff81073b5e>] kthread+0xee/0x100                                                                      
       [<ffffffff815a5fdc>] ret_from_fork+0x7c/0xb0                                                                 
                                                                                                                    
other info that might help us debug this:                                                                           
                                                                                                                    
Chain exists of:                                                                                                    
  s_active#245 --> acpi_scan_lock --> device_hotplug_lock                                                           
                                                                                                                    
 Possible unsafe locking scenario:                                                                                  
                                                                                                                    
       CPU0                    CPU1                                                                                 
       ----                    ----                                                                                 
  lock(device_hotplug_lock);                                                                                        
                               lock(acpi_scan_lock);                                                                
                               lock(device_hotplug_lock);                                                           
  lock(s_active#245);                                                                                               
                                                                                                                    
 *** DEADLOCK ***                                                                                                   
                                                                                                                    
4 locks held by kworker/0:1/96:                                                                                     
 #0:  (kacpi_hotplug){.+.+.+}, at: [<ffffffff8106be53>] process_one_work+0x173/0x560                                
 #1:  ((&dpc->work)#3){+.+.+.}, at: [<ffffffff8106be53>] process_one_work+0x173/0x560                               
 #2:  (acpi_scan_lock){+.+.+.}, at: [<ffffffff8131b6c6>] acpi_bus_hot_remove_device+0x2a/0x69                       
 #3:  (device_hotplug_lock){+.+.+.}, at: [<ffffffff813a16b7>] lock_device_hotplug+0x17/0x20                         
                                                                                                                    
stack backtrace:                                                                                                    
CPU: 0 PID: 96 Comm: kworker/0:1 Tainted: GF            3.11.0-rc6-fix-refeal-fix-01+ #171                          
Hardware name: FUJITSU-SV PRIMEQUEST 1800E/SB, BIOS PRIMEQUEST 1000 Series BIOS Version 89.32 DP Proto 08/16/2012   
Workqueue: kacpi_hotplug acpi_os_execute_deferred                                                                   
 ffff8807bf6a2c00 ffff8807bf6a97a8 ffffffff81596d07 0000000000000002                                                
 0000000000000000 ffff8807bf6a97f8 ffffffff810b7ec9 ffff8807bf6a9818                                                
 ffffffff82171ce0 ffff8807bf6a97f8 ffff8807bf6a2bc8 ffff8807bf6a2c00                                                
Call Trace:                                                                                                         
 [<ffffffff81596d07>] dump_stack+0x59/0x82                                                                          
 [<ffffffff810b7ec9>] print_circular_bug+0x109/0x110                                                                
 [<ffffffff810ba148>] check_prev_add+0x598/0x5d0                                                                    
 [<ffffffff810b9a35>] ? debug_check_no_locks_freed+0x95/0xd0                                                        
 [<ffffffff810ba88c>] validate_chain+0x70c/0x870                                                                    
 [<ffffffff810b9151>] ? mark_lock+0x161/0x240                                                                       
 [<ffffffff810bad5f>] __lock_acquire+0x36f/0x5f0                                                                    
 [<ffffffff8121062b>] ? sysfs_addrm_finish+0x3b/0x70                                                                
 [<ffffffff810bb080>] lock_acquire+0xa0/0x130                                                                       
 [<ffffffff8121062b>] ? sysfs_addrm_finish+0x3b/0x70                                                                
 [<ffffffff810b64e7>] ? lockdep_init_map+0x57/0x170                                                                 
 [<ffffffff8120fed7>] sysfs_deactivate+0x157/0x1c0                                                                  
 [<ffffffff8121062b>] ? sysfs_addrm_finish+0x3b/0x70                                                                
 [<ffffffff8121062b>] sysfs_addrm_finish+0x3b/0x70                                                                  
 [<ffffffff8120e280>] sysfs_hash_and_remove+0x60/0xb0                                                               
 [<ffffffff8120f2a9>] sysfs_remove_file+0x39/0x50                                                                   
 [<ffffffff813a28f7>] device_remove_file+0x17/0x20                                                                  
 [<ffffffff8131a271>] acpi_device_remove_files+0xa9/0x14b                                                           
 [<ffffffff8131a377>] acpi_device_unregister+0x64/0xa6                                                              
 [<ffffffff8131a3e4>] acpi_bus_remove+0x2b/0x2f                                                                     
 [<ffffffff8131a91b>] acpi_bus_trim+0x73/0x7a                                                                       
 [<ffffffff8131b4a5>] acpi_scan_hot_remove+0x160/0x281                                                              
 [<ffffffff8131b6c6>] ? acpi_bus_hot_remove_device+0x2a/0x69                                                        
 [<ffffffff8131b6ce>] acpi_bus_hot_remove_device+0x32/0x69                                                          
 [<ffffffff81315dac>] acpi_os_execute_deferred+0x27/0x34                                                            
 [<ffffffff8106bec8>] process_one_work+0x1e8/0x560                                                                  
 [<ffffffff8106be53>] ? process_one_work+0x173/0x560                                                                
 [<ffffffff8106d0a0>] worker_thread+0x120/0x3a0                                                                     
 [<ffffffff8106cf80>] ? manage_workers+0x170/0x170                                                                  
 [<ffffffff81073b5e>] kthread+0xee/0x100                                                                            
 [<ffffffff810bb59c>] ? __lock_release+0x9c/0x200                                                                   
 [<ffffffff81073a70>] ? __init_kthread_worker+0x70/0x70                                                             
 [<ffffffff815a5fdc>] ret_from_fork+0x7c/0xb0                                                                       
 [<ffffffff81073a70>] ? __init_kthread_worker+0x70/0x70                                                             

> 
> I'll address the ACPI part differently later.
> 
>> ---
>>  drivers/acpi/scan.c |    3 ++-
>>  drivers/base/core.c |   36 ++++++++++++++++++++----------------
>>  2 files changed, 22 insertions(+), 17 deletions(-)
>>
>> Index: linux-pm/drivers/base/core.c
>> ===================================================================
>> --- linux-pm.orig/drivers/base/core.c
>> +++ linux-pm/drivers/base/core.c
>> @@ -49,6 +49,18 @@ static struct kobject *dev_kobj;
>>  struct kobject *sysfs_dev_char_kobj;
>>  struct kobject *sysfs_dev_block_kobj;
>>  
>> +static DEFINE_MUTEX(device_hotplug_lock);
>> +
>> +void lock_device_hotplug(void)
>> +{
>> +	mutex_lock(&device_hotplug_lock);
>> +}
>> +
>> +void unlock_device_hotplug(void)
>> +{
>> +	mutex_unlock(&device_hotplug_lock);
>> +}
>> +
>>  #ifdef CONFIG_BLOCK
>>  static inline int device_is_not_partition(struct device *dev)
>>  {
>> @@ -408,9 +420,11 @@ static ssize_t show_online(struct device
>>  {
>>  	bool val;
>>  
>> -	lock_device_hotplug();
>> +	if (!mutex_trylock(&device_hotplug_lock))
>> +		return -EAGAIN;
>> +
>>  	val = !dev->offline;
>> -	unlock_device_hotplug();
>> +	mutex_unlock(&device_hotplug_lock);
>>  	return sprintf(buf, "%u\n", val);
>>  }
>>  
>> @@ -424,9 +438,11 @@ static ssize_t store_online(struct devic
>>  	if (ret < 0)
>>  		return ret;
>>  
>> -	lock_device_hotplug();
>> +	if (!mutex_trylock(&device_hotplug_lock))
>> +		return -EAGAIN;
>> +
>>  	ret = val ? device_online(dev) : device_offline(dev);
>> -	unlock_device_hotplug();
>> +	mutex_unlock(&device_hotplug_lock);
>>  	return ret < 0 ? ret : count;
>>  }
>>  
>> @@ -1479,18 +1495,6 @@ EXPORT_SYMBOL_GPL(put_device);
>>  EXPORT_SYMBOL_GPL(device_create_file);
>>  EXPORT_SYMBOL_GPL(device_remove_file);
>>  
>> -static DEFINE_MUTEX(device_hotplug_lock);
>> -
>> -void lock_device_hotplug(void)
>> -{
>> -	mutex_lock(&device_hotplug_lock);
>> -}
>> -
>> -void unlock_device_hotplug(void)
>> -{
>> -	mutex_unlock(&device_hotplug_lock);
>> -}
>> -
>>  static int device_check_offline(struct device *dev, void *not_used)
>>  {
>>  	int ret;
>> Index: linux-pm/drivers/acpi/scan.c
>> ===================================================================
>> --- linux-pm.orig/drivers/acpi/scan.c
>> +++ linux-pm/drivers/acpi/scan.c
>> @@ -510,7 +510,8 @@ acpi_eject_store(struct device *d, struc
>>  	if (ACPI_FAILURE(status) || !acpi_device->flags.ejectable)
>>  		return -ENODEV;
>>  
>> -	mutex_lock(&acpi_scan_lock);
>> +	if (!mutex_trylock(&acpi_scan_lock))
>> +		return -EAGAIN;
>>  
>>  	if (acpi_device->flags.eject_pending) {
>>  		/* ACPI eject notification event. */
> 
> Thanks,
> Rafael
> 
> 
> ---
>  drivers/base/core.c |   45 +++++++++++++++++++++++++++++++--------------
>  1 file changed, 31 insertions(+), 14 deletions(-)
> 
> Index: linux-pm/drivers/base/core.c
> ===================================================================
> --- linux-pm.orig/drivers/base/core.c
> +++ linux-pm/drivers/base/core.c
> @@ -49,6 +49,28 @@ static struct kobject *dev_kobj;
>  struct kobject *sysfs_dev_char_kobj;
>  struct kobject *sysfs_dev_block_kobj;
>  
> +static DEFINE_MUTEX(device_hotplug_lock);
> +
> +void lock_device_hotplug(void)
> +{
> +	mutex_lock(&device_hotplug_lock);
> +}
> +
> +void unlock_device_hotplug(void)
> +{
> +	mutex_unlock(&device_hotplug_lock);
> +}
> +
> +static int try_to_lock_device_hotplug(void)
> +{
> +	if (!mutex_trylock(&device_hotplug_lock)) {
> +		/* Avoid busy waiting, 10 ms of sleep should do. */
> +		msleep(10);
> +		return restart_syscall();
> +	}
> +	return 0;
> +}
> +
>  #ifdef CONFIG_BLOCK
>  static inline int device_is_not_partition(struct device *dev)
>  {
> @@ -407,8 +429,12 @@ static ssize_t show_online(struct device
>  			   char *buf)
>  {
>  	bool val;
> +	int ret;
> +
> +	ret = try_to_lock_device_hotplug();
> +	if (ret)
> +		return ret;
>  
> -	lock_device_hotplug();
>  	val = !dev->offline;
>  	unlock_device_hotplug();
>  	return sprintf(buf, "%u\n", val);
> @@ -424,7 +450,10 @@ static ssize_t store_online(struct devic
>  	if (ret < 0)
>  		return ret;
>  
> -	lock_device_hotplug();
> +	ret = try_to_lock_device_hotplug();
> +	if (ret)
> +		return ret;
> +
>  	ret = val ? device_online(dev) : device_offline(dev);
>  	unlock_device_hotplug();
>  	return ret < 0 ? ret : count;
> @@ -1479,18 +1508,6 @@ EXPORT_SYMBOL_GPL(put_device);
>  EXPORT_SYMBOL_GPL(device_create_file);
>  EXPORT_SYMBOL_GPL(device_remove_file);
>  
> -static DEFINE_MUTEX(device_hotplug_lock);
> -
> -void lock_device_hotplug(void)
> -{
> -	mutex_lock(&device_hotplug_lock);
> -}
> -
> -void unlock_device_hotplug(void)
> -{
> -	mutex_unlock(&device_hotplug_lock);
> -}
> -
>  static int device_check_offline(struct device *dev, void *not_used)
>  {
>  	int ret;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


