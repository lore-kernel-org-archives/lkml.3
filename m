Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaE1A0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:26:05 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46682 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaE1A0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:26:03 -0400
Date: Tue, 27 May 2014 17:25:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>,
        Stanislav Meduna <stano@meduna.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] tracing: Don't account for cpu idle time with irqsoff
 tracers
Message-ID: <20140528002557.GR22231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1401221284-13678-1-git-send-email-sboyd@codeaurora.org>
 <17051981.niWmA6MIgX@wuerfel>
 <20140527174847.7b405b5c@gandalf.local.home>
 <53850FF3.8050107@codeaurora.org>
 <20140527193050.4606a014@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527193050.4606a014@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052800-6688-0000-0000-00000222B270
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 07:30:50PM -0400, Steven Rostedt wrote:
> On Tue, 27 May 2014 15:21:39 -0700
> Stephen Boyd <sboyd@codeaurora.org> wrote:
> 
> 
> > > Arnd brings up a good point. 
> > 
> > Hrm.. still not getting Arnd's mails.
> 
> Strange. What mail service do you have. Could they be blocking him?
> 
> > 
> > > If we disable irqs off tracing completely,
> > > we may be missing places in the idle path that disable interrupts for
> > > long periods of time. We may want to move the stop down further.
> > >
> > > The way it works (IIRC), and why tracing can start again is that it can
> > > nest. Perhaps we need to stop it further down if we can't move it
> > > completely.
> > >
> > 
> > I'm not sure how much deeper it can go and I'm afraid it will become a
> > game of whack-a-mole. I already see two places that disable and reenable
> > irqs after stop_critical_timings() is called (first in rcu_idle_enter()
> > and second in clockevents_notify()). Should rcu_idle_enter() move to
> > raw_local_irq_save()? It looks like that path calls rcu_sched_qs() and
> > on tiny RCU that again needs the raw_ treatement. We can probably call
> > stop_critical_timings() after rcu_idle_enter() to fix this.
> 
> I don't think we need to whack-a-mole. The start stop should be around
> where it goes to sleep.
> 
> > 
> > What about clockevents_notify? __raw_spin_lock_irqsave() should probably
> > use raw_local_irqsave().
> 
> No that solution is even worse. We need lockdep working here.
> 
> > 
> > If we go the raw route, do we even need stop/start_critical_timings()?
> > Can't we just use raw accessors in the idle paths
> > (tick_nohz_idle_{enter,exit}(), cpuidle_enter(), etc.) and get rid of
> > the stop/start stuff completely? I admit this patch is pretty much a big
> > sledge hammer that tries to make things simple, but if there is some
> > benefit to the raw accessors I'm willing to send patches to fix all the
> > call sites.
> > 
> 
> How about the following. I don't see any reason stop_critical_timings()
> can't be called from within rcu_idle code, as it doesn't use any rcu.
> 
> Paul, Peter, see anything wrong with this?

I don't immediately see any RCU use by stop_critical_timings(), but could
easily have missed something.  But CONFIG_PROVE_RCU=y will normally yell
if something using RCU showed up.

Looks plausible, but clearly needs testing across the usual array of
configs and arches.

							Thanx, Paul

> -- Steve
> 
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index 8f4390a..f5e6a64 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -88,12 +88,6 @@ static int cpuidle_idle_call(void)
>  	}
> 
>  	/*
> -	 * During the idle period, stop measuring the disabled irqs
> -	 * critical sections latencies
> -	 */
> -	stop_critical_timings();
> -
> -	/*
>  	 * Tell the RCU framework we are entering an idle section,
>  	 * so no more rcu read side critical sections and one more
>  	 * step to the grace period
> @@ -144,6 +138,12 @@ static int cpuidle_idle_call(void)
>  				trace_cpu_idle_rcuidle(next_state, dev->cpu);
> 
>  				/*
> +				 * During the idle period, stop measuring the
> +				 * disabled irqs critical sections latencies
> +				 */
> +				stop_critical_timings();
> +
> +				/*
>  				 * Enter the idle state previously
>  				 * returned by the governor
>  				 * decision. This function will block
> @@ -154,6 +154,8 @@ static int cpuidle_idle_call(void)
>  				entered_state = cpuidle_enter(drv, dev,
>  							      next_state);
> 
> +				start_critical_timings();
> +
>  				trace_cpu_idle_rcuidle(PWR_EVENT_EXIT,
>  						       dev->cpu);
> 
> @@ -175,8 +177,11 @@ static int cpuidle_idle_call(void)
>  	 * We can't use the cpuidle framework, let's use the default
>  	 * idle routine
>  	 */
> -	if (ret)
> +	if (ret) {
> +		stop_critical_timings();
>  		arch_cpu_idle();
> +		start_critical_timings();
> +	}
> 
>  	__current_set_polling();
> 
> @@ -188,7 +193,6 @@ static int cpuidle_idle_call(void)
>  		local_irq_enable();
> 
>  	rcu_idle_exit();
> -	start_critical_timings();
> 
>  	return 0;
>  }
> 

