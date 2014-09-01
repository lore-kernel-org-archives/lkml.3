Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbaIAPjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:39:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:57749 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbaIAPjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:39:39 -0400
Date: Mon, 1 Sep 2014 17:39:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race
 with try_to_wake_up()
Message-ID: <20140901153935.GQ27892@worktop.ger.corp.intel.com>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com>
 <20140825155738.GA5944@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140825155738.GA5944@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 05:57:38PM +0200, Oleg Nesterov wrote:
> Peter, do you remember another problem with TASK_DEAD we discussed recently?
> (prev_state == TASK_DEAD detection in finish_task_switch() still looks racy).

Uhm, right. That was somewhere on the todo list :-)

> I am starting to think that perhaps we need something like below, what do
> you all think?

I'm thinking you lost the hunk that adds rq::dead :-), more comments
below.

> --- x/kernel/sched/core.c
> +++ x/kernel/sched/core.c
> @@ -2205,9 +2205,10 @@ static void finish_task_switch(struct rq
>  	__releases(rq->lock)
>  {
>  	struct mm_struct *mm = rq->prev_mm;
> -	long prev_state;
> +	struct task_struct *dead = rq->dead;
>  
>  	rq->prev_mm = NULL;
> +	rq->dead = NULL;
>  
>  	/*
>  	 * A task struct has one reference for the use as "current".
> @@ -2220,7 +2221,6 @@ static void finish_task_switch(struct rq
>  	 * be dropped twice.
>  	 *		Manfred Spraul <manfred@colorfullife.com>
>  	 */

Clearly that comment needs to go as well..

> -	prev_state = prev->state;
>  	vtime_task_switch(prev);
>  	finish_arch_switch(prev);
>  	perf_event_task_sched_in(prev, current);
> @@ -2230,16 +2230,16 @@ static void finish_task_switch(struct rq
>  	fire_sched_in_preempt_notifiers(current);
>  	if (mm)
>  		mmdrop(mm);
> -	if (unlikely(prev_state == TASK_DEAD)) {
> -		if (prev->sched_class->task_dead)
> -			prev->sched_class->task_dead(prev);
> +	if (unlikely(dead)) {

	BUG_ON(dead != prev); ?

> +		if (dead->sched_class->task_dead)
> +			dead->sched_class->task_dead(dead);
>  
>  		/*
>  		 * Remove function-return probe instances associated with this
>  		 * task and put them back on the free list.
>  		 */
> -		kprobe_flush_task(prev);
> -		put_task_struct(prev);
> +		kprobe_flush_task(dead);
> +		put_task_struct(dead);
>  	}
>  
>  	tick_nohz_task_switch(current);
> @@ -2770,11 +2770,15 @@ need_resched:
>  	smp_mb__before_spinlock();
>  	raw_spin_lock_irq(&rq->lock);
>  
> +	if (unlikely(rq->dead))
> +		goto deactivate;
> +

Yeah, it would be best to not have to do that; ideally we would be able
to maybe do both; set rq->dead and current->state == TASK_DEAD.

Hmm, your exit_schedule() already does this, so why this extra test?

>  	switch_count = &prev->nivcsw;
>  	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
>  		if (unlikely(signal_pending_state(prev->state, prev))) {
>  			prev->state = TASK_RUNNING;
>  		} else {
> +deactivate:
>  			deactivate_task(rq, prev, DEQUEUE_SLEEP);
>  			prev->on_rq = 0;
>  
> @@ -2826,6 +2830,15 @@ need_resched:
>  		goto need_resched;
>  }
>  
> +// called under preempt_disable();
> +void exit_schedule()
> +{
> +	// TODO: kill TASK_DEAD, this is only for proc
> +	current->state = TASK_DEAD;

Ah, not so, its also to avoid that extra condition in schedule() :-)

> +	task_rq(current)->dead = current;
> +	__schedule();
> +}
> +
>  static inline void sched_submit_work(struct task_struct *tsk)
>  {
>  	if (!tsk->state || tsk_is_pi_blocked(tsk))
> --- x/kernel/exit.c
> +++ x/kernel/exit.c
> @@ -815,25 +815,8 @@ void do_exit(long code)
>  		__this_cpu_add(dirty_throttle_leaks, tsk->nr_dirtied);
>  	exit_rcu();
>  
> -	/*
> -	 * The setting of TASK_RUNNING by try_to_wake_up() may be delayed
> -	 * when the following two conditions become true.
> -	 *   - There is race condition of mmap_sem (It is acquired by
> -	 *     exit_mm()), and
> -	 *   - SMI occurs before setting TASK_RUNINNG.
> -	 *     (or hypervisor of virtual machine switches to other guest)
> -	 *  As a result, we may become TASK_RUNNING after becoming TASK_DEAD
> -	 *
> -	 * To avoid it, we have to wait for releasing tsk->pi_lock which
> -	 * is held by try_to_wake_up()
> -	 */
> -	smp_mb();
> -	raw_spin_unlock_wait(&tsk->pi_lock);
> -
> -	/* causes final put_task_struct in finish_task_switch(). */
> -	tsk->state = TASK_DEAD;
>  	tsk->flags |= PF_NOFREEZE;	/* tell freezer to ignore us */
> -	schedule();
> +	exit_schedule();
>  	BUG();
>  	/* Avoid "noreturn function does return".  */
>  	for (;;)

Yes, something like this might work fine..
