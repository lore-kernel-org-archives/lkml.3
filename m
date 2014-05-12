Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaELIMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:12:49 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:40489 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaELIMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:12:46 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        arvind.chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH Resend] hrtimer: call switch_hrtimer_base() after setting new expiry time
Date: Mon, 12 May 2014 13:42:29 +0530
Message-Id: <81999e148745fc51bbcd0615823fbab9b2e87e23.1399882253.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
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
Rebased over: v3.15-rc5

 kernel/hrtimer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6b715c0..e0501fe 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -990,11 +990,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
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
@@ -1009,6 +1006,9 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
 
+	/* Switch the timer base, if necessary: */
+	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
+
 	timer_stats_hrtimer_set_start_info(timer);
 
 	leftmost = enqueue_hrtimer(timer, new_base);
-- 
2.0.0.rc2

