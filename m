Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbaDIEeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 00:34:25 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63419 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaDIEeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 00:34:22 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de, john.stultz@linaro.org
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com, jet.chen@intel.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2] clocksource: register cpu notifier to remove timer from dying CPU
Date: Wed,  9 Apr 2014 10:04:15 +0530
Message-Id: <f13134fea7e7658ae3dab90faca1e6578b8f82e7.1397017662.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clocksource core is using add_timer_on() to run clocksource_watchdog() on all
CPUs one by one. But when a core is brought down, clocksource core doesn't
remove this timer from the dying CPU. And in this case timer core gives this
(Gives this only with unmerged code, anyway in the current code as well timer
core is migrating a pinned timer to other CPUs, which is also wrong:
http://www.gossamer-threads.com/lists/linux/kernel/1898117)

migrate_timer_list: can't migrate pinned timer: ffffffff81f06a60,
timer->function: ffffffff810d7010,deactivating it Modules linked in:

CPU: 0 PID: 1932 Comm: 01-cpu-hotplug Not tainted 3.14.0-rc1-00088-gab3c4fd #4
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
 0000000000000009 ffff88001d407c38 ffffffff817237bd ffff88001d407c80
 ffff88001d407c70 ffffffff8106a1dd 0000000000000010 ffffffff81f06a60
 ffff88001e04d040 ffffffff81e3d4c0 ffff88001e04d030 ffff88001d407cd0
Call Trace:
 [<ffffffff817237bd>] dump_stack+0x4d/0x66
 [<ffffffff8106a1dd>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff8106a24c>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffff810761c3>] ? __internal_add_timer+0x113/0x130
 [<ffffffff810d7010>] ? clocksource_watchdog_kthread+0x40/0x40
 [<ffffffff8107753b>] migrate_timer_list+0xdb/0xf0
 [<ffffffff810782dc>] timer_cpu_notify+0xfc/0x1f0
 [<ffffffff8173046c>] notifier_call_chain+0x4c/0x70
 [<ffffffff8109340e>] __raw_notifier_call_chain+0xe/0x10
 [<ffffffff8106a3f3>] cpu_notify+0x23/0x50
 [<ffffffff8106a44e>] cpu_notify_nofail+0xe/0x20
 [<ffffffff81712a5d>] _cpu_down+0x1ad/0x2e0
 [<ffffffff81712bc4>] cpu_down+0x34/0x50
 [<ffffffff813fec54>] cpu_subsys_offline+0x14/0x20
 [<ffffffff813f9f65>] device_offline+0x95/0xc0
 [<ffffffff813fa060>] online_store+0x40/0x90
 [<ffffffff813f75d8>] dev_attr_store+0x18/0x30
 [<ffffffff8123309d>] sysfs_kf_write+0x3d/0x50

This patch tries to fix this by registering cpu notifiers from clocksource core,
only when we start clocksource-watchdog. And if on the CPU_DEAD notification it
is found that dying CPU was the CPU on which this timer is queued on, then it is
removed from that CPU and queued to next CPU.

Reported-and-tested-by: Jet Chen <jet.chen@intel.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V1->V2:
- Moved 'static int timer_cpu' within #ifdef CONFIG_CLOCKSOURCE_WATCHDOG/endif
- replaced spin_lock with spin_lock_irqsave in clocksource_cpu_notify() as a bug
  is reported by Jet Chen with that.
- Tested again by Jet Chen (Thanks again :))

 kernel/time/clocksource.c | 65 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 11 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ba3e502..d288f1f 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -23,10 +23,12 @@
  *   o Allow clocksource drivers to be unregistered
  */
 
+#include <linux/cpu.h>
 #include <linux/device.h>
 #include <linux/clocksource.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 #include <linux/tick.h>
 #include <linux/kthread.h>
@@ -180,6 +182,9 @@ static char override_name[CS_NAME_LEN];
 static int finished_booting;
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+/* Tracks current CPU to queue watchdog timer on */
+static int timer_cpu;
+
 static void clocksource_watchdog_work(struct work_struct *work);
 static void clocksource_select(void);
 
@@ -246,12 +251,25 @@ void clocksource_mark_unstable(struct clocksource *cs)
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
+static void queue_timer_on_next_cpu(void)
+{
+	/*
+	 * Cycle through CPUs to check if the CPUs stay synchronized to each
+	 * other.
+	 */
+	timer_cpu = cpumask_next(timer_cpu, cpu_online_mask);
+	if (timer_cpu >= nr_cpu_ids)
+		timer_cpu = cpumask_first(cpu_online_mask);
+	watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
+	add_timer_on(&watchdog_timer, timer_cpu);
+}
+
 static void clocksource_watchdog(unsigned long data)
 {
 	struct clocksource *cs;
 	cycle_t csnow, wdnow;
 	int64_t wd_nsec, cs_nsec;
-	int next_cpu, reset_pending;
+	int reset_pending;
 
 	spin_lock(&watchdog_lock);
 	if (!watchdog_running)
@@ -336,27 +354,51 @@ static void clocksource_watchdog(unsigned long data)
 	if (reset_pending)
 		atomic_dec(&watchdog_reset_pending);
 
-	/*
-	 * Cycle through CPUs to check if the CPUs stay synchronized
-	 * to each other.
-	 */
-	next_cpu = cpumask_next(raw_smp_processor_id(), cpu_online_mask);
-	if (next_cpu >= nr_cpu_ids)
-		next_cpu = cpumask_first(cpu_online_mask);
-	watchdog_timer.expires += WATCHDOG_INTERVAL;
-	add_timer_on(&watchdog_timer, next_cpu);
+	queue_timer_on_next_cpu();
 out:
 	spin_unlock(&watchdog_lock);
 }
 
+static int clocksource_cpu_notify(struct notifier_block *self,
+				unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+	unsigned long flags;
+
+	spin_lock_irqsave(&watchdog_lock, flags);
+	if (!watchdog_running)
+		goto notify_out;
+
+	switch (action) {
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		if (cpu != timer_cpu)
+			break;
+		del_timer(&watchdog_timer);
+		queue_timer_on_next_cpu();
+		break;
+	}
+
+notify_out:
+	spin_unlock_irqrestore(&watchdog_lock, flags);
+	return NOTIFY_OK;
+}
+
+static struct notifier_block clocksource_nb = {
+	.notifier_call	= clocksource_cpu_notify,
+	.priority = 1,
+};
+
 static inline void clocksource_start_watchdog(void)
 {
 	if (watchdog_running || !watchdog || list_empty(&watchdog_list))
 		return;
+	timer_cpu = cpumask_first(cpu_online_mask);
+	register_cpu_notifier(&clocksource_nb);
 	init_timer(&watchdog_timer);
 	watchdog_timer.function = clocksource_watchdog;
 	watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
-	add_timer_on(&watchdog_timer, cpumask_first(cpu_online_mask));
+	add_timer_on(&watchdog_timer, timer_cpu);
 	watchdog_running = 1;
 }
 
@@ -365,6 +407,7 @@ static inline void clocksource_stop_watchdog(void)
 	if (!watchdog_running || (watchdog && !list_empty(&watchdog_list)))
 		return;
 	del_timer(&watchdog_timer);
+	unregister_cpu_notifier(&clocksource_nb);
 	watchdog_running = 0;
 }
 
-- 
1.7.12.rc2.18.g61b472e

