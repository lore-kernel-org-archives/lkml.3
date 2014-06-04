Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaFEG40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 02:56:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:24943 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaFEG4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 02:56:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,979,1392192000"; 
   d="scan'208";a="550067854"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, pjt@google.com, bsegall@google.com
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, jacob.jun.pan@linux.intel.com,
        fengguang.wu@intel.com, yuyang.du@intel.com
Subject: [PATCH] sched: remove rq's runnable load average
Date: Thu,  5 Jun 2014 06:51:37 +0800
Message-Id: <1401922297-9729-1-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per rq runnable average has not been made use of anywhere since it was merged by:

commit 18bf2805d9b30cb823d4919b42cd230f59c7ce1f
Author: Ben Segall <bsegall@google.com>
Date:   Thu Oct 4 12:51:20 2012 +0200

    sched: Maintain per-rq runnable averages

    Since runqueues do not have a corresponding sched_entity we instead embed a
    sched_avg structure directly.

    Signed-off-by: Ben Segall <bsegall@google.com>
    Reviewed-by: Paul Turner <pjt@google.com>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/r/20120823141506.442637130@google.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

So removing it does not hurt anything but can benefit PnP as the average trakcing
is in scheduler critical path.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/debug.c |  8 --------
 kernel/sched/fair.c  | 24 ++++--------------------
 kernel/sched/sched.h |  2 --
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
index 0fdb96d..18ee21d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2378,18 +2378,12 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
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
@@ -2562,7 +2556,6 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
  */
 void idle_enter_fair(struct rq *this_rq)
 {
-	update_rq_runnable_avg(this_rq, 1);
 }
 
 /*
@@ -2572,7 +2565,6 @@ void idle_enter_fair(struct rq *this_rq)
  */
 void idle_exit_fair(struct rq *this_rq)
 {
-	update_rq_runnable_avg(this_rq, 0);
 }
 
 static int idle_balance(struct rq *this_rq);
@@ -2581,7 +2573,6 @@ static int idle_balance(struct rq *this_rq);
 
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq) {}
-static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
 static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 					   struct sched_entity *se,
 					   int wakeup) {}
@@ -3882,10 +3873,9 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_entity_load_avg(se, 1);
 	}
 
-	if (!se) {
-		update_rq_runnable_avg(rq, rq->nr_running);
+	if (!se)
 		inc_nr_running(rq);
-	}
+
 	hrtick_update(rq);
 }
 
@@ -3943,10 +3933,9 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_entity_load_avg(se, 1);
 	}
 
-	if (!se) {
+	if (!se)
 		dec_nr_running(rq);
-		update_rq_runnable_avg(rq, 1);
-	}
+
 	hrtick_update(rq);
 }
 
@@ -5364,9 +5353,6 @@ static void __update_blocked_averages_cpu(struct task_group *tg, int cpu)
 		 */
 		if (!se->avg.runnable_avg_sum && !cfs_rq->nr_running)
 			list_del_leaf_cfs_rq(cfs_rq);
-	} else {
-		struct rq *rq = rq_of(cfs_rq);
-		update_rq_runnable_avg(rq, rq->nr_running);
 	}
 }
 
@@ -7243,8 +7229,6 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 
 	if (numabalancing_enabled)
 		task_tick_numa(rq, curr);
-
-	update_rq_runnable_avg(rq, 1);
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 456e492..5a66776 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -552,8 +552,6 @@ struct rq {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
 	struct list_head leaf_cfs_rq_list;
-
-	struct sched_avg avg;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 	/*
-- 
1.9.1

