Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbaC1Lnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:43:42 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:49966 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaC1Lni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:43:38 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 15/16] hrtimer: create base_on_this_cpu()
Date: Fri, 28 Mar 2014 17:11:34 +0530
Message-Id: <24bf5c053d9b39412b0f2d56d980bf9d85149ae2.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had this code at two places to find if a clock base belongs to current CPU:
	base->cpu_base == &__get_cpu_var(hrtimer_bases)

Better to get a inlined routine for that.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 5d77f36..83e5f2d 100644
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
@@ -916,8 +920,7 @@ static inline int remove_hrtimer(struct hrtimer *timer)
 	 * move the timer base in switch_hrtimer_base.
 	 */
 	state = timer->state & HRTIMER_STATE_CALLBACK;
-	__remove_hrtimer(timer, state,
-			timer->base->cpu_base == &__get_cpu_var(hrtimer_bases));
+	__remove_hrtimer(timer, state, base_on_this_cpu(timer->base));
 	return 1;
 }
 
@@ -964,9 +967,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	 *
 	 * XXX send_remote_softirq() ?
 	 */
-	if (hrtimer_is_leftmost(timer) &&
-	    new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
-		&& hrtimer_enqueue_reprogram(timer)) {
+	if (hrtimer_is_leftmost(timer) && base_on_this_cpu(new_base) &&
+	    hrtimer_enqueue_reprogram(timer)) {
 		if (wakeup) {
 			/*
 			 * We need to drop cpu_base->lock to avoid a
-- 
1.7.12.rc2.18.g61b472e

