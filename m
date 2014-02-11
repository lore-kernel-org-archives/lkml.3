Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaBKMRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:17:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46508 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaBKMRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:17:19 -0500
Date: Tue, 11 Feb 2014 04:16:46 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-678d5718d8d099421b0dd54c01b0528f4aaf5919@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        akpm@linux-foundation.org, tj@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        akpm@linux-foundation.org, tj@kernel.org, tglx@linutronix.de
In-Reply-To: <1328936700.2476.17.camel@laptop>
References: <1328936700.2476.17.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Optimize cgroup pick_next_task_fair(
 )
Git-Commit-ID: 678d5718d8d099421b0dd54c01b0528f4aaf5919
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:16:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  678d5718d8d099421b0dd54c01b0528f4aaf5919
Gitweb:     http://git.kernel.org/tip/678d5718d8d099421b0dd54c01b0528f4aaf5919
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sat, 11 Feb 2012 06:05:00 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 10 Feb 2014 16:17:19 +0100

sched/fair: Optimize cgroup pick_next_task_fair()

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
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1328936700.2476.17.camel@laptop
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 110 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8461721..a81b241 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2907,17 +2907,36 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
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
@@ -2939,7 +2958,7 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 	return se;
 }
 
-static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+static bool check_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
@@ -3594,22 +3613,23 @@ static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
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
@@ -3719,7 +3739,7 @@ static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
 }
 
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec) {}
-static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static bool check_cfs_rq_runtime(struct cfs_rq *cfs_rq) { return false; }
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 
@@ -4658,9 +4678,86 @@ preempt:
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
+	if (!prev || prev->sched_class != &fair_sched_class)
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
@@ -4669,12 +4766,13 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
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
 
