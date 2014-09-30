Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaI3Wg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:36:59 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:58632 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaI3Wg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:36:57 -0400
From: Joe Swantek <joseph.swantek@gmail.com>
X-Google-Original-From: Joe Swantek <jswantek@motorola.com>
To: rjw@rjwysocki.net
Cc: pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Swantek <jswantek@motorola.com>
Subject: [PATCH] PM / suspend: Catch wake-up requests in suspend_again
Date: Tue, 30 Sep 2014 17:20:02 -0500
Message-Id: <1412115602-5204-1-git-send-email-jswantek@motorola.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible during the processing of suspend_again() that a
wake-up request (i.e. pm_stay_awake()) be made by a driver in response
to an outside event (i.e. hw interrupt, etc.). Currently, when
suspend_again() requests to re-enter suspend, suspend_enter() runs
to re-enter suspend. The pm_wakeup_pending() function is called to check
for any wake-up requests. However, this function is essentially disabled
because the events_check_enabled flag is set to false by the previous
run through suspend_enter(). This causes any wake-up request made
during the processing of suspend_again() to be delayed until the next
time the kernel resumes sometime in the future.

To resolve this issue, if suspend_again() votes to re-enter
suspend_enter() the count of wake-up requests is re-evaluated
and the events_check_enabled flag set correctly based on the
presence of wake-up requests that occurred during suspend_again().

Signed-off-by: Joe Swantek <jswantek@motorola.com>
---
 kernel/power/suspend.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 18c6219..f619492 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -188,8 +188,25 @@ static void platform_suspend_recover(suspend_state_t state)
 
 static bool platform_suspend_again(suspend_state_t state)
 {
-	return state != PM_SUSPEND_FREEZE && suspend_ops->suspend_again ?
+	int count;
+	bool suspend = state != PM_SUSPEND_FREEZE &&
+		suspend_ops->suspend_again ?
 		suspend_ops->suspend_again() : false;
+
+	if (suspend) {
+		/*
+		 * pm_get_wakeup_count() gets an updated count of wakeup events
+		 * that have occured and will return false (i.e. abort suspend)
+		 * if a wakeup event has been started during suspend_again() and
+		 * is still active. pm_save_wakeup_count() stores the count
+		 * and enables pm_wakeup_pending() to properly analyze wakeup
+		 * events before entering suspend in suspend_enter().
+		 */
+		suspend = pm_get_wakeup_count(&count, false) &&
+			  pm_save_wakeup_count(count);
+	}
+
+	return suspend;
 }
 
 static int suspend_test(int level)
-- 
1.9.1

