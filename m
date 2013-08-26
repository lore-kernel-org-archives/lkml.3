Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3HZDRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 23:17:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:29192 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754710Ab3HZDRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 23:17:33 -0400
X-IronPort-AV: E=Sophos;i="4.89,955,1367942400"; 
   d="scan'208";a="8301033"
Message-ID: <521AC7C9.2000408@cn.fujitsu.com>
Date: Mon, 26 Aug 2013 11:13:13 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH] driver core / ACPI: Avoid device removal locking problems
References: <1543475.L7gSB7lLAu@vostro.rjw.lan>
In-Reply-To: <1543475.L7gSB7lLAu@vostro.rjw.lan>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/26 11:15:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/26 11:15:37,
	Serialize complete at 2013/08/26 11:15:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 08/26/2013 04:09 AM, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> There are two mutexes, device_hotplug_lock and acpi_scan_lock, held
> around the acpi_bus_trim() call in acpi_scan_hot_remove() which
> generally removes devices (it removes ACPI device objects at least,
> but it may also remove "physical" device objects through .detach()
> callbacks of ACPI scan handlers).  Thus, potentially, device sysfs
> attributes are removed under these locks and to remove those
> attributes it is necessary to hold the s_active references of their
> directory entries for writing.
> 
> On the other hand, the execution of a .show() or .store() callback
> from a sysfs attribute is carried out with that attribute's s_active
> reference held for reading.  Consequently, if any device sysfs
> attribute that may be removed from within acpi_scan_hot_remove()
> through acpi_bus_trim() has a .store() or .show() callback which
> acquires either acpi_scan_lock or device_hotplug_lock, the execution
> of that callback may deadlock with the removal of the attribute.
> [Unfortunately, the "online" device attribute of CPUs and memory
> blocks and the "eject" attribute of ACPI device objects are affected
> by this issue.]
> 
> To avoid those deadlocks introduce a new protection mechanism that
> can be used by the device sysfs attributes in question.  Namely,
> if a device sysfs attribute's .store() or .show() callback routine
> is about to acquire device_hotplug_lock or acpi_scan_lock, it can
> first execute read_lock_device_remove() and return an error code if
> that function returns false.  If true is returned, the lock in
> question may be acquired and read_unlock_device_remove() must be
> called.  [This mechanism is implemented by means of an additional
> rwsem in drivers/base/core.c.]
> 
> Make the affected sysfs attributes in the driver core and ACPI core
> use read_lock_device_remove() and read_unlock_device_remove() as
> described above.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reported-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

I'm sorry to forget to mention that the original reporter is
Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>. I continued
the investigation and found more issues.

We tested this patch on kernel 3.11-rc6, but it seems that the
issue is still there. Detail info as following.

Thanks,
Gu

======================================================                                                                                                                           
[ INFO: possible circular locking dependency detected ]                                                                                                                          
3.11.0-rc6-lockdebug-refea+ #162 Tainted: GF                                                                                                                                     
-------------------------------------------------------                                                                                                                          
kworker/0:2/754 is trying to acquire lock:                                                                                                                                       
 (s_active#73){++++.+}, at: [<ffffffff8121062b>] sysfs_addrm_finish+0x3b/0x70                                                                                                    
                                                                                                                                                                                 
but task is already holding lock:                                                                                                                                                
 (mem_sysfs_mutex){+.+.+.}, at: [<ffffffff813b949d>] remove_memory_block+0x1d/0xa0                                                                                               
                                                                                                                                                                                 
which lock already depends on the new lock.                                                                                                                                      
                                                                                                                                                                                 
                                                                                                                                                                                 
the existing dependency chain (in reverse order) is:                                                                                                                             
                                                                                                                                                                                 
-> #4 (mem_sysfs_mutex){+.+.+.}:                                                                                                                                                 
       [<ffffffff810ba88c>] validate_chain+0x70c/0x870                                                                                                                           
       [<ffffffff810bad5f>] __lock_acquire+0x36f/0x5f0                                                                                                                           
       [<ffffffff810bb080>] lock_acquire+0xa0/0x130                                                                                                                              
       [<ffffffff8159781b>] mutex_lock_nested+0x7b/0x3b0                                                                                                                         
       [<ffffffff813b9361>] add_memory_section+0x51/0x150                                                                                                                        
       [<ffffffff813b947b>] register_new_memory+0x1b/0x20                                                                                                                        
       [<ffffffff81590d21>] __add_pages+0x111/0x120                                                                                                                              
       [<ffffffff81041224>] arch_add_memory+0x64/0xf0                                                                                                                            
       [<ffffffff81590e07>] add_memory+0xd7/0x1e0                                                                                                                                
       [<ffffffff81347db4>] acpi_memory_enable_device+0x77/0x12b                                                                                                                 
       [<ffffffff8134801e>] acpi_memory_device_add+0x18f/0x198                                                                                                                   
       [<ffffffff8131aa5a>] acpi_bus_device_attach+0x9a/0x100                                                                                                                    
       [<ffffffff8133666d>] acpi_ns_walk_namespace+0xbe/0x17d                                                                                                                    
       [<ffffffff81336b03>] acpi_walk_namespace+0x8a/0xc4                                                                                                                        
       [<ffffffff8131c126>] acpi_bus_scan+0x91/0x9c                                                                                                                              
       [<ffffffff8131c1af>] acpi_scan_bus_device_check+0x7e/0x10f                                                                                                                
       [<ffffffff8131c253>] acpi_scan_device_check+0x13/0x15                                                                                                                     
       [<ffffffff81315dac>] acpi_os_execute_deferred+0x27/0x34                                                                                                                   
       [<ffffffff8106bec8>] process_one_work+0x1e8/0x560                                                                                                                         
       [<ffffffff8106d0a0>] worker_thread+0x120/0x3a0                                                                                                                            
       [<ffffffff81073b5e>] kthread+0xee/0x100                                                                                                                                   
       [<ffffffff815a605c>] ret_from_fork+0x7c/0xb0                                                                                                                              
                                                                                                                                                                                 
-> #3 (pm_mutex){+.+.+.}:                                                                                                                                                        
       [<ffffffff810ba88c>] validate_chain+0x70c/0x870                                                                                                                           
       [<ffffffff810bad5f>] __lock_acquire+0x36f/0x5f0                                                                                                                           
       [<ffffffff810bb080>] lock_acquire+0xa0/0x130                                                                                                                              
       [<ffffffff8159781b>] mutex_lock_nested+0x7b/0x3b0                                                                                                                         
       [<ffffffff81188795>] lock_memory_hotplug+0x35/0x40                                                                                                                        
       [<ffffffff81590d5f>] add_memory+0x2f/0x1e0                                                                                                                                
       [<ffffffff81347db4>] acpi_memory_enable_device+0x77/0x12b                                                                                                                 
       [<ffffffff8134801e>] acpi_memory_device_add+0x18f/0x198                                                                                                                   
       [<ffffffff8131aa5a>] acpi_bus_device_attach+0x9a/0x100                                                                                                                    
       [<ffffffff8133666d>] acpi_ns_walk_namespace+0xbe/0x17d                                                                                                                    
       [<ffffffff81336b03>] acpi_walk_namespace+0x8a/0xc4                                                                                                                        
       [<ffffffff8131c126>] acpi_bus_scan+0x91/0x9c                                                                                                                              
       [<ffffffff81d39862>] acpi_scan_init+0x66/0x15a                                                                                                                            
       [<ffffffff81d397a0>] acpi_init+0xa1/0xbb                                                                                                                                  
       [<ffffffff810002c2>] do_one_initcall+0xf2/0x1a0                                                                                                                           
       [<ffffffff81d018da>] do_basic_setup+0x9d/0xbb                                                                                                                             
       [<ffffffff81d01b02>] kernel_init_freeable+0x20a/0x28a                                                                                                                     
       [<ffffffff8158f20e>] kernel_init+0xe/0xf0                                                                                                                                 
       [<ffffffff815a605c>] ret_from_fork+0x7c/0xb0                                                                                                                              
                                                                                                                                                                                 
-> #2 (mem_hotplug_mutex){+.+.+.}:                                                                                                                                               
       [<ffffffff810ba88c>] validate_chain+0x70c/0x870                                                                                                                           
       [<ffffffff810bad5f>] __lock_acquire+0x36f/0x5f0                                                                                                                           
       [<ffffffff810bb080>] lock_acquire+0xa0/0x130                                                                                                                              
       [<ffffffff8159781b>] mutex_lock_nested+0x7b/0x3b0                                                                                                                         
       [<ffffffff81188777>] lock_memory_hotplug+0x17/0x40                                                                                                                        
       [<ffffffff81590d5f>] add_memory+0x2f/0x1e0                                                                                                                                
       [<ffffffff81347db4>] acpi_memory_enable_device+0x77/0x12b                                                                                                                 
       [<ffffffff8134801e>] acpi_memory_device_add+0x18f/0x198                                                                                                                   
       [<ffffffff8131aa5a>] acpi_bus_device_attach+0x9a/0x100                                                                                                                    
       [<ffffffff8133666d>] acpi_ns_walk_namespace+0xbe/0x17d                                                                                                                    
       [<ffffffff81336b03>] acpi_walk_namespace+0x8a/0xc4                                                                                                                        
       [<ffffffff8131c126>] acpi_bus_scan+0x91/0x9c                                                                                                                              
       [<ffffffff8131c1af>] acpi_scan_bus_device_check+0x7e/0x10f                                                                                                                
       [<ffffffff8131c253>] acpi_scan_device_check+0x13/0x15                                                                                                                     
       [<ffffffff81315dac>] acpi_os_execute_deferred+0x27/0x34                                                                                                                   
       [<ffffffff8106bec8>] process_one_work+0x1e8/0x560                                                                                                                         
       [<ffffffff8106d0a0>] worker_thread+0x120/0x3a0                                                                                                                            
       [<ffffffff81073b5e>] kthread+0xee/0x100                                                                                                                                   
       [<ffffffff815a605c>] ret_from_fork+0x7c/0xb0                                                                                                                              
                                                                                                                                                                                 
-> #1 (device_hotplug_lock){+.+.+.}:                                                                                                                                             
       [<ffffffff810ba88c>] validate_chain+0x70c/0x870                                                                                                                           
       [<ffffffff810bad5f>] __lock_acquire+0x36f/0x5f0                                                                                                                           
       [<ffffffff810bb080>] lock_acquire+0xa0/0x130                                                                                                                              
       [<ffffffff8159781b>] mutex_lock_nested+0x7b/0x3b0                                                                                                                         
       [<ffffffff813a16e7>] lock_device_hotplug+0x17/0x20                                                                                                                        
       [<ffffffff813a2553>] show_online+0x33/0x80                                                                                                                                
       [<ffffffff813a1ce7>] dev_attr_show+0x27/0x50                                                                                                                              
       [<ffffffff8120ee94>] fill_read_buffer+0x74/0x100                                                                                                                          
       [<ffffffff8120efcc>] sysfs_read_file+0xac/0xe0                                                                                                                            
       [<ffffffff81195d21>] vfs_read+0xb1/0x130                                                                                                                                  
       [<ffffffff81196232>] SyS_read+0x62/0xb0                                                                                                                                   
       [<ffffffff815a6102>] system_call_fastpath+0x16/0x1b                                                                                                                       
                                                                                                                                                                                 
-> #0 (s_active#73){++++.+}:                                                                                                                                                     
       [<ffffffff810ba148>] check_prev_add+0x598/0x5d0                                                                                                                           
       [<ffffffff810ba88c>] validate_chain+0x70c/0x870                                                                                                                           
       [<ffffffff810bad5f>] __lock_acquire+0x36f/0x5f0                                                                                                                           
       [<ffffffff810bb080>] lock_acquire+0xa0/0x130                                                                                                                              
       [<ffffffff8120fed7>] sysfs_deactivate+0x157/0x1c0                                                                                                                         
       [<ffffffff8121062b>] sysfs_addrm_finish+0x3b/0x70                                                                                                                         
       [<ffffffff8120e280>] sysfs_hash_and_remove+0x60/0xb0                                                                                                                      
       [<ffffffff8120f2a9>] sysfs_remove_file+0x39/0x50                                                                                                                          
       [<ffffffff813a2977>] device_remove_file+0x17/0x20                                                                                                                         
       [<ffffffff813a29aa>] device_remove_attrs+0x2a/0xe0                                                                                                                        
       [<ffffffff813a2b8b>] device_del+0x12b/0x1f0                                                                                                                               
       [<ffffffff813a2c72>] device_unregister+0x22/0x60                                                                                                                          
       [<ffffffff813b94ed>] remove_memory_block+0x6d/0xa0                                                                                                                        
       [<ffffffff813b953f>] unregister_memory_section+0x1f/0x30                                                                                                                  
       [<ffffffff81189468>] __remove_pages+0xc8/0x150                                                                                                                            
       [<ffffffff8158f994>] arch_remove_memory+0x94/0xd0                                                                                                                         
       [<ffffffff81590bef>] remove_memory+0x6f/0x90                                                                                                                              
       [<ffffffff81347ccc>] acpi_memory_remove_memory+0x7e/0xa3                                                                                                                  
       [<ffffffff81347d18>] acpi_memory_device_remove+0x27/0x33                                                                                                                  
       [<ffffffff8131a8a2>] acpi_bus_device_detach+0x3d/0x5e                                                                                                                     
       [<ffffffff81336685>] acpi_ns_walk_namespace+0xd6/0x17d                                                                                                                    
       [<ffffffff81336b03>] acpi_walk_namespace+0x8a/0xc4                                                                                                                        
       [<ffffffff8131a8f6>] acpi_bus_trim+0x33/0x7a                                                                                                                              
       [<ffffffff8131b4c0>] acpi_scan_hot_remove+0x160/0x281                                                                                                                     
       [<ffffffff8131b6fc>] acpi_bus_hot_remove_device+0x37/0x73                                                                                                                 
       [<ffffffff81315dac>] acpi_os_execute_deferred+0x27/0x34                                                                                                                   
       [<ffffffff8106bec8>] process_one_work+0x1e8/0x560                                                                                                                         
       [<ffffffff8106d0a0>] worker_thread+0x120/0x3a0                                                                                                                            
       [<ffffffff81073b5e>] kthread+0xee/0x100                                                                                                                                   
       [<ffffffff815a605c>] ret_from_fork+0x7c/0xb0                                                                                                                              
                                                                                                                                                                                 
other info that might help us debug this:                                                                                                                                        
                                                                                                                                                                                 
Chain exists of:                                                                                                                                                                 
  s_active#73 --> pm_mutex --> mem_sysfs_mutex                                                                                                                                   
                                                                                                                                                                                 
 Possible unsafe locking scenario:                                                                                                                                               
                                                                                                                                                                                 
       CPU0                    CPU1                                                                                                                                              
       ----                    ----                                                                                                                                              
  lock(mem_sysfs_mutex);                                                                                                                                                         
                               lock(pm_mutex);                                                                                                                                   
                               lock(mem_sysfs_mutex);                                                                                                                            
  lock(s_active#73);                                                                                                                                                             
                                                                                                                                                                                 
 *** DEADLOCK ***                                                                                                                                                                
                                                                                                                                                                                 
8 locks held by kworker/0:2/754:                                                                                                                                                 
 #0:  (kacpi_hotplug){.+.+.+}, at: [<ffffffff8106be53>] process_one_work+0x173/0x560                                                                                             
 #1:  ((&dpc->work)#3){+.+.+.}, at: [<ffffffff8106be53>] process_one_work+0x173/0x560                                                                                            
 #2:  (device_remove_rwsem){+++++.}, at: [<ffffffff813a1c35>] device_remove_begin+0x15/0x20                                                                                      
 #3:  (acpi_scan_lock){+.+.+.}, at: [<ffffffff8131b6f4>] acpi_bus_hot_remove_device+0x2f/0x73                                                                                    
 #4:  (device_hotplug_lock){+.+.+.}, at: [<ffffffff813a16e7>] lock_device_hotplug+0x17/0x20                                                                                      
 #5:  (mem_hotplug_mutex){+.+.+.}, at: [<ffffffff81188777>] lock_memory_hotplug+0x17/0x40                                                                                        
 #6:  (pm_mutex){+.+.+.}, at: [<ffffffff81188795>] lock_memory_hotplug+0x35/0x40                                                                                                 
 #7:  (mem_sysfs_mutex){+.+.+.}, at: [<ffffffff813b949d>] remove_memory_block+0x1d/0xa0                                                                                          
                                                                                                                                                                                 
stack backtrace:                                                                                                                                                                 
CPU: 0 PID: 754 Comm: kworker/0:2 Tainted: GF            3.11.0-rc6-lockdebug-refea+ #162                                                                                        
Hardware name: FUJITSU-SV PRIMEQUEST 1800E/SB, BIOS PRIMEQUEST 1000 Series BIOS Version 89.32 DP Proto 08/16/2012                                                                
Workqueue: kacpi_hotplug acpi_os_execute_deferred                                                                                                                                
 ffff8807b953cb20 ffff8807b90b3558 ffffffff81596d87 0000000000000002                                                                                                             
 0000000000000000 ffff8807b90b35a8 ffffffff810b7ec9 ffff8807b90b35c8                                                                                                             
 ffffffff82104e60 ffff8807b90b35a8 ffff8807b953cae8 ffff8807b953cb20                                                                                                             
Call Trace:                                                                                                                                                                      
 [<ffffffff81596d87>] dump_stack+0x59/0x82                                                                                                                                       
 [<ffffffff810b7ec9>] print_circular_bug+0x109/0x110                                                                                                                             
 [<ffffffff810ba148>] check_prev_add+0x598/0x5d0                                                                                                                                 
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
 [<ffffffff813a2977>] device_remove_file+0x17/0x20                                                                                                                               
 [<ffffffff813a29aa>] device_remove_attrs+0x2a/0xe0                                                                                                                              
 [<ffffffff813a2b8b>] device_del+0x12b/0x1f0                                                                                                                                     
 [<ffffffff813a2c72>] device_unregister+0x22/0x60                                                                                                                                
 [<ffffffff813b94ed>] remove_memory_block+0x6d/0xa0                                                                                                                              
 [<ffffffff813b953f>] unregister_memory_section+0x1f/0x30                                                                                                                        
 [<ffffffff81189468>] __remove_pages+0xc8/0x150                                                                                                                                  
 [<ffffffff8131a865>] ? power_state_show+0x36/0x36                                                                                                                               
 [<ffffffff8158f994>] arch_remove_memory+0x94/0xd0                                                                                                                               
 [<ffffffff81590bef>] remove_memory+0x6f/0x90                                                                                                                                    
 [<ffffffff81347ccc>] acpi_memory_remove_memory+0x7e/0xa3                                                                                                                        
 [<ffffffff81347d18>] acpi_memory_device_remove+0x27/0x33                                                                                                                        
 [<ffffffff8131a8a2>] acpi_bus_device_detach+0x3d/0x5e                                                                                                                           
 [<ffffffff81336685>] acpi_ns_walk_namespace+0xd6/0x17d                                                                                                                          
 [<ffffffff8131a865>] ? power_state_show+0x36/0x36                                                                                                                               
 [<ffffffff81336b03>] acpi_walk_namespace+0x8a/0xc4                                                                                                                              
 [<ffffffff8131a8f6>] acpi_bus_trim+0x33/0x7a                                                                                                                                    
 [<ffffffff8131b4c0>] acpi_scan_hot_remove+0x160/0x281                                                                                                                           
 [<ffffffff8131b6f4>] ? acpi_bus_hot_remove_device+0x2f/0x73                                                                                                                     
 [<ffffffff8131b6fc>] acpi_bus_hot_remove_device+0x37/0x73                                                                                                                       
 [<ffffffff81315dac>] acpi_os_execute_deferred+0x27/0x34                                                                                                                         
 [<ffffffff8106bec8>] process_one_work+0x1e8/0x560                                                                                                                               
 [<ffffffff8106be53>] ? process_one_work+0x173/0x560                                                                                                                             
 [<ffffffff8106d0a0>] worker_thread+0x120/0x3a0                                                                                                                                  
 [<ffffffff8106cf80>] ? manage_workers+0x170/0x170                                                                                                                               
 [<ffffffff81073b5e>] kthread+0xee/0x100                                                                                                                                         
 [<ffffffff810bb59c>] ? __lock_release+0x9c/0x200                                                                                                                                
 [<ffffffff81073a70>] ? __init_kthread_worker+0x70/0x70                                                                                                                          
 [<ffffffff815a605c>] ret_from_fork+0x7c/0xb0                                                                                                                                    
 [<ffffffff81073a70>] ? __init_kthread_worker+0x70/0x70    


> ---
> 
> For 3.12, applies on top of linux-pm.git/linux-next.
> 
> Thanks,
> Rafael
> 
> ---
>  drivers/acpi/scan.c    |    8 ++++++++
>  drivers/base/core.c    |   29 +++++++++++++++++++++++++++++
>  include/linux/device.h |    4 ++++
>  3 files changed, 41 insertions(+)
> 
> Index: linux-pm/drivers/base/core.c
> ===================================================================
> --- linux-pm.orig/drivers/base/core.c
> +++ linux-pm/drivers/base/core.c
> @@ -408,7 +408,11 @@ static ssize_t show_online(struct device
>  {
>  	bool val;
>  
> +	if (!read_lock_device_remove())
> +		return -EBUSY;
> +
>  	lock_device_hotplug();
> +	read_unlock_device_remove();
>  	val = !dev->offline;
>  	unlock_device_hotplug();
>  	return sprintf(buf, "%u\n", val);
> @@ -424,7 +428,11 @@ static ssize_t store_online(struct devic
>  	if (ret < 0)
>  		return ret;
>  
> +	if (!read_lock_device_remove())
> +		return -EBUSY;
> +
>  	lock_device_hotplug();
> +	read_unlock_device_remove();
>  	ret = val ? device_online(dev) : device_offline(dev);
>  	unlock_device_hotplug();
>  	return ret < 0 ? ret : count;
> @@ -1479,8 +1487,29 @@ EXPORT_SYMBOL_GPL(put_device);
>  EXPORT_SYMBOL_GPL(device_create_file);
>  EXPORT_SYMBOL_GPL(device_remove_file);
>  
> +static DECLARE_RWSEM(device_remove_rwsem);
>  static DEFINE_MUTEX(device_hotplug_lock);
>  
> +bool __must_check read_lock_device_remove(void)
> +{
> +	return down_read_trylock(&device_remove_rwsem);
> +}
> +
> +void read_unlock_device_remove(void)
> +{
> +	up_read(&device_remove_rwsem);
> +}
> +
> +void device_remove_begin(void)
> +{
> +	down_write(&device_remove_rwsem);
> +}
> +
> +void device_remove_end(void)
> +{
> +	up_write(&device_remove_rwsem);
> +}
> +
>  void lock_device_hotplug(void)
>  {
>  	mutex_lock(&device_hotplug_lock);
> Index: linux-pm/include/linux/device.h
> ===================================================================
> --- linux-pm.orig/include/linux/device.h
> +++ linux-pm/include/linux/device.h
> @@ -893,6 +893,10 @@ static inline bool device_supports_offli
>  	return dev->bus && dev->bus->offline && dev->bus->online;
>  }
>  
> +extern bool __must_check read_lock_device_remove(void);
> +extern void read_unlock_device_remove(void);
> +extern void device_remove_begin(void);
> +extern void device_remove_end(void);
>  extern void lock_device_hotplug(void);
>  extern void unlock_device_hotplug(void);
>  extern int device_offline(struct device *dev);
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -288,6 +288,7 @@ static void acpi_bus_device_eject(void *
>  	struct acpi_scan_handler *handler;
>  	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
>  
> +	device_remove_begin();
>  	mutex_lock(&acpi_scan_lock);
>  
>  	acpi_bus_get_device(handle, &device);
> @@ -315,6 +316,7 @@ static void acpi_bus_device_eject(void *
>  
>   out:
>  	mutex_unlock(&acpi_scan_lock);
> +	device_remove_end();
>  	return;
>  
>   err_out:
> @@ -449,6 +451,7 @@ void acpi_bus_hot_remove_device(void *co
>  	acpi_handle handle = device->handle;
>  	int error;
>  
> +	device_remove_begin();
>  	mutex_lock(&acpi_scan_lock);
>  
>  	error = acpi_scan_hot_remove(device);
> @@ -458,6 +461,7 @@ void acpi_bus_hot_remove_device(void *co
>  					  NULL);
>  
>  	mutex_unlock(&acpi_scan_lock);
> +	device_remove_end();
>  	kfree(context);
>  }
>  EXPORT_SYMBOL(acpi_bus_hot_remove_device);
> @@ -510,7 +514,11 @@ acpi_eject_store(struct device *d, struc
>  	if (ACPI_FAILURE(status) || !acpi_device->flags.ejectable)
>  		return -ENODEV;
>  
> +	if (!read_lock_device_remove())
> +		return -EBUSY;
> +
>  	mutex_lock(&acpi_scan_lock);
> +	read_unlock_device_remove();
>  
>  	if (acpi_device->flags.eject_pending) {
>  		/* ACPI eject notification event. */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


