Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbaDNQyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:54:18 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41359 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbaDNQZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:25:44 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 15/38] tick-common: remove tick_check_replacement()
Date: Mon, 14 Apr 2014 21:53:37 +0530
Message-Id: <a981c373e66ccf2d4891741748ca0dcf4935aa15.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_check_replacement() is now nothing more than a wrapper over
tick_check_preferred() and hence can be removed. Use tick_check_preferred()
everywhere.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/clockevents.c   |  2 +-
 kernel/time/tick-common.c   | 16 +++++-----------
 kernel/time/tick-internal.h |  2 +-
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 6680a0d..d80e891 100644
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
index 3bd9f9c..c1b3619 100644
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
@@ -263,16 +267,6 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
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

