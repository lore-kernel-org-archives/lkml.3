Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaIVQYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:24:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60068 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbaIVQYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:24:04 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        mturquette@linaro.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: [PATCH 1/7] sched: Introduce scale-invariant load tracking
Date: Mon, 22 Sep 2014 17:24:01 +0100
Message-Id: <1411403047-32010-2-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 22 Sep 2014 16:24:02.0081 (UTC) FILETIME=[9ED35910:01CFD681]
X-MC-Unique: 114092217240209501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s8MGQ7cx029546

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

The per-entity load-tracking currently neither accounts for frequency
changes due to frequency scaling (cpufreq) nor for micro-architectural
differences between cpus (ARM big.LITTLE). Comparing tracked loads
between different cpus might therefore be quite misleading.

This patch introduces a scale-invariance scaling factor to the
load-tracking computation that can be used to compensate for compute
capacity variations. The scaling factor is to be provided by the
architecture through an arch specific function. It may be as simple as:

	current_freq(cpu) * SCHED_CAPACITY_SCALE / max_freq(cpu)

If the architecture has more sophisticated ways of tracking compute
capacity, it can do so in its implementation. By default, no scaling is
applied.

The patch is loosely based on a patch by Chris Redpath
<Chris.Redpath@arm.com>.

cc: Paul Turner <pjt@google.com>
cc: Ben Segall <bsegall@google.com>

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2a1e6ac..52abb3e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2267,6 +2267,8 @@ static u32 __compute_runnable_contrib(u64 n)
 	return contrib + runnable_avg_yN_sum[n];
 }
 
+unsigned long arch_scale_load_capacity(int cpu);
+
 /*
  * We can represent the historical contribution to runnable average as the
  * coefficients of a geometric series.  To do this we sub-divide our runnable
@@ -2295,13 +2297,14 @@ static u32 __compute_runnable_contrib(u64 n)
  *   load_avg = u_0` + y*(u_0 + u_1*y + u_2*y^2 + ... )
  *            = u_0 + u_1*y + u_2*y^2 + ... [re-labeling u_i --> u_{i+1}]
  */
-static __always_inline int __update_entity_runnable_avg(u64 now,
+static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 							struct sched_avg *sa,
 							int runnable)
 {
 	u64 delta, periods;
 	u32 runnable_contrib;
 	int delta_w, decayed = 0;
+	u32 scale_cap = arch_scale_load_capacity(cpu);
 
 	delta = now - sa->last_runnable_update;
 	/*
@@ -2334,8 +2337,10 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 		 * period and accrue it.
 		 */
 		delta_w = 1024 - delta_w;
+
 		if (runnable)
-			sa->runnable_avg_sum += delta_w;
+			sa->runnable_avg_sum += (delta_w * scale_cap)
+					>> SCHED_CAPACITY_SHIFT;
 		sa->runnable_avg_period += delta_w;
 
 		delta -= delta_w;
@@ -2351,14 +2356,17 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 
 		/* Efficiently calculate \sum (1..n_period) 1024*y^i */
 		runnable_contrib = __compute_runnable_contrib(periods);
+
 		if (runnable)
-			sa->runnable_avg_sum += runnable_contrib;
+			sa->runnable_avg_sum += (runnable_contrib * scale_cap)
+						>> SCHED_CAPACITY_SHIFT;
 		sa->runnable_avg_period += runnable_contrib;
 	}
 
 	/* Remainder of delta accrued against u_0` */
 	if (runnable)
-		sa->runnable_avg_sum += delta;
+		sa->runnable_avg_sum += (delta * scale_cap)
+				>> SCHED_CAPACITY_SHIFT;
 	sa->runnable_avg_period += delta;
 
 	return decayed;
@@ -2464,7 +2472,8 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 {
-	__update_entity_runnable_avg(rq_clock_task(rq), &rq->avg, runnable);
+	__update_entity_runnable_avg(rq_clock_task(rq), rq->cpu, &rq->avg,
+					runnable);
 	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
 }
 #else /* CONFIG_FAIR_GROUP_SCHED */
@@ -2518,6 +2527,7 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 {
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 	long contrib_delta;
+	int cpu = rq_of(cfs_rq)->cpu;
 	u64 now;
 
 	/*
@@ -2529,7 +2539,7 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 	else
 		now = cfs_rq_clock_task(group_cfs_rq(se));
 
-	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq))
+	if (!__update_entity_runnable_avg(now, cpu, &se->avg, se->on_rq))
 		return;
 
 	contrib_delta = __update_entity_load_avg_contrib(se);
@@ -5719,6 +5729,16 @@ unsigned long __weak arch_scale_cpu_capacity(struct sched_domain *sd, int cpu)
 	return default_scale_cpu_capacity(sd, cpu);
 }
 
+static unsigned long default_scale_load_capacity(int cpu)
+{
+	return SCHED_CAPACITY_SCALE;
+}
+
+unsigned long __weak arch_scale_load_capacity(int cpu)
+{
+	return default_scale_load_capacity(cpu);
+}
+
 static unsigned long scale_rt_capacity(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-- 
1.7.9.5


