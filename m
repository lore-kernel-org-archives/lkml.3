Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab3DVMF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:05:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56809 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3DVMFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:05:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH v3] irqchip: Add support for ARMv7-M's NVIC
Date: Mon, 22 Apr 2013 14:04:31 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>
References: <1366214540-31166-1-git-send-email-u.kleine-koenig@pengutronix.de> <20130419150927.GE15233@pengutronix.de> <20130422100219.GH15233@pengutronix.de>
In-Reply-To: <20130422100219.GH15233@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201304221404.31281.arnd@arndb.de>
X-Provags-ID: V02:K0:QRAPyIvCGhm6h0OL4EdT75OAPAA5UeYBUFKRC0h4FPS
 FRGiggvpXwUf2NyGsYQSmrMeP9zn5C0Ydkd9atayCrTHhIbIw2
 Eb/fgCqHVFnek7H2ja4YxLkwCBHVuBBSEqFhZ8S9Wd46ajXKPh
 VktBIJ/jYFHHhLjQlaLbt2967H9+jTle+GyC/uIXk4E/OwlGS6
 D2S1vRh2AcrkLA03kypakB5UZxkA2oPhwmMI9rrqbrOGKTZMhp
 3cfXaxwBHtNtZZJj2n7atuZDPqWLZk0ufVY5uyOWyfsJH2p3X5
 UC3IjJ/blcvrmoFoLuPkxpez71GMKNGHa/1qPX0iyLvhbS6LSV
 pF+Im90/iTpbqz2jaaJo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 April 2013, Uwe Kleine-König wrote:
> Hello,
> 
> (for the new readers of this thread: This is about using
> 
> 	u32 mask = 1 << (d->hwirq % 32);
> 
> instead of
> 
> 	u32 mask = 1 << (d->irq - gc->irq_base);

While not technically any different, I would suggest writing the above
as (d->hwirq & 0x1f), which makes it clear to the reader that this is
intended to be a cheap bit mask operation rather than an expensive
division.
> 
> arch/arm/mach-s5p64x0/common.c
> 	-> uses irq_base=101 for irq_alloc_generic_chip

I think there are plans to replace this code with
drivers/pinctrl/pinctrl-samsung.c, but I don't know if patches
exist already.

> arch/arm/plat-orion/gpio.c
> 	-> depends on how orion_gpio_of_init is called. No callers
> 	found.

As of f9e7592230b, this code has been replaced with a pinctrl driver
and can be killed.

> arch/arm/plat-orion/irq.c
> arch/arm/plat-samsung/irq-vic-timer.c
> 	-> used for a single irq that isn't a multiple of 32

Tomasz Figa has a patch set to remove this file, will likely get merged
in 3.11.

> arch/arm/plat-samsung/s5p-irq-gpioint.c
> 	-> would need % 8?

AFAICT this code is the same driver as arch/arm/mach-s5p64x0/common.c
and will meet the same fate.

> arch/sh/boards/mach-se/7343/irq.c
> 	-> uses irq_base = irq_linear_revmap(se7343_irq_domain, 0) where
> 	se7343_irq_domain is a linear domain.
> 	AFAICT this is a bug. (After adding the domain they map all irqs
> 	in increasing order which currently seems to guarantee that it
> 	works. But IMHO it should use a legacy domain.)
> 
> arch/sh/boards/mach-se/7722/irq.c
> 	as above.

Right. I think irq_domain_add_simple() is the right interface to use
here.

> For the uncommented files using %32 instead of -gc->irq_base should
> work.

I'm not sure I understand why this doesn't work for the ones that use
a base that isn't a multiple of 32. Since you are masking the hwirq
rather than the irq number, it will still be zero-based, won't it?

	Arnd
