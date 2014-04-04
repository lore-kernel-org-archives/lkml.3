Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaDDGow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:44:52 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47890 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaDDGmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:42:55 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 32/36] hrtimer: make switch_hrtimer_base() return void
Date: Fri,  4 Apr 2014 12:06:15 +0530
Message-Id: <7cdbe065e7f05587461b21583ca76b63cee5f16e.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

switch_hrtimer_base() always sets timer->base to the right base and so the
caller can obtain it easily. So, this routine doesn't need to return anything.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index fcbabcf..e581bba 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -211,8 +211,7 @@ hrtimer_check_target(struct hrtimer *timer, struct hrtimer_clock_base *new_base)
 /*
  * Switch the timer base to the current CPU when possible.
  */
-static inline struct hrtimer_clock_base *
-switch_hrtimer_base(struct hrtimer *timer, int pinned)
+static inline void switch_hrtimer_base(struct hrtimer *timer, int pinned)
 {
 	struct hrtimer_clock_base *new_base, *base = timer->base;
 	struct hrtimer_cpu_base *new_cpu_base;
@@ -224,7 +223,7 @@ again:
 	new_base = &new_cpu_base->clock_base[base->index];
 
 	if (base == new_base)
-		return base;
+		return;
 
 	/*
 	 * We are trying to move timer to new_base. However we can't change
@@ -235,7 +234,7 @@ again:
 	 * timer is enqueued.
 	 */
 	if (unlikely(hrtimer_callback_running(timer)))
-		return base;
+		return;
 
 	/* See the comment in lock_timer_base() */
 	timer->base = NULL;
@@ -251,7 +250,6 @@ again:
 	}
 
 	timer->base = new_base;
-	return new_base;
 }
 
 #else /* CONFIG_SMP */
@@ -266,7 +264,7 @@ lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 	return base;
 }
 
-# define switch_hrtimer_base(t, p)	(t->base)
+static inline void switch_hrtimer_base(struct hrtimer *timer, int pinned) {}
 
 #endif	/* !CONFIG_SMP */
 
@@ -949,7 +947,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 		unsigned long delta_ns, const enum hrtimer_mode mode,
 		int wakeup)
 {
-	struct hrtimer_clock_base *base, *new_base;
+	struct hrtimer_clock_base *base;
 	unsigned long flags;
 	int ret, leftmost;
 
@@ -975,7 +973,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
 
 	/* Switch the timer base, if necessary: */
-	new_base = switch_hrtimer_base(timer, mode & HRTIMER_MODE_PINNED);
+	switch_hrtimer_base(timer, mode & HRTIMER_MODE_PINNED);
 
 	timer_stats_hrtimer_set_start_info(timer);
 
@@ -987,7 +985,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	 *
 	 * XXX send_remote_softirq() ?
 	 */
-	if (leftmost && base_on_this_cpu(new_base)
+	if (leftmost && base_on_this_cpu(timer->base)
 		&& hrtimer_enqueue_reprogram(timer)) {
 		if (wakeup) {
 			/*
-- 
1.7.12.rc2.18.g61b472e

