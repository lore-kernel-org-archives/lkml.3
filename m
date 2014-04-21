Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaDUKAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:00:44 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64573 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaDUJ4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:56:17 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 09/19] tick-oneshot: remove tick_resume_oneshot()
Date: Mon, 21 Apr 2014 15:25:05 +0530
Message-Id: <a39765c4e51472227d1bb589d0667d6cf32eb9aa.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_resume_oneshot() and tick_setup_oneshot() have almost same implementation.
So, we can remove tick_resume_oneshot() and use tick_setup_oneshot() in its
place.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c   |  8 +++++---
 kernel/time/tick-internal.h |  5 -----
 kernel/time/tick-oneshot.c  | 11 -----------
 3 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 64897d3..965e9c3 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -359,15 +359,17 @@ void tick_suspend(void)
 void tick_resume(void)
 {
 	struct tick_device *td = tick_get_cpu_device();
+	struct clock_event_device *dev = td->evtdev;
 	int broadcast = tick_resume_broadcast();
 
-	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME);
+	clockevents_set_mode(dev, CLOCK_EVT_MODE_RESUME);
 
 	if (!broadcast) {
 		if (td->mode == TICKDEV_MODE_PERIODIC)
-			tick_setup_periodic(td->evtdev, 0);
+			tick_setup_periodic(dev, 0);
 		else
-			tick_resume_oneshot();
+			tick_setup_oneshot(dev, dev->event_handler,
+					   ktime_get());
 	}
 }
 
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 09f4307..65f080a 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -43,7 +43,6 @@ extern int tick_program_event(ktime_t expires, int force);
 extern void tick_oneshot_notify(void);
 extern int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *));
 extern int tick_is_oneshot_available(void);
-extern void tick_resume_oneshot(void);
 # ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern void tick_broadcast_setup_oneshot(struct clock_event_device *bc);
 extern int tick_broadcast_oneshot_control(unsigned long reason);
@@ -74,10 +73,6 @@ void tick_setup_oneshot(struct clock_event_device *newdev,
 {
 	BUG();
 }
-static inline void tick_resume_oneshot(void)
-{
-	BUG();
-}
 static inline int tick_program_event(ktime_t expires, int force)
 {
 	return 0;
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index aaf60a9..a07fc3d 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -32,17 +32,6 @@ int tick_program_event(ktime_t expires, int force)
 }
 
 /**
- * tick_resume_onshot - resume oneshot mode
- */
-void tick_resume_oneshot(void)
-{
-	struct clock_event_device *dev = tick_get_cpu_device()->evtdev;
-
-	clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
-	clockevents_program_event(dev, ktime_get(), true);
-}
-
-/**
  * tick_setup_oneshot - setup the event device for oneshot mode (hres or nohz)
  */
 void tick_setup_oneshot(struct clock_event_device *newdev,
-- 
1.7.12.rc2.18.g61b472e

