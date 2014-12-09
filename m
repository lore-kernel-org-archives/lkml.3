Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbaLIDCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 22:02:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:8375 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418AbaLIDCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 22:02:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="426731250"
Message-ID: <54866625.8010406@linux.intel.com>
Date: Tue, 09 Dec 2014 11:01:57 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH v3]PM/Sleep: Timer quiesce in freeze state
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is based on v3.18.

Freeze is a general power saving state that processes are frozen, devices
are suspended and CPUs are in idle state. However, when the system enters
freeze state, there are a few timers keep ticking and hence consumes more
power unnecessarily. The observed timer events in freeze state are:
- tick_sched_timer
- watchdog lockup detector
- realtime scheduler period timer

The system power consumption in freeze state will be reduced significantly
if we quiesce these timers.

The patch is tested on:
- Sandybrdige-EP system, both RTC alarm and power button are able to wake
  the system up from freeze state.
- HP laptop EliteBook 8460p, both RTC alarm and power button are able to
  wake the system up from freeze state.
- Baytrail-T(ASUS_T100) platform, power button is able to wake the system
  up from freeze state.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/cpuidle/cpuidle.c   | 13 ++++++++
 include/linux/clockchips.h  |  4 +++
 include/linux/suspend.h     |  4 +++
 include/linux/timekeeping.h |  2 ++
 kernel/power/suspend.c      | 50 ++++++++++++++++++++++++++---
 kernel/sched/idle.c         | 45 ++++++++++++++++++++++++++
 kernel/softirq.c            |  5 +--
 kernel/time/clockevents.c   | 13 ++++++++
 kernel/time/tick-common.c   | 53 +++++++++++++++++++++++++++++++
 kernel/time/tick-internal.h |  3 ++
 kernel/time/timekeeping.c   | 77 +++++++++++++++++++++++++++++++++------------
 11 files changed, 243 insertions(+), 26 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 125150d..b9a3ada 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -20,6 +20,7 @@
 #include <linux/hrtimer.h>
 #include <linux/module.h>
 #include <trace/events/power.h>
+#include <linux/suspend.h>
 
 #include "cpuidle.h"
 
@@ -119,6 +120,18 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
 	ktime_t time_start, time_end;
 	s64 diff;
 
+	/*
+	 * under the freeze scenario, the timekeeping is suspended
+	 * as well as the clock source device, so we bypass the idle
+	 * counter update in freeze idle
+	 */
+	if (in_freeze()) {
+		entered_state = target_state->enter(dev, drv, index);
+		if (!cpuidle_state_is_coupled(dev, drv, entered_state))
+			local_irq_enable();
+		return entered_state;
+	}
+
 	trace_cpu_idle_rcuidle(index, dev->cpu);
 	time_start = ktime_get();
 
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 2e4cb67..d118e0b 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -18,6 +18,9 @@ enum clock_event_nofitiers {
 	CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
 	CLOCK_EVT_NOTIFY_SUSPEND,
 	CLOCK_EVT_NOTIFY_RESUME,
+	CLOCK_EVT_NOTIFY_FREEZE_PREPARE,
+	CLOCK_EVT_NOTIFY_FREEZE,
+	CLOCK_EVT_NOTIFY_UNFREEZE,
 	CLOCK_EVT_NOTIFY_CPU_DYING,
 	CLOCK_EVT_NOTIFY_CPU_DEAD,
 };
@@ -95,6 +98,7 @@ enum clock_event_mode {
  */
 struct clock_event_device {
 	void			(*event_handler)(struct clock_event_device *);
+	void			(*real_handler)(struct clock_event_device *);
 	int			(*set_next_event)(unsigned long evt,
 						  struct clock_event_device *);
 	int			(*set_next_ktime)(ktime_t expires,
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 3388c1b..86a651c 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -203,6 +203,8 @@ extern void suspend_set_ops(const struct platform_suspend_ops *ops);
 extern int suspend_valid_only_mem(suspend_state_t state);
 extern void freeze_set_ops(const struct platform_freeze_ops *ops);
 extern void freeze_wake(void);
+extern bool in_freeze(void);
+extern bool idle_should_freeze(void);
 
 /**
  * arch_suspend_disable_irqs - disable IRQs for suspend
@@ -230,6 +232,8 @@ static inline void suspend_set_ops(const struct platform_suspend_ops *ops) {}
 static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
 static inline void freeze_set_ops(const struct platform_freeze_ops *ops) {}
 static inline void freeze_wake(void) {}
+static inline bool in_freeze(void) { return false; }
+static inline bool idle_should_freeze(void) { return false; }
 #endif /* !CONFIG_SUSPEND */
 
 /* struct pbe is used for creating lists of pages that should be restored
diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 1caa6b0..07957a9 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -5,6 +5,8 @@
 
 void timekeeping_init(void);
 extern int timekeeping_suspended;
+extern void timekeeping_freeze(void);
+extern void timekeeping_unfreeze(void);
 
 /*
  * Get and set timeofday
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index c347e3c..6467fb8 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -28,6 +28,7 @@
 #include <linux/ftrace.h>
 #include <trace/events/power.h>
 #include <linux/compiler.h>
+#include <linux/clockchips.h>
 
 #include "power.h"
 
@@ -37,7 +38,15 @@ const char *pm_states[PM_SUSPEND_MAX];
 static const struct platform_suspend_ops *suspend_ops;
 static const struct platform_freeze_ops *freeze_ops;
 static DECLARE_WAIT_QUEUE_HEAD(suspend_freeze_wait_head);
-static bool suspend_freeze_wake;
+
+/* freeze state machine */
+enum freeze_state {
+	FREEZE_STATE_NONE,      /* not in freeze */
+	FREEZE_STATE_ENTER,     /* enter freeze */
+	FREEZE_STATE_WAKE,      /* in freeze wakeup context */
+};
+
+static enum freeze_state suspend_freeze_state;
 
 void freeze_set_ops(const struct platform_freeze_ops *ops)
 {
@@ -46,23 +55,56 @@ void freeze_set_ops(const struct platform_freeze_ops *ops)
 	unlock_system_sleep();
 }
 
+bool in_freeze(void)
+{
+	return (suspend_freeze_state > FREEZE_STATE_NONE);
+}
+EXPORT_SYMBOL_GPL(in_freeze);
+
+bool idle_should_freeze(void)
+{
+	return (suspend_freeze_state == FREEZE_STATE_ENTER);
+}
+EXPORT_SYMBOL_GPL(idle_should_freeze);
+
 static void freeze_begin(void)
 {
-	suspend_freeze_wake = false;
+	suspend_freeze_state = FREEZE_STATE_NONE;
 }
 
 static void freeze_enter(void)
 {
+	suspend_freeze_state = FREEZE_STATE_ENTER;
+	get_online_cpus();
 	cpuidle_use_deepest_state(true);
 	cpuidle_resume();
-	wait_event(suspend_freeze_wait_head, suspend_freeze_wake);
+	clockevents_notify(CLOCK_EVT_NOTIFY_FREEZE_PREPARE, NULL);
+	/*
+	 * push all the CPUs into freeze idle loop
+	 */
+	wake_up_all_idle_cpus();
+	printk(KERN_INFO "PM: suspend to idle\n");
+	/*
+	 * put the current CPU into wait queue so that this CPU
+	 * is able to enter freeze idle loop as well
+	 */
+	wait_event(suspend_freeze_wait_head,
+		(suspend_freeze_state == FREEZE_STATE_WAKE));
+	printk(KERN_INFO "PM: resume from freeze\n");
 	cpuidle_pause();
 	cpuidle_use_deepest_state(false);
+	put_online_cpus();
+	suspend_freeze_state = FREEZE_STATE_NONE;
 }
 
 void freeze_wake(void)
 {
-	suspend_freeze_wake = true;
+	if (!in_freeze())
+		return;
+	/*
+	 * wake freeze task up
+	 */
+	suspend_freeze_state = FREEZE_STATE_WAKE;
 	wake_up(&suspend_freeze_wait_head);
 }
 EXPORT_SYMBOL_GPL(freeze_wake);
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index c47fce7..f28f8cb 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -7,6 +7,7 @@
 #include <linux/tick.h>
 #include <linux/mm.h>
 #include <linux/stackprotector.h>
+#include <linux/suspend.h>
 
 #include <asm/tlb.h>
 
@@ -182,6 +183,45 @@ exit_idle:
 }
 
 /*
+ * cpu idle freeze function
+ */
+static void cpu_idle_freeze(void)
+{
+	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
+	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
+
+	/*
+	 * suspend tick, the last CPU suspend timekeeping
+	 */
+	clockevents_notify(CLOCK_EVT_NOTIFY_FREEZE, NULL);
+	/*
+	 * idle loop here if idle_should_freeze()
+	 */
+	while (idle_should_freeze()) {
+		int next_state;
+		/*
+		 * interrupt must be disabled before cpu enters idle
+		 */
+		local_irq_disable();
+
+		next_state = cpuidle_select(drv, dev);
+		if (next_state < 0) {
+			arch_cpu_idle();
+			continue;
+		}
+		/*
+		 * cpuidle_enter will return with interrupt enabled
+		 */
+		cpuidle_enter(drv, dev, next_state);
+	}
+
+	/*
+	 * resume tick, the first wakeup CPU resume timekeeping
+	 */
+	clockevents_notify(CLOCK_EVT_NOTIFY_UNFREEZE, NULL);
+}
+
+/*
  * Generic idle loop implementation
  *
  * Called with polling cleared.
@@ -208,6 +248,11 @@ static void cpu_idle_loop(void)
 			if (cpu_is_offline(smp_processor_id()))
 				arch_cpu_idle_dead();
 
+			if (idle_should_freeze()) {
+				cpu_idle_freeze();
+				continue;
+			}
+
 			local_irq_disable();
 			arch_cpu_idle_enter();
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 0699add..a231bf6 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -26,6 +26,7 @@
 #include <linux/smpboot.h>
 #include <linux/tick.h>
 #include <linux/irq.h>
+#include <linux/suspend.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/irq.h>
@@ -321,7 +322,7 @@ asmlinkage __visible void do_softirq(void)
 void irq_enter(void)
 {
 	rcu_irq_enter();
-	if (is_idle_task(current) && !in_interrupt()) {
+	if (is_idle_task(current) && !in_interrupt() && !in_freeze()) {
 		/*
 		 * Prevent raise_softirq from needlessly waking up ksoftirqd
 		 * here, as softirq will be serviced on return from interrupt.
@@ -364,7 +365,7 @@ static inline void tick_irq_exit(void)
 
 	/* Make sure that timer wheel updates are propagated */
 	if ((idle_cpu(cpu) && !need_resched()) || tick_nohz_full_cpu(cpu)) {
-		if (!in_interrupt())
+		if (!in_interrupt() && !in_freeze())
 			tick_nohz_irq_exit();
 	}
 #endif
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 5544990..6d9a4a3 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/smp.h>
 #include <linux/device.h>
+#include <linux/suspend.h>
 
 #include "tick-internal.h"
 
@@ -579,6 +580,18 @@ int clockevents_notify(unsigned long reason, void *arg)
 		tick_resume();
 		break;
 
+	case CLOCK_EVT_NOTIFY_FREEZE_PREPARE:
+		tick_freeze_prepare();
+		break;
+
+	case CLOCK_EVT_NOTIFY_FREEZE:
+		tick_freeze();
+		break;
+
+	case CLOCK_EVT_NOTIFY_UNFREEZE:
+		tick_unfreeze();
+		break;
+
 	case CLOCK_EVT_NOTIFY_CPU_DEAD:
 		tick_shutdown_broadcast_oneshot(arg);
 		tick_shutdown_broadcast(arg);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 7efeedf..0bbc886 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -19,6 +19,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/suspend.h>
 
 #include <asm/irq_regs.h>
 
@@ -51,6 +52,16 @@ ktime_t tick_period;
 int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT;
 
 /*
+ * Tick device is per CPU device, when we freeze the timekeeping stuff, we
+ * want to freeze the tick device on all of the online CPUs.
+ *
+ * tick_freeze_target_depth is a counter used for freezing tick device, the
+ * initial value of it is online CPU number. When it is counted down to ZERO,
+ * all of the tick devices are freezed.
+ */
+static unsigned int tick_freeze_target_depth;
+
+/*
  * Debugging: see timer_list.c
  */
 struct tick_device *tick_get_device(int cpu)
@@ -375,15 +386,21 @@ void tick_shutdown(unsigned int *cpup)
 void tick_suspend(void)
 {
 	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
+	struct clock_event_device *dev = td->evtdev;
 
+	dev->real_handler = dev->event_handler;
+	dev->event_handler = clockevents_handle_noop;
 	clockevents_shutdown(td->evtdev);
 }
 
 void tick_resume(void)
 {
 	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
+	struct clock_event_device *dev = td->evtdev;
 	int broadcast = tick_resume_broadcast();
 
+	dev->event_handler = dev->real_handler;
+	dev->real_handler = NULL;
 	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME);
 
 	if (!broadcast) {
@@ -394,6 +411,42 @@ void tick_resume(void)
 	}
 }
 
+void tick_freeze_prepare(void)
+{
+	tick_freeze_target_depth = num_online_cpus();
+}
+
+void tick_freeze(void)
+{
+	/*
+	 * This is serialized against a concurrent wakeup
+	 * via clockevents_lock
+	 */
+	tick_freeze_target_depth--;
+	tick_suspend();
+
+	/*
+	 * the last tick_suspend CPU suspends timekeeping
+	 */
+	if (!tick_freeze_target_depth)
+		timekeeping_freeze();
+}
+
+void tick_unfreeze(void)
+{
+	/*
+	 * the first wakeup CPU resumes timekeeping
+	 */
+	if (timekeeping_suspended) {
+		timekeeping_unfreeze();
+		touch_softlockup_watchdog();
+		tick_resume();
+		hrtimers_resume();
+	} else {
+		tick_resume();
+	}
+}
+
 /**
  * tick_init - initialize the tick control
  */
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 366aeb4..8b5bab6 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -27,6 +27,9 @@ extern void tick_handover_do_timer(int *cpup);
 extern void tick_shutdown(unsigned int *cpup);
 extern void tick_suspend(void);
 extern void tick_resume(void);
+extern void tick_freeze_prepare(void);
+extern void tick_freeze(void);
+extern void tick_unfreeze(void);
 extern bool tick_check_replacement(struct clock_event_device *curdev,
 				   struct clock_event_device *newdev);
 extern void tick_install_replacement(struct clock_event_device *dev);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ec1791f..a11065f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1107,14 +1107,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	clock_was_set();
 }
 
-/**
- * timekeeping_resume - Resumes the generic timekeeping subsystem.
- *
- * This is for the generic clocksource timekeeping.
- * xtime/wall_to_monotonic/jiffies/etc are
- * still managed by arch specific suspend/resume code.
- */
-static void timekeeping_resume(void)
+static void timekeeping_resume_compensate_time(void)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
 	struct clocksource *clock = tk->tkr.clock;
@@ -1127,9 +1120,6 @@ static void timekeeping_resume(void)
 	read_persistent_clock(&tmp);
 	ts_new = timespec_to_timespec64(tmp);
 
-	clockevents_resume();
-	clocksource_resume();
-
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&tk_core.seq);
 
@@ -1186,16 +1176,9 @@ static void timekeeping_resume(void)
 	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
 	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
-
-	touch_softlockup_watchdog();
-
-	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
-
-	/* Resume hrtimers */
-	hrtimers_resume();
 }
 
-static int timekeeping_suspend(void)
+static void timekeeping_suspend_get_time(void)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long flags;
@@ -1242,11 +1225,65 @@ static int timekeeping_suspend(void)
 	timekeeping_update(tk, TK_MIRROR);
 	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
+}
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+/*
+ * The following operations:
+ *	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+ *	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
+ * are moved out of
+ *	timekeeping_freeze() and timekeeping_unfreeze()
+ * and, replaced by
+ *	tick_suspend() and tick_resume()
+ * and, put into:
+ *	tick_freeze() and tick_unfreeze()
+ * so we avoid clockevents_lock multiple access
+ */
+void timekeeping_freeze(void)
+{
+	/*
+	 * clockevents_lock being held
+	 */
+	timekeeping_suspend_get_time();
 	clocksource_suspend();
 	clockevents_suspend();
+}
 
+void timekeeping_unfreeze(void)
+{
+	/*
+	 * clockevents_lock being held
+	 */
+	clockevents_resume();
+	clocksource_resume();
+	timekeeping_resume_compensate_time();
+}
+
+/**
+ * timekeeping_resume - Resumes the generic timekeeping subsystem.
+ *
+ * This is for the generic clocksource timekeeping.
+ * xtime/wall_to_monotonic/jiffies/etc are
+ * still managed by arch specific suspend/resume code.
+ */
+static void timekeeping_resume(void)
+{
+	clockevents_resume();
+	clocksource_resume();
+	timekeeping_resume_compensate_time();
+
+	touch_softlockup_watchdog();
+	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
+	/* Resume hrtimers */
+	hrtimers_resume();
+}
+
+static int timekeeping_suspend(void)
+{
+	timekeeping_suspend_get_time();
+	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+	clocksource_suspend();
+	clockevents_suspend();
 	return 0;
 }
 
-- 
1.9.1
