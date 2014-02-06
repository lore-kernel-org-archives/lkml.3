Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaBFXKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:10:55 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50027 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbaBFXKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:10:49 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: alex.shi@linaro.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH V2 3/3] sched: Move idle_stamp up to the core
Date: Thu,  6 Feb 2014 23:10:37 +0000
Message-Id: <1391728237-4441-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org>
References: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idle_balance modifies the idle_stamp field of the rq, making this
information to be shared across core.c and fair.c. As we can know if the
cpu is going to idle or not with the previous patch, let's encapsulate the
idle_stamp information in core.c by moving it up to the caller. The
idle_balance function returns true in case a balancing occured and the cpu
won't be idle, false if no balance happened and the cpu is going idle.

Cc: mingo@kernel.org
Cc: alex.shi@linaro.org
Cc: peterz@infradead.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c  |   13 +++++++++++--
 kernel/sched/fair.c  |   14 ++++++--------
 kernel/sched/sched.h |    8 +-------
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 16b97dd..428ee4c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2704,8 +2704,17 @@ need_resched:
 
 	pre_schedule(rq, prev);
 
-	if (unlikely(!rq->nr_running))
-		idle_balance(rq);
+#ifdef CONFIG_SMP
+	if (unlikely(!rq->nr_running)) {
+		/*
+		 * We must set idle_stamp _before_ calling idle_balance(), such
+		 * that we measure the duration of idle_balance() as idle time.
+		 */
+		rq->idle_stamp = rq_clock(rq);
+		if (idle_balance(rq))
+			rq->idle_stamp = 0;
+	}
+#endif
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5ebc681..04fea77 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6531,7 +6531,7 @@ out:
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
-void idle_balance(struct rq *this_rq)
+int idle_balance(struct rq *this_rq)
 {
 	struct sched_domain *sd;
 	int pulled_task = 0;
@@ -6539,10 +6539,8 @@ void idle_balance(struct rq *this_rq)
 	u64 curr_cost = 0;
 	int this_cpu = this_rq->cpu;
 
-	this_rq->idle_stamp = rq_clock(this_rq);
-
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
-		return;
+		return 0;
 
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
@@ -6580,10 +6578,8 @@ void idle_balance(struct rq *this_rq)
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task) {
-			this_rq->idle_stamp = 0;
+		if (pulled_task)
 			break;
-		}
 	}
 	rcu_read_unlock();
 
@@ -6594,7 +6590,7 @@ void idle_balance(struct rq *this_rq)
 	 * A task could have be enqueued in the meantime
 	 */
 	if (this_rq->nr_running && !pulled_task)
-		return;
+		return 1;
 
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
@@ -6606,6 +6602,8 @@ void idle_balance(struct rq *this_rq)
 
 	if (curr_cost > this_rq->max_idle_balance_cost)
 		this_rq->max_idle_balance_cost = curr_cost;
+
+	return pulled_task;
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1436219..c08c070 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1176,17 +1176,11 @@ extern const struct sched_class idle_sched_class;
 extern void update_group_power(struct sched_domain *sd, int cpu);
 
 extern void trigger_load_balance(struct rq *rq);
-extern void idle_balance(struct rq *this_rq);
+extern int idle_balance(struct rq *this_rq);
 
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
 
-#else	/* CONFIG_SMP */
-
-static inline void idle_balance(struct rq *rq)
-{
-}
-
 #endif
 
 extern void sysrq_sched_debug_show(void);
-- 
1.7.9.5

