Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaLQPnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:43:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:55184 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaLQPnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:43:01 -0500
Date: Wed, 17 Dec 2014 16:42:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti Murthy <preeti.lkml@gmail.com>
cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
In-Reply-To: <CAM4v1pNGHOg5JCpAJqKDPa4NTWHGT_urs9HoamD2dwsrfB4xoQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412171632470.17382@nanos>
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com> <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com> <548E8D01.9050707@linux.vnet.ibm.com> <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com> <20141215234443.GA23297@lerouge>
 <CAKohpokOuOqvpNt4_y2tHPTM8nKLyEg=-gN4NDe1_mqpy=Vrow@mail.gmail.com> <548FFD20.1040102@linux.vnet.ibm.com> <alpine.DEB.2.11.1412161105470.17382@nanos> <CAM4v1pNGHOg5JCpAJqKDPa4NTWHGT_urs9HoamD2dwsrfB4xoQ@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Preeti Murthy wrote:
> On Tue, Dec 16, 2014 at 6:19 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > So the possible states are:
> >
> >  ts->inidle     ts->tick_stopped
> >  0              0               valid
> >  0              1               BUG
> >  1              0               valid
> >  1              1               valid
> >
> > And we are transitioning in and out of that via:
> >
> >     tick_nohz_idle_enter()
> >         ts->inidle = true;
> >         if (stop_possible)
> >           stop_tick(ts)
> >
> >     tick_nohz_idle_exit()
> >         ts->inidle = false;
> >         if (ts->tick_stopped)
> >            start_tick(ts)
> >
> > irq_exit needs to take care of the following situations if we are
> > inidle:
> >
> >     if (ts->tick_stopped) {
> >          if (stop_possible) {
> >             /* handle timer changes (earlier/later) */
> >             update_tick(ts);
> >          } else {
> >             kick_out_of_idle();
> >          }
> >     } else {
> >         if (stop_possible)
> >           stop_tick(ts)
> >     }
> 
> Just for my understanding, Isn't the entire above logic minus the
> update_tick() contained in __tick_nohz_idle_enter() ? And why

Yes, I just explained it formally.

> do we need to update ticks during irq_exit path? We do it during
> the irq_enter() path if ticks are stopped.

update_tick() has nothing to do with jiffies/timekeeping. Again:

tick_nohz_idle_enter()
  stop_tick()
idle()
  interrupt()
    irq_enter()
      update_timekeeping_and_jiffies()
    handler()
      modify_timer()
    irq_exit()
      /* handle timer changes (earlier/later) */
      update_tick(()
        check_whether_interrupt_has_modified_next_expiry_time()

> I do agree that the powerclamp driver has brought in a new scenario.
> But I do not find it to be a messy implementation of mimicking idle.
> Here is why:
> 
> Powerclamp driver injects idle duration when there is a need to
> stay within the power budget. This is a fair enough problem.
> Now for the implementation of the idle injection. Currently
> powerclamp schedules in an idle thread, when there is work in the rq.
> This means although the thread is idle, the CPU is not. It also requires
> the tick to be stopped, so that the idle period is not interrupted.
> 
> I looked at your patch for scheduling in an idle thread to solve this issue,
> but I think it will break things further. Because although it is an idle thread,
> it cannot belong to the idle sched class because the function of an idle task
> is to loop in cpu_idle(), calling into the idle governors and more extra frills,
> none of which are relevant to the powerclamp driver.

MY patch does nothing of that. It throttles sched_fair, which brings
the cpu to idle.

>    Don't you think that the one function that a thread should call into in the
> above situation is tick_nohz_idle_enter() ?

No thread except idle is ever supposed to call any of the
tick_nohz_idle functions. Period.
 
> Looking at the implementation of tick_nohz_idle_enter/exit() I see that
> fundamentally they declare the tick on that cpu to be idle and verify
> if they have to be stopped/restarted; exactly what powerclamp is asking for.

Just get it: powerclamp is abusing everything from RT scheduling to
the idle infrastructure with some homebrewn construct. It's wrong.

> Nothing here that critically mandates that the cpu calling it has to have no
> work on it.
> 
> I agree that tick_nohz_idle_enter()/exit() were meant to be used by the
> idle task alone when they were written. But I do not see why they
> cannot be used for the usecase that powerclamp brings to the table.
> They have the potential, which is why we are able to use
> the functions that they call into,  for nohz_full scenarios as well.
> tick_nohz_stop_sched_tick() for instance. This shows that they need
> not merely be used just before cpus go idle.

No. You are just fostering mindless crap instead of fixing it proper.
 
> For this reason, I suggest the below patch to fix this issue for the time
> being. Like you and Frederic pointed we need to depend on ts->inidle now.
> Basing the decision on the idleness of the cpu will no longer work.
> 
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 0699add..a31864d 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -361,9 +361,10 @@ static inline void tick_irq_exit(void)
>  {
>  #ifdef CONFIG_NO_HZ_COMMON
>         int cpu = smp_processor_id();
> +       struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
> 
>         /* Make sure that timer wheel updates are propagated */
> -       if ((idle_cpu(cpu) && !need_resched()) || tick_nohz_full_cpu(cpu)) {
> +       if (ts->inidle || tick_nohz_full_cpu(cpu)) {

So you pointlessly force that in tick_nohz_irq_exit() even if
need_resched() is set.

Stop this tinkering finally. I'm not going to apply anything of that
which just burdens crap on sane code to support powerclamp insanity.

You can hack what you want here, it's never going to be a sane
solution. Period.

Thanks,

	tglx
