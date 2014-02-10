Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaBJRRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:17:19 -0500
Received: from hofr.at ([212.69.189.236]:45134 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbaBJRRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:17:15 -0500
Date: Mon, 10 Feb 2014 18:17:12 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: Re: allow preemption in check_task_state
Message-ID: <20140210171712.GA17517@opentech.at>
References: <20140210153856.GD20017@opentech.at> <20140210111106.67438d1e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210111106.67438d1e@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014, Steven Rostedt wrote:

> Subject is missing patch number.
> 
> 
> On Mon, 10 Feb 2014 16:38:56 +0100
> Nicholas Mc Guire <der.herr@hofr.at> wrote:
> 
> > 
> > A lockfree approach to check_task_state
> > 
> > This treates the state as an indicator variable and use it to probe 
> > saved_state lock free. There is actually no consistency demand on 
> > state/saved_state but rather a consistency demand on the transitions 
> > of the two variables but those transition, based on path inspection,
> > are not independent.
> > 
> > Its probably not faster than the lock/unlock case if uncontended - atleast
> > it does not show up in benchmark results, but it would never be hit by a 
> > full pi-boost cycle as there is no contention.
> > 
> > This also was tested against the test-case from Sebastian as well as 
> > rnning a few scripted gdb breakpoint debugging/single-stepping loops
> > to trigger this.
> 
> To trigger what?

sorry should have included that in the patch header
the testcase that Sebastian Andrzej Siewior had - available at:
  http://breakpoint.cc/ptrace-test.c
the test-case triggers missing the state update.

> 
> > 
> > Tested-by: Andreas Platschek <platschek@ict.tuwien.ac.at>
> > Tested-by: Carsten Emde <C.Emde@osadl.org>
> > Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> > ---
> >  kernel/sched/core.c |   10 ++++++++--
> >  1 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index bf93f63..5690ba3 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -1074,11 +1074,17 @@ static int migration_cpu_stop(void *data);
> >  static bool check_task_state(struct task_struct *p, long match_state)
> >  {
> >  	bool match = false;
> > +	long state, saved_state;
> > +
> > +	/* catch restored state */
> > +	do {
> > +		state = p->state;
> > +		saved_state = p->saved_state;
> > +		rmb();  /* make sure we actually catch updates */
> 
> The problem I have with this is that there's no matching wmb(). Also,
> shouldn't that be a smp_rmb(), I don't think we can race with devices
> here.

Sebastian also mentioned that - I simply was not sure on this - still
not into this deep enough I guess .

> 
> > +	} while (state != p->state);
> >  
> > -	raw_spin_lock_irq(&p->pi_lock);
> >  	if (p->state == match_state || p->saved_state == match_state)
> >  		match = true;
> > -	raw_spin_unlock_irq(&p->pi_lock);
> >  
> >  	return match;
> >  }
> 
> 
> In rtmutex.c we have:
> 
> 	pi_lock(&self->pi_lock);
> 	__set_current_state(self->saved_state);
> 	self->saved_state = TASK_RUNNING;
> 	pi_unlock(&self->pi_lock);
> 
> As there is no wmb() here, it can be very possible that another CPU
> will see saved_state as TASK_RUNNING, and current state as
> TASK_RUNNING, and miss the update completely.
> 
> I would not want to add a wmb() unless there is a real bug with the
> check state, as the above is in a very fast path and the check state is
> in a slower path.
>
maybe I'm missing/missunderstanding something here but
pi_unlock -> arch_spin_unlock is a full mb() 
so once any task did an update of the state the loop should be catching
this update ? if the loop exits before the updat takes effect (pi_unlock)
would that be ncorrect ?

thx!
hofrat
 
