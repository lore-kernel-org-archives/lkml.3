Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab3DYUdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:33:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:46015 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758996Ab3DYUbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:31:49 -0400
Message-Id: <20130425143436.162888472@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 25 Apr 2013 20:31:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 10/15] clockevents: Simplify locking
References: <20130425142452.908423538@linutronix.de>
Content-Disposition: inline; filename=clockevents-simplify-locking.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the notifier chain is gone there are no other users and it's
pointless to nest tick_device_lock inside of clockevents_lock because
there is no other use case.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-common.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

Index: tip/kernel/time/tick-common.c
===================================================================
--- tip.orig/kernel/time/tick-common.c
+++ tip/kernel/time/tick-common.c
@@ -33,7 +33,6 @@ DEFINE_PER_CPU(struct tick_device, tick_
 ktime_t tick_next_period;
 ktime_t tick_period;
 int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT;
-static DEFINE_RAW_SPINLOCK(tick_device_lock);
 
 /*
  * Debugging: see timer_list.c
@@ -203,16 +202,14 @@ static void tick_setup_device(struct tic
 }
 
 /*
- * Check, if the new registered device should be used.
+ * Check, if the new registered device should be used. Called with
+ * clockevents_lock held and interrupts disabled.
  */
 void tick_check_new_device(struct clock_event_device *newdev)
 {
 	struct clock_event_device *curdev;
 	struct tick_device *td;
 	int cpu;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&tick_device_lock, flags);
 
 	cpu = smp_processor_id();
 	if (!cpumask_test_cpu(cpu, newdev->cpumask))
@@ -270,8 +267,6 @@ void tick_check_new_device(struct clock_
 	tick_setup_device(td, newdev, cpu, cpumask_of(cpu));
 	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_oneshot_notify();
-
-	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
 	return;
 
 out_bc:
@@ -279,7 +274,6 @@ out_bc:
 	 * Can the new device be used as a broadcast device ?
 	 */
 	tick_install_broadcast_device(newdev);
-	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
 /*
@@ -308,9 +302,7 @@ static void tick_shutdown(unsigned int *
 {
 	struct tick_device *td = &per_cpu(tick_cpu_device, *cpup);
 	struct clock_event_device *dev = td->evtdev;
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&tick_device_lock, flags);
 	td->mode = TICKDEV_MODE_PERIODIC;
 	if (dev) {
 		/*
@@ -322,26 +314,20 @@ static void tick_shutdown(unsigned int *
 		dev->event_handler = clockevents_handle_noop;
 		td->evtdev = NULL;
 	}
-	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
 static void tick_suspend(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&tick_device_lock, flags);
 	clockevents_shutdown(td->evtdev);
-	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
 static void tick_resume(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
-	unsigned long flags;
 	int broadcast = tick_resume_broadcast();
 
-	raw_spin_lock_irqsave(&tick_device_lock, flags);
 	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME);
 
 	if (!broadcast) {
@@ -350,9 +336,11 @@ static void tick_resume(void)
 		else
 			tick_resume_oneshot();
 	}
-	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
+/*
+ * Called with clockevents_lock held and interrupts disabled
+ */
 void tick_notify(unsigned long reason, void *dev)
 {
 	switch (reason) {


