Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbaIKQbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:31:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48358 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755845AbaIKQbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:31:04 -0400
Date: Thu, 11 Sep 2014 18:31:01 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/7] ARM: at91: introduce basic SAMA5D4 support
Message-ID: <20140911183101.7a82d291@free-electrons.com>
In-Reply-To: <1410450852-1834-4-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410450852-1834-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1410450852-1834-4-git-send-email-alexandre.belloni@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alexandre Belloni,

On Thu, 11 Sep 2014 17:54:08 +0200, Alexandre Belloni wrote:

> +#ifdef CONFIG_CACHE_L2X0
> +static void __init at91_init_l2cache(void)
> +{
> +	struct device_node *np;
> +
> +	np = of_find_compatible_node(NULL, NULL, "arm,pl310-cache");
> +	if (!np)
> +		return;
> +	of_node_put(np);
> +
> +	l2x0_of_init(0, ~0UL);
> +}
> +#else
> +static inline void at91_init_l2cache(void) {}
> +#endif
> +
>  static void __init sama5_dt_device_init(void)
>  {
> +	at91_init_l2cache();

Following Russell's cleanup of the L2 cache code, I don't think this is
necessary. The l2x0_of_init() function is automatically called for you
in init_IRQ(), as long as one of the l2c_aux_mask or l2c_aux_val fields
of your DT_MACHINE structure are non zero:

void __init init_IRQ(void)
{
        int ret;

        if (IS_ENABLED(CONFIG_OF) && !machine_desc->init_irq)
                irqchip_init();
        else
                machine_desc->init_irq();

        if (IS_ENABLED(CONFIG_OF) && IS_ENABLED(CONFIG_CACHE_L2X0) &&
            (machine_desc->l2c_aux_mask || machine_desc->l2c_aux_val)) {
                outer_cache.write_sec = machine_desc->l2c_write_sec;
                ret = l2x0_of_init(machine_desc->l2c_aux_val,
                                   machine_desc->l2c_aux_mask);
                if (ret)
                        pr_err("L2C: failed to init: %d\n", ret);
        }
}

Also, l2x0_of_init() already has a stub definition when
CONFIG_CACHE_L2X0 is not enabled, so the compile time conditional is
not necessary.

> +/* Firmware */
> +extern void atmel_firmware_init(void);
> +extern bool atmel_firmware_is_registered(void);

What is this firmware?

> diff --git a/arch/arm/mach-at91/include/mach/sama5d4.h b/arch/arm/mach-at91/include/mach/sama5d4.h
> new file mode 100644
> index 000000000000..af835e89d4c5
> --- /dev/null
> +++ b/arch/arm/mach-at91/include/mach/sama5d4.h
> @@ -0,0 +1,35 @@
> +/*
> + * Chip-specific header file for the SAMA5D4 family
> + *
> + *  Copyright (C) 2013 Atmel Corporation,
> + *                     Nicolas Ferre <nicolas.ferre@atmel.com>
> + *
> + * Common definitions.
> + * Based on SAMA5D4 datasheet.
> + *
> + * Licensed under GPLv2 or later.
> + */
> +
> +#ifndef SAMA5D4_H
> +#define SAMA5D4_H
> +
> +/*
> + * User Peripheral physical base addresses.
> + */
> +#define SAMA5D4_BASE_AIC	0xfc06e000 /* (AIC non-secure) Base Address */
> +#define SAMA5D4_BASE_USART3	0xfc00c000 /* (USART3 non-secure) Base Address */
> +#define SAMA5D4_BASE_PMC	0xf0018000 /* (PMC) Base Address */
> +#define SAMA5D4_BASE_MPDDRC	0xf0010000 /* (MPDDRC) Base Address */
> +#define SAMA5D4_BASE_PIOD	0xfc068000 /* (PIOD) Base Address */
> +#define SAMA5D4_BASE_PIOE	0xfc06d000 /* (PIOE) Base Address */

Are these definitions still all necessary? With the migration of most
(all?) peripherals to the Device Tree, less and less of those
definitions should be useful. For example, isn't the AIC fully
described in the Device Tree now?

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
