Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab3ISKC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:02:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60188 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3ISKC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:02:57 -0400
Date: Thu, 19 Sep 2013 12:02:39 +0200
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
Message-ID: <20130919100239.GS24802@pengutronix.de>
References: <1379077365-18458-1-git-send-email-mkl@pengutronix.de>
 <20130917095600.GJ26819@ludovic.desroches@atmel.com>
 <20130917100417.GQ12758@n2100.arm.linux.org.uk>
 <alpine.DEB.2.02.1309171210450.4089@ionos.tec.linutronix.de>
 <20130917130153.GL26819@ludovic.desroches@atmel.com>
 <alpine.DEB.2.02.1309172228400.4089@ionos.tec.linutronix.de>
 <20130918085627.GN24802@pengutronix.de>
 <alpine.DEB.2.02.1309181058470.4089@ionos.tec.linutronix.de>
 <20130918150958.GO24802@pengutronix.de>
 <alpine.DEB.2.02.1309182201000.4089@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1309182201000.4089@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Thu, Sep 19, 2013 at 12:01:25AM +0200, Thomas Gleixner wrote:
> On Wed, 18 Sep 2013, Uwe Kleine-König wrote:
> > On Wed, Sep 18, 2013 at 11:38:07AM +0200, Thomas Gleixner wrote:
> > > On Wed, 18 Sep 2013, Uwe Kleine-König wrote:
> > > > Another doubt I have is: You changed clockevent_delta2ns to round up now
> > > > unconditionally. For the numbers on at91 that doesn't matter, but I
> > > > wonder if there are situations that make the timer core violate the
> > > > max_delta_ticks condition now.
> > > 
> > > And how so? The + (mult - 1) ensures, that the conversion back to
> > > ticks results in the same value as latch. So how should it violate
> > > the max boundary?
> > That is wrong:
> > With max_delta_ticks << shift = n * mult - k for k in [0 .. mult-1] and
> > an integer n:
> > 
> > 	  (max_delta_ns * mult) >> shift
> > 	= ((((max_delta_ticks << shift) + mult - 1) / mult) * mult) >> shift
> > 	= (((n * mult - k + mult - 1) / mult) * mult) >> shift
> > 	= n * mult >> shift
> > 	= ((max_delta_ticks << shift) + k) >> shift
> > 	= max_delta_ticks + (k >> shift)
> > 
> > k >> shift is only known to be zero if mult <= 1 << shift (i.e. the same
> > condition as above where your 64bit overflow detection is wrong). So
> > this can result in values > max_delta_ticks.
> 
> Right, should have waited for coffee actually activating the right
> brain cells.
> 
> So the rounding thing works nicely for mult <= (1 << sft). For the
> other cases the conversion is wrong by (mult / (1 << sft)) - 1. So for
> a 3 GHz clock it's off by 2. That's not an issue for the min value,
> but for the max value it might overflow the hardware limit. Not a real
> functional issue as we'd just get a pointless short interrupt, but for
> correctness reasons and for the sake of NOHZ we need to fix that.
Well, you're assuming here that this is how the hardware reacts. Might
be worse. But we're on the same side here, it should be fixed.
 
> There is no real correct solution for these cases, which will result
> in a correct backwards conversion. We could validate against the max
> delta ticks in program_event, but that adds another boundary check to
> the hotpath so I rather want to avoid it.
> 
> The simple solution is to check for the following in the conversion
> routine:
> 
>     if (latch == dev->min_delta_ticks || dev->mult <= (1 << dev->sft))
>        clc += mult - 1
I didn't do the necessary math, but I wouldn't be surprised if you'd
need to check for

	latch <= dev->min_delta_ticks + n

for some non-negative n.

Another simple solution is to apply the uprounding only for
min_delta_ticks -> min_delta_ns conversion, but not for the
max_delta_ticks -> max_delta_ns conversion. For the first you have to
guarantee not to yield lower values so round up, for the latter you must
not pass on bigger values so round down.
 
> That ensures, that we never violate the lower boundary independent of
> the mult/sft relation. For the max_delta_ticks conversion in the "mult
> > (1 << sft)" case we end up with a slightly smaller value, but well
> inside the boundaries and close enough to the hardware limitations.
Yeah, probably it's not worth to calculate the optimal value (actually
for both limits). Anyhow, I will check that on my next shopping tour :-)
 
> Versus the 64bit overflow check, we need to be even more careful. We
> need to check for overflowing (1 << 63) - 1 (i.e. the max positive
> value which fits into a s64). See clockevents_program_event().
That is because you interpret times < 0 as in the past, right? But note
that the interim result we're talking about here is still to be divided
by evt->mult. So assuming mult > 1, that check is too strict unless you
move it below the do_div in clockevent_delta2ns. For sure it makes sense
to use the same value for a and b in the handling:

	if (calculatedval overflows a)
		calculatedval = b

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
