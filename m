Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3IRWBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 18:01:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:33281 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3IRWBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 18:01:33 -0400
Date: Thu, 19 Sep 2013 00:01:25 +0200 (CEST)
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
In-Reply-To: <20130918150958.GO24802@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1309182201000.4089@ionos.tec.linutronix.de>
References: <1379077365-18458-1-git-send-email-mkl@pengutronix.de> <20130917095600.GJ26819@ludovic.desroches@atmel.com> <20130917100417.GQ12758@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1309171210450.4089@ionos.tec.linutronix.de> <20130917130153.GL26819@ludovic.desroches@atmel.com>
 <alpine.DEB.2.02.1309172228400.4089@ionos.tec.linutronix.de> <20130918085627.GN24802@pengutronix.de> <alpine.DEB.2.02.1309181058470.4089@ionos.tec.linutronix.de> <20130918150958.GO24802@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1268994594-1379541686=:4089"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1268994594-1379541686=:4089
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 18 Sep 2013, Uwe Kleine-König wrote:
> On Wed, Sep 18, 2013 at 11:38:07AM +0200, Thomas Gleixner wrote:
> > On Wed, 18 Sep 2013, Uwe Kleine-König wrote:
> > > Another doubt I have is: You changed clockevent_delta2ns to round up now
> > > unconditionally. For the numbers on at91 that doesn't matter, but I
> > > wonder if there are situations that make the timer core violate the
> > > max_delta_ticks condition now.
> > 
> > And how so? The + (mult - 1) ensures, that the conversion back to
> > ticks results in the same value as latch. So how should it violate
> > the max boundary?
> That is wrong:
> With max_delta_ticks << shift = n * mult - k for k in [0 .. mult-1] and
> an integer n:
> 
> 	  (max_delta_ns * mult) >> shift
> 	= ((((max_delta_ticks << shift) + mult - 1) / mult) * mult) >> shift
> 	= (((n * mult - k + mult - 1) / mult) * mult) >> shift
> 	= n * mult >> shift
> 	= ((max_delta_ticks << shift) + k) >> shift
> 	= max_delta_ticks + (k >> shift)
> 
> k >> shift is only known to be zero if mult <= 1 << shift (i.e. the same
> condition as above where your 64bit overflow detection is wrong). So
> this can result in values > max_delta_ticks.

Right, should have waited for coffee actually activating the right
brain cells.

So the rounding thing works nicely for mult <= (1 << sft). For the
other cases the conversion is wrong by (mult / (1 << sft)) - 1. So for
a 3 GHz clock it's off by 2. That's not an issue for the min value,
but for the max value it might overflow the hardware limit. Not a real
functional issue as we'd just get a pointless short interrupt, but for
correctness reasons and for the sake of NOHZ we need to fix that.

There is no real correct solution for these cases, which will result
in a correct backwards conversion. We could validate against the max
delta ticks in program_event, but that adds another boundary check to
the hotpath so I rather want to avoid it.

The simple solution is to check for the following in the conversion
routine:

    if (latch == dev->min_delta_ticks || dev->mult <= (1 << dev->sft))
       clc += mult - 1

That ensures, that we never violate the lower boundary independent of
the mult/sft relation. For the max_delta_ticks conversion in the "mult
> (1 << sft)" case we end up with a slightly smaller value, but well
inside the boundaries and close enough to the hardware limitations.

Versus the 64bit overflow check, we need to be even more careful. We
need to check for overflowing (1 << 63) - 1 (i.e. the max positive
value which fits into a s64). See clockevents_program_event().

So this check needs to be:

   u64 clc = (u64)latch << sft;

   if ((s64)clc < 0 || (clc >> sft ) != latch)
      clc = (1 << 63) - 1;

   And the above rounding magic, which has to be applied after this
   needs to take the following condition into account as well:

    (1 << 63) - 1 - clc >= mult - 1

    If that's not true, we can't do the rounding add, but we know that
    we are well at the upper limit of the hardware, so no issue
    either.

> > > > for boundary violation and can limit "clc" to (1 << 63) - 1 before the
> > > Where does this magic constant come from?
> > 
> > Rolling my magic hex dice gave me that.
> Wow, how many sides does your dice have? Couldn't it have choosen
> (u64)-1 for improved results?

No it's restricted to s64 positiv values due to software
limitations. See above.

Thanks,

	tglx
--8323329-1268994594-1379541686=:4089--
