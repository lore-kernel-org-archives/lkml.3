Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaILVXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:23:30 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43017 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaILVWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:22:39 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Richard Larocque <rlarocque@google.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Sharvil Nanavati <sharvil@google.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 2/4] alarmtimer: Return relative times in timer_gettime
Date: Fri, 12 Sep 2014 14:22:22 -0700
Message-Id: <1410556944-14944-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410556944-14944-1-git-send-email-john.stultz@linaro.org>
References: <1410556944-14944-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Larocque <rlarocque@google.com>

Returns the time remaining for an alarm timer, rather than the time at
which it is scheduled to expire.  If the timer has already expired or it
is not currently scheduled, the it_value's members are set to zero.

This new behavior matches that of the other posix-timers and the POSIX
specifications.

This is a change in user-visible behavior, and may break existing
applications.  Hopefully, few users rely on the old incorrect behavior.

Cc: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Sharvil Nanavati <sharvil@google.com>
Signed-off-by: Richard Larocque <rlarocque@google.com>
[jstultz: minor style tweak]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/alarmtimer.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 4aec4a4..b4bce62 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -541,18 +541,22 @@ static int alarm_timer_create(struct k_itimer *new_timer)
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
 
-	cur_setting->it_interval =
-			ktime_to_timespec(timr->it.alarm.interval);
-	cur_setting->it_value =
-		ktime_to_timespec(timr->it.alarm.alarmtimer.node.expires);
-	return;
+	if (ktime_to_ns(relative_expiry_time) > 0) {
+		cur_setting->it_value = ktime_to_timespec(relative_expiry_time);
+	} else {
+		cur_setting->it_value.tv_sec = 0;
+		cur_setting->it_value.tv_nsec = 0;
+	}
+
+	cur_setting->it_interval = ktime_to_timespec(timr->it.alarm.interval);
 }
 
 /**
-- 
1.9.1

