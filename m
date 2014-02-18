Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaBRWdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:33:42 -0500
Received: from www.linutronix.de ([62.245.132.108]:46448 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaBRWdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:33:40 -0500
Date: Tue, 18 Feb 2014 23:33:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Perevalov <a.perevalov@samsung.com>
cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        anton@enomsg.org, kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
In-Reply-To: <5303B910.5090009@samsung.com>
Message-ID: <alpine.DEB.2.02.1402182209500.4468@ionos.tec.linutronix.de>
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com> <52DEC6A3.9020600@linaro.org> <52E606D8.6000401@samsung.com> <alpine.DEB.2.02.1402041419420.24986@ionos.tec.linutronix.de> <52F1DDA8.90605@samsung.com> <alpine.DEB.2.02.1402051229260.24986@ionos.tec.linutronix.de>
 <52F2B504.5010403@linaro.org> <alpine.DEB.2.02.1402052306580.24986@ionos.tec.linutronix.de> <52F3C8A5.708@samsung.com> <alpine.DEB.2.02.1402062148440.21991@ionos.tec.linutronix.de> <5300D752.5030403@samsung.com> <alpine.DEB.2.02.1402161634590.21991@ionos.tec.linutronix.de>
 <5303B910.5090009@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014, Alexey Perevalov wrote:
> On 02/16/2014 07:39 PM, Thomas Gleixner wrote:
> I figured out with deviation, I described before.

Which is wrong to begin with. Using the wrong method does not justify
the results. Are you actually trying to understand what I'm saying?

> It was due expires and especially softexpires is fixed (don't base on delay).

That's how an interval timer is supposed to work by definition. End of
discussion.

> For example if we have a timer like this:
> hrtimer_expire_entry: hrtimer=ffffffffa056f280 function=timerfd_tmrproc
> [hrtimers_mod] now=191450988244 expires=191400000000 softexpires=191400000000
> It was fired at 191450988244, but softexpire is  191400000000, 50ms delay, if
> I'm not wrong.
> Next trigger time is 191700000000, (hrtimer_start: hrtimer=ffffffffa056f280
> function=timerfd_tmrproc [hrtimers_mod] expires=191700000000
> softexpires=191700000000)
> and if there is no cpu idle at next time, we'll get 250ms interval for such
> timer.

This is complete nonsense. You schedule your hrtimer on an absolute
timeline:

191400000000
191700000000
...

So it's supposed to fire every 300ms, but it is allowed to fire later
when the system is idle. And that's what it does. If the system would
be idle for 10.3 seconds from the point where the timer is started
then it would expire the first timer at

191400000000 + 10 sec = 201400000000

and then schedule the next one at

201400000000 + 300ms = 201700000000

So if your system is not idle the timer can be expired. That's the
same for deferrable timer list timers. We expire them when a non
deferrable timer fires.

And you do the same for your timer list timer according to your trace:

expires=4298169903
expires=4298169978
expires=4298170053
expires=4298170128
expires=4298170204
expires=4298170287
expires=4298170362
expires=4298170462
expires=4298170558
expires=4298170637
expires=4298170712
expires=4298170787
expires=4298170862

The delta is always 75 ticks. And the expiry times are 

now=4298169903
now=4298169978
now=4298170053
now=4298170129
now=4298170212
now=4298170287
now=4298170387
now=4298170483
now=4298170562
now=4298170637
now=4298170712
now=4298170787

Which results in the deferrements:

Delta:   0.0ms
Delta:   0.0ms
Delta:   0.0ms
Delta:   1.0ms
Delta:   8.0ms
Delta:   0.0ms
Delta:  25.0ms
Delta:  21.0ms
Delta:   4.0ms
Delta:   0.0ms
Delta:   0.0ms
Delta:   0.0ms

Avg:  	 4.0ms

And why? Because you scheduled your timer along an absolute
timeline. And if you use an absolute timeline, then the deltas between
the actual timer events are completely irrelevant. The only thing what
matters is the delta between the expected and the real expiry time.

Is it really that hard to understand?

> But we want 300ms or more for DEFERRABLE timer.

And I want a pony!

If you want that then simply setup the timer in relative oneshot mode,
i.e. interval = 0 and when it expires (deferred) rearm it relative to
now from user space. Then you get exactly the behaviour you want. It's
that simple, really.

> Thomas what do you think about moving format expire/softexpire to _!now!_ in
> run_hrtimer, right before we
> invoke callback function? The prolongation of hrtimer usually comes from user
> timer functions by
> invoking hrtimer_forward, which moves expires/softexpires forward.

You really don't want to know what I think about that.

> +       trace_hrtimer_expire_entry(timer, now, 0);
> +
> +       if (deferrable)
> +               hrtimer_set_expires(timer, *now);
>         restart = fn(timer);
> 
> 
> I got expected results (timer interval is 300ms):

So you got your pony. But it's your private pony and it stays that
way, because you made the timer interval relative. And you managed to
do that in the most disgusting way.

In course of that you broke the behaviour of the existing user space
interfaces. You can do so in your own hackery, but it's not going to
go near mainline.

Read and understand:

   man timer_create
   man timerfd

along with the relevant standards.

And if you need further education feel free to get a lecture from
Linus about user space interfaces or google one if you really want to
know how that works out.

We are not going to special case that deferrable stuff, simply because
it breaks the user space interfaces and you can solve your issue with
the existing user space interfaces already.

There is a simple solution for the problem. You just need to
understand what you try to solve and use the proper mechanisms. And
don't tell me you can't do that, because you need to modify your user
space code anyway as CLOCK*DEFERRABLE does not exist yet.

Just because you can do it in the kernel does not mean that it is the
correct approach.

Thanks,

	tglx
