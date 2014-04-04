Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaDDGl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:41:57 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63525 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbaDDGlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:41:52 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 21/36] hrtimer: create base_on_this_cpu()
Date: Fri,  4 Apr 2014 12:06:04 +0530
Message-Id: <698f137afe7bee33391033aff95218dbf54be301.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had this code at two places to find if a clock base belongs to current CPU:
	base->cpu_base == &__get_cpu_var(hrtimer_bases)

Better to get a inlined routine for that.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 458b952..2d5bb9d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -107,6 +107,10 @@ static inline int hrtimer_clockid_to_base(clockid_t clock_id)
 	return hrtimer_clock_to_base_table[clock_id];
 }
 
+static inline bool base_on_this_cpu(struct hrtimer_clock_base *base)
+{
+	return base->cpu_base == &__get_cpu_var(hrtimer_bases);
+}
 
 /*
  * Get the coarse grained time at the softirq based on xtime and
@@ -933,8 +937,7 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 	 * move the timer base in switch_hrtimer_base.
 	 */
 	state = timer->state & HRTIMER_STATE_CALLBACK;
-	__remove_hrtimer(timer, base, state,
-			 base->cpu_base == &__get_cpu_var(hrtimer_bases));
+	__remove_hrtimer(timer, base, state, base_on_this_cpu(base));
 	return 1;
 }
 
@@ -980,7 +983,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	 *
 	 * XXX send_remote_softirq() ?
 	 */
-	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
+	if (leftmost && base_on_this_cpu(new_base)
 		&& hrtimer_enqueue_reprogram(timer, new_base)) {
 		if (wakeup) {
 			/*
-- 
1.7.12.rc2.18.g61b472e

