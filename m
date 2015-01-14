Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbbANOEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:04:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36908 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbbANOD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:03:57 -0500
Date: Wed, 14 Jan 2015 06:03:25 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-9edfbfed3f544a7830d99b341f0c175995a02950@git.kernel.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@kernel.org, tglx@linutronix.de,
        hpa@zytor.com
Reply-To: hpa@zytor.com, tglx@linutronix.de, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
In-Reply-To: <20150105103554.432381549@infradead.org>
References: <20150105103554.432381549@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/core: Rework rq->clock update skips
Git-Commit-ID: 9edfbfed3f544a7830d99b341f0c175995a02950
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9edfbfed3f544a7830d99b341f0c175995a02950
Gitweb:     http://git.kernel.org/tip/9edfbfed3f544a7830d99b341f0c175995a02950
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 5 Jan 2015 11:18:11 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 14 Jan 2015 13:34:20 +0100

sched/core: Rework rq->clock update skips

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
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: umgwanakikbuti@gmail.com
Link: http://lkml.kernel.org/r/20150105103554.432381549@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  | 12 ++++++++----
 kernel/sched/fair.c  |  2 +-
 kernel/sched/rt.c    |  9 ++++++---
 kernel/sched/sched.h | 15 +++++++++++++--
 4 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 46a2345..b53cc85 100644
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
@@ -1046,7 +1048,7 @@ void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 	 * this case, we can save a useless back to back clock update.
 	 */
 	if (task_on_rq_queued(rq->curr) && test_tsk_need_resched(rq->curr))
-		rq->skip_clock_update = 1;
+		rq_clock_skip_update(rq, true);
 }
 
 #ifdef CONFIG_SMP
@@ -2779,6 +2781,8 @@ need_resched:
 	smp_mb__before_spinlock();
 	raw_spin_lock_irq(&rq->lock);
 
+	rq->clock_skip_update <<= 1; /* promote REQ to ACT */
+
 	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev))) {
@@ -2803,13 +2807,13 @@ need_resched:
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
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 50ff902..2ecf779 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5156,7 +5156,7 @@ static void yield_task_fair(struct rq *rq)
 		 * so we don't do microscopic update in schedule()
 		 * and double the fastpath cost.
 		 */
-		 rq->skip_clock_update = 1;
+		rq_clock_skip_update(rq, true);
 	}
 
 	set_skip_buddy(se);
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index ee15f5a..6725e3c 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -831,11 +831,14 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
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
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index bd23732..0870db2 100644
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
 
@@ -704,6 +703,18 @@ static inline u64 rq_clock_task(struct rq *rq)
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
