Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaDWMYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:24:54 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:40348 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaDWMYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:24:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokPSVTJ5rupW8vM0btgtc9S6bWdgCdDkn6qHK5SfcGX0A@mail.gmail.com>
References: <CAKohpokPSVTJ5rupW8vM0btgtc9S6bWdgCdDkn6qHK5SfcGX0A@mail.gmail.com>
Date: Wed, 23 Apr 2014 17:54:51 +0530
Message-ID: <CAM4v1pMRiWkUx0YboOkcYXDt=quXiR7FWs0b=HjzbRG+sdnPFA@mail.gmail.com>
Subject: Re: [Query]: hrtimers: why don't we consider hrtimers in get_next_timer_interrupt()
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Wed, Apr 23, 2014 at 3:08 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Hi,
>
> File: hrtimer.c
> Function: hrtimer_get_next_event()
>
> I was looking closely at what's waking up my system and
> found this piece of code:
>
> ktime_t hrtimer_get_next_event(void)
> {
>         if (!hrtimer_hres_active()) {
>                 find next hrtimer event ....
>         }
> }
>
> Which probably means that: "don't consider hrtimers for getting
> next timer event if we are running ticks in high resolution mode".
>
> And I couldn't understand why is it so?

In case of high resolution mode, the clock device would have
already been programmed for the upcoming hrtimer, the last
time the list of hrtimers was evaluated. So we have
already taken care of hrtimers to expire next.

Note that in high resolution mode as long as the
cpu is busy we queue the tick_sched_timer at the next
periodic tick.

Having said the above:
The above mentioned function is called from cmp_next_hrtimer_event()
when the scheduler tick needs to be stopped in dynamic tick mode.
We now need to know the next appropriate time to setup
the tick_sched_timer in high resolution mode and this has to co-incide
at a periodic tick granularity. As long as the cpu was busy we were
queuing it at the very next tick. But now that the cpu is going idle,
we need to see the next opportune multiple of periodic tick to queue
this timer at.

That is nothing but the time at which the next *timer wheel event*
is set to expire. In high resolution mode, the tick_sched_timer is
queued at this time while in low resolution mode the clock device
is programmed for this time.
(Also note that in high resolution mode,if any hrtimer was to
expire before the next timer wheel event, the cpu would exit idle
and restart tick_sched_timer at the next period again.)

So the purpose of hrtimer_get_next_event() is merely to tell
you the next timer wheel event. If the system is in high resolution
mode, then we do not need to probe the hrtimers for the reason
mentioned above: that would have been taken care of in the
previous hrtimer_interrupt() call or hrtimer_start() function. We
only need to know the time at which tick_sched_timer needs to
be queued and for that the timer wheel is sufficient to probe.

In low resolution mode however we need to explicitly go through
the hrtimer list since its a part and parcel of the timer wheel
events.


Regards
Preeti U Murthy

>
> When hres_active isn't set, we run hrtimer handlers from timer
> handlers, which means that timers would be sufficient in finding
> the next event and we don't need to check for hrtimers.
>
> But when hres_active is set, hrtimers could be set to fire before
> the next timer event and so we must take them into account.
>
> I am new to this whole world of core frameworks and might be
> missing something very very obvious. But its always better to
> ask than to ignore and think that things are probably fine and
> just shut up.
>
> Thanks for your patience during my learning curve :)
>
> --
> viresh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
