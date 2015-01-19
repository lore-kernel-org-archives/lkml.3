Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbbASEyC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 23:54:02 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:60422 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbASEv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 23:51:56 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@gmail.com>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH 3/5] sched/deadline: Fix wrong cpudl_find() in check_preempt_equal_dl()
Date: Mon, 19 Jan 2015 04:49:38 +0000
Message-Id: <1421642980-10045-3-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
References: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In check_preempt_equal_dl(), cpudl_find() is called with a NULL
later_mask, thus cpudl_find() here doesn't check cpudl::free_cpus
at all.

This patch takles this issue by always passing a non-NULL later_mask
to cpudl_find(), thereby fixing this issue.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 kernel/sched/cpudeadline.c |  8 +++-----
 kernel/sched/deadline.c    | 15 +++++++++++----
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index c6acb07..f331fcf 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -97,7 +97,7 @@ static inline int cpudl_maximum(struct cpudl *cp)
  * cpudl_find - find the best (later-dl) CPU in the system
  * @cp: the cpudl max-heap context
  * @p: the task
- * @later_mask: a mask to fill in with the selected CPUs (or NULL)
+ * @later_mask: a mask to fill in with the selected CPUs (not NULL)
  *
  * Returns: int - best CPU (heap maximum if suitable)
  */
@@ -107,15 +107,13 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	int best_cpu = -1;
 	const struct sched_dl_entity *dl_se = &p->dl;
 
-	if (later_mask &&
-	    cpumask_and(later_mask, cp->free_cpus, &p->cpus_allowed)) {
+	if (cpumask_and(later_mask, cp->free_cpus, &p->cpus_allowed)) {
 		best_cpu = cpumask_any(later_mask);
 		goto out;
 	} else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
 			dl_time_before(dl_se->deadline, cp->elements[0].dl)) {
 		best_cpu = cpudl_maximum(cp);
-		if (later_mask)
-			cpumask_set_cpu(best_cpu, later_mask);
+		cpumask_set_cpu(best_cpu, later_mask);
 	}
 
 out:
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e7b2722..82d900f 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -943,14 +943,23 @@ out:
 	return cpu;
 }
 
+static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask_dl);
+
 static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 {
+	struct cpumask *later_mask =
+			this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
+
+	/* Make sure the mask is initialized first */
+	if (unlikely(!later_mask))
+		return;
+
 	/*
 	 * Current can't be migrated, useless to reschedule,
 	 * let's hope p can move out.
 	 */
 	if (rq->curr->nr_cpus_allowed == 1 ||
-	    cpudl_find(&rq->rd->cpudl, rq->curr, NULL) == -1)
+	    cpudl_find(&rq->rd->cpudl, rq->curr, later_mask) == -1)
 		return;
 
 	/*
@@ -958,7 +967,7 @@ static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 	 * see if it is pushed or pulled somewhere else.
 	 */
 	if (p->nr_cpus_allowed != 1 &&
-	    cpudl_find(&rq->rd->cpudl, p, NULL) != -1)
+	    cpudl_find(&rq->rd->cpudl, p, later_mask) != -1)
 		return;
 
 	resched_curr(rq);
@@ -1145,8 +1154,6 @@ next_node:
 	return NULL;
 }
 
-static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask_dl);
-
 static int find_later_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-- 
1.9.1

