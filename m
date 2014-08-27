Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbaH0HOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:14:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:17455 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbaH0HOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:14:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="377511956"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, lenb@kernel.org, fengguang.wu@intel.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, All applicable <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH V3] ACPI / OSL: Make acpi_os_map_cleanup() use call_rcu() to avoid deadlocks
Date: Wed, 27 Aug 2014 15:11:29 +0800
Message-Id: <1409123489-11786-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20140827022709.GA22064@localhost>
References: <20140827022709.GA22064@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deadlock is possible when CPU hotplug and evaluating ACPI method happen
at the same time.

During CPU hotplug, acpi_cpu_soft_notify() is called under the CPU hotplug
lock.  Then, acpi_cpu_soft_notify() calls acpi_bus_get_device() to obtain
the struct acpi_device attached to the given ACPI handle.  The ACPICA's
namespace lock will be acquired by acpi_bus_get_device() in the process.
Thus it is possible to hold the ACPICA's namespace lock under the CPU
hotplug lock.

Evaluating an ACPI method may involve accessing an operation region in
system memory and the associated address space will be unmapped under
the ACPICA's namespace lock after completing the access. Currently, osl.c
uses RCU to protect memory ranges used by AML.  When unmapping them it
calls synchronize_rcu() in acpi_os_map_cleanup(), but that blocks
CPU hotplug by acquiring the CPU hotplug lock.  Thus it is possible to
hold the CPU hotplug lock under the ACPICA's namespace lock.

This leads to deadlocks like the following one if AML accessing operation
regions in memory is executed in parallel with CPU hotplug.

INFO: task bash:741 blocked for more than 30 seconds.
      Not tainted 3.16.0-rc5+ #671
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
bash            D ffff88014e214140     0   741    716 0x00000080
 ffff88009b9f3a10 0000000000000086 ffff88009dcfb840 ffff88009b9f3fd8
 0000000000014140 0000000000014140 ffffffff81c18460 ffffffff81c40fc8
 ffffffff81c40fcc ffff88009dcfb840 00000000ffffffff ffffffff81c40fd0
Call Trace:
 [<ffffffff817a1b29>] schedule_preempt_disabled+0x29/0x70
 [<ffffffff817a34fa>] __mutex_lock_slowpath+0xca/0x1c0
 [<ffffffff817a360f>] mutex_lock+0x1f/0x2f
 [<ffffffff810bc8cc>] get_online_cpus+0x2c/0x50
 [<ffffffff8111bbd4>] synchronize_sched_expedited+0x64/0x1c0
 [<ffffffff8111bb65>] synchronize_sched+0x45/0x50
 [<ffffffff81431498>] acpi_os_map_cleanup.part.7+0x14/0x3e
 [<ffffffff81795c54>] acpi_os_unmap_iomem+0xe2/0xea
 [<ffffffff81795c6a>] acpi_os_unmap_memory+0xe/0x14
 [<ffffffff814459bc>] acpi_ev_system_memory_region_setup+0x2d/0x97
 [<ffffffff81459504>] acpi_ut_update_ref_count+0x24d/0x2de
 [<ffffffff814596af>] acpi_ut_update_object_reference+0x11a/0x18b
 [<ffffffff81459282>] acpi_ut_remove_reference+0x2e/0x31
 [<ffffffff8144ffdf>] acpi_ns_detach_object+0x7b/0x80
 [<ffffffff8144ef11>] acpi_ns_delete_namespace_subtree+0x47/0x81
 [<ffffffff81440488>] acpi_ds_terminate_control_method+0x85/0x11b
 [<ffffffff81454625>] acpi_ps_parse_aml+0x164/0x289
 [<ffffffff81454da6>] acpi_ps_execute_method+0x1c1/0x26c
 [<ffffffff8144f764>] acpi_ns_evaluate+0x1c1/0x258
 [<ffffffff81451f86>] acpi_evaluate_object+0x126/0x22f
 [<ffffffff8144d1ac>] acpi_hw_execute_sleep_method+0x3d/0x68
 [<ffffffff8144d5cf>] ? acpi_hw_enable_all_runtime_gpes+0x17/0x19
 [<ffffffff8144deb0>] acpi_hw_legacy_wake+0x4d/0x9d
 [<ffffffff8144e599>] acpi_hw_sleep_dispatch+0x2a/0x2c
 [<ffffffff8144e5cb>] acpi_leave_sleep_state+0x17/0x19
 [<ffffffff8143335c>] acpi_pm_finish+0x3f/0x99
 [<ffffffff81108c49>] suspend_devices_and_enter+0x139/0x560
 [<ffffffff81109162>] pm_suspend+0xf2/0x370
 [<ffffffff81107e69>] state_store+0x79/0xf0
 [<ffffffff813bc4af>] kobj_attr_store+0xf/0x20
 [<ffffffff81284f3d>] sysfs_kf_write+0x3d/0x50
 [<ffffffff81284580>] kernfs_fop_write+0xe0/0x160
 [<ffffffff81210f47>] vfs_write+0xb7/0x1f0
 [<ffffffff81211ae6>] SyS_write+0x46/0xb0
 [<ffffffff8114d986>] ? __audit_syscall_exit+0x1f6/0x2a0
 [<ffffffff817a4ea9>] system_call_fastpath+0x16/0x1b
INFO: task async-enable-no:749 blocked for more than 30 seconds.
      Not tainted 3.16.0-rc5+ #671
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
async-enable-no D ffff88014e254140     0   749      2 0x00000080
 ffff88009de83bf0 0000000000000046 ffff88009b850000 ffff88009de83fd8
 0000000000014140 0000000000014140 ffff880148305dc0 ffff880149804160
 7fffffffffffffff 0000000000000002 0000000000000000 ffff88009b850000
Call Trace:
 [<ffffffff817a1689>] schedule+0x29/0x70
 [<ffffffff817a0b49>] schedule_timeout+0x1f9/0x270
 [<ffffffff81284bfe>] ? __kernfs_create_file+0x7e/0xa0
 [<ffffffff8128546b>] ? sysfs_add_file_mode_ns+0x9b/0x160
 [<ffffffff817a36b2>] __down_common+0x93/0xd8
 [<ffffffff817a376a>] __down_timeout+0x16/0x18
 [<ffffffff8110546c>] down_timeout+0x4c/0x60
 [<ffffffff81431f97>] acpi_os_wait_semaphore+0x43/0x57
 [<ffffffff8145a8f4>] acpi_ut_acquire_mutex+0x48/0x88
 [<ffffffff81435d1b>] ? acpi_match_device+0x4f/0x4f
 [<ffffffff8145250f>] acpi_get_data_full+0x3a/0x8e
 [<ffffffff81435b30>] acpi_bus_get_device+0x23/0x40
 [<ffffffff8145d839>] acpi_cpu_soft_notify+0x50/0xe6
 [<ffffffff810e1ddc>] notifier_call_chain+0x4c/0x70
 [<ffffffff810e1eee>] __raw_notifier_call_chain+0xe/0x10
 [<ffffffff810bc993>] cpu_notify+0x23/0x50
 [<ffffffff810bcb98>] _cpu_up+0x168/0x180
 [<ffffffff810bcc5c>] _cpu_up_with_trace+0x2c/0xe0
 [<ffffffff810bd050>] ? disable_nonboot_cpus+0x1c0/0x1c0
 [<ffffffff810bd06f>] async_enable_nonboot_cpus+0x1f/0x70
 [<ffffffff810dda02>] kthread+0xd2/0xf0
 [<ffffffff810dd930>] ? insert_kthread_work+0x40/0x40
 [<ffffffff817a4dfc>] ret_from_fork+0x7c/0xb0

To avoid such deadlocks, modify acpi_os_map_cleanup() to use call_rcu()
to schedule acpi_os_async_umap() asynchronously to umap memory regions
that aren't used any more. The umap operation can't be done in the
call_rcu()'s callback directly because the callback will be called in the
soft irq context and acpi_unmap() holds mutex lock inside.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
[rjw: Subject and changelog.]
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/osl.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 3abe9b2..9baef71 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -40,6 +40,7 @@
 #include <linux/nmi.h>
 #include <linux/acpi.h>
 #include <linux/efi.h>
+#include <linux/async.h>
 #include <linux/ioport.h>
 #include <linux/list.h>
 #include <linux/jiffies.h>
@@ -94,6 +95,7 @@ struct acpi_ioremap {
 	acpi_physical_address phys;
 	acpi_size size;
 	unsigned long refcount;
+	struct rcu_head rcu;
 };
 
 static LIST_HEAD(acpi_ioremaps);
@@ -423,13 +425,25 @@ static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
 		list_del_rcu(&map->list);
 }
 
+static void acpi_os_async_umap(void *data, async_cookie_t cookie)
+{
+	struct acpi_ioremap *map = data;
+
+	acpi_unmap(map->phys, map->virt);
+	kfree(map);
+}
+
+static void acpi_os_map_reclaim(struct rcu_head *rcu)
+{
+	struct acpi_ioremap *map = container_of(rcu, struct acpi_ioremap, rcu);
+
+	async_schedule(acpi_os_async_umap, map);
+}
+
 static void acpi_os_map_cleanup(struct acpi_ioremap *map)
 {
-	if (!map->refcount) {
-		synchronize_rcu();
-		acpi_unmap(map->phys, map->virt);
-		kfree(map);
-	}
+	if (!map->refcount)
+		call_rcu(&map->rcu, acpi_os_map_reclaim);
 }
 
 void __ref acpi_os_unmap_iomem(void __iomem *virt, acpi_size size)
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

