Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab3HTWSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 18:18:24 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:40454 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab3HTWSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 18:18:22 -0400
Date: Wed, 21 Aug 2013 00:18:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130820221811.GB2412@somewhere>
References: <20130816160201.GA31682@redhat.com>
 <20130816162056.GE24210@somewhere>
 <20130816162654.GA453@redhat.com>
 <20130816164626.GH24210@somewhere>
 <20130819111026.GE24092@twins.programming.kicks-ass.net>
 <521313D8.9080500@lab.ntt.co.jp>
 <20130820084405.GC3258@twins.programming.kicks-ass.net>
 <52138BE9.5090005@linux.intel.com>
 <20130820160146.GG3258@twins.programming.kicks-ass.net>
 <20130820163312.GA17957@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820163312.GA17957@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 06:33:12PM +0200, Oleg Nesterov wrote:
> On 08/20, Peter Zijlstra wrote:
> >
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -453,7 +453,8 @@ struct rq {
> >  	u64 clock;
> >  	u64 clock_task;
> >  
> > -	atomic_t nr_iowait;
> > +	int nr_iowait_local;
> > +	atomic_t nr_iowait_remote;
> 
> I am wondering how the extra lock(rq)/unlock(rq) in schedule() is bad
> compared to atomic_dec.
> 
> IOW, what if we simply make rq->nr_iowait "int" and change schedule()
> to update it? Something like below. Just curious.
> 
> As for nr_iowait_local + nr_iowait_remote, this doesn't look safe...
> in theory nr_iowait_cpu() or even nr_iowait() can return a negative
> number.
> 
> Oleg.
> 
> 
> --- x/kernel/sched/core.c
> +++ x/kernel/sched/core.c
> @@ -2435,6 +2435,9 @@ need_resched:
>  		rq->curr = next;
>  		++*switch_count;
>  
> +		if (unlikely(prev->in_iowait))
> +			rq->nr_iowait++;
> +
>  		context_switch(rq, prev, next); /* unlocks the rq */
>  		/*
>  		 * The context switch have flipped the stack from under us
> @@ -2442,6 +2445,12 @@ need_resched:
>  		 * this task called schedule() in the past. prev == current
>  		 * is still correct, but it can be moved to another cpu/rq.
>  		 */
> +		if (unlikely(prev->in_iowait)) {
> +			raw_spin_lock_irq(&rq->lock);
> +			rq->nr_iowait--;
> +			raw_spin_unlock_irq(&rq->lock);
> +		}
> +

It seems that with this solution rq->nr_iowait is only ever modified locally.
Can't we just disable irqs for rq->nr_iowait-- ?

Also if this is only updated locally, no need for a lock to update ts->iowait_sleep_time anymore,
we can flush the io sleeptime in place. Great thing.

Now just in case, it might be worth noting as well that the time elapsing from the rq task enqueue
until it is finally running on the CPU is not accounted anymore there. This can make a little difference
if the task is woken up but a higher priority task, possibly SCHED_FIFO is already running on the CPU.
Now do we care...

Thanks.

 
>  		cpu = smp_processor_id();
>  		rq = cpu_rq(cpu);
>  	} else
> @@ -3939,31 +3948,24 @@ EXPORT_SYMBOL_GPL(yield_to);
>   */
>  void __sched io_schedule(void)
>  {
> -	struct rq *rq = raw_rq();
> -
>  	delayacct_blkio_start();
> -	atomic_inc(&rq->nr_iowait);
>  	blk_flush_plug(current);
>  	current->in_iowait = 1;
>  	schedule();
>  	current->in_iowait = 0;
> -	atomic_dec(&rq->nr_iowait);
>  	delayacct_blkio_end();
>  }
>  EXPORT_SYMBOL(io_schedule);
>  
>  long __sched io_schedule_timeout(long timeout)
>  {
> -	struct rq *rq = raw_rq();
>  	long ret;
>  
>  	delayacct_blkio_start();
> -	atomic_inc(&rq->nr_iowait);
>  	blk_flush_plug(current);
>  	current->in_iowait = 1;
>  	ret = schedule_timeout(timeout);
>  	current->in_iowait = 0;
> -	atomic_dec(&rq->nr_iowait);
>  	delayacct_blkio_end();
>  	return ret;
>  }
> 
