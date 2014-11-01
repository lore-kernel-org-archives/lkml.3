Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985AbaKAWdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:33:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:47655 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaKAWdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:33:49 -0400
Date: Sat, 1 Nov 2014 23:33:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [NOHZ] Remove scheduler_tick_max_deferment
In-Reply-To: <alpine.DEB.2.11.1411011646280.7732@gentwo.org>
Message-ID: <alpine.DEB.2.11.1411012313320.5308@nanos>
References: <alpine.DEB.2.11.1410311058500.32582@gentwo.org> <alpine.DEB.2.11.1411012003390.5308@nanos> <alpine.DEB.2.11.1411011646280.7732@gentwo.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2014, Christoph Lameter wrote:
> On Sat, 1 Nov 2014, Thomas Gleixner wrote:
> 
> > On Fri, 31 Oct 2014, Christoph Lameter wrote:
> > > The reasoning behind this function is not clear to me and removal seems
> >
> > The comment above the function is clear enough.
> 
> I looked around into the functions called by the timer interrupt for
> accounting etc. They have measures to compensate if the HZ is not
> occurring for some time.

Let's look at that comment first:

 * Keep at least one tick per second when a single
 * active task is running because the scheduler doesn't
 * yet completely support full dynticks environment.
 *
 * This makes sure that uptime, CFS vruntime, load
 * balancing, etc... continue to move forward, even
 * with a very low granularity.

So this talks about the scheduler tick obviously, right?

Now scheduler_tick() is invoked from update_process_times() and
update_process_times() is invoked from tick_sched_handle() and that is
invoked from either tick_sched_timer() or tick_nohz_handler().

tick_sched_timer() is the hrtimer callback of tick_cpu_sched.sched_timer.
That's used when high resolution timers are enabled.

tick_nohz_handler() is the event handler for the clock event device if
high resolution timers are disabled.

Now the callsite of scheduler_tick_max_deferment() does:

   time_delta = min(time_delta, scheduler_tick_max_deferment());

And that is used further down after some other checks to arm either
tick_cpu_sched.sched_timer or the clockevent itself.

Which then when fired will invoke scheduler_tick() ....

Really hard to figure out, right?

> > > to have a limited impact on the system overall. Even without the
> > > cap to 1 second the system will be limited by the boundaries on the period
> > > of interrupts by various devices (in my case I ended up with a 4 second
> > > interval on x86 because of the limitations of periodicy of the underlying
> > > interupt source).
> >
> > And just because it happens to do so on your machine it's not
> > guaranteed.
> 
> When would it not occur? Where do we lack a measure to cope with missing
> timer interrupts now?

I wont happen, if time_delta is KTIME_MAX and the following checks are
not having a timer armed.

                 if (unlikely(expires.tv64 == KTIME_MAX)) {
                        if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
                                hrtimer_cancel(&ts->sched_timer);
                        goto out;
                }

Which does either not arm the clockevent device (non highres) or
cancels ts->sched_timer (highres).

So in that case your timer interrupt will stop completely and therefor
the scheduler updates on that cpu wont happen anymore.

> > But we care about that _after_ we solved the scheduler tick
> > requirement because that is the most evident one.
> 
> Why does the scheduler require that tick? It seems that the processor is
> always busy running exactly 1 process when the tick is not
> occurring. Anything else will switch on the tick again. So the information
> that the scheduler has never becomes outdated.

Surely vruntime, load balancing data, load accounting and all the
other stuff which contributes to global and local state updates itself
magically.

As I said before: It can be delegated to a housekeeper, but this needs
to be implemented first before we can remove that function.

There is a world outside of vmstat kworker, really.

Thanks,

	tglx
