Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbaKTR2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:28:49 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39090 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbaKTR2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:28:48 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v3 1/3] sched/deadline: Modify cpudl.free_cpus to reflect rd->span
Date: Fri, 21 Nov 2014 01:28:03 +0800
Message-Id: <1416504485-8180-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, cpudl.free_cpus contains all cpus during init(see cpudl_init()),
so when calling cpudl_find() we have to add rd->span cpumask(cpus_allowed is
undependable when performing clustered scheduling using the cpuset) to avoid
selecting the cpu outside current root domain, see find_later_rq().

This patch adds cpudl_set_freecpu() to initialize cpudl.free_cpus when doing
rq_attach_root(), so we can avoid the extra rd->span operation when calling
cpudl_find().

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/core.c        |  2 ++
 kernel/sched/cpudeadline.c | 18 ++++++++++++++----
 kernel/sched/cpudeadline.h |  1 +
 kernel/sched/deadline.c    |  3 ---
 4 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 240157c..1b417de 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5584,6 +5584,8 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	rq->rd = rd;
 
 	cpumask_set_cpu(rq->cpu, rd->span);
+	cpudl_set_freecpu(&rd->cpudl, rq->cpu);
+
 	if (cpumask_test_cpu(rq->cpu, cpu_active_mask))
 		set_rq_online(rq);
 
diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 539ca3c..c79f0d7 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -107,7 +107,9 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	int best_cpu = -1;
 	const struct sched_dl_entity *dl_se = &p->dl;
 
-	if (later_mask && cpumask_and(later_mask, later_mask, cp->free_cpus)) {
+	if (later_mask &&
+	    cpumask_and(later_mask, cp->free_cpus, &p->cpus_allowed) &&
+	    cpumask_and(later_mask, later_mask, cpu_active_mask)) {
 		best_cpu = cpumask_any(later_mask);
 		goto out;
 	} else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
@@ -186,6 +188,16 @@ out:
 }
 
 /*
+ * cpudl_set_freecpu - Set the cpudl.free_cpus
+ * @cp: the cpudl max-heap context
+ * @cpu: rd attached cpu
+ */
+void cpudl_set_freecpu(struct cpudl *cp, int cpu)
+{
+	cpumask_set_cpu(cpu, cp->free_cpus);
+}
+
+/*
  * cpudl_init - initialize the cpudl structure
  * @cp: the cpudl max-heap context
  */
@@ -203,7 +215,7 @@ int cpudl_init(struct cpudl *cp)
 	if (!cp->elements)
 		return -ENOMEM;
 
-	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL)) {
+	if (!zalloc_cpumask_var(&cp->free_cpus, GFP_KERNEL)) {
 		kfree(cp->elements);
 		return -ENOMEM;
 	}
@@ -211,8 +223,6 @@ int cpudl_init(struct cpudl *cp)
 	for_each_possible_cpu(i)
 		cp->elements[i].idx = IDX_INVALID;
 
-	cpumask_setall(cp->free_cpus);
-
 	return 0;
 }
 
diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
index 020039b..4a10a65 100755
--- a/kernel/sched/cpudeadline.h
+++ b/kernel/sched/cpudeadline.h
@@ -24,6 +24,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	       struct cpumask *later_mask);
 void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid);
 int cpudl_init(struct cpudl *cp);
+void cpudl_set_freecpu(struct cpudl *cp, int cpu);
 void cpudl_cleanup(struct cpudl *cp);
 #endif /* CONFIG_SMP */
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 5285332..bd83272 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1187,9 +1187,6 @@ static int find_later_rq(struct task_struct *task)
 	 * We have to consider system topology and task affinity
 	 * first, then we can look for a suitable cpu.
 	 */
-	cpumask_copy(later_mask, task_rq(task)->rd->span);
-	cpumask_and(later_mask, later_mask, cpu_active_mask);
-	cpumask_and(later_mask, later_mask, &task->cpus_allowed);
 	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
 			task, later_mask);
 	if (best_cpu == -1)
-- 
2.1.0

