Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbaFWRTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:19:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:45056 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaFWRTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:19:20 -0400
Date: Mon, 23 Jun 2014 19:19:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
cc: john.stultz@linaro.org, prarit@redhat.com, paul.gortmaker@windriver.com,
        juri.lelli@gmail.com, ddaney.cavm@gmail.com, mbohan@codeaurora.org,
        david.vrabel@citrix.com, david.engraf@sysgo.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hrtimers: calculate expires_next after all timers
 are executed
In-Reply-To: <20140623110302.GA20225@stfomichev-desktop.yandex.net>
Message-ID: <alpine.DEB.2.10.1406231904090.5170@nanos>
References: <1395067037-20060-1-git-send-email-stfomichev@yandex-team.ru> <alpine.DEB.2.02.1403191149460.18573@ionos.tec.linutronix.de> <20140319141615.GB11081@stfomichev-desktop.yandex.net> <alpine.DEB.2.10.1406221417510.5170@nanos>
 <20140623110302.GA20225@stfomichev-desktop.yandex.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014, Stanislav Fomichev wrote:
> > 
> > + * @next:              time of the next event on this clock base
> > 
> > What initializes that? It's 0 to begin with.
> I thought I can skip initialization because I update base->next
> in the interrupt or in __remove_hrtimer, like:
> - enqueue_timer, base->next is 0

Right, and that makes inconsistent state. We can do without such
magic, really.

> - reprogram device
> - device fires -> hrtimer_interrupt
> - __run_hrtimer
> - __remove_hrtimer
> - if last base->next = KTIME_MAX
> - otherwise base->next = ktime_sub(hrtimer_get_expires(timer), base->offset)
>   in hrtimer_interrupt
> 
> > > @@ -893,6 +895,10 @@ static int enqueue_hrtimer(struct hrtimer *timer,
> > >  	 */
> > >  	timer->state |= HRTIMER_STATE_ENQUEUED;
> > >  
> > > +	expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
> > 
> > This does not work when time gets set and the offset changes. We need
> > to store the absolute expiry time and subtract the offset at
> > evaluation time.

> Hm, looking at this code after a while it seems I don't need to update
> base->next in enqueue_hrtimer. It's enough to set it to KTIME_MAX in
> __remove_hrtimer or to actual value upon breaking from __run_hrtimer
> loop in hrtimer_interrupt.

Huch? Why don't you need to update in enqueue_hrtimer?

That's the whole point of this excercise.

hrtimer_interrupt()

 lock(cpu_base)    

 if (not_expired(base0))
      base0->next = expiry;
 
 if (expired(base1))
      unlock(cpu_base)			/* remote enqueue */
					lock(cpu_base)
      run_timer_fn()    		enqeueue_to(base0)
					unlock(cpu_base)
      lock(cpu_base)

 evaluate_base_next()

So in case the enqueued timer is earlier than base0->next, you are
looking at the wrong data. Same as in the current code and why you
started to look into this at all.

> > > @@ -929,8 +935,10 @@ static void __remove_hrtimer(struct hrtimer *timer,
> > >  		}
> > >  #endif
> > >  	}
> > > -	if (!timerqueue_getnext(&base->active))
> > > +	if (!timerqueue_getnext(&base->active)) {
> > >  		base->cpu_base->active_bases &= ~(1 << base->index);
> > > +		base->next = ktime_set(KTIME_SEC_MAX, 0);
> > > +	}
> > 
> > And what updates base->next if there are timers pending?
> See above, hrtimer_interrupt updates it before breaking or sets to
> KTIME_MAX in __remove_hrtimer if it's the last one.

See above WHY it does NOT work.
 
> > > +	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
> > > +		ktime_t expires;
> > 
> > So this adds the third incarnation of finding the next expiring timer
> > to the code. Not really helpful.
> Didn't really think about all the other places, refactoring may come in
> another patch.

No, we're not going to add another one in the first place as I know
how MAY COME works: it translates to NEVER, unless I do it myself.

> > Untested patch which addresses the issues below.
> Aside from a small nitpick below, looks reasonable, I'll try to run it on a
> couple of machines.
> Should I send you a v3 afterwards with the changelog or
> tested-by would be enough?

Tested-by is fine. I can cobble a changelog together.
 
> > +	while (active) {
> > +		idx = __ffs(active);
> > +		active &= ~(1UL << idx);
> Is there any reason you did that instead of conventional:

I thought about using __ffs before, just never came around it.

Thanks,

	tglx
