Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaKJWnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:43:22 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62586 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaKJWnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:43:20 -0500
Date: Mon, 10 Nov 2014 23:43:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
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
Message-ID: <20141110224306.GC29741@lerouge>
References: <alpine.DEB.2.11.1410311058500.32582@gentwo.org>
 <alpine.DEB.2.11.1411012003390.5308@nanos>
 <alpine.DEB.2.11.1411011646280.7732@gentwo.org>
 <alpine.DEB.2.11.1411012313320.5308@nanos>
 <alpine.DEB.2.11.1411061057470.5591@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411061057470.5591@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 11:24:59AM -0600, Christoph Lameter wrote:
> I thought there is already logic in there to compensate for times when the
> tick is off.
> 
> tick_do_update_jiffies64 calculates the time differential and calculates
> the number of ticks from there calling do_timer() with the number of ticks
> that have passed since the last invocation. The global load calculation
> is then also made based on the number of ticks that have passed. So it
> compensates when reenabling. And the load during the dynticks busy period
> is known because one process is monopolizing the processor during that
> time.

jiffies accounting is well handled everywhere. But that's different than the
scheduler.

> > I wont happen, if time_delta is KTIME_MAX and the following checks are
> > not having a timer armed.
> >
> >                  if (unlikely(expires.tv64 == KTIME_MAX)) {
> >                         if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
> >                                 hrtimer_cancel(&ts->sched_timer);
> >                         goto out;
> >                 }
> >
> > Which does either not arm the clockevent device (non highres) or
> > cancels ts->sched_timer (highres).
> >
> > So in that case your timer interrupt will stop completely and therefor
> > the scheduler updates on that cpu wont happen anymore.
> 
> Why is that bad? The load is constant and the timer interrupt can be
> reenabled by the dynticks logic when a system call occurs that requires OS
> services. I thought that was already done that way by Frederic?

Yeah it is. Perf events, RCU, posix cpu timers are examples of things that
are well handled by this tick on demand system. But they are all seperate
things than the scheduler.

> 
> > > Why does the scheduler require that tick? It seems that the processor is
> > > always busy running exactly 1 process when the tick is not
> > > occurring. Anything else will switch on the tick again. So the information
> > > that the scheduler has never becomes outdated.
> >
> > Surely vruntime, load balancing data, load accounting and all the
> > other stuff which contributes to global and local state updates itself
> > magically.
> 
> There is logic in there that compensates when the tick is finally
> reenabled. Load balancing data is already not updated when the tick is
> disabled when the processor is idle right? What is so different here?

That's completely different because idle and busy CPUs may play different
roles in load balancing. Load balancing can be assigned to idle CPUs for
example. But the scheduler still assumes that dynticks CPUs are always idle.
And we certainly don't want to assign load balancing duty to nohz full CPUs.

That too needs some work to be fixed properly.

> 
> > As I said before: It can be delegated to a housekeeper, but this needs
> > to be implemented first before we can remove that function.
> 
> We did not need to housekeeper in the dynticks idle case. What is so
> different about dynticks busy?

Because when a task runs we need some things to move forward: timekeeping
for example. We don't want to update jiffies and gettimeofday from full nohz
syscalls kernel entry. So another CPU has to maintain that.

Probably the game between timekeeping and vdso complicates even further the situation.

> 
> > There is a world outside of vmstat kworker, really.
> 
> Absolutely but I thought the logic is already there to compensate for
> issues like the timer interrupt not occurring.
> 
> I may not have the complete picture of the timer tick processing in my
> mind these days (it has been a lots of years since I did any work there
> after all) but as far as my arguably simplistic reading of the code goes I
> do not see why a housekeeper would be needed there. The load is constant
> and known in the dynticks busy case as it is in the dynticks idle case.

This is because of the general confusion between idle and dynticks.
There is no need for housekeeping if there is no activity at all on
a CPU (idle) and the mind makes a shortcut by considering that dynticks doesn't need
housekeeping.

But housekeeping is needed as long as there is activity and kernel service.
And that's the case whether hz or nohz.

Ok, I confess we moved part of that housekeeping to the syscall/exception/interrupt
entry path. We did that for cputime accounting and RCU. And it's possible to
even do that for timekeeping. But then the kernel entrypoint is going to be extremely
costly. It's worth CPU 0 as a sacrificial lamb.
