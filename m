Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaDDGpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:45:46 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:62692 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaDDGmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:42:32 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 28/36] hrtimer: remove 'base' parameter from remove_timer() and __remove_timer()
Date: Fri,  4 Apr 2014 12:06:11 +0530
Message-Id: <38fa0782392646448215337b29bb0871ce6f5dbe.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clock 'base' can be obtained easily by doing timer->base and remove_timer()/
__remove_timer() never gets anything else than timer->base as its parameter.
Which means, these routines doesn't require this parameter. Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 81e0251..a404436 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -895,10 +895,10 @@ static int enqueue_hrtimer(struct hrtimer *timer,
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
 	struct timerqueue_node *next_timer;
 
 	next_timer = timerqueue_getnext(&base->active);
@@ -921,11 +921,8 @@ static void __remove_hrtimer(struct hrtimer *timer,
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
 	unsigned long state;
 
@@ -947,7 +944,7 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 	 * move the timer base in switch_hrtimer_base.
 	 */
 	state = timer->state & HRTIMER_STATE_CALLBACK;
-	__remove_hrtimer(timer, base, state, base_on_this_cpu(base));
+	__remove_hrtimer(timer, state, base_on_this_cpu(timer->base));
 	return 1;
 }
 
@@ -962,7 +959,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	base = lock_hrtimer_base(timer, &flags);
 
 	/* Remove an active timer from the queue: */
-	ret = remove_hrtimer(timer, base);
+	ret = remove_hrtimer(timer);
 
 	if (mode & HRTIMER_MODE_REL) {
 		tim = ktime_add_safe(tim, base->get_time());
@@ -1064,14 +1061,13 @@ EXPORT_SYMBOL_GPL(hrtimer_start);
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
 
@@ -1223,7 +1219,7 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 	WARN_ON(!irqs_disabled());
 
 	debug_deactivate(timer);
-	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
+	__remove_hrtimer(timer, HRTIMER_STATE_CALLBACK, 0);
 	timer_stats_account_hrtimer(timer);
 	fn = timer->function;
 
@@ -1660,7 +1656,7 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
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

