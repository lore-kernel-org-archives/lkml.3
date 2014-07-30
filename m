Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaG3NXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:23:45 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45343 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaG3NXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:23:42 -0400
Date: Wed, 30 Jul 2014 15:23:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 07/10] nohz: Enforce timekeeping on CPU 0
Message-ID: <20140730132333.GA18158@localhost.localdomain>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
 <1406569056-30217-8-git-send-email-fweisbec@gmail.com>
 <20140729121237.GY3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729121237.GY3935@laptop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 02:12:37PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 28, 2014 at 07:37:33PM +0200, Frederic Weisbecker wrote:
> > The timekeeper gets initialized to the value of the CPU where the
> > first clockevent device is setup. This works well because the timekeeper
> > can be any online CPU in most configs.
> > 
> > Full dynticks has its own requirement though and needs the timekeeper
> > to always be 0. And this requirement seem to accomodate pretty well with
> > the above described boot timekeeper setting because the first clockevent
> > device happens to be initialized, most of the time, on the boot CPU
> > (which should be CPU 0).
> 
> This isn't true in general, Voyager (which we dropped support for iirc)
> had a boot cpu != 0, and I think there's ARM platforms where the same
> can be true.

Ah I didn't know that. But I heard before that assuming CPU0 as the boot
CPU is a mistake.

> 
> > However there is no mention of such a guarantee anywhere. This assumption
> > might well be defeated on some corner case now or in the future.
> 
> Right..
> 
> > So lets wipe out the FUD and force tick_do_timer_cpu to CPU 0 on boot
> > when full dynticks is used.
> > 
> > This way we can even remove some corner case code that handled scenarios
> > where all clockevent devices were setup on full dynticks CPUs.
> 
> > diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> > index 0a0608e..cb57bce 100644
> > --- a/kernel/time/tick-common.c
> > +++ b/kernel/time/tick-common.c
> > @@ -179,10 +179,10 @@ static void tick_setup_device(struct tick_device *td,
> >  		 * this cpu:
> >  		 */
> >  		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
> > -			if (!tick_nohz_full_cpu(cpu))
> > -				tick_do_timer_cpu = cpu;
> > +			if (tick_nohz_full_enabled())
> > +				tick_do_timer_cpu = TICK_DO_TIMER_DEFAULT;
> >  			else
> > -				tick_do_timer_cpu = TICK_DO_TIMER_NONE;
> > +				tick_do_timer_cpu = cpu;
> >  			tick_next_period = ktime_get();
> >  			tick_period = ktime_set(0, NSEC_PER_SEC / HZ);
> >  		}
> 
> So from what I can tell this code can get called before SMP setup, which
> would mean we could get here before CPU0 is online?

If CPU0 is a secondary CPU then yeah we have a problem.

Look, the most important for me is to determine the boot CPU and make sure
we don't need to offline it for suspend.

Looking at disable_nonboot_cpus(), it seems that the lowest number from the online set
is considered the boot CPU. But if CPU0 boots after the boot CPU, this assumption is defeated,
right?

Probably disable_nonboot_cpus() doesn't look for the real boot CPU but
rather it just tries to keep at least one CPU alive for stopping and resuming the
suspend process.

It looks like the only sane thing I can do is:

1) Pick up the boot CPU (the one that calls tick_nohz_init() for example) as the
default timekeeper.

2) Let it be offlined but then handover its timekeeping duty to any online CPU,
whether full dynticks or not (of course then the full dynticks timekeeper won't be
ever allowed to enter in full dynticks mode), we don't have the choice anyway.

But then we need a way to reset the sysidle state when we handover the timekeeping
duty.

Big headaches on the horizon!

Why haven't we kept CPU0 as the boot CPU for everyone? Things were just simple that way...
