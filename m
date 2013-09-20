Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3ITUlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:41:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45957 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab3ITUll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:41:41 -0400
Date: Fri, 20 Sep 2013 22:41:25 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>, nicolas.ferre@atmel.com,
        LKML <linux-kernel@vger.kernel.org>, Marc Pignat <marc.pignat@hevs.ch>,
        john.stultz@linaro.org, kernel@pengutronix.de,
        Ronald Wahl <ronald.wahl@raritan.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clockevents: Sanitize ticks to nsec conversion
Message-ID: <20130920204125.GB16106@pengutronix.de>
References: <20130918085627.GN24802@pengutronix.de>
 <alpine.DEB.2.02.1309181058470.4089@ionos.tec.linutronix.de>
 <20130918150958.GO24802@pengutronix.de>
 <alpine.DEB.2.02.1309182201000.4089@ionos.tec.linutronix.de>
 <20130919100239.GS24802@pengutronix.de>
 <alpine.DEB.2.02.1309191207460.4089@ionos.tec.linutronix.de>
 <20130919124805.GU24802@pengutronix.de>
 <alpine.DEB.2.02.1309191629040.4089@ionos.tec.linutronix.de>
 <20130919200343.GV24802@pengutronix.de>
 <alpine.DEB.2.02.1309201127400.4089@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1309201127400.4089@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Fri, Sep 20, 2013 at 11:56:27AM +0200, Thomas Gleixner wrote:
> On Thu, 19 Sep 2013, Uwe Kleine-König wrote:
> > > +	 * For mult <= (1 << shift) we can safely add mult - 1 to
> > > +	 * prevent integer rounding loss. So the backwards conversion
> > It doesn't prevent inexactness to add mult - 1. It (only) asserts that
> > the ns2delta(delta2ns(latch)) >= latch instead of ... <= latch when not
> > doing it.
> 
> For mult <= 1 << shift the conversion is always ending up with the
> same latch value.
Ah right, I missed that we're in the slow-clock-case.

> > > +	 * from nsec to device ticks will be correct.
> > > +	 *
> > > +	 * For mult > (1 << shift), i.e. device frequency is > 1GHz we
> > > +	 * need to be careful. Adding mult - 1 will result in a value
> > > +	 * which when converted back to device ticks will be larger
> > s/will/can/
> 
> No, it will always be larger.
Hmm, consider a 1.25 GHz clock with shift = 2 and mult = 5. Then
ns2clc(clc2ns(1000)) = 1000. So it's not always larger!
In the fast-clock-case we have:
With x << shift = n * mult - k for k in [0 .. mult-1] and an integer n:

	  ns2clc(clc2ns(x))
	= ns2clc(((x << shift) + mult - 1) / mult)
	= ((((x << shift) + mult - 1) / mult) * mult) >> shift
	= n * mult >> shift
	= ((x << shift) + k) >> shift
	= x + (k >> shift)

So ns2clc(clc2ns(x)) = x for all x > 0 that have

	k = mult - ((x << shift) - 1) % mult - 1 < 1 << shift

So my correction still stands.
 
> > > +	 * than latch by (mult / (1 << shift)) - 1. For the min_delta
> > s/by/by up to/
>From the calculation above you can also see that this term is wrong. k
is smaller than mult (and there are values that realize k = mult - 1).
So the converted back value can be larger than latch by up to
(mult - 1) >> shift. This is zero for the slow-clock-case.

In the 1.25 GHz example above that means that the difference is up to 1,
not 0 as your term would imply. 1004 is an example where the conversion
to nano seconds and back to ticks results in a difference of 1.

> > > +	 * calculation we still want to apply this in order to stay
> > > +	 * above the minimum device ticks limit. For the upper limit
> > > +	 * we would end up with a latch value larger than the upper
> > > +	 * limit of the device, so we omit the add to stay below the
> > > +	 * device upper boundary.
> > > +	 *
> > > +	 * Also omit the add if it would overflow the u64 boundary.
> > > +	 */
> > > +	if ((~0ULL - clc > rnd) &&
> > > +	    (!ismax || evt->mult <= (1U << evt->shift)))
> > > +		clc += rnd;
> > I would expect that
> > 
> > 	if (!ismax)
> > 		if (~0ULL - clc > rnd)
> > 			clc += rnd;
> > 		else
> > 			clc = ~0ULL;
> > 
> > is enough (and a tad more exact in the presence of an overflow). I have
> > to think about that though.
> 
> Errm.
> 
> 1) We cannot add if we'd overflow
> 
> 2) For mult <= 1 << shift it's always correct
> 
> 3) for mult > 1 << shift we only apply it to the min value not the max
Yeah, I didn't say your code is wrong *here*. I just think that my
easier (and so probably faster) code is good enough.
 
> > >  	clockevents_calc_mult_shift(dev, freq, sec);
> > > -	dev->min_delta_ns = clockevent_delta2ns(dev->min_delta_ticks, dev);
> > > -	dev->max_delta_ns = clockevent_delta2ns(dev->max_delta_ticks, dev);
> > > +	dev->min_delta_ns = cev_delta2ns(dev->min_delta_ticks, dev, false);
> > > +	dev->max_delta_ns = cev_delta2ns(dev->max_delta_ticks, dev, true);
> > Another improvement that came to my mind just now. For min_delta_ns you
> > want to assert that it results in a value >= min_delta_ticks when
> > converted back. For max_delta_ns you want ... value <= max_delta_ticks.
> > What about the values in between? They for sure should land in
> > [min_delta_ticks ... max_delta_ticks] when converted back and ideally
> > should be most exact. The latter part would mean to add (rnd / 2)
> > instead of rnd. I don't know yet how that would behave at the borders of
> > the [min_delta_ns ... max_delta_ns] interval, but I think you still need
> > to special-case that.
> 
> Again:
> 
> 1) For mult <= 1 << shift the backwards conversion is always the same as
>    the input value.
> 
> 2) For mult > 1 << shift the backwards conversion of the min value is
>    always > than the input value. And the backwards conversion of the
>    max value is always < than the input value.
> 
> The values between that are completely uninteresting as the
> program_events code always converts from nsec to device ticks.
> 
> We clamp the delta between min_ns and max_ns. So due to the above any
> 
>    min_ns <= delta <= max_ns
> 
> will after conversion fulfil 
> 
>    min_tick <= delta_tick <= max_tick
> 
> So what are you going to improve? Either the math works or it does not.
Right, my idea is nice, but useless.

So I suggest you resend your patch with the compile fix and the
corrected comment and I will think about my suggestion to simplify the
if condition independently as it's only a small runtime improvent and so
not important enough to stop the correctness issue your patch is fixing.

Best regards and thanks for the nice discussion,
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
