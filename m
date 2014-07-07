Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaGGVGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 17:06:24 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47794 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaGGVGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 17:06:20 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Sharvil Nanavati <sharvil@google.com>, stable <stable@vger.kernel.org>
Subject: [PATCH] alarmtimer: Fix bug where relative alarm timers were treated as absolute
Date: Mon,  7 Jul 2014 14:06:11 -0700
Message-Id: <1404767171-6902-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sharvil noticed with the posix timer_settime interface, using the
CLOCK_REALTIME_ALARM or CLOCK_BOOTTIME_ALARM clockid, if the users
tried to specify a relative time timer, it would incorrectly be
treated as absolute regardless of the state of the flags argument.

This patch corrects this, properly checking the absolute/relative flag,
as well as adds further error checking that no invalid flag bits are set.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Sharvil Nanavati <sharvil@google.com>
Cc: stable <stable@vger.kernel.org> #3.0+
Reported-by: Sharvil Nanavati <sharvil@google.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---

Thomas, Ingo: Please consider for tip/timers/urgent for 3.16

 kernel/time/alarmtimer.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 88c9c65..fe75444 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -585,9 +585,14 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
 				struct itimerspec *new_setting,
 				struct itimerspec *old_setting)
 {
+	ktime_t exp;
+
 	if (!rtcdev)
 		return -ENOTSUPP;
 
+	if (flags & ~TIMER_ABSTIME)
+		return -EINVAL;
+
 	if (old_setting)
 		alarm_timer_get(timr, old_setting);
 
@@ -597,8 +602,16 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
 
 	/* start the timer */
 	timr->it.alarm.interval = timespec_to_ktime(new_setting->it_interval);
-	alarm_start(&timr->it.alarm.alarmtimer,
-			timespec_to_ktime(new_setting->it_value));
+	exp = timespec_to_ktime(new_setting->it_value);
+	/* Convert (if necessary) to absolute time */
+	if (flags != TIMER_ABSTIME) {
+		ktime_t now;
+
+		now = alarm_bases[timr->it.alarm.alarmtimer.type].gettime();
+		exp = ktime_add(now, exp);
+	}
+
+	alarm_start(&timr->it.alarm.alarmtimer, exp);
 	return 0;
 }
 
@@ -730,6 +743,9 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
 	if (!alarmtimer_get_rtcdev())
 		return -ENOTSUPP;
 
+	if (flags & ~TIMER_ABSTIME)
+		return -EINVAL;
+
 	if (!capable(CAP_WAKE_ALARM))
 		return -EPERM;
 
-- 
1.9.1

