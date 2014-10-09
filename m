Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaJITgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:36:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbaJITfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:35:54 -0400
Date: Thu, 9 Oct 2014 21:32:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: [PATCH 1/1] sched: make finish_task_switch() return struct rq *
Message-ID: <20141009193232.GB5408@redhat.com>
References: <20141007195046.GA28002@redhat.com> <20141009193207.GA5408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009193207.GA5408@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both callers of finish_task_switch() need to recalculate this_rq()
and pass it as an argument, plus __schedule() does this again after
context_switch().

It would be simpler to call this_rq() once in finish_task_switch()
and return the this rq to the callers.

Note: probably "int cpu" in __schedule() should die; it is not used
and both rcu_note_context_switch() and wq_worker_sleeping() do not
really need this argument.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/core.c |   37 +++++++++++++++----------------------
 1 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index cfe9905..3bfbd3d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2200,10 +2200,16 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
  * so, we finish that here outside of the runqueue lock. (Doing it
  * with the lock held can cause deadlocks; see schedule() for
  * details.)
+ *
+ * The context switch have flipped the stack from under us and restored the
+ * local variables which were saved when this task called schedule() in the
+ * past. prev == current is still correct but we need to recalculate this_rq
+ * because prev may have moved to another CPU.
  */
-static void finish_task_switch(struct rq *rq, struct task_struct *prev)
+static struct rq *finish_task_switch(struct task_struct *prev)
 	__releases(rq->lock)
 {
+	struct rq *rq = this_rq();
 	struct mm_struct *mm = rq->prev_mm;
 	long prev_state;
 
@@ -2243,6 +2249,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	}
 
 	tick_nohz_task_switch(current);
+	return rq;
 }
 
 #ifdef CONFIG_SMP
@@ -2281,8 +2288,7 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
 
 	/* finish_task_switch() drops rq->lock and enables preemtion */
 	preempt_disable();
-	rq = this_rq();
-	finish_task_switch(rq, prev);
+	rq = finish_task_switch(prev);
 	post_schedule(rq);
 	preempt_enable();
 
@@ -2291,10 +2297,9 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
 }
 
 /*
- * context_switch - switch to the new MM and the new
- * thread's register state.
+ * context_switch - switch to the new MM and the new thread's register state.
  */
-static inline void
+static inline struct rq *
 context_switch(struct rq *rq, struct task_struct *prev,
 	       struct task_struct *next)
 {
@@ -2335,14 +2340,9 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	context_tracking_task_switch(prev, next);
 	/* Here we just switch the register state and the stack. */
 	switch_to(prev, next, prev);
-
 	barrier();
-	/*
-	 * this_rq must be evaluated again because prev may have moved
-	 * CPUs since it called schedule(), thus the 'rq' on its stack
-	 * frame will be invalid.
-	 */
-	finish_task_switch(this_rq(), prev);
+
+	return finish_task_switch(prev);
 }
 
 /*
@@ -2802,15 +2802,8 @@ need_resched:
 		rq->curr = next;
 		++*switch_count;
 
-		context_switch(rq, prev, next); /* unlocks the rq */
-		/*
-		 * The context switch have flipped the stack from under us
-		 * and restored the local variables which were saved when
-		 * this task called schedule() in the past. prev == current
-		 * is still correct, but it can be moved to another cpu/rq.
-		 */
-		cpu = smp_processor_id();
-		rq = cpu_rq(cpu);
+		rq = context_switch(rq, prev, next); /* unlocks the rq */
+		cpu = rq->cpu;
 	} else
 		raw_spin_unlock_irq(&rq->lock);
 
-- 
1.5.5.1


