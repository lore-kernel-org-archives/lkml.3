Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab3HUL4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 07:56:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab3HUL4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 07:56:05 -0400
Date: Wed, 21 Aug 2013 13:49:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130821114944.GB2220@redhat.com>
References: <20130816162056.GE24210@somewhere> <20130816162654.GA453@redhat.com> <20130816164626.GH24210@somewhere> <20130819111026.GE24092@twins.programming.kicks-ass.net> <521313D8.9080500@lab.ntt.co.jp> <20130820084405.GC3258@twins.programming.kicks-ass.net> <52138BE9.5090005@linux.intel.com> <20130820160146.GG3258@twins.programming.kicks-ass.net> <20130820163312.GA17957@redhat.com> <20130820221811.GB2412@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820221811.GB2412@somewhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Frederic Weisbecker wrote:
>
> On Tue, Aug 20, 2013 at 06:33:12PM +0200, Oleg Nesterov wrote:
> >
> > --- x/kernel/sched/core.c
> > +++ x/kernel/sched/core.c
> > @@ -2435,6 +2435,9 @@ need_resched:
> >  		rq->curr = next;
> >  		++*switch_count;
> >
> > +		if (unlikely(prev->in_iowait))
> > +			rq->nr_iowait++;
> > +
> >  		context_switch(rq, prev, next); /* unlocks the rq */
> >  		/*
> >  		 * The context switch have flipped the stack from under us
> > @@ -2442,6 +2445,12 @@ need_resched:
> >  		 * this task called schedule() in the past. prev == current
> >  		 * is still correct, but it can be moved to another cpu/rq.
> >  		 */
> > +		if (unlikely(prev->in_iowait)) {
> > +			raw_spin_lock_irq(&rq->lock);
> > +			rq->nr_iowait--;
> > +			raw_spin_unlock_irq(&rq->lock);
> > +		}
> > +
>
> It seems that with this solution rq->nr_iowait is only ever modified locally.
> Can't we just disable irqs for rq->nr_iowait-- ?

Not really. rq holds the old value, which was used when this task
called context_switch() in the past.

IOW, if a task T does io_schedule() on CPU_0, then cpu_of(rq) is still 0
after context_switch(), even if T runs on another cpu.

> Also if this is only updated locally,

Unfortunately, I don't see how we can do this.

Oleg.

