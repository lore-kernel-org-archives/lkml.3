Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3ITJ4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:56:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:39562 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab3ITJ4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:56:34 -0400
Date: Fri, 20 Sep 2013 11:56:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>, nicolas.ferre@atmel.com,
        LKML <linux-kernel@vger.kernel.org>, Marc Pignat <marc.pignat@hevs.ch>,
        john.stultz@linaro.org, kernel@pengutronix.de,
        Ronald Wahl <ronald.wahl@raritan.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clockevents: Sanitize ticks to nsec conversion
In-Reply-To: <20130919200343.GV24802@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1309201127400.4089@ionos.tec.linutronix.de>
References: <20130917130153.GL26819@ludovic.desroches@atmel.com> <alpine.DEB.2.02.1309172228400.4089@ionos.tec.linutronix.de> <20130918085627.GN24802@pengutronix.de> <alpine.DEB.2.02.1309181058470.4089@ionos.tec.linutronix.de> <20130918150958.GO24802@pengutronix.de>
 <alpine.DEB.2.02.1309182201000.4089@ionos.tec.linutronix.de> <20130919100239.GS24802@pengutronix.de> <alpine.DEB.2.02.1309191207460.4089@ionos.tec.linutronix.de> <20130919124805.GU24802@pengutronix.de> <alpine.DEB.2.02.1309191629040.4089@ionos.tec.linutronix.de>
 <20130919200343.GV24802@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1381942138-1379670810=:4089"
Content-ID: <alpine.DEB.2.02.1309201153550.4089@ionos.tec.linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1381942138-1379670810=:4089
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.02.1309201153551.4089@ionos.tec.linutronix.de>

On Thu, 19 Sep 2013, Uwe Kleine-König wrote:
> > +     u64 rnd = (u64) evt->mult - 1;
> >  
> >       if (unlikely(!evt->mult)) {
> >               evt->mult = 1;
> >               WARN_ON(1);
> >       }
> I suggest to move the assignment to rnd below this if block as it
> changes mult. 

True.

>  
> +     /*
> +      * Upper bound sanity check. If the backwards conversion is
> +      * not equal latch, we know that the above shift overflowed.
> +      */
> +     if (clc >> evt->shift) != (u64)latch)
You didn't compile test, did you? Also the cast on the rhs isn't needed.

I did. I just missed to refresh the patch before sending it :)

> > +	 * For mult <= (1 << shift) we can safely add mult - 1 to
> > +	 * prevent integer rounding loss. So the backwards conversion
> It doesn't prevent inexactness to add mult - 1. It (only) asserts that
> the ns2delta(delta2ns(latch)) >= latch instead of ... <= latch when not
> doing it.

For mult <= 1 << shift the conversion is always ending up with the
same latch value.
 
> > +	 * from nsec to device ticks will be correct.
> > +	 *
> > +	 * For mult > (1 << shift), i.e. device frequency is > 1GHz we
> > +	 * need to be careful. Adding mult - 1 will result in a value
> > +	 * which when converted back to device ticks will be larger
> s/will/can/

No, it will always be larger.

> > +	 * than latch by (mult / (1 << shift)) - 1. For the min_delta
> s/by/by up to/
> 
> > +	 * calculation we still want to apply this in order to stay
> > +	 * above the minimum device ticks limit. For the upper limit
> > +	 * we would end up with a latch value larger than the upper
> > +	 * limit of the device, so we omit the add to stay below the
> > +	 * device upper boundary.
> > +	 *
> > +	 * Also omit the add if it would overflow the u64 boundary.
> > +	 */
> > +	if ((~0ULL - clc > rnd) &&
> > +	    (!ismax || evt->mult <= (1U << evt->shift)))
> > +		clc += rnd;
> I would expect that
> 
> 	if (!ismax)
> 		if (~0ULL - clc > rnd)
> 			clc += rnd;
> 		else
> 			clc = ~0ULL;
> 
> is enough (and a tad more exact in the presence of an overflow). I have
> to think about that though.

Errm.

1) We cannot add if we'd overflow

2) For mult <= 1 << shift it's always correct

3) for mult > 1 << shift we only apply it to the min value not the max
 
> >  	clockevents_calc_mult_shift(dev, freq, sec);
> > -	dev->min_delta_ns = clockevent_delta2ns(dev->min_delta_ticks, dev);
> > -	dev->max_delta_ns = clockevent_delta2ns(dev->max_delta_ticks, dev);
> > +	dev->min_delta_ns = cev_delta2ns(dev->min_delta_ticks, dev, false);
> > +	dev->max_delta_ns = cev_delta2ns(dev->max_delta_ticks, dev, true);
> Another improvement that came to my mind just now. For min_delta_ns you
> want to assert that it results in a value >= min_delta_ticks when
> converted back. For max_delta_ns you want ... value <= max_delta_ticks.
> What about the values in between? They for sure should land in
> [min_delta_ticks ... max_delta_ticks] when converted back and ideally
> should be most exact. The latter part would mean to add (rnd / 2)
> instead of rnd. I don't know yet how that would behave at the borders of
> the [min_delta_ns ... max_delta_ns] interval, but I think you still need
> to special-case that.

Again:

1) For mult <= 1 << shift the backwards conversion is always the same as
   the input value.

2) For mult > 1 << shift the backwards conversion of the min value is
   always > than the input value. And the backwards conversion of the
   max value is always < than the input value.

The values between that are completely uninteresting as the
program_events code always converts from nsec to device ticks.

We clamp the delta between min_ns and max_ns. So due to the above any

   min_ns <= delta <= max_ns

will after conversion fulfil 

   min_tick <= delta_tick <= max_tick

So what are you going to improve? Either the math works or it does not.

Thanks,

	tglx
--8323329-1381942138-1379670810=:4089--
