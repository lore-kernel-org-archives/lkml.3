Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaKCRDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:03:07 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38391 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaKCRDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:03:02 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com, linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Paul Turner <pjt@google.com>, Ben Segall <bsegall@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v9 04/10] sched: Make sched entity usage tracking scale-invariant
Date: Mon,  3 Nov 2014 17:54:41 +0100
Message-Id: <1415033687-23294-5-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Morten Rasmussen <morten.rasmussen@arm.com>

Apply frequency scale-invariance correction factor to usage tracking.
Each segment of the running_load_avg geometric series is now scaled by the
current frequency so the utilization_avg_contrib of each entity will be
invariant with frequency scaling. As a result, utilization_load_avg which is
the sum of utilization_avg_contrib, becomes invariant too. So the usage level
that is returned by get_cpu_usage, stays relative to the max frequency as the
cpu_capacity which is is compared against.
Then, we want the keep the load tracking values in a 32bits type, which implies
that the max value of {runnable|running}_avg_sum must be lower than
2^32/88761=48388 (88761 is the max weigth of a task). As LOAD_AVG_MAX = 47742,
arch_scale_freq_capacity must return a value less than
(48388/47742) << SCHED_CAPACITY_SHIFT = 1037 (SCHED_SCALE_CAPACITY = 1024).
So we define the range to [0..SCHED_SCALE_CAPACITY] in order to avoid overflow.

cc: Paul Turner <pjt@google.com>
cc: Ben Segall <bsegall@google.com>

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a96affd..a5039da 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2266,6 +2266,8 @@ static u32 __compute_runnable_contrib(u64 n)
 	return contrib + runnable_avg_yN_sum[n];
 }
 
+unsigned long __weak arch_scale_freq_capacity(struct sched_domain *sd, int cpu);
+
 /*
  * We can represent the historical contribution to runnable average as the
  * coefficients of a geometric series.  To do this we sub-divide our runnable
@@ -2294,7 +2296,7 @@ static u32 __compute_runnable_contrib(u64 n)
  *   load_avg = u_0` + y*(u_0 + u_1*y + u_2*y^2 + ... )
  *            = u_0 + u_1*y + u_2*y^2 + ... [re-labeling u_i --> u_{i+1}]
  */
-static __always_inline int __update_entity_runnable_avg(u64 now,
+static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 							struct sched_avg *sa,
 							int runnable,
 							int running)
@@ -2302,6 +2304,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 	u64 delta, periods;
 	u32 runnable_contrib;
 	int delta_w, decayed = 0;
+	unsigned long scale_freq = arch_scale_freq_capacity(NULL, cpu);
 
 	delta = now - sa->last_runnable_update;
 	/*
@@ -2337,7 +2340,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		if (runnable)
 			sa->runnable_avg_sum += delta_w;
 		if (running)
-			sa->running_avg_sum += delta_w;
+			sa->running_avg_sum += delta_w * scale_freq
+				>> SCHED_CAPACITY_SHIFT;
 		sa->avg_period += delta_w;
 
 		delta -= delta_w;
@@ -2358,7 +2362,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		if (runnable)
 			sa->runnable_avg_sum += runnable_contrib;
 		if (running)
-			sa->running_avg_sum += runnable_contrib;
+			sa->running_avg_sum += runnable_contrib * scale_freq
+				>> SCHED_CAPACITY_SHIFT;
 		sa->avg_period += runnable_contrib;
 	}
 
@@ -2366,7 +2371,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 	if (runnable)
 		sa->runnable_avg_sum += delta;
 	if (running)
-		sa->running_avg_sum += delta;
+		sa->running_avg_sum += delta * scale_freq
+			>> SCHED_CAPACITY_SHIFT;
 	sa->avg_period += delta;
 
 	return decayed;
@@ -2474,8 +2480,8 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 {
-	__update_entity_runnable_avg(rq_clock_task(rq), &rq->avg, runnable,
-			runnable);
+	__update_entity_runnable_avg(rq_clock_task(rq), cpu_of(rq), &rq->avg,
+			runnable, runnable);
 	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
 }
 #else /* CONFIG_FAIR_GROUP_SCHED */
@@ -2553,6 +2559,7 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 {
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 	long contrib_delta, utilization_delta;
+	int cpu = cpu_of(rq_of(cfs_rq));
 	u64 now;
 
 	/*
@@ -2564,7 +2571,7 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 	else
 		now = cfs_rq_clock_task(group_cfs_rq(se));
 
-	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq,
+	if (!__update_entity_runnable_avg(now, cpu, &se->avg, se->on_rq,
 					cfs_rq->curr == se))
 		return;
 
-- 
1.9.1

