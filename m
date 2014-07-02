Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaGBKeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:34:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:62413 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaGBKeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:34:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,587,1400050800"; 
   d="scan'208";a="567182167"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, fengguang.wu@intel.com,
        yuyang.du@intel.com
Subject: [PATCH 1/2] sched: Remove update_rq_runnable_avg
Date: Wed,  2 Jul 2014 10:30:55 +0800
Message-Id: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current rq->avg is not made use of anywhere, and the code is in fair
scheduler's critical path, so remove it.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/debug.c |    8 --------
 kernel/sched/fair.c  |   24 ++++--------------------
 kernel/sched/sched.h |    2 --
 3 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 695f977..4b864c7 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -68,14 +68,6 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 #define PN(F) \
 	SEQ_printf(m, "  .%-30s: %lld.%06ld\n", #F, SPLIT_NS((long long)F))
 
-	if (!se) {
-		struct sched_avg *avg = &cpu_rq(cpu)->avg;
-		P(avg->runnable_avg_sum);
-		P(avg->runnable_avg_period);
-		return;
-	}
-
-
 	PN(se->exec_start);
 	PN(se->vruntime);
 	PN(se->sum_exec_runtime);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fea7d33..1a2d04f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2430,18 +2430,12 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 	}
 }
 
-static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
-{
-	__update_entity_runnable_avg(rq_clock_task(rq), &rq->avg, runnable);
-	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
-}
 #else /* CONFIG_FAIR_GROUP_SCHED */
 static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 						 int force_update) {}
 static inline void __update_tg_runnable_avg(struct sched_avg *sa,
 						  struct cfs_rq *cfs_rq) {}
 static inline void __update_group_entity_contrib(struct sched_entity *se) {}
-static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 static inline void __update_task_entity_contrib(struct sched_entity *se)
@@ -2614,7 +2608,6 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
  */
 void idle_enter_fair(struct rq *this_rq)
 {
-	update_rq_runnable_avg(this_rq, 1);
 }
 
 /*
@@ -2624,7 +2617,6 @@ void idle_enter_fair(struct rq *this_rq)
  */
 void idle_exit_fair(struct rq *this_rq)
 {
-	update_rq_runnable_avg(this_rq, 0);
 }
 
 static int idle_balance(struct rq *this_rq);
@@ -2633,7 +2625,6 @@ static int idle_balance(struct rq *this_rq);
 
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq) {}
-static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
 static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 					   struct sched_entity *se,
 					   int wakeup) {}
@@ -3936,10 +3927,9 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_entity_load_avg(se, 1);
 	}
 
-	if (!se) {
-		update_rq_runnable_avg(rq, rq->nr_running);
+	if (!se)
 		add_nr_running(rq, 1);
-	}
+
 	hrtick_update(rq);
 }
 
@@ -3997,10 +3987,9 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_entity_load_avg(se, 1);
 	}
 
-	if (!se) {
+	if (!se)
 		sub_nr_running(rq, 1);
-		update_rq_runnable_avg(rq, 1);
-	}
+
 	hrtick_update(rq);
 }
 
@@ -5437,9 +5426,6 @@ static void __update_blocked_averages_cpu(struct task_group *tg, int cpu)
 		 */
 		if (!se->avg.runnable_avg_sum && !cfs_rq->nr_running)
 			list_del_leaf_cfs_rq(cfs_rq);
-	} else {
-		struct rq *rq = rq_of(cfs_rq);
-		update_rq_runnable_avg(rq, rq->nr_running);
 	}
 }
 
@@ -7352,8 +7338,6 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 
 	if (numabalancing_enabled)
 		task_tick_numa(rq, curr);
-
-	update_rq_runnable_avg(rq, 1);
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 31cc02e..a147571 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -542,8 +542,6 @@ struct rq {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
 	struct list_head leaf_cfs_rq_list;
-
-	struct sched_avg avg;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 	/*
-- 
1.7.9.5

