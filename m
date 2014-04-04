Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaDDGmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:42:49 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:63259 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaDDGmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:42:43 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 30/36] hrtimer: remove 'base' parameter from enqueue_hrtimer()
Date: Fri,  4 Apr 2014 12:06:13 +0530
Message-Id: <4918b29417bb8685a1c9e04ee91fbb6cb8820858.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
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
index c35dc36..abbf155 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -867,9 +867,10 @@ EXPORT_SYMBOL_GPL(hrtimer_forward);
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
@@ -981,7 +982,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	timer_stats_hrtimer_set_start_info(timer);
 
-	leftmost = enqueue_hrtimer(timer, new_base);
+	leftmost = enqueue_hrtimer(timer);
 
 	/*
 	 * Only allow reprogramming if the new base is on this CPU.
@@ -1210,8 +1211,7 @@ EXPORT_SYMBOL_GPL(hrtimer_get_res);
 
 static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 {
-	struct hrtimer_clock_base *base = timer->base;
-	struct hrtimer_cpu_base *cpu_base = base->cpu_base;
+	struct hrtimer_cpu_base *cpu_base = timer->base->cpu_base;
 	enum hrtimer_restart (*fn)(struct hrtimer *);
 	int restart;
 
@@ -1240,7 +1240,7 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 	 */
 	if (restart != HRTIMER_NORESTART) {
 		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
-		enqueue_hrtimer(timer, base);
+		enqueue_hrtimer(timer);
 	}
 
 	WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
@@ -1665,7 +1665,7 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 		 * sort out already expired timers and reprogram the
 		 * event device.
 		 */
-		enqueue_hrtimer(timer, new_base);
+		enqueue_hrtimer(timer);
 
 		/* Clear the migration state bit */
 		timer->state &= ~HRTIMER_STATE_MIGRATE;
-- 
1.7.12.rc2.18.g61b472e

