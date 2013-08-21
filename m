Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab3HULmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 07:42:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab3HULma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 07:42:30 -0400
Date: Wed, 21 Aug 2013 13:35:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130821113551.GA1472@redhat.com>
References: <20130816164626.GH24210@somewhere> <20130819111026.GE24092@twins.programming.kicks-ass.net> <521313D8.9080500@lab.ntt.co.jp> <20130820084405.GC3258@twins.programming.kicks-ass.net> <52138BE9.5090005@linux.intel.com> <20130820160146.GG3258@twins.programming.kicks-ass.net> <20130820163312.GA17957@redhat.com> <20130820175429.GI3258@twins.programming.kicks-ass.net> <20130820182553.GB22287@redhat.com> <20130821083130.GM3258@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821083130.GM3258@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Peter Zijlstra wrote:
>
> On Tue, Aug 20, 2013 at 08:25:53PM +0200, Oleg Nesterov wrote:
> > On 08/20, Peter Zijlstra wrote:
> > >
> > > On Tue, Aug 20, 2013 at 06:33:12PM +0200, Oleg Nesterov wrote:
>
> > > > +		if (unlikely(prev->in_iowait)) {
> > > > +			raw_spin_lock_irq(&rq->lock);
> > > > +			rq->nr_iowait--;
> > > > +			raw_spin_unlock_irq(&rq->lock);
> > > > +		}
> > >
> > > This seems like the wrong place, this is where you return from
> > > schedule() running another task,
> >
> > Yes, but prev is current, and rq should be "correct" for
> > rq->nr_iowait-- ?
>
> Yes its the right rq, but the wrong time.

Hmm. Just in case, it is not that I think this patch really makes sense,
but I'd like to understand why do you think it is wrong.

> > This local var should be equal to its value when this task called
> > context_switch() in the past.
> >
> > Like any other variable, like "rq = raw_rq()" in io_schedule().
> >
> > > not where the task you just send to
> > > sleep wakes up.
> >
> > sure, but currently io_schedule() does the same.
>
> No it doesn't. It only does the decrement when the task is woken back
> up. Not right after it switches out.

But it is not "after it switches out", it is after it switched back.

Lets ignore the locking,

	if (prev->in_iowait)
		rq->nr_iowait++;

	context_switch(prev, next);

	if (prev->in_iowait)
		rq->nr_iowait--;

>From the task_struct's (current's) pov prev/rq are the same, before or
after context_switch().

But from the CPU's pov they differ. And ignoring more details on UP the
code above is equivalent to

	if (prev->in_iowait)
		rq->nr_iowait++;

	if (next->in_iowait)
		rq->nr_iowait--;

	context_switch(prev, next);

No?

Yes, need_resched()/preemption can trigger more inc/dec's than io_schedule()
does, but I don't think this was your concern.

> > Btw. Whatever we do, can't we unify io_schedule/io_schedule_timeout?
>
> I suppose we could, a timeout of MAX_SCHEDULE_TIMEOUT will act like a
> regular schedule, but it gets all the overhead of doing
> schedule_timeout(). So I don't think its a win.

Well, the only overhead is "if(to == MAX_SCHEDULE_TIMEOUT)" at the start.
I don't think it makes sense to copy-and-paste the identical code to
avoid it. But please ignore, this is really minor and off-topic.

Oleg.

