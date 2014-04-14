Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbaDNQZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:25:07 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41049 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbaDNQZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:25:01 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 08/38] tick-oneshot: move tick_is_oneshot_available() to tick-oneshot.c
Date: Mon, 14 Apr 2014 21:53:30 +0530
Message-Id: <9792e3ff835266ba2c1678867e88ac3606a57cd2.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is tick-oneshot specific routine and hence must be there in this file. Also
it isn't used outside of kernel/time/ and so moving its declaration to
tick-internal.h.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/tick.h        |  1 -
 kernel/time/tick-common.c   | 14 --------------
 kernel/time/tick-internal.h |  2 ++
 kernel/time/tick-oneshot.c  | 14 ++++++++++++++
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 98065e5..b8ee6f4 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -84,7 +84,6 @@ struct tick_sched {
 };
 
 extern void __init tick_init(void);
-extern int tick_is_oneshot_available(void);
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 static inline struct tick_device *tick_get_device(int cpu)
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index b4fdb28..298467e 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -53,20 +53,6 @@ int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT;
 /*
  * Debugging: see timer_list.c
  */
-/**
- * tick_is_oneshot_available - check for a oneshot capable event device
- */
-int tick_is_oneshot_available(void)
-{
-	struct clock_event_device *dev = tick_get_cpu_device()->evtdev;
-
-	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT))
-		return 0;
-	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
-		return 1;
-	return tick_broadcast_oneshot_available();
-}
-
 /*
  * Periodic tick
  */
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 57c1a76..09f4307 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -42,6 +42,7 @@ extern void tick_setup_oneshot(struct clock_event_device *newdev,
 extern int tick_program_event(ktime_t expires, int force);
 extern void tick_oneshot_notify(void);
 extern int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *));
+extern int tick_is_oneshot_available(void);
 extern void tick_resume_oneshot(void);
 # ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern void tick_broadcast_setup_oneshot(struct clock_event_device *bc);
@@ -96,6 +97,7 @@ static inline int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 	return 0;
 }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
+static inline int tick_is_oneshot_available(void) { return 0; };
 static inline bool tick_broadcast_oneshot_available(void) { return false; }
 #endif /* !TICK_ONESHOT */
 
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 39492f1..cb158f7 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -95,6 +95,20 @@ int tick_oneshot_mode_active(void)
 	return tick_get_cpu_device()->mode == TICKDEV_MODE_ONESHOT;
 }
 
+/**
+ * tick_is_oneshot_available - check for a oneshot capable event device
+ */
+int tick_is_oneshot_available(void)
+{
+	struct clock_event_device *dev = tick_get_cpu_device()->evtdev;
+
+	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT))
+		return 0;
+	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
+		return 1;
+	return tick_broadcast_oneshot_available();
+}
+
 #ifdef CONFIG_HIGH_RES_TIMERS
 /**
  * tick_init_highres - switch to high resolution mode
-- 
1.7.12.rc2.18.g61b472e

