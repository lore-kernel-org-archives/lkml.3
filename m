Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaDNQZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:25:14 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40657 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbaDNQZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:25:08 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 09/38] tick-oneshot: remove tick_resume_oneshot()
Date: Mon, 14 Apr 2014 21:53:31 +0530
Message-Id: <8c1eaf95a4c8bead45bbf7154edc40062db9c14c.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_resume_oneshot() and tick_setup_oneshot() have almost the same
implementation and tick_setup_oneshot() can be used easily instead of
tick_resume_oneshot(). So, remove tick_resume_oneshot() and use
tick_setup_oneshot() in its place.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c   |  8 +++++---
 kernel/time/tick-internal.h |  5 -----
 kernel/time/tick-oneshot.c  | 11 -----------
 3 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 298467e..949f3d3 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -363,15 +363,17 @@ void tick_suspend(void)
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
index cb158f7..82fc3f5 100644
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

