Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab3HSQNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:13:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36060 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3HSQNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:13:33 -0400
Message-Id: <20130819160425.157603641@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 19 Aug 2013 18:01:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>, Joonsoo Kim <js1304@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 02/10] sched: Factor out code to should_we_balance()
References: <20130819160058.539049611@infradead.org>
Content-Disposition: inline; filename=joonsoo_kim-sched-factor_out_code_to_should_we_balance.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Now checking whether this cpu is appropriate to balance or not
is embedded into update_sg_lb_stats() and this checking has no direct
relationship to this function. There is not enough reason to place
this checking at update_sg_lb_stats(), except saving one iteration
for sched_group_cpus.

In this patch, I factor out this checking to should_we_balance() function.
And before doing actual work for load_balancing, check whether this cpu is
appropriate to balance via should_we_balance(). If this cpu is not
a candidate for balancing, it quit the work immediately.

With this change, we can save two memset cost and can expect better
compiler optimization.

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
[peterz: style changes and a fix in should_we_balance() ]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1375778203-31343-3-git-send-email-iamjoonsoo.kim@lge.com
---
 kernel/sched/fair.c |  111 +++++++++++++++++++++++++---------------------------
 1 file changed, 54 insertions(+), 57 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4510,22 +4510,17 @@ fix_small_capacity(struct sched_domain *
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
@@ -4538,15 +4533,9 @@ static inline void update_sg_lb_stats(st
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
@@ -4566,22 +4555,9 @@ static inline void update_sg_lb_stats(st
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
@@ -4663,7 +4639,7 @@ static bool update_sd_pick_busiest(struc
  * @sds: variable to hold the statistics for this sched_domain.
  */
 static inline void update_sd_lb_stats(struct lb_env *env,
-					int *balance, struct sd_lb_stats *sds)
+					struct sd_lb_stats *sds)
 {
 	struct sched_domain *child = env->sd->child;
 	struct sched_group *sg = env->sd->groups;
@@ -4680,10 +4656,7 @@ static inline void update_sd_lb_stats(st
 
 		local_group = cpumask_test_cpu(env->dst_cpu, sched_group_cpus(sg));
 		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(env, sg, load_idx, local_group, balance, &sgs);
-
-		if (local_group && !(*balance))
-			return;
+		update_sg_lb_stats(env, sg, load_idx, local_group, &sgs);
 
 		sds->total_load += sgs.group_load;
 		sds->total_pwr += sg->sgp->power;
@@ -4916,8 +4889,6 @@ static inline void calculate_imbalance(s
  * to restore balance.
  *
  * @env: The load balancing environment.
- * @balance: Pointer to a variable indicating if this_cpu
- *	is the appropriate cpu to perform load balancing at this_level.
  *
  * Return:	- The busiest group if imbalance exists.
  *		- If no imbalance and user has opted for power-savings balance,
@@ -4925,7 +4896,7 @@ static inline void calculate_imbalance(s
  *		   put to idle by rebalancing its tasks onto our group.
  */
 static struct sched_group *
-find_busiest_group(struct lb_env *env, int *balance)
+find_busiest_group(struct lb_env *env)
 {
 	struct sd_lb_stats sds;
 
@@ -4935,14 +4906,7 @@ find_busiest_group(struct lb_env *env, i
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
@@ -5006,7 +4970,6 @@ find_busiest_group(struct lb_env *env, i
 	return sds.busiest;
 
 out_balanced:
-ret:
 	env->imbalance = 0;
 	return NULL;
 }
@@ -5088,13 +5051,47 @@ static int need_active_balance(struct lb
 
 static int active_load_balance_cpu_stop(void *data);
 
+static int should_we_balance(struct lb_env *env)
+{
+	struct sched_group *sg = env->sd->groups;
+	struct cpumask *sg_cpus, *sg_mask;
+	int cpu, balance_cpu = -1;
+
+	/*
+	 * In the newly idle case, we will allow all the cpu's
+	 * to do the newly idle load balance.
+	 */
+	if (env->idle == CPU_NEWLY_IDLE)
+		return 1;
+
+	sg_cpus = sched_group_cpus(sg);
+	sg_mask = sched_group_mask(sg);
+	/* Try to find first idle cpu */
+	for_each_cpu_and(cpu, sg_cpus, env->cpus) {
+		if (!cpumask_test_cpu(cpu, sg_mask) || !idle_cpu(cpu))
+			continue;
+
+		balance_cpu = cpu;
+		break;
+	}
+
+	if (balance_cpu == -1)
+		balance_cpu = group_balance_cpu(sg);
+
+	/*
+	 * First idle cpu or the first cpu(busiest) in this sched group
+	 * is eligible for doing load balancing at this and above domains.
+	 */
+	return balance_cpu != env->dst_cpu;
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
@@ -5123,12 +5120,11 @@ static int load_balance(int this_cpu, st
 
 	schedstat_inc(sd, lb_count[idle]);
 
-redo:
-	group = find_busiest_group(&env, balance);
-
-	if (*balance == 0)
+	if (!(*should_balance = should_we_balance(&env)))
 		goto out_balanced;
 
+redo:
+	group = find_busiest_group(&env);
 	if (!group) {
 		schedstat_inc(sd, lb_nobusyg[idle]);
 		goto out_balanced;
@@ -5340,7 +5336,7 @@ void idle_balance(int this_cpu, struct r
 	rcu_read_lock();
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
-		int balance = 1;
+		int should_balance;
 
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
@@ -5348,7 +5344,8 @@ void idle_balance(int this_cpu, struct r
 		if (sd->flags & SD_BALANCE_NEWIDLE) {
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance(this_cpu, this_rq,
-						   sd, CPU_NEWLY_IDLE, &balance);
+						   sd, CPU_NEWLY_IDLE,
+						   &should_balance);
 		}
 
 		interval = msecs_to_jiffies(sd->balance_interval);
@@ -5586,7 +5583,7 @@ void update_max_interval(void)
  */
 static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 {
-	int balance = 1;
+	int should_balance = 1;
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long interval;
 	struct sched_domain *sd;
@@ -5618,7 +5615,7 @@ static void rebalance_domains(int cpu, e
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(cpu, rq, sd, idle, &balance)) {
+			if (load_balance(cpu, rq, sd, idle, &should_balance)) {
 				/*
 				 * The LBF_SOME_PINNED logic could have changed
 				 * env->dst_cpu, so we can't know our idle
@@ -5641,7 +5638,7 @@ static void rebalance_domains(int cpu, e
 		 * CPU in our sched group which is doing load balancing more
 		 * actively.
 		 */
-		if (!balance)
+		if (!should_balance)
 			break;
 	}
 	rcu_read_unlock();


