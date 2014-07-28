Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaG1RyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:54:14 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46211 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaG1Rwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:52:55 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v4 08/12] sched: move cfs task on a CPU with higher capacity
Date: Mon, 28 Jul 2014 19:51:42 +0200
Message-Id: <1406569906-9763-9-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406569906-9763-1-git-send-email-vincent.guittot@linaro.org>
References: <1406569906-9763-1-git-send-email-vincent.guittot@linaro.org>
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

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 69 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 20 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6843016..1cde8dd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5969,6 +5969,14 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 			return true;
 	}
 
+	/*
+	 * The group capacity is reduced probably because of activity from other
+	 * sched class or interrupts which use part of the available capacity
+	 */
+	if ((sg->sgc->capacity_orig * 100) > (sgs->group_capacity *
+				env->sd->imbalance_pct))
+		return true;
+
 	return false;
 }
 
@@ -6455,13 +6463,23 @@ static int need_active_balance(struct lb_env *env)
 	struct sched_domain *sd = env->sd;
 
 	if (env->idle == CPU_NEWLY_IDLE) {
+		int src_cpu = env->src_cpu;
 
 		/*
 		 * ASYM_PACKING needs to force migrate tasks from busy but
 		 * higher numbered CPUs in order to pack all tasks in the
 		 * lowest numbered CPUs.
 		 */
-		if ((sd->flags & SD_ASYM_PACKING) && env->src_cpu > env->dst_cpu)
+		if ((sd->flags & SD_ASYM_PACKING) && src_cpu > env->dst_cpu)
+			return 1;
+
+		/*
+		 * If the CPUs share their cache and the src_cpu's capacity is
+		 * reduced because of other sched_class or IRQs, we trig an
+		 * active balance to move the task
+		 */
+		if ((capacity_orig_of(src_cpu) * 100) > (capacity_of(src_cpu) *
+				sd->imbalance_pct))
 			return 1;
 	}
 
@@ -6563,6 +6581,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 
 	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
+	env.src_cpu = busiest->cpu;
+
 	ld_moved = 0;
 	if (busiest->nr_running > 1) {
 		/*
@@ -6572,7 +6592,6 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		 * correctly treated as an imbalance.
 		 */
 		env.flags |= LBF_ALL_PINNED;
-		env.src_cpu   = busiest->cpu;
 		env.src_rq    = busiest;
 		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
 
@@ -7262,10 +7281,12 @@ static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
 
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
@@ -7275,9 +7296,10 @@ static inline int nohz_kick_needed(struct rq *rq)
 	struct sched_domain *sd;
 	struct sched_group_capacity *sgc;
 	int nr_busy, cpu = rq->cpu;
+	bool kick = false;
 
 	if (unlikely(rq->idle_balance))
-		return 0;
+		return false;
 
        /*
 	* We may be recently in ticked or tickless idle mode. At the first
@@ -7291,38 +7313,45 @@ static inline int nohz_kick_needed(struct rq *rq)
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
+				((rq->cpu_capacity * sd->imbalance_pct) <
+				(rq->cpu_capacity_orig * 100))) {
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

