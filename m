Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaAUUpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:45:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37252 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbaAUUnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:43:19 -0500
Date: Tue, 21 Jan 2014 21:43:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: bsegall@google.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, daniel.lezcano@linaro.org,
        pjt@google.com
Subject: Re: [PATCH 8/9] sched/fair: Optimize cgroup pick_next_task_fair
Message-ID: <20140121204312.GS11314@laptop.programming.kicks-ass.net>
References: <20140121111754.580142558@infradead.org>
 <20140121112258.708117448@infradead.org>
 <xm2661pdkuiw.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140121193759.GR11314@laptop.programming.kicks-ass.net>
 <xm261u01kspx.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xm261u01kspx.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 12:03:38PM -0800, bsegall@google.com wrote:

> > Indeed, in that case we can miss something... we could try to call
> > check_cfs_rq_runtime() from the initial top-down selection loop? When
> > true, just put the entire stack and don't pretend to be smart?
> 
> Yeah, I think that should work. I wasn't sure if there could be a
> problem of doing throttle_cfs_rq(parent); throttle_cfs_rq(child);, but
> thinking about, that has to be ok, because schedule can do that if
> deactivate throttled the parent, schedule calls update_rq_clock, and
> then put_prev throttled the child.

Maybe something like the below? Completely untested and everything.

There's the obviuos XXX fail that was also in the previous version; not
sure how to deal with that yet, either we need to change the interface
to take struct task_struct **prev, or get smarter :-)

Any other obvious fails in here?

---
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2736,17 +2736,36 @@ wakeup_preempt_entity(struct sched_entit
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
@@ -2768,7 +2787,7 @@ static struct sched_entity *pick_next_en
 	return se;
 }
 
-static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+static bool check_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
@@ -3423,22 +3442,23 @@ static void check_enqueue_throttle(struc
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
@@ -3548,7 +3568,7 @@ static inline u64 cfs_rq_clock_task(stru
 }
 
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec) {}
-static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static bool check_cfs_rq_runtime(struct cfs_rq *cfs_rq) { return false; }
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 
@@ -4484,26 +4504,109 @@ static void check_preempt_wakeup(struct
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
-	struct task_struct *p;
 	struct cfs_rq *cfs_rq = &rq->cfs;
 	struct sched_entity *se;
+	struct task_struct *p;
 
 	if (!cfs_rq->nr_running)
 		return NULL;
 
-	if (prev)
+	if (!IS_ENABLED(CONFIG_FAIR_GROUP_SCHED) ||
+	    (prev->sched_class != &fair_sched_class)) {
 		prev->sched_class->put_prev_task(rq, prev);
+		prev = NULL;
+	}
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	if (!prev)
+		goto simple;
 
 	do {
-		se = pick_next_entity(cfs_rq);
+		struct sched_entity *curr = cfs_rq->curr;
+
+		/*
+		 * Since we got here without doing put_prev_entity() we also
+		 * have to consider cfs_rq->curr. If it is still a runnable
+		 * entity, update_curr() will update its vruntime, otherwise
+		 * forget we've ever seen it.
+		 */
+		if (curr->on_rq)
+			update_curr(cfs_rq);
+		else
+			curr = NULL;
+
+		if (unlikely(check_cfs_rq_runtime(cfs_rq))) {
+			put_prev_task_fair(rq, prev);
+			goto simple;
+		}
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
+	return p;
+simple:
+#endif
+	cfs_rq = &rq->cfs;
+
+	if (!cfs_rq->nr_running) {
+		// XXX FAIL we should never return NULL after putting @prev
+		return NULL;
+	}
+
+	do {
+		se = pick_next_entity(cfs_rq, NULL);
 		set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
 
 	p = task_of(se);
+
 	if (hrtick_enabled(rq))
 		hrtick_start_fair(rq, p);
 
@@ -4511,20 +4614,6 @@ pick_next_task_fair(struct rq *rq, struc
 }
 
 /*
- * Account for a descheduled task:
- */
-static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
-{
-	struct sched_entity *se = &prev->se;
-	struct cfs_rq *cfs_rq;
-
-	for_each_sched_entity(se) {
-		cfs_rq = cfs_rq_of(se);
-		put_prev_entity(cfs_rq, se);
-	}
-}
-
-/*
  * sched_yield() is very simple
  *
  * The magic of dealing with the ->skip buddy is in pick_next_entity.
