Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab3G2QxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:53:09 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46510 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab3G2QxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:53:06 -0400
Date: Mon, 29 Jul 2013 09:52:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 7/7] nohz_full: Force RCU's grace-period
 kthreads onto timekeeping CPU
Message-ID: <20130729165253.GP26694@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130726231848.GA12967@linux.vnet.ibm.com>
 <1374880764-14248-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1374880764-14248-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <51F5E325.4000607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F5E325.4000607@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072916-7282-0000-0000-000019C1B2DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 11:36:05AM +0800, Lai Jiangshan wrote:
> On 07/27/2013 07:19 AM, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Because RCU's quiescent-state-forcing mechanism is used to drive the
> > full-system-idle state machine, and because this mechanism is executed
> > by RCU's grace-period kthreads, this commit forces these kthreads to
> > run on the timekeeping CPU (tick_do_timer_cpu).  To do otherwise would
> > mean that the RCU grace-period kthreads would force the system into
> > non-idle state every time they drove the state machine, which would
> > be just a bit on the futile side.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/rcutree.c        |  1 +
> >  kernel/rcutree.h        |  1 +
> >  kernel/rcutree_plugin.h | 20 +++++++++++++++++++-
> >  3 files changed, 21 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index aa6d96e..fe83085 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1286,6 +1286,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
> >  	struct rcu_data *rdp;
> >  	struct rcu_node *rnp = rcu_get_root(rsp);
> >  
> > +	rcu_bind_gp_kthread();
> >  	raw_spin_lock_irq(&rnp->lock);
> >  	rsp->gp_flags = 0; /* Clear all flags: New grace period. */
> 
> bind the gp thread when RCU_GP_FLAG_INIT ...
> 
> >  
> > diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> > index e0de5dc..49dac99 100644
> > --- a/kernel/rcutree.h
> > +++ b/kernel/rcutree.h
> > @@ -560,6 +560,7 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
> >  static bool is_sysidle_rcu_state(struct rcu_state *rsp);
> >  static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
> >  				  unsigned long maxj);
> > +static void rcu_bind_gp_kthread(void);
> >  static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
> >  
> >  #endif /* #ifndef RCU_TREE_NONCORE */
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index ff84bed..f65d9c2 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -2544,7 +2544,7 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
> >  	if (!*isidle || rdp->rsp != rcu_sysidle_state ||
> >  	    cpu_is_offline(rdp->cpu) || rdp->cpu == tick_do_timer_cpu)
> >  		return;
> > -	/* WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu); */
> > +	WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);
> 
> 
> but call rcu_sysidle_check_cpu() when RCU_GP_FLAG_FQS.

Yep!  But we don't call rcu_gp_fqs() until the grace period is started,
by which time the kthread will be bound.  Any setting of RCU_GP_FLAG_FQS
while there is no grace period in progress is ignored.

> In this time, the thread may not be bound to tick_do_timer_cpu,
> the WARN_ON_ONCE() may be wrong.
> 
> Does any other code ensure the gp thread bound on tick_do_timer_cpu
> which I missed?

However, on small systems, rcu_sysidle_check_cpu() can be called from
the timekeeping CPU.  I suppose that this could potentially happen
before the first grace period starts, and in that case, we could
potentially see a spurious warning.  I could imagine a number of ways
to fix this:

1.	Bind the kthread when it is created.

2.	Bind the kthread when it first starts running, rather than just
	after the grace period starts.

3.	Suppress the warning when there is no grace period in progress.

4.	Suppress the warning prior to the first grace period starting.

Seems like #3 is the most straightforward approach.  I just change it to:

	if (rcu_gp_in_progress(rdp->rsp))
		WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);

This still gets a WARN_ON_ONCE() if someone moves the timekeeping CPU,
but Frederic tells me that it never moves.  My WARN_ON_ONCE() has some
probability of complaining should some bug creep in.

Sound reasonable?

							Thanx, Paul

> >  	/* Pick up current idle and NMI-nesting counter and check. */
> >  	cur = atomic_read(&rdtp->dynticks_idle);
> > @@ -2570,6 +2570,20 @@ static bool is_sysidle_rcu_state(struct rcu_state *rsp)
> >  }
> >  
> >  /*
> > + * Bind the grace-period kthread for the sysidle flavor of RCU to the
> > + * timekeeping CPU.
> > + */
> > +static void rcu_bind_gp_kthread(void)
> > +{
> > +	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
> > +
> > +	if (cpu < 0 || cpu >= nr_cpu_ids)
> > +		return;
> > +	if (raw_smp_processor_id() != cpu)
> > +		set_cpus_allowed_ptr(current, cpumask_of(cpu));
> > +}
> > +
> > +/*
> >   * Return a delay in jiffies based on the number of CPUs, rcu_node
> >   * leaf fanout, and jiffies tick rate.  The idea is to allow larger
> >   * systems more time to transition to full-idle state in order to
> > @@ -2767,6 +2781,10 @@ static bool is_sysidle_rcu_state(struct rcu_state *rsp)
> >  	return false;
> >  }
> >  
> > +static void rcu_bind_gp_kthread(void)
> > +{
> > +}
> > +
> >  static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
> >  				  unsigned long maxj)
> >  {
> 

