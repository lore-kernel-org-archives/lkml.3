Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbaGSIuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 04:50:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:52326 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530AbaGSIuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 04:50:35 -0400
Date: Sat, 19 Jul 2014 10:50:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] timer updates for 3.16
Message-ID: <alpine.DEB.2.10.1407191046560.24854@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

A single fix for a long standing issue in the alarm timer subsystem,
which was noticed recently when people finally started to use alarm
timers for serious work.

Thanks,

	tglx

------------------>
John Stultz (1):
      alarmtimer: Fix bug where relative alarm timers were treated as absolute


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
 
