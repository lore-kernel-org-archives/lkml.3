Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab3DYUc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:32:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:46022 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759354Ab3DYUbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:31:50 -0400
Message-Id: <20130425143436.235746557@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 25 Apr 2013 20:31:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 11/15] clockevents: Move the tick_notify() switch case to
 clockevents_notify()
References: <20130425142452.908423538@linutronix.de>
Content-Disposition: inline;
 filename=clockevents-move-the-external-notifier-to-clockevents.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to call another function and have duplicated cases.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clockevents.c   |   28 +++++++++++++++++++++++-
 kernel/time/tick-common.c   |   50 +++-----------------------------------------
 kernel/time/tick-internal.h |    5 +++-
 3 files changed, 35 insertions(+), 48 deletions(-)

Index: tip/kernel/time/clockevents.c
===================================================================
--- tip.orig/kernel/time/clockevents.c
+++ tip/kernel/time/clockevents.c
@@ -404,10 +404,36 @@ void clockevents_notify(unsigned long re
 	int cpu;
 
 	raw_spin_lock_irqsave(&clockevents_lock, flags);
-	tick_notify(reason, arg);
 
 	switch (reason) {
+	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
+	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
+	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
+		tick_broadcast_on_off(reason, arg);
+		break;
+
+	case CLOCK_EVT_NOTIFY_BROADCAST_ENTER:
+	case CLOCK_EVT_NOTIFY_BROADCAST_EXIT:
+		tick_broadcast_oneshot_control(reason);
+		break;
+
+	case CLOCK_EVT_NOTIFY_CPU_DYING:
+		tick_handover_do_timer(arg);
+		break;
+
+	case CLOCK_EVT_NOTIFY_SUSPEND:
+		tick_suspend();
+		tick_suspend_broadcast();
+		break;
+
+	case CLOCK_EVT_NOTIFY_RESUME:
+		tick_resume();
+		break;
+
 	case CLOCK_EVT_NOTIFY_CPU_DEAD:
+		tick_shutdown_broadcast_oneshot(arg);
+		tick_shutdown_broadcast(arg);
+		tick_shutdown(arg);
 		/*
 		 * Unregister the clock event devices which were
 		 * released from the users in the notify chain.
Index: tip/kernel/time/tick-common.c
===================================================================
--- tip.orig/kernel/time/tick-common.c
+++ tip/kernel/time/tick-common.c
@@ -281,7 +281,7 @@ out_bc:
  *
  * Called with interrupts disabled.
  */
-static void tick_handover_do_timer(int *cpup)
+void tick_handover_do_timer(int *cpup)
 {
 	if (*cpup == tick_do_timer_cpu) {
 		int cpu = cpumask_first(cpu_online_mask);
@@ -298,7 +298,7 @@ static void tick_handover_do_timer(int *
  * access the hardware device itself.
  * We just set the mode and remove it from the lists.
  */
-static void tick_shutdown(unsigned int *cpup)
+void tick_shutdown(unsigned int *cpup)
 {
 	struct tick_device *td = &per_cpu(tick_cpu_device, *cpup);
 	struct clock_event_device *dev = td->evtdev;
@@ -316,14 +316,14 @@ static void tick_shutdown(unsigned int *
 	}
 }
 
-static void tick_suspend(void)
+void tick_suspend(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
 
 	clockevents_shutdown(td->evtdev);
 }
 
-static void tick_resume(void)
+void tick_resume(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
 	int broadcast = tick_resume_broadcast();
@@ -338,48 +338,6 @@ static void tick_resume(void)
 	}
 }
 
-/*
- * Called with clockevents_lock held and interrupts disabled
- */
-void tick_notify(unsigned long reason, void *dev)
-{
-	switch (reason) {
-
-	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
-	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
-	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
-		tick_broadcast_on_off(reason, dev);
-		break;
-
-	case CLOCK_EVT_NOTIFY_BROADCAST_ENTER:
-	case CLOCK_EVT_NOTIFY_BROADCAST_EXIT:
-		tick_broadcast_oneshot_control(reason);
-		break;
-
-	case CLOCK_EVT_NOTIFY_CPU_DYING:
-		tick_handover_do_timer(dev);
-		break;
-
-	case CLOCK_EVT_NOTIFY_CPU_DEAD:
-		tick_shutdown_broadcast_oneshot(dev);
-		tick_shutdown_broadcast(dev);
-		tick_shutdown(dev);
-		break;
-
-	case CLOCK_EVT_NOTIFY_SUSPEND:
-		tick_suspend();
-		tick_suspend_broadcast();
-		break;
-
-	case CLOCK_EVT_NOTIFY_RESUME:
-		tick_resume();
-		break;
-
-	default:
-		break;
-	}
-}
-
 /**
  * tick_init - initialize the tick control
  */
Index: tip/kernel/time/tick-internal.h
===================================================================
--- tip.orig/kernel/time/tick-internal.h
+++ tip/kernel/time/tick-internal.h
@@ -18,8 +18,11 @@ extern int tick_do_timer_cpu __read_most
 
 extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
 extern void tick_handle_periodic(struct clock_event_device *dev);
-extern void tick_notify(unsigned long reason, void *dev);
 extern void tick_check_new_device(struct clock_event_device *dev);
+extern void tick_handover_do_timer(int *cpup);
+extern void tick_shutdown(unsigned int *cpup);
+extern void tick_suspend(void);
+extern void tick_resume(void);
 
 extern void clockevents_shutdown(struct clock_event_device *dev);
 


