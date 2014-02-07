Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaBGOmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:42:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55939 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaBGOkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:40:41 -0500
Date: Fri, 7 Feb 2014 06:40:28 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-627ee7947e2e83ba565c31c5c9373d6e364b1ecd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, soren.brinkmann@xilinx.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, michal.simek@xilinx.com,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, soren.brinkmann@xilinx.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org, michal.simek@xilinx.com
In-Reply-To: <1391466877-28908-2-git-send-email-soren.brinkmann@xilinx.com>
References: <1391466877-28908-2-git-send-email-soren.brinkmann@xilinx.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents:
  Serialize calls to clockevents_update_freq() in the core
Git-Commit-ID: 627ee7947e2e83ba565c31c5c9373d6e364b1ecd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 07 Feb 2014 06:40:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  627ee7947e2e83ba565c31c5c9373d6e364b1ecd
Gitweb:     http://git.kernel.org/tip/627ee7947e2e83ba565c31c5c9373d6e364b1ecd
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 3 Feb 2014 14:34:31 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 7 Feb 2014 15:34:28 +0100

clockevents: Serialize calls to clockevents_update_freq() in the core

We can identify the broadcast device in the core and serialize all
callers including interrupts on a different CPU against the update.
Also, disabling interrupts is moved into the core allowing callers to
leave interrutps enabled when calling clockevents_update_freq().

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Soeren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Michal Simek <michal.simek@xilinx.com>
Link: http://lkml.kernel.org/r/1391466877-28908-2-git-send-email-soren.brinkmann@xilinx.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clockevents.c    | 29 ++++++++++++++++++++++-------
 kernel/time/tick-broadcast.c | 25 +++++++++++++++++++------
 kernel/time/tick-internal.h  |  4 ++++
 3 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 086ad60..641d910 100644
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
index 43780ab..003e6c3 100644
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
index 8329669..26f1c0b 100644
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
