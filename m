Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaI2PUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:20:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27918 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaI2PUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:20:15 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] sched: Use RCU read lock on all calls to dl_bw_of()
Date: Mon, 29 Sep 2014 11:19:30 -0400
Message-Id: <1412003970-25277-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "sched: Use dl_bw_of() under RCU read lock" has missed a call
to dl_bw_of(), which has now started showing warnings:

[  820.960972] ===============================
[  820.961663] [ INFO: suspicious RCU usage. ]
[  820.962344] 3.17.0-rc6-next-20140926-sasha-00051-g9253dff-dirty #1242 Not tainted
[  820.963670] -------------------------------
[  820.964454] kernel/sched/core.c:2008 sched RCU must be held!
[  820.975556]
[  820.975556] other info that might help us debug this:
[  820.975556]
[  820.987512] rcu_scheduler_active = 1, debug_locks = 1
[  820.988546] 9 locks held by trinity-c157/26236:
[  820.989274] #0: (&f->f_pos_lock){+.+.+.}, at: __fdget_pos (fs/file.c:718)
[  820.994630] #1: (sb_writers#5){.+.+.+}, at: do_readv_writev (include/linux/fs.h:2270 fs/read_write.c:832)
[  820.996170] #2: (&of->mutex){+.+.+.}, at: kernfs_fop_write (fs/kernfs/file.c:296)
[  821.001816] #3: (s_active#23){.+.+.+}, at: kernfs_fop_write (fs/kernfs/file.c:296)
[  821.003235] #4: (device_hotplug_lock){+.+.+.}, at: lock_device_hotplug_sysfs (drivers/base/core.c:66)
[  821.004842] #5: (&dev->mutex){......}, at: device_offline (include/linux/device.h:900 drivers/base/core.c:1423)
[  821.010610] #6: (cpu_add_remove_lock){+.+.+.}, at: cpu_down (kernel/cpu.c:426)
[  821.011859] #7: (cpu_hotplug.lock){++++++}, at: cpu_hotplug_begin (kernel/cpu.c:152)
[  821.013208] #8: (cpu_hotplug.lock#2){+.+.+.}, at: cpu_hotplug_begin (kernel/cpu.c:158)
[  821.027101]
[  821.027101] stack backtrace:
[  821.027903] CPU: 17 PID: 26236 Comm: trinity-c157 Not tainted 3.17.0-rc6-next-20140926-sasha-00051-g9253dff-dirty #1242
[  821.030246]  0000000000000001 0000000000000000 0000000000000001 ffff880803363a98
[  821.038543]  ffffffffb5f0070f 0000000000000011 ffff8808271eb000 ffff880803363ac8
[  821.039967]  ffffffffb124e8ed 0000000000000000 ffff880803363bbc 0000000000000013
[  821.041455] Call Trace:
[  821.042038] dump_stack (lib/dump_stack.c:52)
[  821.043005] lockdep_rcu_suspicious (kernel/locking/lockdep.c:4265)
[  821.044169] sched_cpu_inactive (kernel/sched/core.c:2008 kernel/sched/core.c:5271)
[  821.050486] notifier_call_chain (kernel/notifier.c:93)
[  821.051594] __raw_notifier_call_chain (kernel/notifier.c:395)
[  821.052766] _cpu_down (include/linux/notifier.h:179 kernel/cpu.c:219 kernel/cpu.c:356)
[  821.053809] ? cpu_down (kernel/cpu.c:426)
[  821.054770] cpu_down (kernel/cpu.c:431)
[  821.062497] cpu_subsys_offline (drivers/base/cpu.c:69)
[  821.063500] device_offline (drivers/base/core.c:1428)
[  821.064428] ? cpu_device_release (drivers/base/cpu.c:67)
[  821.065429] online_store (drivers/base/core.c:451 (discriminator 2))
[  821.066390] dev_attr_store (drivers/base/core.c:138)
[  821.067328] ? dev_driver_string (drivers/base/core.c:130)
[  821.073698] sysfs_kf_write (fs/sysfs/file.c:116)
[  821.074496] ? sysfs_file_ops (fs/sysfs/file.c:108)
[  821.075312] kernfs_fop_write (fs/kernfs/file.c:308)
[  821.076135] ? do_readv_writev (include/linux/fs.h:2270 fs/read_write.c:832)
[  821.076999] do_loop_readv_writev (fs/read_write.c:710)
[  821.078066] ? kernfs_vma_page_mkwrite (fs/kernfs/file.c:267)
[  821.079252] do_readv_writev (fs/read_write.c:842)
[  821.080495] ? kernfs_vma_page_mkwrite (fs/kernfs/file.c:267)
[  821.081644] ? mutex_lock_nested (./arch/x86/include/asm/preempt.h:98 kernel/locking/mutex.c:599 kernel/locking/mutex.c:616)
[  821.086535] ? __fdget_pos (fs/file.c:718)
[  821.087447] ? __fdget_pos (fs/file.c:718)
[  821.088363] ? rcu_read_lock_held (kernel/rcu/update.c:169)
[  821.089425] vfs_writev (fs/read_write.c:881)
[  821.090486] SyS_writev (fs/read_write.c:913 fs/read_write.c:905)
[  821.091382] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/sched/core.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e6cfd9b..91bfbbb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5261,6 +5261,9 @@ static int sched_cpu_inactive(struct notifier_block *nfb,
 {
 	unsigned long flags;
 	long cpu = (long)hcpu;
+	int ret;
+
+	rcu_read_lock();
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
@@ -5277,13 +5280,19 @@ static int sched_cpu_inactive(struct notifier_block *nfb,
 			overflow = __dl_overflow(dl_b, cpus, 0, 0);
 			raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 
+			ret = notifier_from_errno(-EBUSY);
 			if (overflow)
-				return notifier_from_errno(-EBUSY);
+				goto done;
 		}
-		return NOTIFY_OK;
+		ret = NOTIFY_OK;
+		goto done;
 	}
 
-	return NOTIFY_DONE;
+	ret = NOTIFY_DONE;
+
+done:
+	rcu_read_unlock();
+	return ret;
 }
 
 static int __init migration_init(void)
-- 
1.7.10.4

