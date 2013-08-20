Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab3HTRyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:54:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36980 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3HTRyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:54:40 -0400
Date: Tue, 20 Aug 2013 19:54:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130820175429.GI3258@twins.programming.kicks-ass.net>
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
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 06:33:12PM +0200, Oleg Nesterov wrote:
> On 08/20, Peter Zijlstra wrote:

> I am wondering how the extra lock(rq)/unlock(rq) in schedule() is bad
> compared to atomic_dec.
> 
> IOW, what if we simply make rq->nr_iowait "int" and change schedule()
> to update it? Something like below. Just curious.
> 
> As for nr_iowait_local + nr_iowait_remote, this doesn't look safe...
> in theory nr_iowait_cpu() or even nr_iowait() can return a negative
> number.

I'm too tired to see how its different, I'll think on it :-)


That said:

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

This seems like the wrong place, this is where you return from
schedule() running another task, not where the task you just send to
sleep wakes up.

If you want to to this, the nr_iowait decrement needs to be in the
wakeup path someplace.

>  		cpu = smp_processor_id();
>  		rq = cpu_rq(cpu);
>  	} else
