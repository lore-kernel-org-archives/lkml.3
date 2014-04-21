Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaDUJ7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:59:25 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:41279 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaDUJ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:56:28 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 11/19] tick-common: remove tick_check_replacement()
Date: Mon, 21 Apr 2014 15:25:07 +0530
Message-Id: <03a6046b4db8c6587f75775b274e2fd3655a550c.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_check_replacement() is now nothing more than a dummy wrapper over
tick_check_preferred() and can be removed.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/clockevents.c   |  2 +-
 kernel/time/tick-common.c   | 16 +++++-----------
 kernel/time/tick-internal.h |  2 +-
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index a3e9333..15ff71d 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -298,7 +298,7 @@ static int clockevents_replace(struct clock_event_device *ced)
 		if (dev == ced || dev->mode != CLOCK_EVT_MODE_UNUSED)
 			continue;
 
-		if (!tick_check_replacement(newdev, dev))
+		if (!tick_check_preferred(newdev, dev))
 			continue;
 
 		if (!try_module_get(dev->owner))
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 9d3106b..896c992 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -230,7 +230,11 @@ static bool tick_check_percpu(struct clock_event_device *curdev,
 	return true;
 }
 
-static bool tick_check_preferred(struct clock_event_device *curdev,
+/*
+ * Check whether the new device is a better fit than curdev. curdev
+ * can be NULL !
+ */
+bool tick_check_preferred(struct clock_event_device *curdev,
 				 struct clock_event_device *newdev)
 {
 	if (!tick_check_percpu(curdev, newdev, smp_processor_id()))
@@ -254,16 +258,6 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
 }
 
 /*
- * Check whether the new device is a better fit than curdev. curdev
- * can be NULL !
- */
-bool tick_check_replacement(struct clock_event_device *curdev,
-			    struct clock_event_device *newdev)
-{
-	return tick_check_preferred(curdev, newdev);
-}
-
-/*
  * Check, if the new registered device should be used. Called with
  * clockevents_lock held and interrupts disabled.
  */
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 65f080a..8c6e85d 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -24,7 +24,7 @@ extern void tick_handover_do_timer(int *cpup);
 extern void tick_shutdown(unsigned int *cpup);
 extern void tick_suspend(void);
 extern void tick_resume(void);
-extern bool tick_check_replacement(struct clock_event_device *curdev,
+extern bool tick_check_preferred(struct clock_event_device *curdev,
 				   struct clock_event_device *newdev);
 extern void tick_install_replacement(struct clock_event_device *dev);
 
-- 
1.7.12.rc2.18.g61b472e

