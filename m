Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3IRJiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:38:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:56874 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3IRJiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:38:13 -0400
Date: Wed, 18 Sep 2013 11:38:07 +0200 (CEST)
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
In-Reply-To: <20130918085627.GN24802@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1309181058470.4089@ionos.tec.linutronix.de>
References: <1379077365-18458-1-git-send-email-mkl@pengutronix.de> <20130917095600.GJ26819@ludovic.desroches@atmel.com> <20130917100417.GQ12758@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1309171210450.4089@ionos.tec.linutronix.de> <20130917130153.GL26819@ludovic.desroches@atmel.com>
 <alpine.DEB.2.02.1309172228400.4089@ionos.tec.linutronix.de> <20130918085627.GN24802@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1661809435-1379497088=:4089"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1661809435-1379497088=:4089
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 18 Sep 2013, Uwe Kleine-König wrote:
> > Now we can easily verify whether the whole equation fits into the
> > 64bit boundary. Shifting the "clc" result back by evt->shift MUST
> > result in "latch". If that's not the case, we have a clear indicator
> But this is only the case if evt->mult is <= (1 << evt->shift). Is this
> always given?

Crap, no. It's only true for device frequency <= 1GHz. Good catch!

> Is it more sensible to adjust dev->max_delta_ns once at register time
> and so save the often recurrent overflow check in
> clockevents_program_event?

Which overflow check are you talking about?

There is only the boundary check:

        delta = min(delta, (int64_t) dev->max_delta_ns);
        delta = max(delta, (int64_t) dev->min_delta_ns);

Which sensible adjustment at register time is going to remove that?

> Another doubt I have is: You changed clockevent_delta2ns to round up now
> unconditionally. For the numbers on at91 that doesn't matter, but I
> wonder if there are situations that make the timer core violate the
> max_delta_ticks condition now.

And how so? The + (mult - 1) ensures, that the conversion back to
ticks results in the same value as latch. So how should it violate
the max boundary?

Math is hard, right?
 
> > for boundary violation and can limit "clc" to (1 << 63) - 1 before the
> Where does this magic constant come from?

Rolling my magic hex dice gave me that.

Thanks,

	tglx
--8323329-1661809435-1379497088=:4089--
