Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaJGMPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:15:18 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39273 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJGMPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:15:12 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v7 2/7] sched: move cfs task on a CPU with higher capacity
Date: Tue,  7 Oct 2014 14:13:32 +0200
Message-Id: <1412684017-16595-3-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the CPU is used for handling lot of IRQs, trig a load balance to check if
it's worth moving its tasks on another CPU that has more capacity.

As a sidenote, this will note generate more spurious ilb because we already
trig an ilb if there is more than 1 busy cpu. If this cpu is the only one that
has a task, we will trig the ilb once for migrating the task.

The nohz_kick_needed function has been cleaned up a bit while adding the new
test

env.src_cpu and env.src_rq must be set unconditionnaly because they are used
in need_active_balance which is called even if busiest->nr_running equals 1

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 70 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 50 insertions(+), 20 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c3674da..9075dee 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5896,6 +5896,18 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 }
 
 /*
+ * Check whether the capacity of the rq has been noticeably reduced by side
+ * activity. The imbalance_pct is used for the threshold.
+ * Return true is the capacity is reduced
+ */
+static inline int
+check_cpu_capacity(struct rq *rq, struct sched_domain *sd)
+{
+	return ((rq->cpu_capacity * sd->imbalance_pct) <
+				(rq->cpu_capacity_orig * 100));
+}
+
+/*
  * Group imbalance indicates (and tries to solve) the problem where balancing
  * groups is inadequate due to tsk_cpus_allowed() constraints.
  *
@@ -6567,6 +6579,14 @@ static int need_active_balance(struct lb_env *env)
 		 */
 		if ((sd->flags & SD_ASYM_PACKING) && env->src_cpu > env->dst_cpu)
 			return 1;
+
+		/*
+		 * The src_cpu's capacity is reduced because of other
+		 * sched_class or IRQs, we trig an active balance to move the
+		 * task
+		 */
+		if (check_cpu_capacity(env->src_rq, sd))
+			return 1;
 	}
 
 	return unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2);
@@ -6668,6 +6688,9 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 
 	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
+	env.src_cpu = busiest->cpu;
+	env.src_rq = busiest;
+
 	ld_moved = 0;
 	if (busiest->nr_running > 1) {
 		/*
@@ -6677,8 +6700,6 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		 * correctly treated as an imbalance.
 		 */
 		env.flags |= LBF_ALL_PINNED;
-		env.src_cpu   = busiest->cpu;
-		env.src_rq    = busiest;
 		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
 
 more_balance:
@@ -7378,10 +7399,12 @@ static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
 
 /*
  * Current heuristic for kicking the idle load balancer in the presence
- * of an idle cpu is the system.
+ * of an idle cpu in the system.
  *   - This rq has more than one task.
- *   - At any scheduler domain level, this cpu's scheduler group has multiple
- *     busy cpu's exceeding the group's capacity.
+ *   - This rq has at least one CFS task and the capacity of the CPU is
+ *     significantly reduced because of RT tasks or IRQs.
+ *   - At parent of LLC scheduler domain level, this cpu's scheduler group has
+ *     multiple busy cpu.
  *   - For SD_ASYM_PACKING, if the lower numbered cpu's in the scheduler
  *     domain span are idle.
  */
@@ -7391,9 +7414,10 @@ static inline int nohz_kick_needed(struct rq *rq)
 	struct sched_domain *sd;
 	struct sched_group_capacity *sgc;
 	int nr_busy, cpu = rq->cpu;
+	bool kick = false;
 
 	if (unlikely(rq->idle_balance))
-		return 0;
+		return false;
 
        /*
 	* We may be recently in ticked or tickless idle mode. At the first
@@ -7407,38 +7431,44 @@ static inline int nohz_kick_needed(struct rq *rq)
 	 * balancing.
 	 */
 	if (likely(!atomic_read(&nohz.nr_cpus)))
-		return 0;
+		return false;
 
 	if (time_before(now, nohz.next_balance))
-		return 0;
+		return false;
 
 	if (rq->nr_running >= 2)
-		goto need_kick;
+		return true;
 
 	rcu_read_lock();
 	sd = rcu_dereference(per_cpu(sd_busy, cpu));
-
 	if (sd) {
 		sgc = sd->groups->sgc;
 		nr_busy = atomic_read(&sgc->nr_busy_cpus);
 
-		if (nr_busy > 1)
-			goto need_kick_unlock;
+		if (nr_busy > 1) {
+			kick = true;
+			goto unlock;
+		}
+
 	}
 
-	sd = rcu_dereference(per_cpu(sd_asym, cpu));
+	sd = rcu_dereference(rq->sd);
+	if (sd) {
+		if ((rq->cfs.h_nr_running >= 1) &&
+				check_cpu_capacity(rq, sd)) {
+			kick = true;
+			goto unlock;
+		}
+	}
 
+	sd = rcu_dereference(per_cpu(sd_asym, cpu));
 	if (sd && (cpumask_first_and(nohz.idle_cpus_mask,
 				  sched_domain_span(sd)) < cpu))
-		goto need_kick_unlock;
-
-	rcu_read_unlock();
-	return 0;
+		kick = true;
 
-need_kick_unlock:
+unlock:
 	rcu_read_unlock();
-need_kick:
-	return 1;
+	return kick;
 }
 #else
 static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle) { }
-- 
1.9.1

