Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaKFRZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:25:08 -0500
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:53674 "EHLO
	resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbaKFRZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:25:03 -0500
Date: Thu, 6 Nov 2014 11:24:59 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Thomas Gleixner <tglx@linutronix.de>
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
In-Reply-To: <alpine.DEB.2.11.1411012313320.5308@nanos>
Message-ID: <alpine.DEB.2.11.1411061057470.5591@gentwo.org>
References: <alpine.DEB.2.11.1410311058500.32582@gentwo.org> <alpine.DEB.2.11.1411012003390.5308@nanos> <alpine.DEB.2.11.1411011646280.7732@gentwo.org> <alpine.DEB.2.11.1411012313320.5308@nanos>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2014, Thomas Gleixner wrote:

>  * balancing, etc... continue to move forward, even
>  * with a very low granularity.
>
> So this talks about the scheduler tick obviously, right?

Obviously.

> Now scheduler_tick() is invoked from update_process_times() and
> update_process_times() is invoked from tick_sched_handle() and that is
> invoked from either tick_sched_timer() or tick_nohz_handler().

>
> tick_sched_timer() is the hrtimer callback of tick_cpu_sched.sched_timer.
> That's used when high resolution timers are enabled.
>
> tick_nohz_handler() is the event handler for the clock event device if
> high resolution timers are disabled.
>
> Now the callsite of scheduler_tick_max_deferment() does:
>
>    time_delta = min(time_delta, scheduler_tick_max_deferment());
>
> And that is used further down after some other checks to arm either
> tick_cpu_sched.sched_timer or the clockevent itself.
>
> Which then when fired will invoke scheduler_tick() ....
>
> Really hard to figure out, right?

I thought there is already logic in there to compensate for times when the
tick is off.

tick_do_update_jiffies64 calculates the time differential and calculates
the number of ticks from there calling do_timer() with the number of ticks
that have passed since the last invocation. The global load calculation
is then also made based on the number of ticks that have passed. So it
compensates when reenabling. And the load during the dynticks busy period
is known because one process is monopolizing the processor during that
time.

> I wont happen, if time_delta is KTIME_MAX and the following checks are
> not having a timer armed.
>
>                  if (unlikely(expires.tv64 == KTIME_MAX)) {
>                         if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
>                                 hrtimer_cancel(&ts->sched_timer);
>                         goto out;
>                 }
>
> Which does either not arm the clockevent device (non highres) or
> cancels ts->sched_timer (highres).
>
> So in that case your timer interrupt will stop completely and therefor
> the scheduler updates on that cpu wont happen anymore.

Why is that bad? The load is constant and the timer interrupt can be
reenabled by the dynticks logic when a system call occurs that requires OS
services. I thought that was already done that way by Frederic?

> > Why does the scheduler require that tick? It seems that the processor is
> > always busy running exactly 1 process when the tick is not
> > occurring. Anything else will switch on the tick again. So the information
> > that the scheduler has never becomes outdated.
>
> Surely vruntime, load balancing data, load accounting and all the
> other stuff which contributes to global and local state updates itself
> magically.

There is logic in there that compensates when the tick is finally
reenabled. Load balancing data is already not updated when the tick is
disabled when the processor is idle right? What is so different here?

> As I said before: It can be delegated to a housekeeper, but this needs
> to be implemented first before we can remove that function.

We did not need to housekeeper in the dynticks idle case. What is so
different about dynticks busy?

> There is a world outside of vmstat kworker, really.

Absolutely but I thought the logic is already there to compensate for
issues like the timer interrupt not occurring.

I may not have the complete picture of the timer tick processing in my
mind these days (it has been a lots of years since I did any work there
after all) but as far as my arguably simplistic reading of the code goes I
do not see why a housekeeper would be needed there. The load is constant
and known in the dynticks busy case as it is in the dynticks idle case.

