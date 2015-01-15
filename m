Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbbAOKNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:13:06 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:34150 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbAOKNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:13:00 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com
Cc: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        dietmar.eggemann@arm.com, linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH RESEND v9 10/10] sched: move cfs task on a CPU with higher capacity
Date: Thu, 15 Jan 2015 11:09:30 +0100
Message-Id: <1421316570-23097-11-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421316570-23097-1-git-send-email-vincent.guittot@linaro.org>
References: <1421316570-23097-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a CPU is used to handle a lot of IRQs or some RT tasks, the remaining
capacity for CFS tasks can be significantly reduced. Once we detect such
situation by comparing cpu_capacity_orig and cpu_capacity, we trig an idle
load balance to check if it's worth moving its tasks on an idle CPU.

Once the idle load_balance has selected the busiest CPU, it will look for an
active load balance for only two cases :
- there is only 1 task on the busiest CPU.
- we haven't been able to move a task of the busiest rq.

A CPU with a reduced capacity is included in the 1st case, and it's worth to
actively migrate its task if the idle CPU has got full capacity. This test has
been added in need_active_balance.

As a sidenote, this will note generate more spurious ilb because we already
trig an ilb if there is more than 1 busy cpu. If this cpu is the only one that
has a task, we will trig the ilb once for migrating the task.

The nohz_kick_needed function has been cleaned up a bit while adding the new
test

env.src_cpu and env.src_rq must be set unconditionnally because they are used
in need_active_balance which is called even if busiest->nr_running equals 1

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 74 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 53 insertions(+), 21 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index db392a6..02e8f7f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6634,6 +6634,28 @@ static int need_active_balance(struct lb_env *env)
 			return 1;
 	}
 
+	/*
+	 * The dst_cpu is idle and the src_cpu CPU has only 1 CFS task.
+	 * It's worth migrating the task if the src_cpu's capacity is reduced
+	 * because of other sched_class or IRQs whereas capacity stays
+	 * available on dst_cpu.
+	 */
+	if ((env->idle != CPU_NOT_IDLE) &&
+			(env->src_rq->cfs.h_nr_running == 1)) {
+		unsigned long src_eff_capacity, dst_eff_capacity;
+
+		dst_eff_capacity = 100;
+		dst_eff_capacity *= capacity_of(env->dst_cpu);
+		dst_eff_capacity *= capacity_orig_of(env->src_cpu);
+
+		src_eff_capacity = sd->imbalance_pct;
+		src_eff_capacity *= capacity_of(env->src_cpu);
+		src_eff_capacity *= capacity_orig_of(env->dst_cpu);
+
+		if (src_eff_capacity < dst_eff_capacity)
+			return 1;
+	}
+
 	return unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2);
 }
 
@@ -6733,6 +6755,9 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 
 	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
+	env.src_cpu = busiest->cpu;
+	env.src_rq = busiest;
+
 	ld_moved = 0;
 	if (busiest->nr_running > 1) {
 		/*
@@ -6742,8 +6767,6 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		 * correctly treated as an imbalance.
 		 */
 		env.flags |= LBF_ALL_PINNED;
-		env.src_cpu   = busiest->cpu;
-		env.src_rq    = busiest;
 		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
 
 more_balance:
@@ -7443,22 +7466,25 @@ static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
 
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
-static inline int nohz_kick_needed(struct rq *rq)
+static inline bool nohz_kick_needed(struct rq *rq)
 {
 	unsigned long now = jiffies;
 	struct sched_domain *sd;
 	struct sched_group_capacity *sgc;
 	int nr_busy, cpu = rq->cpu;
+	bool kick = false;
 
 	if (unlikely(rq->idle_balance))
-		return 0;
+		return false;
 
        /*
 	* We may be recently in ticked or tickless idle mode. At the first
@@ -7472,38 +7498,44 @@ static inline int nohz_kick_needed(struct rq *rq)
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
+		kick = true;
 
+unlock:
 	rcu_read_unlock();
-	return 0;
-
-need_kick_unlock:
-	rcu_read_unlock();
-need_kick:
-	return 1;
+	return kick;
 }
 #else
 static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle) { }
-- 
1.9.1

