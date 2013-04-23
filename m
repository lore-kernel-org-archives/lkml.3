Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3DWI2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 04:28:34 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55449 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab3DWI1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 04:27:50 -0400
X-AuditID: 9c93016f-b7c5fae00000791a-93-517646002641
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Jason Low <jason.low2@hp.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 6/6] sched: prevent to re-select dst-cpu in load_balance()
Date: Tue, 23 Apr 2013 17:27:42 +0900
Message-Id: <1366705662-3587-7-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366705662-3587-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1366705662-3587-1-git-send-email-iamjoonsoo.kim@lge.com>
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

With this patch, we can remove lb_iterations and max_lb_iterations,
because we decide whether we can go ahead or not via env's cpus.

Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5b1e966..acaf567 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3905,7 +3905,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 		return 0;
 
 	if (!cpumask_test_cpu(env->dst_cpu, tsk_cpus_allowed(p))) {
-		int new_dst_cpu;
+		int cpu;
 
 		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
 
@@ -3920,12 +3920,15 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 		if (!env->dst_grpmask || (env->flags & LBF_SOME_PINNED))
 			return 0;
 
-		new_dst_cpu = cpumask_first_and(env->dst_grpmask,
-						tsk_cpus_allowed(p));
-		if (new_dst_cpu < nr_cpu_ids) {
-			env->flags |= LBF_SOME_PINNED;
-			env->new_dst_cpu = new_dst_cpu;
+		/* Prevent to re-select dst_cpu via env's cpus */
+		for_each_cpu_and(cpu, env->dst_grpmask, env->cpus) {
+			if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) {
+				env->flags |= LBF_SOME_PINNED;
+				env->new_dst_cpu = cpu;
+				break;
+			}
 		}
+
 		return 0;
 	}
 
@@ -5008,7 +5011,6 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			int *balance)
 {
 	int ld_moved, cur_ld_moved, active_balance = 0;
-	int lb_iterations, max_lb_iterations;
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
@@ -5028,15 +5030,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	 * For NEWLY_IDLE load_balancing, we don't need to consider
 	 * other cpus in our group
 	 */
-	if (idle == CPU_NEWLY_IDLE) {
+	if (idle == CPU_NEWLY_IDLE)
 		env.dst_grpmask = NULL;
-		/*
-		 * we don't care max_lb_iterations in this case,
-		 * in following patch, this will be removed
-		 */
-		max_lb_iterations = 0;
-	} else
-		max_lb_iterations = cpumask_weight(env.dst_grpmask);
 
 	cpumask_copy(cpus, cpu_active_mask);
 
@@ -5064,7 +5059,6 @@ redo:
 	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
 	ld_moved = 0;
-	lb_iterations = 1;
 	if (busiest->nr_running > 1) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
@@ -5121,14 +5115,17 @@ more_balance:
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

