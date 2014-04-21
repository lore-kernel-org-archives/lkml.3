Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaDUJ4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:56:31 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:33080 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaDUJ4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:56:00 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 06/19] tick: create tick_get_cpu_device() to get tick_cpu_device on this cpu
Date: Mon, 21 Apr 2014 15:25:02 +0530
Message-Id: <15f918abab2959e9addd7f66d13e4f4ed821dd7d.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are using &__get_cpu_var(tick_cpu_device) at several places and would be
better if we create tick_get_cpu_device() and use it instead.

This also converts tick_get_device(smp_processor_id()) to use
tick_get_cpu_device().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/tick.h         |  5 +++++
 kernel/hrtimer.c             |  2 +-
 kernel/time/tick-broadcast.c |  8 ++++----
 kernel/time/tick-common.c    | 10 +++++-----
 kernel/time/tick-oneshot.c   |  8 ++++----
 kernel/time/tick-sched.c     |  2 +-
 6 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 45e1331..98065e5 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -92,6 +92,11 @@ static inline struct tick_device *tick_get_device(int cpu)
 	return &per_cpu(tick_cpu_device, cpu);
 }
 
+static inline struct tick_device *tick_get_cpu_device(void)
+{
+	return &__get_cpu_var(tick_cpu_device);
+}
+
 # ifdef CONFIG_HIGH_RES_TIMERS
 extern int tick_init_highres(void);
 extern int tick_program_event(ktime_t expires, int force);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index d55092c..393f422 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1403,7 +1403,7 @@ static void __hrtimer_peek_ahead_timers(void)
 	if (!hrtimer_hres_active())
 		return;
 
-	td = &__get_cpu_var(tick_cpu_device);
+	td = tick_get_cpu_device();
 	if (td && td->evtdev)
 		hrtimer_interrupt(td->evtdev);
 }
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 6289680..bf289cd 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -235,7 +235,7 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 int tick_receive_broadcast(void)
 {
-	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
+	struct tick_device *td = tick_get_cpu_device();
 	struct clock_event_device *evt = td->evtdev;
 
 	if (!evt)
@@ -337,7 +337,7 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	cpu = smp_processor_id();
-	td = tick_get_device(cpu);
+	td = tick_get_cpu_device();
 	dev = td->evtdev;
 	bc = tick_broadcast_device.evtdev;
 
@@ -550,7 +550,7 @@ int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 void tick_check_oneshot_broadcast_this_cpu(void)
 {
 	if (cpumask_test_cpu(smp_processor_id(), tick_broadcast_oneshot_mask)) {
-		struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+		struct tick_device *td = tick_get_cpu_device();
 
 		/*
 		 * We might be in the middle of switching over from
@@ -700,7 +700,7 @@ int tick_broadcast_oneshot_control(unsigned long reason)
 	 * idle code, so we can't be moved away.
 	 */
 	cpu = smp_processor_id();
-	td = tick_get_device(cpu);
+	td = tick_get_cpu_device();
 	dev = td->evtdev;
 
 	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 3f3aa86..1e2c96e 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -58,7 +58,7 @@ int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT;
  */
 int tick_is_oneshot_available(void)
 {
-	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
+	struct clock_event_device *dev = tick_get_cpu_device()->evtdev;
 
 	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT))
 		return 0;
@@ -219,7 +219,7 @@ static void tick_setup_device(struct tick_device *td,
 
 void tick_install_replacement(struct clock_event_device *newdev)
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = tick_get_cpu_device();
 	int cpu = smp_processor_id();
 
 	clockevents_exchange_device(td->evtdev, newdev);
@@ -291,7 +291,7 @@ void tick_check_new_device(struct clock_event_device *newdev)
 	if (!cpumask_test_cpu(cpu, newdev->cpumask))
 		goto out_bc;
 
-	td = tick_get_device(cpu);
+	td = tick_get_cpu_device();
 	curdev = td->evtdev;
 
 	/* cpu local device ? */
@@ -369,14 +369,14 @@ void tick_shutdown(unsigned int *cpup)
 
 void tick_suspend(void)
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = tick_get_cpu_device();
 
 	clockevents_shutdown(td->evtdev);
 }
 
 void tick_resume(void)
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = tick_get_cpu_device();
 	int broadcast = tick_resume_broadcast();
 
 	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME);
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 5fe86a7..7089dea 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -26,7 +26,7 @@
  */
 int tick_program_event(ktime_t expires, int force)
 {
-	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
+	struct clock_event_device *dev = tick_get_cpu_device()->evtdev;
 
 	return clockevents_program_event(dev, expires, force);
 }
@@ -36,7 +36,7 @@ int tick_program_event(ktime_t expires, int force)
  */
 void tick_resume_oneshot(void)
 {
-	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
+	struct clock_event_device *dev = tick_get_cpu_device()->evtdev;
 
 	clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
 	clockevents_program_event(dev, ktime_get(), true);
@@ -59,7 +59,7 @@ void tick_setup_oneshot(struct clock_event_device *newdev,
  */
 int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *))
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = tick_get_cpu_device();
 	struct clock_event_device *dev = td->evtdev;
 
 	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT) ||
@@ -96,7 +96,7 @@ int tick_oneshot_mode_active(void)
 	int ret;
 
 	local_irq_save(flags);
-	ret = __this_cpu_read(tick_cpu_device.mode) == TICKDEV_MODE_ONESHOT;
+	ret = tick_get_cpu_device()->mode == TICKDEV_MODE_ONESHOT;
 	local_irq_restore(flags);
 
 	return ret;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9e9ddba..5f27c71 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -536,7 +536,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
 	ktime_t last_update, expires, ret = { .tv64 = 0 };
 	unsigned long rcu_delta_jiffies;
-	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
+	struct clock_event_device *dev = tick_get_cpu_device()->evtdev;
 	u64 time_delta;
 
 	time_delta = timekeeping_max_deferment();
-- 
1.7.12.rc2.18.g61b472e

