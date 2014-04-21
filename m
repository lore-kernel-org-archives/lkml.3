Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaDUJ4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:56:25 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60952 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaDUJzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:55:54 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 05/19] tick: move definition of tick_get_device() to tick.h
Date: Mon, 21 Apr 2014 15:25:01 +0530
Message-Id: <2565ee70b249641746606702238580bd40b4e595.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are multiple users of tick_get_device() which are currently using
&per_cpu(tick_cpu_device, cpu) directly. Would be better if we use
tick_get_device() consistently. Move definition of tick_get_device() to tick.h
and update others to use it.

This change reduced size of bzImage for x86 by 96 bytes.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/tick.h         |  5 ++++-
 kernel/time/clockevents.c    |  6 +++---
 kernel/time/tick-broadcast.c | 12 ++++++------
 kernel/time/tick-common.c    |  9 ++-------
 4 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 1a9908a..45e1331 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -87,7 +87,10 @@ extern void __init tick_init(void);
 extern int tick_is_oneshot_available(void);
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
-extern struct tick_device *tick_get_device(int cpu);
+static inline struct tick_device *tick_get_device(int cpu)
+{
+	return &per_cpu(tick_cpu_device, cpu);
+}
 
 # ifdef CONFIG_HIGH_RES_TIMERS
 extern int tick_init_highres(void);
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 2ba812bc..a3e9333 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -326,7 +326,7 @@ static int __clockevents_try_unbind(struct clock_event_device *ced, int cpu)
 		return 0;
 	}
 
-	return ced == per_cpu(tick_cpu_device, cpu).evtdev ? -EAGAIN : -EBUSY;
+	return ced == tick_get_device(cpu)->evtdev ? -EAGAIN : -EBUSY;
 }
 
 /*
@@ -675,7 +675,7 @@ static struct device tick_bc_dev = {
 static struct tick_device *tick_get_tick_dev(struct device *dev)
 {
 	return dev == &tick_bc_dev ? tick_get_broadcast_device() :
-		&per_cpu(tick_cpu_device, dev->id);
+		tick_get_device(dev->id);
 }
 
 static __init int tick_broadcast_init_sysfs(void)
@@ -689,7 +689,7 @@ static __init int tick_broadcast_init_sysfs(void)
 #else
 static struct tick_device *tick_get_tick_dev(struct device *dev)
 {
-	return &per_cpu(tick_cpu_device, dev->id);
+	return tick_get_device(dev->id);
 }
 static inline int tick_broadcast_init_sysfs(void) { return 0; }
 #endif
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index b1c7b21..6289680 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -262,7 +262,7 @@ static void tick_do_broadcast(struct cpumask *mask)
 	 */
 	if (cpumask_test_cpu(cpu, mask)) {
 		cpumask_clear_cpu(cpu, mask);
-		td = &per_cpu(tick_cpu_device, cpu);
+		td = tick_get_device(cpu);
 		td->evtdev->event_handler(td->evtdev);
 	}
 
@@ -273,7 +273,7 @@ static void tick_do_broadcast(struct cpumask *mask)
 		 * one of the first device. This works as long as we have this
 		 * misfeature only on x86 (lapic)
 		 */
-		td = &per_cpu(tick_cpu_device, cpumask_first(mask));
+		td = tick_get_device(cpumask_first(mask));
 		td->evtdev->broadcast(mask);
 	}
 }
@@ -337,7 +337,7 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	cpu = smp_processor_id();
-	td = &per_cpu(tick_cpu_device, cpu);
+	td = tick_get_device(cpu);
 	dev = td->evtdev;
 	bc = tick_broadcast_device.evtdev;
 
@@ -581,7 +581,7 @@ again:
 	now = ktime_get();
 	/* Find all expired events */
 	for_each_cpu(cpu, tick_broadcast_oneshot_mask) {
-		td = &per_cpu(tick_cpu_device, cpu);
+		td = tick_get_device(cpu);
 		if (td->evtdev->next_event.tv64 <= now.tv64) {
 			cpumask_set_cpu(cpu, tmpmask);
 			/*
@@ -700,7 +700,7 @@ int tick_broadcast_oneshot_control(unsigned long reason)
 	 * idle code, so we can't be moved away.
 	 */
 	cpu = smp_processor_id();
-	td = &per_cpu(tick_cpu_device, cpu);
+	td = tick_get_device(cpu);
 	dev = td->evtdev;
 
 	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
@@ -824,7 +824,7 @@ static void tick_broadcast_init_next_event(struct cpumask *mask,
 	int cpu;
 
 	for_each_cpu(cpu, mask) {
-		td = &per_cpu(tick_cpu_device, cpu);
+		td = tick_get_device(cpu);
 		if (td->evtdev)
 			td->evtdev->next_event = expires;
 	}
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 0a0608e..3f3aa86 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -53,11 +53,6 @@ int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT;
 /*
  * Debugging: see timer_list.c
  */
-struct tick_device *tick_get_device(int cpu)
-{
-	return &per_cpu(tick_cpu_device, cpu);
-}
-
 /**
  * tick_is_oneshot_available - check for a oneshot capable event device
  */
@@ -296,7 +291,7 @@ void tick_check_new_device(struct clock_event_device *newdev)
 	if (!cpumask_test_cpu(cpu, newdev->cpumask))
 		goto out_bc;
 
-	td = &per_cpu(tick_cpu_device, cpu);
+	td = tick_get_device(cpu);
 	curdev = td->evtdev;
 
 	/* cpu local device ? */
@@ -356,7 +351,7 @@ void tick_handover_do_timer(int *cpup)
  */
 void tick_shutdown(unsigned int *cpup)
 {
-	struct tick_device *td = &per_cpu(tick_cpu_device, *cpup);
+	struct tick_device *td = tick_get_device(*cpup);
 	struct clock_event_device *dev = td->evtdev;
 
 	td->mode = TICKDEV_MODE_PERIODIC;
-- 
1.7.12.rc2.18.g61b472e

