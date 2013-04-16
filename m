Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab3DPP0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:26:42 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56854 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523Ab3DPP0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:26:40 -0400
Message-ID: <1366125995.9604.3.camel@e103567-lin>
Subject: [RFC PATCH 3/3] sched: Scale load contribution by CPU Capacity
From: Chris Redpath <chris.redpath@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Alex Shi <alex.shi@intel.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Todd Poynor <toddpoynor@google.com>
Date: Tue, 16 Apr 2013 16:26:35 +0100
In-Reply-To: <cover.1364298828.git.chris.redpath@arm.com>
References: <cover.1364298828.git.chris.redpath@arm.com>
References: <cover.1364298828.git.chris.redpath@arm.com>
In-Reply-To: <cover.1364298828.git.chris.redpath@arm.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
Mime-Version: 1.0
X-OriginalArrivalTime: 16 Apr 2013 15:26:36.0711 (UTC) FILETIME=[C8C49B70:01CE3AB6]
X-MC-Unique: 113041616263902801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modulate the tracked load of a task using the measure of current
and maximum compute capacity for the core it is executing on.

Change-Id: If6aea806e631f2313fd925c8902260a522663dbd

Conflicts:

	kernel/sched/fair.c
---
 kernel/sched/fair.c |   51 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f6bbe1e..3f3ee08 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1319,11 +1319,15 @@ static inline void update_cpu_capacity(int cpu)
 static __always_inline int __update_entity_runnable_avg(u64 now,
 							struct sched_avg *sa,
 							int runnable,
-							int running)
+							int running,
+							int cpu)
 {
 	u64 delta, periods;
 	u32 runnable_contrib;
 	int delta_w, decayed = 0;
+#ifdef CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY
+	u32 curr_scale = 1<<SCHED_ARCH_SCALE_POWER_SHIFT;
+#endif /* CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY */
 
 	delta = now - sa->last_runnable_update;
 	/*
@@ -1344,6 +1348,12 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		return 0;
 	sa->last_runnable_update = now;
 
+#ifdef CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY
+	update_cpu_capacity(cpu);
+	curr_scale = (compute_capacity_of(cpu) << SCHED_ARCH_SCALE_POWER_SHIFT)
+			/ (max_compute_capacity_of(cpu)+1);
+#endif
+
 	/* delta_w is the amount already accumulated against our next period */
 	delta_w = sa->runnable_avg_period % 1024;
 	if (delta + delta_w >= 1024) {
@@ -1356,13 +1366,17 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		 * period and accrue it.
 		 */
 		delta_w = 1024 - delta_w;
+		sa->runnable_avg_period += delta_w;
+		delta -= delta_w;
+		/* scale runnable time if necessary */
+#ifdef CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY
+		delta_w = (delta_w * curr_scale)
+				>> SCHED_ARCH_SCALE_POWER_SHIFT;
+#endif
 		if (runnable)
 			sa->runnable_avg_sum += delta_w;
 		if (running)
 			sa->usage_avg_sum += delta_w;
-		sa->runnable_avg_period += delta_w;
-
-		delta -= delta_w;
 
 		/* Figure out how many additional periods this update spans */
 		periods = delta / 1024;
@@ -1376,19 +1390,31 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 
 		/* Efficiently calculate \sum (1..n_period) 1024*y^i */
 		runnable_contrib = __compute_runnable_contrib(periods);
+		sa->runnable_avg_period += runnable_contrib;
+		/* Apply load scaling if necessary.
+		 * Note that multiplying the whole series is same as
+		 * multiplying all terms
+		 */
+#ifdef CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY
+		runnable_contrib = (runnable_contrib * curr_scale)
+				>> SCHED_ARCH_SCALE_POWER_SHIFT;
+#endif 
 		if (runnable)
 			sa->runnable_avg_sum += runnable_contrib;
 		if (running)
 			sa->usage_avg_sum += runnable_contrib;
-		sa->runnable_avg_period += runnable_contrib;
 	}
 
 	/* Remainder of delta accrued against u_0` */
+	sa->runnable_avg_period += delta;
+	/* scale if necessary */
+#ifdef CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY
+	delta = ((delta * curr_scale) >> SCHED_ARCH_SCALE_POWER_SHIFT);
+#endif
 	if (runnable)
 		sa->runnable_avg_sum += delta;
 	if (running)
 		sa->usage_avg_sum += delta;
-	sa->runnable_avg_period += delta;
 
 	return decayed;
 }
@@ -1551,7 +1577,11 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 	long contrib_delta;
 	u64 now;
+	int cpu = -1;   /* not used in normal case */
 
+#ifdef CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY
+	cpu = cfs_rq->rq->cpu;
+#endif
 	/*
 	 * For a group entity we need to use their owned cfs_rq_clock_task() in
 	 * case they are the parent of a throttled hierarchy.
@@ -1562,7 +1592,7 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 		now = cfs_rq_clock_task(group_cfs_rq(se));
 
 	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq,
-					  cfs_rq->curr == se))
+			cfs_rq->curr == se, cpu))
 		return;
 
 	contrib_delta = __update_entity_load_avg_contrib(se);
@@ -1607,8 +1637,13 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 {
 	u32 contrib;
+	int cpu = -1;	/* not used in normal case */
+
+#ifdef CONFIG_ARCH_SCALE_INVARIANT_CPU_CAPACITY
+	cpu = rq->cpu;
+#endif
 	__update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable,
-				     runnable);
+			runnable, cpu);
 	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
 	contrib = rq->avg.runnable_avg_sum * scale_load_down(1024);
 	contrib /= (rq->avg.runnable_avg_period + 1);
-- 
1.7.9.5



