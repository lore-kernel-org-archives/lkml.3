Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaLOXov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 18:44:51 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57254 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaLOXot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 18:44:49 -0500
Date: Tue, 16 Dec 2014 00:44:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
Message-ID: <20141215234443.GA23297@lerouge>
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com>
 <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com>
 <548E8D01.9050707@linux.vnet.ibm.com>
 <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 03:02:17PM +0530, Viresh Kumar wrote:
> On 15 December 2014 at 12:55, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> > Hi Viresh,
> >
> > Let me explain why I think this is happening.
> >
> > 1. tick_nohz_irq_enter/exit() both get called *only if the cpu is idle*
> > and receives an interrupt.
> 
> Bang on target. Yeah that's the part we missed while writing this patch :)
> 
> > 2. Commit 2a16fc93d2c9568e1, cancels programming of tick_sched timer
> > in its handler, assuming that tick_nohz_irq_exit() will take care of
> > programming the clock event device appropriately, and hence it would
> > requeue or cancel the tick_sched timer.
> 
> Correct.
> 
> > 3. But the intel_powerclamp driver injects an idle period only.
> > *The CPU however is not idle*. It has work on its runqueue and the
> > rq->curr != idle. This means that *tick_nohz_irq_enter()/exit() will not
> > get called on any interrupt*.
> 
> Still good..
> 
> > 4. As a consequence, when we get a hrtimer interrupt during the period
> > that the powerclamp driver is mimicking idle, the exit path of the
> > interrupt never calls tick_nohz_irq_exit(). Hence the tick_sched timer
> > that would have got removed due to the above commit will not get
> > enqueued back on for any pending timers that there might be. Besides
> > this, *jiffies never gets updated*.
> 
> Jiffies can be updated by any CPU and there is something called a control
> cpu with powerclamp driver. BUT we may have got interrupted before the
> powerclamp timer expired and so we are stuck in the
> 
> while (time_before(jiffies, target_jiffies))
> 
> loop for ever.
> 
> > Hope the above explanation makes sense.
> 
> Mostly good. Thanks for helping out.
> 
> Now, what's the right solution going forward ?
> 
> - Revert the offending commit ..
> - Or still try to avoid reprogramming if we can ..
> 
> This is what I could come up with to still avoid reprogramming of tick:
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index cc0a5b6f741b..49f4278f69e2 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -1100,7 +1100,7 @@ static enum hrtimer_restart
> tick_sched_timer(struct hrtimer *timer)
>                 tick_sched_handle(ts, regs);
> 
>         /* No need to reprogram if we are in idle or full dynticks mode */
> -       if (unlikely(ts->tick_stopped))
> +       if (unlikely(ts->tick_stopped && (is_idle_task(current) ||
> !ts->inidle)))
>                 return HRTIMER_NORESTART;
> 
>         hrtimer_forward(timer, now, tick_period);

So to summarize: I see it enqueues a timer then it loops on that timer expiration.
On that loop we stop the CPU and we expect the timer to fire and wake the thread up.
But if the delayed tick fires too early, before the timer actually
expires, then we go to sleep again because we haven't yet reached the delay,
but since tick_nohz_irq_exit() is only called on idle tasks and not for threads
like powerclamp, the tick isn't rescheduled to handle the remaining timer slice
so we sleep forever.

Hence if we really want to stop the tick when we mimic idle from powerclamp driver,
we must call tick_nohz_irq_exit() on irq exit to do it correctly.

It happened to work by accident before the commit because we were rescheduling the
tick from itself without tick_nohz_irq_exit() to cancel anything. And that restored
the periodic behaviour necessary to complete the delay.

So the above change is rather a hack than a solution.

We have several choices:

1) Revert the commit. But this has to be a temporary solution really. Powerclamp has
to be fixed and handle tick_nohz_irq_exit().

2) Remove powerclamp tick stop until somebody fixes it to handle nohz properly.

2) Fix it directly. But I believe there is a release that is going to miss the fix
and suffer the regression. Does the regression matter for anybody? Is powerclamp
meant for anything else than testing (I have no idea what it's used for)?

So to fix powerclamp to handle nohz correctly, tick_nohz_irq_exit() must be called
for both idle tasks and powerclamp kthreads. Checking ts->inidle can be a good way to match
both. That means we might need to use a reduced part of idle_cpu() to avoid redundant checks.
tick_irq_enter() must be called as well for powerclamp, in case it's the only CPU running, it
has to fixup the timekeeping alone.
