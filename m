Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab3IBHlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:41:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52384 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581Ab3IBHlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:41:04 -0400
Date: Mon, 2 Sep 2013 00:40:21 -0700
From: tip-bot for Joonsoo Kim <tipbot@zytor.com>
Message-ID: <tip-23f0d2093c789e612185180c468fa09063834e87@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, pjt@google.com, iamjoonsoo.kim@lge.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, peterz@infradead.org, tglx@linutronix.de,
        iamjoonsoo.kim@lge.com
In-Reply-To: <1375778203-31343-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375778203-31343-3-git-send-email-iamjoonsoo.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Factor out code to should_we_balance()
Git-Commit-ID: 23f0d2093c789e612185180c468fa09063834e87
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 02 Sep 2013 00:40:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23f0d2093c789e612185180c468fa09063834e87
Gitweb:     http://git.kernel.org/tip/23f0d2093c789e612185180c468fa09063834e87
Author:     Joonsoo Kim <iamjoonsoo.kim@lge.com>
AuthorDate: Tue, 6 Aug 2013 17:36:42 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 2 Sep 2013 08:27:34 +0200

sched: Factor out code to should_we_balance()

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

In addition, rename @balance to @continue_balancing in order to represent
its purpose more clearly.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
[ s/should_balance/continue_balancing/g ]
Reviewed-by: Paul Turner <pjt@google.com>
[ Made style changes and a fix in should_we_balance(). ]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1375778203-31343-3-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 107 ++++++++++++++++++++++++++--------------------------
 1 file changed, 53 insertions(+), 54 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8aa217f..9a6daf8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4463,22 +4463,17 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
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
@@ -4492,12 +4487,6 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
-			if (idle_cpu(i) && !first_idle_cpu &&
-					cpumask_test_cpu(i, sched_group_mask(group))) {
-				first_idle_cpu = 1;
-				balance_cpu = i;
-			}
-
 			load = target_load(i, load_idx);
 		} else {
 			load = source_load(i, load_idx);
@@ -4519,22 +4508,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
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
@@ -4613,7 +4589,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
  * @sds: variable to hold the statistics for this sched_domain.
  */
 static inline void update_sd_lb_stats(struct lb_env *env,
-					int *balance, struct sd_lb_stats *sds)
+					struct sd_lb_stats *sds)
 {
 	struct sched_domain *child = env->sd->child;
 	struct sched_group *sg = env->sd->groups;
@@ -4630,10 +4606,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 
 		local_group = cpumask_test_cpu(env->dst_cpu, sched_group_cpus(sg));
 		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(env, sg, load_idx, local_group, balance, &sgs);
-
-		if (local_group && !(*balance))
-			return;
+		update_sg_lb_stats(env, sg, load_idx, local_group, &sgs);
 
 		sds->total_load += sgs.group_load;
 		sds->total_pwr += sg->sgp->power;
@@ -4866,8 +4839,6 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
  * to restore balance.
  *
  * @env: The load balancing environment.
- * @balance: Pointer to a variable indicating if this_cpu
- *	is the appropriate cpu to perform load balancing at this_level.
  *
  * Returns:	- the busiest group if imbalance exists.
  *		- If no imbalance and user has opted for power-savings balance,
@@ -4875,7 +4846,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
  *		   put to idle by rebalancing its tasks onto our group.
  */
 static struct sched_group *
-find_busiest_group(struct lb_env *env, int *balance)
+find_busiest_group(struct lb_env *env)
 {
 	struct sd_lb_stats sds;
 
@@ -4885,14 +4856,7 @@ find_busiest_group(struct lb_env *env, int *balance)
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
@@ -4956,7 +4920,6 @@ force_balance:
 	return sds.busiest;
 
 out_balanced:
-ret:
 	env->imbalance = 0;
 	return NULL;
 }
@@ -5043,13 +5006,47 @@ static int need_active_balance(struct lb_env *env)
 
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
+			int *continue_balancing)
 {
 	int ld_moved, cur_ld_moved, active_balance = 0;
 	struct sched_group *group;
@@ -5079,11 +5076,12 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	schedstat_inc(sd, lb_count[idle]);
 
 redo:
-	group = find_busiest_group(&env, balance);
-
-	if (*balance == 0)
+	if (!should_we_balance(&env)) {
+		*continue_balancing = 0;
 		goto out_balanced;
+	}
 
+	group = find_busiest_group(&env);
 	if (!group) {
 		schedstat_inc(sd, lb_nobusyg[idle]);
 		goto out_balanced;
@@ -5296,7 +5294,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	rcu_read_lock();
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
-		int balance = 1;
+		int continue_balancing = 1;
 
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
@@ -5304,7 +5302,8 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 		if (sd->flags & SD_BALANCE_NEWIDLE) {
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance(this_cpu, this_rq,
-						   sd, CPU_NEWLY_IDLE, &balance);
+						   sd, CPU_NEWLY_IDLE,
+						   &continue_balancing);
 		}
 
 		interval = msecs_to_jiffies(sd->balance_interval);
@@ -5542,7 +5541,7 @@ void update_max_interval(void)
  */
 static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 {
-	int balance = 1;
+	int continue_balancing = 1;
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long interval;
 	struct sched_domain *sd;
@@ -5574,7 +5573,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(cpu, rq, sd, idle, &balance)) {
+			if (load_balance(cpu, rq, sd, idle, &continue_balancing)) {
 				/*
 				 * The LBF_SOME_PINNED logic could have changed
 				 * env->dst_cpu, so we can't know our idle
@@ -5597,7 +5596,7 @@ out:
 		 * CPU in our sched group which is doing load balancing more
 		 * actively.
 		 */
-		if (!balance)
+		if (!continue_balancing)
 			break;
 	}
 	rcu_read_unlock();
