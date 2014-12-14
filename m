Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750796AbaLNSJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 13:09:04 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45686 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbaLNSJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 13:09:00 -0500
Date: Sun, 14 Dec 2014 10:08:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/3] tracepoints: Do not use call_rcu_sched() before
 early_initcall()
Message-ID: <20141214180854.GC5310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141214164104.307127356@goodmis.org>
 <20141214164803.991954802@goodmis.org>
 <20141214115332.76be1b8b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141214115332.76be1b8b@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121418-0013-0000-0000-0000070F6935
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 11:53:32AM -0500, Steven Rostedt wrote:
> On Sun, 14 Dec 2014 11:41:05 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > In order to move enabling of trace events to just after mm_init(), the
> > tracepoint enable code can not use call_rcu_sched() because rcu isn't
> > even initialized yet.  Since this can only happen before SMP is set up
> > (and even before interrupts are set up), there's no reason to use
> > call_rcu_sched() at this point.
> > 
> > Instead, create a variable called tracepoint_rcu_safe that gets enabled
> > via early_initcall() and if that is not set, free the code directly
> > instead of using call_rcu_sched().
> > 
> > This allows us to enable tracepoints early without issues.
> > 
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

With the addition of read_mostly, and given that I am not going to mess
with call_rcu() this late in the 3.19 process without a blazingly good
reason:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Please note that you can use call_rcu() and friends as soon as rcu_init()
returns.  The callbacks won't be invoked until early_initcall() time,
but they will be properly queued.

Please note also that there are places where turning a call_rcu() into
a direct function call don't work, even at times when preemption is
disabled and there is only one CPU.  One example is where single-threaded
code uses call_rcu() on a list element of a list that it is traversing
within an RCU read-side critical section.  A direct call to the RCU
callback could potentially destroy the pointers that the traversal was
going to use to find the next element.  This means that we cannot make
call_rcu() do direct calls to the callback, as that would break quite
a bit of existing code.

Is there some definite point during boot before which you won't need to
invoke call_rcu_sched() for tracing?  I am guessing "no", but have to ask.
I can probably make call_rcu_sched() work arbitrarily early, but it is a
bit uglier.  And this assumes that irqs_disabled_flags(local_irq_save())
returns true during early boot.  I would -hope- this would be true!  ;-)

							Thanx, Paul

> > ---
> >  kernel/tracepoint.c | 27 ++++++++++++++++++++++++++-
> >  1 file changed, 26 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> > index 3490407dc7b7..9b90ef0ac731 100644
> > --- a/kernel/tracepoint.c
> > +++ b/kernel/tracepoint.c
> > @@ -33,6 +33,15 @@ extern struct tracepoint * const __stop___tracepoints_ptrs[];
> >  /* Set to 1 to enable tracepoint debug output */
> >  static const int tracepoint_debug;
> >  
> > +/*
> > + * traceoint_rcu_is_safe is set to true at early_initcall().
> > + * Tracepoints can be enabled before rcu is initialized.
> > + * When that happens, there's no reason to free via call_rcu()
> > + * because the system isn't even in SMP mode yet, and rcu isn't
> > + * initialized. Just directly free the old tracepoints instead.
> > + */
> > +static bool tracepoint_rcu_is_safe;
> 
> Hmm, I probably should make this read_mostly.
> 
> Although, it's not a hot path. Still, it gets set once at boot up and
> never touched again. Yeah, that deserves a read_mostly.
> 
> -- Steve
> 
> > +
> >  #ifdef CONFIG_MODULES
> >  /*
> >   * Tracepoint module list mutex protects the local module list.
> > @@ -76,7 +85,16 @@ static inline void release_probes(struct tracepoint_func *old)
> >  	if (old) {
> >  		struct tp_probes *tp_probes = container_of(old,
> >  			struct tp_probes, probes[0]);
> > -		call_rcu_sched(&tp_probes->rcu, rcu_free_old_probes);
> > +		/*
> > +		 * Tracepoints can be enabled before RCU is initialized
> > +		 * at boot up. If that is the case, do not bother using
> > +		 * call_rcu() (because that will fail), but instead just
> > +		 * free directly.
> > +		 */
> > +		if (likely(tracepoint_rcu_is_safe))
> > +			call_rcu_sched(&tp_probes->rcu, rcu_free_old_probes);
> > +		else
> > +			rcu_free_old_probes(&tp_probes->rcu);
> >  	}
> >  }
> >  
> > @@ -518,3 +536,10 @@ void syscall_unregfunc(void)
> >  	}
> >  }
> >  #endif
> > +
> > +static __init int init_tracepoint_rcu(void)
> > +{
> > +	tracepoint_rcu_is_safe = true;
> > +	return 0;
> > +}
> > +early_initcall(init_tracepoint_rcu);
> 

