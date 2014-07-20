Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaGTLsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 07:48:13 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:36646 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaGTLsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 07:48:07 -0400
Date: Sun, 20 Jul 2014 04:47:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu] Do not keep timekeeping CPU tick running
 for non-nohz_full= CPUs
Message-ID: <20140720114759.GO8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140719165350.GA18411@linux.vnet.ibm.com>
 <20140719180120.GA20887@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140719180120.GA20887@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072011-7164-0000-0000-000003428279
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 08:01:24PM +0200, Frederic Weisbecker wrote:
> On Sat, Jul 19, 2014 at 09:53:50AM -0700, Paul E. McKenney wrote:
> > If a non-nohz_full= CPU is non-idle, it will have a scheduling-clock
> > interrupt, and therefore doesn't need the timekeeping CPU to keep
> > its scheduling-clock interrupt going.  This commit therefore ignores
> > the idle state of non-nohz_full CPUs when determining whether or not
> > the timekeeping CPU can safely turn off its scheduling-clock interrupt.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Unfortunately that's not how things work. Running a CPU tick doesn't necessarily
> imply to run the timekeeping duty.
> 
> Only the timekeeper can update the timekeeping. There is an exception though:
> the timekeeping is also updated by dynticks idle CPUs when they wake up in an
> interrupt from idle.
> 
> Here is in practice why it doesn't work:
> 
> So lets say CPU 0 is timekeeper, CPU 1 a non-nohz-full CPU and all others are full-nohz.
> CPU 0 is sleeping. CPU 1 wakes up from idle, so it has an uptodate timekeeping but then
> if it continues to execute further without waking up CPU 0, it risks stale timestamps.
> 
> This can be changed by allowing timekeeping duty from all non-nohz_full CPUs, that's
> the initial direction I took, but it involved a lot of complications and scalability
> issues.

So we really have to have -all- the CPUs be idle to turn off the timekeeper.
This won't make the battery-powered embedded guys happy...

Other thoughts on this?  We really should not be setting
CONFIG_NO_HZ_FULL_SYSIDLE by default until this is solved.

								Thanx, Paul

> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index ddad959a9132..eaa32e4c228d 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -2789,8 +2789,13 @@ static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
> >  	 * system-idle state.  This means that the timekeeping CPU must
> >  	 * invoke rcu_sysidle_force_exit() directly if it does anything
> >  	 * more than take a scheduling-clock interrupt.
> > +	 *
> > +	 * In addition if we are not a nohz_full= CPU, then when we are
> > +	 * non-idle we have our own tick, so we don't need the timekeeping
> > +	 * CPU to keep a tick on our behalf.  We assume that the timekeeping
> > +	 * CPU is also a nohz_full= CPU.
> >  	 */
> > -	if (smp_processor_id() == tick_do_timer_cpu)
> > +	if (!tick_nohz_full_cpu(smp_processor_id()))
> >  		return;
> >  
> >  	/* Update system-idle state: We are clearly no longer fully idle! */
> > @@ -2810,11 +2815,11 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
> >  
> >  	/*
> >  	 * If some other CPU has already reported non-idle, if this is
> > -	 * not the flavor of RCU that tracks sysidle state, or if this
> > -	 * is an offline or the timekeeping CPU, nothing to do.
> > +	 * not the flavor of RCU that tracks sysidle state, or if this is
> > +	 * an offline or !nohz_full= or the timekeeping CPU, nothing to do.
> >  	 */
> >  	if (!*isidle || rdp->rsp != rcu_sysidle_state ||
> > -	    cpu_is_offline(rdp->cpu) || rdp->cpu == tick_do_timer_cpu)
> > +	    cpu_is_offline(rdp->cpu) || !tick_nohz_full_cpu(rdp->cpu))
> >  		return;
> >  	if (rcu_gp_in_progress(rdp->rsp))
> >  		WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);
> > 
> 

