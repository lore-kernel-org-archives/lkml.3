Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaJBVY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:24:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbaJBVY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:24:28 -0400
Date: Thu, 2 Oct 2014 23:21:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] wait: Provide infrastructure to deal with nested
	blocking
Message-ID: <20141002212108.GA12446@redhat.com>
References: <20140924081845.572814794@infradead.org> <20140924082242.051202318@infradead.org> <20140929210221.GA12112@redhat.com> <20141002073739.GF2843@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002073739.GF2843@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02, Peter Zijlstra wrote:
>
> On Mon, Sep 29, 2014 at 11:02:21PM +0200, Oleg Nesterov wrote:
> > On 09/24, Peter Zijlstra wrote:
> > >
> > > +int woken_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
> > > +{
> > > +	/*
> > > +	 * Although this function is called under waitqueue lock, LOCK
> > > +	 * doesn't imply write barrier and the users expects write
> > > +	 * barrier semantics on wakeup functions.  The following
> > > +	 * smp_wmb() is equivalent to smp_wmb() in try_to_wake_up()
> > > +	 * and is paired with set_mb() in wait_woken().
> > > +	 */
> > > +	smp_wmb(); /* C */
> > > +	wait->flags |= WQ_FLAG_WOKEN;
> >
> > Perhaps it is just me, but I was a bit confused by the comment above wmb().
> > Afaics, it is not that "users expects write barrier semantics", just we
> > need to ensure that
> >
> > 	CONDITION = true;
> > 	wait->flags |= WQ_FLAG_WOKEN;
> >
> > can't be reordered (and this differs from smp_wmb() in try_to_wake_up()).
> > Otherwise we can obviously race with
> >
> > 	// wait_woken() -> set_mb()
> > 	wait->flags &= ~WQ_FLAG_WOKEN;
> > 	mb();
> >
> > 	if (CONDITION)
> > 		break;
> >
>
> Yes, that comment could be clearer. It is however, to me, the 'same' as
> a regular wakeup in that we need to separate whatever state changes
> before the wakeup (CONDITION=true typically) from whatever writes are
> required to affect the wakeup (->state=TASK_RUNNING typically,

Not really, ttwu() needs to serialize CONDITION=true and the reading of
task->state. And for the waiter its state is write only, it doesn't need
to check it.

While in this case we need to separate CONDITION and WQ_FLAG_WOKEN, and
the waiter needs to check them in the right order.

But please forget, the code looks clear with or without the comment, and
"paired with set_mb() in wait_woken()" should explain the intent anyway.

Oleg.

