Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaFUX3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 19:29:44 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38461 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaFUX33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 19:29:29 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/5] hrtimer: Remove hrtimer_enqueue_reprogram()
Date: Sun, 22 Jun 2014 01:29:17 +0200
Message-Id: <1403393357-2070-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1403393357-2070-1-git-send-email-fweisbec@gmail.com>
References: <1403393357-2070-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

We call hrtimer_enqueue_reprogram() only when we are in high resolution
mode now so we don't need to check that again in hrtimer_enqueue_reprogram().

Once the check is removed, hrtimer_enqueue_reprogram() turns to be an
useless wrapper over hrtimer_reprogram() and can be dropped.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/hrtimer.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 5f30917..8b3ea17 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -602,6 +602,11 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
  * timers, we have to check, whether it expires earlier than the timer for
  * which the clock event device was armed.
  *
+ * Note, that in case the state has HRTIMER_STATE_CALLBACK set, no reprogramming
+ * and no expiry check happens. The timer gets enqueued into the rbtree. The
+ * reprogramming and expiry check is done in the hrtimer_interrupt or in the
+ * softirq.
+ *
  * Called with interrupts disabled and base->cpu_base.lock held
  */
 static int hrtimer_reprogram(struct hrtimer *timer,
@@ -662,18 +667,6 @@ static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base)
 	base->hres_active = 0;
 }
 
-/*
- * When High resolution timers are active, try to reprogram. Note, that in case
- * the state has HRTIMER_STATE_CALLBACK set, no reprogramming and no expiry
- * check happens. The timer gets enqueued into the rbtree. The reprogramming
- * and expiry check is done in the hrtimer_interrupt or in the softirq.
- */
-static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base)
-{
-	return base->cpu_base->hres_active && hrtimer_reprogram(timer, base);
-}
-
 static inline ktime_t hrtimer_update_base(struct hrtimer_cpu_base *base)
 {
 	ktime_t *offs_real = &base->clock_base[HRTIMER_BASE_REALTIME].offset;
@@ -755,8 +748,8 @@ static inline int hrtimer_is_hres_enabled(void) { return 0; }
 static inline int hrtimer_switch_to_hres(void) { return 0; }
 static inline void
 hrtimer_force_reprogram(struct hrtimer_cpu_base *base, int skip_equal) { }
-static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base)
+static inline int hrtimer_reprogram(struct hrtimer *timer,
+				    struct hrtimer_clock_base *base)
 {
 	return 0;
 }
@@ -1025,7 +1018,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 		 */
 		wake_up_nohz_cpu(base->cpu_base->cpu);
 	} else if (new_base->cpu_base == &__get_cpu_var(hrtimer_bases) &&
-			hrtimer_enqueue_reprogram(timer, new_base)) {
+			hrtimer_reprogram(timer, new_base)) {
 		/*
 		 * Only allow reprogramming if the new base is on this CPU.
 		 * (it might still be on another CPU if the timer was pending)
-- 
1.8.3.1

