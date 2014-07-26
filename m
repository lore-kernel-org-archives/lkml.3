Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbaGZTZX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:25:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaGZTXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sharvil Nanavati <sharvil@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 3.15 090/109] alarmtimer: Fix bug where relative alarm timers were treated as absolute
Date: Sat, 26 Jul 2014 12:02:52 -0700
Message-Id: <20140726190226.567186560@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/alarmtimer.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -585,9 +585,14 @@ static int alarm_timer_set(struct k_itim
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
 
@@ -597,8 +602,16 @@ static int alarm_timer_set(struct k_itim
 
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
 
@@ -730,6 +743,9 @@ static int alarm_timer_nsleep(const cloc
 	if (!alarmtimer_get_rtcdev())
 		return -ENOTSUPP;
 
+	if (flags & ~TIMER_ABSTIME)
+		return -EINVAL;
+
 	if (!capable(CAP_WAKE_ALARM))
 		return -EPERM;
 


