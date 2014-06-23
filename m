Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaFWLDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:03:16 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:44374 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbaFWLDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:03:15 -0400
X-Yandex-Uniq: 7dd882a4-4845-47d4-917a-d2040fa130a9
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Mon, 23 Jun 2014 15:03:02 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john.stultz@linaro.org, prarit@redhat.com, paul.gortmaker@windriver.com,
        juri.lelli@gmail.com, ddaney.cavm@gmail.com, mbohan@codeaurora.org,
        david.vrabel@citrix.com, david.engraf@sysgo.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hrtimers: calculate expires_next after all timers are
 executed
Message-ID: <20140623110302.GA20225@stfomichev-desktop.yandex.net>
References: <1395067037-20060-1-git-send-email-stfomichev@yandex-team.ru>
 <alpine.DEB.2.02.1403191149460.18573@ionos.tec.linutronix.de>
 <20140319141615.GB11081@stfomichev-desktop.yandex.net>
 <alpine.DEB.2.10.1406221417510.5170@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406221417510.5170@nanos>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> 
> + * @next:              time of the next event on this clock base
> 
> What initializes that? It's 0 to begin with.
I thought I can skip initialization because I update base->next
in the interrupt or in __remove_hrtimer, like:
- enqueue_timer, base->next is 0
- reprogram device
- device fires -> hrtimer_interrupt
- __run_hrtimer
- __remove_hrtimer
- if last base->next = KTIME_MAX
- otherwise base->next = ktime_sub(hrtimer_get_expires(timer), base->offset)
  in hrtimer_interrupt

> > @@ -893,6 +895,10 @@ static int enqueue_hrtimer(struct hrtimer *timer,
> >  	 */
> >  	timer->state |= HRTIMER_STATE_ENQUEUED;
> >  
> > +	expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
> 
> This does not work when time gets set and the offset changes. We need
> to store the absolute expiry time and subtract the offset at
> evaluation time.
Hm, looking at this code after a while it seems I don't need to update
base->next in enqueue_hrtimer. It's enough to set it to KTIME_MAX in
__remove_hrtimer or to actual value upon breaking from __run_hrtimer
loop in hrtimer_interrupt.

> > @@ -929,8 +935,10 @@ static void __remove_hrtimer(struct hrtimer *timer,
> >  		}
> >  #endif
> >  	}
> > -	if (!timerqueue_getnext(&base->active))
> > +	if (!timerqueue_getnext(&base->active)) {
> >  		base->cpu_base->active_bases &= ~(1 << base->index);
> > +		base->next = ktime_set(KTIME_SEC_MAX, 0);
> > +	}
> 
> And what updates base->next if there are timers pending?
See above, hrtimer_interrupt updates it before breaking or sets to
KTIME_MAX in __remove_hrtimer if it's the last one.

> > +	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
> > +		ktime_t expires;
> 
> So this adds the third incarnation of finding the next expiring timer
> to the code. Not really helpful.
Didn't really think about all the other places, refactoring may come in
another patch.

> Untested patch which addresses the issues below.
Aside from a small nitpick below, looks reasonable, I'll try to run it on a
couple of machines.
Should I send you a v3 afterwards with the changelog or
tested-by would be enough?

> +	while (active) {
> +		idx = __ffs(active);
> +		active &= ~(1UL << idx);
Is there any reason you did that instead of conventional:
	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
		if (!(cpu_base->active_bases & (1 << i)))
			continue;

		...
	}
