Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaDPIbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:31:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41933 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaDPIbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:31:33 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V1 Resend] hrtimer: call switch_hrtimer_base() after setting new expiry time
Date: Wed, 16 Apr 2014 14:01:19 +0530
Message-Id: <8ed33f7e6e58b1a51fa156cf69831a177d724456.1397636308.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In switch_hrtimer_base() we are calling hrtimer_check_target() which guarantees
this:

/*
 * With HIGHRES=y we do not migrate the timer when it is expiring
 * before the next event on the target cpu because we cannot reprogram
 * the target cpu hardware and we would cause it to fire late.
 *
 * Called with cpu_base->lock of target cpu held.
 */

But switch_hrtimer_base() is only called from one place, i.e.
__hrtimer_start_range_ns() and at that point (where we call
switch_hrtimer_base()) expiration time is not yet known as we call this routine
later: hrtimer_set_expires_range_ns().

To fix this, we need to find the updated expiry time before calling
switch_hrtimer_base().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Hi Thomas,

I have sent this previously as part of: https://lkml.org/lkml/2014/4/4/23

But as you asked to send bugfixes without any dependencies for ticks patches, I
thought of sending bugfixes separately for timers too. This was the only bugfix
from that series and other patches don't conflict with it, so I am not resending
other patches from above series again.

Not adding any stable tags as this is broken from a long long time and don't
know if you want to fix it for those kernels.

 kernel/hrtimer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index d55092c..c86b95a 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -968,11 +968,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	/* Remove an active timer from the queue: */
 	ret = remove_hrtimer(timer, base);
 
-	/* Switch the timer base, if necessary: */
-	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
-
 	if (mode & HRTIMER_MODE_REL) {
-		tim = ktime_add_safe(tim, new_base->get_time());
+		tim = ktime_add_safe(tim, base->get_time());
 		/*
 		 * CONFIG_TIME_LOW_RES is a temporary way for architectures
 		 * to signal that they simply return xtime in
@@ -987,6 +984,9 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
 
+	/* Switch the timer base, if necessary: */
+	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
+
 	timer_stats_hrtimer_set_start_info(timer);
 
 	leftmost = enqueue_hrtimer(timer, new_base);
-- 
1.7.12.rc2.18.g61b472e

