Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3GJRql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:46:41 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:55869 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754714Ab3GJRqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:46:40 -0400
Date: Wed, 10 Jul 2013 18:45:26 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Nishanth Menon <nm@ti.com>,
        linux@arm.linux.org.uk, Peter De Schrijver <pdeschrijver@nvidia.com>,
        Ivaylo Dimitrov <freemangordon@abv.bg>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Pavel Machek <pavel@ucw.cz>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] ARM: OMAP: Add secure function omap_smc3() which
 calling instruction smc #1
Message-ID: <20130710174521.GA2872@localhost.localdomain>
References: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com>
 <1373461145-9812-1-git-send-email-pali.rohar@gmail.com>
 <1373461145-9812-2-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1373461145-9812-2-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 02:59:04PM +0200, Pali Rohár wrote:
> Other secure functions omap_smc1() and omap_smc2() calling instruction smc #0
> but Nokia RX-51 board needs to call smc #1 for PPA access.
> 
> Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  arch/arm/mach-omap2/omap-secure.h |    1 +
>  arch/arm/mach-omap2/omap-smc.S    |   22 +++++++++++++++++++++-
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/omap-secure.h b/arch/arm/mach-omap2/omap-secure.h
> index 0e72917..c4586f4 100644
> --- a/arch/arm/mach-omap2/omap-secure.h
> +++ b/arch/arm/mach-omap2/omap-secure.h
> @@ -51,6 +51,7 @@
>  extern u32 omap_secure_dispatcher(u32 idx, u32 flag, u32 nargs,
>  				u32 arg1, u32 arg2, u32 arg3, u32 arg4);
>  extern u32 omap_smc2(u32 id, u32 falg, u32 pargs);
> +extern u32 omap_smc3(u32 id, u32 process, u32 flag, u32 pargs);
>  extern phys_addr_t omap_secure_ram_mempool_base(void);
>  extern int omap_secure_ram_reserve_memblock(void);
>  
> diff --git a/arch/arm/mach-omap2/omap-smc.S b/arch/arm/mach-omap2/omap-smc.S
> index f6441c1..5c02b8d 100644
> --- a/arch/arm/mach-omap2/omap-smc.S
> +++ b/arch/arm/mach-omap2/omap-smc.S
> @@ -1,9 +1,11 @@
>  /*
> - * OMAP44xx secure APIs file.
> + * OMAP34xx and OMAP44xx secure APIs file.
>   *
>   * Copyright (C) 2010 Texas Instruments, Inc.
>   * Written by Santosh Shilimkar <santosh.shilimkar@ti.com>
>   *
> + * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
> + * Copyright (C) 2013 Pali Rohár <pali.rohar@gmail.com>
>   *
>   * This program is free software,you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -54,6 +56,24 @@ ENTRY(omap_smc2)
>  	ldmfd   sp!, {r4-r12, pc}
>  ENDPROC(omap_smc2)
>  
> +/**
> + * u32 omap_smc3(u32 service_id, u32 process_id, u32 flag, u32 pargs)
> + * Low level common routine for secure HAL and PPA APIs via smc #1
> + * r0 - @service_id: Secure Service ID
> + * r1 - @process_id: Process ID
> + * r2 - @flag: Flag to indicate the criticality of operation
> + * r3 - @pargs: Physical address of parameter list
> + */
> +ENTRY(omap_smc3)
> +	stmfd	sp!, {r4-r12, lr}

You don't need to save/restore r12.  The ABI allows it to be clobbered
across function calls.

> +	mov	r12, r0		@ Copy the secure service ID
> +	mov	r6, #0xff	@ Indicate new Task call
> +	dsb
> +	dmb

dsb synchronises a superset of what dmb synchronises, so the dmb here is
not useful.

In any case, any code calling this must flush the region addressed by
r3 beforehand anyway, which will include a dsb as part of its semantics
-- this is how you call it from rx51_secure_dispatcher().

So I think the dsb may not be needed here (?)

Cheers
---Dave

