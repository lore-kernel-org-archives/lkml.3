Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaKFHxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 02:53:11 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:38874 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaKFHxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 02:53:08 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v4 5/7] sched/deadline: Fix several problems with cpudl_find()
Date: Thu,  6 Nov 2014 15:52:05 +0800
Message-Id: <1415260327-30465-5-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415260327-30465-1-git-send-email-pang.xunlei@linaro.org>
References: <1415260327-30465-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpudl_find() has some problems:

1)in check_preempt_equal_dl(), called with NULL later_mask, thus
cpudl_find() doesn't check cpudl.free_cpus at all.

2)Also, the whole system isn't always overloaded with many DL tasks
in which cases all the cpu may have a DL task running, so it may
return the best cpu, because we only return the first maximum deadline
cpu(is there a need to iterate the same deadline value to find more
different cpus if possible?).
So it may be reasonable to change the return value of cpudl_find()
to a bool type, because it isn't always the best cpu actually which
can be better determined in find_later_rq() via sched_domain topology.

This patch adds a new cpudl_set_freecpu() to initialize cpudl.free_cpus
when rq_attach_root(), and modifies cpudl_find() and all its call sites
in order to address these problems.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/core.c        |    2 ++
 kernel/sched/cpudeadline.c |   41 ++++++++++++++++++++++-------------------
 kernel/sched/cpudeadline.h |    1 +
 kernel/sched/deadline.c    |   32 +++++++++++++++-----------------
 4 files changed, 40 insertions(+), 36 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 240157c..17d5778 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5584,6 +5584,8 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	rq->rd = rd;
 
 	cpumask_set_cpu(rq->cpu, rd->span);
+	cpudl_set_freecpu(rq->cpu, &rd->cpudl);
+
 	if (cpumask_test_cpu(rq->cpu, cpu_active_mask))
 		set_rq_online(rq);
 
diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 539ca3c..1dd446a 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -97,30 +97,25 @@ static inline int cpudl_maximum(struct cpudl *cp)
  * cpudl_find - find the best (later-dl) CPU in the system
  * @cp: the cpudl max-heap context
  * @p: the task
- * @later_mask: a mask to fill in with the selected CPUs (or NULL)
+ * @later_mask: a mask to fill in with the selected CPUs (not NULL)
  *
- * Returns: int - best CPU (heap maximum if suitable)
+ * Returns: (int)bool - CPUs were found
  */
 int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	       struct cpumask *later_mask)
 {
-	int best_cpu = -1;
 	const struct sched_dl_entity *dl_se = &p->dl;
 
-	if (later_mask && cpumask_and(later_mask, later_mask, cp->free_cpus)) {
-		best_cpu = cpumask_any(later_mask);
-		goto out;
-	} else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
-			dl_time_before(dl_se->deadline, cp->elements[0].dl)) {
-		best_cpu = cpudl_maximum(cp);
-		if (later_mask)
-			cpumask_set_cpu(best_cpu, later_mask);
+	cpumask_and(later_mask, cpu_active_mask, &p->cpus_allowed);
+	if (cpumask_and(later_mask, later_mask, cp->free_cpus)) {
+		return 1;
+	} else if (cpumask_and(later_mask, cpumask_of(cpudl_maximum(cp)),
+		                   &p->cpus_allowed) &&
+		       dl_time_before(dl_se->deadline, cp->elements[0].dl)) {
+		return 1;
 	}
 
-out:
-	WARN_ON(best_cpu != -1 && !cpu_present(best_cpu));
-
-	return best_cpu;
+	return 0;
 }
 
 /*
@@ -165,7 +160,7 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
 			old_idx = parent(old_idx);
 		}
 		cpumask_set_cpu(cpu, cp->free_cpus);
-                cpudl_heapify(cp, old_idx);
+		cpudl_heapify(cp, old_idx);
 
 		goto out;
 	}
@@ -186,6 +181,16 @@ out:
 }
 
 /*
+ * cpudl_set_freecpu - Set the cpudl.free_cpus
+ * @cpu: rd attached cpu
+ * @cp: the cpudl max-heap context
+ */
+void cpudl_set_freecpu(int cpu, struct cpudl *cp)
+{
+	cpumask_set_cpu(cpu, cp->free_cpus);
+}
+
+/*
  * cpudl_init - initialize the cpudl structure
  * @cp: the cpudl max-heap context
  */
@@ -203,7 +208,7 @@ int cpudl_init(struct cpudl *cp)
 	if (!cp->elements)
 		return -ENOMEM;
 
-	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL)) {
+	if (!zalloc_cpumask_var(&cp->free_cpus, GFP_KERNEL)) {
 		kfree(cp->elements);
 		return -ENOMEM;
 	}
@@ -211,8 +216,6 @@ int cpudl_init(struct cpudl *cp)
 	for_each_possible_cpu(i)
 		cp->elements[i].idx = IDX_INVALID;
 
-	cpumask_setall(cp->free_cpus);
-
 	return 0;
 }
 
diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
index 020039b..71478fc 100644
--- a/kernel/sched/cpudeadline.h
+++ b/kernel/sched/cpudeadline.h
@@ -25,6 +25,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid);
 int cpudl_init(struct cpudl *cp);
 void cpudl_cleanup(struct cpudl *cp);
+void cpudl_set_freecpu(int cpu, struct cpudl *cp);
 #endif /* CONFIG_SMP */
 
 #endif /* _LINUX_CPUDL_H */
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 5285332..e0e8013 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -965,14 +965,18 @@ out:
 	return cpu;
 }
 
+static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask_dl);
+
 static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 {
+	struct cpumask *later_mask = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
+
 	/*
 	 * Current can't be migrated, useless to reschedule,
 	 * let's hope p can move out.
 	 */
 	if (rq->curr->nr_cpus_allowed == 1 ||
-	    cpudl_find(&rq->rd->cpudl, rq->curr, NULL) == -1)
+	    !cpudl_find(&rq->rd->cpudl, rq->curr, later_mask))
 		return;
 
 	/*
@@ -980,7 +984,7 @@ static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 	 * see if it is pushed or pulled somewhere else.
 	 */
 	if (p->nr_cpus_allowed != 1 &&
-	    cpudl_find(&rq->rd->cpudl, p, NULL) != -1)
+	    cpudl_find(&rq->rd->cpudl, p, later_mask))
 		return;
 
 	resched_curr(rq);
@@ -1167,14 +1171,12 @@ next_node:
 	return NULL;
 }
 
-static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask_dl);
-
 static int find_later_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
 	struct cpumask *later_mask = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
 	int this_cpu = smp_processor_id();
-	int best_cpu, cpu = task_cpu(task);
+	int cpu = task_cpu(task);
 
 	/* Make sure the mask is initialized first */
 	if (unlikely(!later_mask))
@@ -1187,14 +1189,12 @@ static int find_later_rq(struct task_struct *task)
 	 * We have to consider system topology and task affinity
 	 * first, then we can look for a suitable cpu.
 	 */
-	cpumask_copy(later_mask, task_rq(task)->rd->span);
-	cpumask_and(later_mask, later_mask, cpu_active_mask);
-	cpumask_and(later_mask, later_mask, &task->cpus_allowed);
-	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
-			task, later_mask);
-	if (best_cpu == -1)
+	if (!cpudl_find(&task_rq(task)->rd->cpudl, task, later_mask))
 		return -1;
 
+	if (cpumask_weight(later_mask) == 1)
+		return cpumask_any(later_mask);
+
 	/*
 	 * If we are here, some target has been found,
 	 * the most suitable of which is cached in best_cpu.
@@ -1219,6 +1219,7 @@ static int find_later_rq(struct task_struct *task)
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
+		int best_cpu;
 		if (sd->flags & SD_WAKE_AFFINE) {
 
 			/*
@@ -1231,12 +1232,9 @@ static int find_later_rq(struct task_struct *task)
 				return this_cpu;
 			}
 
-			/*
-			 * Last chance: if best_cpu is valid and is
-			 * in the mask, that becomes our choice.
-			 */
-			if (best_cpu < nr_cpu_ids &&
-			    cpumask_test_cpu(best_cpu, sched_domain_span(sd))) {
+			best_cpu = cpumask_first_and(later_mask,
+								sched_domain_span(sd));
+			if (best_cpu < nr_cpu_ids) {
 				rcu_read_unlock();
 				return best_cpu;
 			}
-- 
1.7.9.5

