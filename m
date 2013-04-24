Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab3DXJjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:39:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39367 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424Ab3DXJjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:39:08 -0400
Date: Wed, 24 Apr 2013 02:38:40 -0700
From: tip-bot for Joonsoo Kim <tipbot@zytor.com>
Message-ID: <tip-e02e60c109ca70935bad1131976bdbf5160cf576@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, davidlohr.bueso@hp.com, a.p.zijlstra@chello.nl,
        peterz@infradead.org, jason.low2@hp.com, tglx@linutronix.de,
        iamjoonsoo.kim@lge.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, davidlohr.bueso@hp.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, jason.low2@hp.com,
        iamjoonsoo.kim@lge.com, tglx@linutronix.de
In-Reply-To: <1366705662-3587-7-git-send-email-iamjoonsoo.kim@lge.com>
References: <1366705662-3587-7-git-send-email-iamjoonsoo.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Prevent to re-select dst-cpu in load_balance()
Git-Commit-ID: e02e60c109ca70935bad1131976bdbf5160cf576
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e02e60c109ca70935bad1131976bdbf5160cf576
Gitweb:     http://git.kernel.org/tip/e02e60c109ca70935bad1131976bdbf5160cf576
Author:     Joonsoo Kim <iamjoonsoo.kim@lge.com>
AuthorDate: Tue, 23 Apr 2013 17:27:42 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Apr 2013 08:52:46 +0200

sched: Prevent to re-select dst-cpu in load_balance()

Commit 88b8dac0 makes load_balance() consider other cpus in its
group. But, in that, there is no code for preventing to
re-select dst-cpu. So, same dst-cpu can be selected over and
over.

This patch add functionality to load_balance() in order to
exclude cpu which is selected once. We prevent to re-select
dst_cpu via env's cpus, so now, env's cpus is a candidate not
only for src_cpus, but also dst_cpus.

With this patch, we can remove lb_iterations and
max_lb_iterations, because we decide whether we can go ahead or
not via env's cpus.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Jason Low <jason.low2@hp.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1366705662-3587-7-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

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
