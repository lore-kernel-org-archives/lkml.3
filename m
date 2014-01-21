Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaAUL3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:29:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51875 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbaAUL3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:29:25 -0500
Message-Id: <20140121112258.513021486@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 21 Jan 2014 12:17:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, daniel.lezcano@linaro.org, pjt@google.com,
        bsegall@google.com, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5/9] sched/fair: Track cgroup depth
References: <20140121111754.580142558@infradead.org>
Content-Disposition: inline; filename=peter_zijlstra-sched-optimize_cgroup_pick_next_task_fair_1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Track depth in cgroup tree, this is useful for things like
find_matching_se() where you need to get to a common parent of two
sched entities.

Keeping the depth avoids having to calculate it on the spot, which
saves a number of possible cache-misses.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1328936700.2476.17.camel@laptop
---
 include/linux/sched.h |    1 +
 kernel/sched/fair.c   |   47 +++++++++++++++++++++--------------------------
 2 files changed, 22 insertions(+), 26 deletions(-)
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1064,6 +1064,7 @@ struct sched_entity {
 #endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	int			depth;
 	struct sched_entity	*parent;
 	/* rq on which this entity is (to be) queued: */
 	struct cfs_rq		*cfs_rq;
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -322,13 +322,13 @@ static inline void list_del_leaf_cfs_rq(
 	list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
 
 /* Do the two (enqueued) entities belong to the same group ? */
-static inline int
+static inline struct cfs_rq *
 is_same_group(struct sched_entity *se, struct sched_entity *pse)
 {
 	if (se->cfs_rq == pse->cfs_rq)
-		return 1;
+		return se->cfs_rq;
 
-	return 0;
+	return NULL;
 }
 
 static inline struct sched_entity *parent_entity(struct sched_entity *se)
@@ -336,17 +336,6 @@ static inline struct sched_entity *paren
 	return se->parent;
 }
 
-/* return depth at which a sched entity is present in the hierarchy */
-static inline int depth_se(struct sched_entity *se)
-{
-	int depth = 0;
-
-	for_each_sched_entity(se)
-		depth++;
-
-	return depth;
-}
-
 static void
 find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 {
@@ -360,8 +349,8 @@ find_matching_se(struct sched_entity **s
 	 */
 
 	/* First walk up until both entities are at same depth */
-	se_depth = depth_se(*se);
-	pse_depth = depth_se(*pse);
+	se_depth = (*se)->depth;
+	pse_depth = (*pse)->depth;
 
 	while (se_depth > pse_depth) {
 		se_depth--;
@@ -426,10 +415,10 @@ static inline void list_del_leaf_cfs_rq(
 #define for_each_leaf_cfs_rq(rq, cfs_rq) \
 		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
 
-static inline int
+static inline struct cfs_rq *
 is_same_group(struct sched_entity *se, struct sched_entity *pse)
 {
-	return 1;
+	return cfs_rq_of(se); /* always the same rq */
 }
 
 static inline struct sched_entity *parent_entity(struct sched_entity *se)
@@ -7091,7 +7080,9 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void task_move_group_fair(struct task_struct *p, int on_rq)
 {
+	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq;
+
 	/*
 	 * If the task was not on the rq at the time of this cgroup movement
 	 * it must have been asleep, sleeping tasks keep their ->vruntime
@@ -7117,23 +7108,24 @@ static void task_move_group_fair(struct
 	 * To prevent boost or penalty in the new cfs_rq caused by delta
 	 * min_vruntime between the two cfs_rqs, we skip vruntime adjustment.
 	 */
-	if (!on_rq && (!p->se.sum_exec_runtime || p->state == TASK_WAKING))
+	if (!on_rq && (!se->sum_exec_runtime || p->state == TASK_WAKING))
 		on_rq = 1;
 
 	if (!on_rq)
-		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
+		se->vruntime -= cfs_rq_of(se)->min_vruntime;
 	set_task_rq(p, task_cpu(p));
+	se->depth = se->parent ? se->parent->depth + 1 : 0;
 	if (!on_rq) {
-		cfs_rq = cfs_rq_of(&p->se);
-		p->se.vruntime += cfs_rq->min_vruntime;
+		cfs_rq = cfs_rq_of(se);
+		se->vruntime += cfs_rq->min_vruntime;
 #ifdef CONFIG_SMP
 		/*
 		 * migrate_task_rq_fair() will have removed our previous
 		 * contribution, but we must synchronize for ongoing future
 		 * decay.
 		 */
-		p->se.avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
-		cfs_rq->blocked_load_avg += p->se.avg.load_avg_contrib;
+		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
+		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
 #endif
 	}
 }
@@ -7229,10 +7221,13 @@ void init_tg_cfs_entry(struct task_group
 	if (!se)
 		return;
 
-	if (!parent)
+	if (!parent) {
 		se->cfs_rq = &rq->cfs;
-	else
+		se->depth = 0;
+	} else {
 		se->cfs_rq = parent->my_q;
+		se->depth = parent->depth + 1;
+	}
 
 	se->my_q = cfs_rq;
 	/* guarantee group entities always have weight */


