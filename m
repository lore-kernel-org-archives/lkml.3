Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528Ab3LBVQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:16:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab3LBTMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:12:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vit Ondruch <v.ondruch@tiscali.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3.10 022/173] alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev doesnt exist
Date: Mon,  2 Dec 2013 11:10:05 -0800
Message-Id: <20131202191145.378681080@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/alarmtimer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -445,7 +445,7 @@ static int alarm_clock_getres(const cloc
 	clockid_t baseid = alarm_bases[clock2alarm(which_clock)].base_clockid;
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EINVAL;
 
 	return hrtimer_get_res(baseid, tp);
 }
@@ -462,7 +462,7 @@ static int alarm_clock_get(clockid_t whi
 	struct alarm_base *base = &alarm_bases[clock2alarm(which_clock)];
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EINVAL;
 
 	*tp = ktime_to_timespec(base->gettime());
 	return 0;


