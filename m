Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaA1Rds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:33:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60562 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbaA1Rdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:33:46 -0500
Message-Id: <20140128171948.009146613@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 28 Jan 2014 18:16:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, daniel.lezcano@linaro.org, pjt@google.com,
        bsegall@google.com, Steven Rostedt <rostedt@goodmis.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/9] sched: Move idle_stamp up to the core
References: <20140128171634.974847076@infradead.org>
Content-Disposition: inline; filename=daniel_lezcano-3_sched-move_idle_stamp_up_to_the_core.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

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
 kernel/sched/core.c  |   11 +++++++++--
 kernel/sched/fair.c  |   14 ++++++--------
 kernel/sched/sched.h |    2 +-
 3 files changed, 16 insertions(+), 11 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2681,8 +2681,15 @@ static void __sched __schedule(void)
 
 	pre_schedule(rq, prev);
 
-	if (unlikely(!rq->nr_running))
-		idle_balance(rq);
+	if (unlikely(!rq->nr_running)) {
+		/*
+		 * We must set idle_stamp _before_ calling idle_balance(), such
+		 * that we measure the duration of idle_balance() as idle time.
+		 */
+		rq->idle_stamp = rq_clock(rq);
+		if (idle_balance(rq))
+			rq->idle_stamp = 0;
+	}
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6535,7 +6535,7 @@ static int load_balance(int this_cpu, st
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
-void idle_balance(struct rq *this_rq)
+int idle_balance(struct rq *this_rq)
 {
 	struct sched_domain *sd;
 	int pulled_task = 0;
@@ -6543,10 +6543,8 @@ void idle_balance(struct rq *this_rq)
 	u64 curr_cost = 0;
 	int this_cpu = this_rq->cpu;
 
-	this_rq->idle_stamp = rq_clock(this_rq);
-
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
-		return;
+		return 0;
 
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
@@ -6584,10 +6582,8 @@ void idle_balance(struct rq *this_rq)
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
 
@@ -6598,7 +6594,7 @@ void idle_balance(struct rq *this_rq)
 	 * A task could have be enqueued in the meantime
 	 */
 	if (this_rq->nr_running && !pulled_task)
-		return;
+		return 1;
 
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
@@ -6610,6 +6606,8 @@ void idle_balance(struct rq *this_rq)
 
 	if (curr_cost > this_rq->max_idle_balance_cost)
 		this_rq->max_idle_balance_cost = curr_cost;
+
+	return pulled_task;
 }
 
 /*
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1176,7 +1176,7 @@ extern const struct sched_class idle_sch
 extern void update_group_power(struct sched_domain *sd, int cpu);
 
 extern void trigger_load_balance(struct rq *rq);
-extern void idle_balance(struct rq *this_rq);
+extern int idle_balance(struct rq *this_rq);
 
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);


