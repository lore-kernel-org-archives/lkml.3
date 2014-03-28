Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaC1Lm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:42:29 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:65271 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaC1LmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:42:25 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 05/16] hrtimer: remove 'base' parameter from switch_hrtimer_base()
Date: Fri, 28 Mar 2014 17:11:24 +0530
Message-Id: <ced918e28599daa64ba43c4e0d54f2039860ba42.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clock 'base' can be obtained easily by doing timer->base and
switch_hrtimer_base() never gets anything else than timer->base as its
parameter. And so this routines doesn't require this parameter. Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 343fe99..9561336 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -195,10 +195,9 @@ hrtimer_check_target(struct hrtimer *timer, struct hrtimer_clock_base *new_base)
  * Switch the timer base to the current CPU when possible.
  */
 static inline struct hrtimer_clock_base *
-switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
-		    int pinned)
+switch_hrtimer_base(struct hrtimer *timer, int pinned)
 {
-	struct hrtimer_clock_base *new_base;
+	struct hrtimer_clock_base *new_base, *base = timer->base;
 	struct hrtimer_cpu_base *new_cpu_base;
 	int this_cpu = smp_processor_id();
 	int cpu = get_nohz_timer_target(pinned);
@@ -249,7 +248,7 @@ lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 	return base;
 }
 
-# define switch_hrtimer_base(t, b, p)	(b)
+# define switch_hrtimer_base(t, p)	(t->base)
 
 #endif	/* !CONFIG_SMP */
 
@@ -955,7 +954,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	ret = remove_hrtimer(timer);
 
 	/* Switch the timer base, if necessary: */
-	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
+	new_base = switch_hrtimer_base(timer, mode & HRTIMER_MODE_PINNED);
 
 	if (mode & HRTIMER_MODE_REL) {
 		tim = ktime_add_safe(tim, new_base->get_time());
-- 
1.7.12.rc2.18.g61b472e

