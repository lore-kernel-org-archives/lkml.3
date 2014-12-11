Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaLKMb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:31:28 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:49198 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaLKMb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:31:27 -0500
Date: Thu, 11 Dec 2014 13:31:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] tracing/sched: Check preempt_count() for current when
 reading task->state
Message-ID: <20141211123121.GB18538@gmail.com>
References: <20141210174428.3cb7542a@gandalf.local.home>
 <20141211063811.GD5059@gmail.com>
 <20141211063712.5cf4d240@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141211063712.5cf4d240@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 11 Dec 2014 07:38:11 +0100
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > > Cc: stable@vger.kernel.org # 3.13+
> > > Fixes: 01028747559a "sched: Create more preempt_count accessors"
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > ---
> > >  include/trace/events/sched.h | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> > > index 0a68d5ae584e..13fbadcc172b 100644
> > > --- a/include/trace/events/sched.h
> > > +++ b/include/trace/events/sched.h
> > > @@ -97,10 +97,14 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
> > >  	long state = p->state;
> > >  
> > >  #ifdef CONFIG_PREEMPT
> > > +	unsigned long pc;
> > > +
> > > +	pc = (p == current) ? preempt_count() : task_preempt_count(p);
> > > +
> > >  	/*
> > >  	 * For all intents and purposes a preempted task is a running task.
> > >  	 */
> > > -	if (task_preempt_count(p) & PREEMPT_ACTIVE)
> > > +	if (pc & PREEMPT_ACTIVE)
> > >  		state = TASK_RUNNING | TASK_STATE_MAX;
> > 
> > I really don't like the overhead around here.
> 
> Hi Ingo!
> 
> What overhead are you worried about? Note, this is in the 
> schedule tracepoint and does not affect the scheduler itself 
> (as long as the tracepoint is not enabled).

Scheduler tracepoints are pretty popular, so I'm worried about 
their complexity when they are activated.

> I'm also thinking that as long as "prev" is always guaranteed 
> to be "current" we can remove the check and just use 
> preempt_count() always. But I'm worried that we can't 
> guaranteed that.

You could add a WARN_ON_ONCE() or so to double check that 
assumption?

> What other ideas do you have? Because wrong data is worse than 
> the overhead of the above code. If Thomas taught me anything, 
> it's that!

My idea is to have simpler, yet correct code. And ponies!

Thanks,

	Ingo
