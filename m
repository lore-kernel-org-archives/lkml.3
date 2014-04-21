Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaDUKBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:01:20 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:63799 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaDUJ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:56:11 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 08/19] tick-oneshot: move tick_is_oneshot_available() to tick-oneshot.c
Date: Mon, 21 Apr 2014 15:25:04 +0530
Message-Id: <ccb0dc853c0c2fdf5fc87e852c11e4f4f7976fc7.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is tick-oneshot specific routine and hence must be defined in
tick-oneshot.c.

Also, as it isn't used outside kernel/time/, move its declaration to
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
index 4d45e08..64897d3 100644
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
index 7089dea..aaf60a9 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -102,6 +102,20 @@ int tick_oneshot_mode_active(void)
 	return ret;
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

