Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3KYNI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:08:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57194 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab3KYNIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:08:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 46/78] alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev doesn't exist
Date: Mon, 25 Nov 2013 13:06:33 +0000
Message-Id: <1385384825-21681-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 98d6f4dd84a134d942827584a3c5f67ffd8ec35f upstream.

Fedora Ruby maintainer reported latest Ruby doesn't work on Fedora Rawhide
on ARM. (http://bugs.ruby-lang.org/issues/9008)

Because of, commit 1c6b39ad3f (alarmtimers: Return -ENOTSUPP if no
RTC device is present) intruduced to return ENOTSUPP when
clock_get{time,res} can't find a RTC device. However this is incorrect.

First, ENOTSUPP isn't exported to userland (ENOTSUP or EOPNOTSUP are the
closest userland equivlents).

Second, Posix and Linux man pages agree that clock_gettime and
clock_getres should return EINVAL if clk_id argument is invalid.
While the arugment that the clockid is valid, but just not supported
on this hardware could be made, this is just a technicality that
doesn't help userspace applicaitons, and only complicates error
handling.

Thus, this patch changes the code to use EINVAL.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: Vit Ondruch <v.ondruch@tiscali.cz>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
[jstultz: Tweaks to commit message to include full rational]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/alarmtimer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index aa27d39..2cfe9a5 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -474,7 +474,7 @@ static int alarm_clock_getres(const clockid_t which_clock, struct timespec *tp)
 	clockid_t baseid = alarm_bases[clock2alarm(which_clock)].base_clockid;
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EINVAL;
 
 	return hrtimer_get_res(baseid, tp);
 }
@@ -491,7 +491,7 @@ static int alarm_clock_get(clockid_t which_clock, struct timespec *tp)
 	struct alarm_base *base = &alarm_bases[clock2alarm(which_clock)];
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EINVAL;
 
 	*tp = ktime_to_timespec(base->gettime());
 	return 0;
-- 
1.8.3.2

