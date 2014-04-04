Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaDDGm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:42:57 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:64984 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbaDDGmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:42:49 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 31/36] hrtimer: remove 'base' parameter from hrtimer_{enqueue_}reprogram()
Date: Fri,  4 Apr 2014 12:06:14 +0530
Message-Id: <c1551b35eb5e40320ab2b655d32f4144398ea6b2.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
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
index abbf155..fcbabcf 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -597,11 +597,10 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
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
@@ -661,10 +660,9 @@ static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base)
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
@@ -743,8 +741,7 @@ void clock_was_set_delayed(void)
 static inline int hrtimer_hres_active(void) { return 0; }
 static inline int hrtimer_is_hres_enabled(void) { return 0; }
 static inline int hrtimer_switch_to_hres(void) { return 0; }
-static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base)
+static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer)
 {
 	return 0;
 }
@@ -991,7 +988,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	 * XXX send_remote_softirq() ?
 	 */
 	if (leftmost && base_on_this_cpu(new_base)
-		&& hrtimer_enqueue_reprogram(timer, new_base)) {
+		&& hrtimer_enqueue_reprogram(timer)) {
 		if (wakeup) {
 			/*
 			 * We need to drop cpu_base->lock to avoid a
-- 
1.7.12.rc2.18.g61b472e

