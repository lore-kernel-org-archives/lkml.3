Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaDUJ4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:56:07 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54755 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaDUJza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:55:30 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 01/19] tick: trivial cleanups
Date: Mon, 21 Apr 2014 15:24:57 +0530
Message-Id: <f3f95d6a68a1d3aec3a30c2384848a06ad32459b.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This does some trivial fixups:
- break lines longer than 80 columns
- merge few lines together
- don't break print messages even if they cross 80 columns
- remove extra whitespaces and blank lines
- replace printk() with pr_*()

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/tick.h         |  3 ++-
 kernel/time/clockevents.c    |  4 ++--
 kernel/time/clocksource.c    | 14 +++++---------
 kernel/time/tick-broadcast.c | 16 ++++++----------
 kernel/time/tick-internal.h  |  5 ++++-
 kernel/time/tick-oneshot.c   |  3 +--
 kernel/time/tick-sched.c     | 29 ++++++++++++++++-------------
 kernel/time/timekeeping.c    | 10 ++++------
 8 files changed, 40 insertions(+), 44 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b84773c..8c865fb 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -47,7 +47,8 @@ enum tick_nohz_mode {
  * @idle_waketime:	Time when the idle was interrupted
  * @idle_exittime:	Time when the idle state was left
  * @idle_sleeptime:	Sum of the time slept in idle with sched tick stopped
- * @iowait_sleeptime:	Sum of the time slept in idle with sched tick stopped, with IO outstanding
+ * @iowait_sleeptime:	Sum of the time slept in idle with sched tick stopped,
+ *			with IO outstanding
  * @sleep_length:	Duration of the current idle sleep
  * @do_timer_lst:	CPU was the last one doing do_timer before going idle
  */
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index ad362c2..2ba812bc 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -146,7 +146,7 @@ static int clockevents_increase_min_delta(struct clock_event_device *dev)
 {
 	/* Nothing to do if we already reached the limit */
 	if (dev->min_delta_ns >= MIN_DELTA_LIMIT) {
-		printk(KERN_WARNING "CE: Reprogramming failure. Giving up\n");
+		pr_warn("CE: Reprogramming failure. Giving up\n");
 		dev->next_event.tv64 = KTIME_MAX;
 		return -ETIME;
 	}
@@ -159,7 +159,7 @@ static int clockevents_increase_min_delta(struct clock_event_device *dev)
 	if (dev->min_delta_ns > MIN_DELTA_LIMIT)
 		dev->min_delta_ns = MIN_DELTA_LIMIT;
 
-	printk(KERN_WARNING "CE: %s increased min_delta_ns to %llu nsec\n",
+	pr_warn("CE: %s increased min_delta_ns to %llu nsec\n",
 	       dev->name ? dev->name : "?",
 	       (unsigned long long) dev->min_delta_ns);
 	return 0;
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ba3e502..6ef39af 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -219,8 +219,7 @@ static void __clocksource_unstable(struct clocksource *cs)
 
 static void clocksource_unstable(struct clocksource *cs, int64_t delta)
 {
-	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
-	       cs->name, delta);
+	pr_warn("Clocksource %s unstable (delta = %Ld ns)\n", cs->name, delta);
 	__clocksource_unstable(cs);
 }
 
@@ -643,9 +642,8 @@ static void __clocksource_select(bool skipcur)
 		 */
 		if (!(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES) && oneshot) {
 			/* Override clocksource cannot be used. */
-			printk(KERN_WARNING "Override clocksource %s is not "
-			       "HRT compatible. Cannot switch while in "
-			       "HRT/NOHZ mode\n", cs->name);
+			pr_warn("Override clocksource %s is not HRT compatible. Cannot switch while in HRT/NOHZ mode\n",
+				cs->name);
 			override_name[0] = 0;
 		} else
 			/* Override clocksource can be used. */
@@ -1095,12 +1093,10 @@ __setup("clocksource=", boot_override_clocksource);
 static int __init boot_override_clock(char* str)
 {
 	if (!strcmp(str, "pmtmr")) {
-		printk("Warning: clock=pmtmr is deprecated. "
-			"Use clocksource=acpi_pm.\n");
+		printk("Warning: clock=pmtmr is deprecated. Use clocksource=acpi_pm.\n");
 		return boot_override_clocksource("acpi_pm");
 	}
-	printk("Warning! clock= boot option is deprecated. "
-		"Use clocksource=xyz\n");
+	printk("Warning! clock= boot option is deprecated. Use clocksource=xyz\n");
 	return boot_override_clocksource(str);
 }
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 64c5990..b1c7b21 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -132,7 +132,6 @@ int tick_broadcast_update_freq(struct clock_event_device *dev, u32 freq)
 	return ret;
 }
 
-
 static void err_broadcast(const struct cpumask *mask)
 {
 	pr_crit_once("Failed to broadcast timer tick. Some CPUs may be unresponsive.\n");
@@ -358,8 +357,7 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
 		cpumask_set_cpu(cpu, tick_broadcast_on);
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_mask)) {
-			if (tick_broadcast_device.mode ==
-			    TICKDEV_MODE_PERIODIC)
+			if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
 				clockevents_shutdown(dev);
 		}
 		if (*reason == CLOCK_EVT_NOTIFY_BROADCAST_FORCE)
@@ -372,8 +370,7 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 		if (!tick_device_is_functional(dev))
 			break;
 		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_mask)) {
-			if (tick_broadcast_device.mode ==
-			    TICKDEV_MODE_PERIODIC)
+			if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);
 		}
 		break;
@@ -399,8 +396,8 @@ out:
 void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 {
 	if (!cpumask_test_cpu(*oncpu, cpu_online_mask))
-		printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
-		       "offline CPU #%d\n", *oncpu);
+		pr_err("tick-broadcast: ignoring broadcast for offline CPU #%d\n",
+		       *oncpu);
 	else
 		tick_do_broadcast_on_off(&reason);
 }
@@ -484,7 +481,6 @@ int tick_resume_broadcast(void)
 	return broadcast;
 }
 
-
 #ifdef CONFIG_TICK_ONESHOT
 
 static cpumask_var_t tick_broadcast_oneshot_mask;
@@ -727,7 +723,8 @@ int tick_broadcast_oneshot_control(unsigned long reason)
 			 */
 			if (!cpumask_test_cpu(cpu, tick_broadcast_force_mask) &&
 			    dev->next_event.tv64 < bc->next_event.tv64)
-				tick_broadcast_set_event(bc, cpu, dev->next_event, 1);
+				tick_broadcast_set_event(bc, cpu,
+							 dev->next_event, 1);
 		}
 		/*
 		 * If the current CPU owns the hrtimer broadcast
@@ -894,7 +891,6 @@ void tick_broadcast_switch_to_oneshot(void)
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
-
 /*
  * Remove a dead CPU from broadcasting
  */
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 7ab92b1..855c513 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -87,7 +87,10 @@ static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
 	BUG();
 }
-static inline int tick_broadcast_oneshot_control(unsigned long reason) { return 0; }
+static inline int tick_broadcast_oneshot_control(unsigned long reason)
+{
+	return 0;
+}
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 8241090..5fe86a7 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -65,8 +65,7 @@ int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *))
 	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT) ||
 		    !tick_device_is_functional(dev)) {
 
-		printk(KERN_INFO "Clockevents: "
-		       "could not switch to one-shot mode:");
+		pr_info("Clockevents: could not switch to one-shot mode:");
 		if (!dev) {
 			printk(" no tick device\n");
 		} else {
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6558b7a..9e9ddba 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -108,7 +108,6 @@ static ktime_t tick_init_jiffy_update(void)
 	return period;
 }
 
-
 static void tick_sched_do_timer(ktime_t now)
 {
 	int cpu = smp_processor_id();
@@ -248,8 +247,8 @@ void tick_nohz_full_kick_all(void)
 		return;
 
 	preempt_disable();
-	smp_call_function_many(tick_nohz_full_mask,
-			       nohz_full_kick_ipi, NULL, false);
+	smp_call_function_many(tick_nohz_full_mask, nohz_full_kick_ipi, NULL,
+			       false);
 	tick_nohz_full_kick();
 	preempt_enable();
 }
@@ -288,7 +287,8 @@ static int __init tick_nohz_full_setup(char *str)
 
 	cpu = smp_processor_id();
 	if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
-		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n", cpu);
+		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n",
+			   cpu);
 		cpumask_clear_cpu(cpu, tick_nohz_full_mask);
 	}
 	tick_nohz_full_running = true;
@@ -298,8 +298,7 @@ static int __init tick_nohz_full_setup(char *str)
 __setup("nohz_full=", tick_nohz_full_setup);
 
 static int tick_nohz_cpu_down_callback(struct notifier_block *nfb,
-						 unsigned long action,
-						 void *hcpu)
+				       unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 
@@ -353,7 +352,8 @@ void __init tick_nohz_init(void)
 		context_tracking_cpu_set(cpu);
 
 	cpu_notifier(tick_nohz_cpu_down_callback, 0);
-	cpulist_scnprintf(nohz_full_buf, sizeof(nohz_full_buf), tick_nohz_full_mask);
+	cpulist_scnprintf(nohz_full_buf, sizeof(nohz_full_buf),
+			  tick_nohz_full_mask);
 	pr_info("NO_HZ: Full dynticks CPUs: %s.\n", nohz_full_buf);
 }
 #endif
@@ -365,8 +365,8 @@ void __init tick_nohz_init(void)
 /*
  * NO HZ enabled ?
  */
-static int tick_nohz_enabled __read_mostly  = 1;
-int tick_nohz_active  __read_mostly;
+static int tick_nohz_enabled __read_mostly = 1;
+int tick_nohz_active __read_mostly;
 /*
  * Enable / Disable tickless mode
  */
@@ -410,16 +410,19 @@ static void tick_nohz_update_jiffies(ktime_t now)
  * Updates the per cpu time idle statistics counters
  */
 static void
-update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now, u64 *last_update_time)
+update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now,
+		     u64 *last_update_time)
 {
 	ktime_t delta;
 
 	if (ts->idle_active) {
 		delta = ktime_sub(now, ts->idle_entrytime);
 		if (nr_iowait_cpu(cpu) > 0)
-			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
+			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime,
+							 delta);
 		else
-			ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+			ts->idle_sleeptime = ktime_add(ts->idle_sleeptime,
+						       delta);
 		ts->idle_entrytime = now;
 	}
 
@@ -876,7 +879,7 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 	/*
 	 * Cancel the scheduled timer and restore the tick
 	 */
-	ts->tick_stopped  = 0;
+	ts->tick_stopped = 0;
 	ts->idle_exittime = now;
 
 	tick_nohz_restart(ts, now);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f7df8ea..8e547b5 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -852,8 +852,7 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
 							struct timespec *delta)
 {
 	if (!timespec_valid_strict(delta)) {
-		printk(KERN_WARNING "__timekeeping_inject_sleeptime: Invalid "
-					"sleep delta value!\n");
+		pr_warn("__timekeeping_inject_sleeptime: Invalid sleep delta value!\n");
 		return;
 	}
 	tk_xtime_add(tk, delta);
@@ -1157,10 +1156,9 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 
 	if (unlikely(tk->clock->maxadj &&
 		(tk->mult + adj > tk->clock->mult + tk->clock->maxadj))) {
-		printk_once(KERN_WARNING
-			"Adjusting %s more than 11%% (%ld vs %ld)\n",
-			tk->clock->name, (long)tk->mult + adj,
-			(long)tk->clock->mult + tk->clock->maxadj);
+		pr_warn_once("Adjusting %s more than 11%% (%ld vs %ld)\n",
+			     tk->clock->name, (long)tk->mult + adj,
+			     (long)tk->clock->mult + tk->clock->maxadj);
 	}
 	/*
 	 * So the following can be confusing.
-- 
1.7.12.rc2.18.g61b472e

