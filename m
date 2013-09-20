Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3ITVa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 17:30:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:43988 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab3ITVa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 17:30:26 -0400
Date: Fri, 20 Sep 2013 23:30:20 +0200 (CEST)
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
In-Reply-To: <20130920204125.GB16106@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1309202304280.4089@ionos.tec.linutronix.de>
References: <20130918085627.GN24802@pengutronix.de> <alpine.DEB.2.02.1309181058470.4089@ionos.tec.linutronix.de> <20130918150958.GO24802@pengutronix.de> <alpine.DEB.2.02.1309182201000.4089@ionos.tec.linutronix.de> <20130919100239.GS24802@pengutronix.de>
 <alpine.DEB.2.02.1309191207460.4089@ionos.tec.linutronix.de> <20130919124805.GU24802@pengutronix.de> <alpine.DEB.2.02.1309191629040.4089@ionos.tec.linutronix.de> <20130919200343.GV24802@pengutronix.de> <alpine.DEB.2.02.1309201127400.4089@ionos.tec.linutronix.de>
 <20130920204125.GB16106@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-341680546-1379712421=:4089"
Content-ID: <alpine.DEB.2.02.1309202327210.4089@ionos.tec.linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-341680546-1379712421=:4089
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.02.1309202327211.4089@ionos.tec.linutronix.de>

On Fri, 20 Sep 2013, Uwe Kleine-König wrote:
> On Fri, Sep 20, 2013 at 11:56:27AM +0200, Thomas Gleixner wrote:
> > On Thu, 19 Sep 2013, Uwe Kleine-König wrote:
> > > > +	 * from nsec to device ticks will be correct.
> > > > +	 *
> > > > +	 * For mult > (1 << shift), i.e. device frequency is > 1GHz we
> > > > +	 * need to be careful. Adding mult - 1 will result in a value
> > > > +	 * which when converted back to device ticks will be larger
> > > s/will/can/
> > 
> > No, it will always be larger.
> Hmm, consider a 1.25 GHz clock with shift = 2 and mult = 5. Then
> ns2clc(clc2ns(1000)) = 1000. So it's not always larger!
> In the fast-clock-case we have:
> With x << shift = n * mult - k for k in [0 .. mult-1] and an integer n:
> 
> 	  ns2clc(clc2ns(x))
> 	= ns2clc(((x << shift) + mult - 1) / mult)
> 	= ((((x << shift) + mult - 1) / mult) * mult) >> shift
> 	= n * mult >> shift
> 	= ((x << shift) + k) >> shift
> 	= x + (k >> shift)
> 
> So ns2clc(clc2ns(x)) = x for all x > 0 that have
> 
> 	k = mult - ((x << shift) - 1) % mult - 1 < 1 << shift
> 
> So my correction still stands.

Fair enough.  

> > 1) We cannot add if we'd overflow
> > 
> > 2) For mult <= 1 << shift it's always correct
> > 
> > 3) for mult > 1 << shift we only apply it to the min value not the max
> 
> Yeah, I didn't say your code is wrong *here*. I just think that my
> easier (and so probably faster) code is good enough.

Granted. I was stuck in the correctness discussion. So yeah, it does
not matter if we steal 30 usec of maximum idle sleep time from a 32kHz
clock. OTOH it does not matter much in the setup slow path to take
another conditional. :)

> Best regards and thanks for the nice discussion,
  
Ditto! You saved me from actually sitting down and using the pencil to
do the proper math.

Thanks,

	tglx
--8323329-341680546-1379712421=:4089--
