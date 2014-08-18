Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaHRKG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:06:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42477 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaHRJdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Prarit Bhargava <prarit@redhat.com>,
        Sharvil Nanavati <sharvil@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 009/137] alarmtimer: Fix bug where relative alarm timers were treated as absolute
Date: Mon, 18 Aug 2014 10:31:10 +0100
Message-Id: <1408354398-10226-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit 16927776ae757d0d132bdbfabbfe2c498342bd59 upstream.

Sharvil noticed with the posix timer_settime interface, using the
CLOCK_REALTIME_ALARM or CLOCK_BOOTTIME_ALARM clockid, if the users
tried to specify a relative time timer, it would incorrectly be
treated as absolute regardless of the state of the flags argument.

This patch corrects this, properly checking the absolute/relative flag,
as well as adds further error checking that no invalid flag bits are set.

Reported-by: Sharvil Nanavati <sharvil@google.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Sharvil Nanavati <sharvil@google.com>
Link: http://lkml.kernel.org/r/1404767171-6902-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/alarmtimer.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 88c9c65a430d..fe75444ae7ec 100644
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

