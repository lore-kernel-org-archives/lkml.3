Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426Ab3DYUbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:31:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:46039 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758707Ab3DYUbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:31:51 -0400
Message-Id: <20130425143436.431796247@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 25 Apr 2013 20:31:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 14/15] clockevents: Split out selection logic
References: <20130425142452.908423538@linutronix.de>
Content-Disposition: inline;
 filename=clockevents-split-out-selection-logic.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out the clockevent device selection logic. Preparatory patch to
allow unbinding active clockevent devices.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c |   25 ++++++++++++---
 kernel/time/tick-common.c    |   69 ++++++++++++++++++++++---------------------
 2 files changed, 56 insertions(+), 38 deletions(-)

Index: tip/kernel/time/tick-broadcast.c
===================================================================
--- tip.orig/kernel/time/tick-broadcast.c
+++ tip/kernel/time/tick-broadcast.c
@@ -65,19 +65,34 @@ static void tick_broadcast_start_periodi
 /*
  * Check, if the device can be utilized as broadcast device:
  */
+static bool tick_check_broadcast_device(struct clock_event_device *curdev,
+					struct clock_event_device *newdev)
+{
+	if ((newdev->features & CLOCK_EVT_FEAT_DUMMY) ||
+	    (newdev->features & CLOCK_EVT_FEAT_C3STOP))
+		return false;
+
+	if (tick_broadcast_device.mode == TICKDEV_MODE_ONESHOT &&
+	    !(newdev->features & CLOCK_EVT_FEAT_ONESHOT))
+		return false;
+
+	return !curdev || newdev->rating > curdev->rating;
+}
+
+/*
+ * Conditionally install/replace broadcast device
+ */
 void tick_install_broadcast_device(struct clock_event_device *dev)
 {
 	struct clock_event_device *cur = tick_broadcast_device.evtdev;
 
-	if ((dev->features & CLOCK_EVT_FEAT_DUMMY) ||
-	    (tick_broadcast_device.evtdev &&
-	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
-	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
+	if (!tick_check_broadcast_device(cur, dev))
 		return;
+
 	if (!try_module_get(dev->owner))
 		return;
 
-	clockevents_exchange_device(tick_broadcast_device.evtdev, dev);
+	clockevents_exchange_device(cur, dev);
 	if (cur)
 		cur->event_handler = clockevents_handle_noop;
 	tick_broadcast_device.evtdev = dev;
Index: tip/kernel/time/tick-common.c
===================================================================
--- tip.orig/kernel/time/tick-common.c
+++ tip/kernel/time/tick-common.c
@@ -202,6 +202,37 @@ static void tick_setup_device(struct tic
 		tick_setup_oneshot(newdev, handler, next_event);
 }
 
+static bool tick_check_percpu(struct clock_event_device *curdev,
+			      struct clock_event_device *newdev, int cpu)
+{
+	if (!cpumask_test_cpu(cpu, newdev->cpumask))
+		return false;
+	if (cpumask_equal(newdev->cpumask, cpumask_of(cpu)))
+		return true;
+	/* Check if irq affinity can be set */
+	if (newdev->irq >= 0 && !irq_can_set_affinity(newdev->irq))
+		return false;
+	/* Prefer an existing cpu local device */
+	if (curdev && cpumask_equal(curdev->cpumask, cpumask_of(cpu)))
+		return false;
+	return true;
+}
+
+static bool tick_check_preferred(struct clock_event_device *curdev,
+				 struct clock_event_device *newdev)
+{
+	/* Prefer oneshot capable device */
+	if (!(newdev->features & CLOCK_EVT_FEAT_ONESHOT)) {
+		if (curdev && (curdev->features & CLOCK_EVT_FEAT_ONESHOT))
+			return false;
+		if (tick_oneshot_mode_active())
+			return false;
+	}
+
+	/* Use the higher rated one */
+	return !curdev || newdev->rating > curdev->rating;
+}
+
 /*
  * Check, if the new registered device should be used. Called with
  * clockevents_lock held and interrupts disabled.
@@ -220,40 +251,12 @@ void tick_check_new_device(struct clock_
 	curdev = td->evtdev;
 
 	/* cpu local device ? */
-	if (!cpumask_equal(newdev->cpumask, cpumask_of(cpu))) {
-
-		/*
-		 * If the cpu affinity of the device interrupt can not
-		 * be set, ignore it.
-		 */
-		if (!irq_can_set_affinity(newdev->irq))
-			goto out_bc;
-
-		/*
-		 * If we have a cpu local device already, do not replace it
-		 * by a non cpu local device
-		 */
-		if (curdev && cpumask_equal(curdev->cpumask, cpumask_of(cpu)))
-			goto out_bc;
-	}
+	if (!tick_check_percpu(curdev, newdev, cpu))
+		goto out_bc;
 
-	/*
-	 * If we have an active device, then check the rating and the oneshot
-	 * feature.
-	 */
-	if (curdev) {
-		/*
-		 * Prefer one shot capable devices !
-		 */
-		if ((curdev->features & CLOCK_EVT_FEAT_ONESHOT) &&
-		    !(newdev->features & CLOCK_EVT_FEAT_ONESHOT))
-			goto out_bc;
-		/*
-		 * Check the rating
-		 */
-		if (curdev->rating >= newdev->rating)
-			goto out_bc;
-	}
+	/* Preference decision */
+	if (!tick_check_preferred(curdev, newdev))
+		goto out_bc;
 
 	if (!try_module_get(newdev->owner))
 		return;


