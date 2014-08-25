Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbaHYQA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:00:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbaHYQA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:00:56 -0400
Date: Mon, 25 Aug 2014 17:57:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kautuk Consul <consul.kautuk@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race
	with try_to_wake_up()
Message-ID: <20140825155738.GA5944@redhat.com>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Kautuk Consul wrote:
>
> I encountered a BUG() scenario within do_exit() on an ARM system.
>
> The problem is due to a race scenario between do_exit() and try_to_wake_up()
> on different CPUs due to usage of sleeping primitives such as __down_common
> and wait_for_common.
>
> Race Scenario
> =============
>
> Let us assume there are 2 CPUs A and B execute code in the following order:
> 1)	CPU A was running in user-mode and enters kernel mode via some
> 	syscall/exception handler.
> 2)	CPU A sets the current task(t) state to TASK_INTERRUPTIBLE via __down_common
> 	or wait_for_common.
> 3)	CPU A checks for signal_pending() and returns due to TIF_SIGPENDING
> 	being set in t's threadinfo due to a previous signal(say SIGKILL) being
> 	received on this task t.
> 4)	CPU A returns returns back to the assembly trap handler and calls
> 	do_work_pending() -> do_signal() -> get_signal() -> do_group_exit()
> 	 -> do_exit()
> 	CPU A  has not yet executed the following line of code before the final
> 	call to schedule:
>     /* causes final put_task_struct in finish_task_switch(). */
>     tsk->state = TASK_DEAD;
> 5)	CPU B tries to send a signal to task t (currently executing on CPU A)
> 	and thus enters: signal_wake_up_state() -> wake_up_state() ->
> 					 try_to_wake_up()
> 6)	CPU B executes all code in try_to_wake_up() till the call to
> 	ttwu_queue -> ttwu_do_activate -> ttwu_do_wakeup().
> 	CPU B has still not executed the following code in ttwu_do_wakeup():
> 	p->state = TASK_RUNNING;
> 7)	CPU A executes the following line of code:
>     /* causes final put_task_struct in finish_task_switch(). */
>     tsk->state = TASK_DEAD;
> 8)	CPU B executes the following code in ttwu_do_wakeup():
> 	p->state = TASK_RUNNING;
> 9)	CPU A continues to the call to do_exit() -> schedule().
> 	Since the tsk->state is TASK_RUNNING, the call to schedule() returns and
> 	do_exit() -> BUG() is hit on CPU A.
>
> Alternate Solution
> ==================
>
> An alternate solution would be to simply set the current task state to
> TASK_RUNNING in __down_common(), wait_for_common() and all other interruptible
> sleeping primitives in their if(signal_pending/signal_pending_state) conditional
> blocks.
>
> But this change seems to me to be more logical because:
> i)		This will involve lesser changes to the kernel core code.
> ii)		Any further sleeping primitives in the kernel also need not suffer from
> 		this kind of race scenario.
>
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> ---
>  kernel/exit.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 32c58f7..69a8231 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -824,14 +824,16 @@ void do_exit(long code)
>  	 *     (or hypervisor of virtual machine switches to other guest)
>  	 *  As a result, we may become TASK_RUNNING after becoming TASK_DEAD
>  	 *
> -	 * To avoid it, we have to wait for releasing tsk->pi_lock which
> -	 * is held by try_to_wake_up()
> +	 * To solve this, we have to compete for tsk->pi_lock which is held by
> +	 * try_to_wake_up().
>  	 */
> -	smp_mb();
> -	raw_spin_unlock_wait(&tsk->pi_lock);
> +	raw_spin_lock(&tsk->pi_lock);
>
>  	/* causes final put_task_struct in finish_task_switch(). */
>  	tsk->state = TASK_DEAD;
> +
> +	raw_spin_unlock(&tsk->pi_lock);
> +
>  	tsk->flags |= PF_NOFREEZE;	/* tell freezer to ignore us */
>  	schedule();
>  	BUG();
> --

Peter, do you remember another problem with TASK_DEAD we discussed recently?
(prev_state == TASK_DEAD detection in finish_task_switch() still looks racy).

I am starting to think that perhaps we need something like below, what do
you all think?

Oleg.

--- x/kernel/sched/core.c
+++ x/kernel/sched/core.c
@@ -2205,9 +2205,10 @@ static void finish_task_switch(struct rq
 	__releases(rq->lock)
 {
 	struct mm_struct *mm = rq->prev_mm;
-	long prev_state;
+	struct task_struct *dead = rq->dead;
 
 	rq->prev_mm = NULL;
+	rq->dead = NULL;
 
 	/*
 	 * A task struct has one reference for the use as "current".
@@ -2220,7 +2221,6 @@ static void finish_task_switch(struct rq
 	 * be dropped twice.
 	 *		Manfred Spraul <manfred@colorfullife.com>
 	 */
-	prev_state = prev->state;
 	vtime_task_switch(prev);
 	finish_arch_switch(prev);
 	perf_event_task_sched_in(prev, current);
@@ -2230,16 +2230,16 @@ static void finish_task_switch(struct rq
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
 		mmdrop(mm);
-	if (unlikely(prev_state == TASK_DEAD)) {
-		if (prev->sched_class->task_dead)
-			prev->sched_class->task_dead(prev);
+	if (unlikely(dead)) {
+		if (dead->sched_class->task_dead)
+			dead->sched_class->task_dead(dead);
 
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
 		 */
-		kprobe_flush_task(prev);
-		put_task_struct(prev);
+		kprobe_flush_task(dead);
+		put_task_struct(dead);
 	}
 
 	tick_nohz_task_switch(current);
@@ -2770,11 +2770,15 @@ need_resched:
 	smp_mb__before_spinlock();
 	raw_spin_lock_irq(&rq->lock);
 
+	if (unlikely(rq->dead))
+		goto deactivate;
+
 	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev))) {
 			prev->state = TASK_RUNNING;
 		} else {
+deactivate:
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 			prev->on_rq = 0;
 
@@ -2826,6 +2830,15 @@ need_resched:
 		goto need_resched;
 }
 
+// called under preempt_disable();
+void exit_schedule()
+{
+	// TODO: kill TASK_DEAD, this is only for proc
+	current->state = TASK_DEAD;
+	task_rq(current)->dead = current;
+	__schedule();
+}
+
 static inline void sched_submit_work(struct task_struct *tsk)
 {
 	if (!tsk->state || tsk_is_pi_blocked(tsk))
--- x/kernel/exit.c
+++ x/kernel/exit.c
@@ -815,25 +815,8 @@ void do_exit(long code)
 		__this_cpu_add(dirty_throttle_leaks, tsk->nr_dirtied);
 	exit_rcu();
 
-	/*
-	 * The setting of TASK_RUNNING by try_to_wake_up() may be delayed
-	 * when the following two conditions become true.
-	 *   - There is race condition of mmap_sem (It is acquired by
-	 *     exit_mm()), and
-	 *   - SMI occurs before setting TASK_RUNINNG.
-	 *     (or hypervisor of virtual machine switches to other guest)
-	 *  As a result, we may become TASK_RUNNING after becoming TASK_DEAD
-	 *
-	 * To avoid it, we have to wait for releasing tsk->pi_lock which
-	 * is held by try_to_wake_up()
-	 */
-	smp_mb();
-	raw_spin_unlock_wait(&tsk->pi_lock);
-
-	/* causes final put_task_struct in finish_task_switch(). */
-	tsk->state = TASK_DEAD;
 	tsk->flags |= PF_NOFREEZE;	/* tell freezer to ignore us */
-	schedule();
+	exit_schedule();
 	BUG();
 	/* Avoid "noreturn function does return".  */
 	for (;;)

