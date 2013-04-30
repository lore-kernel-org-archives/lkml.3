Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675Ab3D3Nh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 09:37:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16022 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760612Ab3D3NhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 09:37:24 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=5eKZcm_OZmQA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=jz4g3xt9QgwA:10 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=ToziKIXQIKC-ZMH8_cYA:9 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=Zh68SRI7RUMA:10 a=vxagMScsGYuRhU7v:21 a=ipNlL67vzzBydeoD:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Tue, 30 Apr 2013 09:37:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] sched: Distangle worker accounting from rq->lock
Message-ID: <20130430133722.GA477@home.goodmis.org>
References: <20110622174659.496793734@linutronix.de>
 <20110622174919.135236139@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622174919.135236139@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Blast from the past! ]

When merging in 3.4.42 into the 3.4-rt branch I hit a conflict with the
try_to_wake_up_local() call. It seems that the 3.4-rt patch has this
patch applied. Although, this is not applied to any of the other -rt patches.

My question is, what was the final verdict of this patch? The thread
sorta died without a definite answer.

Is this a change we want to add upstream? If not, is this a change I
should remove from the 3.4-rt branch?

Note, -rt did hit a bug with the try_to_wake_up_local() code, so
removing it is a welcome idea. We are still trying to reproduce that
bug.

Thanks,

-- Steve

On Wed, Jun 22, 2011 at 05:52:15PM -0000, Thomas Gleixner wrote:
> The worker accounting for cpu bound workers is plugged into the core
> scheduler code and the wakeup code. This is not a hard requirement and
> can be avoided by keeping track of the state in the workqueue code
> itself.
> 
> Keep track of the sleeping state in the worker itself and call the
> notifier before entering the core scheduler. There might be false
> positives when the task is woken between that call and actually
> scheduling, but that's not really different from scheduling and being
> woken immediately after switching away. There is also no harm from
> updating nr_running when the task returns from scheduling instead of
> accounting it in the wakeup code.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/sched.c           |   66 ++++++++++------------------------------------
>  kernel/workqueue.c       |   67 ++++++++++++++++++++---------------------------
>  kernel/workqueue_sched.h |    5 +--
>  3 files changed, 46 insertions(+), 92 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2477,10 +2477,6 @@ static void ttwu_activate(struct rq *rq,
>  {
>  	activate_task(rq, p, en_flags);
>  	p->on_rq = 1;
> -
> -	/* if a worker is waking up, notify workqueue */
> -	if (p->flags & PF_WQ_WORKER)
> -		wq_worker_waking_up(p, cpu_of(rq));
>  }
>  
>  /*
> @@ -2703,40 +2699,6 @@ out:
>  }
>  
>  /**
> - * try_to_wake_up_local - try to wake up a local task with rq lock held
> - * @p: the thread to be awakened
> - *
> - * Put @p on the run-queue if it's not already there. The caller must
> - * ensure that this_rq() is locked, @p is bound to this_rq() and not
> - * the current task.
> - */
> -static void try_to_wake_up_local(struct task_struct *p)
> -{
> -	struct rq *rq = task_rq(p);
> -
> -	BUG_ON(rq != this_rq());
> -	BUG_ON(p == current);
> -	lockdep_assert_held(&rq->lock);
> -
> -	if (!raw_spin_trylock(&p->pi_lock)) {
> -		raw_spin_unlock(&rq->lock);
> -		raw_spin_lock(&p->pi_lock);
> -		raw_spin_lock(&rq->lock);
> -	}
> -
> -	if (!(p->state & TASK_NORMAL))
> -		goto out;
> -
> -	if (!p->on_rq)
> -		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
> -
> -	ttwu_do_wakeup(rq, p, 0);
> -	ttwu_stat(p, smp_processor_id(), 0);
> -out:
> -	raw_spin_unlock(&p->pi_lock);
> -}
> -
> -/**
>   * wake_up_process - Wake up a specific process
>   * @p: The process to be woken up.
>   *
> @@ -4240,19 +4202,6 @@ need_resched:
>  		} else {
>  			deactivate_task(rq, prev, DEQUEUE_SLEEP);
>  			prev->on_rq = 0;
> -
> -			/*
> -			 * If a worker went to sleep, notify and ask workqueue
> -			 * whether it wants to wake up a task to maintain
> -			 * concurrency.
> -			 */
> -			if (prev->flags & PF_WQ_WORKER) {
> -				struct task_struct *to_wakeup;
> -
> -				to_wakeup = wq_worker_sleeping(prev, cpu);
> -				if (to_wakeup)
> -					try_to_wake_up_local(to_wakeup);
> -			}
>  		}
>  		switch_count = &prev->nvcsw;
>  	}
> @@ -4295,6 +4244,14 @@ static inline void sched_submit_work(str
>  {
>  	if (!tsk->state)
>  		return;
> +
> +	/*
> +	 * If a worker went to sleep, notify and ask workqueue whether
> +	 * it wants to wake up a task to maintain concurrency.
> +	 */
> +	if (tsk->flags & PF_WQ_WORKER)
> +		wq_worker_sleeping(tsk);
> +
>  	/*
>  	 * If we are going to sleep and we have plugged IO queued,
>  	 * make sure to submit it to avoid deadlocks.
> @@ -4303,12 +4260,19 @@ static inline void sched_submit_work(str
>  		blk_schedule_flush_plug(tsk);
>  }
>  
> +static inline void sched_update_worker(struct task_struct *tsk)
> +{
> +	if (tsk->flags & PF_WQ_WORKER)
> +		wq_worker_running(tsk);
> +}
> +
>  asmlinkage void schedule(void)
>  {
>  	struct task_struct *tsk = current;
>  
>  	sched_submit_work(tsk);
>  	__schedule();
> +	sched_update_worker(tsk);
>  }
>  EXPORT_SYMBOL(schedule);
>  
> Index: linux-2.6/kernel/workqueue.c
> ===================================================================
> --- linux-2.6.orig/kernel/workqueue.c
> +++ linux-2.6/kernel/workqueue.c
> @@ -137,6 +137,7 @@ struct worker {
>  	unsigned int		flags;		/* X: flags */
>  	int			id;		/* I: worker id */
>  	struct work_struct	rebind_work;	/* L: rebind worker to cpu */
> +	int			sleeping;	/* None */
>  };
>  
>  /*
> @@ -657,66 +658,56 @@ static void wake_up_worker(struct global
>  }
>  
>  /**
> - * wq_worker_waking_up - a worker is waking up
> - * @task: task waking up
> - * @cpu: CPU @task is waking up to
> + * wq_worker_running - a worker is running again
> + * @task: task returning from sleep
>   *
> - * This function is called during try_to_wake_up() when a worker is
> - * being awoken.
> - *
> - * CONTEXT:
> - * spin_lock_irq(rq->lock)
> + * This function is called when a worker returns from schedule()
>   */
> -void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
> +void wq_worker_running(struct task_struct *task)
>  {
>  	struct worker *worker = kthread_data(task);
>  
> +	if (!worker->sleeping)
> +		return;
>  	if (!(worker->flags & WORKER_NOT_RUNNING))
> -		atomic_inc(get_gcwq_nr_running(cpu));
> +		atomic_inc(get_gcwq_nr_running(smp_processor_id()));
> +	worker->sleeping = 0;
>  }
>  
>  /**
>   * wq_worker_sleeping - a worker is going to sleep
>   * @task: task going to sleep
> - * @cpu: CPU in question, must be the current CPU number
> - *
> - * This function is called during schedule() when a busy worker is
> - * going to sleep.  Worker on the same cpu can be woken up by
> - * returning pointer to its task.
> - *
> - * CONTEXT:
> - * spin_lock_irq(rq->lock)
>   *
> - * RETURNS:
> - * Worker task on @cpu to wake up, %NULL if none.
> + * This function is called from schedule() when a busy worker is
> + * going to sleep.
>   */
> -struct task_struct *wq_worker_sleeping(struct task_struct *task,
> -				       unsigned int cpu)
> +void wq_worker_sleeping(struct task_struct *task)
>  {
> -	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
> -	struct global_cwq *gcwq = get_gcwq(cpu);
> -	atomic_t *nr_running = get_gcwq_nr_running(cpu);
> +	struct worker *worker = kthread_data(task);
> +	struct global_cwq *gcwq;
> +	int cpu;
>  
>  	if (worker->flags & WORKER_NOT_RUNNING)
> -		return NULL;
> +		return;
>  
> -	/* this can only happen on the local cpu */
> -	BUG_ON(cpu != raw_smp_processor_id());
> +	if (WARN_ON_ONCE(worker->sleeping))
> +		return;
>  
> +	cpu = smp_processor_id();
> +	gcwq = get_gcwq(cpu);
> +	spin_lock_irq(&gcwq->lock);
>  	/*
>  	 * The counterpart of the following dec_and_test, implied mb,
>  	 * worklist not empty test sequence is in insert_work().
>  	 * Please read comment there.
> -	 *
> -	 * NOT_RUNNING is clear.  This means that trustee is not in
> -	 * charge and we're running on the local cpu w/ rq lock held
> -	 * and preemption disabled, which in turn means that none else
> -	 * could be manipulating idle_list, so dereferencing idle_list
> -	 * without gcwq lock is safe.
> -	 */
> -	if (atomic_dec_and_test(nr_running) && !list_empty(&gcwq->worklist))
> -		to_wakeup = first_worker(gcwq);
> -	return to_wakeup ? to_wakeup->task : NULL;
> +	 */
> +	if (atomic_dec_and_test(get_gcwq_nr_running(cpu)) &&
> +	    !list_empty(&gcwq->worklist)) {
> +		worker = first_worker(gcwq);
> +		if (worker)
> +			wake_up_process(worker->task);
> +	}
> +	spin_unlock_irq(&gcwq->lock);
>  }
>  
>  /**
> Index: linux-2.6/kernel/workqueue_sched.h
> ===================================================================
> --- linux-2.6.orig/kernel/workqueue_sched.h
> +++ linux-2.6/kernel/workqueue_sched.h
> @@ -4,6 +4,5 @@
>   * Scheduler hooks for concurrency managed workqueue.  Only to be
>   * included from sched.c and workqueue.c.
>   */
> -void wq_worker_waking_up(struct task_struct *task, unsigned int cpu);
> -struct task_struct *wq_worker_sleeping(struct task_struct *task,
> -				       unsigned int cpu);
> +void wq_worker_running(struct task_struct *task);
> +void wq_worker_sleeping(struct task_struct *task);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
