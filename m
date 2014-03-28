Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaC1Lmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:42:45 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:53262 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaC1Lmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:42:39 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 07/16] hrtimer: remove 'base' parameter from hrtimer_{enqueue_}reprogram()
Date: Fri, 28 Mar 2014 17:11:26 +0530
Message-Id: <b102337f493080849eaaea486fdc51003ff06303.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clock 'base' can be obtained easily by doing timer->base and hrtimer_reprogram()
& hrtimer_enqueue_reprogram() never gets anything else than timer->base as its
parameter. And so these routines doesn't require this parameter. Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index d6724b5..98a73d9 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -584,11 +584,10 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
  *
  * Called with interrupts disabled and base->cpu_base.lock held
  */
-static int hrtimer_reprogram(struct hrtimer *timer,
-			     struct hrtimer_clock_base *base)
+static int hrtimer_reprogram(struct hrtimer *timer)
 {
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-	ktime_t expires = hrtimer_get_monoexpires(timer, base);
+	ktime_t expires = hrtimer_get_monoexpires(timer, timer->base);
 	int res;
 
 	WARN_ON_ONCE(hrtimer_get_expires_tv64(timer) < 0);
@@ -648,10 +647,9 @@ static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base)
  * check happens. The timer gets enqueued into the rbtree. The reprogramming
  * and expiry check is done in the hrtimer_interrupt or in the softirq.
  */
-static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base)
+static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer)
 {
-	return base->cpu_base->hres_active && hrtimer_reprogram(timer, base);
+	return timer->base->cpu_base->hres_active && hrtimer_reprogram(timer);
 }
 
 static inline ktime_t hrtimer_update_base(struct hrtimer_cpu_base *base)
@@ -730,8 +728,7 @@ static void clock_was_set_delayed(void)
 static inline int hrtimer_hres_active(void) { return 0; }
 static inline int hrtimer_is_hres_enabled(void) { return 0; }
 static inline int hrtimer_switch_to_hres(void) { return 0; }
-static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base)
+static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer)
 {
 	return 0;
 }
@@ -984,7 +981,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	 * XXX send_remote_softirq() ?
 	 */
 	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
-		&& hrtimer_enqueue_reprogram(timer, new_base)) {
+		&& hrtimer_enqueue_reprogram(timer)) {
 		if (wakeup) {
 			/*
 			 * We need to drop cpu_base->lock to avoid a
-- 
1.7.12.rc2.18.g61b472e

