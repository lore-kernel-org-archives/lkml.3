Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab3BNFte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 00:49:34 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54445 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3BNFsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 00:48:50 -0500
X-AuditID: 9c93016f-b7b1fae000006419-25-511c7abfed44
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 7/8] sched: prevent to re-select dst-cpu in load_balance()
Date: Thu, 14 Feb 2013 14:48:40 +0900
Message-Id: <1360820921-2513-8-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 88b8dac0 makes load_balance() consider other cpus in its group.
But, in that, there is no code for preventing to re-select dst-cpu.
So, same dst-cpu can be selected over and over.

This patch add functionality to load_balance() in order to exclude
cpu which is selected once.

Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e6f8783..d4c6ed0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6814,6 +6814,7 @@ struct task_group root_task_group;
 LIST_HEAD(task_groups);
 #endif
 
+DECLARE_PER_CPU(cpumask_var_t, load_balance_dst_grp);
 DECLARE_PER_CPU(cpumask_var_t, load_balance_cpu_active);
 
 void __init sched_init(void)
@@ -6828,7 +6829,7 @@ void __init sched_init(void)
 	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
 #endif
 #ifdef CONFIG_CPUMASK_OFFSTACK
-	alloc_size += num_possible_cpus() * cpumask_size();
+	alloc_size += num_possible_cpus() * cpumask_size() * 2;
 #endif
 	if (alloc_size) {
 		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
@@ -6851,6 +6852,8 @@ void __init sched_init(void)
 #endif /* CONFIG_RT_GROUP_SCHED */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 		for_each_possible_cpu(i) {
+			per_cpu(load_balance_dst_grp, i) = (void *)ptr;
+			ptr += cpumask_size();
 			per_cpu(load_balance_cpu_active, i) = (void *)ptr;
 			ptr += cpumask_size();
 		}
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7382fa5..70631e8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4974,6 +4974,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 #define MAX_PINNED_INTERVAL	512
 
 /* Working cpumask for load_balance and load_balance_newidle. */
+DEFINE_PER_CPU(cpumask_var_t, load_balance_dst_grp);
 DEFINE_PER_CPU(cpumask_var_t, load_balance_cpu_active);
 
 static int need_active_balance(struct lb_env *env)
@@ -5005,17 +5006,17 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			int *balance)
 {
 	int ld_moved, cur_ld_moved, active_balance = 0;
-	int lb_iterations, max_lb_iterations;
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
+	struct cpumask *dst_grp = __get_cpu_var(load_balance_dst_grp);
 	struct cpumask *cpus = __get_cpu_var(load_balance_cpu_active);
 
 	struct lb_env env = {
 		.sd		= sd,
 		.dst_cpu	= this_cpu,
 		.dst_rq		= this_rq,
-		.dst_grpmask    = sched_group_cpus(sd->groups),
+		.dst_grpmask    = dst_grp,
 		.idle		= idle,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
@@ -5025,9 +5026,9 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	 * other cpus in our group */
 	if (idle == CPU_NEWLY_IDLE) {
 		env.dst_grpmask = NULL;
-		max_lb_iterations = 0;
 	} else {
-		max_lb_iterations = cpumask_weight(env.dst_grpmask);
+		cpumask_copy(dst_grp, sched_group_cpus(sd->groups));
+		cpumask_clear_cpu(env.dst_cpu, env.dst_grpmask);
 	}
 	cpumask_copy(cpus, cpu_active_mask);
 
@@ -5055,7 +5056,6 @@ redo:
 	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
 	ld_moved = 0;
-	lb_iterations = 1;
 	if (busiest->nr_running > 1) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
@@ -5112,14 +5112,17 @@ more_balance:
 		 * moreover subsequent load balance cycles should correct the
 		 * excess load moved.
 		 */
-		if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0 &&
-				lb_iterations++ < max_lb_iterations) {
+		if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0) {
 
 			env.dst_rq	 = cpu_rq(env.new_dst_cpu);
 			env.dst_cpu	 = env.new_dst_cpu;
 			env.flags	&= ~LBF_SOME_PINNED;
 			env.loop	 = 0;
 			env.loop_break	 = sched_nr_migrate_break;
+
+			/* Prevent to re-select dst_cpu */
+			cpumask_clear_cpu(env.dst_cpu, env.dst_grpmask);
+
 			/*
 			 * Go back to "more_balance" rather than "redo" since we
 			 * need to continue with same src_cpu.
-- 
1.7.9.5

