Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab3JNVd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:33:29 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54491 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab3JNVd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:33:27 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev doesn't exist
Date: Mon, 14 Oct 2013 17:33:16 -0400
Message-Id: <1381786396-1818-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Fedora Ruby maintainer reported latest Ruby doesn't work on Fedora Rawhide
on ARM. (http://bugs.ruby-lang.org/issues/9008)

Because of, commit 1c6b39ad3f (alarmtimers: Return -ENOTSUPP if no
RTC device is present) intruduced to return ENOTSUPP when
clock_get{time,res} can't find a RTC device. However it is incorrect.

Posix and Linux man pages agree that clock_gettime and clock_getres
should return EINVAL if clk_id argument is invalid. This is significant
different from timer_create API.

This patch fixes it.

Reported-by: Vit Ondruch <v.ondruch@tiscali.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/time/alarmtimer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index eec50fc..88c9c65 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -490,7 +490,7 @@ static int alarm_clock_getres(const clockid_t which_clock, struct timespec *tp)
 	clockid_t baseid = alarm_bases[clock2alarm(which_clock)].base_clockid;
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EINVAL;
 
 	return hrtimer_get_res(baseid, tp);
 }
@@ -507,7 +507,7 @@ static int alarm_clock_get(clockid_t which_clock, struct timespec *tp)
 	struct alarm_base *base = &alarm_bases[clock2alarm(which_clock)];
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EINVAL;
 
 	*tp = ktime_to_timespec(base->gettime());
 	return 0;
-- 
1.7.1

