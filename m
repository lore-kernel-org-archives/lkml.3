Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3IQXUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:20:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:55536 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3IQXUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:20:34 -0400
Date: Wed, 18 Sep 2013 01:20:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Kleine-Budde <mkl@pengutronix.de>
cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        nicolas.ferre@atmel.com, LKML <linux-kernel@vger.kernel.org>,
        Marc Pignat <marc.pignat@hevs.ch>, john.stultz@linaro.org,
        kernel@pengutronix.de, Ronald Wahl <ronald.wahl@raritan.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] clockevents: Sanitize ticks to nsec conversion
In-Reply-To: <5238D6BE.6040603@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1309180045480.4089@ionos.tec.linutronix.de>
References: <1379077365-18458-1-git-send-email-mkl@pengutronix.de> <20130917095600.GJ26819@ludovic.desroches@atmel.com> <20130917100417.GQ12758@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1309171210450.4089@ionos.tec.linutronix.de> <20130917130153.GL26819@ludovic.desroches@atmel.com>
 <alpine.DEB.2.02.1309172228400.4089@ionos.tec.linutronix.de> <5238D6BE.6040603@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Sep 2013, Marc Kleine-Budde wrote:
> On 09/17/2013 11:15 PM, Thomas Gleixner wrote:
> > Marc Kleine-Budde pointed out, that commit 77cc982 "clocksource: use
> > clockevents_config_and_register() where possible" caused a regression
> > for some of the converted subarchs.
> > 
> > The reason is, that the clockevents core code converts the minimal
> > hardware tick delta to a nanosecond value for core internal
> > usage. This conversion is affected by integer math rounding loss, so
> > the backwards conversion to hardware ticks will likely result in a
> > value which is less than the configured hardware limitation. The
> > affected subarchs used their own workaround (SIGH!) which got lost in
> > the conversion.
> > 
> > Now instead of fixing the underlying core code problem, Marcs patch
> > tried to work around the core code issue by increasing the minimal
> > tick delta at clockevents registration time so the resulting limit in
> > the core code backwards conversion did not violate the hardware
> > limits. More SIGH!
> 
> It was not easy getting your attention with this problem :)

A really hard to understand and solve problem! Obviously you are a
great fan of John Stultz famous "Math is hard, lets go shopping!"
line.

Why on earth do you need my attention to fix at least the simple
rounding issue in the core code?

You could have sent the "clk += evt->mult - 1:" patch directly to
Linus without even cc'ing me.

It's not rocket science, really. When I responded with the while(1)
loop patch today in the morning it was just because I did not have a
second to think about the correct fix for this, but the reason WHY
this happened was entirely clear in a split second after reading
Russells reply.

The upper bounds issue tooks a few minutes more, but it's not rocket
science either.

Sorry, I can understand the need for a second opinion on a weird race
condition problem, but tracking down an obvious simple math issue to
the point and fixing it... SIGH!

Thanks,

	tglx
