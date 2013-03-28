Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3C1H77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:59:59 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53645 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab3C1H7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:59:03 -0400
X-AuditID: 9c930197-b7c9dae000006959-a5-5153f844f303
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 2/5] sched: factor out code to should_we_balance()
Date: Thu, 28 Mar 2013 16:58:53 +0900
Message-Id: <1364457537-15114-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now checking that this cpu is appropriate to balance is embedded into
update_sg_lb_stats() and this checking has no direct relationship to this
function.

There is not enough reason to place this checking at update_sg_lb_stats(),
except saving one iteration for sched_group_cpus. But with this change,
we can save two memset cost and can expect better compiler optimization,
so clean-up may be more beneficial to us.

Below is result of this patch.

* Vanilla *
   text	   data	    bss	    dec	    hex	filename
  34499	   1136	    116	  35751	   8ba7	kernel/sched/fair.o

* Patched *
   text	   data	    bss	    dec	    hex	filename
  34243	   1136	    116	  35495	   8aa7	kernel/sched/fair.o

In addition, rename @balance to @should_balance in order to represent
its purpose more clearly.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1d8774f..95ec757 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4406,22 +4406,17 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  * @group: sched_group whose statistics are to be updated.
  * @load_idx: Load index of sched_domain of this_cpu for load calc.
  * @local_group: Does group contain this_cpu.
- * @balance: Should we balance.
  * @sgs: variable to hold the statistics for this group.
  */
 static inline void update_sg_lb_stats(struct lb_env *env,
 			struct sched_group *group, int load_idx,
-			int local_group, int *balance, struct sg_lb_stats *sgs)
+			int local_group, struct sg_lb_stats *sgs)
 {
 	unsigned long nr_running, max_nr_running, min_nr_running;
 	unsigned long load, max_cpu_load, min_cpu_load;
-	unsigned int balance_cpu = -1, first_idle_cpu = 0;
 	unsigned long avg_load_per_task = 0;
 	int i;
 
-	if (local_group)
-		balance_cpu = group_balance_cpu(group);
-
 	/* Tally up the load of all CPUs in the group */
 	max_cpu_load = 0;
 	min_cpu_load = ~0UL;
@@ -4434,15 +4429,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		nr_running = rq->nr_running;
 
 		/* Bias balancing toward cpus of our domain */
-		if (local_group) {
-			if (idle_cpu(i) && !first_idle_cpu &&
-					cpumask_test_cpu(i, sched_group_mask(group))) {
-				first_idle_cpu = 1;
-				balance_cpu = i;
-			}
-
+		if (local_group)
 			load = target_load(i, load_idx);
-		} else {
+		else {
 			load = source_load(i, load_idx);
 			if (load > max_cpu_load)
 				max_cpu_load = load;
@@ -4462,22 +4451,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			sgs->idle_cpus++;
 	}
 
-	/*
-	 * First idle cpu or the first cpu(busiest) in this sched group
-	 * is eligible for doing load balancing at this and above
-	 * domains. In the newly idle case, we will allow all the cpu's
-	 * to do the newly idle load balance.
-	 */
-	if (local_group) {
-		if (env->idle != CPU_NEWLY_IDLE) {
-			if (balance_cpu != env->dst_cpu) {
-				*balance = 0;
-				return;
-			}
-			update_group_power(env->sd, env->dst_cpu);
-		} else if (time_after_eq(jiffies, group->sgp->next_update))
-			update_group_power(env->sd, env->dst_cpu);
-	}
+	if (local_group && (env->idle != CPU_NEWLY_IDLE ||
+			time_after_eq(jiffies, group->sgp->next_update)))
+		update_group_power(env->sd, env->dst_cpu);
 
 	/* Adjust by relative CPU power of the group */
 	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->sgp->power;
@@ -4556,7 +4532,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
  * @sds: variable to hold the statistics for this sched_domain.
  */
 static inline void update_sd_lb_stats(struct lb_env *env,
-					int *balance, struct sd_lb_stats *sds)
+					struct sd_lb_stats *sds)
 {
 	struct sched_domain *child = env->sd->child;
 	struct sched_group *sg = env->sd->groups;
@@ -4573,10 +4549,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 
 		local_group = cpumask_test_cpu(env->dst_cpu, sched_group_cpus(sg));
 		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(env, sg, load_idx, local_group, balance, &sgs);
-
-		if (local_group && !(*balance))
-			return;
+		update_sg_lb_stats(env, sg, load_idx, local_group, &sgs);
 
 		sds->total_load += sgs.group_load;
 		sds->total_pwr += sg->sgp->power;
@@ -4809,8 +4782,6 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
  * to restore balance.
  *
  * @env: The load balancing environment.
- * @balance: Pointer to a variable indicating if this_cpu
- *	is the appropriate cpu to perform load balancing at this_level.
  *
  * Returns:	- the busiest group if imbalance exists.
  *		- If no imbalance and user has opted for power-savings balance,
@@ -4818,7 +4789,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
  *		   put to idle by rebalancing its tasks onto our group.
  */
 static struct sched_group *
-find_busiest_group(struct lb_env *env, int *balance)
+find_busiest_group(struct lb_env *env)
 {
 	struct sd_lb_stats sds;
 
@@ -4828,14 +4799,7 @@ find_busiest_group(struct lb_env *env, int *balance)
 	 * Compute the various statistics relavent for load balancing at
 	 * this level.
 	 */
-	update_sd_lb_stats(env, balance, &sds);
-
-	/*
-	 * this_cpu is not the appropriate cpu to perform load balancing at
-	 * this level.
-	 */
-	if (!(*balance))
-		goto ret;
+	update_sd_lb_stats(env, &sds);
 
 	if ((env->idle == CPU_IDLE || env->idle == CPU_NEWLY_IDLE) &&
 	    check_asym_packing(env, &sds))
@@ -4899,7 +4863,6 @@ force_balance:
 	return sds.busiest;
 
 out_balanced:
-ret:
 	env->imbalance = 0;
 	return NULL;
 }
@@ -4981,13 +4944,46 @@ static int need_active_balance(struct lb_env *env)
 
 static int active_load_balance_cpu_stop(void *data);
 
+static int should_we_balance(struct lb_env *env)
+{
+	struct sched_group *sg = env->sd->groups;
+	int cpu, balance_cpu = -1;
+
+	/*
+	 * In the newly idle case, we will allow all the cpu's
+	 * to do the newly idle load balance.
+	 */
+	if (env->idle == CPU_NEWLY_IDLE)
+		return 1;
+
+	/* Try to find first idle cpu */
+	for_each_cpu_and(cpu, sched_group_cpus(sg), env->cpus)
+		if (cpumask_test_cpu(cpu, sched_group_mask(sg)) &&
+			idle_cpu(cpu)) {
+				balance_cpu = cpu;
+				break;
+			}
+
+	if (balance_cpu == -1)
+		balance_cpu = group_balance_cpu(sg);
+
+	/*
+	 * First idle cpu or the first cpu(busiest) in this sched group
+	 * is eligible for doing load balancing at this and above domains.
+	 */
+	if (balance_cpu != env->dst_cpu)
+		return 0;
+
+	return 1;
+}
+
 /*
  * Check this_cpu to ensure it is balanced within domain. Attempt to move
  * tasks if there is an imbalance.
  */
 static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *balance)
+			int *should_balance)
 {
 	int ld_moved, cur_ld_moved, active_balance = 0;
 	struct sched_group *group;
@@ -5014,12 +5010,14 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 
 	schedstat_inc(sd, lb_count[idle]);
 
-redo:
-	group = find_busiest_group(&env, balance);
-
-	if (*balance == 0)
+	if (!should_we_balance(&env)) {
+		*should_balance = 0;
 		goto out_balanced;
+	} else
+		*should_balance = 1;
 
+redo:
+	group = find_busiest_group(&env);
 	if (!group) {
 		schedstat_inc(sd, lb_nobusyg[idle]);
 		goto out_balanced;
@@ -5234,7 +5232,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	rcu_read_lock();
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
-		int balance = 1;
+		int should_balance;
 
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
@@ -5242,7 +5240,8 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 		if (sd->flags & SD_BALANCE_NEWIDLE) {
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance(this_cpu, this_rq,
-						   sd, CPU_NEWLY_IDLE, &balance);
+						   sd, CPU_NEWLY_IDLE,
+						   &should_balance);
 		}
 
 		interval = msecs_to_jiffies(sd->balance_interval);
@@ -5476,7 +5475,7 @@ void update_max_interval(void)
  */
 static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 {
-	int balance = 1;
+	int should_balance;
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long interval;
 	struct sched_domain *sd;
@@ -5508,7 +5507,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(cpu, rq, sd, idle, &balance)) {
+			if (load_balance(cpu, rq, sd, idle, &should_balance)) {
 				/*
 				 * We've pulled tasks over so either we may
 				 * be no longer idle.
@@ -5530,7 +5529,7 @@ out:
 		 * CPU in our sched group which is doing load balancing more
 		 * actively.
 		 */
-		if (!balance)
+		if (!should_balance)
 			break;
 	}
 	rcu_read_unlock();
-- 
1.7.9.5

