Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbaG2JWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:22:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:35339 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaG2JWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:22:42 -0400
Date: Tue, 29 Jul 2014 11:22:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: Re: finish_task_switch && prev_state (Was: sched, timers: use after
 free in __lock_task_sighand when exiting a process)
Message-ID: <20140729092237.GU12054@laptop.lan>
References: <53C2FF4D.3020606@oracle.com>
 <53C31A34.8030500@oracle.com>
 <20140714090449.GL9918@twins.programming.kicks-ass.net>
 <20140714144953.GA8173@redhat.com>
 <20140714160147.GA11986@redhat.com>
 <20140715131240.GA23014@redhat.com>
 <20140715132353.GF9918@twins.programming.kicks-ass.net>
 <20140715142525.GA26029@redhat.com>
 <20140729091018.GT20603@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729091018.GT20603@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 11:10:18AM +0200, Peter Zijlstra wrote:
> On Tue, Jul 15, 2014 at 04:25:25PM +0200, Oleg Nesterov wrote:
> 
> > And probably I missed something again, but it seems that this logic is broken
> > with __ARCH_WANT_UNLOCKED_CTXSW.
> > 
> > Of course, even if I am right this is pure theoretical, but smp_wmb() before
> > "->on_cpu = 0" is not enough and we need a full barrier ?
> 
> (long delay there, forgot about this thread, sorry)
> 
> Yes, I think I see that.. but now I think the comment is further wrong.
> 
> Its not rq->lock that is important, remember, a concurrent wakeup onto
> another CPU does not require our rq->lock at all.
> 
> It is the ->on_cpu = 0 store that is important (for both the
> UNLOCKED_CTXSW cases). As soon as that store comes through the task can
> start running on the remote cpu.
> 
> Now the below patch 'fixes' this but at the cost of adding a full
> barrier which is somewhat unfortunate to say the least.
> 
> wmb's are free on x86 and generally cheaper than mbs, so it would to
> find another solution to this problem...

Something like so then?

---
 kernel/sched/core.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2676866b4394..179390f7380d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2190,6 +2190,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
  * finish_task_switch - clean up after a task-switch
  * @rq: runqueue associated with task-switch
  * @prev: the thread we just switched away from.
+ * @prev_state: the state of @prev before we switched away from it.
  *
  * finish_task_switch must be called after the context switch, paired
  * with a prepare_task_switch call before the context switch.
@@ -2201,26 +2202,14 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
  * with the lock held can cause deadlocks; see schedule() for
  * details.)
  */
-static void finish_task_switch(struct rq *rq, struct task_struct *prev)
+static void 
+finish_task_switch(struct rq *rq, struct task_struct *prev, long prev_state)
 	__releases(rq->lock)
 {
 	struct mm_struct *mm = rq->prev_mm;
-	long prev_state;
 
 	rq->prev_mm = NULL;
 
-	/*
-	 * A task struct has one reference for the use as "current".
-	 * If a task dies, then it sets TASK_DEAD in tsk->state and calls
-	 * schedule one last time. The schedule call will never return, and
-	 * the scheduled task must drop that reference.
-	 * The test for TASK_DEAD must occur while the runqueue locks are
-	 * still held, otherwise prev could be scheduled on another cpu, die
-	 * there before we look at prev->state, and then the reference would
-	 * be dropped twice.
-	 *		Manfred Spraul <manfred@colorfullife.com>
-	 */
-	prev_state = prev->state;
 	vtime_task_switch(prev);
 	finish_arch_switch(prev);
 	perf_event_task_sched_in(prev, current);
@@ -2279,7 +2268,7 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
 {
 	struct rq *rq = this_rq();
 
-	finish_task_switch(rq, prev);
+	finish_task_switch(rq, prev, 0);
 
 	/*
 	 * FIXME: do we need to worry about rq being invalidated by the
@@ -2304,6 +2293,21 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	       struct task_struct *next)
 {
 	struct mm_struct *mm, *oldmm;
+	/*
+	 * A task struct has one reference for the use as "current".
+	 * If a task dies, then it sets TASK_DEAD in tsk->state and calls
+	 * schedule one last time. The schedule call will never return, and
+	 * the scheduled task must drop that reference.
+	 *
+	 * We must observe prev->state before clearing prev->on_cpu (in
+	 * finish_lock_switch), otherwise a concurrent wakeup can get prev
+	 * running on another CPU and we could race with its RUNNING -> DEAD
+	 * transition, and then the reference would be dropped twice.
+	 *
+	 * We avoid the race by observing prev->state while it is still
+	 * current.
+	 */
+	long prev_state = prev->state;
 
 	prepare_task_switch(rq, prev, next);
 
@@ -2347,7 +2351,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 * CPUs since it called schedule(), thus the 'rq' on its stack
 	 * frame will be invalid.
 	 */
-	finish_task_switch(this_rq(), prev);
+	finish_task_switch(this_rq(), prev, prev_state);
 }
 
 /*
