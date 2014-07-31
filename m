Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbaGaJ5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:57:42 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39652 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaGaJ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:57:41 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: yuyang.du@intel.com, peterz@infradead.org
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com, morten.rasmussen@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
Date: Thu, 31 Jul 2014 11:56:13 +0200
Message-Id: <1406800573-9692-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140729015344.GF5203@intel.com>
References: <20140729015344.GF5203@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend with a correct subject

Hi Yuyang,

Does something like the patch below to be applied of top of your patchset, seem
reasonable add-on?

It adds 1 new usage_sum statistics which is something that I use to detect the
overload of a rq in my patchset that reworks cpu_power and removes
capacity_factor

And I think that the change I made on load_sum should match some of Morten's
concerns

Regards,
Vincent

---
Subject: [PATCH] sched: add usage_sum statistic

Add a new statitic that reflects the average time a task is running on CPU.

load_sum is now the average runnable time before being weighted

The sum of usage_sum of the tasks that are on a rq, is used to detect
the overload of a rq.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 include/linux/sched.h |  1 +
 kernel/sched/fair.c   | 47 +++++++++++++++++++++++++++++++++++------------
 kernel/sched/sched.h  |  2 ++
 3 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b6617a1..3296e76 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1080,6 +1080,7 @@ struct sched_avg {
 	 */
 	u64 last_update_time;
 	u64 load_sum;
+	unsigned long usage_sum;
 	unsigned long load_avg;
 	u32 period_contrib;
 };
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a3a3168..78408a0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -679,7 +679,8 @@ void init_task_runnable_average(struct task_struct *p)
 	 */
 	sa->period_contrib = 1023;
 	sa->load_avg = p->se.load.weight;
-	sa->load_sum = p->se.load.weight * LOAD_AVG_MAX;
+	sa->load_sum = sa->usage_sum = LOAD_AVG_MAX;
+	;
 	/* when this task enqueue'ed, it will contribute to its cfs_rq's load_avg */
 }
 #else
@@ -2300,7 +2301,7 @@ static u32 __compute_runnable_contrib(u64 n)
  *            = u_0 + u_1*y + u_2*y^2 + ... [re-labeling u_i --> u_{i+1}]
  */
 static __always_inline int
-__update_load_avg(u64 now, struct sched_avg *sa, unsigned long w)
+__update_load_avg(u64 now, struct sched_avg *sa, unsigned long w, int running)
 {
 	u64 delta, periods;
 	u32 contrib;
@@ -2340,7 +2341,9 @@ __update_load_avg(u64 now, struct sched_avg *sa, unsigned long w)
 		 */
 		delta_w = 1024 - delta_w;
 		if (w)
-			sa->load_sum += w * delta_w;
+			sa->load_sum += delta_w;
+		if (running)
+			sa->usage_sum += delta_w;
 
 		delta -= delta_w;
 
@@ -2349,21 +2352,26 @@ __update_load_avg(u64 now, struct sched_avg *sa, unsigned long w)
 		delta %= 1024;
 
 		sa->load_sum = decay_load(sa->load_sum, periods + 1);
+		sa->usage_sum = decay_load(sa->usage_sum, periods + 1);
 
 		/* Efficiently calculate \sum (1..n_period) 1024*y^i */
 		contrib = __compute_runnable_contrib(periods);
 		if (w)
-			sa->load_sum += w * contrib;
+			sa->load_sum += contrib;
+		if (running)
+			sa->usage_sum += contrib;
 	}
 
 	/* Remainder of delta accrued against u_0` */
 	if (w)
-		sa->load_sum += w * delta;
+		sa->load_sum +=  delta;
+	if (running)
+		sa->usage_sum += delta;
 
 	sa->period_contrib += delta;
 
 	if (decayed)
-		sa->load_avg = div_u64(sa->load_sum, LOAD_AVG_MAX);
+		sa->load_avg = div_u64(sa->load_sum * w, LOAD_AVG_MAX);
 
 	return decayed;
 }
@@ -2404,11 +2412,17 @@ static inline int update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
 	if (atomic_long_read(&cfs_rq->removed_load_avg)) {
 		long r = atomic_long_xchg(&cfs_rq->removed_load_avg, 0);
 		cfs_rq->avg.load_avg = subtract_until_zero(cfs_rq->avg.load_avg, r);
-		r *= LOAD_AVG_MAX;
+	}
+	if (atomic_long_read(&cfs_rq->removed_load_sum)) {
+		long r = atomic_long_xchg(&cfs_rq->removed_load_sum, 0);
 		cfs_rq->avg.load_sum = subtract_until_zero(cfs_rq->avg.load_sum, r);
 	}
+	if (atomic_long_read(&cfs_rq->removed_usage_sum)) {
+		long r = atomic_long_xchg(&cfs_rq->removed_usage_sum, 0);
+		cfs_rq->avg.usage_sum = subtract_until_zero(cfs_rq->avg.usage_sum, r);
+	}
 
-	decayed = __update_load_avg(now, &cfs_rq->avg, cfs_rq->load.weight);
+	decayed = __update_load_avg(now, &cfs_rq->avg, cfs_rq->load.weight, cfs_rq->curr != NULL);
 
 #ifndef CONFIG_64BIT
 	if (cfs_rq->avg.last_update_time != cfs_rq->load_last_update_time_copy) {
@@ -2430,7 +2444,8 @@ static inline void update_load_avg(struct sched_entity *se, int update_tg)
 	 * Track task load average for carrying it to new CPU after migrated,
 	 * and group sched_entity for task_h_load calc in migration
 	 */
-	__update_load_avg(now, &se->avg, se->on_rq * se->load.weight);
+	__update_load_avg(now, &se->avg, se->on_rq * se->load.weight,
+			entity_is_task(se) ? task_of(se)->on_cpu : 0);
 
 	if (update_cfs_rq_load_avg(now, cfs_rq) && update_tg)
 		update_tg_load_avg(cfs_rq);
@@ -2451,13 +2466,14 @@ static inline void enqueue_entity_load_avg(struct sched_entity *se)
 			migrated = 1;
 	}
 	else
-		__update_load_avg(now, sa, se->on_rq * se->load.weight);
+		__update_load_avg(now, sa, se->on_rq * se->load.weight, entity_is_task(se) ? task_of(se)->on_cpu : 0);
 
 	decayed = update_cfs_rq_load_avg(now, cfs_rq);
 
 	if (migrated) {
 		cfs_rq->avg.load_avg += sa->load_avg;
 		cfs_rq->avg.load_sum += sa->load_sum;
+		cfs_rq->avg.usage_sum += sa->usage_sum;
 	}
 
 	if (decayed || migrated)
@@ -4442,8 +4458,10 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 #else
 	last_update_time = cfs_rq->avg.last_update_time;
 #endif
-	__update_load_avg(last_update_time, &se->avg, 0);
+	__update_load_avg(last_update_time, &se->avg, 0, p->on_cpu);
 	atomic_long_add(se->avg.load_avg, &cfs_rq->removed_load_avg);
+	atomic_long_add(se->avg.load_sum, &cfs_rq->removed_load_sum);
+	atomic_long_add(se->avg.usage_sum, &cfs_rq->removed_usage_sum);
 
 	/*
 	 * We are supposed to update the task to "current" time, then its up to date
@@ -7316,11 +7334,13 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 	* Remove our load from contribution when we leave cfs_rq.
 	*/
 	__update_load_avg(cfs_rq->avg.last_update_time, &se->avg,
-		se->on_rq * se->load.weight);
+		se->on_rq * se->load.weight, p->on_cpu);
 	cfs_rq->avg.load_avg =
 		subtract_until_zero(cfs_rq->avg.load_avg, se->avg.load_avg);
 	cfs_rq->avg.load_sum =
 		subtract_until_zero(cfs_rq->avg.load_sum, se->avg.load_sum);
+	cfs_rq->avg.usage_sum =
+		subtract_until_zero(cfs_rq->avg.usage_sum, se->avg.usage_sum);
 #endif
 }
 
@@ -7378,6 +7398,8 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #endif
 #ifdef CONFIG_SMP
 	atomic_long_set(&cfs_rq->removed_load_avg, 0);
+	atomic_long_set(&cfs_rq->removed_load_sum, 0);
+	atomic_long_set(&cfs_rq->removed_usage_sum, 0);
 #endif
 }
 
@@ -7428,6 +7450,7 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 		p->se.avg.last_update_time = cfs_rq->avg.last_update_time;
 		cfs_rq->avg.load_avg += p->se.avg.load_avg;
 		cfs_rq->avg.load_sum += p->se.avg.load_sum;
+		cfs_rq->avg.usage_sum += p->se.avg.usage_sum;
 #endif
 	}
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f21ddde..1bdd878 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -335,6 +335,8 @@ struct cfs_rq {
 	struct sched_avg avg;
 	unsigned long tg_load_avg_contrib;
 	atomic_long_t removed_load_avg;
+	atomic_long_t removed_load_sum;
+	atomic_long_t removed_usage_sum;
 #ifndef CONFIG_64BIT
 	u64 load_last_update_time_copy;
 #endif
-- 
1.9.1

