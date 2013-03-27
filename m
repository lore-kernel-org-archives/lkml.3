Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3C0VJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:09:28 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:16736 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3C0VJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:09:27 -0400
X-Greylist: delayed 794 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Mar 2013 17:09:27 EDT
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19U7LEhP6X8e6a9Af05Aeop
Date: Wed, 27 Mar 2013 14:09:18 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Juha Yrjola <juha.yrjola@solidboot.com>,
        Russell King <linux@arm.linux.org.uk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP3 ROM Random Number Generator support
Message-ID: <20130327210918.GP10155@atomide.com>
References: <201302281905.48546@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201302281905.48546@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130228 10:09]:
> --- /dev/null
> +++ b/drivers/char/hw_random/omap3-rom-asm.S
> @@ -0,0 +1,27 @@
> +/*
> + * Copyright (C) 2009 Nokia Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/assembler.h>
> +
> +ENTRY(omap3_rng_call_rom_asm)
> +	.arch_extension sec
> +	stmfd	sp!, {r4-r12, lr}
> +	stmfd	sp!, {r0-r3}
> +	bl	v7_flush_dcache_all
> +	ldmfd	sp!, {r0-r3}
> +	mov	r6, #0xff
> +	mov	r12, r0
> +	smc	#1
> +	mov	r12, r0
> +	bl	v7_flush_dcache_all
> +	mov	r0, #0
> +	mcr	p15, 0, r0, c7, c5, 0
> +	mov	r0, r12
> +	ldmfd	sp!, {r4-r12, pc}

This part should be in arch/arm/mach-omap2 because of the
direct calls to v7_flush_dcache_all. Then you can pass a pointer
to this function in platform_data for now, and set it up based
on the compatible flag with device tree from driver later on.

> --- /dev/null
> +++ b/drivers/char/hw_random/omap3-rom-drv.c
> @@ -0,0 +1,167 @@
> +/*
> + * omap3-rom-drv.c - RNG driver for TI OMAP3 CPU family
> + *
> + * Copyright (C) 2009 Nokia Corporation
> + * Author: Juha Yrjola <juha.yrjola@solidboot.com>
> + *
> + * This file is licensed under  the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/random.h>
> +#include <linux/hw_random.h>
> +#include <linux/timer.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +
> +#include "../../../arch/arm/mach-omap2/soc.h"

NAK for this, this must be private to arch/arm/mach-omap2.

Instead, just create a minimal include/linux/platform_data/omap3-rom.h,
and pass the function pointer in the pdata if passed.

> +static int omap3_rom_rng_probe(struct platform_device *pdev)
> +{
> +	printk(KERN_INFO "%s: initializing\n", omap3_rom_rng_name);
> +	if (!cpu_is_omap34xx()) {
> +		printk(KERN_ERR "%s: currently supports only OMAP34xx CPUs\n",
> +		       omap3_rom_rng_name);
> +		return -ENODEV;
> +	}
> +	if (omap_type() == OMAP2_DEVICE_TYPE_GP) {
> +		printk(KERN_ERR "%s: GP OMAPs not supported\n",
> +		       omap3_rom_rng_name);
> +		return -ENODEV;
> +	}
> +
> +	setup_timer(&idle_timer, omap3_rom_idle_rng, 0);
> +	rng_clk = clk_get_sys("omap_rng", "ick");
> +	if (IS_ERR(rng_clk)) {
> +		printk(KERN_ERR "%s: unable to get RNG clock\n",
> +		       omap3_rom_rng_name);
> +		return IS_ERR(rng_clk);
> +	}
> +
> +	/* Leave the RNG in reset state. */
> +	clk_prepare_enable(rng_clk);
> +	omap3_rom_idle_rng(0);
> +
> +	return hwrng_register(&omap3_rom_rng_ops);
> +}

You should replace the cpu_is_omap34xx() and omap_type() with
some flags that you pass in the pdata. These too can be then
deciphered based on the DT compatible flag later on. And then
you don't need to include soc.h.

Regards,

Tony
