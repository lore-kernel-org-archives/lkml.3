Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaBXFNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:13:14 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:64673 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaBXFNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:13:10 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com
Subject: [PATCH 04/10] sched: unify imbalance bias for target group
Date: Mon, 24 Feb 2014 13:12:19 +0800
Message-Id: <1393218745-8795-5-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1393218745-8795-1-git-send-email-alex.shi@linaro.org>
References: <1393218745-8795-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old code considers the bias in source/target_load already. but still
use imbalance_pct as last check in idlest/busiest group finding. It is
also a kind of redundant job. If we bias imbalance in source/target_load,
we'd better not use imbalance_pct again.

After cpu_load array removed, it is nice time to unify the target bias
consideration. So I remove the imbalance_pct from last check and add the
live bias using.

On wake_affine, since all archs' wake_idx is 0, current logical is just
want to prefer current cpu. so we follows this logical. Just renaming the
target_load/source_load to wegithed_cpuload for more exact meaning.
Thanks for reminding from Morten!

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index eeffe75..5a3ea72 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1016,7 +1016,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
 
 static unsigned long weighted_cpuload(const int cpu);
 static unsigned long source_load(int cpu);
-static unsigned long target_load(int cpu);
+static unsigned long target_load(int cpu, int imbalance_pct);
 static unsigned long power_of(int cpu);
 static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
 
@@ -3967,7 +3967,7 @@ static unsigned long source_load(int cpu)
  * Return a high guess at the load of a migration-target cpu weighted
  * according to the scheduling class and "nice" value.
  */
-static unsigned long target_load(int cpu)
+static unsigned long target_load(int cpu, int imbalance_pct)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
@@ -3975,6 +3975,11 @@ static unsigned long target_load(int cpu)
 	if (!sched_feat(LB_BIAS))
 		return total;
 
+	/*
+	 * Bias target load with imbalance_pct.
+	 */
+	total = total * imbalance_pct / 100;
+
 	return max(rq->cpu_load, total);
 }
 
@@ -4190,8 +4195,8 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 	this_cpu  = smp_processor_id();
 	prev_cpu  = task_cpu(p);
-	load	  = source_load(prev_cpu);
-	this_load = target_load(this_cpu);
+	load	  = weighted_cpuload(prev_cpu);
+	this_load = weighted_cpuload(this_cpu);
 
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
@@ -4247,7 +4252,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 	if (balanced ||
 	    (this_load <= load &&
-	     this_load + target_load(prev_cpu) <= tl_per_task)) {
+		     this_load + weighted_cpuload(prev_cpu) <= tl_per_task)) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
@@ -4293,7 +4298,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 			if (local_group)
 				load = source_load(i);
 			else
-				load = target_load(i);
+				load = target_load(i, imbalance);
 
 			avg_load += load;
 		}
@@ -4309,7 +4314,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 		}
 	} while (group = group->next, group != sd->groups);
 
-	if (!idlest || 100*this_load < imbalance*min_load)
+	if (!idlest || this_load < min_load)
 		return NULL;
 	return idlest;
 }
@@ -5745,6 +5750,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 {
 	unsigned long load;
 	int i;
+	int bias = 100 + (env->sd->imbalance_pct - 100) / 2;
 
 	memset(sgs, 0, sizeof(*sgs));
 
@@ -5752,8 +5758,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		struct rq *rq = cpu_rq(i);
 
 		/* Bias balancing toward cpus of our domain */
-		if (local_group)
-			load = target_load(i);
+		if (local_group && env->idle != CPU_IDLE)
+			load = target_load(i, bias);
 		else
 			load = source_load(i);
 
@@ -6193,14 +6199,6 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 		if ((local->idle_cpus < busiest->idle_cpus) &&
 		    busiest->sum_nr_running <= busiest->group_weight)
 			goto out_balanced;
-	} else {
-		/*
-		 * In the CPU_NEWLY_IDLE, CPU_NOT_IDLE cases, use
-		 * imbalance_pct to be conservative.
-		 */
-		if (100 * busiest->avg_load <=
-				env->sd->imbalance_pct * local->avg_load)
-			goto out_balanced;
 	}
 
 force_balance:
-- 
1.8.1.2

