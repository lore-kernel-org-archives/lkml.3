Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaBCWew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:34:52 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59846 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaBCWeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:34:50 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [PATCH v3 1/7] time: Serialize calls to 'clockevents_update_freq' in the timing core
Date: Mon,  3 Feb 2014 14:34:31 -0800
Message-Id: <1391466877-28908-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391466877-28908-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1391466877-28908-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

We can identify the broadcast device in the core and serialize all
callers including interrupts on a different CPU against the update.
Also, disabling interrupts is moved into the core allowing callers to
leave interrutps enabled when calling clockevents_update_freq().

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 kernel/time/clockevents.c    | 29 ++++++++++++++++++++++-------
 kernel/time/tick-broadcast.c | 25 +++++++++++++++++++------
 kernel/time/tick-internal.h  |  4 ++++
 3 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 086ad6043bcb..641d91003a45 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -439,6 +439,16 @@ void clockevents_config_and_register(struct clock_event_device *dev,
 }
 EXPORT_SYMBOL_GPL(clockevents_config_and_register);
 
+int __clockevents_update_freq(struct clock_event_device *dev, u32 freq)
+{
+	clockevents_config(dev, freq);
+
+	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
+		return 0;
+
+	return clockevents_program_event(dev, dev->next_event, false);
+}
+
 /**
  * clockevents_update_freq - Update frequency and reprogram a clock event device.
  * @dev:	device to modify
@@ -446,17 +456,22 @@ EXPORT_SYMBOL_GPL(clockevents_config_and_register);
  *
  * Reconfigure and reprogram a clock event device in oneshot
  * mode. Must be called on the cpu for which the device delivers per
- * cpu timer events with interrupts disabled!  Returns 0 on success,
- * -ETIME when the event is in the past.
+ * cpu timer events. If called for the broadcast device the core takes
+ * care of serialization.
+ *
+ * Returns 0 on success, -ETIME when the event is in the past.
  */
 int clockevents_update_freq(struct clock_event_device *dev, u32 freq)
 {
-	clockevents_config(dev, freq);
-
-	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
-		return 0;
+	unsigned long flags;
+	int ret;
 
-	return clockevents_program_event(dev, dev->next_event, false);
+	local_irq_save(flags);
+	ret = tick_broadcast_update_freq(dev, freq);
+	if (ret == -ENODEV)
+		ret = __clockevents_update_freq(dev, freq);
+	local_irq_restore(flags);
+	return ret;
 }
 
 /*
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 43780ab5e279..003e6c3663b1 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -120,6 +120,19 @@ int tick_is_broadcast_device(struct clock_event_device *dev)
 	return (dev && tick_broadcast_device.evtdev == dev);
 }
 
+int tick_broadcast_update_freq(struct clock_event_device *dev, u32 freq)
+{
+	int ret = -ENODEV;
+
+	if (tick_is_broadcast_device(dev)) {
+		raw_spin_lock(&tick_broadcast_lock);
+		ret = __clockevents_update_freq(dev, freq);
+		raw_spin_unlock(&tick_broadcast_lock);
+	}
+	return ret;
+}
+
+
 static void err_broadcast(const struct cpumask *mask)
 {
 	pr_crit_once("Failed to broadcast timer tick. Some CPUs may be unresponsive.\n");
@@ -272,12 +285,8 @@ static void tick_do_broadcast(struct cpumask *mask)
  */
 static void tick_do_periodic_broadcast(void)
 {
-	raw_spin_lock(&tick_broadcast_lock);
-
 	cpumask_and(tmpmask, cpu_online_mask, tick_broadcast_mask);
 	tick_do_broadcast(tmpmask);
-
-	raw_spin_unlock(&tick_broadcast_lock);
 }
 
 /*
@@ -287,13 +296,15 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 {
 	ktime_t next;
 
+	raw_spin_lock(&tick_broadcast_lock);
+
 	tick_do_periodic_broadcast();
 
 	/*
 	 * The device is in periodic mode. No reprogramming necessary:
 	 */
 	if (dev->mode == CLOCK_EVT_MODE_PERIODIC)
-		return;
+		goto unlock;
 
 	/*
 	 * Setup the next period for devices, which do not have
@@ -306,9 +317,11 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 		next = ktime_add(next, tick_period);
 
 		if (!clockevents_program_event(dev, next, false))
-			return;
+			goto unlock;
 		tick_do_periodic_broadcast();
 	}
+unlock:
+	raw_spin_unlock(&tick_broadcast_lock);
 }
 
 /*
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 8329669b51ec..26f1c0ba9d81 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -111,6 +111,7 @@ extern int tick_resume_broadcast(void);
 extern void tick_broadcast_init(void);
 extern void
 tick_set_periodic_handler(struct clock_event_device *dev, int broadcast);
+int tick_broadcast_update_freq(struct clock_event_device *dev, u32 freq);
 
 #else /* !BROADCAST */
 
@@ -133,6 +134,8 @@ static inline void tick_shutdown_broadcast(unsigned int *cpup) { }
 static inline void tick_suspend_broadcast(void) { }
 static inline int tick_resume_broadcast(void) { return 0; }
 static inline void tick_broadcast_init(void) { }
+static inline int tick_broadcast_update_freq(struct clock_event_device *dev,
+					     u32 freq) { return -ENODEV; }
 
 /*
  * Set the periodic handler in non broadcast mode
@@ -154,5 +157,6 @@ static inline int tick_device_is_functional(struct clock_event_device *dev)
 
 #endif
 
+int __clockevents_update_freq(struct clock_event_device *dev, u32 freq);
 extern void do_timer(unsigned long ticks);
 extern void update_wall_time(void);
-- 
1.8.5.3

