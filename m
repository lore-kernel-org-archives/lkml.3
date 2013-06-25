Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab3FYV3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:29:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:59171 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3FYV3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:29:38 -0400
Date: Tue, 25 Jun 2013 23:29:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4] irqchip: Add support for ARMv7-M's NVIC
In-Reply-To: <1371073835-10639-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1306252316470.4013@ionos.tec.linutronix.de>
References: <1371073835-10639-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-569184648-1372195778=:4013"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-569184648-1372195778=:4013
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 12 Jun 2013, Uwe Kleine-König wrote:

> This interrupt controller is found on Cortex-M3 and Cortex-M4 machines.

I don't think that anyone is searching for interrupt controllers as
they are simply an essential part of the M3/4 SoCs.
 
>     
>     This depends on the stuff currently in tip/irq/for-arm
> 
>  arch/arm/kernel/entry-v7m.S |   2 +-

This is not depending on my tree. I can take the patch if

 - you drop the arm related change and do that cleanup later

or

 - the relevant maintainers provide their ACK.

> +	for (i = 0; i < numbanks; ++i) {
> +		struct irq_chip_generic *gc =
> +			irq_get_domain_generic_chip(nvic_irq_domain, 32 * i);
> +		gc->reg_base = nvic_base + 4 * i;
> +		gc->chip_types[0].regs.enable = NVIC_ISER;
> +		gc->chip_types[0].regs.disable = NVIC_ICER;
> +		gc->chip_types[0].chip.irq_mask = irq_gc_mask_disable_reg;
> +		gc->chip_types[0].chip.irq_unmask = irq_gc_unmask_enable_reg;
> +		gc->chip_types[0].chip.irq_eoi = nvic_eoi;
> +	}
> +
> +	/* Disable all interrupts */
> +	for (i = 0; i < irqs; i += 32)
> +		writel_relaxed(~0, nvic_base + NVIC_ICER + i * 4 / 32);

So this is another, slightly different loop than the previous one

> +	for (i = 0; i < numbanks; ++i) {

This time based on irqs and increasing the irq number per loop by a
full bank. Why not doing this in the above loop which does exaclty the
same and you don't have to do the odd register base math. A simple

	writel_relaxed(~0, gc->reg_base + NVIC_ICER);

in the banks loop is sufficient, right?

Thanks,

	tglx
--8323329-569184648-1372195778=:4013--
