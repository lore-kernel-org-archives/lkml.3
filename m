Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab3G3LoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:44:05 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:45625 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3G3LoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130730093519.GP3008@twins.programming.kicks-ass.net>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com>
	<alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de>
	<CABawtvP4oLuvHOS3prbbgPShXVziV_wTo7i6KCqJ9KkoVdz0ag@mail.gmail.com>
	<20130730093519.GP3008@twins.programming.kicks-ass.net>
Date: Tue, 30 Jul 2013 19:44:03 +0800
Message-ID: <CABawtvNVeHbe06tbuH6Khgp_5gYmRYtk=sz9U7oE8f_x+6yg1g@mail.gmail.com>
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, johlstei@codeaurora.org,
        Yinghai Lu <yinghai@kernel.org>, Jin Feng <joe.jin@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 5:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Jul 30, 2013 at 05:12:49PM +0800, Ethan Zhao wrote:
> > On Mon, Jul 29, 2013 at 6:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > The test case does not involve anything hrtimer related. Do you have
> > > CONFIG_SCHED_HRTICK enabled?
> > >
> >
> > Yes.  it is default configured in stable release.
> > CONFIG_SCHED_HRTICK=y
>
> Should still be disabled by default even if supported:
>
> # grep HRTICK kernel/sched/features.h
> SCHED_FEAT(HRTICK, false)
>
>
> > > First of all we want to know, which particular hrtimer is causing that
> > > issue. If it is the hrtick one, then I really have to ask why you want
> > > to use it at all in such a high performance scenario.
> > >
> > >  Any advice about the HZ in high performance scenario ? hrtimer tick
> > Is not fit for high performance ?
>
> Hence why its disabled, programming the timer hardware is too expensive.
> But since you didn't even know that I suspect you aren't in fact using
> it.
>
Got it.
what tglx and you mean

 SCHED_FEAT(HRTICK, 0)

 then no hrtimer operation in
  void __sched __schedule(void)
   {
      … …
    if (sched_feat(HRTICK))
hrtick_clear(rq);
      … …

Yup, So what I am facing is not HRTICK.
But that doesn't move my eyes away from hrtimer and suspect
reprogramming delay the scheduling.
The call stack looks like following :

 cpu_idle()
 {
  … …
  tick_nohz_stop_sched_tick()
    --> hrtimer_start(); --> __hrtimer_start_range_ns() -- > remove_hrtimer()
    -- > raise_softirq_irqoff(TIMER_SOFTIRQ);
---->run_timer_softirq() --> tick_sched_timer() -- >
hrtimer_start_expires
  … …

  … ...
  tick_nohz_restart_sched_tick()
  … ...
  schedule()
  … ...
 }

So the expensive thing maybe not inside the schedule(), but could
outside the scheduler(), the more bigger forever loop.

This is one part of what I am facing.

Thanks
Ethan

>
> It would be good if you could do what Thomas suggested and look at which
> timer is actually active during your workload.
