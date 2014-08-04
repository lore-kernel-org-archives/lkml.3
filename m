Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaHDInH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 04:43:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:2721 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaHDInE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:43:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,796,1400050800"; 
   d="scan'208";a="583039657"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, lenb@kernel.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI/OSL: Remove RCU in the osl.c to avoid dead lock with cpu hot plug
Date: Mon,  4 Aug 2014 16:40:08 +0800
Message-Id: <1407141608-28920-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cpu hotplug and evaluating ACPI method happen at the same time,
there is a dead lock between ACPICA namespace lock and cpu hotplug lock.

During cpu hotplug, cpu core will call acpi_cpu_soft_notify() to notify
Linux ACPI under cpu hotplug lock. acpi_cpu_soft_notify() calls
acpi_bus_get_device() to convert ACPI handle to struct acpi_struct.
ACPICA namespace lock will be held in the acpi_bus_get_device().

Evaluating ACPI method may involve in accessing system mem operation
region and the associated address space will be unmapped under
ACPICA namespace lock after accessing. Currently, osl.c uses RCU to
protect io mem pages used by ACPICA. During unmapping, synchronize_rcu()
will be called in the acpi_os_map_cleanup(). Synchroize_rcu() blocks
cpu hotplug via getting cpu hotplug lock. This causes dead lock with
cpu hotplug. Cpu hotplug thread holds cpu hotplug lock first and
then get ACPICA namespace lock. The thread of evaluating ACPI method
does the converse thing. This patch is to fix it via replacing
RCU with spin lock.

Here is dead lock log.
[   97.149005] INFO: task bash:741 blocked for more than 30 seconds.
[   97.155914]       Not tainted 3.16.0-rc5+ #671
[   97.160969] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   97.169850] bash            D ffff88014e214140     0   741    716 0x00000080
[   97.177885]  ffff88009b9f3a10 0000000000000086 ffff88009dcfb840 ffff88009b9f3fd8
[   97.186316]  0000000000014140 0000000000014140 ffffffff81c18460 ffffffff81c40fc8
[   97.194746]  ffffffff81c40fcc ffff88009dcfb840 00000000ffffffff ffffffff81c40fd0
[   97.203175] Call Trace:
[   97.205946]  [<ffffffff817a1b29>] schedule_preempt_disabled+0x29/0x70
[   97.213246]  [<ffffffff817a34fa>] __mutex_lock_slowpath+0xca/0x1c0
[   97.220258]  [<ffffffff817a360f>] mutex_lock+0x1f/0x2f
[   97.226085]  [<ffffffff810bc8cc>] get_online_cpus+0x2c/0x50
[   97.232408]  [<ffffffff8111bbd4>] synchronize_sched_expedited+0x64/0x1c0
[   97.240011]  [<ffffffff8111bb65>] synchronize_sched+0x45/0x50
[   97.246522]  [<ffffffff81431498>] acpi_os_map_cleanup.part.7+0x14/0x3e
[   97.253928]  [<ffffffff81795c54>] acpi_os_unmap_iomem+0xe2/0xea
[   97.260636]  [<ffffffff81795c6a>] acpi_os_unmap_memory+0xe/0x14
[   97.267355]  [<ffffffff814459bc>] acpi_ev_system_memory_region_setup+0x2d/0x97
[   97.275550]  [<ffffffff81459504>] acpi_ut_update_ref_count+0x24d/0x2de
[   97.282958]  [<ffffffff814596af>] acpi_ut_update_object_reference+0x11a/0x18b
[   97.291055]  [<ffffffff81459282>] acpi_ut_remove_reference+0x2e/0x31
[   97.298265]  [<ffffffff8144ffdf>] acpi_ns_detach_object+0x7b/0x80
[   97.305180]  [<ffffffff8144ef11>] acpi_ns_delete_namespace_subtree+0x47/0x81
[   97.313179]  [<ffffffff81440488>] acpi_ds_terminate_control_method+0x85/0x11b
[   97.321276]  [<ffffffff81454625>] acpi_ps_parse_aml+0x164/0x289
[   97.327988]  [<ffffffff81454da6>] acpi_ps_execute_method+0x1c1/0x26c
[   97.335195]  [<ffffffff8144f764>] acpi_ns_evaluate+0x1c1/0x258
[   97.341814]  [<ffffffff81451f86>] acpi_evaluate_object+0x126/0x22f
[   97.348826]  [<ffffffff8144d1ac>] acpi_hw_execute_sleep_method+0x3d/0x68
[   97.356427]  [<ffffffff8144d5cf>] ? acpi_hw_enable_all_runtime_gpes+0x17/0x19
[   97.364523]  [<ffffffff8144deb0>] acpi_hw_legacy_wake+0x4d/0x9d
[   97.371239]  [<ffffffff8144e599>] acpi_hw_sleep_dispatch+0x2a/0x2c
[   97.378243]  [<ffffffff8144e5cb>] acpi_leave_sleep_state+0x17/0x19
[   97.385252]  [<ffffffff8143335c>] acpi_pm_finish+0x3f/0x99
[   97.391471]  [<ffffffff81108c49>] suspend_devices_and_enter+0x139/0x560
[   97.398972]  [<ffffffff81109162>] pm_suspend+0xf2/0x370
[   97.404900]  [<ffffffff81107e69>] state_store+0x79/0xf0
[   97.410824]  [<ffffffff813bc4af>] kobj_attr_store+0xf/0x20
[   97.417038]  [<ffffffff81284f3d>] sysfs_kf_write+0x3d/0x50
[   97.423260]  [<ffffffff81284580>] kernfs_fop_write+0xe0/0x160
[   97.429776]  [<ffffffff81210f47>] vfs_write+0xb7/0x1f0
[   97.435602]  [<ffffffff81211ae6>] SyS_write+0x46/0xb0
[   97.441334]  [<ffffffff8114d986>] ? __audit_syscall_exit+0x1f6/0x2a0
[   97.448544]  [<ffffffff817a4ea9>] system_call_fastpath+0x16/0x1b
[   97.455361] INFO: task async-enable-no:749 blocked for more than 30 seconds.
[   97.463353]       Not tainted 3.16.0-rc5+ #671
[   97.468391] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   97.477271] async-enable-no D ffff88014e254140     0   749      2 0x00000080
[   97.485286]  ffff88009de83bf0 0000000000000046 ffff88009b850000 ffff88009de83fd8
[   97.493714]  0000000000014140 0000000000014140 ffff880148305dc0 ffff880149804160
[   97.502142]  7fffffffffffffff 0000000000000002 0000000000000000 ffff88009b850000
[   97.510573] Call Trace:
[   97.513344]  [<ffffffff817a1689>] schedule+0x29/0x70
[   97.518974]  [<ffffffff817a0b49>] schedule_timeout+0x1f9/0x270
[   97.525588]  [<ffffffff81284bfe>] ? __kernfs_create_file+0x7e/0xa0
[   97.532599]  [<ffffffff8128546b>] ? sysfs_add_file_mode_ns+0x9b/0x160
[   97.539903]  [<ffffffff817a36b2>] __down_common+0x93/0xd8
[   97.546027]  [<ffffffff817a376a>] __down_timeout+0x16/0x18
[   97.552252]  [<ffffffff8110546c>] down_timeout+0x4c/0x60
[   97.558274]  [<ffffffff81431f97>] acpi_os_wait_semaphore+0x43/0x57
[   97.565285]  [<ffffffff8145a8f4>] acpi_ut_acquire_mutex+0x48/0x88
[   97.572200]  [<ffffffff81435d1b>] ? acpi_match_device+0x4f/0x4f
[   97.578918]  [<ffffffff8145250f>] acpi_get_data_full+0x3a/0x8e
[   97.585537]  [<ffffffff81435b30>] acpi_bus_get_device+0x23/0x40
[   97.592253]  [<ffffffff8145d839>] acpi_cpu_soft_notify+0x50/0xe6
[   97.599064]  [<ffffffff810e1ddc>] notifier_call_chain+0x4c/0x70
[   97.605776]  [<ffffffff810e1eee>] __raw_notifier_call_chain+0xe/0x10
[   97.612983]  [<ffffffff810bc993>] cpu_notify+0x23/0x50
[   97.618815]  [<ffffffff810bcb98>] _cpu_up+0x168/0x180
[   97.624542]  [<ffffffff810bcc5c>] _cpu_up_with_trace+0x2c/0xe0
[   97.631153]  [<ffffffff810bd050>] ? disable_nonboot_cpus+0x1c0/0x1c0
[   97.638360]  [<ffffffff810bd06f>] async_enable_nonboot_cpus+0x1f/0x70
[   97.645670]  [<ffffffff810dda02>] kthread+0xd2/0xf0
[   97.651201]  [<ffffffff810dd930>] ? insert_kthread_work+0x40/0x40
[   97.658117]  [<ffffffff817a4dfc>] ret_from_fork+0x7c/0xb0

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/osl.c | 60 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 28 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index bad25b0..d018d95 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -97,7 +97,7 @@ struct acpi_ioremap {
 };
 
 static LIST_HEAD(acpi_ioremaps);
-static DEFINE_MUTEX(acpi_ioremap_lock);
+static DEFINE_SPINLOCK(acpi_ioremap_lock);
 
 static void __init acpi_osi_setup_late(void);
 
@@ -267,13 +267,13 @@ acpi_physical_address __init acpi_os_get_root_pointer(void)
 	}
 }
 
-/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
+/* Must be called with 'acpi_ioremap_lock'. */
 static struct acpi_ioremap *
 acpi_map_lookup(acpi_physical_address phys, acpi_size size)
 {
 	struct acpi_ioremap *map;
 
-	list_for_each_entry_rcu(map, &acpi_ioremaps, list)
+	list_for_each_entry(map, &acpi_ioremaps, list)
 		if (map->phys <= phys &&
 		    phys + size <= map->phys + map->size)
 			return map;
@@ -281,7 +281,7 @@ acpi_map_lookup(acpi_physical_address phys, acpi_size size)
 	return NULL;
 }
 
-/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
+/* Must be called with 'acpi_ioremap_lock'. */
 static void __iomem *
 acpi_map_vaddr_lookup(acpi_physical_address phys, unsigned int size)
 {
@@ -298,29 +298,29 @@ void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size)
 {
 	struct acpi_ioremap *map;
 	void __iomem *virt = NULL;
+	unsigned long flags;
 
-	mutex_lock(&acpi_ioremap_lock);
+	spin_lock_irqsave(&acpi_ioremap_lock, flags);
 	map = acpi_map_lookup(phys, size);
 	if (map) {
 		virt = map->virt + (phys - map->phys);
 		map->refcount++;
 	}
-	mutex_unlock(&acpi_ioremap_lock);
+	spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
 	return virt;
 }
 EXPORT_SYMBOL_GPL(acpi_os_get_iomem);
 
-/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
+/* Must be called with 'acpi_ioremap_lock'. */
 static struct acpi_ioremap *
 acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
 {
 	struct acpi_ioremap *map;
 
-	list_for_each_entry_rcu(map, &acpi_ioremaps, list)
+	list_for_each_entry(map, &acpi_ioremaps, list)
 		if (map->virt <= virt &&
 		    virt + size <= map->virt + map->size)
 			return map;
-
 	return NULL;
 }
 
@@ -362,6 +362,7 @@ acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 	void __iomem *virt;
 	acpi_physical_address pg_off;
 	acpi_size pg_sz;
+	unsigned long flags;
 
 	if (phys > ULONG_MAX) {
 		printk(KERN_ERR PREFIX "Cannot map memory that high\n");
@@ -371,7 +372,7 @@ acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 	if (!acpi_gbl_permanent_mmap)
 		return __acpi_map_table((unsigned long)phys, size);
 
-	mutex_lock(&acpi_ioremap_lock);
+	spin_lock_irqsave(&acpi_ioremap_lock, flags);
 	/* Check if there's a suitable mapping already. */
 	map = acpi_map_lookup(phys, size);
 	if (map) {
@@ -381,7 +382,7 @@ acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
 	if (!map) {
-		mutex_unlock(&acpi_ioremap_lock);
+		spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
 		return NULL;
 	}
 
@@ -389,7 +390,7 @@ acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 	pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
 	virt = acpi_map(pg_off, pg_sz);
 	if (!virt) {
-		mutex_unlock(&acpi_ioremap_lock);
+		spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
 		kfree(map);
 		return NULL;
 	}
@@ -400,10 +401,10 @@ acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
 	map->size = pg_sz;
 	map->refcount = 1;
 
-	list_add_tail_rcu(&map->list, &acpi_ioremaps);
+	list_add_tail(&map->list, &acpi_ioremaps);
 
 out:
-	mutex_unlock(&acpi_ioremap_lock);
+	spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
 	return map->virt + (phys - map->phys);
 }
 EXPORT_SYMBOL_GPL(acpi_os_map_iomem);
@@ -418,13 +419,12 @@ EXPORT_SYMBOL_GPL(acpi_os_map_memory);
 static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
 {
 	if (!--map->refcount)
-		list_del_rcu(&map->list);
+		list_del(&map->list);
 }
 
 static void acpi_os_map_cleanup(struct acpi_ioremap *map)
 {
 	if (!map->refcount) {
-		synchronize_rcu();
 		acpi_unmap(map->phys, map->virt);
 		kfree(map);
 	}
@@ -433,21 +433,22 @@ static void acpi_os_map_cleanup(struct acpi_ioremap *map)
 void __ref acpi_os_unmap_iomem(void __iomem *virt, acpi_size size)
 {
 	struct acpi_ioremap *map;
+	unsigned long flags;
 
 	if (!acpi_gbl_permanent_mmap) {
 		__acpi_unmap_table(virt, size);
 		return;
 	}
 
-	mutex_lock(&acpi_ioremap_lock);
+	spin_lock_irqsave(&acpi_ioremap_lock, flags);
 	map = acpi_map_lookup_virt(virt, size);
 	if (!map) {
-		mutex_unlock(&acpi_ioremap_lock);
+		spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
 		WARN(true, PREFIX "%s: bad address %p\n", __func__, virt);
 		return;
 	}
 	acpi_os_drop_map_ref(map);
-	mutex_unlock(&acpi_ioremap_lock);
+	spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
 
 	acpi_os_map_cleanup(map);
 }
@@ -490,6 +491,7 @@ void acpi_os_unmap_generic_address(struct acpi_generic_address *gas)
 {
 	u64 addr;
 	struct acpi_ioremap *map;
+	unsigned long flags;
 
 	if (gas->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
 		return;
@@ -499,14 +501,14 @@ void acpi_os_unmap_generic_address(struct acpi_generic_address *gas)
 	if (!addr || !gas->bit_width)
 		return;
 
-	mutex_lock(&acpi_ioremap_lock);
+	spin_lock_irqsave(&acpi_ioremap_lock, flags);
 	map = acpi_map_lookup(addr, gas->bit_width / 8);
 	if (!map) {
-		mutex_unlock(&acpi_ioremap_lock);
+		spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
 		return;
 	}
 	acpi_os_drop_map_ref(map);
-	mutex_unlock(&acpi_ioremap_lock);
+	spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
 
 	acpi_os_map_cleanup(map);
 }
@@ -939,11 +941,12 @@ acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
 	unsigned int size = width / 8;
 	bool unmap = false;
 	u64 dummy;
+	unsigned long flags;
 
-	rcu_read_lock();
+	spin_lock_irqsave(&acpi_ioremap_lock, flags);
 	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
 	if (!virt_addr) {
-		rcu_read_unlock();
+		spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
 		virt_addr = acpi_os_ioremap(phys_addr, size);
 		if (!virt_addr)
 			return AE_BAD_ADDRESS;
@@ -973,7 +976,7 @@ acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
 	if (unmap)
 		iounmap(virt_addr);
 	else
-		rcu_read_unlock();
+		spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
 
 	return AE_OK;
 }
@@ -997,11 +1000,12 @@ acpi_os_write_memory(acpi_physical_address phys_addr, u64 value, u32 width)
 	void __iomem *virt_addr;
 	unsigned int size = width / 8;
 	bool unmap = false;
+	unsigned long flags;
 
-	rcu_read_lock();
+	spin_lock_irqsave(&acpi_ioremap_lock, flags);
 	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
 	if (!virt_addr) {
-		rcu_read_unlock();
+		spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
 		virt_addr = acpi_os_ioremap(phys_addr, size);
 		if (!virt_addr)
 			return AE_BAD_ADDRESS;
@@ -1028,7 +1032,7 @@ acpi_os_write_memory(acpi_physical_address phys_addr, u64 value, u32 width)
 	if (unmap)
 		iounmap(virt_addr);
 	else
-		rcu_read_unlock();
+		spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
 
 	return AE_OK;
 }
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

