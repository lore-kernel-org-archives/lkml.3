Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab3G3Hts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:49:48 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43228 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab3G3Htq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:49:46 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [RFC PATCH 07/10] sched: Pass hint to active balancer about the task to be chosen
Date: Tue, 30 Jul 2013 13:18:22 +0530
Message-Id: <1375170505-5967-8-git-send-email-srikar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375170505-5967-1-git-send-email-srikar@linux.vnet.ibm.com>
References: <1375170505-5967-1-git-send-email-srikar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073007-7182-0000-0000-000007E6A13C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a task to be active balanced, which improves the numa affinity is
already chosen, then pass the task to the actual migration.

This helps in 2 ways.
- Dont have to iterate through the list of tasks and again chose a
  task.
- If the chosen task has already moved out of runqueue, avoid moving
  some other task that may or may not provide consolidation.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/sched/fair.c  |   20 +++++++++++++++++++-
 kernel/sched/sched.h |    3 +++
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 17027e0..e04703e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4057,6 +4057,18 @@ static int move_one_task(struct lb_env *env)
 {
 	struct task_struct *p, *n;
 
+#ifdef CONFIG_NUMA_BALANCING
+	p = env->src_rq->push_task;
+	if (p) {
+		if (p->on_rq && task_cpu(p) == env->src_rq->cpu) {
+			move_task(p, env);
+			schedstat_inc(env->sd, lb_gained[env->idle]);
+			return 1;
+		}
+		return 0;
+	}
+#endif
+
 again:
 	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
 		if (!preferred_node(p, env))
@@ -5471,6 +5483,9 @@ static int active_load_balance_cpu_stop(void *data)
 	double_unlock_balance(busiest_rq, target_rq);
 out_unlock:
 	busiest_rq->active_balance = 0;
+#ifdef CONFIG_NUMA_BALANCING
+	busiest_rq->push_task = NULL;
+#endif
 	raw_spin_unlock_irq(&busiest_rq->lock);
 	return 0;
 }
@@ -5621,6 +5636,8 @@ select_task_to_pull(struct mm_struct *this_mm, int this_cpu, int nid)
 		rq = cpu_rq(cpu);
 		mm = rq->curr->mm;
 
+		if (rq->push_task)
+			continue;
 		if (mm == this_mm) {
 			if (cpumask_test_cpu(this_cpu, tsk_cpus_allowed(rq->curr)))
 				return rq->curr;
@@ -5823,10 +5840,11 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 			 * only after active load balance is finished.
 			 */
 			raw_spin_lock_irqsave(&this_rq->lock, flags);
-			if (task_rq(p) == this_rq) {
+			if (task_rq(p) == this_rq && !this_rq->push_task) {
 				if (!this_rq->active_balance) {
 					this_rq->active_balance = 1;
 					this_rq->push_cpu = cpu;
+					this_rq->push_task = p;
 					active_balance = 1;
 				}
 			}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index cc03cfd..9f60d74 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -484,6 +484,9 @@ struct rq {
 #endif
 
 	struct sched_avg avg;
+#ifdef CONFIG_NUMA_BALANCING
+	struct task_struct *push_task;
+#endif
 };
 
 static inline int cpu_of(struct rq *rq)
-- 
1.7.1

