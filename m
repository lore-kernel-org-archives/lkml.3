Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3HZOcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:32:48 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35002 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab3HZOcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:32:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH] driver core / ACPI: Avoid device removal locking problems
Date: Mon, 26 Aug 2013 16:43:26 +0200
Message-ID: <3389643.Fdir3g6c6B@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <4785337.sqQqDSPcpL@vostro.rjw.lan>
References: <1543475.L7gSB7lLAu@vostro.rjw.lan> <521AC7C9.2000408@cn.fujitsu.com> <4785337.sqQqDSPcpL@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 26, 2013 02:42:09 PM Rafael J. Wysocki wrote:
> On Monday, August 26, 2013 11:13:13 AM Gu Zheng wrote:
> > Hi Rafael,
> 
> Hi,
> 
> > On 08/26/2013 04:09 AM, Rafael J. Wysocki wrote:
> > 
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > There are two mutexes, device_hotplug_lock and acpi_scan_lock, held
> > > around the acpi_bus_trim() call in acpi_scan_hot_remove() which
> > > generally removes devices (it removes ACPI device objects at least,
> > > but it may also remove "physical" device objects through .detach()
> > > callbacks of ACPI scan handlers).  Thus, potentially, device sysfs
> > > attributes are removed under these locks and to remove those
> > > attributes it is necessary to hold the s_active references of their
> > > directory entries for writing.
> > > 
> > > On the other hand, the execution of a .show() or .store() callback
> > > from a sysfs attribute is carried out with that attribute's s_active
> > > reference held for reading.  Consequently, if any device sysfs
> > > attribute that may be removed from within acpi_scan_hot_remove()
> > > through acpi_bus_trim() has a .store() or .show() callback which
> > > acquires either acpi_scan_lock or device_hotplug_lock, the execution
> > > of that callback may deadlock with the removal of the attribute.
> > > [Unfortunately, the "online" device attribute of CPUs and memory
> > > blocks and the "eject" attribute of ACPI device objects are affected
> > > by this issue.]
> > > 
> > > To avoid those deadlocks introduce a new protection mechanism that
> > > can be used by the device sysfs attributes in question.  Namely,
> > > if a device sysfs attribute's .store() or .show() callback routine
> > > is about to acquire device_hotplug_lock or acpi_scan_lock, it can
> > > first execute read_lock_device_remove() and return an error code if
> > > that function returns false.  If true is returned, the lock in
> > > question may be acquired and read_unlock_device_remove() must be
> > > called.  [This mechanism is implemented by means of an additional
> > > rwsem in drivers/base/core.c.]
> > > 
> > > Make the affected sysfs attributes in the driver core and ACPI core
> > > use read_lock_device_remove() and read_unlock_device_remove() as
> > > described above.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > Reported-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> > 
> > I'm sorry to forget to mention that the original reporter is
> > Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>. I continued
> > the investigation and found more issues.
> > 
> > We tested this patch on kernel 3.11-rc6, but it seems that the
> > issue is still there. Detail info as following.
> 
> Well, taking pm_mutex under acpi_scan_lock (trace #2) is a bad idea anyway,
> because we'll need to take acpi_scan_lock during system suspend for PCI hot
> remove to work and that's under pm_mutex.  So I wonder if we can simply
> drop the system sleep locking from lock/unlock_memory_hotplug().  But that's
> a side note, because dropping it won't help here.
> 
> Now ->
> 
> > ======================================================                                                                                                                           
> > [ INFO: possible circular locking dependency detected ]                                                                                                                          
> > 3.11.0-rc6-lockdebug-refea+ #162 Tainted: GF                                                                                                                                     
> > -------------------------------------------------------                                                                                                                          
> > kworker/0:2/754 is trying to acquire lock:                                                                                                                                       
> >  (s_active#73){++++.+}, at: [<ffffffff8121062b>] sysfs_addrm_finish+0x3b/0x70                                                                                                    
> >                                                                                                                                                                                  
> > but task is already holding lock:                                                                                                                                                
> >  (mem_sysfs_mutex){+.+.+.}, at: [<ffffffff813b949d>] remove_memory_block+0x1d/0xa0                                                                                               
> >                                                                                                                                                                                  
> > which lock already depends on the new lock.                                                                                                                                      
> >                                                                                                                                                                                  
> >                                                                                                                                                                                  
> > the existing dependency chain (in reverse order) is:                                                                                                                             
> >                                                                                                                                                                                  
> > -> #4 (mem_sysfs_mutex){+.+.+.}:                                                                                                                                                 
> >        [<ffffffff810ba88c>] validate_chain+0x70c/0x870                                                                                                                           
> >        [<ffffffff810bad5f>] __lock_acquire+0x36f/0x5f0                                                                                                                           
> >        [<ffffffff810bb080>] lock_acquire+0xa0/0x130                                                                                                                              
> >        [<ffffffff8159781b>] mutex_lock_nested+0x7b/0x3b0                                                                                                                         
> >        [<ffffffff813b9361>] add_memory_section+0x51/0x150                                                                                                                        
> >        [<ffffffff813b947b>] register_new_memory+0x1b/0x20                                                                                                                        
> >        [<ffffffff81590d21>] __add_pages+0x111/0x120                                                                                                                              
> >        [<ffffffff81041224>] arch_add_memory+0x64/0xf0                                                                                                                            
> >        [<ffffffff81590e07>] add_memory+0xd7/0x1e0                                                                                                                                
> >        [<ffffffff81347db4>] acpi_memory_enable_device+0x77/0x12b                                                                                                                 
> >        [<ffffffff8134801e>] acpi_memory_device_add+0x18f/0x198                                                                                                                   
> >        [<ffffffff8131aa5a>] acpi_bus_device_attach+0x9a/0x100                                                                                                                    
> >        [<ffffffff8133666d>] acpi_ns_walk_namespace+0xbe/0x17d                                                                                                                    
> >        [<ffffffff81336b03>] acpi_walk_namespace+0x8a/0xc4                                                                                                                        
> >        [<ffffffff8131c126>] acpi_bus_scan+0x91/0x9c                                                                                                                              
> >        [<ffffffff8131c1af>] acpi_scan_bus_device_check+0x7e/0x10f                                                                                                                
> >        [<ffffffff8131c253>] acpi_scan_device_check+0x13/0x15                                                                                                                     
> >        [<ffffffff81315dac>] acpi_os_execute_deferred+0x27/0x34                                                                                                                   
> >        [<ffffffff8106bec8>] process_one_work+0x1e8/0x560                                                                                                                         
> >        [<ffffffff8106d0a0>] worker_thread+0x120/0x3a0                                                                                                                            
> >        [<ffffffff81073b5e>] kthread+0xee/0x100                                                                                                                                   
> >        [<ffffffff815a605c>] ret_from_fork+0x7c/0xb0                                                                                                                              
> >                                                                                                                                                                                  
> > -> #3 (pm_mutex){+.+.+.}:                                                                                                                                                        
> >        [<ffffffff810ba88c>] validate_chain+0x70c/0x870                                                                                                                           
> >        [<ffffffff810bad5f>] __lock_acquire+0x36f/0x5f0                                                                                                                           
> >        [<ffffffff810bb080>] lock_acquire+0xa0/0x130                                                                                                                              
> >        [<ffffffff8159781b>] mutex_lock_nested+0x7b/0x3b0                                                                                                                         
> >        [<ffffffff81188795>] lock_memory_hotplug+0x35/0x40                                                                                                                        
> >        [<ffffffff81590d5f>] add_memory+0x2f/0x1e0                                                                                                                                
> >        [<ffffffff81347db4>] acpi_memory_enable_device+0x77/0x12b                                                                                                                 
> >        [<ffffffff8134801e>] acpi_memory_device_add+0x18f/0x198                                                                                                                   
> >        [<ffffffff8131aa5a>] acpi_bus_device_attach+0x9a/0x100                                                                                                                    
> >        [<ffffffff8133666d>] acpi_ns_walk_namespace+0xbe/0x17d                                                                                                                    
> >        [<ffffffff81336b03>] acpi_walk_namespace+0x8a/0xc4                                                                                                                        
> >        [<ffffffff8131c126>] acpi_bus_scan+0x91/0x9c                                                                                                                              
> >        [<ffffffff81d39862>] acpi_scan_init+0x66/0x15a                                                                                                                            
> >        [<ffffffff81d397a0>] acpi_init+0xa1/0xbb                                                                                                                                  
> >        [<ffffffff810002c2>] do_one_initcall+0xf2/0x1a0                                                                                                                           
> >        [<ffffffff81d018da>] do_basic_setup+0x9d/0xbb                                                                                                                             
> >        [<ffffffff81d01b02>] kernel_init_freeable+0x20a/0x28a                                                                                                                     
> >        [<ffffffff8158f20e>] kernel_init+0xe/0xf0                                                                                                                                 
> >        [<ffffffff815a605c>] ret_from_fork+0x7c/0xb0                                                                                                                              
> >                                                                                                                                                                                  
> > -> #2 (mem_hotplug_mutex){+.+.+.}:                                                                                                                                               
> >        [<ffffffff810ba88c>] validate_chain+0x70c/0x870                                                                                                                           
> >        [<ffffffff810bad5f>] __lock_acquire+0x36f/0x5f0                                                                                                                           
> >        [<ffffffff810bb080>] lock_acquire+0xa0/0x130                                                                                                                              
> >        [<ffffffff8159781b>] mutex_lock_nested+0x7b/0x3b0                                                                                                                         
> >        [<ffffffff81188777>] lock_memory_hotplug+0x17/0x40                                                                                                                        
> >        [<ffffffff81590d5f>] add_memory+0x2f/0x1e0                                                                                                                                
> >        [<ffffffff81347db4>] acpi_memory_enable_device+0x77/0x12b                                                                                                                 
> >        [<ffffffff8134801e>] acpi_memory_device_add+0x18f/0x198                                                                                                                   
> >        [<ffffffff8131aa5a>] acpi_bus_device_attach+0x9a/0x100                                                                                                                    
> >        [<ffffffff8133666d>] acpi_ns_walk_namespace+0xbe/0x17d                                                                                                                    
> >        [<ffffffff81336b03>] acpi_walk_namespace+0x8a/0xc4                                                                                                                        
> >        [<ffffffff8131c126>] acpi_bus_scan+0x91/0x9c                                                                                                                              
> >        [<ffffffff8131c1af>] acpi_scan_bus_device_check+0x7e/0x10f                                                                                                                
> >        [<ffffffff8131c253>] acpi_scan_device_check+0x13/0x15                                                                                                                     
> >        [<ffffffff81315dac>] acpi_os_execute_deferred+0x27/0x34                                                                                                                   
> >        [<ffffffff8106bec8>] process_one_work+0x1e8/0x560                                                                                                                         
> >        [<ffffffff8106d0a0>] worker_thread+0x120/0x3a0                                                                                                                            
> >        [<ffffffff81073b5e>] kthread+0xee/0x100                                                                                                                                   
> >        [<ffffffff815a605c>] ret_from_fork+0x7c/0xb0                                                                                                                              
> >                                                                                                                                                                                  
> > -> #1 (device_hotplug_lock){+.+.+.}:                                                                                                                                             
> >        [<ffffffff810ba88c>] validate_chain+0x70c/0x870                                                                                                                           
> >        [<ffffffff810bad5f>] __lock_acquire+0x36f/0x5f0                                                                                                                           
> >        [<ffffffff810bb080>] lock_acquire+0xa0/0x130                                                                                                                              
> >        [<ffffffff8159781b>] mutex_lock_nested+0x7b/0x3b0                                                                                                                         
> >        [<ffffffff813a16e7>] lock_device_hotplug+0x17/0x20
> 
> -> we should have grabbed device_remove_rwsem for reading here with the patch
> applied, which means that -->
> 
> >        [<ffffffff813a2553>] show_online+0x33/0x80                                                                                                                                
> >        [<ffffffff813a1ce7>] dev_attr_show+0x27/0x50                                                                                                                              
> >        [<ffffffff8120ee94>] fill_read_buffer+0x74/0x100                                                                                                                          
> >        [<ffffffff8120efcc>] sysfs_read_file+0xac/0xe0                                                                                                                            
> >        [<ffffffff81195d21>] vfs_read+0xb1/0x130                                                                                                                                  
> >        [<ffffffff81196232>] SyS_read+0x62/0xb0                                                                                                                                   
> >        [<ffffffff815a6102>] system_call_fastpath+0x16/0x1b                                                                                                                       
> >                                                                                                                                                                                  
> > -> #0 (s_active#73){++++.+}:                                                                                                                                                     
> >        [<ffffffff810ba148>] check_prev_add+0x598/0x5d0                                                                                                                           
> >        [<ffffffff810ba88c>] validate_chain+0x70c/0x870                                                                                                                           
> >        [<ffffffff810bad5f>] __lock_acquire+0x36f/0x5f0                                                                                                                           
> >        [<ffffffff810bb080>] lock_acquire+0xa0/0x130                                                                                                                              
> >        [<ffffffff8120fed7>] sysfs_deactivate+0x157/0x1c0                                                                                                                         
> >        [<ffffffff8121062b>] sysfs_addrm_finish+0x3b/0x70                                                                                                                         
> >        [<ffffffff8120e280>] sysfs_hash_and_remove+0x60/0xb0                                                                                                                      
> >        [<ffffffff8120f2a9>] sysfs_remove_file+0x39/0x50                                                                                                                          
> >        [<ffffffff813a2977>] device_remove_file+0x17/0x20                                                                                                                         
> >        [<ffffffff813a29aa>] device_remove_attrs+0x2a/0xe0                                                                                                                        
> >        [<ffffffff813a2b8b>] device_del+0x12b/0x1f0                                                                                                                               
> >        [<ffffffff813a2c72>] device_unregister+0x22/0x60                                                                                                                          
> >        [<ffffffff813b94ed>] remove_memory_block+0x6d/0xa0                                                                                                                        
> >        [<ffffffff813b953f>] unregister_memory_section+0x1f/0x30                                                                                                                  
> >        [<ffffffff81189468>] __remove_pages+0xc8/0x150                                                                                                                            
> >        [<ffffffff8158f994>] arch_remove_memory+0x94/0xd0                                                                                                                         
> >        [<ffffffff81590bef>] remove_memory+0x6f/0x90                                                                                                                              
> >        [<ffffffff81347ccc>] acpi_memory_remove_memory+0x7e/0xa3                                                                                                                  
> >        [<ffffffff81347d18>] acpi_memory_device_remove+0x27/0x33                                                                                                                  
> >        [<ffffffff8131a8a2>] acpi_bus_device_detach+0x3d/0x5e                                                                                                                     
> >        [<ffffffff81336685>] acpi_ns_walk_namespace+0xd6/0x17d                                                                                                                    
> >        [<ffffffff81336b03>] acpi_walk_namespace+0x8a/0xc4                                                                                                                        
> >        [<ffffffff8131a8f6>] acpi_bus_trim+0x33/0x7a                                                                                                                              
> >        [<ffffffff8131b4c0>] acpi_scan_hot_remove+0x160/0x281                                                                                                                     
> 
> --> device_hotplug_lock is already held by show_online() at this point (or if
> it is not held, that function will return -EBUSY after attempting to grab
> device_remove_rwsem for reading), so acpi_scan_hot_remove() will wait for it
> to be released before calling acpi_bus_trim().
> 
> So the situation in which one thread holds s_active for reading and blocks on
> device_hotplug_lock while another thread is holding it over device removal is
> clearly impossible to me.
> 
> So I'm not sure how device_hotplug_lock is still involved?

Well, it is not involved, but lockdep doesn't see that anyway.  Bummer.

> >        [<ffffffff8131b6fc>] acpi_bus_hot_remove_device+0x37/0x73                                                                                                                 
> >        [<ffffffff81315dac>] acpi_os_execute_deferred+0x27/0x34                                                                                                                   
> >        [<ffffffff8106bec8>] process_one_work+0x1e8/0x560                                                                                                                         
> >        [<ffffffff8106d0a0>] worker_thread+0x120/0x3a0                                                                                                                            
> >        [<ffffffff81073b5e>] kthread+0xee/0x100                                                                                                                                   
> >        [<ffffffff815a605c>] ret_from_fork+0x7c/0xb0                                                                                                                              
> >                                                                                                                                                                                  
> > other info that might help us debug this:                                                                                                                                        
> >                                                                                                                                                                                  
> > Chain exists of:                                                                                                                                                                 
> >   s_active#73 --> pm_mutex --> mem_sysfs_mutex                                                                                                                                   
> >                                                                                                                                                                                  
> >  Possible unsafe locking scenario:                                                                                                                                               
> >                                                                                                                                                                                  
> >        CPU0                    CPU1                                                                                                                                              
> >        ----                    ----                                                                                                                                              
> >   lock(mem_sysfs_mutex);                                                                                                                                                         
> >                                lock(pm_mutex);                                                                                                                                   
> >                                lock(mem_sysfs_mutex);                                                                                                                            
> >   lock(s_active#73);                                                                                                                                                             
> >                                                                                                                                                                                  
> >  *** DEADLOCK ***                                                                                                                                                                

OK, so the patch below is quick and dirty and overkill, but it should make the
splat go away at least.

Thanks,
Rafael


---
 drivers/acpi/scan.c |    3 ++-
 drivers/base/core.c |   36 ++++++++++++++++++++----------------
 2 files changed, 22 insertions(+), 17 deletions(-)

Index: linux-pm/drivers/base/core.c
===================================================================
--- linux-pm.orig/drivers/base/core.c
+++ linux-pm/drivers/base/core.c
@@ -49,6 +49,18 @@ static struct kobject *dev_kobj;
 struct kobject *sysfs_dev_char_kobj;
 struct kobject *sysfs_dev_block_kobj;
 
+static DEFINE_MUTEX(device_hotplug_lock);
+
+void lock_device_hotplug(void)
+{
+	mutex_lock(&device_hotplug_lock);
+}
+
+void unlock_device_hotplug(void)
+{
+	mutex_unlock(&device_hotplug_lock);
+}
+
 #ifdef CONFIG_BLOCK
 static inline int device_is_not_partition(struct device *dev)
 {
@@ -408,9 +420,11 @@ static ssize_t show_online(struct device
 {
 	bool val;
 
-	lock_device_hotplug();
+	if (!mutex_trylock(&device_hotplug_lock))
+		return -EAGAIN;
+
 	val = !dev->offline;
-	unlock_device_hotplug();
+	mutex_unlock(&device_hotplug_lock);
 	return sprintf(buf, "%u\n", val);
 }
 
@@ -424,9 +438,11 @@ static ssize_t store_online(struct devic
 	if (ret < 0)
 		return ret;
 
-	lock_device_hotplug();
+	if (!mutex_trylock(&device_hotplug_lock))
+		return -EAGAIN;
+
 	ret = val ? device_online(dev) : device_offline(dev);
-	unlock_device_hotplug();
+	mutex_unlock(&device_hotplug_lock);
 	return ret < 0 ? ret : count;
 }
 
@@ -1479,18 +1495,6 @@ EXPORT_SYMBOL_GPL(put_device);
 EXPORT_SYMBOL_GPL(device_create_file);
 EXPORT_SYMBOL_GPL(device_remove_file);
 
-static DEFINE_MUTEX(device_hotplug_lock);
-
-void lock_device_hotplug(void)
-{
-	mutex_lock(&device_hotplug_lock);
-}
-
-void unlock_device_hotplug(void)
-{
-	mutex_unlock(&device_hotplug_lock);
-}
-
 static int device_check_offline(struct device *dev, void *not_used)
 {
 	int ret;
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -510,7 +510,8 @@ acpi_eject_store(struct device *d, struc
 	if (ACPI_FAILURE(status) || !acpi_device->flags.ejectable)
 		return -ENODEV;
 
-	mutex_lock(&acpi_scan_lock);
+	if (!mutex_trylock(&acpi_scan_lock))
+		return -EAGAIN;
 
 	if (acpi_device->flags.eject_pending) {
 		/* ACPI eject notification event. */

