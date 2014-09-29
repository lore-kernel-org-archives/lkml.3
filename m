Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaI2Qn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:43:56 -0400
Received: from relay.parallels.com ([195.214.232.42]:41360 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaI2Qnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:43:55 -0400
Message-ID: <1412009027.20287.17.camel@tkhai>
Subject: Re: [PATCH] sched: Use RCU read lock on all calls to dl_bw_of()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Sasha Levin <sasha.levin@oracle.com>
CC: <mingo@kernel.org>, <torvalds@linux-foundation.org>,
        <paulmck@linux.vnet.ibm.com>, <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 29 Sep 2014 20:43:47 +0400
In-Reply-To: <1412003970-25277-1-git-send-email-sasha.levin@oracle.com>
References: <1412003970-25277-1-git-send-email-sasha.levin@oracle.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Sasha,

В Пн, 29/09/2014 в 11:19 -0400, Sasha Levin пишет:
> Commit "sched: Use dl_bw_of() under RCU read lock" has missed a call
> to dl_bw_of(), which has now started showing warnings:
> 
> [  820.960972] ===============================
> [  820.961663] [ INFO: suspicious RCU usage. ]
> [  820.962344] 3.17.0-rc6-next-20140926-sasha-00051-g9253dff-dirty #1242 Not tainted
> [  820.963670] -------------------------------
> [  820.964454] kernel/sched/core.c:2008 sched RCU must be held!
> [  820.975556]
> [  820.975556] other info that might help us debug this:
> [  820.975556]
> [  820.987512] rcu_scheduler_active = 1, debug_locks = 1
> [  820.988546] 9 locks held by trinity-c157/26236:
> [  820.989274] #0: (&f->f_pos_lock){+.+.+.}, at: __fdget_pos (fs/file.c:718)
> [  820.994630] #1: (sb_writers#5){.+.+.+}, at: do_readv_writev (include/linux/fs.h:2270 fs/read_write.c:832)
> [  820.996170] #2: (&of->mutex){+.+.+.}, at: kernfs_fop_write (fs/kernfs/file.c:296)
> [  821.001816] #3: (s_active#23){.+.+.+}, at: kernfs_fop_write (fs/kernfs/file.c:296)
> [  821.003235] #4: (device_hotplug_lock){+.+.+.}, at: lock_device_hotplug_sysfs (drivers/base/core.c:66)
> [  821.004842] #5: (&dev->mutex){......}, at: device_offline (include/linux/device.h:900 drivers/base/core.c:1423)
> [  821.010610] #6: (cpu_add_remove_lock){+.+.+.}, at: cpu_down (kernel/cpu.c:426)
> [  821.011859] #7: (cpu_hotplug.lock){++++++}, at: cpu_hotplug_begin (kernel/cpu.c:152)
> [  821.013208] #8: (cpu_hotplug.lock#2){+.+.+.}, at: cpu_hotplug_begin (kernel/cpu.c:158)
> [  821.027101]
> [  821.027101] stack backtrace:
> [  821.027903] CPU: 17 PID: 26236 Comm: trinity-c157 Not tainted 3.17.0-rc6-next-20140926-sasha-00051-g9253dff-dirty #1242
> [  821.030246]  0000000000000001 0000000000000000 0000000000000001 ffff880803363a98
> [  821.038543]  ffffffffb5f0070f 0000000000000011 ffff8808271eb000 ffff880803363ac8
> [  821.039967]  ffffffffb124e8ed 0000000000000000 ffff880803363bbc 0000000000000013
> [  821.041455] Call Trace:
> [  821.042038] dump_stack (lib/dump_stack.c:52)
> [  821.043005] lockdep_rcu_suspicious (kernel/locking/lockdep.c:4265)
> [  821.044169] sched_cpu_inactive (kernel/sched/core.c:2008 kernel/sched/core.c:5271)
> [  821.050486] notifier_call_chain (kernel/notifier.c:93)
> [  821.051594] __raw_notifier_call_chain (kernel/notifier.c:395)
> [  821.052766] _cpu_down (include/linux/notifier.h:179 kernel/cpu.c:219 kernel/cpu.c:356)
> [  821.053809] ? cpu_down (kernel/cpu.c:426)
> [  821.054770] cpu_down (kernel/cpu.c:431)
> [  821.062497] cpu_subsys_offline (drivers/base/cpu.c:69)
> [  821.063500] device_offline (drivers/base/core.c:1428)
> [  821.064428] ? cpu_device_release (drivers/base/cpu.c:67)
> [  821.065429] online_store (drivers/base/core.c:451 (discriminator 2))
> [  821.066390] dev_attr_store (drivers/base/core.c:138)
> [  821.067328] ? dev_driver_string (drivers/base/core.c:130)
> [  821.073698] sysfs_kf_write (fs/sysfs/file.c:116)
> [  821.074496] ? sysfs_file_ops (fs/sysfs/file.c:108)
> [  821.075312] kernfs_fop_write (fs/kernfs/file.c:308)
> [  821.076135] ? do_readv_writev (include/linux/fs.h:2270 fs/read_write.c:832)
> [  821.076999] do_loop_readv_writev (fs/read_write.c:710)
> [  821.078066] ? kernfs_vma_page_mkwrite (fs/kernfs/file.c:267)
> [  821.079252] do_readv_writev (fs/read_write.c:842)
> [  821.080495] ? kernfs_vma_page_mkwrite (fs/kernfs/file.c:267)
> [  821.081644] ? mutex_lock_nested (./arch/x86/include/asm/preempt.h:98 kernel/locking/mutex.c:599 kernel/locking/mutex.c:616)
> [  821.086535] ? __fdget_pos (fs/file.c:718)
> [  821.087447] ? __fdget_pos (fs/file.c:718)
> [  821.088363] ? rcu_read_lock_held (kernel/rcu/update.c:169)
> [  821.089425] vfs_writev (fs/read_write.c:881)
> [  821.090486] SyS_writev (fs/read_write.c:913 fs/read_write.c:905)
> [  821.091382] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Thanks for your report. It looks like your fix is not enough, because
we check for rcu_read_lock_sched_held() in dl_bw_of(). It still warns
even if rcu_read_lock() is held.

I used rcu_read_lock_sched_held() because we free root_domain using
call_rcu_sched(). So, it's necessary to held rcu_read_lock_sched(),
and my initial commit has this problem too.

It looks like we should fix it in a way like this:

[PATCH]sched: Use dl_bw_of() under rcu_read_lock_sched()

rq->rd is freed using call_rcu_sched(), and it's accessed with preemption
disabled in the most cases.

So in other places we should use rcu_read_lock_sched() to access it to fit
the scheme:

rcu_read_lock_sched() or preempt_disable() <==> call_rcu_sched().

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com
Fixes 66339c31bc39 "sched: Use dl_bw_of() under RCU read lock"
Reported-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/sched/core.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 25e4513..3a0a62d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5248,6 +5248,9 @@ static int sched_cpu_inactive(struct notifier_block *nfb,
 {
 	unsigned long flags;
 	long cpu = (long)hcpu;
+	int ret;
+
+	rcu_read_lock_sched();
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
@@ -5264,13 +5267,19 @@ static int sched_cpu_inactive(struct notifier_block *nfb,
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
+	rcu_read_unlock_sched();
+	return ret;
 }
 
 static int __init migration_init(void)
@@ -7634,7 +7643,7 @@ static int sched_dl_global_constraints(void)
 	int cpu, ret = 0;
 	unsigned long flags;
 
-	rcu_read_lock();
+	rcu_read_lock_sched();
 
 	/*
 	 * Here we want to check the bandwidth not being set to some
@@ -7657,7 +7666,7 @@ static int sched_dl_global_constraints(void)
 			break;
 	}
 
-	rcu_read_unlock();
+	rcu_read_unlock_sched();
 
 	return ret;
 }
@@ -7674,7 +7683,7 @@ static void sched_dl_do_global(void)
 	if (global_rt_runtime() != RUNTIME_INF)
 		new_bw = to_ratio(global_rt_period(), global_rt_runtime());
 
-	rcu_read_lock();
+	rcu_read_lock_sched();
 	/*
 	 * FIXME: As above...
 	 */
@@ -7685,7 +7694,7 @@ static void sched_dl_do_global(void)
 		dl_b->bw = new_bw;
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 	}
-	rcu_read_unlock();
+	rcu_read_unlock_sched();
 }
 
 static int sched_rt_global_validate(void)


