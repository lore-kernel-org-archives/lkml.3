Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab3ISMsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:48:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51284 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3ISMsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:48:15 -0400
Date: Thu, 19 Sep 2013 14:48:05 +0200
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
Message-ID: <20130919124805.GU24802@pengutronix.de>
References: <20130917100417.GQ12758@n2100.arm.linux.org.uk>
 <alpine.DEB.2.02.1309171210450.4089@ionos.tec.linutronix.de>
 <20130917130153.GL26819@ludovic.desroches@atmel.com>
 <alpine.DEB.2.02.1309172228400.4089@ionos.tec.linutronix.de>
 <20130918085627.GN24802@pengutronix.de>
 <alpine.DEB.2.02.1309181058470.4089@ionos.tec.linutronix.de>
 <20130918150958.GO24802@pengutronix.de>
 <alpine.DEB.2.02.1309182201000.4089@ionos.tec.linutronix.de>
 <20130919100239.GS24802@pengutronix.de>
 <alpine.DEB.2.02.1309191207460.4089@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1309191207460.4089@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Thu, Sep 19, 2013 at 12:15:10PM +0200, Thomas Gleixner wrote:
> On Thu, 19 Sep 2013, Uwe Kleine-König wrote:
> > On Thu, Sep 19, 2013 at 12:01:25AM +0200, Thomas Gleixner wrote:
> > > Versus the 64bit overflow check, we need to be even more careful. We
> > > need to check for overflowing (1 << 63) - 1 (i.e. the max positive
> > > value which fits into a s64). See clockevents_program_event().
> > 
> > That is because you interpret times < 0 as in the past, right? But note
> > that the interim result we're talking about here is still to be divided
> > by evt->mult. So assuming mult > 1, that check is too strict unless you
> > move it below the do_div in clockevent_delta2ns. For sure it makes sense
> > to use the same value for a and b in the handling:
> 
> No, it's not too strict.
> 
>     nsec = (latch << shift) / mult;
> 
> Now the backwards conversion does:
> 
>     latch = (nsec * mult) >> shift;
>
> So we want nsec * mult to be in the positive range of s64. Which
> means, that latch << shift must be in that range as well.
The backwards conversion is in clockevents_program_event(), right? There
is:

	clc = ((unsigned long long) delta * dev->mult) >> dev->shift;

So I don't see a problem if nsec * mult overflows (1 << 63) - 1 as long
as it still fits into an unsigned long long (i.e. a 64 bit value).

What am I missing?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
