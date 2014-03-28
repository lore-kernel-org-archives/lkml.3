Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaC1Lm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:42:58 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33459 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaC1Lm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:42:56 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 09/16] hrtimer: make lock_hrtimer_base() return void
Date: Fri, 28 Mar 2014 17:11:28 +0530
Message-Id: <cd08cd98f1264cdd4bbd47bd6f54c9cde052719b.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lock_hrtimer_base() always returns after taking lock and so timer->base can't
change further. So, callers of this routine can simply do timer->base to get the
base and so we can make this routine return void.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index d98c1ec..7d85b8f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -149,9 +149,7 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
  * possible to set timer->base = NULL and drop the lock: the timer remains
  * locked.
  */
-static
-struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
-					     unsigned long *flags)
+static void lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 {
 	struct hrtimer_clock_base *base;
 
@@ -160,7 +158,7 @@ struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
 		if (likely(base != NULL)) {
 			raw_spin_lock_irqsave(&base->cpu_base->lock, *flags);
 			if (likely(base == timer->base))
-				return base;
+				return;
 			/* The timer has migrated to another CPU: */
 			raw_spin_unlock_irqrestore(&base->cpu_base->lock, *flags);
 		}
@@ -236,14 +234,10 @@ again:
 
 #else /* CONFIG_SMP */
 
-static inline struct hrtimer_clock_base *
+static inline void
 lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 {
-	struct hrtimer_clock_base *base = timer->base;
-
-	raw_spin_lock_irqsave(&base->cpu_base->lock, *flags);
-
-	return base;
+	raw_spin_lock_irqsave(&timer->base->cpu_base->lock, *flags);
 }
 
 static inline void switch_hrtimer_base(struct hrtimer *timer, int pinned) {}
@@ -944,7 +938,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	unsigned long flags;
 	int ret, leftmost;
 
-	base = lock_hrtimer_base(timer, &flags);
+	lock_hrtimer_base(timer, &flags);
+	base = timer->base;
 
 	/* Remove an active timer from the queue: */
 	ret = remove_hrtimer(timer);
-- 
1.7.12.rc2.18.g61b472e

