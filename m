Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbaAUL3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:29:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51880 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbaAUL30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:29:26 -0500
Message-Id: <20140121112258.459329467@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 21 Jan 2014 12:17:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, daniel.lezcano@linaro.org, pjt@google.com,
        bsegall@google.com, Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/9] sched: Clean up idle task SMP logic
References: <20140121111754.580142558@infradead.org>
Content-Disposition: inline; filename=peter_zijlstra-sched-clean_up_idle_task_smp_logic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idle post_schedule hook is just a vile waste of time, fix it proper.

Cc: alex.shi@linaro.org
Cc: mingo@kernel.org
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140117140939.GH11314@laptop.programming.kicks-ass.net
---
 kernel/sched/fair.c      |    5 +++--
 kernel/sched/idle_task.c |   21 ++++++---------------
 2 files changed, 9 insertions(+), 17 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2416,7 +2416,8 @@ void idle_exit_fair(struct rq *this_rq)
 	update_rq_runnable_avg(this_rq, 0);
 }
 
-#else
+#else /* CONFIG_SMP */
+
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq) {}
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
@@ -2428,7 +2429,7 @@ static inline void dequeue_entity_load_a
 					   int sleep) {}
 static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
 					      int force_update) {}
-#endif
+#endif /* CONFIG_SMP */
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -13,18 +13,8 @@ select_task_rq_idle(struct task_struct *
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
-
-static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
-{
-	idle_exit_fair(rq);
-	rq_last_tick_reset(rq);
-}
-
-static void post_schedule_idle(struct rq *rq)
-{
-	idle_enter_fair(rq);
-}
 #endif /* CONFIG_SMP */
+
 /*
  * Idle tasks are unconditionally rescheduled:
  */
@@ -37,8 +27,7 @@ static struct task_struct *pick_next_tas
 {
 	schedstat_inc(rq, sched_goidle);
 #ifdef CONFIG_SMP
-	/* Trigger the post schedule to do an idle_enter for CFS */
-	rq->post_schedule = 1;
+	idle_enter_fair(rq);
 #endif
 	return rq->idle;
 }
@@ -58,6 +47,10 @@ dequeue_task_idle(struct rq *rq, struct
 
 static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
 {
+#ifdef CONFIG_SMP
+	idle_exit_fair(rq);
+	rq_last_tick_reset(rq);
+#endif
 }
 
 static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)
@@ -101,8 +94,6 @@ const struct sched_class idle_sched_clas
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_idle,
-	.pre_schedule		= pre_schedule_idle,
-	.post_schedule		= post_schedule_idle,
 #endif
 
 	.set_curr_task          = set_curr_task_idle,


