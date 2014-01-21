Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaAUPp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:45:27 -0500
Received: from flusers.ccur.com ([173.221.59.2]:50203 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754134AbaAUPp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:45:26 -0500
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jan 2014 10:45:25 EST
Date: Tue, 21 Jan 2014 10:40:03 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Muli Baron <muli.baron@gmail.com>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.12.6-rt9
Message-ID: <20140121154003.GA10999@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20131223225017.GA8623@linutronix.de>
 <1387900067.5490.33.camel@marge.simpson.net>
 <20140117170052.GF5785@linutronix.de>
 <1390014929.5444.38.camel@marge.simpson.net>
 <20140120211736.0c97418a@gandalf.local.home>
 <52DE160E.7080504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DE160E.7080504@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 01:39:10AM -0500, Muli Baron wrote:
> On 21/1/2014 04:17, Steven Rostedt wrote:
> > On Sat, 18 Jan 2014 04:15:29 +0100
> > Mike Galbraith <bitbucket@online.de> wrote:
> >
> >
> >>> So you also have the timers-do-not-raise-softirq-unconditionally.patch?
> >>
> >
> > People have been complaining that the latest 3.12-rt does not boot on
> > intel i7 boxes. And by reverting this patch, it boots fine.
> >
> > I happen to have a i7 box to test on, and sure enough, the latest
> > 3.12-rt locks up on boot and reverting the
> > timers-do-not-raise-softirq-unconditionally.patch, it boots fine.
> >
> > Looking into it, I made this small update, and the box boots. Seems
> > checking "active_timers" is not enough to skip raising softirqs. I
> > haven't looked at why yet, but I would like others to test this patch
> > too.
> >
> > I'll leave why this lets i7 boxes boot as an exercise for Thomas ;-)
> >
> > -- Steve
> >
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> >
> > diff --git a/kernel/timer.c b/kernel/timer.c
> > index 46467be..8212c10 100644
> > --- a/kernel/timer.c
> > +++ b/kernel/timer.c
> > @@ -1464,13 +1464,11 @@ void run_local_timers(void)
> >   		raise_softirq(TIMER_SOFTIRQ);
> >   		return;
> >   	}
> > -	if (!base->active_timers)
> > -		goto out;
> >
> >   	/* Check whether the next pending timer has expired */
> >   	if (time_before_eq(base->next_timer, jiffies))
> >   		raise_softirq(TIMER_SOFTIRQ);
> > -out:
> > +
> >   	rt_spin_unlock_after_trylock_in_irq(&base->lock);
> >
> >   }
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> While this might fix booting on i7 machines it kinds of defeats the 
> original purpose of this patch, which was to let NO_HZ_FULL work 
> properly with threaded interrupts. With the active_timers check removed 
> the timer interrupt keeps firing even though there is only one task 
> running on a specific processor, since it can't shut down the tick 
> because the ksoftirqd thread keeps getting scheduled (see the previous 
> thread "CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo" for the full 
> discussion).
> 
> -- Muli


Would something like this work?  This would get us past boot, which has
always been this strange, half initialized thing one has to tiptoe around.

-	if (!base->active_timers)
+	if (!base->active_timers && system_state == SYSTEM_RUNNING)

Joe

