Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab3IRPKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:10:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55868 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3IRPKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:10:11 -0400
Date: Wed, 18 Sep 2013 17:09:58 +0200
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
Message-ID: <20130918150958.GO24802@pengutronix.de>
References: <1379077365-18458-1-git-send-email-mkl@pengutronix.de>
 <20130917095600.GJ26819@ludovic.desroches@atmel.com>
 <20130917100417.GQ12758@n2100.arm.linux.org.uk>
 <alpine.DEB.2.02.1309171210450.4089@ionos.tec.linutronix.de>
 <20130917130153.GL26819@ludovic.desroches@atmel.com>
 <alpine.DEB.2.02.1309172228400.4089@ionos.tec.linutronix.de>
 <20130918085627.GN24802@pengutronix.de>
 <alpine.DEB.2.02.1309181058470.4089@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1309181058470.4089@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Wed, Sep 18, 2013 at 11:38:07AM +0200, Thomas Gleixner wrote:
> On Wed, 18 Sep 2013, Uwe Kleine-König wrote:
> > > Now we can easily verify whether the whole equation fits into the
> > > 64bit boundary. Shifting the "clc" result back by evt->shift MUST
> > > result in "latch". If that's not the case, we have a clear indicator
> > But this is only the case if evt->mult is <= (1 << evt->shift). Is this
> > always given?
> 
> Crap, no. It's only true for device frequency <= 1GHz. Good catch!
> 
> > Is it more sensible to adjust dev->max_delta_ns once at register time
> > and so save the often recurrent overflow check in
> > clockevents_program_event?
> 
> Which overflow check are you talking about?
> 
> There is only the boundary check:
> 
>         delta = min(delta, (int64_t) dev->max_delta_ns);
>         delta = max(delta, (int64_t) dev->min_delta_ns);
> 
> Which sensible adjustment at register time is going to remove that?
My idea was that wouldn't need to add

	if ((clc >> evt->shift) != (u64)latch)
		...

to clockevent_delta2ns (not clockevents_program_event as I wrote) if
dev->max_delta_ns was small enough. So max_delta_ns would be the minimum
of the hardware limit and the value to prevent an overflow. Not sure any
more that this works though.

> > Another doubt I have is: You changed clockevent_delta2ns to round up now
> > unconditionally. For the numbers on at91 that doesn't matter, but I
> > wonder if there are situations that make the timer core violate the
> > max_delta_ticks condition now.
> 
> And how so? The + (mult - 1) ensures, that the conversion back to
> ticks results in the same value as latch. So how should it violate
> the max boundary?
That is wrong:
With max_delta_ticks << shift = n * mult - k for k in [0 .. mult-1] and
an integer n:

	  (max_delta_ns * mult) >> shift
	= ((((max_delta_ticks << shift) + mult - 1) / mult) * mult) >> shift
	= (((n * mult - k + mult - 1) / mult) * mult) >> shift
	= n * mult >> shift
	= ((max_delta_ticks << shift) + k) >> shift
	= max_delta_ticks + (k >> shift)

k >> shift is only known to be zero if mult <= 1 << shift (i.e. the same
condition as above where your 64bit overflow detection is wrong). So
this can result in values > max_delta_ticks.

> Math is hard, right?
Yes, if it involves integer division and overflow handling it's hard to
come up with correct solutions during shopping. ;-)
 
> > > for boundary violation and can limit "clc" to (1 << 63) - 1 before the
> > Where does this magic constant come from?
> 
> Rolling my magic hex dice gave me that.
Wow, how many sides does your dice have? Couldn't it have choosen
(u64)-1 for improved results?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
