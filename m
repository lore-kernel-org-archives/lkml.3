Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaAUL3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:29:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51881 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbaAUL30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:29:26 -0500
Message-Id: <20140121112258.708117448@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 21 Jan 2014 12:18:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, daniel.lezcano@linaro.org, pjt@google.com,
        bsegall@google.com, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 8/9] sched/fair: Optimize cgroup pick_next_task_fair
References: <20140121111754.580142558@infradead.org>
Content-Disposition: inline; filename=peter_zijlstra-sched-optimize_cgroup_pick_next_task_fair_4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 2f36825b1 ("sched: Next buddy hint on sleep and preempt
path") it is likely we pick a new task from the same cgroup, doing a put
and then set on all intermediate entities is a waste of time, so try to
avoid this.

XXX please review carefully; its quite horrid.

That said, simple hackbench runs in a 3 deep cgroup show a consistent
performance increase (small, but consistent).

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1328936700.2476.17.camel@laptop
---
 kernel/sched/fair.c |  140 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 111 insertions(+), 29 deletions(-)
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2738,15 +2738,46 @@ wakeup_preempt_entity(struct sched_entit
  */
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *se = __pick_first_entity(cfs_rq);
-	struct sched_entity *left = se;
+	struct sched_entity *left = __pick_first_entity(cfs_rq);
+	struct sched_entity *se, *curr = cfs_rq->curr;
+
+	/*
+	 * Since its possible we got here without doing put_prev_entity() we
+	 * also have to consider cfs_rq->curr. If it was set, and is still a
+	 * runnable entity, update_curr() will update its vruntime, otherwise
+	 * forget we've ever seen it.
+	 */
+	if (curr) {
+		if (curr->on_rq)
+			update_curr(cfs_rq);
+		else
+			curr = NULL;
+	}
+
+	/*
+	 * If curr is set we have to see if its left of the leftmost entity
+	 * still in the tree, provided there was anything in the tree at all.
+	 */
+	if (!left || (curr && entity_before(curr, left)))
+		left = curr;
+
+	se = left; /* ideally we run the leftmost entity */
 
 	/*
 	 * Avoid running the skip buddy, if running something else can
 	 * be done without getting too unfair.
 	 */
 	if (cfs_rq->skip == se) {
-		struct sched_entity *second = __pick_next_entity(se);
+		struct sched_entity *second;
+
+		if (se == curr) {
+			second = __pick_first_entity(cfs_rq);
+		} else {
+			second = __pick_next_entity(se);
+			if (!second || (curr && entity_before(curr, second)))
+				second = curr;
+		}
+
 		if (second && wakeup_preempt_entity(second, left) < 1)
 			se = second;
 	}
@@ -2768,7 +2799,7 @@ static struct sched_entity *pick_next_en
 	return se;
 }
 
-static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+static bool check_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
@@ -3423,22 +3454,23 @@ static void check_enqueue_throttle(struc
 }
 
 /* conditionally throttle active cfs_rq's from put_prev_entity() */
-static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+static bool check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
 	if (!cfs_bandwidth_used())
-		return;
+		return false;
 
 	if (likely(!cfs_rq->runtime_enabled || cfs_rq->runtime_remaining > 0))
-		return;
+		return false;
 
 	/*
 	 * it's possible for a throttled entity to be forced into a running
 	 * state (e.g. set_curr_task), in this case we're finished.
 	 */
 	if (cfs_rq_throttled(cfs_rq))
-		return;
+		return true;
 
 	throttle_cfs_rq(cfs_rq);
+	return true;
 }
 
 static enum hrtimer_restart sched_cfs_slack_timer(struct hrtimer *timer)
@@ -3548,7 +3580,7 @@ static inline u64 cfs_rq_clock_task(stru
 }
 
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec) {}
-static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static bool check_cfs_rq_runtime(struct cfs_rq *cfs_rq) { return false; }
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 
@@ -4484,44 +4516,94 @@ static void check_preempt_wakeup(struct
 		set_last_buddy(se);
 }
 
+/*
+ * Account for a descheduled task:
+ */
+static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
+{
+	struct sched_entity *se = &prev->se;
+	struct cfs_rq *cfs_rq;
+
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+		put_prev_entity(cfs_rq, se);
+	}
+}
+
 static struct task_struct *
 pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 {
+	struct sched_entity *se, __maybe_unused *pse;
 	struct task_struct *p;
-	struct cfs_rq *cfs_rq = &rq->cfs;
-	struct sched_entity *se;
+	struct cfs_rq *cfs_rq;
+
+again: __maybe_unused
+	cfs_rq = &rq->cfs;
+
+	if (prev) {
+		if (!IS_ENABLED(CONFIG_FAIR_GROUP_SCHED) ||
+		    (prev->sched_class != &fair_sched_class)) {
+			prev->sched_class->put_prev_task(rq, prev);
+			prev = NULL;
+		}
+	}
 
 	if (!cfs_rq->nr_running)
 		return NULL;
 
-	if (prev)
-		prev->sched_class->put_prev_task(rq, prev);
-
 	do {
 		se = pick_next_entity(cfs_rq);
-		set_next_entity(cfs_rq, se);
+		if (!prev)
+			set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
 
 	p = task_of(se);
-	if (hrtick_enabled(rq))
-		hrtick_start_fair(rq, p);
 
-	return p;
-}
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	/*
+	 * If we haven't yet done put_prev_entity and the selected task is
+	 * a different task than we started out with, try and touch the least
+	 * amount of cfs_rq trees.
+	 */
+	if (prev) {
+		if (prev != p) {
+			pse = &prev->se;
+
+			while (!(cfs_rq = is_same_group(se, pse))) {
+				int se_depth = se->depth;
+				int pse_depth = pse->depth;
+
+				if (se_depth <= pse_depth) {
+					put_prev_entity(cfs_rq_of(pse), pse);
+					pse = parent_entity(pse);
+				}
+				if (se_depth >= pse_depth) {
+					set_next_entity(cfs_rq_of(se), se);
+					se = parent_entity(se);
+				}
+			}
 
-/*
- * Account for a descheduled task:
- */
-static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
-{
-	struct sched_entity *se = &prev->se;
-	struct cfs_rq *cfs_rq;
+			put_prev_entity(cfs_rq, pse);
+			set_next_entity(cfs_rq, se);
+		}
 
-	for_each_sched_entity(se) {
-		cfs_rq = cfs_rq_of(se);
-		put_prev_entity(cfs_rq, se);
+		/*
+		 * In case the common cfs_rq got throttled, just give up and
+		 * put the stack and retry.
+		 */
+		if (unlikely(check_cfs_rq_runtime(cfs_rq))) {
+			put_prev_task_fair(rq, p);
+			prev = NULL;
+			goto again;
+		}
 	}
+#endif
+
+	if (hrtick_enabled(rq))
+		hrtick_start_fair(rq, p);
+
+	return p;
 }
 
 /*


