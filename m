Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaC1Lme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:42:34 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62186 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaC1Lmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:42:32 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 06/16] hrtimer: remove 'base' parameter from enqueue_hrtimer()
Date: Fri, 28 Mar 2014 17:11:25 +0530
Message-Id: <f046106b2aa98c86b2bf9677b6143d27e2b1800b.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clock 'base' can be obtained easily by doing timer->base and enqueue_hrtimer()
never gets anything else than timer->base as its parameter. And so this routines
doesn't require this parameter. Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 9561336..d6724b5 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -855,9 +855,10 @@ EXPORT_SYMBOL_GPL(hrtimer_forward);
  *
  * Returns 1 when the new timer is the leftmost timer in the tree.
  */
-static int enqueue_hrtimer(struct hrtimer *timer,
-			   struct hrtimer_clock_base *base)
+static int enqueue_hrtimer(struct hrtimer *timer)
 {
+	struct hrtimer_clock_base *base = timer->base;
+
 	debug_activate(timer);
 
 	timerqueue_add(&base->active, &timer->node);
@@ -974,7 +975,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	timer_stats_hrtimer_set_start_info(timer);
 
-	leftmost = enqueue_hrtimer(timer, new_base);
+	leftmost = enqueue_hrtimer(timer);
 
 	/*
 	 * Only allow reprogramming if the new base is on this CPU.
@@ -1207,8 +1208,7 @@ EXPORT_SYMBOL_GPL(hrtimer_get_res);
 
 static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 {
-	struct hrtimer_clock_base *base = timer->base;
-	struct hrtimer_cpu_base *cpu_base = base->cpu_base;
+	struct hrtimer_cpu_base *cpu_base = timer->base->cpu_base;
 	enum hrtimer_restart (*fn)(struct hrtimer *);
 	int restart;
 
@@ -1237,7 +1237,7 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 	 */
 	if (restart != HRTIMER_NORESTART) {
 		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
-		enqueue_hrtimer(timer, base);
+		enqueue_hrtimer(timer);
 	}
 
 	WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
@@ -1670,7 +1670,7 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 		 * sort out already expired timers and reprogram the
 		 * event device.
 		 */
-		enqueue_hrtimer(timer, new_base);
+		enqueue_hrtimer(timer);
 
 		/* Clear the migration state bit */
 		timer->state &= ~HRTIMER_STATE_MIGRATE;
-- 
1.7.12.rc2.18.g61b472e

