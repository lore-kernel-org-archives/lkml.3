Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaC1LmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:42:21 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:61749 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaC1LmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:42:17 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 04/16] hrtimer: remove 'base' parameter from remove_timer() and __remove_timer()
Date: Fri, 28 Mar 2014 17:11:23 +0530
Message-Id: <b64d746a77be2bbd38c772419febc5e2b4d94dc4.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clock 'base' can be obtained easily by doing timer->base and remove_timer()/
__remove_timer() never gets anything else than timer->base as its parameter.
Which means, these routines doesn't require this parameter. Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 675fe9e..343fe99 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -883,10 +883,11 @@ static int enqueue_hrtimer(struct hrtimer *timer,
  * reprogram to zero. This is useful, when the context does a reprogramming
  * anyway (e.g. timer interrupt)
  */
-static void __remove_hrtimer(struct hrtimer *timer,
-			     struct hrtimer_clock_base *base,
-			     unsigned long newstate, int reprogram)
+static void __remove_hrtimer(struct hrtimer *timer, unsigned long newstate,
+			     int reprogram)
 {
+	struct hrtimer_clock_base *base = timer->base;
+
 	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
 		goto out;
 
@@ -909,11 +910,8 @@ out:
 	timer->state = newstate;
 }
 
-/*
- * remove hrtimer, called with base lock held
- */
-static inline int
-remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
+/* remove hrtimer, called with base lock held */
+static inline int remove_hrtimer(struct hrtimer *timer)
 {
 	if (hrtimer_is_queued(timer)) {
 		unsigned long state;
@@ -929,14 +927,15 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 		 */
 		debug_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
-		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
+		reprogram =
+			timer->base->cpu_base == &__get_cpu_var(hrtimer_bases);
 		/*
 		 * We must preserve the CALLBACK state flag here,
 		 * otherwise we could move the timer base in
 		 * switch_hrtimer_base.
 		 */
 		state = timer->state & HRTIMER_STATE_CALLBACK;
-		__remove_hrtimer(timer, base, state, reprogram);
+		__remove_hrtimer(timer, state, reprogram);
 		return 1;
 	}
 	return 0;
@@ -953,7 +952,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	base = lock_hrtimer_base(timer, &flags);
 
 	/* Remove an active timer from the queue: */
-	ret = remove_hrtimer(timer, base);
+	ret = remove_hrtimer(timer);
 
 	/* Switch the timer base, if necessary: */
 	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
@@ -1055,14 +1054,13 @@ EXPORT_SYMBOL_GPL(hrtimer_start);
  */
 int hrtimer_try_to_cancel(struct hrtimer *timer)
 {
-	struct hrtimer_clock_base *base;
 	unsigned long flags;
 	int ret = -1;
 
-	base = lock_hrtimer_base(timer, &flags);
+	lock_hrtimer_base(timer, &flags);
 
 	if (!hrtimer_callback_running(timer))
-		ret = remove_hrtimer(timer, base);
+		ret = remove_hrtimer(timer);
 
 	unlock_hrtimer_base(timer, &flags);
 
@@ -1218,7 +1216,7 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 	WARN_ON(!irqs_disabled());
 
 	debug_deactivate(timer);
-	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
+	__remove_hrtimer(timer, HRTIMER_STATE_CALLBACK, 0);
 	timer_stats_account_hrtimer(timer);
 	fn = timer->function;
 
@@ -1663,7 +1661,7 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 		 * timer could be seen as !active and just vanish away
 		 * under us on another CPU
 		 */
-		__remove_hrtimer(timer, old_base, HRTIMER_STATE_MIGRATE, 0);
+		__remove_hrtimer(timer, HRTIMER_STATE_MIGRATE, 0);
 		timer->base = new_base;
 		/*
 		 * Enqueue the timers on the new cpu. This does not
-- 
1.7.12.rc2.18.g61b472e

