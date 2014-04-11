Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbaDKPSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 11:18:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40842 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbaDKPSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:18:32 -0400
Date: Fri, 11 Apr 2014 17:18:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [Query]: tick-sched: why don't we stop tick when we are running
 idle task?
Message-ID: <20140411151825.GX11096@twins.programming.kicks-ass.net>
References: <CAKohpo=uT0oC+bZVJQPsoGLb-a4y4huYKtd1ayb4_+iH4906nw@mail.gmail.com>
 <CAKohpom5Ft_XrNTExE9Ukyv1e4car+wicDiPp_Bdhy=PW9Sq8g@mail.gmail.com>
 <20140410143857.GA27654@localhost.localdomain>
 <CAKohpomMhpGsYGafr5uZ0QgO0MEndqDA4G=4syhus4sZW3d8cg@mail.gmail.com>
 <20140411145333.GC3438@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411145333.GC3438@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 04:53:35PM +0200, Frederic Weisbecker wrote:
> On Fri, Apr 11, 2014 at 03:34:23PM +0530, Viresh Kumar wrote:
> > On 10 April 2014 20:09, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > > index 9f8af69..1e2d6b7 100644
> > > --- a/kernel/time/tick-sched.c
> > > +++ b/kernel/time/tick-sched.c
> > > @@ -202,13 +202,16 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now);
> > >  void __tick_nohz_full_check(void)
> > >  {
> > >         struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
> > > +       unsigned long flags;
> > >
> > > +       local_irq_save(flags);
> > 
> > As we need to disable interrupts to read this variable, would it be
> > better to just remove this completely and use is_idle_task(current)
> > instead?
> 
> I don't get what you mean. The goal was get read of the hammer is_idle_task()
> check, wasn't it?
> 
> Also irqs are disabled but this is fundamentaly not required as this can only be
> called by IPIs which always have irqs disabled.
> 
> Hmm I should add a WARN_ON_(!irqs_disabled()) though just in case.
> 
> > 
> > >         if (tick_nohz_full_cpu(smp_processor_id())) {
> > > -               if (ts->tick_stopped && !is_idle_task(current)) {
> > > +               if (ts->tick_stopped && !ts->inidle)) {
> > >                         if (!can_stop_full_tick())
> > >                                 tick_nohz_restart_sched_tick(ts, ktime_get());
> > >                 }
> > >         }
> > > +       local_irq_restore(flags);
> > >  }
> > 
> > > If you like it I'll push it to Ingo.
> > 
> > Yes please. And thanks for the explanations. It was pretty useful.
> > 
> > I am looking to offload 1 second tick to timekeeping CPUs and so
> > going through these frameworks. I don't have a working solution yet
> > (even partially :)). Would send a RFC to you as soon as I get anything
> > working.
> 
> I see. The only solution I can think of right now is to have the timekeeper call
> sched_class(current[$CPU])::scheduler_tick() on behalf of all full dynticks CPUs.
> 
> This sounds costly but can be done once per sec for each CPUs. Not sure if Peterz will
> like it but sending mockup RFC patches will tell us more about his opinion :)

I think there's assumptions that tick runs on the local cpu; also what
are you going to do when running it on all remote cpus takes longer than
the tick?

> Otherwise (and ideally) we need to make the scheduler code able to handle long periods without
> calling scheduler_tick(). But this is a lot more plumbing. And the scheduler has gazillions
> accounting stuffs to handle. Sounds like a big nightmare to take that direction.

So i'm not at all sure what you guys are talking about, but it seems to
me you should all put down the bong and have a detox round instead.

This all sounds like a cure worse than the problem.
