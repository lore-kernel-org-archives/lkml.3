Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbbAEKhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:37:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:46164 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbbAEKhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:37:35 -0500
Message-Id: <20150105103554.432381549@infradead.org>
User-Agent: quilt/0.61-1
Date: Mon, 05 Jan 2015 11:18:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, umgwanakikbuti@gmail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        "Peter Zijlstra" <peterz@infradead.org>
Subject: [RFC][PATCH 2/3] sched: Rework rq->clock update skips
References: <20150105101809.860964488@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-sched-skip_clock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original purpose of rq::skip_clock_update was to avoid 'costly' clock
updates for back to back wakeup-preempt pairs. The big problem with it
has always been that the rq variable is unaware of the context and
causes indiscrimiate clock skips.

Rework the entire thing and create a sense of context by only allowing
schedule() to skip clock updates. (XXX can we measure the cost of the
added store?)

By ensuring only schedule can ever skip an update, we guarantee we're
never more than 1 tick behind on the update.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/sched/core.c  |   12 ++++++++----
 kernel/sched/fair.c  |    2 +-
 kernel/sched/rt.c    |    9 ++++++---
 kernel/sched/sched.h |   15 +++++++++++++--
 4 files changed, 28 insertions(+), 10 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -119,7 +119,9 @@ void update_rq_clock(struct rq *rq)
 {
 	s64 delta;
 
-	if (rq->skip_clock_update > 0)
+	lockdep_assert_held(&rq->lock);
+
+	if (rq->clock_skip_update & RQCF_ACT_SKIP)
 		return;
 
 	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
@@ -1046,7 +1048,7 @@ void check_preempt_curr(struct rq *rq, s
 	 * this case, we can save a useless back to back clock update.
 	 */
 	if (task_on_rq_queued(rq->curr) && test_tsk_need_resched(rq->curr))
-		rq->skip_clock_update = 1;
+		rq_clock_skip_update(rq, true);
 }
 
 #ifdef CONFIG_SMP
@@ -2776,6 +2778,8 @@ static void __sched __schedule(void)
 	smp_mb__before_spinlock();
 	raw_spin_lock_irq(&rq->lock);
 
+	rq->clock_skip_update <<= 1; /* promote REQ to ACT */
+
 	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev))) {
@@ -2800,13 +2804,13 @@ static void __sched __schedule(void)
 		switch_count = &prev->nvcsw;
 	}
 
-	if (task_on_rq_queued(prev) || rq->skip_clock_update < 0)
+	if (task_on_rq_queued(prev))
 		update_rq_clock(rq);
 
 	next = pick_next_task(rq, prev);
 	clear_tsk_need_resched(prev);
 	clear_preempt_need_resched();
-	rq->skip_clock_update = 0;
+	rq->clock_skip_update = 0;
 
 	if (likely(prev != next)) {
 		rq->nr_switches++;
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5153,7 +5153,7 @@ static void yield_task_fair(struct rq *r
 		 * so we don't do microscopic update in schedule()
 		 * and double the fastpath cost.
 		 */
-		 rq->skip_clock_update = 1;
+		rq_clock_skip_update(rq, true);
 	}
 
 	set_skip_buddy(se);
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -831,11 +831,14 @@ static int do_sched_rt_period_timer(stru
 				enqueue = 1;
 
 				/*
-				 * Force a clock update if the CPU was idle,
-				 * lest wakeup -> unthrottle time accumulate.
+				 * When we're idle and a woken (rt) task is
+				 * throttled check_preempt_curr() will set
+				 * skip_update and the time between the wakeup
+				 * and this unthrottle will get accounted as
+				 * 'runtime'.
 				 */
 				if (rt_rq->rt_nr_running && rq->curr == rq->idle)
-					rq->skip_clock_update = -1;
+					rq_clock_skip_update(rq, false);
 			}
 			if (rt_rq->rt_time || rt_rq->rt_nr_running)
 				idle = 0;
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -558,8 +558,6 @@ struct rq {
 #ifdef CONFIG_NO_HZ_FULL
 	unsigned long last_sched_tick;
 #endif
-	int skip_clock_update;
-
 	/* capture load from *all* tasks on this cpu: */
 	struct load_weight load;
 	unsigned long nr_load_updates;
@@ -588,6 +586,7 @@ struct rq {
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
 
+	unsigned int clock_skip_update;
 	u64 clock;
 	u64 clock_task;
 
@@ -704,6 +703,18 @@ static inline u64 rq_clock_task(struct r
 	return rq->clock_task;
 }
 
+#define RQCF_REQ_SKIP	0x01
+#define RQCF_ACT_SKIP	0x02
+
+static inline void rq_clock_skip_update(struct rq *rq, bool skip)
+{
+	lockdep_assert_held(&rq->lock);
+	if (skip)
+		rq->clock_skip_update |= RQCF_REQ_SKIP;
+	else
+		rq->clock_skip_update &= ~RQCF_REQ_SKIP;
+}
+
 #ifdef CONFIG_NUMA
 enum numa_topology_type {
 	NUMA_DIRECT,


