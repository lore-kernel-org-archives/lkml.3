Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934724AbaEFJwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:52:20 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:11029 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934559AbaEFJwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:52:13 -0400
X-IronPort-AV: E=Sophos;i="4.97,996,1389715200"; 
   d="scan'208";a="30132834"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <mingo@redhat.com>, <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] sched: Remove implementation of dl_time_before().
Date: Tue, 6 May 2014 17:52:23 +0900
Message-ID: <aea3a14b9c8b58f85e7208c52e42253a98f62d70.1399366240.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <79ab3616c1a9206d3d5c5cfcd1b63c94ab8bddfc.1399366240.git.yangds.fnst@cn.fujitsu.com>
References: <79ab3616c1a9206d3d5c5cfcd1b63c94ab8bddfc.1399366240.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As there is a time_before64() in linux/jiffies.h we can use to
achieve our requirement here, we need not to reimplement a new
function of dl_time_before() here.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/sched/cpudeadline.c | 17 ++++++-----------
 kernel/sched/deadline.c    | 30 +++++++++++++++---------------
 kernel/sched/sched.h       |  7 +------
 3 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 5b9bb42..15cedea 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -30,11 +30,6 @@ static inline int right_child(int i)
 	return (i << 1) + 2;
 }
 
-static inline int dl_time_before(u64 a, u64 b)
-{
-	return (s64)(a - b) < 0;
-}
-
 static void cpudl_exchange(struct cpudl *cp, int a, int b)
 {
 	int cpu_a = cp->elements[a].cpu, cpu_b = cp->elements[b].cpu;
@@ -53,10 +48,10 @@ static void cpudl_heapify(struct cpudl *cp, int idx)
 		r = right_child(idx);
 		largest = idx;
 
-		if ((l < cp->size) && dl_time_before(cp->elements[idx].dl,
+		if ((l < cp->size) && time_before64(cp->elements[idx].dl,
 							cp->elements[l].dl))
 			largest = l;
-		if ((r < cp->size) && dl_time_before(cp->elements[largest].dl,
+		if ((r < cp->size) && time_before64(cp->elements[largest].dl,
 							cp->elements[r].dl))
 			largest = r;
 		if (largest == idx)
@@ -72,12 +67,12 @@ static void cpudl_change_key(struct cpudl *cp, int idx, u64 new_dl)
 {
 	WARN_ON(idx == IDX_INVALID || !cpu_present(idx));
 
-	if (dl_time_before(new_dl, cp->elements[idx].dl)) {
+	if (time_before64(new_dl, cp->elements[idx].dl)) {
 		cp->elements[idx].dl = new_dl;
 		cpudl_heapify(cp, idx);
 	} else {
 		cp->elements[idx].dl = new_dl;
-		while (idx > 0 && dl_time_before(cp->elements[parent(idx)].dl,
+		while (idx > 0 && time_before64(cp->elements[parent(idx)].dl,
 					cp->elements[idx].dl)) {
 			cpudl_exchange(cp, idx, parent(idx));
 			idx = parent(idx);
@@ -110,7 +105,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 		best_cpu = cpumask_any(later_mask);
 		goto out;
 	} else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
-			dl_time_before(dl_se->deadline, cp->elements[0].dl)) {
+			time_before64(dl_se->deadline, cp->elements[0].dl)) {
 		best_cpu = cpudl_maximum(cp);
 		if (later_mask)
 			cpumask_set_cpu(best_cpu, later_mask);
@@ -157,7 +152,7 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
 		cp->size--;
 		cp->cpu_to_idx[new_cpu] = old_idx;
 		cp->cpu_to_idx[cpu] = IDX_INVALID;
-		while (old_idx > 0 && dl_time_before(
+		while (old_idx > 0 && time_before64(
 				cp->elements[parent(old_idx)].dl,
 				cp->elements[old_idx].dl)) {
 			cpudl_exchange(cp, old_idx, parent(old_idx));
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b080957..ef53607 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -347,7 +347,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se,
 	 * resetting the deadline and the budget of the
 	 * entity.
 	 */
-	if (dl_time_before(dl_se->deadline, rq_clock(rq))) {
+	if (time_before64(dl_se->deadline, rq_clock(rq))) {
 		static bool lag_once = false;
 
 		if (!lag_once) {
@@ -410,7 +410,7 @@ static bool dl_entity_overflow(struct sched_dl_entity *dl_se,
 	right = ((dl_se->deadline - t) >> DL_SCALE) *
 		(pi_se->dl_runtime >> DL_SCALE);
 
-	return dl_time_before(right, left);
+	return time_before64(right, left);
 }
 
 /*
@@ -437,7 +437,7 @@ static void update_dl_entity(struct sched_dl_entity *dl_se,
 		return;
 	}
 
-	if (dl_time_before(dl_se->deadline, rq_clock(rq)) ||
+	if (time_before64(dl_se->deadline, rq_clock(rq)) ||
 	    dl_entity_overflow(dl_se, pi_se, rq_clock(rq))) {
 		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
 		dl_se->runtime = pi_se->dl_runtime;
@@ -565,7 +565,7 @@ void init_dl_task_timer(struct sched_dl_entity *dl_se)
 static
 int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
 {
-	int dmiss = dl_time_before(dl_se->deadline, rq_clock(rq));
+	int dmiss = time_before64(dl_se->deadline, rq_clock(rq));
 	int rorun = dl_se->runtime <= 0;
 
 	if (!rorun && !dmiss)
@@ -680,7 +680,7 @@ static void inc_dl_deadline(struct dl_rq *dl_rq, u64 deadline)
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
 	if (dl_rq->earliest_dl.curr == 0 ||
-	    dl_time_before(deadline, dl_rq->earliest_dl.curr)) {
+	    time_before64(deadline, dl_rq->earliest_dl.curr)) {
 		/*
 		 * If the dl_rq had no -deadline tasks, or if the new task
 		 * has shorter deadline than the current one on dl_rq, we
@@ -691,7 +691,7 @@ static void inc_dl_deadline(struct dl_rq *dl_rq, u64 deadline)
 		dl_rq->earliest_dl.curr = deadline;
 		cpudl_set(&rq->rd->cpudl, rq->cpu, deadline, 1);
 	} else if (dl_rq->earliest_dl.next == 0 ||
-		   dl_time_before(deadline, dl_rq->earliest_dl.next)) {
+		   time_before64(deadline, dl_rq->earliest_dl.next)) {
 		/*
 		 * On the other hand, if the new -deadline task has a
 		 * a later deadline than the earliest one on dl_rq, but
@@ -773,7 +773,7 @@ static void __enqueue_dl_entity(struct sched_dl_entity *dl_se)
 	while (*link) {
 		parent = *link;
 		entry = rb_entry(parent, struct sched_dl_entity, rb_node);
-		if (dl_time_before(dl_se->deadline, entry->deadline))
+		if (time_before64(dl_se->deadline, entry->deadline))
 			link = &parent->rb_left;
 		else {
 			link = &parent->rb_right;
@@ -1268,7 +1268,7 @@ static struct rq *find_lock_later_rq(struct task_struct *task, struct rq *rq)
 		 * task, the rq is a good one.
 		 */
 		if (!later_rq->dl.dl_nr_running ||
-		    dl_time_before(task->dl.deadline,
+		    time_before64(task->dl.deadline,
 				   later_rq->dl.earliest_dl.curr))
 			break;
 
@@ -1329,7 +1329,7 @@ retry:
 	 * without going further in pushing next_task.
 	 */
 	if (dl_task(rq->curr) &&
-	    dl_time_before(next_task->dl.deadline, rq->curr->dl.deadline) &&
+	    time_before64(next_task->dl.deadline, rq->curr->dl.deadline) &&
 	    rq->curr->nr_cpus_allowed > 1) {
 		resched_task(rq->curr);
 		return 0;
@@ -1415,7 +1415,7 @@ static int pull_dl_task(struct rq *this_rq)
 		 * we are fine with this.
 		 */
 		if (this_rq->dl.dl_nr_running &&
-		    dl_time_before(this_rq->dl.earliest_dl.curr,
+		    time_before64(this_rq->dl.earliest_dl.curr,
 				   src_rq->dl.earliest_dl.next))
 			continue;
 
@@ -1436,9 +1436,9 @@ static int pull_dl_task(struct rq *this_rq)
 		 *  - it preempts our current (if there's one),
 		 *  - it will preempt the last one we pulled (if any).
 		 */
-		if (p && dl_time_before(p->dl.deadline, dmin) &&
+		if (p && time_before64(p->dl.deadline, dmin) &&
 		    (!this_rq->dl.dl_nr_running ||
-		     dl_time_before(p->dl.deadline,
+		     time_before64(p->dl.deadline,
 				    this_rq->dl.earliest_dl.curr))) {
 			WARN_ON(p == src_rq->curr);
 			WARN_ON(!p->on_rq);
@@ -1447,8 +1447,8 @@ static int pull_dl_task(struct rq *this_rq)
 			 * Then we pull iff p has actually an earlier
 			 * deadline than the current task of its runqueue.
 			 */
-			if (dl_time_before(p->dl.deadline,
-					   src_rq->curr->dl.deadline))
+			if (time_before64(p->dl.deadline,
+					  src_rq->curr->dl.deadline))
 				goto skip;
 
 			ret = 1;
@@ -1628,7 +1628,7 @@ static void prio_changed_dl(struct rq *rq, struct task_struct *p,
 		 * then reschedule, provided p is still on this
 		 * runqueue.
 		 */
-		if (dl_time_before(rq->dl.earliest_dl.curr, p->dl.deadline) &&
+		if (time_before64(rq->dl.earliest_dl.curr, p->dl.deadline) &&
 		    rq->curr == p)
 			resched_task(p);
 #else
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index bbc7e07..bf71df0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -93,18 +93,13 @@ static inline int task_has_dl_policy(struct task_struct *p)
 	return dl_policy(p->policy);
 }
 
-static inline bool dl_time_before(u64 a, u64 b)
-{
-	return (s64)(a - b) < 0;
-}
-
 /*
  * Tells if entity @a should preempt entity @b.
  */
 static inline bool
 dl_entity_preempt(struct sched_dl_entity *a, struct sched_dl_entity *b)
 {
-	return dl_time_before(a->deadline, b->deadline);
+	return time_before64(a->deadline, b->deadline);
 }
 
 /*
-- 
1.8.2.1

