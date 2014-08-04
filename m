Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaHDQ7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:59:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56567 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "John Stultz" <john.stultz@linaro.org>,
        "Prarit Bhargava" <prarit@redhat.com>,
        "Sharvil Nanavati" <sharvil@google.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@kernel.org>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.691314519@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 42/94] alarmtimer: Fix bug where relative alarm timers
 were treated as absolute
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/time/alarmtimer.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -563,9 +563,14 @@ static int alarm_timer_set(struct k_itim
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
 
@@ -575,8 +580,16 @@ static int alarm_timer_set(struct k_itim
 
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
 
@@ -708,6 +721,9 @@ static int alarm_timer_nsleep(const cloc
 	if (!alarmtimer_get_rtcdev())
 		return -ENOTSUPP;
 
+	if (flags & ~TIMER_ABSTIME)
+		return -EINVAL;
+
 	if (!capable(CAP_WAKE_ALARM))
 		return -EPERM;
 

