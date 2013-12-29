Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3L2DFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 22:05:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54987 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799Ab3L2CJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:47 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Frederic Weisbecker" <fweisbec@gmail.com>,
        "John Stultz" <john.stultz@linaro.org>,
        "Vit Ondruch" <v.ondruch@tiscali.cz>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.830646529@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 008/185] alarmtimer: return EINVAL instead of ENOTSUPP
 if rtcdev doesn't exist
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/time/alarmtimer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -468,7 +468,7 @@ static int alarm_clock_getres(const cloc
 	clockid_t baseid = alarm_bases[clock2alarm(which_clock)].base_clockid;
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EINVAL;
 
 	return hrtimer_get_res(baseid, tp);
 }
@@ -485,7 +485,7 @@ static int alarm_clock_get(clockid_t whi
 	struct alarm_base *base = &alarm_bases[clock2alarm(which_clock)];
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EINVAL;
 
 	*tp = ktime_to_timespec(base->gettime());
 	return 0;

