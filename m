Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab3E0J6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:58:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35663 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab3E0J6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:58:04 -0400
Date: Mon, 27 May 2013 02:57:49 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-45cb8e01b2ecef1c2afb18333e95793fa1a90281@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130425143436.431796247@linutronix.de>
References: <20130425143436.431796247@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents: Split out selection logic
Git-Commit-ID: 45cb8e01b2ecef1c2afb18333e95793fa1a90281
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45cb8e01b2ecef1c2afb18333e95793fa1a90281
Gitweb:     http://git.kernel.org/tip/45cb8e01b2ecef1c2afb18333e95793fa1a90281
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 25 Apr 2013 20:31:50 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 16 May 2013 11:09:17 +0200

clockevents: Split out selection logic

Split out the clockevent device selection logic. Preparatory patch to
allow unbinding active clockevent devices.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130425143436.431796247@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c | 25 ++++++++++++----
 kernel/time/tick-common.c    | 69 +++++++++++++++++++++++---------------------
 2 files changed, 56 insertions(+), 38 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 0e374cd..d067c01 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -65,19 +65,34 @@ static void tick_broadcast_start_periodic(struct clock_event_device *bc)
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
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 433a1e1..c34021650 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -205,6 +205,37 @@ static void tick_setup_device(struct tick_device *td,
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
@@ -223,40 +254,12 @@ void tick_check_new_device(struct clock_event_device *newdev)
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
