Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbaDDGnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:43:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52233 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbaDDGnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:43:01 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 33/36] hrtimer: make lock_hrtimer_base() return void
Date: Fri,  4 Apr 2014 12:06:16 +0530
Message-Id: <70dd1920bcbc74a98a61340e44a5915ec4e8e1bf.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
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
index e581bba..ea620e5 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -166,9 +166,7 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
  * possible to set timer->base = NULL and drop the lock: the timer remains
  * locked.
  */
-static
-struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
-					     unsigned long *flags)
+static void lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 {
 	struct hrtimer_clock_base *base;
 
@@ -177,7 +175,7 @@ struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
 		if (likely(base != NULL)) {
 			raw_spin_lock_irqsave(&base->cpu_base->lock, *flags);
 			if (likely(base == timer->base))
-				return base;
+				return;
 			/* The timer has migrated to another CPU: */
 			raw_spin_unlock_irqrestore(&base->cpu_base->lock, *flags);
 		}
@@ -254,14 +252,10 @@ again:
 
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
@@ -951,7 +945,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	unsigned long flags;
 	int ret, leftmost;
 
-	base = lock_hrtimer_base(timer, &flags);
+	lock_hrtimer_base(timer, &flags);
+	base = timer->base;
 
 	/* Remove an active timer from the queue: */
 	ret = remove_hrtimer(timer);
-- 
1.7.12.rc2.18.g61b472e

