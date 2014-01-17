Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaAQJFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:05:06 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64990 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaAQJEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:04:10 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        alex.shi@linaro.org
Subject: [PATCH 3/4] sched: Move idle_stamp up to the core
Date: Fri, 17 Jan 2014 10:04:03 +0100
Message-Id: <1389949444-14821-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org>
References: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idle_balance modifies the idle_stamp field of the rq, making this
information to be shared across core.c and fair.c. As we can know if the
cpu is going to idle or not with the previous patch, let's encapsulate the
idle_stamp information in core.c by moving it up to the caller. The
idle_balance function returns true in case a balancing occured and the cpu
won't be idle, false if no balance happened and the cpu is going idle.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/core.c  |    2 +-
 kernel/sched/fair.c  |   14 ++++++--------
 kernel/sched/sched.h |    2 +-
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index cf51601..b7e3635 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2680,7 +2680,7 @@ need_resched:
 	pre_schedule(rq, prev);
 
 	if (unlikely(!rq->nr_running))
-		idle_balance(rq);
+		rq->idle_stamp = idle_balance(rq) ? 0 : rq_clock(rq);
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 502c51c..49dfedb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6359,7 +6359,7 @@ out:
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
-void idle_balance(struct rq *this_rq)
+int idle_balance(struct rq *this_rq)
 {
 	struct sched_domain *sd;
 	int pulled_task = 0;
@@ -6367,10 +6367,8 @@ void idle_balance(struct rq *this_rq)
 	u64 curr_cost = 0;
 	int this_cpu = this_rq->cpu;
 
-	this_rq->idle_stamp = rq_clock(this_rq);
-
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
-		return;
+		return 0;
 
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
@@ -6408,10 +6406,8 @@ void idle_balance(struct rq *this_rq)
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
 
@@ -6422,7 +6418,7 @@ void idle_balance(struct rq *this_rq)
 	 * A task could have be enqueued in the meantime
 	 */
 	if (this_rq->nr_running && !pulled_task)
-		return;
+		return 1;
 
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
@@ -6434,6 +6430,8 @@ void idle_balance(struct rq *this_rq)
 
 	if (curr_cost > this_rq->max_idle_balance_cost)
 		this_rq->max_idle_balance_cost = curr_cost;
+
+	return pulled_task;
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b0be4c6..970dd44 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1176,7 +1176,7 @@ extern const struct sched_class idle_sched_class;
 extern void update_group_power(struct sched_domain *sd, int cpu);
 
 extern void trigger_load_balance(struct rq *rq);
-extern void idle_balance(struct rq *this_rq);
+extern int idle_balance(struct rq *this_rq);
 
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
-- 
1.7.9.5

