Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536Ab3DYUdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:33:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:46009 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759348Ab3DYUbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:31:49 -0400
Message-Id: <20130425143436.098520211@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 25 Apr 2013 20:31:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 09/15] clockevents: Get rid of the notifier chain
References: <20130425142452.908423538@linutronix.de>
Content-Disposition: inline; filename=clockevents-get-rid-of-the-notifier.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

7+ years and still a single user. Kill it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clockchips.h   |    1 -
 kernel/time/clockevents.c    |   35 +++--------------------------------
 kernel/time/tick-broadcast.c |    5 ++---
 kernel/time/tick-common.c    |   30 +++++-------------------------
 kernel/time/tick-internal.h  |    7 ++++---
 5 files changed, 14 insertions(+), 64 deletions(-)

Index: tip/include/linux/clockchips.h
===================================================================
--- tip.orig/include/linux/clockchips.h
+++ tip/include/linux/clockchips.h
@@ -150,7 +150,6 @@ extern void clockevents_exchange_device(
 					struct clock_event_device *new);
 extern void clockevents_set_mode(struct clock_event_device *dev,
 				 enum clock_event_mode mode);
-extern int clockevents_register_notifier(struct notifier_block *nb);
 extern int clockevents_program_event(struct clock_event_device *dev,
 				     ktime_t expires, bool force);
 
Index: tip/kernel/time/clockevents.c
===================================================================
--- tip.orig/kernel/time/clockevents.c
+++ tip/kernel/time/clockevents.c
@@ -15,7 +15,6 @@
 #include <linux/hrtimer.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/notifier.h>
 #include <linux/smp.h>
 
 #include "tick-internal.h"
@@ -23,10 +22,6 @@
 /* The registered clock event devices */
 static LIST_HEAD(clockevent_devices);
 static LIST_HEAD(clockevents_released);
-
-/* Notification for clock events */
-static RAW_NOTIFIER_HEAD(clockevents_chain);
-
 /* Protection for the above */
 static DEFINE_RAW_SPINLOCK(clockevents_lock);
 
@@ -232,30 +227,6 @@ int clockevents_program_event(struct clo
 	return (rc && force) ? clockevents_program_min_delta(dev) : rc;
 }
 
-/**
- * clockevents_register_notifier - register a clock events change listener
- */
-int clockevents_register_notifier(struct notifier_block *nb)
-{
-	unsigned long flags;
-	int ret;
-
-	raw_spin_lock_irqsave(&clockevents_lock, flags);
-	ret = raw_notifier_chain_register(&clockevents_chain, nb);
-	raw_spin_unlock_irqrestore(&clockevents_lock, flags);
-
-	return ret;
-}
-
-/*
- * Notify about a clock event change. Called with clockevents_lock
- * held.
- */
-static void clockevents_do_notify(unsigned long reason, void *dev)
-{
-	raw_notifier_call_chain(&clockevents_chain, reason, dev);
-}
-
 /*
  * Called after a notify add to make devices available which were
  * released from the notifier call.
@@ -269,7 +240,7 @@ static void clockevents_notify_released(
 				 struct clock_event_device, list);
 		list_del(&dev->list);
 		list_add(&dev->list, &clockevent_devices);
-		clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
+		tick_check_new_device(dev);
 	}
 }
 
@@ -290,7 +261,7 @@ void clockevents_register_device(struct 
 	raw_spin_lock_irqsave(&clockevents_lock, flags);
 
 	list_add(&dev->list, &clockevent_devices);
-	clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
+	tick_check_new_device(dev);
 	clockevents_notify_released();
 
 	raw_spin_unlock_irqrestore(&clockevents_lock, flags);
@@ -433,7 +404,7 @@ void clockevents_notify(unsigned long re
 	int cpu;
 
 	raw_spin_lock_irqsave(&clockevents_lock, flags);
-	clockevents_do_notify(reason, arg);
+	tick_notify(reason, arg);
 
 	switch (reason) {
 	case CLOCK_EVT_NOTIFY_CPU_DEAD:
Index: tip/kernel/time/tick-broadcast.c
===================================================================
--- tip.orig/kernel/time/tick-broadcast.c
+++ tip/kernel/time/tick-broadcast.c
@@ -64,7 +64,7 @@ static void tick_broadcast_start_periodi
 /*
  * Check, if the device can be utilized as broadcast device:
  */
-int tick_check_broadcast_device(struct clock_event_device *dev)
+void tick_install_broadcast_device(struct clock_event_device *dev)
 {
 	struct clock_event_device *cur = tick_broadcast_device.evtdev;
 
@@ -72,7 +72,7 @@ int tick_check_broadcast_device(struct c
 	    (tick_broadcast_device.evtdev &&
 	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
 	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
-		return 0;
+		return;
 
 	clockevents_exchange_device(tick_broadcast_device.evtdev, dev);
 	if (cur)
@@ -90,7 +90,6 @@ int tick_check_broadcast_device(struct c
 	 */
 	if (dev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_clock_notify();
-	return 1;
 }
 
 /*
Index: tip/kernel/time/tick-common.c
===================================================================
--- tip.orig/kernel/time/tick-common.c
+++ tip/kernel/time/tick-common.c
@@ -205,11 +205,11 @@ static void tick_setup_device(struct tic
 /*
  * Check, if the new registered device should be used.
  */
-static int tick_check_new_device(struct clock_event_device *newdev)
+void tick_check_new_device(struct clock_event_device *newdev)
 {
 	struct clock_event_device *curdev;
 	struct tick_device *td;
-	int cpu, ret = NOTIFY_OK;
+	int cpu;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&tick_device_lock, flags);
@@ -272,18 +272,14 @@ static int tick_check_new_device(struct 
 		tick_oneshot_notify();
 
 	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
-	return NOTIFY_STOP;
+	return;
 
 out_bc:
 	/*
 	 * Can the new device be used as a broadcast device ?
 	 */
-	if (tick_check_broadcast_device(newdev))
-		ret = NOTIFY_STOP;
-
+	tick_install_broadcast_device(newdev);
 	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
-
-	return ret;
 }
 
 /*
@@ -357,17 +353,10 @@ static void tick_resume(void)
 	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
-/*
- * Notification about clock event devices
- */
-static int tick_notify(struct notifier_block *nb, unsigned long reason,
-			       void *dev)
+void tick_notify(unsigned long reason, void *dev)
 {
 	switch (reason) {
 
-	case CLOCK_EVT_NOTIFY_ADD:
-		return tick_check_new_device(dev);
-
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
@@ -401,21 +390,12 @@ static int tick_notify(struct notifier_b
 	default:
 		break;
 	}
-
-	return NOTIFY_OK;
 }
 
-static struct notifier_block tick_notifier = {
-	.notifier_call = tick_notify,
-};
-
 /**
  * tick_init - initialize the tick control
- *
- * Register the notifier with the clockevents framework
  */
 void __init tick_init(void)
 {
-	clockevents_register_notifier(&tick_notifier);
 	tick_broadcast_init();
 }
Index: tip/kernel/time/tick-internal.h
===================================================================
--- tip.orig/kernel/time/tick-internal.h
+++ tip/kernel/time/tick-internal.h
@@ -18,6 +18,8 @@ extern int tick_do_timer_cpu __read_most
 
 extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
 extern void tick_handle_periodic(struct clock_event_device *dev);
+extern void tick_notify(unsigned long reason, void *dev);
+extern void tick_check_new_device(struct clock_event_device *dev);
 
 extern void clockevents_shutdown(struct clock_event_device *dev);
 
@@ -90,7 +92,7 @@ static inline bool tick_broadcast_onesho
  */
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu);
-extern int tick_check_broadcast_device(struct clock_event_device *dev);
+extern void tick_install_broadcast_device(struct clock_event_device *dev);
 extern int tick_is_broadcast_device(struct clock_event_device *dev);
 extern void tick_broadcast_on_off(unsigned long reason, int *oncpu);
 extern void tick_shutdown_broadcast(unsigned int *cpup);
@@ -102,9 +104,8 @@ tick_set_periodic_handler(struct clock_e
 
 #else /* !BROADCAST */
 
-static inline int tick_check_broadcast_device(struct clock_event_device *dev)
+static inline void tick_install_broadcast_device(struct clock_event_device *dev)
 {
-	return 0;
 }
 
 static inline int tick_is_broadcast_device(struct clock_event_device *dev)


