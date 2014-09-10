Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaIJBbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 21:31:31 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:60045 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaIJBb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 21:31:29 -0400
From: Richard Larocque <rlarocque@google.com>
To: tglx@linutronix.de, john.stultz@linaro.org
Cc: linux-kernel@vger.kernel.org, Richard Larocque <rlarocque@google.com>
Subject: [PATCH 1/3] alarmtimer: Return relative times in timer_gettime
Date: Tue,  9 Sep 2014 18:31:03 -0700
Message-Id: <1410312665-25381-2-git-send-email-rlarocque@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410312665-25381-1-git-send-email-rlarocque@google.com>
References: <1410312665-25381-1-git-send-email-rlarocque@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Returns the time remaining for an alarm timer, rather than the time at
which it is scheduled to expire.  If the timer has already expired or it
is not currently scheduled, the it_value's members are set to zero.

This new behavior matches that of the other posix-timers and the POSIX
specifications.

This is a change in user-visible behavior, and may break existing
applications.  Hopefully, few users rely on the old incorrect behavior.

Signed-off-by: Richard Larocque <rlarocque@google.com>
---
 kernel/time/alarmtimer.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 4aec4a4..cb31fd0 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -541,18 +541,21 @@ static int alarm_timer_create(struct k_itimer *new_timer)
  * @new_timer: k_itimer pointer
  * @cur_setting: itimerspec data to fill
  *
- * Copies the itimerspec data out from the k_itimer
+ * Copies out the current itimerspec data
  */
 static void alarm_timer_get(struct k_itimer *timr,
 				struct itimerspec *cur_setting)
 {
-	memset(cur_setting, 0, sizeof(struct itimerspec));
+	ktime_t relative_expiry_time =
+		alarm_expires_remaining(&(timr->it.alarm.alarmtimer));
+	if (ktime_to_ns(relative_expiry_time) > 0) {
+		cur_setting->it_value = ktime_to_timespec(relative_expiry_time);
+	} else {
+		cur_setting->it_value.tv_sec = 0;
+		cur_setting->it_value.tv_nsec = 0;
+	}
 
-	cur_setting->it_interval =
-			ktime_to_timespec(timr->it.alarm.interval);
-	cur_setting->it_value =
-		ktime_to_timespec(timr->it.alarm.alarmtimer.node.expires);
-	return;
+	cur_setting->it_interval = ktime_to_timespec(timr->it.alarm.interval);
 }
 
 /**
-- 
2.1.0.rc2.206.gedb03e5

