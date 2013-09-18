Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3IRT1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:27:42 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36947 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3IRT1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:27:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+XsceTJN7ysA+TK+ciHXoH
Date: Wed, 18 Sep 2013 12:27:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, Nishanth Menon <nm@ti.com>,
        Pavel Machek <pavel@ucw.cz>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v3 2/2] RX-51: ARM errata 430973 workaround
Message-ID: <20130918192731.GE9994@atomide.com>
References: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com>
 <1373461145-9812-3-git-send-email-pali.rohar@gmail.com>
 <20130917232417.GK9994@atomide.com>
 <201309182122.01570@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201309182122.01570@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130918 12:29]:
> Hello Tony,
> 
> here is new v3 patch. I just only moved functions rx51_secure_dispatcher and
> rx51_secure_update_aux_cr to omap-secure.c and added header to omap-secure.h
> Because I only moved two functions to other source file I tested only compilation.
> It is OK now?

Yes looks OK to me for v3.13 for the patch.

For the patch description, maybe also add something saying
that the rx51_secure_dispatcher() is different from the existing
smc function as that may be easy to miss while glancing over
the code?

Regards,

Tony
 
> diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
> index 773510556..db168c9 100644
> --- a/arch/arm/mach-omap2/board-rx51.c
> +++ b/arch/arm/mach-omap2/board-rx51.c
> @@ -2,6 +2,8 @@
>   * Board support file for Nokia N900 (aka RX-51).
>   *
>   * Copyright (C) 2007, 2008 Nokia
> + * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
> + * Copyright (C) 2013 Pali Rohár <pali.rohar@gmail.com>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -31,7 +33,9 @@
>  #include "mux.h"
>  #include "gpmc.h"
>  #include "pm.h"
> +#include "soc.h"
>  #include "sdram-nokia.h"
> +#include "omap-secure.h"
>  
>  #define RX51_GPIO_SLEEP_IND 162
>  
> @@ -103,6 +107,14 @@ static void __init rx51_init(void)
>  	usb_musb_init(&musb_board_data);
>  	rx51_peripherals_init();
>  
> +	if (omap_type() == OMAP2_DEVICE_TYPE_SEC) {
> +#ifdef CONFIG_ARM_ERRATA_430973
> +		pr_info("RX-51: Enabling ARM errata 430973 workaround\n");
> +		/* set IBE to 1 */
> +		rx51_secure_update_aux_cr(BIT(6), 0);
> +#endif
> +	}
> +
>  	/* Ensure SDRC pins are mux'd for self-refresh */
>  	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
>  	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
> diff --git a/arch/arm/mach-omap2/omap-secure.c b/arch/arm/mach-omap2/omap-secure.c
> index b970440..eba74cf 100644
> --- a/arch/arm/mach-omap2/omap-secure.c
> +++ b/arch/arm/mach-omap2/omap-secure.c
> @@ -3,6 +3,8 @@
>   *
>   * Copyright (C) 2011 Texas Instruments, Inc.
>   *	Santosh Shilimkar <santosh.shilimkar@ti.com>
> + * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
> + * Copyright (C) 2013 Pali Rohár <pali.rohar@gmail.com>
>   *
>   *
>   * This program is free software,you can redistribute it and/or modify
> @@ -70,3 +72,63 @@ phys_addr_t omap_secure_ram_mempool_base(void)
>  {
>  	return omap_secure_memblock_base;
>  }
> +
> +/**
> + * rx51_secure_dispatcher: Routine to dispatch secure PPA API calls
> + * @idx: The PPA API index
> + * @process: Process ID
> + * @flag: The flag indicating criticality of operation
> + * @nargs: Number of valid arguments out of four.
> + * @arg1, arg2, arg3 args4: Parameters passed to secure API
> + *
> + * Return the non-zero error value on failure.
> + */
> +u32 rx51_secure_dispatcher(u32 idx, u32 process, u32 flag, u32 nargs,
> +			   u32 arg1, u32 arg2, u32 arg3, u32 arg4)
> +{
> +	u32 ret;
> +	u32 param[5];
> +
> +	param[0] = nargs+1; /* RX-51 needs number of arguments + 1 */
> +	param[1] = arg1;
> +	param[2] = arg2;
> +	param[3] = arg3;
> +	param[4] = arg4;
> +
> +	/*
> +	 * Secure API needs physical address
> +	 * pointer for the parameters
> +	 */
> +	local_irq_disable();
> +	local_fiq_disable();
> +	flush_cache_all();
> +	outer_clean_range(__pa(param), __pa(param + 5));
> +	ret = omap_smc3(idx, process, flag, __pa(param));
> +	flush_cache_all();
> +	local_fiq_enable();
> +	local_irq_enable();
> +
> +	return ret;
> +}
> +
> +/**
> + * rx51_secure_update_aux_cr: Routine to modify the contents of Auxiliary Control Register
> + *  @set_bits: bits to set in ACR
> + *  @clr_bits: bits to clear in ACR
> + *
> + * Return the non-zero error value on failure.
> +*/
> +u32 rx51_secure_update_aux_cr(u32 set_bits, u32 clear_bits)
> +{
> +	u32 acr;
> +
> +	/* Read ACR */
> +	asm volatile ("mrc p15, 0, %0, c1, c0, 1" : "=r" (acr));
> +	acr &= ~clear_bits;
> +	acr |= set_bits;
> +
> +	return rx51_secure_dispatcher(RX51_PPA_WRITE_ACR,
> +				      0,
> +				      FLAG_START_CRITICAL,
> +				      1, acr, 0, 0, 0);
> +}
> diff --git a/arch/arm/mach-omap2/omap-secure.h b/arch/arm/mach-omap2/omap-secure.h
> index c4586f4..51b59c6 100644
> --- a/arch/arm/mach-omap2/omap-secure.h
> +++ b/arch/arm/mach-omap2/omap-secure.h
> @@ -3,6 +3,8 @@
>   *
>   * Copyright (C) 2011 Texas Instruments, Inc.
>   *	Santosh Shilimkar <santosh.shilimkar@ti.com>
> + * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
> + * Copyright (C) 2013 Pali Rohár <pali.rohar@gmail.com>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -46,6 +48,11 @@
>  #define OMAP4_PPA_L2_POR_INDEX		0x23
>  #define OMAP4_PPA_CPU_ACTRL_SMP_INDEX	0x25
>  
> +/* Secure RX-51 PPA (Primary Protected Application) APIs */
> +#define RX51_PPA_HWRNG			29
> +#define RX51_PPA_L2_INVAL		40
> +#define RX51_PPA_WRITE_ACR		42
> +
>  #ifndef __ASSEMBLER__
>  
>  extern u32 omap_secure_dispatcher(u32 idx, u32 flag, u32 nargs,
> @@ -55,6 +62,10 @@ extern u32 omap_smc3(u32 id, u32 process, u32 flag, u32 pargs);
>  extern phys_addr_t omap_secure_ram_mempool_base(void);
>  extern int omap_secure_ram_reserve_memblock(void);
>  
> +extern u32 rx51_secure_dispatcher(u32 idx, u32 process, u32 flag, u32 nargs,
> +				  u32 arg1, u32 arg2, u32 arg3, u32 arg4);
> +extern u32 rx51_secure_update_aux_cr(u32 set_bits, u32 clear_bits);
> +
>  #ifdef CONFIG_OMAP4_ERRATA_I688
>  extern int omap_barrier_reserve_memblock(void);
>  #else
> 
> 
> -- 
> Pali Rohár
> pali.rohar@gmail.com


