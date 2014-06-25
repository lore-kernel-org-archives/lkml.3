Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaFYIss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:48:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:15789 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735AbaFYIjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:39:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="scan'208";a="449717438"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        Yuyang Du <yuyang.du@intel.com>
Subject: [RFC PATCH 3/9 v4] How CPU ConCurrency (CC) accrues with runqueue change and time
Date: Wed, 25 Jun 2014 08:36:02 +0800
Message-Id: <1403656568-32445-4-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403656568-32445-1-git-send-email-yuyang.du@intel.com>
References: <1403656568-32445-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC can be seen as either decayed average run queue length, or run-queue-lengh-
weighted CPU utilization. CC is calculated by two steps:

1) Divide continuous time into periods of time, and average task concurrency
in period, for tolerating the transient bursts:

a = sum(concurrency * time) / period

2) Exponentially decay past periods, and synthesize them all, for hysteresis
to load drops or resilience to load rises (let f be decaying factor, and a_x
the xth period average since period 0):

s = a_n + f^1 * a_n-1 + f^2 * a_n-2 +, ..., + f^(n-1) * a_1 + f^n * a_0

We reuse __update_entity_runnable_avg to calc CC.

CC can only be modified when enqueue and dequeue the CPU rq. We also update it
in scheduler tick, load balancing, and idle enter/exit in case we may not have
enqueue and dequeue for a long time.

Therefore, we update/track CC in and only in these points:

we update cpu concurrency at:
1) enqueue task, which increases concurrency
2) dequeue task, which decreases concurrency
3) periodic scheduler tick, in case no en/dequeue for long
4) enter and exit idle
5) update_blocked_averages

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/fair.c  |   45 +++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched/sched.h |    2 ++
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e914e32..c4270cf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2605,6 +2605,8 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
 }
 
+static inline void update_cpu_concurrency(struct rq *rq);
+
 /*
  * Update the rq's load with the elapsed running time before entering
  * idle. if the last scheduled task is not a CFS task, idle_enter will
@@ -2612,6 +2614,7 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
  */
 void idle_enter_fair(struct rq *this_rq)
 {
+	update_cpu_concurrency(this_rq);
 }
 
 /*
@@ -2621,6 +2624,7 @@ void idle_enter_fair(struct rq *this_rq)
  */
 void idle_exit_fair(struct rq *this_rq)
 {
+	update_cpu_concurrency(this_rq);
 }
 
 static int idle_balance(struct rq *this_rq);
@@ -2638,6 +2642,8 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
 					      int force_update) {}
 
+static inline void update_cpu_concurrency(struct rq *rq) {}
+
 static inline int idle_balance(struct rq *rq)
 {
 	return 0;
@@ -3931,8 +3937,10 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_entity_load_avg(se, 1);
 	}
 
-	if (!se)
+	if (!se) {
+		update_cpu_concurrency(rq);
 		add_nr_running(rq, 1);
+	}
 
 	hrtick_update(rq);
 }
@@ -3991,8 +3999,10 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_entity_load_avg(se, 1);
 	}
 
-	if (!se)
+	if (!se) {
+		update_cpu_concurrency(rq);
 		sub_nr_running(rq, 1);
+	}
 
 	hrtick_update(rq);
 }
@@ -5454,6 +5464,8 @@ static void update_blocked_averages(int cpu)
 		__update_blocked_averages_cpu(cfs_rq->tg, rq->cpu);
 	}
 
+	update_cpu_concurrency(rq);
+
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
@@ -7342,6 +7354,8 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 
 	if (numabalancing_enabled)
 		task_tick_numa(rq, curr);
+
+	update_cpu_concurrency(rq);
 }
 
 /*
@@ -7801,3 +7815,30 @@ __init void init_sched_fair_class(void)
 #endif /* SMP */
 
 }
+
+#ifdef CONFIG_SMP
+
+/*
+ * CPU ConCurrency (CC) measures the CPU load by averaging
+ * the number of running tasks. Using CC, the scheduler can
+ * evaluate the load of CPUs to improve load balance for power
+ * efficiency without sacrificing performance.
+ */
+
+/*
+ * we update cpu concurrency at:
+ * 1) enqueue task, which increases concurrency
+ * 2) dequeue task, which decreases concurrency
+ * 3) periodic scheduler tick, in case no en/dequeue for long
+ * 4) enter and exit idle
+ * 5) update_blocked_averages
+ */
+static void update_cpu_concurrency(struct rq *rq)
+{
+	struct sched_avg *sa = &rq->avg;
+	if (__update_entity_runnable_avg(rq->clock, sa, rq->nr_running)) {
+		sa->load_avg_contrib = sa->runnable_avg_sum << NICE_0_SHIFT;
+		sa->load_avg_contrib /= (sa->runnable_avg_period + 1);
+	}
+}
+#endif /* CONFIG_SMP */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a147571..eb47ce2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -579,6 +579,8 @@ struct rq {
 
 	struct list_head cfs_tasks;
 
+	struct sched_avg avg;
+
 	u64 rt_avg;
 	u64 age_stamp;
 	u64 idle_stamp;
-- 
1.7.9.5

