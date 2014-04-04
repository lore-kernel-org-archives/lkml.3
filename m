Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaDDGmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:42:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36993 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaDDGm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:42:26 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 27/36] hrtimer: call switch_hrtimer_base() after setting new expiry time
Date: Fri,  4 Apr 2014 12:06:10 +0530
Message-Id: <c24f642621d35932ed55417e609736240451bccd.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
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
__hrtimer_start_range_ns() and at the point (where we call
switch_hrtimer_base()) expiration time is not yet known as we call this routine
later:

hrtimer_set_expires_range_ns()

To fix this, we need to find the updated expiry time before calling
switch_hrtimer_base() from hrtimer_set_expires_range_ns().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index c712960..81e0251 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -964,11 +964,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
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
@@ -977,12 +974,15 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 		 * timeouts. This will go away with the GTOD framework.
 		 */
 #ifdef CONFIG_TIME_LOW_RES
-		tim = ktime_add_safe(tim, new_base->resolution);
+		tim = ktime_add_safe(tim, base->resolution);
 #endif
 	}
 
 	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
 
+	/* Switch the timer base, if necessary: */
+	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
+
 	timer_stats_hrtimer_set_start_info(timer);
 
 	leftmost = enqueue_hrtimer(timer, new_base);
@@ -1000,7 +1000,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 			 * We need to drop cpu_base->lock to avoid a
 			 * lock ordering issue vs. rq->lock.
 			 */
-			raw_spin_unlock(&new_base->cpu_base->lock);
+			raw_spin_unlock(&timer->base->cpu_base->lock);
 			raise_softirq_irqoff(HRTIMER_SOFTIRQ);
 			local_irq_restore(flags);
 			return ret;
-- 
1.7.12.rc2.18.g61b472e

