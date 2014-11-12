Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaKLLQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:16:09 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:46122 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaKLLQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:16:06 -0500
Date: Wed, 12 Nov 2014 12:15:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched/cputime: fix clock_nanosleep/clock_gettime
 inconsistency
Message-ID: <20141112111553.GA21343@twins.programming.kicks-ass.net>
References: <1415788168-3165-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415788168-3165-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 11:29:28AM +0100, Stanislaw Gruszka wrote:
> Commit d670ec13178d "posix-cpu-timers: Cure SMP wobbles" fixes one glibc
> test case in cost of breaking another one. After that commit, calling
> clock_nanosleep(TIMER_ABSTIME, X) and then clock_gettime(&Y) can result
> of Y time being smaller than X time.

<snip>

> Issue happens because on start in thread_group_cputimer() we initialize
> sum_exec_runtime of cputimer with threads runtime not yet accounted and
> then add the threads runtime again on scheduler tick. When cputimer
> finish, it's sum_exec_runtime value is bigger than current sum counted
> by iterating over the threads in thread_group_cputime().
> 
> KOSAKI Motohiro posted fix for this problem, but that patch was never
> applied: https://lkml.org/lkml/2013/5/26/191.
> 
> This patch takes different approach. It revert change from d670ec13178d,
> but to assure process times are in sync with thread times, before
> accounting the times it calls update_curr() to update current thread
> sum_exec_runtime. This fixes the test case from commit d670ec13178d and
> also make things like they were before i.e. process cpu times can be
> (nr_threads - 1) * TICK_NSEC behind the clock (this is a drawback
> unfortunately). 

> Good news is that patch improve performance of
> thread_group_cputime(), i.e. we do not need optimizations from commit
> 911b289 "sched: Optimize task_sched_runtime()"

You're inconsistent with your SHA1 lengths, use 12 chars.

So I'm not seeing how you've not reintroduced the issue from
d670ec13178d, afaict you simply do not take the delta of all the other
threads into account, which is why you're not taking as many locks.

Which also re-introduces the 32bit data race mentioned in that
changelog.

> Note I'm not familiar with scheduler subsystem, hence I'm not sure if
> calling update_curr() will not affect scheduler functionality somehow.

Well, it will, it has to. But we call it at any odd point anyhow so
there's really nothing too weird about that.

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 240157c..117c852 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2475,75 +2475,20 @@ EXPORT_PER_CPU_SYMBOL(kstat);
>  EXPORT_PER_CPU_SYMBOL(kernel_cpustat);
>  
>  /*
> + * If the task is currently running, update the statistics. Main purpose
> + * of this function is assure that the accounted runtime is updated.
>   */
> +void scheduler_update_curr(struct task_struct *p)
>  {
>  	unsigned long flags;
>  	struct rq *rq;
>  
>  	rq = task_rq_lock(p, &flags);
> +	if (task_current(rq, p) && task_on_rq_queued(p)) {
> +		update_rq_clock(rq);
> +		p->sched_class->update_curr(rq);
> +	}
>  	task_rq_unlock(rq, p, &flags);
>  }

Right so that name stinks, it updates 'p' not curr, and it really should
have that optimization in, there is no point in taking that lock if p
isn't actually on a cpu atm.

> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index 8394b1e..afcf114 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -305,7 +305,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
>  			task_cputime(t, &utime, &stime);
>  			times->utime += utime;
>  			times->stime += stime;
> +			times->sum_exec_runtime += t->se.sum_exec_runtime;
>  		}
>  		/* If lockless access failed, take the lock. */
>  		nextseq = 1;

This re-introduces the 32bit fail.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 34baa60..99995e0 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -726,6 +726,11 @@ static void update_curr(struct cfs_rq *cfs_rq)
>  	account_cfs_rq_runtime(cfs_rq, delta_exec);
>  }
>  
> +static void update_curr_rq(struct rq *rq)
> +{
> +	update_curr(&rq->cfs);
> +}
> +
>  static inline void
>  update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  {
> @@ -7949,6 +7954,8 @@ const struct sched_class fair_sched_class = {
>  
>  	.get_rr_interval	= get_rr_interval_fair,
>  
> +	.update_curr		= update_curr_rq,
> +
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  	.task_move_group	= task_move_group_fair,
>  #endif

For consistency sake:

  s/update_curr_rq/update_curr_fair/g


> diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
> index 492b986..c2a5401 100644
> --- a/kernel/time/posix-cpu-timers.c
> +++ b/kernel/time/posix-cpu-timers.c
> @@ -190,7 +190,8 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
>  		*sample = virt_ticks(p);
>  		break;
>  	case CPUCLOCK_SCHED:
> -		*sample = task_sched_runtime(p);
> +		scheduler_update_curr(p);
> +		*sample = p->se.sum_exec_runtime;
>  		break;
>  	}
>  	return 0;

Same 32bit fail

> @@ -221,6 +222,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
>  		 * to synchronize the timer to the clock every time we start
>  		 * it.
>  		 */
> +		scheduler_update_curr(tsk);
>  		thread_group_cputime(tsk, &sum);
>  		raw_spin_lock_irqsave(&cputimer->lock, flags);
>  		cputimer->running = 1;

So here you only update the current thread, not the entire thread group.
But you've failed to explain how that does not re-introduce problems.

> @@ -254,6 +256,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
>  		*sample = cputime_to_expires(cputime.utime);
>  		break;
>  	case CPUCLOCK_SCHED:
> +		scheduler_update_curr(p);
>  		thread_group_cputime(p, &cputime);
>  		*sample = cputime.sum_exec_runtime;
>  		break;

Why only these two thread_group_cputime() calls and not all others?
