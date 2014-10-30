Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbaJaHcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:32:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:52623 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbaJaHb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:31:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="408960576"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: pjt@google.com, bsegall@google.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, rafael.j.wysocki@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com, dietmar.eggemann@arm.com,
        umgwanakikbuti@gmail.com, Yuyang Du <yuyang.du@intel.com>
Subject: [PATCH 1/3 v6] sched: Remove update_rq_runnable_avg
Date: Fri, 31 Oct 2014 07:32:26 +0800
Message-Id: <1414711948-10475-2-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414711948-10475-1-git-send-email-yuyang.du@intel.com>
References: <1414711948-10475-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current rq->avg is not made use of anywhere, and the code is in fair
scheduler's critical path, so remove it.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/debug.c |    7 +------
 kernel/sched/fair.c  |   24 ++++--------------------
 kernel/sched/sched.h |    2 --
 3 files changed, 5 insertions(+), 28 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index ce33780..807f7b9 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -68,13 +68,8 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 #define PN(F) \
 	SEQ_printf(m, "  .%-30s: %lld.%06ld\n", #F, SPLIT_NS((long long)F))
 
-	if (!se) {
-		struct sched_avg *avg = &cpu_rq(cpu)->avg;
-		P(avg->runnable_avg_sum);
-		P(avg->runnable_avg_period);
+	if (!se)
 		return;
-	}
-
 
 	PN(se->exec_start);
 	PN(se->vruntime);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0b069bf..d3034b2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2459,18 +2459,12 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
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
@@ -2643,7 +2637,6 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
  */
 void idle_enter_fair(struct rq *this_rq)
 {
-	update_rq_runnable_avg(this_rq, 1);
 }
 
 /*
@@ -2653,7 +2646,6 @@ void idle_enter_fair(struct rq *this_rq)
  */
 void idle_exit_fair(struct rq *this_rq)
 {
-	update_rq_runnable_avg(this_rq, 0);
 }
 
 static int idle_balance(struct rq *this_rq);
@@ -2662,7 +2654,6 @@ static int idle_balance(struct rq *this_rq);
 
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq) {}
-static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
 static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 					   struct sched_entity *se,
 					   int wakeup) {}
@@ -3976,10 +3967,9 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
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
 
@@ -4037,10 +4027,9 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
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
 
@@ -5527,9 +5516,6 @@ static void __update_blocked_averages_cpu(struct task_group *tg, int cpu)
 		 */
 		if (!se->avg.runnable_avg_sum && !cfs_rq->nr_running)
 			list_del_leaf_cfs_rq(cfs_rq);
-	} else {
-		struct rq *rq = rq_of(cfs_rq);
-		update_rq_runnable_avg(rq, rq->nr_running);
 	}
 }
 
@@ -7507,8 +7493,6 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 
 	if (numabalancing_enabled)
 		task_tick_numa(rq, curr);
-
-	update_rq_runnable_avg(rq, 1);
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 24156c84..7c50f93 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -553,8 +553,6 @@ struct rq {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
 	struct list_head leaf_cfs_rq_list;
-
-	struct sched_avg avg;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 	/*
-- 
1.7.9.5

