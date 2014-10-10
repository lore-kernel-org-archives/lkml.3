Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbaJJKXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:23:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:12856 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbaJJKW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:22:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="398118492"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: pjt@google.com, bsegall@google.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, rafael.j.wysocki@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, fengguang.wu@intel.com,
        Yuyang Du <yuyang.du@intel.com>
Subject: [RESEND PATCH 1/3 v5] sched: Remove update_rq_runnable_avg
Date: Fri, 10 Oct 2014 10:21:55 +0800
Message-Id: <1412907717-2871-2-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412907717-2871-1-git-send-email-yuyang.du@intel.com>
References: <1412907717-2871-1-git-send-email-yuyang.du@intel.com>
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
index 627b3c3..da0b7d5 100644
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
index bfa3c86..1eb6ccd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2446,18 +2446,12 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
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
@@ -2630,7 +2624,6 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
  */
 void idle_enter_fair(struct rq *this_rq)
 {
-	update_rq_runnable_avg(this_rq, 1);
 }
 
 /*
@@ -2640,7 +2633,6 @@ void idle_enter_fair(struct rq *this_rq)
  */
 void idle_exit_fair(struct rq *this_rq)
 {
-	update_rq_runnable_avg(this_rq, 0);
 }
 
 static int idle_balance(struct rq *this_rq);
@@ -2649,7 +2641,6 @@ static int idle_balance(struct rq *this_rq);
 
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq) {}
-static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
 static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 					   struct sched_entity *se,
 					   int wakeup) {}
@@ -3971,10 +3962,9 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
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
 
@@ -4032,10 +4022,9 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
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
 
@@ -5471,9 +5460,6 @@ static void __update_blocked_averages_cpu(struct task_group *tg, int cpu)
 		 */
 		if (!se->avg.runnable_avg_sum && !cfs_rq->nr_running)
 			list_del_leaf_cfs_rq(cfs_rq);
-	} else {
-		struct rq *rq = rq_of(cfs_rq);
-		update_rq_runnable_avg(rq, rq->nr_running);
 	}
 }
 
@@ -7404,8 +7390,6 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 
 	if (numabalancing_enabled)
 		task_tick_numa(rq, curr);
-
-	update_rq_runnable_avg(rq, 1);
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 579712f..fc26556 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -545,8 +545,6 @@ struct rq {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
 	struct list_head leaf_cfs_rq_list;
-
-	struct sched_avg avg;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 	/*
-- 
1.7.9.5

