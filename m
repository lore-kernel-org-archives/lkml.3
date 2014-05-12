Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbaELJai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:30:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62174 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbaELJab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:30:31 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        arvind.chauhan@arm.com, daniel.lezcano@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: [RFC 1/2] clockevents: return 'int' from clockevents_set_mode()
Date: Mon, 12 May 2014 15:00:05 +0530
Message-Id: <df571ff25b510bd0263b194bfdcbaf1b476a2a03.1399886467.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1399886467.git.viresh.kumar@linaro.org>
References: <cover.1399886467.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1399886467.git.viresh.kumar@linaro.org>
References: <cover.1399886467.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clockevents_set_mode() calls dev->set_mode() which has return type of 'void'
currently. Later patches would add another interface dev->set_dev_mode(), which
will return int and clockevents_set_mode() must propagate failures returned from
it.

This patch changes prototype of clockevents_set_mode() to return 'int' and fix
caller sites as well. As most of the call sites maynot work if
clockevents_set_mode() fails, do issue a WARN() on failures. All other are
updated to return error codes.

Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/common/bL_switcher.c |  5 +++--
 include/linux/clockchips.h    |  2 +-
 kernel/time/clockevents.c     |  8 +++++---
 kernel/time/tick-broadcast.c  | 25 ++++++++++++++++---------
 kernel/time/tick-common.c     |  6 +++---
 kernel/time/tick-oneshot.c    |  6 +++---
 6 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/arch/arm/common/bL_switcher.c b/arch/arm/common/bL_switcher.c
index f01c0ee..bf95a6a 100644
--- a/arch/arm/common/bL_switcher.c
+++ b/arch/arm/common/bL_switcher.c
@@ -234,7 +234,8 @@ static int bL_switch_to(unsigned int new_cluster_id)
 		tdev = NULL;
 	if (tdev) {
 		tdev_mode = tdev->evtdev->mode;
-		clockevents_set_mode(tdev->evtdev, CLOCK_EVT_MODE_SHUTDOWN);
+		WARN_ON(clockevents_set_mode(tdev->evtdev,
+					     CLOCK_EVT_MODE_SHUTDOWN));
 	}
 
 	ret = cpu_pm_enter();
@@ -262,7 +263,7 @@ static int bL_switch_to(unsigned int new_cluster_id)
 	ret = cpu_pm_exit();
 
 	if (tdev) {
-		clockevents_set_mode(tdev->evtdev, tdev_mode);
+		WARN_ON(clockevents_set_mode(tdev->evtdev, tdev_mode));
 		clockevents_program_event(tdev->evtdev,
 					  tdev->evtdev->next_event, 1);
 	}
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 2e4cb67..4e7a4d3 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -160,7 +160,7 @@ extern int clockevents_update_freq(struct clock_event_device *ce, u32 freq);
 
 extern void clockevents_exchange_device(struct clock_event_device *old,
 					struct clock_event_device *new);
-extern void clockevents_set_mode(struct clock_event_device *dev,
+extern int clockevents_set_mode(struct clock_event_device *dev,
 				 enum clock_event_mode mode);
 extern int clockevents_program_event(struct clock_event_device *dev,
 				     ktime_t expires, bool force);
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index ad362c2..8665660 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -101,7 +101,7 @@ EXPORT_SYMBOL_GPL(clockevent_delta2ns);
  *
  * Must be called with interrupts disabled !
  */
-void clockevents_set_mode(struct clock_event_device *dev,
+int clockevents_set_mode(struct clock_event_device *dev,
 				 enum clock_event_mode mode)
 {
 	if (dev->mode != mode) {
@@ -119,6 +119,8 @@ void clockevents_set_mode(struct clock_event_device *dev,
 			}
 		}
 	}
+
+	return 0;
 }
 
 /**
@@ -127,7 +129,7 @@ void clockevents_set_mode(struct clock_event_device *dev,
  */
 void clockevents_shutdown(struct clock_event_device *dev)
 {
-	clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
+	WARN_ON(clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN));
 	dev->next_event.tv64 = KTIME_MAX;
 }
 
@@ -503,7 +505,7 @@ void clockevents_exchange_device(struct clock_event_device *old,
 	 */
 	if (old) {
 		module_put(old->owner);
-		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
+		WARN_ON(clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED));
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
 	}
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 64c5990..fb83fa1 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -464,7 +464,8 @@ int tick_resume_broadcast(void)
 	bc = tick_broadcast_device.evtdev;
 
 	if (bc) {
-		clockevents_set_mode(bc, CLOCK_EVT_MODE_RESUME);
+		if (clockevents_set_mode(bc, CLOCK_EVT_MODE_RESUME))
+			goto unlock;
 
 		switch (tick_broadcast_device.mode) {
 		case TICKDEV_MODE_PERIODIC:
@@ -479,6 +480,7 @@ int tick_resume_broadcast(void)
 			break;
 		}
 	}
+unlock:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 
 	return broadcast;
@@ -532,8 +534,11 @@ static int tick_broadcast_set_event(struct clock_event_device *bc, int cpu,
 {
 	int ret;
 
-	if (bc->mode != CLOCK_EVT_MODE_ONESHOT)
-		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
+	if (bc->mode != CLOCK_EVT_MODE_ONESHOT) {
+		ret = clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
+		if (ret)
+			return ret;
+	}
 
 	ret = clockevents_program_event(bc, expires, force);
 	if (!ret)
@@ -543,8 +548,7 @@ static int tick_broadcast_set_event(struct clock_event_device *bc, int cpu,
 
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
-	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
-	return 0;
+	return clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 }
 
 /*
@@ -562,8 +566,8 @@ void tick_check_oneshot_broadcast_this_cpu(void)
 		 * switched over, leave the device alone.
 		 */
 		if (td->mode == TICKDEV_MODE_ONESHOT) {
-			clockevents_set_mode(td->evtdev,
-					     CLOCK_EVT_MODE_ONESHOT);
+			WARN_ON(clockevents_set_mode(td->evtdev,
+					     CLOCK_EVT_MODE_ONESHOT));
 		}
 	}
 }
@@ -741,7 +745,9 @@ int tick_broadcast_oneshot_control(unsigned long reason)
 			cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
 	} else {
 		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_oneshot_mask)) {
-			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
+			ret = clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
+			if (ret)
+				goto out;
 			/*
 			 * The cpu which was handling the broadcast
 			 * timer marked this cpu in the broadcast
@@ -858,7 +864,8 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 			   tick_broadcast_oneshot_mask, tmpmask);
 
 		if (was_periodic && !cpumask_empty(tmpmask)) {
-			clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
+			WARN_ON(clockevents_set_mode(bc,
+						     CLOCK_EVT_MODE_ONESHOT));
 			tick_broadcast_init_next_event(tmpmask,
 						       tick_next_period);
 			tick_broadcast_set_event(bc, cpu, tick_next_period, 1);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 0a0608e..7b2cf15 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -140,7 +140,7 @@ void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
 
 	if ((dev->features & CLOCK_EVT_FEAT_PERIODIC) &&
 	    !tick_broadcast_oneshot_active()) {
-		clockevents_set_mode(dev, CLOCK_EVT_MODE_PERIODIC);
+		WARN_ON(clockevents_set_mode(dev, CLOCK_EVT_MODE_PERIODIC));
 	} else {
 		unsigned long seq;
 		ktime_t next;
@@ -150,7 +150,7 @@ void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
 			next = tick_next_period;
 		} while (read_seqretry(&jiffies_lock, seq));
 
-		clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
+		WARN_ON(clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT));
 
 		for (;;) {
 			if (!clockevents_program_event(dev, next, false))
@@ -384,7 +384,7 @@ void tick_resume(void)
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
 	int broadcast = tick_resume_broadcast();
 
-	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME);
+	WARN_ON(clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME));
 
 	if (!broadcast) {
 		if (td->mode == TICKDEV_MODE_PERIODIC)
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 8241090..b525f97 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -38,7 +38,7 @@ void tick_resume_oneshot(void)
 {
 	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
 
-	clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
+	WARN_ON(clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT));
 	clockevents_program_event(dev, ktime_get(), true);
 }
 
@@ -50,7 +50,7 @@ void tick_setup_oneshot(struct clock_event_device *newdev,
 			ktime_t next_event)
 {
 	newdev->event_handler = handler;
-	clockevents_set_mode(newdev, CLOCK_EVT_MODE_ONESHOT);
+	WARN_ON(clockevents_set_mode(newdev, CLOCK_EVT_MODE_ONESHOT));
 	clockevents_program_event(newdev, next_event, true);
 }
 
@@ -81,7 +81,7 @@ int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *))
 
 	td->mode = TICKDEV_MODE_ONESHOT;
 	dev->event_handler = handler;
-	clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
+	WARN_ON(clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT));
 	tick_broadcast_switch_to_oneshot();
 	return 0;
 }
-- 
2.0.0.rc2

