Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab3LROUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:20:05 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36900 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab3LROUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:20:03 -0500
Date: Wed, 18 Dec 2013 15:19:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 10/13] nohz: Hand over timekeeping duty on cpu offlining
Message-ID: <20131218141957.GB18464@localhost.localdomain>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-11-git-send-email-fweisbec@gmail.com>
 <20131217234022.GH19211@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217234022.GH19211@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 03:40:23PM -0800, Paul E. McKenney wrote:
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > index 527b501..94b6901 100644
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -217,6 +217,12 @@ static u64 tick_timekeeping_max_deferment(struct tick_sched *ts)
> >  		return timekeeping_max_deferment();
> > 
> >  	/*
> > +	 * Order tick_do_timer_cpu read against the IPI, pairs with
> > +	 * tick_nohz_full_kick_timekeeping()
> > +	 */
> > +	smp_rmb();
> 
> If this is the handler for the smp_send_reschedule(), then the above
> memory barrier is not needed.  (See my comment below.)
> 
> > +
> > +	/*
> >  	 * If we are the timekeeper and all full dynticks CPUs are idle,
> >  	 * then we can finally sleep.
> >  	 */
> > @@ -293,6 +299,22 @@ void tick_nohz_full_kick_all(void)
> >  	preempt_enable();
> >  }
> > 
> > +/**
> > + * tick_nohz_full_kick_timekeeping - kick the default timekeeper
> > + *
> > + * kick the default timekeeper when a secondary timekeeper goes offline.
> > + */
> > +void tick_nohz_full_kick_timekeeping(void)
> > +{
> > +	tick_do_timer_cpu = tick_timekeeping_default_cpu();
> > +	/*
> > +	 * Order tick_do_timer_cpu against the IPI, pairs with
> > +	 * tick_timekeeping_max_deferment on irq exit.
> > +	 */
> > +	smp_wmb();
> 
> But the IPI is supposed to provide full ordering between the CPU invoking
> the IPI and the IPI handler, right?

Great! I remember you told me so once but I wasn't sure. Thanks for
the confirmation!

> I do not believe that you need
> the above smp_wmb() -- though keeping the comment stating that you are
> relying on the implicit barrier in IPI would be good.

Indeed, I'll keep the comment on what the code rely on concerning implicit
ordering guarantees and then remove the explicit barriers.

> 
> > +	smp_send_reschedule(tick_timekeeping_default_cpu());
> 
> Again, smp_send_reschedule()'s IPI hander does not necessarily do
> anything if there is nothing for the scheduler to do, so any needed
> actions are taking in the return-from-interrupt code?

Yep, this is all handled from irq exit:

irq_exit -> tick_nohz_irq_exit() -> tick_nohz_stop_sched_tick() -> tick_timekeeping_max_deferment()

The latter function performs the tick re-evaluation on top of the need or not for the current
CPU to handle the timekeeping on behalf of others.

Thanks.

> 
> > +}
> > +
> >  /*
> >   * Re-evaluate the need for the tick as we switch the current task.
> >   * It might need the tick due to per task/process properties:
> > @@ -351,6 +373,15 @@ static int tick_nohz_cpu_down_callback(struct notifier_block *nfb,
> >  		if (tick_nohz_full_running && tick_timekeeping_default_cpu() == cpu)
> >  			return NOTIFY_BAD;
> >  		break;
> > +
> > +	case CPU_DYING:
> > +		/*
> > +		 * Notify default timekeeper if we are giving up
> > +		 * timekeeping duty
> > +		 */
> > +		if (tick_nohz_full_running && tick_do_timer_cpu == cpu)
> > +			tick_nohz_full_kick_timekeeping();
> > +		break;
> >  	}
> >  	return NOTIFY_OK;
> >  }
> > -- 
> > 1.8.3.1
> > 
> 
