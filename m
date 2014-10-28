Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaJ0XLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:11:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbaJ0XLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:11:12 -0400
Date: Tue, 28 Oct 2014 01:07:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, mingo@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, rafael.j.wysocki@intel.com
Subject: Re: [PATCH 00/11] nested sleeps, fixes and debug infrastructure
Message-ID: <20141028000703.GA22964@redhat.com>
References: <20140924081845.572814794@infradead.org> <1411633803.15810.12.camel@marge.simpson.net> <20140925090619.GA5430@worktop> <20140925091556.GB5430@worktop> <20141002102251.GA6324@worktop.programming.kicks-ass.net> <20141002121553.GB6324@worktop.programming.kicks-ass.net> <20141027134103.GA10476@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027134103.GA10476@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27, Peter Zijlstra wrote:
>
> On Thu, Oct 02, 2014 at 02:15:53PM +0200, Peter Zijlstra wrote:
> > On Thu, Oct 02, 2014 at 12:22:51PM +0200, Peter Zijlstra wrote:
>
> > > +#define __wait_event_freezable(wq, condition)				\
> > > +	(void)___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,	\
> > > +			    schedule(); try_to_freeze())
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

see below.

> > > +
> > > +/**
> > > + * wait_event - sleep until a condition gets true or freeze (for kthreads)
> > > + * @wq: the waitqueue to wait on
> > > + * @condition: a C expression for the event to wait for
> > > + *
> > > + * The process is put to sleep (TASK_INTERRUPTIBLE -- so as not to contribute
> > > + * to system load) until the @condition evaluates to true. The
> > > + * @condition is checked each time the waitqueue @wq is woken up.
> > > + *
> > > + * wake_up() has to be called after changing any variable that could
> > > + * change the result of the wait condition.
> > > + */
> > > +#define wait_event_freezable(wq, condition)				\
> > > +do {									\
> > > +	WARN_ON_ONCE(!(current->flags & PF_KTHREAD));			\
> > > +	might_sleep();							\
> > > +	if (condition)							\
> > > +		break;							\
> > > +	__wait_event_freezable(wq, condition);				\
> > > +} while (0)
> > > +
> > >  #define __wait_event_timeout(wq, condition, timeout)			\
> > >  	___wait_event(wq, ___wait_cond_timeout(condition),		\
> > >  		      TASK_UNINTERRUPTIBLE, 0, timeout,			\
> >
> > Bah, that doesn't compile, because there already appears to be one,
> > hidden in freezer.h. Now I can't actually tell if it does the same thing
> > or not.
> >
> > Rafael?
>
> Ping?

I was going to say that wait_event_freezable() in kauditd_thread()
is not friendly wrt kthread_should_stop() and thus we we need
kthread_freezable_should_stop().

But in fact we never stop this kauditd_task, so I think we should
turn the main loop into "for (;;)" and change this code to use
wait_event_freezable() like your patch does.

Perhaps it also makes sense to redefine wait_event_freezable.*()
via ___wait_event(cmd => freezable_schedule), but I think this needs
another patch.

Oleg.

