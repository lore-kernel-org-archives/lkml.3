Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaC1Lmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:42:50 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59572 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaC1Lmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:42:47 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 08/16] hrtimer: make switch_hrtimer_base() return void
Date: Fri, 28 Mar 2014 17:11:27 +0530
Message-Id: <d43b5d11a1d15aab34e51fc6adbdbd140ca62518.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

switch_hrtimer_base() always sets timer->base to the right base and so the
caller can obtain it easily. So, this routine doesn't need to return anything.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 98a73d9..d98c1ec 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -194,8 +194,7 @@ hrtimer_check_target(struct hrtimer *timer, struct hrtimer_clock_base *new_base)
 /*
  * Switch the timer base to the current CPU when possible.
  */
-static inline struct hrtimer_clock_base *
-switch_hrtimer_base(struct hrtimer *timer, int pinned)
+static inline void switch_hrtimer_base(struct hrtimer *timer, int pinned)
 {
 	struct hrtimer_clock_base *new_base, *base = timer->base;
 	struct hrtimer_cpu_base *new_cpu_base;
@@ -217,7 +216,7 @@ again:
 		 * the timer is enqueued.
 		 */
 		if (unlikely(hrtimer_callback_running(timer)))
-			return base;
+			return;
 
 		/* See the comment in lock_timer_base() */
 		timer->base = NULL;
@@ -233,7 +232,6 @@ again:
 		}
 		timer->base = new_base;
 	}
-	return new_base;
 }
 
 #else /* CONFIG_SMP */
@@ -248,7 +246,7 @@ lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 	return base;
 }
 
-# define switch_hrtimer_base(t, p)	(t->base)
+static inline void switch_hrtimer_base(struct hrtimer *timer, int pinned) {}
 
 #endif	/* !CONFIG_SMP */
 
@@ -952,7 +950,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	ret = remove_hrtimer(timer);
 
 	/* Switch the timer base, if necessary: */
-	new_base = switch_hrtimer_base(timer, mode & HRTIMER_MODE_PINNED);
+	switch_hrtimer_base(timer, mode & HRTIMER_MODE_PINNED);
+	new_base = timer->base;
 
 	if (mode & HRTIMER_MODE_REL) {
 		tim = ktime_add_safe(tim, new_base->get_time());
-- 
1.7.12.rc2.18.g61b472e

