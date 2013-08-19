Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab3HSBWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 21:22:53 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51290 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab3HSBWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 21:22:51 -0400
Date: Sun, 18 Aug 2013 18:22:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 4/9] nohz_full: Add rcu_dyntick data for
 scalable detection of all-idle state
Message-ID: <20130819012229.GZ29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130818014918.GA27827@linux.vnet.ibm.com>
 <1376790584-28120-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376790584-28120-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130818030234.GG28923@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130818030234.GG28923@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081901-5406-0000-0000-00000B929594
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 08:02:34PM -0700, Josh Triplett wrote:
> On Sat, Aug 17, 2013 at 06:49:39PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > This commit adds fields to the rcu_dyntick structure that are used to
> > detect idle CPUs.  These new fields differ from the existing ones in
> > that the existing ones consider a CPU executing in user mode to be idle,
> > where the new ones consider CPUs executing in user mode to be busy.
> > The handling of these new fields is otherwise quite similar to that for
> > the exiting fields.  This commit also adds the initialization required
> > for these fields.
> > 
> > So, why is usermode execution treated differently, with RCU considering
> > it a quiescent state equivalent to idle, while in contrast the new
> > full-system idle state detection considers usermode execution to be
> > non-idle?
> > 
> > It turns out that although one of RCU's quiescent states is usermode
> > execution, it is not a full-system idle state.  This is because the
> > purpose of the full-system idle state is not RCU, but rather determining
> > when accurate timekeeping can safely be disabled.  Whenever accurate
> > timekeeping is required in a CONFIG_NO_HZ_FULL kernel, at least one
> > CPU must keep the scheduling-clock tick going.  If even one CPU is
> > executing in user mode, accurate timekeeping is requires, particularly for
> > architectures where gettimeofday() and friends do not enter the kernel.
> > Only when all CPUs are really and truly idle can accurate timekeeping be
> > disabled, allowing all CPUs to turn off the scheduling clock interrupt,
> > thus greatly improving energy efficiency.
> > 
> > This naturally raises the question "Why is this code in RCU rather than in
> > timekeeping?", and the answer is that RCU has the data and infrastructure
> > to efficiently make this determination.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> 
> One comment below.  With that change:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> > +#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
> > +
> > +/*
> > + * Initialize dynticks sysidle state for CPUs coming online.
> > + */
> > +static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
> > +{
> > +	rdtp->dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE;
> > +}
> > +
> > +#else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
> > +
> > +static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
> > +{
> > +}
> > +
> > +#endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
> 
> Just move the ifdef around the function body:
> 
> static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
> {
> #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
> 	rdtp->dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE;
> #endif /* CONFIG_NO_HZ_FULL_SYSIDLE */
> }

This makes sense for this isolated function, and it would also
make sense if the end result had only functions that were exported.
But if I try to apply this to the result, I will end up with something
like the following.  Is that really what you want?

I suppose I could individually enclose whole functions whose definitions
are unneeded for CONFIG_NO_HZ_FULL_SYSIDLE=n, but that doesn't seem
helpful either.

Thoughts?

							Thanx, Paul


/*
 * Invoked to note exit from irq or task transition to idle.  Note that
 * usermode execution does -not- count as idle here!  After all, we want
 * to detect full-system idle states, not RCU quiescent states and grace
 * periods.  The caller must have disabled interrupts.
 */
static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
{
#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
	unsigned long j;

	/* Adjust nesting, check for fully idle. */
	if (irq) {
		rdtp->dynticks_idle_nesting--;
		WARN_ON_ONCE(rdtp->dynticks_idle_nesting < 0);
		if (rdtp->dynticks_idle_nesting != 0)
			return;  /* Still not fully idle. */
	} else {
		if ((rdtp->dynticks_idle_nesting & DYNTICK_TASK_NEST_MASK) ==
		    DYNTICK_TASK_NEST_VALUE) {
			rdtp->dynticks_idle_nesting = 0;
		} else {
			rdtp->dynticks_idle_nesting -= DYNTICK_TASK_NEST_VALUE;
			WARN_ON_ONCE(rdtp->dynticks_idle_nesting < 0);
			return;  /* Still not fully idle. */
		}
	}

	/* Record start of fully idle period. */
	j = jiffies;
	ACCESS_ONCE(rdtp->dynticks_idle_jiffies) = j;
	smp_mb__before_atomic_inc();
	atomic_inc(&rdtp->dynticks_idle);
	smp_mb__after_atomic_inc();
	WARN_ON_ONCE(atomic_read(&rdtp->dynticks_idle) & 0x1);
#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
}

#ifdef CONFIG_NO_HZ_FULL_SYSIDLE

/*
 * Unconditionally force exit from full system-idle state.  This is
 * invoked when a normal CPU exits idle, but must be called separately
 * for the timekeeping CPU (tick_do_timer_cpu).  The reason for this
 * is that the timekeeping CPU is permitted to take scheduling-clock
 * interrupts while the system is in system-idle state, and of course
 * rcu_sysidle_exit() has no way of distinguishing a scheduling-clock
 * interrupt from any other type of interrupt.
 */
void rcu_sysidle_force_exit(void)
{
	int oldstate = ACCESS_ONCE(full_sysidle_state);
	int newoldstate;

	/*
	 * Each pass through the following loop attempts to exit full
	 * system-idle state.  If contention proves to be a problem,
	 * a trylock-based contention tree could be used here.
	 */
	while (oldstate > RCU_SYSIDLE_SHORT) {
		newoldstate = cmpxchg(&full_sysidle_state,
				      oldstate, RCU_SYSIDLE_NOT);
		if (oldstate == newoldstate &&
		    oldstate == RCU_SYSIDLE_FULL_NOTED) {
			rcu_kick_nohz_cpu(tick_do_timer_cpu);
			return; /* We cleared it, done! */
		}
		oldstate = newoldstate;
	}
	smp_mb(); /* Order initial oldstate fetch vs. later non-idle work. */
}

#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */

/*
 * Invoked to note entry to irq or task transition from idle.  Note that
 * usermode execution does -not- count as idle here!  The caller must
 * have disabled interrupts.
 */
static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
{
#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
	/* Adjust nesting, check for already non-idle. */
	if (irq) {
		rdtp->dynticks_idle_nesting++;
		WARN_ON_ONCE(rdtp->dynticks_idle_nesting <= 0);
		if (rdtp->dynticks_idle_nesting != 1)
			return; /* Already non-idle. */
	} else {
		/*
		 * Allow for irq misnesting.  Yes, it really is possible
		 * to enter an irq handler then never leave it, and maybe
		 * also vice versa.  Handle both possibilities.
		 */
		if (rdtp->dynticks_idle_nesting & DYNTICK_TASK_NEST_MASK) {
			rdtp->dynticks_idle_nesting += DYNTICK_TASK_NEST_VALUE;
			WARN_ON_ONCE(rdtp->dynticks_idle_nesting <= 0);
			return; /* Already non-idle. */
		} else {
			rdtp->dynticks_idle_nesting = DYNTICK_TASK_EXIT_IDLE;
		}
	}

	/* Record end of idle period. */
	smp_mb__before_atomic_inc();
	atomic_inc(&rdtp->dynticks_idle);
	smp_mb__after_atomic_inc();
	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks_idle) & 0x1));

	/*
	 * If we are the timekeeping CPU, we are permitted to be non-idle
	 * during a system-idle state.  This must be the case, because
	 * the timekeeping CPU has to take scheduling-clock interrupts
	 * during the time that the system is transitioning to full
	 * system-idle state.  This means that the timekeeping CPU must
	 * invoke rcu_sysidle_force_exit() directly if it does anything
	 * more than take a scheduling-clock interrupt.
	 */
	if (smp_processor_id() == tick_do_timer_cpu)
		return;

	/* Update system-idle state: We are clearly no longer fully idle! */
	rcu_sysidle_force_exit();
#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
}

/*
 * Check to see if the current CPU is idle.  Note that usermode execution
 * does not count as idle.  The caller must have disabled interrupts.
 */
static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
				  unsigned long *maxj)
{
#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
	int cur;
	unsigned long j;
	struct rcu_dynticks *rdtp = rdp->dynticks;

	/*
	 * If some other CPU has already reported non-idle, if this is
	 * not the flavor of RCU that tracks sysidle state, or if this
	 * is an offline or the timekeeping CPU, nothing to do.
	 */
	if (!*isidle || rdp->rsp != rcu_sysidle_state ||
	    cpu_is_offline(rdp->cpu) || rdp->cpu == tick_do_timer_cpu)
		return;
	if (rcu_gp_in_progress(rdp->rsp))
		WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);

	/* Pick up current idle and NMI-nesting counter and check. */
	cur = atomic_read(&rdtp->dynticks_idle);
	if (cur & 0x1) {
		*isidle = false; /* We are not idle! */
		return;
	}
	smp_mb(); /* Read counters before timestamps. */

	/* Pick up timestamps. */
	j = ACCESS_ONCE(rdtp->dynticks_idle_jiffies);
	/* If this CPU entered idle more recently, update maxj timestamp. */
	if (ULONG_CMP_LT(*maxj, j))
		*maxj = j;
#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
}

/*
 * Is this the flavor of RCU that is handling full-system idle?
 */
static bool is_sysidle_rcu_state(struct rcu_state *rsp)
{
#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
	return rsp == rcu_sysidle_state;
#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
}

/*
 * Bind the grace-period kthread for the sysidle flavor of RCU to the
 * timekeeping CPU.
 */
static void rcu_bind_gp_kthread(void)
{
#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
	int cpu = ACCESS_ONCE(tick_do_timer_cpu);

	if (cpu < 0 || cpu >= nr_cpu_ids)
		return;
	if (raw_smp_processor_id() != cpu)
		set_cpus_allowed_ptr(current, cpumask_of(cpu));
#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
}

#ifdef CONFIG_NO_HZ_FULL_SYSIDLE

/*
 * Return a delay in jiffies based on the number of CPUs, rcu_node
 * leaf fanout, and jiffies tick rate.  The idea is to allow larger
 * systems more time to transition to full-idle state in order to
 * avoid the cache thrashing that otherwise occur on the state variable.
 * Really small systems (less than a couple of tens of CPUs) should
 * instead use a single global atomically incremented counter, and later
 * versions of this will automatically reconfigure themselves accordingly.
 */
static unsigned long rcu_sysidle_delay(void)
{
	if (nr_cpu_ids <= RCU_SYSIDLE_SMALL)
		return 0;
	return DIV_ROUND_UP(nr_cpu_ids * HZ, rcu_fanout_leaf * 1000);
}

/*
 * Advance the full-system-idle state.  This is invoked when all of
 * the non-timekeeping CPUs are idle.
 */
static void rcu_sysidle(unsigned long j)
{
	/* Check the current state. */
	switch (ACCESS_ONCE(full_sysidle_state)) {
	case RCU_SYSIDLE_NOT:

		/* First time all are idle, so note a short idle period. */
		ACCESS_ONCE(full_sysidle_state) = RCU_SYSIDLE_SHORT;
		break;

	case RCU_SYSIDLE_SHORT:

		/*
		 * Idle for a bit, time to advance to next state?
		 * cmpxchg failure means race with non-idle, let them win.
		 */
		if (ULONG_CMP_GE(jiffies, j + rcu_sysidle_delay()))
			(void)cmpxchg(&full_sysidle_state,
				      RCU_SYSIDLE_SHORT, RCU_SYSIDLE_LONG);
		break;

	case RCU_SYSIDLE_LONG:

		/*
		 * Do an additional check pass before advancing to full.
		 * cmpxchg failure means race with non-idle, let them win.
		 */
		if (ULONG_CMP_GE(jiffies, j + rcu_sysidle_delay()))
			(void)cmpxchg(&full_sysidle_state,
				      RCU_SYSIDLE_LONG, RCU_SYSIDLE_FULL);
		break;

	default:
		break;
	}
}

/*
 * Found a non-idle non-timekeeping CPU, so kick the system-idle state
 * back to the beginning.
 */
static void rcu_sysidle_cancel(void)
{
	smp_mb();
	ACCESS_ONCE(full_sysidle_state) = RCU_SYSIDLE_NOT;
}

/*
 * Update the sysidle state based on the results of a force-quiescent-state
 * scan of the CPUs' dyntick-idle state.
 */
static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
			       unsigned long maxj, bool gpkt)
{
	if (rsp != rcu_sysidle_state)
		return;  /* Wrong flavor, ignore. */
	if (isidle) {
		if (gpkt && nr_cpu_ids > RCU_SYSIDLE_SMALL)
			rcu_sysidle(maxj);    /* More idle! */
	} else {
		rcu_sysidle_cancel(); /* Idle is over. */
	}
}

#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */

static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
				  unsigned long maxj)
{
#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
	rcu_sysidle_report(rsp, isidle, maxj, true);
#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
}

#ifdef CONFIG_NO_HZ_FULL_SYSIDLE

/* Callback and function for forcing an RCU grace period. */
struct rcu_sysidle_head {
	struct rcu_head rh;
	int inuse;
};

static void rcu_sysidle_cb(struct rcu_head *rhp)
{
	struct rcu_sysidle_head *rshp;

	smp_mb();  /* grace period precedes setting inuse. */
	rshp = container_of(rhp, struct rcu_sysidle_head, rh);
	ACCESS_ONCE(rshp->inuse) = 0;
}

/*
 * Check to see if the system is fully idle, other than the timekeeping CPU.
 * The caller must have disabled interrupts.
 */
bool rcu_sys_is_idle(void)
{
	static struct rcu_sysidle_head rsh;
	int rss = ACCESS_ONCE(full_sysidle_state);

	if (WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu))
		return false;

	/* Handle small-system case by doing a full scan of CPUs. */
	if (nr_cpu_ids <= RCU_SYSIDLE_SMALL) {
		int oldrss = rss - 1;

		/*
		 * One pass to advance to each state up to _FULL.
		 * Give up if any pass fails to advance the state.
		 */
		while (rss < RCU_SYSIDLE_FULL && oldrss < rss) {
			int cpu;
			bool isidle = true;
			unsigned long maxj = jiffies - ULONG_MAX / 4;
			struct rcu_data *rdp;

			/* Scan all the CPUs looking for nonidle CPUs. */
			for_each_possible_cpu(cpu) {
				rdp = per_cpu_ptr(rcu_sysidle_state->rda, cpu);
				rcu_sysidle_check_cpu(rdp, &isidle, &maxj);
				if (!isidle)
					break;
			}
			rcu_sysidle_report(rcu_sysidle_state,
					   isidle, maxj, false);
			oldrss = rss;
			rss = ACCESS_ONCE(full_sysidle_state);
		}
	}

	/* If this is the first observation of an idle period, record it. */
	if (rss == RCU_SYSIDLE_FULL) {
		rss = cmpxchg(&full_sysidle_state,
			      RCU_SYSIDLE_FULL, RCU_SYSIDLE_FULL_NOTED);
		return rss == RCU_SYSIDLE_FULL;
	}

	smp_mb(); /* ensure rss load happens before later caller actions. */

	/* If already fully idle, tell the caller (in case of races). */
	if (rss == RCU_SYSIDLE_FULL_NOTED)
		return true;

	/*
	 * If we aren't there yet, and a grace period is not in flight,
	 * initiate a grace period.  Either way, tell the caller that
	 * we are not there yet.
	 */
	if (nr_cpu_ids > RCU_SYSIDLE_SMALL &&
	    !rcu_gp_in_progress(rcu_sysidle_state) &&
	    !rsh.inuse && xchg(&rsh.inuse, 1) == 0)
		call_rcu(&rsh.rh, rcu_sysidle_cb);
	return false;
}

#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */

/*
 * Initialize dynticks sysidle state for CPUs coming online.
 */
static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
{
#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
	rdtp->dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE;
#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
}

#else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */

static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
{
}

static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
{
}

static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
				  unsigned long *maxj)
{
}

static bool is_sysidle_rcu_state(struct rcu_state *rsp)
{
	return false;
}

static void rcu_bind_gp_kthread(void)
{
}

static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
				  unsigned long maxj)
{
}

static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
{
}

#endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */

