Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab3CFLSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:18:42 -0500
Received: from www.linutronix.de ([62.245.132.108]:42497 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab3CFLSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:18:36 -0500
Message-Id: <20130306111537.366394000@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 06 Mar 2013 11:18:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Arjan van de Veen <arjan@infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jason Liu <liu.h.jason@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 2/7] tick: Convert broadcast cpu bitmaps to cpumask_var_t
References: <20130306111351.883117670@linutronix.de>
Content-Disposition: inline; filename=tick-broadcast-convert-to-cpumask-t.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/time/tick-broadcast.c |   86 +++++++++++++++++++++----------------------
 kernel/time/tick-common.c    |    1 
 kernel/time/tick-internal.h  |    3 +
 3 files changed, 46 insertions(+), 44 deletions(-)

Index: tip/kernel/time/tick-broadcast.c
===================================================================
--- tip.orig/kernel/time/tick-broadcast.c
+++ tip/kernel/time/tick-broadcast.c
@@ -28,9 +28,8 @@
  */
 
 static struct tick_device tick_broadcast_device;
-/* FIXME: Use cpumask_var_t. */
-static DECLARE_BITMAP(tick_broadcast_mask, NR_CPUS);
-static DECLARE_BITMAP(tmpmask, NR_CPUS);
+static cpumask_var_t tick_broadcast_mask;
+static cpumask_var_t tmpmask;
 static DEFINE_RAW_SPINLOCK(tick_broadcast_lock);
 static int tick_broadcast_force;
 
@@ -50,7 +49,7 @@ struct tick_device *tick_get_broadcast_d
 
 struct cpumask *tick_get_broadcast_mask(void)
 {
-	return to_cpumask(tick_broadcast_mask);
+	return tick_broadcast_mask;
 }
 
 /*
@@ -74,7 +73,7 @@ int tick_check_broadcast_device(struct c
 
 	clockevents_exchange_device(tick_broadcast_device.evtdev, dev);
 	tick_broadcast_device.evtdev = dev;
-	if (!cpumask_empty(tick_get_broadcast_mask()))
+	if (!cpumask_empty(tick_broadcast_mask))
 		tick_broadcast_start_periodic(dev);
 	return 1;
 }
@@ -123,7 +122,7 @@ int tick_device_uses_broadcast(struct cl
 	if (!tick_device_is_functional(dev)) {
 		dev->event_handler = tick_handle_periodic;
 		tick_device_setup_broadcast_func(dev);
-		cpumask_set_cpu(cpu, tick_get_broadcast_mask());
+		cpumask_set_cpu(cpu, tick_broadcast_mask);
 		tick_broadcast_start_periodic(tick_broadcast_device.evtdev);
 		ret = 1;
 	} else {
@@ -134,7 +133,7 @@ int tick_device_uses_broadcast(struct cl
 		 */
 		if (!(dev->features & CLOCK_EVT_FEAT_C3STOP)) {
 			int cpu = smp_processor_id();
-			cpumask_clear_cpu(cpu, tick_get_broadcast_mask());
+			cpumask_clear_cpu(cpu, tick_broadcast_mask);
 			tick_broadcast_clear_oneshot(cpu);
 		} else {
 			tick_device_setup_broadcast_func(dev);
@@ -198,9 +197,8 @@ static void tick_do_periodic_broadcast(v
 {
 	raw_spin_lock(&tick_broadcast_lock);
 
-	cpumask_and(to_cpumask(tmpmask),
-		    cpu_online_mask, tick_get_broadcast_mask());
-	tick_do_broadcast(to_cpumask(tmpmask));
+	cpumask_and(tmpmask, cpu_online_mask, tick_broadcast_mask);
+	tick_do_broadcast(tmpmask);
 
 	raw_spin_unlock(&tick_broadcast_lock);
 }
@@ -263,13 +261,12 @@ static void tick_do_broadcast_on_off(uns
 	if (!tick_device_is_functional(dev))
 		goto out;
 
-	bc_stopped = cpumask_empty(tick_get_broadcast_mask());
+	bc_stopped = cpumask_empty(tick_broadcast_mask);
 
 	switch (*reason) {
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
-		if (!cpumask_test_cpu(cpu, tick_get_broadcast_mask())) {
-			cpumask_set_cpu(cpu, tick_get_broadcast_mask());
+		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_mask)) {
 			if (tick_broadcast_device.mode ==
 			    TICKDEV_MODE_PERIODIC)
 				clockevents_shutdown(dev);
@@ -279,8 +276,7 @@ static void tick_do_broadcast_on_off(uns
 		break;
 	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
 		if (!tick_broadcast_force &&
-		    cpumask_test_cpu(cpu, tick_get_broadcast_mask())) {
-			cpumask_clear_cpu(cpu, tick_get_broadcast_mask());
+		    cpumask_test_and_clear_cpu(cpu, tick_broadcast_mask)) {
 			if (tick_broadcast_device.mode ==
 			    TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);
@@ -288,7 +284,7 @@ static void tick_do_broadcast_on_off(uns
 		break;
 	}
 
-	if (cpumask_empty(tick_get_broadcast_mask())) {
+	if (cpumask_empty(tick_broadcast_mask)) {
 		if (!bc_stopped)
 			clockevents_shutdown(bc);
 	} else if (bc_stopped) {
@@ -337,10 +333,10 @@ void tick_shutdown_broadcast(unsigned in
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	bc = tick_broadcast_device.evtdev;
-	cpumask_clear_cpu(cpu, tick_get_broadcast_mask());
+	cpumask_clear_cpu(cpu, tick_broadcast_mask);
 
 	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC) {
-		if (bc && cpumask_empty(tick_get_broadcast_mask()))
+		if (bc && cpumask_empty(tick_broadcast_mask))
 			clockevents_shutdown(bc);
 	}
 
@@ -376,13 +372,13 @@ int tick_resume_broadcast(void)
 
 		switch (tick_broadcast_device.mode) {
 		case TICKDEV_MODE_PERIODIC:
-			if (!cpumask_empty(tick_get_broadcast_mask()))
+			if (!cpumask_empty(tick_broadcast_mask))
 				tick_broadcast_start_periodic(bc);
 			broadcast = cpumask_test_cpu(smp_processor_id(),
-						     tick_get_broadcast_mask());
+						     tick_broadcast_mask);
 			break;
 		case TICKDEV_MODE_ONESHOT:
-			if (!cpumask_empty(tick_get_broadcast_mask()))
+			if (!cpumask_empty(tick_broadcast_mask))
 				broadcast = tick_resume_broadcast_oneshot(bc);
 			break;
 		}
@@ -395,15 +391,14 @@ int tick_resume_broadcast(void)
 
 #ifdef CONFIG_TICK_ONESHOT
 
-/* FIXME: use cpumask_var_t. */
-static DECLARE_BITMAP(tick_broadcast_oneshot_mask, NR_CPUS);
+static cpumask_var_t tick_broadcast_oneshot_mask;
 
 /*
  * Exposed for debugging: see timer_list.c
  */
 struct cpumask *tick_get_broadcast_oneshot_mask(void)
 {
-	return to_cpumask(tick_broadcast_oneshot_mask);
+	return tick_broadcast_oneshot_mask;
 }
 
 static int tick_broadcast_set_event(ktime_t expires, int force)
@@ -428,7 +423,7 @@ int tick_resume_broadcast_oneshot(struct
  */
 void tick_check_oneshot_broadcast(int cpu)
 {
-	if (cpumask_test_cpu(cpu, to_cpumask(tick_broadcast_oneshot_mask))) {
+	if (cpumask_test_cpu(cpu, tick_broadcast_oneshot_mask)) {
 		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
 
 		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
@@ -448,13 +443,13 @@ static void tick_handle_oneshot_broadcas
 again:
 	dev->next_event.tv64 = KTIME_MAX;
 	next_event.tv64 = KTIME_MAX;
-	cpumask_clear(to_cpumask(tmpmask));
+	cpumask_clear(tmpmask);
 	now = ktime_get();
 	/* Find all expired events */
-	for_each_cpu(cpu, tick_get_broadcast_oneshot_mask()) {
+	for_each_cpu(cpu, tick_broadcast_oneshot_mask) {
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev->next_event.tv64 <= now.tv64)
-			cpumask_set_cpu(cpu, to_cpumask(tmpmask));
+			cpumask_set_cpu(cpu, tmpmask);
 		else if (td->evtdev->next_event.tv64 < next_event.tv64)
 			next_event.tv64 = td->evtdev->next_event.tv64;
 	}
@@ -462,7 +457,7 @@ again:
 	/*
 	 * Wakeup the cpus which have an expired event.
 	 */
-	tick_do_broadcast(to_cpumask(tmpmask));
+	tick_do_broadcast(tmpmask);
 
 	/*
 	 * Two reasons for reprogram:
@@ -518,16 +513,13 @@ void tick_broadcast_oneshot_control(unsi
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
-		if (!cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
-			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
+		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
 			if (dev->next_event.tv64 < bc->next_event.tv64)
 				tick_broadcast_set_event(dev->next_event, 1);
 		}
 	} else {
-		if (cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
-			cpumask_clear_cpu(cpu,
-					  tick_get_broadcast_oneshot_mask());
+		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
 			if (dev->next_event.tv64 != KTIME_MAX)
 				tick_program_event(dev->next_event, 1);
@@ -543,7 +535,7 @@ void tick_broadcast_oneshot_control(unsi
  */
 static void tick_broadcast_clear_oneshot(int cpu)
 {
-	cpumask_clear_cpu(cpu, tick_get_broadcast_oneshot_mask());
+	cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
 }
 
 static void tick_broadcast_init_next_event(struct cpumask *mask,
@@ -581,15 +573,14 @@ void tick_broadcast_setup_oneshot(struct
 		 * oneshot_mask bits for those and program the
 		 * broadcast device to fire.
 		 */
-		cpumask_copy(to_cpumask(tmpmask), tick_get_broadcast_mask());
-		cpumask_clear_cpu(cpu, to_cpumask(tmpmask));
-		cpumask_or(tick_get_broadcast_oneshot_mask(),
-			   tick_get_broadcast_oneshot_mask(),
-			   to_cpumask(tmpmask));
+		cpumask_copy(tmpmask, tick_broadcast_mask);
+		cpumask_clear_cpu(cpu, tmpmask);
+		cpumask_or(tick_broadcast_oneshot_mask,
+			   tick_broadcast_oneshot_mask, tmpmask);
 
-		if (was_periodic && !cpumask_empty(to_cpumask(tmpmask))) {
+		if (was_periodic && !cpumask_empty(tmpmask)) {
 			clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
-			tick_broadcast_init_next_event(to_cpumask(tmpmask),
+			tick_broadcast_init_next_event(tmpmask,
 						       tick_next_period);
 			tick_broadcast_set_event(tick_next_period, 1);
 		} else
@@ -639,7 +630,7 @@ void tick_shutdown_broadcast_oneshot(uns
 	 * Clear the broadcast mask flag for the dead cpu, but do not
 	 * stop the broadcast device!
 	 */
-	cpumask_clear_cpu(cpu, tick_get_broadcast_oneshot_mask());
+	cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
 
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
@@ -663,3 +654,12 @@ bool tick_broadcast_oneshot_available(vo
 }
 
 #endif
+
+void __init tick_broadcast_init(void)
+{
+	alloc_cpumask_var(&tick_broadcast_mask, GFP_NOWAIT);
+	alloc_cpumask_var(&tmpmask, GFP_NOWAIT);
+#ifdef CONFIG_TICK_ONESHOT
+	alloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);
+#endif
+}
Index: tip/kernel/time/tick-common.c
===================================================================
--- tip.orig/kernel/time/tick-common.c
+++ tip/kernel/time/tick-common.c
@@ -416,4 +416,5 @@ static struct notifier_block tick_notifi
 void __init tick_init(void)
 {
 	clockevents_register_notifier(&tick_notifier);
+	tick_broadcast_init();
 }
Index: tip/kernel/time/tick-internal.h
===================================================================
--- tip.orig/kernel/time/tick-internal.h
+++ tip/kernel/time/tick-internal.h
@@ -94,7 +94,7 @@ extern void tick_broadcast_on_off(unsign
 extern void tick_shutdown_broadcast(unsigned int *cpup);
 extern void tick_suspend_broadcast(void);
 extern int tick_resume_broadcast(void);
-
+extern void tick_broadcast_init(void);
 extern void
 tick_set_periodic_handler(struct clock_event_device *dev, int broadcast);
 
@@ -119,6 +119,7 @@ static inline void tick_broadcast_on_off
 static inline void tick_shutdown_broadcast(unsigned int *cpup) { }
 static inline void tick_suspend_broadcast(void) { }
 static inline int tick_resume_broadcast(void) { return 0; }
+static inline void tick_broadcast_init(void) { }
 
 /*
  * Set the periodic handler in non broadcast mode


