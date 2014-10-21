Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbaJUTA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:00:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:16869 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932679AbaJUTAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:00:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,762,1406617200"; 
   d="scan'208";a="593124154"
Message-ID: <5446787E.60202@linux.intel.com>
Date: Tue, 21 Oct 2014 23:15:10 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: peterz@infradead.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: [RFC/PATCH] PM / Sleep: Timer quiesce in freeze state
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is based on v3.17, merged with Rafael's pm+acpi-3.18-rc1 tag from
linux-pm.git tree.

The patch is based on the patch PeterZ initially wrote.
---
Freeze is a general power saving state that processes are frozen, devices
are suspended and CPUs are in idle state. However, when the system enters
freeze state, there are a few timers keep ticking and hence consumes more
power unnecessarily. The observed timer events in freeze state are:
- tick_sched_timer
- watchdog lockup detector
- realtime scheduler period timer

The system power consumption in freeze state will be reduced significantly
if we quiesce these timers.

On Baytrail-T(ASUS_T100) platform, when the system is freezed to low power
idle state(S0ix), quiescing these timers saves 29.8% power(94.48mw -> 66.32mw).

The patch is also tested on:
- Sandybrdige-EP system, both RTC alarm and power button are able to wake
  the system up from freeze state.
- HP laptop EliteBook 8460p, both RTC alarm and power button are able to
  wake the system up from freeze state.

Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Alan Cox <alan@linux.intel.com>
---
 arch/x86/kernel/apic/apic.c        |   8 ++
 drivers/cpuidle/cpuidle.c          |  12 +++
 kernel/power/suspend.c             | 175 +++++++++++++++++++++++++++++++++++--
 kernel/time/timekeeping.c          |   4 +-
 kernel/time/timekeeping_internal.h |   3 +
 5 files changed, 193 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 6776027..f2bb645 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -917,6 +917,14 @@ static void local_apic_timer_interrupt(void)
 	 */
 	inc_irq_stat(apic_timer_irqs);
 
+	/*
+	 * if timekeeping is suspended, the clock event device will be
+	 * suspended as well, so we are not supposed to invoke the event
+	 * handler of clock event device.
+	 */
+	if (unlikely(timekeeping_suspended))
+		return;
+
 	evt->event_handler(evt);
 }
 
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index ee9df5e..8f84f40 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -119,6 +119,18 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
 	ktime_t time_start, time_end;
 	s64 diff;
 
+	/*
+	 * under the scenario of use deepest idle state, the timekeeping
+	 * could be suspended as well as the clock source device, so we
+	 * bypass the idle counter update for this case
+	 */
+	if (unlikely(use_deepest_state)) {
+		entered_state = target_state->enter(dev, drv, index);
+		if (!cpuidle_state_is_coupled(dev, drv, entered_state))
+			local_irq_enable();
+		return entered_state;
+	}
+
 	trace_cpu_idle_rcuidle(index, dev->cpu);
 	time_start = ktime_get();
 
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 4ca9a33..e58d880 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -28,16 +28,20 @@
 #include <linux/ftrace.h>
 #include <trace/events/power.h>
 #include <linux/compiler.h>
+#include <linux/stop_machine.h>
+#include <linux/clockchips.h>
+#include <linux/hrtimer.h>
 
 #include "power.h"
+#include "../time/tick-internal.h"
+#include "../time/timekeeping_internal.h"
 
 const char *pm_labels[] = { "mem", "standby", "freeze", NULL };
 const char *pm_states[PM_SUSPEND_MAX];
 
 static const struct platform_suspend_ops *suspend_ops;
 static const struct platform_freeze_ops *freeze_ops;
-static DECLARE_WAIT_QUEUE_HEAD(suspend_freeze_wait_head);
-static bool suspend_freeze_wake;
+static int suspend_freeze_wake;
 
 void freeze_set_ops(const struct platform_freeze_ops *ops)
 {
@@ -48,22 +52,179 @@ void freeze_set_ops(const struct platform_freeze_ops *ops)
 
 static void freeze_begin(void)
 {
-	suspend_freeze_wake = false;
+	suspend_freeze_wake = -1;
 }
 
-static void freeze_enter(void)
+enum freezer_state {
+	FREEZER_NONE,
+	FREEZER_PICK_TK,
+	FREEZER_SUSPEND_CLKEVT,
+	FREEZER_SUSPEND_TK,
+	FREEZER_IDLE,
+	FREEZER_RESUME_TK,
+	FREEZER_RESUME_CLKEVT,
+	FREEZER_EXIT,
+};
+
+struct freezer_data {
+	int			thread_num;
+	atomic_t		thread_ack;
+	enum freezer_state	state;
+};
+
+static void set_state(struct freezer_data *fd, enum freezer_state state)
+{
+	/* set ack counter */
+	atomic_set(&fd->thread_ack, fd->thread_num);
+	/* guarantee the write ordering between ack counter and state */
+	smp_wmb();
+	fd->state = state;
+}
+
+static void ack_state(struct freezer_data *fd)
+{
+	if (atomic_dec_and_test(&fd->thread_ack))
+		set_state(fd, fd->state + 1);
+}
+
+static void freezer_pick_tk(int cpu)
+{
+	if (tick_do_timer_cpu == TICK_DO_TIMER_NONE) {
+		static DEFINE_SPINLOCK(lock);
+
+		spin_lock(&lock);
+		if (tick_do_timer_cpu == TICK_DO_TIMER_NONE)
+			tick_do_timer_cpu = cpu;
+		spin_unlock(&lock);
+	}
+}
+
+static void freezer_suspend_clkevt(int cpu)
+{
+	if (tick_do_timer_cpu == cpu)
+		return;
+
+	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+}
+
+static void freezer_suspend_tk(int cpu)
 {
+	if (tick_do_timer_cpu != cpu)
+		return;
+
+	timekeeping_suspend();
+
 	cpuidle_use_deepest_state(true);
 	cpuidle_resume();
-	wait_event(suspend_freeze_wait_head, suspend_freeze_wake);
+}
+
+static void freezer_idle(int cpu)
+{
+	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
+	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
+
+	stop_critical_timings();
+
+	while (suspend_freeze_wake == -1) {
+		int next_state;
+
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
+	if (suspend_freeze_wake == cpu)
+		kick_all_cpus_sync();
+
+	start_critical_timings();
+}
+
+static void freezer_resume_tk(int cpu)
+{
+	if (tick_do_timer_cpu != cpu)
+		return;
+
 	cpuidle_pause();
 	cpuidle_use_deepest_state(false);
+
+	local_irq_disable();
+	timekeeping_resume();
+	local_irq_enable();
+}
+
+static void freezer_resume_clkevt(int cpu)
+{
+	if (tick_do_timer_cpu == cpu)
+		return;
+
+	touch_softlockup_watchdog();
+	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
+	local_irq_disable();
+	hrtimers_resume();
+	local_irq_enable();
+}
+
+typedef void (*freezer_fn)(int);
+
+static freezer_fn freezer_func[FREEZER_EXIT] = {
+	NULL,
+	freezer_pick_tk,
+	freezer_suspend_clkevt,
+	freezer_suspend_tk,
+	freezer_idle,
+	freezer_resume_tk,
+	freezer_resume_clkevt,
+};
+
+static int freezer_stopper_fn(void *arg)
+{
+	struct freezer_data *fd = arg;
+	enum freezer_state state = FREEZER_NONE;
+	int cpu = smp_processor_id();
+
+	do {
+		cpu_relax();
+		if (fd->state != state) {
+			state = fd->state;
+			if (freezer_func[state])
+				(*freezer_func[state])(cpu);
+			ack_state(fd);
+		}
+	} while (fd->state != FREEZER_EXIT);
+
+	return 0;
+}
+
+static void freeze_enter(void)
+{
+	struct freezer_data fd;
+
+	get_online_cpus();
+
+	fd.thread_num = num_online_cpus();
+	set_state(&fd, FREEZER_PICK_TK);
+
+	__stop_machine(freezer_stopper_fn, &fd, cpu_online_mask);
+
+	put_online_cpus();
 }
 
 void freeze_wake(void)
 {
-	suspend_freeze_wake = true;
-	wake_up(&suspend_freeze_wait_head);
+	if (suspend_freeze_wake != -1)
+		return;
+	suspend_freeze_wake = smp_processor_id();
 }
 EXPORT_SYMBOL_GPL(freeze_wake);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ec1791f..23d8feb 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1114,7 +1114,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
  * xtime/wall_to_monotonic/jiffies/etc are
  * still managed by arch specific suspend/resume code.
  */
-static void timekeeping_resume(void)
+void timekeeping_resume(void)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
 	struct clocksource *clock = tk->tkr.clock;
@@ -1195,7 +1195,7 @@ static void timekeeping_resume(void)
 	hrtimers_resume();
 }
 
-static int timekeeping_suspend(void)
+int timekeeping_suspend(void)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long flags;
diff --git a/kernel/time/timekeeping_internal.h b/kernel/time/timekeeping_internal.h
index 4ea005a..ed7a574 100644
--- a/kernel/time/timekeeping_internal.h
+++ b/kernel/time/timekeeping_internal.h
@@ -26,4 +26,7 @@ static inline cycle_t clocksource_delta(cycle_t now, cycle_t last, cycle_t mask)
 }
 #endif
 
+extern int timekeeping_suspend(void);
+extern void timekeeping_resume(void);
+
 #endif /* _TIMEKEEPING_INTERNAL_H */
-- 
1.9.1
