Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978Ab3CZGBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 02:01:25 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59821 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759417Ab3CZGBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 02:01:00 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-57-51513997c09e
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 6/6] sched: prevent to re-select dst-cpu in load_balance()
Date: Tue, 26 Mar 2013 15:01:40 +0900
Message-Id: <1364277700-7509-7-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 88b8dac0 makes load_balance() consider other cpus in its group.
But, in that, there is no code for preventing to re-select dst-cpu.
So, same dst-cpu can be selected over and over.

This patch add functionality to load_balance() in order to exclude
cpu which is selected once. We prevent to re-select dst_cpu via
env's cpus, so now, env's cpus is a candidate not only for src_cpus,
but also dst_cpus.

Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e3f09f4..6f238d2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3883,7 +3883,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 		return 0;
 
 	if (!cpumask_test_cpu(env->dst_cpu, tsk_cpus_allowed(p))) {
-		int new_dst_cpu;
+		int cpu;
 
 		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
 
@@ -3898,12 +3898,14 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 		if (!env->dst_grpmask || (env->flags & LBF_SOME_PINNED))
 			return 0;
 
-		new_dst_cpu = cpumask_first_and(env->dst_grpmask,
-						tsk_cpus_allowed(p));
-		if (new_dst_cpu < nr_cpu_ids) {
-			env->flags |= LBF_SOME_PINNED;
-			env->new_dst_cpu = new_dst_cpu;
-		}
+		/* Prevent to re-select dst_cpu via env's cpus */
+		for_each_cpu_and(cpu, env->dst_grpmask, env->cpus)
+			if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) {
+				env->flags |= LBF_SOME_PINNED;
+				env->new_dst_cpu = cpu;
+				break;
+			}
+
 		return 0;
 	}
 
@@ -4989,7 +4991,6 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			int *balance)
 {
 	int ld_moved, cur_ld_moved, active_balance = 0;
-	int lb_iterations, max_lb_iterations;
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
@@ -5009,11 +5010,6 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	 * other cpus in our group */
 	if (idle == CPU_NEWLY_IDLE) {
 		env.dst_grpmask = NULL;
-		/* we don't care max_lb_iterations in this case,
-		 * in following patch, this will be removed */
-		max_lb_iterations = 0;
-	} else {
-		max_lb_iterations = cpumask_weight(env.dst_grpmask);
 	}
 	cpumask_copy(cpus, cpu_active_mask);
 
@@ -5041,7 +5037,6 @@ redo:
 	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
 	ld_moved = 0;
-	lb_iterations = 1;
 	if (busiest->nr_running > 1) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
@@ -5098,14 +5093,17 @@ more_balance:
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
+			/* Prevent to re-select dst_cpu via env's cpus */
+			cpumask_clear_cpu(env.dst_cpu, env.cpus);
+
 			/*
 			 * Go back to "more_balance" rather than "redo" since we
 			 * need to continue with same src_cpu.
-- 
1.7.9.5

