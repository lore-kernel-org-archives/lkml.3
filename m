Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3FDM30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:29:26 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:35835 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3FDM3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:29:24 -0400
Date: Tue, 4 Jun 2013 14:29:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2][RFC] tracing/context-tracking: Add
 preempt_schedule_context() for tracing
Message-ID: <20130604122919.GF14973@somewhere>
References: <1369943981.26799.43.camel@gandalf.local.home>
 <20130531134319.GE5932@somewhere>
 <1370013528.26799.49.camel@gandalf.local.home>
 <20130531160101.GB5910@twins.programming.kicks-ass.net>
 <1370050218.26799.87.camel@gandalf.local.home>
 <20130604120949.GD14973@somewhere>
 <1370348189.26799.117.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370348189.26799.117.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 08:16:29AM -0400, Steven Rostedt wrote:
> On Tue, 2013-06-04 at 14:09 +0200, Frederic Weisbecker wrote:
> >  
> > > +/**
> > > + * preempt_schedule_context - preempt_schedule called by tracing
> > > + *
> > > + * The tracing infrastructure uses preempt_enable_notrace to prevent
> > > + * recursion and tracing preempt enabling caused by the tracing
> > > + * infrastructure itself. But as tracing can happen in areas coming
> > > + * from userspace or just about to enter userspace, a preempt enable
> > > + * can occur before user_exit() is called. This will cause the scheduler
> > > + * to be called when the system is still in usermode.
> > > + *
> > > + * To prevent this, the preempt_enable_notrace will use this function
> > > + * instead of preempt_schedule() to exit user context if needed before
> > > + * calling the scheduler.
> > > + */
> > > +void __sched notrace preempt_schedule_context(void)
> > > +{
> > > +	struct thread_info *ti = current_thread_info();
> > > +	enum ctx_state prev_ctx;
> > > +
> > > +	if (likely(ti->preempt_count || irqs_disabled()))
> > > +		return;
> > 
> > or:
> >         if (!preemptible())
> >                 return;
> 
> Sure, but this is a cut and paste from preempt_schedule(). If I make
> that change here, I would want to make that there too.
> 
> Peter, should I use !preemptible() or keep it like preempt_schedule()
> and make a clean up change for 3.11?

That seem to indeed make sense to use it in preempt_schedule() as well.
