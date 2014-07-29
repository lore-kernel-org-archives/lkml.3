Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaG2JKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:10:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:32934 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaG2JKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:10:30 -0400
Date: Tue, 29 Jul 2014 11:10:18 +0200
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
Message-ID: <20140729091018.GT20603@laptop.programming.kicks-ass.net>
References: <53C2FF4D.3020606@oracle.com>
 <53C31A34.8030500@oracle.com>
 <20140714090449.GL9918@twins.programming.kicks-ass.net>
 <20140714144953.GA8173@redhat.com>
 <20140714160147.GA11986@redhat.com>
 <20140715131240.GA23014@redhat.com>
 <20140715132353.GF9918@twins.programming.kicks-ass.net>
 <20140715142525.GA26029@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715142525.GA26029@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 04:25:25PM +0200, Oleg Nesterov wrote:

> And probably I missed something again, but it seems that this logic is broken
> with __ARCH_WANT_UNLOCKED_CTXSW.
> 
> Of course, even if I am right this is pure theoretical, but smp_wmb() before
> "->on_cpu = 0" is not enough and we need a full barrier ?

(long delay there, forgot about this thread, sorry)

Yes, I think I see that.. but now I think the comment is further wrong.

Its not rq->lock that is important, remember, a concurrent wakeup onto
another CPU does not require our rq->lock at all.

It is the ->on_cpu = 0 store that is important (for both the
UNLOCKED_CTXSW cases). As soon as that store comes through the task can
start running on the remote cpu.

Now the below patch 'fixes' this but at the cost of adding a full
barrier which is somewhat unfortunate to say the least.

wmb's are free on x86 and generally cheaper than mbs, so it would to
find another solution to this problem...

---
 kernel/sched/core.c  | 10 +++++-----
 kernel/sched/sched.h | 10 ++++++++--
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2676866b4394..950264381644 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2214,11 +2214,11 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 * If a task dies, then it sets TASK_DEAD in tsk->state and calls
 	 * schedule one last time. The schedule call will never return, and
 	 * the scheduled task must drop that reference.
-	 * The test for TASK_DEAD must occur while the runqueue locks are
-	 * still held, otherwise prev could be scheduled on another cpu, die
-	 * there before we look at prev->state, and then the reference would
-	 * be dropped twice.
-	 *		Manfred Spraul <manfred@colorfullife.com>
+	 *
+	 * We must observe prev->state before clearing prev->on_cpu (in
+	 * finish_lock_switch), otherwise a concurrent wakeup can get prev
+	 * running on another CPU and we could race with its RUNNING -> DEAD
+	 * transition, and then the reference would be dropped twice.
 	 */
 	prev_state = prev->state;
 	vtime_task_switch(prev);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 579712f4e9d5..259632c09c98 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -973,8 +973,11 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
 	 * We must ensure this doesn't happen until the switch is completely
 	 * finished.
+	 *
+	 * We must furthermore ensure the prev->state read in
+	 * finish_task_switch() is complete before allowing this store.
 	 */
-	smp_wmb();
+	smp_mb();
 	prev->on_cpu = 0;
 #endif
 #ifdef CONFIG_DEBUG_SPINLOCK
@@ -1012,8 +1015,11 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
 	 * We must ensure this doesn't happen until the switch is completely
 	 * finished.
+	 *
+	 * We must furthermore ensure the prev->state read in
+	 * finish_task_switch() is complete before allowing this store.
 	 */
-	smp_wmb();
+	smp_mb();
 	prev->on_cpu = 0;
 #endif
 	local_irq_enable();
