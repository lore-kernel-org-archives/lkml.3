Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3JDWCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 18:02:39 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55824 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab3JDWCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 18:02:37 -0400
Date: Fri, 4 Oct 2013 15:02:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, peter@hurleysoftware.com
Subject: Re: tty^Wrcu/perf lockdep trace.
Message-ID: <20131004220232.GA8293@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131003190830.GA18672@redhat.com>
 <20131003194226.GO28601@twins.programming.kicks-ass.net>
 <20131003195832.GU5790@linux.vnet.ibm.com>
 <20131004065835.GP28601@twins.programming.kicks-ass.net>
 <20131004160352.GF5790@linux.vnet.ibm.com>
 <20131004165044.GV28601@twins.programming.kicks-ass.net>
 <20131004170954.GK5790@linux.vnet.ibm.com>
 <20131004185239.GS15690@laptop.programming.kicks-ass.net>
 <20131004212506.GM5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004212506.GM5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100422-5806-0000-0000-000022F60975
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 02:25:06PM -0700, Paul E. McKenney wrote:
> On Fri, Oct 04, 2013 at 08:52:39PM +0200, Peter Zijlstra wrote:
> > On Fri, Oct 04, 2013 at 10:09:54AM -0700, Paul E. McKenney wrote:
> > > On Fri, Oct 04, 2013 at 06:50:44PM +0200, Peter Zijlstra wrote:
> > > > On Fri, Oct 04, 2013 at 09:03:52AM -0700, Paul E. McKenney wrote:
> > > > > The problem exists, but NOCB made it much more probable.  With non-NOCB
> > > > > kernels, an irq-disabled call_rcu() invocation does a wake_up() only if
> > > > > there are more than 10,000 callbacks stacked up on the CPU.  With a NOCB
> > > > > kernel, the wake_up() happens on the first callback.
> > > > 
> > > > Oh I see.. so I was hoping this was some NOCB crackbrained damage we
> > > > could still 'fix'.
> > > > 
> > > > And that wakeup is because we moved grace-period advancing into
> > > > kthreads, right?
> > > 
> > > Yep, in earlier kernels we would instead be doing raise_softirq().
> > > Which would instead wake up ksoftirqd, if I am reading the code
> > > correctly -- spin_lock_irq() does not affect preempt_count.
> > 
> > I suspect you got lost in the indirection fest; but have a look at
> > __raw_spin_lock_irqsave(). It does:
> > 
> > 	local_irq_save();
> > 	preempt_disable();
> 
> ETOOMANYLEVELS.  ;-)
> 
> OK, then I should be able to just do raise_softirq() in this
> situation.  As long as irqs were disabled due to something other than
> local_irq_disable(), but I would get around that by doing an explicit
> preempt_disable() in call_rcu() or friends.
> 
> The real-time guys won't like that much -- they are trying to get rid
> of softirq -- but hopefully we can come up with something better later.
> Or maybe they have other tricks available to them.

But preempt_disable() won't set anything that in_interrupt() sees...
And it is a no-op in any case on CONFIG_PREEMPT=n kernels.

> > > > Probably; so the regular no-NOCB would be easy to work around by
> > > > providing me a call_rcu variant that never does the wakeup.
> > > 
> > > Well, if we can safely, sanely, and reliably defer the wakeup, there is
> > > no reason not to make plain old call_rcu() do what you need.
> > 
> > Agreed.
> > 
> > > If there
> > > is no such way to defer the wakeup, then I don't see how to make that
> > > variant.
> > 
> > Wouldn't it be a simple matter of making __call_rcu_core() return early,
> > just like it does for irqs_disabled_flags()?
> 
> Given that raise_softirq() works, it just might be.  Except that I would
> need to leave an indication that there are deferred callbacks and do
> an invoke_rcu_core().  Plus make __rcu_process_callbacks() check this
> indication and do the wakeup.
> 
> I should be able to use in_interrupt() despite its inaccuracy near
> the beginnings and ends of interrupt handlers because all I really
> care about is whether one of the scheduler or perf locks might be
> held, and they will cause in_interrupt() to return true regardless.

So I can't use in_interrupt(), because it doesn't see the bits that
preempt_disable() sets, even in kernels where preempt_disable isn't
a no-op.

I can instead use irqs_disabled_flags(), but then I am back to not
seeing how raise_softirq() is safe in non-irq-handler contexts where
the scheduler locks might be held.  The check of in_interrupt() only
looks at HARDIRQ_MASK, SOFTIRQ_MASK, and NMI_MASK, so it won't see
local_irq_disable() or spin_lock_irqsave() from process context.

This puts me back into the position of having to check for deferred
wakeups in many locations.

Back to the drawing board...

							Thanx, Paul

> > > > NOCB might be a little more difficult; depending on the reason why it
> > > > needs to do this wakeup on every single invocation; that seems
> > > > particularly expensive.
> > > 
> > > Not on every single invocation, just on those invocations where the list
> > > is initially empty.  So the first call_rcu() on a CPU whose rcuo kthread
> > > is sleeping will do a wakeup, but subsequent call_rcu()s will just queue,
> > > at least until rcuo goes to sleep again.  Which takes awhile, since it
> > > has to wait for a grace period before invoking that first RCU callback.
> > 
> > So I've not kept up with RCU the last year or so due to circumstance, so
> > please bear with me ( http://www.youtube.com/watch?v=4sxtHODemi0 ).
> 
> I would, but the people sitting near me might be disturbed.  ;-)
> 
> >                                                                     Why
> > do we still have a per-cpu kthread in nocb mode? The idea is that we do
> > not disturb the cpu, right? So I suppose these kthreads get to run on
> > another cpu.
> 
> Yep, the idea is that usermode figures out where to run them.  Even if
> usermode doesn't do that, this has the effect of getting them to be
> more out of the way of real-time tasks.
> 
> > Since its running on another cpu; we get into atomic and memory barriers
> > anyway; so why not keep the logic the same as no-nocb but have another
> > cpu check our nocb cpu's state.
> 
> You can do that today by setting rcu_nocb_poll, but that results in
> frequent polling wakeups even when the system is completely idle, which
> is out of the question for the battery-powered embedded guys.
> 
> > That is; I'm fumbling to understand how all this works and needs to be
> > different.
> 
> Here is an untested patch.  Thoughts?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index a33a24d10611..1a0a14349b29 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -2310,6 +2310,9 @@ __rcu_process_callbacks(struct rcu_state *rsp)
>  	/* If there are callbacks ready, invoke them. */
>  	if (cpu_has_callbacks_ready_to_invoke(rdp))
>  		invoke_rcu_callbacks(rsp, rdp);
> +
> +	/* Do any needed deferred wakeups of rcuo kthreads. */
> +	do_nocb_deferred_wakeup(rdp);
>  }
>  
>  /*
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 8e34d8674a4e..c20096cf8206 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -335,6 +335,7 @@ struct rcu_data {
>  	int nocb_p_count_lazy;		/*  (approximate). */
>  	wait_queue_head_t nocb_wq;	/* For nocb kthreads to sleep on. */
>  	struct task_struct *nocb_kthread;
> +	bool nocb_defer_wakeup;		/* Defer wakeup of nocb_kthread. */
>  #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
>  
>  	/* 8) RCU CPU stall data. */
> @@ -553,6 +554,7 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
>  			    bool lazy);
>  static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
>  				      struct rcu_data *rdp);
> +static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
>  static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
>  static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
>  static void rcu_kick_nohz_cpu(int cpu);
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 747df70a4d64..7f54fb25a036 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -2125,9 +2125,17 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
>  	}
>  	len = atomic_long_read(&rdp->nocb_q_count);
>  	if (old_rhpp == &rdp->nocb_head) {
> -		wake_up(&rdp->nocb_wq); /* ... only if queue was empty ... */
> +		if (!in_interrupt()) {
> +			wake_up(&rdp->nocb_wq); /* ... if queue was empty ... */
> +			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
> +					    TPS("WakeEmpty"));
> +		} else {
> +			rdp->nocb_defer_wakeup = true;
> +			invoke_rcu_core();
> +			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
> +					    TPS("WakeEmptyIsDeferred"));
> +		}
>  		rdp->qlen_last_fqs_check = 0;
> -		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeEmpty"));
>  	} else if (len > rdp->qlen_last_fqs_check + qhimark) {
>  		wake_up_process(t); /* ... or if many callbacks queued. */
>  		rdp->qlen_last_fqs_check = LONG_MAX / 2;
> @@ -2314,6 +2322,16 @@ static int rcu_nocb_kthread(void *arg)
>  	return 0;
>  }
>  
> +/* Do a deferred wakeup of rcu_nocb_kthread(). */
> +static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
> +{
> +	if (!ACCESS_ONCE(rdp->nocb_defer_wakeup))
> +		return;
> +	ACCESS_ONCE(rdp->nocb_defer_wakeup) = false;
> +	wake_up(&rdp->nocb_wq);
> +	trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("DeferredWakeEmpty"));
> +}
> +
>  /* Initialize per-rcu_data variables for no-CBs CPUs. */
>  static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
>  {
> @@ -2384,6 +2402,10 @@ static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
>  {
>  }
>  
> +static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
> +{
> +}
> +
>  static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
>  {
>  }

