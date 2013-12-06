Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662Ab3LFWGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:06:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759464Ab3LFVxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kim Phillips <kim.phillips@linaro.org>
Subject: [PATCH 3.10 47/58] clockevents: Split out selection logic
Date: Fri,  6 Dec 2013 13:52:18 -0800
Message-Id: <20131206214849.251325104@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 45cb8e01b2ecef1c2afb18333e95793fa1a90281 upstream.

Split out the clockevent device selection logic. Preparatory patch to
allow unbinding active clockevent devices.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130425143436.431796247@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kim Phillips <kim.phillips@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-broadcast.c |   25 ++++++++++++---
 kernel/time/tick-common.c    |   69 ++++++++++++++++++++++---------------------
 2 files changed, 56 insertions(+), 38 deletions(-)

--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -66,19 +66,34 @@ static void tick_broadcast_start_periodi
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
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -207,6 +207,37 @@ static void tick_setup_device(struct tic
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
  * Check, if the new registered device should be used.
  */
@@ -227,40 +258,12 @@ void tick_check_new_device(struct clock_
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


