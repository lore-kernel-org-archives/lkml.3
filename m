Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaGDHOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:14:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55766 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750772AbaGDHOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:14:52 -0400
Date: Fri, 4 Jul 2014 09:14:43 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        devicetree@vger.kernel.org, dbaryshkov@gmail.com,
        Nicolas FERRE <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        dwmw2@infradead.org, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/18] power: reset: Add AT91 reset driver
Message-ID: <20140704091443.545d1e08@bbrezillon>
In-Reply-To: <B425B925-B75E-4761-8CE6-9B12C5AC0469@jcrosoft.com>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
	<1404396906-25194-8-git-send-email-maxime.ripard@free-electrons.com>
	<F9547E0F-AB97-47E6-BA09-135EE4E1BC73@jcrosoft.com>
	<20140703145957.GH31996@lukather>
	<B425B925-B75E-4761-8CE6-9B12C5AC0469@jcrosoft.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2014 11:08:20 +0800
Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> wrote:

> 
> On Jul 3, 2014, at 10:59 PM, Maxime Ripard <maxime.ripard@free-electrons.com> wrote:
> 
> > On Thu, Jul 03, 2014 at 10:39:08PM +0800, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >>> +++ b/drivers/power/reset/at91-reset.c
> >>> @@ -0,0 +1,202 @@
> >>> +/*
> >>> + * Atmel AT91 SAM9 SoCs reset code
> >>> + *
> >>> + * Copyright (C) 2014 Maxime Ripard
> >>> + *
> >>> + * Maxime Ripard <maxime.ripard@free-electrons.com>
> >> 
> >> you can not own the copyright as it’s basically a copy of other
> >> people code
> > 
> > The previous names are missing, right.
> > 
> >>> + *
> >>> + * This file is licensed under the terms of the GNU General Public
> >>> + * License version 2.  This program is licensed "as is" without any
> >>> + * warranty of any kind, whether express or implied.
> >>> + */
> >>> +
> >>> +#include <linux/io.h>
> >>> +#include <linux/module.h>
> >>> +#include <linux/of_address.h>
> >>> +#include <linux/platform_device.h>
> >>> +#include <linux/reboot.h>
> >>> +
> >>> +#include <asm/system_misc.h>
> >>> +
> >>> +#include <mach/at91sam9_ddrsdr.h>
> >>> +#include <mach/at91sam9_sdramc.h>
> >>> +
> >>> +#define AT91_RSTC_CR	0x00		/* Reset Controller Control Register */
> >>> +#define	AT91_RSTC_PROCRST	BIT(0)		/* Processor Reset */
> >>> +#define	AT91_RSTC_PERRST	BIT(2)		/* Peripheral Reset */
> >>> +#define	AT91_RSTC_EXTRST	BIT(3)		/* External Reset */
> >>> +#define	AT91_RSTC_KEY		(0xa5 << 24)	/* KEY Password */
> >>> +
> >>> +#define AT91_RSTC_SR	0x04		/* Reset Controller Status Register */
> >>> +#define	AT91_RSTC_URSTS		BIT(0)		/* User Reset Status */
> >>> +#define	AT91_RSTC_RSTTYP	GENMASK(10, 8)	/* Reset Type */
> >>> +#define	AT91_RSTC_NRSTL		BIT(16)		/* NRST Pin Level */
> >>> +#define	AT91_RSTC_SRCMP		BIT(17)		/* Software Reset Command in Progress */
> >>> +
> >>> +#define AT91_RSTC_MR	0x08		/* Reset Controller Mode Register */
> >>> +#define	AT91_RSTC_URSTEN	BIT(0)		/* User Reset Enable */
> >>> +#define	AT91_RSTC_URSTIEN	BIT(4)		/* User Reset Interrupt Enable */
> >>> +#define	AT91_RSTC_ERSTL		GENMASK(11, 8)	/* External Reset Length */
> >>> +
> >>> +enum reset_type {
> >>> +	RESET_TYPE_GENERAL	= 0,
> >>> +	RESET_TYPE_WAKEUP	= 1,
> >>> +	RESET_TYPE_WATCHDOG	= 2,
> >>> +	RESET_TYPE_SOFTWARE	= 3,
> >>> +	RESET_TYPE_USER		= 4,
> >>> +};
> >>> +
> >>> +static void __iomem *at91_ramc_base[2], *at91_rstc_base;
> >>> +
> >>> +static void at91sam9_restart(enum reboot_mode mode, const char *cmd)
> >>> +{
> >>> +	asm volatile(
> >>> +		".balign 32\n\t"
> >>> +
> >>> +		"str	%2, [%0, #" __stringify(AT91_SDRAMC_TR) "]\n\t"
> >>> +		"str	%3, [%0, #" __stringify(AT91_SDRAMC_LPR) "]\n\t"
> >>> +		"str	%4, [%1, #" __stringify(AT91_RSTC_CR) "]\n\t"
> >>> +
> >>> +		"b	.\n\t"
> >>> +		:
> >>> +		: "r" (at91_ramc_base[0]),
> >>> +		  "r" (at91_rstc_base),
> >>> +		  "r" (1),
> >>> +		  "r" (AT91_SDRAMC_LPCB_POWER_DOWN),
> >>> +		  "r" (AT91_RSTC_KEY | AT91_RSTC_PERRST | AT91_RSTC_PROCRST));
> >>> +}
> >>> +
> >>> +static void at91sam9g45_restart(enum reboot_mode mode, const char *cmd)
> >>> +{
> >>> +	asm volatile(
> >>> +		"cmp	%1, #0\n\t"
> >>> +		"beq	1f\n\t"
> >>> +
> >>> +		"ldr	r0, [%1]\n\t"
> >>> +		"cmp	r0, #0\n\t"
> >>> +
> >>> +		".balign 32\n\t"
> >>> +
> >>> +		"1:	str	%3, [%0, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
> >>> +		"	str	%4, [%0, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
> >>> +		"	strne	%3, [%1, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
> >>> +		"	strne	%4, [%1, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
> >>> +		"	str	%5, [%2, #" __stringify(AT91_RSTC_CR) "]\n\t"
> >>> +
> >>> +		"	b	.\n\t"
> >>> +		:
> >>> +		: "r" (at91_ramc_base[0]),
> >>> +		  "r" (at91_ramc_base[1]),
> >>> +		  "r" (at91_rstc_base),
> >>> +		  "r" (1),
> >>> +		  "r" (AT91_DDRSDRC_LPCB_POWER_DOWN),
> >>> +		  "r" (AT91_RSTC_KEY | AT91_RSTC_PERRST | AT91_RSTC_PROCRST)
> >>> +		: "r0");
> >>> +}
> >>> +
> >> move this to an assembly file more easy to read than a C code
> > 
> > Nope. It's a pain to pass variable to an external assembly file, and
> > this makes the use of global variable pretty much mandatory, which is
> > definitely not great.
> 
> Not at all I did for the PM slow clock code just write a function and pas it as a parameter
> you have 3
> 
> so basically you have to use the current and just pass at91_ramc_base[0], at91_ramc_base[1]
> and at91_rstc_base
> it’s 3 lignes of modification, if you have at91_ramc_base and at91_ramc_base same
> 

Yes, retrieving function parameters from assembly code is not that
complicated (the first 4 pointer values are accessible through r0-r3),
but then you'll have to store your assembly file somewhere.

Subsystem directories (drivers/xxx) are supposed to be architecture
agnostics, and I'm not sure subsystem maintainers will accept these
assembly files in their directory.
ITOH, leaving these assembly files in arch/arm/mach-at91 will just
spread the code over linux src tree and will definitely not help other
people find out the relationship between these files.

Regarding the readability concern, I think some comments could help
understanding what's being done here.

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
