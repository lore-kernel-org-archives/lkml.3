Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3EaP4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:56:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58459 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3EaP4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:56:47 -0400
Date: Fri, 31 May 2013 17:56:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH][RFC] tracing/context-tracking: Add
 preempt_schedule_context() for tracing
Message-ID: <20130531155643.GL5932@somewhere>
References: <1369943981.26799.43.camel@gandalf.local.home>
 <20130531134319.GE5932@somewhere>
 <1370013528.26799.49.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370013528.26799.49.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 11:18:48AM -0400, Steven Rostedt wrote:
> On Fri, 2013-05-31 at 15:43 +0200, Frederic Weisbecker wrote:
> 
> > > +void __sched notrace preempt_schedule_context(void)
> > > +{
> > > +	struct thread_info *ti = current_thread_info();
> > > +	enum ctx_state prev_ctx;
> > > +
> > > +	if (likely(ti->preempt_count || irqs_disabled()))
> > > +		return;
> > > +
> > > +	/*
> > > +	 * Need to disable preemption in case user_exit() is traced
> > > +	 * and the tracer calls preempt_enable_notrace() causing
> > > +	 * an infinite recursion.
> > > +	 */
> > > +	preempt_disable_notrace();
> > > +	prev_ctx = this_cpu_read(context_tracking.state);
> > > +	user_exit();
> > 
> > You can reuse exception_enter()
> 
> I originally did use that, but then noticed that everything else in
> context_tracking.c used context_tracking.state directly. I have no
> problems doing it this way again.

It's more about the fact that exception_*() APIs already implement
part of what you're doing. And yeah as a bonus it's also better to keep
context_tracking internals in context_tracking.c

> 
> > 
> > > +	preempt_enable_no_resched_notrace();
> > > +
> > > +	preempt_schedule();
> > > +
> > > +	preempt_disable_notrace();
> > > +	if (prev_ctx == IN_USER)
> > > +		user_enter();
> > 
> > And then exception_exit() here.
> > 
> > I guess this replaces your fix with schedule_preempt_user(). I liked
> > it because it seems that:
> > 
> >    if (need_resched()) {
> >       user_exit();
> >       local_irq_enable();
> >       schedule();
> >       local_irq_enable();
> >       user_enter();
> >    }
> > 
> > is a common pattern of arch user resume preemption that we can consolidate.
> > 
> > But your new patch probably makes it more widely safe for the function tracer
> > for any function that can be called and traced in IN_USER mode. Not only user preemption.
> > Think about do_notify_resume() for example if it is called after syscall_trace_leave().
> > 
> > Independantly, schedule_preempt_user() is still interesting for consolidation.
> 
> And I think that patch is still valid from just a clean up point of
> view. It just didn't cover all the cases needed for tracing.

Right.

Thanks.
