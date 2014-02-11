Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaBKMQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:16:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46487 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaBKMQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:16:42 -0500
Date: Tue, 11 Feb 2014 04:16:12 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-fed14d45f945042a15b09de48d7d3d58d9455fc4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1328936700.2476.17.camel@laptop>
References: <1328936700.2476.17.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Track cgroup depth
Git-Commit-ID: fed14d45f945042a15b09de48d7d3d58d9455fc4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:16:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fed14d45f945042a15b09de48d7d3d58d9455fc4
Gitweb:     http://git.kernel.org/tip/fed14d45f945042a15b09de48d7d3d58d9455fc4
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sat, 11 Feb 2012 06:05:00 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 10 Feb 2014 16:17:10 +0100

sched/fair: Track cgroup depth

Track depth in cgroup tree, this is useful for things like
find_matching_se() where you need to get to a common parent of two
sched entities.

Keeping the depth avoids having to calculate it on the spot, which
saves a number of possible cache-misses.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1328936700.2476.17.camel@laptop
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  1 +
 kernel/sched/fair.c   | 47 +++++++++++++++++++++--------------------------
 2 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e3d5564..555e27d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1078,6 +1078,7 @@ struct sched_entity {
 #endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	int			depth;
 	struct sched_entity	*parent;
 	/* rq on which this entity is (to be) queued: */
 	struct cfs_rq		*cfs_rq;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 04fea77..748a7ac 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -322,13 +322,13 @@ static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
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
@@ -336,17 +336,6 @@ static inline struct sched_entity *parent_entity(struct sched_entity *se)
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
@@ -360,8 +349,8 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 	 */
 
 	/* First walk up until both entities are at same depth */
-	se_depth = depth_se(*se);
-	pse_depth = depth_se(*pse);
+	se_depth = (*se)->depth;
+	pse_depth = (*pse)->depth;
 
 	while (se_depth > pse_depth) {
 		se_depth--;
@@ -426,10 +415,10 @@ static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
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
@@ -7262,7 +7251,9 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void task_move_group_fair(struct task_struct *p, int on_rq)
 {
+	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq;
+
 	/*
 	 * If the task was not on the rq at the time of this cgroup movement
 	 * it must have been asleep, sleeping tasks keep their ->vruntime
@@ -7288,23 +7279,24 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
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
@@ -7400,10 +7392,13 @@ void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
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
