Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328Ab3HNDHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 23:07:31 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37800 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759278Ab3HNDHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 23:07:30 -0400
Date: Tue, 13 Aug 2013 20:07:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 6/7] nohz_full: Add full-system-idle state
 machine
Message-ID: <20130814030723.GT29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130726231848.GA12967@linux.vnet.ibm.com>
 <1374880764-14248-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1374880764-14248-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130809162057.GC13339@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809162057.GC13339@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081403-7408-0000-0000-000012F865BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 06:20:59PM +0200, Frederic Weisbecker wrote:
> On Fri, Jul 26, 2013 at 04:19:23PM -0700, Paul E. McKenney wrote:
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index 3edae39..ff84bed 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -28,7 +28,7 @@
> >  #include <linux/gfp.h>
> >  #include <linux/oom.h>
> >  #include <linux/smpboot.h>
> > -#include <linux/tick.h>
> > +#include "time/tick-internal.h"
> >  
> >  #define RCU_KTHREAD_PRIO 1
> >  
> > @@ -2395,12 +2395,12 @@ static void rcu_kick_nohz_cpu(int cpu)
> >   * most active flavor of RCU.
> >   */
> >  #ifdef CONFIG_PREEMPT_RCU
> > -static struct rcu_state __maybe_unused *rcu_sysidle_state = &rcu_preempt_state;
> > +static struct rcu_state *rcu_sysidle_state = &rcu_preempt_state;
> >  #else /* #ifdef CONFIG_PREEMPT_RCU */
> > -static struct rcu_state __maybe_unused *rcu_sysidle_state = &rcu_sched_state;
> > +static struct rcu_state *rcu_sysidle_state = &rcu_sched_state;
> >  #endif /* #else #ifdef CONFIG_PREEMPT_RCU */
> 
> Ah you fixed it here. Ok :)

Bisectability and all that.  ;-)

> > -static int __maybe_unused full_sysidle_state; /* Current system-idle state. */
> > +static int full_sysidle_state;		/* Current system-idle state. */
> >  #define RCU_SYSIDLE_NOT		0	/* Some CPU is not idle. */
> >  #define RCU_SYSIDLE_SHORT	1	/* All CPUs idle for brief period. */
> >  #define RCU_SYSIDLE_LONG	2	/* All CPUs idle for long enough. */
> [...]
> > +/*
> > + * Check to see if the system is fully idle, other than the timekeeping CPU.
> > + * The caller must have disabled interrupts.
> > + */
> > +bool rcu_sys_is_idle(void)
> > +{
> > +	static struct rcu_sysidle_head rsh;
> > +	int rss = ACCESS_ONCE(full_sysidle_state);
> > +
> > +	if (WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu))
> > +		return false;
> > +
> > +	/* Handle small-system case by doing a full scan of CPUs. */
> > +	if (nr_cpu_ids <= RCU_SYSIDLE_SMALL) {
> 
> I don't understand how the nr_cpu_ids > RCU_SYSIDLE_SMALL is handled. There don't
> seem to be other calls of rcu_sysidle_check_cpu() than for small systems.

The other calls are from kernel/rcutree.c from the force-quiescent-state
code.  If we have a big system, we don't check until we have some other
reason to touch the cache lines.  If we have a small system, we just
dig through them on transition to idle.

							Thanx, Paul

