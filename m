Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3ISNMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:12:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:35812 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab3ISNMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:12:39 -0400
Date: Thu, 19 Sep 2013 15:12:34 +0200 (CEST)
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
In-Reply-To: <20130919124805.GU24802@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1309191500280.4089@ionos.tec.linutronix.de>
References: <20130917100417.GQ12758@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1309171210450.4089@ionos.tec.linutronix.de> <20130917130153.GL26819@ludovic.desroches@atmel.com> <alpine.DEB.2.02.1309172228400.4089@ionos.tec.linutronix.de> <20130918085627.GN24802@pengutronix.de>
 <alpine.DEB.2.02.1309181058470.4089@ionos.tec.linutronix.de> <20130918150958.GO24802@pengutronix.de> <alpine.DEB.2.02.1309182201000.4089@ionos.tec.linutronix.de> <20130919100239.GS24802@pengutronix.de> <alpine.DEB.2.02.1309191207460.4089@ionos.tec.linutronix.de>
 <20130919124805.GU24802@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1750308372-1379596355=:4089"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1750308372-1379596355=:4089
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 19 Sep 2013, Uwe Kleine-König wrote:
> On Thu, Sep 19, 2013 at 12:15:10PM +0200, Thomas Gleixner wrote:
> > On Thu, 19 Sep 2013, Uwe Kleine-König wrote:
> > > On Thu, Sep 19, 2013 at 12:01:25AM +0200, Thomas Gleixner wrote:
> > > > Versus the 64bit overflow check, we need to be even more careful. We
> > > > need to check for overflowing (1 << 63) - 1 (i.e. the max positive
> > > > value which fits into a s64). See clockevents_program_event().
> > > 
> > > That is because you interpret times < 0 as in the past, right? But note
> > > that the interim result we're talking about here is still to be divided
> > > by evt->mult. So assuming mult > 1, that check is too strict unless you
> > > move it below the do_div in clockevent_delta2ns. For sure it makes sense
> > > to use the same value for a and b in the handling:
> > 
> > No, it's not too strict.
> > 
> >     nsec = (latch << shift) / mult;
> > 
> > Now the backwards conversion does:
> > 
> >     latch = (nsec * mult) >> shift;
> >
> > So we want nsec * mult to be in the positive range of s64. Which
> > means, that latch << shift must be in that range as well.
> The backwards conversion is in clockevents_program_event(), right? There
> is:
> 
> 	clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
> 
> So I don't see a problem if nsec * mult overflows (1 << 63) - 1 as long
> as it still fits into an unsigned long long (i.e. a 64 bit value).

Right. It doesn't matter.

--8323329-1750308372-1379596355=:4089--
