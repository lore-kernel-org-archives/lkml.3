Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaDNQ20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:28:26 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47101 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbaDNQ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:28:23 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 38/38] clockevents: set event_handler to clockevents_handle_noop() in clockevents_exchange_device()
Date: Mon, 14 Apr 2014 21:54:00 +0530
Message-Id: <8b416eb5d9362b014d1954df08f8001d03889f2f.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users of clockevents_handle_noop() are setting old->event_handler to it
after calling clockevents_exchange_device() and so it would be better if we can
do this at a single place. The only thing we need to make sure is, we preserve
it before calling clockevents_exchange_device() in case we need it.

As there are no external users of it, make it static.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/clockchips.h   |  2 --
 kernel/time/clockevents.c    |  3 ++-
 kernel/time/tick-broadcast.c |  2 --
 kernel/time/tick-common.c    | 11 +++++------
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 2e4cb67..7e492ad 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -165,8 +165,6 @@ extern void clockevents_set_mode(struct clock_event_device *dev,
 extern int clockevents_program_event(struct clock_event_device *dev,
 				     ktime_t expires, bool force);
 
-extern void clockevents_handle_noop(struct clock_event_device *dev);
-
 static inline void
 clockevents_calc_mult_shift(struct clock_event_device *ce, u32 freq, u32 minsec)
 {
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index d80e891..757dae8 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -480,7 +480,7 @@ int clockevents_update_freq(struct clock_event_device *dev, u32 freq)
 /*
  * Noop handler when we shut down an event device
  */
-void clockevents_handle_noop(struct clock_event_device *dev)
+static void clockevents_handle_noop(struct clock_event_device *dev)
 {
 }
 
@@ -506,6 +506,7 @@ void clockevents_exchange_device(struct clock_event_device *old,
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
+		old->event_handler = clockevents_handle_noop;
 	}
 
 	if (new) {
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 9d81a81..bb96da7 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -95,8 +95,6 @@ void tick_install_broadcast_device(struct clock_event_device *dev)
 		return;
 
 	clockevents_exchange_device(cur, dev);
-	if (cur)
-		cur->event_handler = clockevents_handle_noop;
 	tick_broadcast_device.evtdev = dev;
 	if (!cpumask_empty(tick_broadcast_mask))
 		tick_broadcast_start_periodic(dev);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index e1b2947..b0d14e3 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -145,11 +145,11 @@ void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
  * Setup the tick device
  */
 static void tick_setup_device(struct tick_device *td,
-			      struct clock_event_device *newdev, int cpu)
+			      struct clock_event_device *newdev, int cpu,
+			      void (*handler)(struct clock_event_device *))
 {
 	const struct cpumask *cpumask = cpumask_of(cpu);
 	ktime_t next_event;
-	void (*handler)(struct clock_event_device *) = NULL;
 
 	/*
 	 * First device setup ?
@@ -173,9 +173,7 @@ static void tick_setup_device(struct tick_device *td,
 		 */
 		td->mode = TICKDEV_MODE_PERIODIC;
 	} else {
-		handler = td->evtdev->event_handler;
 		next_event = td->evtdev->next_event;
-		td->evtdev->event_handler = clockevents_handle_noop;
 	}
 
 	td->evtdev = newdev;
@@ -206,10 +204,12 @@ static void tick_setup_device(struct tick_device *td,
 void tick_install_replacement(struct clock_event_device *newdev)
 {
 	struct tick_device *td = tick_get_cpu_device();
+	void (*handler)(struct clock_event_device *) =
+		td->evtdev->event_handler;
 	int cpu = smp_processor_id();
 
 	clockevents_exchange_device(td->evtdev, newdev);
-	tick_setup_device(td, newdev, cpu);
+	tick_setup_device(td, newdev, cpu, handler);
 	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_oneshot_notify();
 }
@@ -335,7 +335,6 @@ void tick_shutdown(unsigned int *cpup)
 		 * the set mode function!
 		 */
 		clockevents_exchange_device(dev, NULL);
-		dev->event_handler = clockevents_handle_noop;
 		td->evtdev = NULL;
 	}
 }
-- 
1.7.12.rc2.18.g61b472e

