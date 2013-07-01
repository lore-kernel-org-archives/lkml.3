Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3GASKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:10:50 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40180 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3GASKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:10:48 -0400
Date: Mon, 1 Jul 2013 11:10:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full v2 6/7] nohz_full: Add full-system-idle
 state machine
Message-ID: <20130701181040.GO3773@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130628200949.GA17458@linux.vnet.ibm.com>
 <1372450222-19420-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1372450222-19420-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130701163529.GO7246@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701163529.GO7246@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070118-5518-0000-0000-000010043AFD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 06:35:31PM +0200, Frederic Weisbecker wrote:
> On Fri, Jun 28, 2013 at 01:10:21PM -0700, Paul E. McKenney wrote:
> >  /*
> > + * Unconditionally force exit from full system-idle state.  This is
> > + * invoked when a normal CPU exits idle, but must be called separately
> > + * for the timekeeping CPU (tick_do_timer_cpu).  The reason for this
> > + * is that the timekeeping CPU is permitted to take scheduling-clock
> > + * interrupts while the system is in system-idle state, and of course
> > + * rcu_sysidle_exit() has no way of distinguishing a scheduling-clock
> > + * interrupt from any other type of interrupt.
> > + */
> > +void rcu_sysidle_force_exit(void)
> > +{
> > +	int oldstate = ACCESS_ONCE(full_sysidle_state);
> > +	int newoldstate;
> > +
> > +	/*
> > +	 * Each pass through the following loop attempts to exit full
> > +	 * system-idle state.  If contention proves to be a problem,
> > +	 * a trylock-based contention tree could be used here.
> > +	 */
> > +	while (oldstate > RCU_SYSIDLE_SHORT) {
> > +		newoldstate = cmpxchg(&full_sysidle_state,
> > +				      oldstate, RCU_SYSIDLE_NOT);
> > +		if (oldstate == newoldstate &&
> > +		    oldstate == RCU_SYSIDLE_FULL_NOTED) {
> > +			rcu_kick_nohz_cpu(tick_do_timer_cpu);
> > +			return; /* We cleared it, done! */
> > +		}
> > +		oldstate = newoldstate;
> > +	}
> > +	smp_mb(); /* Order initial oldstate fetch vs. later non-idle work. */
> > +}
> > +
> > +/*
> >   * Invoked to note entry to irq or task transition from idle.  Note that
> >   * usermode execution does -not- count as idle here!  The caller must
> >   * have disabled interrupts.
> > @@ -2474,6 +2506,214 @@ static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
> >  	atomic_inc(&rdtp->dynticks_idle);
> >  	smp_mb__after_atomic_inc();
> >  	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks_idle) & 0x1));
> > +
> > +	/*
> > +	 * If we are the timekeeping CPU, we are permitted to be non-idle
> > +	 * during a system-idle state.  This must be the case, because
> > +	 * the timekeeping CPU has to take scheduling-clock interrupts
> > +	 * during the time that the system is transitioning to full
> > +	 * system-idle state.  This means that the timekeeping CPU must
> > +	 * invoke rcu_sysidle_force_exit() directly if it does anything
> > +	 * more than take a scheduling-clock interrupt.
> > +	 */
> > +	if (smp_processor_id() == tick_do_timer_cpu)
> > +		return;
> > +
> > +	/* Update system-idle state: We are clearly no longer fully idle! */
> > +	rcu_sysidle_force_exit();
> > +}
> > +
> > +/*
> > + * Check to see if the current CPU is idle.  Note that usermode execution
> > + * does not count as idle.  The caller must have disabled interrupts.
> > + */
> > +static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
> > +				  unsigned long *maxj)
> > +{
> > +	int cur;
> > +	int curnmi;
> > +	unsigned long j;
> > +	struct rcu_dynticks *rdtp = rdp->dynticks;
> > +
> > +	/*
> > +	 * If some other CPU has already reported non-idle, if this is
> > +	 * not the flavor of RCU that tracks sysidle state, or if this
> > +	 * is an offline or the timekeeping CPU, nothing to do.
> > +	 */
> > +	if (!*isidle || rdp->rsp != rcu_sysidle_state ||
> > +	    cpu_is_offline(rdp->cpu) || rdp->cpu == tick_do_timer_cpu)
> > +		return;
> > +	/* WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu); */
> > +
> > +	/*
> > +	 * Pick up current idle and NMI-nesting counters, check.  We check
> > +	 * for NMIs using RCU's main ->dynticks counter.  This works because
> > +	 * any time ->dynticks has its low bit set, ->dynticks_idle will
> > +	 * too -- unless the only reason that ->dynticks's low bit is set
> > +	 * is due to an NMI from idle.  Which is exactly the case we need
> > +	 * to account for.
> > +	 */
> > +	cur = atomic_read(&rdtp->dynticks_idle);
> > +	curnmi = atomic_read(&rdtp->dynticks);
> > +	if ((cur & 0x1) || (curnmi & 0x1)) {
> 
> I think you wanted to ignore NMIs this time because they don't read walltime?
> 
> By the way they can still read jiffies, but unlike irq_enter(), nmi_enter()
> don't catch up with missing jiffies update. So the behaviour doesn't change
> compared to !NO_HZ_FULL.

You are right, I missed this when ripping out NMI handling.  Will fix!

> > +		*isidle = 0; /* We are not idle! */
> > +		return;
> > +	}
> > +	smp_mb(); /* Read counters before timestamps. */
> > +
> > +	/* Pick up timestamps. */
> > +	j = ACCESS_ONCE(rdtp->dynticks_idle_jiffies);
> > +	/* If this CPU entered idle more recently, update maxj timestamp. */
> > +	if (ULONG_CMP_LT(*maxj, j))
> > +		*maxj = j;
> 
> So I'm a bit confused with the ordering so I'm probably going to ask a silly question.
> 
> What makes sure that we are not reading a stale value of rdtp->dynticks_idle
> in the following scenario:
> 
>     CPU 0                          CPU 1
>     
>                                    //CPU 1 idle
>                                    //rdtp(1)->dynticks_idle == 0
> 
> sysidle_check_cpu(CPU 1) {
>     rdtp(1)->dynticks_idle == 0
> }
> cmpxchg(full_sysidle_state, 
>         ...RCU_SYSIDLE_SHORT)
>                                    rcu_irq_exit() {

rcu_irq_enter(), right?

>                                          rdtp(1)->dynticks_idle = 1
>                                          smp_mb()
>                                          rcu_sysidle_force_exit() {
>                                             full_sysidle_state == RCU_SYSIDLE_SHORT
>                                             // no cmpxchg
>                                             smp_mb()
>                                    ...
> 
> [1]
> sysidle_check_cpu(CPU 1) {
>     rdtp(1)->dynticks_idle == 0
> }
> 
> cmpxchg(RCU_SYSIDLE_FULL, ...)

You know, I had an RCU_SYSIDLE_LONG state for this purpose, but later
convinced myself that I didn't need it.  :-/

Time to go put it back in, and thank you for your careful review!

							Thanx, Paul

> [2]
> sysidle_check_cpu(CPU 1) {
>     rdtp(1)->dynticks_idle == 0
> }
> 
> cmpxchg(RCU_SYSIDLE_FULL_NOTED, ...)
> 
> 
> I mean in [1] and [2] I can't see something in the ordering that guarantees that we see
> the new value rdtp(1)->dynticks_idle == 1.
> 

