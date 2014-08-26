Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbaHZLJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:09:12 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50497 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757648AbaHZLIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:08:02 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v5 09/12] sched: add usage_load_avg
Date: Tue, 26 Aug 2014 13:06:52 +0200
Message-Id: <1409051215-16788-10-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new statistics which reflect the average time a task is running on the
CPU and the sum of the tasks' running on a runqueue. The latter is named
usage_avg_contrib.

This patch is based on the usage metric that was proposed in the 1st
versions of the per-entity load tracking patchset but that has be removed
afterward. This version differs from the original one in the sense that it's
not linked to task_group.

The rq's usage_avg_contrib will be used to check if a rq is overloaded or not
instead of trying to compute how many task a group of CPUs can handle

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 include/linux/sched.h |  4 ++--
 kernel/sched/fair.c   | 47 ++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sched/sched.h  |  2 +-
 3 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885..7dfd584 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1073,10 +1073,10 @@ struct sched_avg {
 	 * above by 1024/(1-y).  Thus we only need a u32 to store them for all
 	 * choices of y < 1-2^(-32)*1024.
 	 */
-	u32 runnable_avg_sum, runnable_avg_period;
+	u32 runnable_avg_sum, runnable_avg_period, running_avg_sum;
 	u64 last_runnable_update;
 	s64 decay_count;
-	unsigned long load_avg_contrib;
+	unsigned long load_avg_contrib, usage_avg_contrib;
 };
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 60ae1ce..1fd2131 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -676,7 +676,7 @@ void init_task_runnable_average(struct task_struct *p)
 
 	p->se.avg.decay_count = 0;
 	slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
-	p->se.avg.runnable_avg_sum = slice;
+	p->se.avg.runnable_avg_sum = p->se.avg.running_avg_sum = slice;
 	p->se.avg.runnable_avg_period = slice;
 	__update_task_entity_contrib(&p->se);
 }
@@ -2289,7 +2289,8 @@ static u32 __compute_runnable_contrib(u64 n)
  */
 static __always_inline int __update_entity_runnable_avg(u64 now,
 							struct sched_avg *sa,
-							int runnable)
+							int runnable,
+							int running)
 {
 	u64 delta, periods;
 	u32 runnable_contrib;
@@ -2328,6 +2329,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		delta_w = 1024 - delta_w;
 		if (runnable)
 			sa->runnable_avg_sum += delta_w;
+		if (running)
+			sa->running_avg_sum += delta_w;
 		sa->runnable_avg_period += delta_w;
 
 		delta -= delta_w;
@@ -2338,6 +2341,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 
 		sa->runnable_avg_sum = decay_load(sa->runnable_avg_sum,
 						  periods + 1);
+		sa->running_avg_sum = decay_load(sa->running_avg_sum,
+						  periods + 1);
 		sa->runnable_avg_period = decay_load(sa->runnable_avg_period,
 						     periods + 1);
 
@@ -2345,12 +2350,16 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		runnable_contrib = __compute_runnable_contrib(periods);
 		if (runnable)
 			sa->runnable_avg_sum += runnable_contrib;
+		if (running)
+			sa->running_avg_sum += runnable_contrib;
 		sa->runnable_avg_period += runnable_contrib;
 	}
 
 	/* Remainder of delta accrued against u_0` */
 	if (runnable)
 		sa->runnable_avg_sum += delta;
+	if (running)
+		sa->running_avg_sum += delta;
 	sa->runnable_avg_period += delta;
 
 	return decayed;
@@ -2490,6 +2499,27 @@ static long __update_entity_load_avg_contrib(struct sched_entity *se)
 	return se->avg.load_avg_contrib - old_contrib;
 }
 
+
+static inline void __update_task_entity_usage(struct sched_entity *se)
+{
+	u32 contrib;
+
+	/* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
+	contrib = se->avg.running_avg_sum * scale_load_down(SCHED_LOAD_SCALE);
+	contrib /= (se->avg.runnable_avg_period + 1);
+	se->avg.usage_avg_contrib = scale_load(contrib);
+}
+
+static long __update_entity_usage_avg_contrib(struct sched_entity *se)
+{
+	long old_contrib = se->avg.usage_avg_contrib;
+
+	if (entity_is_task(se))
+		__update_task_entity_usage(se);
+
+	return se->avg.usage_avg_contrib - old_contrib;
+}
+
 static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
 						 long load_contrib)
 {
@@ -2506,7 +2536,7 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq)
 {
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
-	long contrib_delta;
+	long contrib_delta, usage_delta;
 	u64 now;
 
 	/*
@@ -2518,16 +2548,20 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 	else
 		now = cfs_rq_clock_task(group_cfs_rq(se));
 
-	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq))
+	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq,
+					cfs_rq->curr == se))
 		return;
 
 	contrib_delta = __update_entity_load_avg_contrib(se);
+	usage_delta = __update_entity_usage_avg_contrib(se);
 
 	if (!update_cfs_rq)
 		return;
 
-	if (se->on_rq)
+	if (se->on_rq) {
 		cfs_rq->runnable_load_avg += contrib_delta;
+		cfs_rq->usage_load_avg += usage_delta;
+	}
 	else
 		subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
 }
@@ -2604,6 +2638,7 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	}
 
 	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
+	cfs_rq->usage_load_avg += se->avg.usage_avg_contrib;
 	/* we force update consideration on load-balancer moves */
 	update_cfs_rq_blocked_load(cfs_rq, !wakeup);
 }
@@ -2622,6 +2657,7 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 	update_cfs_rq_blocked_load(cfs_rq, !sleep);
 
 	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
+	cfs_rq->usage_load_avg -= se->avg.usage_avg_contrib;
 	if (sleep) {
 		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
@@ -2959,6 +2995,7 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		 */
 		update_stats_wait_end(cfs_rq, se);
 		__dequeue_entity(cfs_rq, se);
+		update_entity_load_avg(se, 1);
 	}
 
 	update_stats_curr_start(cfs_rq, se);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7c0a74e..d625fbb 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -340,7 +340,7 @@ struct cfs_rq {
 	 * This allows for the description of both thread and group usage (in
 	 * the FAIR_GROUP_SCHED case).
 	 */
-	unsigned long runnable_load_avg, blocked_load_avg;
+	unsigned long runnable_load_avg, blocked_load_avg, usage_load_avg;
 	atomic64_t decay_counter;
 	u64 last_decay;
 	atomic_long_t removed_load;
-- 
1.9.1

