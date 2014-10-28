Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbaJ1LHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:07:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51075 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaJ1LHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:07:20 -0400
Date: Tue, 28 Oct 2014 04:06:19 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-dfa50b605c2a933b7bb1c1d575a0da4e897e3c7d@git.kernel.org>
Cc: torvalds@linux-foundation.org, mingo@kernel.org, tkhai@yandex.ru,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
        oleg@redhat.com, hpa@zytor.com, peterz@infradead.org
Reply-To: tkhai@yandex.ru, linux-kernel@vger.kernel.org, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rostedt@goodmis.org, tglx@linutronix.de, oleg@redhat.com,
        hpa@zytor.com
In-Reply-To: <20141009193232.GB5408@redhat.com>
References: <20141009193232.GB5408@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Make finish_task_switch() return '
 struct rq *'
Git-Commit-ID: dfa50b605c2a933b7bb1c1d575a0da4e897e3c7d
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

Commit-ID:  dfa50b605c2a933b7bb1c1d575a0da4e897e3c7d
Gitweb:     http://git.kernel.org/tip/dfa50b605c2a933b7bb1c1d575a0da4e897e3c7d
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Thu, 9 Oct 2014 21:32:32 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:47:55 +0100

sched: Make finish_task_switch() return 'struct rq *'

Both callers of finish_task_switch() need to recalculate this_rq()
and pass it as an argument, plus __schedule() does this again after
context_switch().

It would be simpler to call this_rq() once in finish_task_switch()
and return the this rq to the callers.

Note: probably "int cpu" in __schedule() should die; it is not used
and both rcu_note_context_switch() and wq_worker_sleeping() do not
really need this argument.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20141009193232.GB5408@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b493560..1b69603 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2220,7 +2220,6 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 
 /**
  * finish_task_switch - clean up after a task-switch
- * @rq: runqueue associated with task-switch
  * @prev: the thread we just switched away from.
  *
  * finish_task_switch must be called after the context switch, paired
@@ -2232,10 +2231,16 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
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
 
@@ -2275,6 +2280,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	}
 
 	tick_nohz_task_switch(current);
+	return rq;
 }
 
 #ifdef CONFIG_SMP
@@ -2313,8 +2319,7 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
 
 	/* finish_task_switch() drops rq->lock and enables preemtion */
 	preempt_disable();
-	rq = this_rq();
-	finish_task_switch(rq, prev);
+	rq = finish_task_switch(prev);
 	post_schedule(rq);
 	preempt_enable();
 
@@ -2323,10 +2328,9 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
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
@@ -2365,14 +2369,9 @@ context_switch(struct rq *rq, struct task_struct *prev,
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
@@ -2854,15 +2853,8 @@ need_resched:
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
+		cpu = cpu_of(rq);
 	} else
 		raw_spin_unlock_irq(&rq->lock);
 
