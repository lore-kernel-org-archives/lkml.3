Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaDDGmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:42:43 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57866 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaDDGmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:42:38 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 29/36] hrtimer: remove 'base' parameter from switch_hrtimer_base()
Date: Fri,  4 Apr 2014 12:06:12 +0530
Message-Id: <572cbf109770a5b8fc9f595d73145a73721a5e0f.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
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
index a404436..c35dc36 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -212,10 +212,9 @@ hrtimer_check_target(struct hrtimer *timer, struct hrtimer_clock_base *new_base)
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
@@ -267,7 +266,7 @@ lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 	return base;
 }
 
-# define switch_hrtimer_base(t, b, p)	(b)
+# define switch_hrtimer_base(t, p)	(t->base)
 
 #endif	/* !CONFIG_SMP */
 
@@ -978,7 +977,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
 
 	/* Switch the timer base, if necessary: */
-	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
+	new_base = switch_hrtimer_base(timer, mode & HRTIMER_MODE_PINNED);
 
 	timer_stats_hrtimer_set_start_info(timer);
 
-- 
1.7.12.rc2.18.g61b472e

