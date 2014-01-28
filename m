Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbaA1Rfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:35:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60575 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbaA1Rdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:33:49 -0500
Message-Id: <20140128171948.287518863@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 28 Jan 2014 18:16:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, daniel.lezcano@linaro.org, pjt@google.com,
        bsegall@google.com, Steven Rostedt <rostedt@goodmis.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 7/9] sched/fair: Optimize cgroup pick_next_task_fair
References: <20140128171634.974847076@infradead.org>
Content-Disposition: inline; filename=peter_zijlstra-sched-optimize_cgroup_pick_next_task_fair_4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 2f36825b1 ("sched: Next buddy hint on sleep and preempt
path") it is likely we pick a new task from the same cgroup, doing a put
and then set on all intermediate entities is a waste of time, so try to
avoid this.

Measured using:

  mount nodev /cgroup -t cgroup -o cpu
  cd /cgroup
  mkdir a; cd a
  mkdir b; cd b
  mkdir c; cd c
  echo $$ > tasks
  perf stat --repeat 10 -- taskset 1 perf bench sched pipe

PRE :      4.542422684 seconds time elapsed   ( +-  0.33% )
POST:      4.389409991 seconds time elapsed   ( +-  0.32% )

Which shows a significant improvement of ~3.5%

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |  122 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 110 insertions(+), 12 deletions(-)
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2911,17 +2911,36 @@ wakeup_preempt_entity(struct sched_entit
  * 3) pick the "last" process, for cache locality
  * 4) do not run the "skip" process, if something else is available
  */
-static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
+static struct sched_entity *
+pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 {
-	struct sched_entity *se = __pick_first_entity(cfs_rq);
-	struct sched_entity *left = se;
+	struct sched_entity *left = __pick_first_entity(cfs_rq);
+	struct sched_entity *se;
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
@@ -2943,7 +2962,7 @@ static struct sched_entity *pick_next_en
 	return se;
 }
 
-static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+static bool check_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
@@ -3598,22 +3617,23 @@ static void check_enqueue_throttle(struc
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
@@ -3723,7 +3743,7 @@ static inline u64 cfs_rq_clock_task(stru
 }
 
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec) {}
-static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static bool check_cfs_rq_runtime(struct cfs_rq *cfs_rq) { return false; }
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 
@@ -4662,9 +4682,86 @@ static void check_preempt_wakeup(struct
 static struct task_struct *
 pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 {
-	struct task_struct *p;
 	struct cfs_rq *cfs_rq = &rq->cfs;
 	struct sched_entity *se;
+	struct task_struct *p;
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	if (!cfs_rq->nr_running)
+		return NULL;
+
+	if (prev->sched_class != &fair_sched_class)
+		goto simple;
+
+	/*
+	 * Because of the set_next_buddy() in dequeue_task_fair() it is rather
+	 * likely that a next task is from the same cgroup as the current.
+	 *
+	 * Therefore attempt to avoid putting and setting the entire cgroup
+	 * hierarchy, only change the part that actually changes.
+	 */
+
+	do {
+		struct sched_entity *curr = cfs_rq->curr;
+
+		/*
+		 * Since we got here without doing put_prev_entity() we also
+		 * have to consider cfs_rq->curr. If it is still a runnable
+		 * entity, update_curr() will update its vruntime, otherwise
+		 * forget we've ever seen it.
+		 */
+		if (curr && curr->on_rq)
+			update_curr(cfs_rq);
+		else
+			curr = NULL;
+
+		/*
+		 * This call to check_cfs_rq_runtime() will do the throttle and
+		 * dequeue its entity in the parent(s). Therefore the 'simple'
+		 * nr_running test will indeed be correct.
+		 */
+		if (unlikely(check_cfs_rq_runtime(cfs_rq)))
+			goto simple;
+
+		se = pick_next_entity(cfs_rq, curr);
+		cfs_rq = group_cfs_rq(se);
+	} while (cfs_rq);
+
+	p = task_of(se);
+
+	/*
+	 * Since we haven't yet done put_prev_entity and if the selected task
+	 * is a different task than we started out with, try and touch the
+	 * least amount of cfs_rqs.
+	 */
+	if (prev != p) {
+		struct sched_entity *pse = &prev->se;
+
+		while (!(cfs_rq = is_same_group(se, pse))) {
+			int se_depth = se->depth;
+			int pse_depth = pse->depth;
+
+			if (se_depth <= pse_depth) {
+				put_prev_entity(cfs_rq_of(pse), pse);
+				pse = parent_entity(pse);
+			}
+			if (se_depth >= pse_depth) {
+				set_next_entity(cfs_rq_of(se), se);
+				se = parent_entity(se);
+			}
+		}
+
+		put_prev_entity(cfs_rq, pse);
+		set_next_entity(cfs_rq, se);
+	}
+
+	if (hrtick_enabled(rq))
+		hrtick_start_fair(rq, p);
+
+	return p;
+simple:
+	cfs_rq = &rq->cfs;
+#endif
 
 	if (!cfs_rq->nr_running)
 		return NULL;
@@ -4672,12 +4769,13 @@ pick_next_task_fair(struct rq *rq, struc
 	prev->sched_class->put_prev_task(rq, prev);
 
 	do {
-		se = pick_next_entity(cfs_rq);
+		se = pick_next_entity(cfs_rq, NULL);
 		set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
 
 	p = task_of(se);
+
 	if (hrtick_enabled(rq))
 		hrtick_start_fair(rq, p);
 


