Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab3GKTzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 15:55:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58675 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab3GKTzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 15:55:39 -0400
Message-ID: <51DF0D7A.4090008@ti.com>
Date: Thu, 11 Jul 2013 15:54:34 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
CC: Dave Martin <Dave.Martin@arm.com>, <pali.rohar@gmail.com>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <aaro.koskinen@iki.fi>, <nm@ti.com>, <linux@arm.linux.org.uk>,
        <pdeschrijver@nvidia.com>, <pavel@ucw.cz>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/2] ARM: OMAP: Add secure function omap_smc3() which
 calling instruction smc #1
References: <531356997.66774.1373571839852.JavaMail.apache@mail81.abv.bg>
In-Reply-To: <531356997.66774.1373571839852.JavaMail.apache@mail81.abv.bg>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 July 2013 03:43 PM, Ивайло Димитров wrote:
>  
> 
> 
> 
> 
>  >-------- Оригинално писмо --------
>  >От:  Dave Martin 
>  >Относно: Re: [PATCH v2 1/2] ARM: OMAP: Add secure function omap_smc3() which
>  calling instruction smc #1
>  >До: Pali Rohár 
>  >Изпратено на: Сряда, 2013, Юли 10 20:45:26 EEST
>  >
>  >
>  >On Wed, Jul 10, 2013 at 02:59:04PM +0200, Pali Rohár wrote:
>  >> Other secure functions omap_smc1() and omap_smc2() calling instruction smc #0
>  >> but Nokia RX-51 board needs to call smc #1 for PPA access.
>  >> 
>  >> Signed-off-by: Ivaylo Dimitrov 
>  >> Signed-off-by: Pali Rohár 
>  >> ---
>  >>  arch/arm/mach-omap2/omap-secure.h |    1 +
>  >>  arch/arm/mach-omap2/omap-smc.S    |   22 +++++++++++++++++++++-
>  >>  2 files changed, 22 insertions(+), 1 deletion(-)
>  >> 
>  >> diff --git a/arch/arm/mach-omap2/omap-secure.h b/arch/arm/mach-omap2/omap-secure.h
>  >> index 0e72917..c4586f4 100644
>  >> --- a/arch/arm/mach-omap2/omap-secure.h
>  >> +++ b/arch/arm/mach-omap2/omap-secure.h
>  >> @@ -51,6 +51,7 @@
>  >>  extern u32 omap_secure_dispatcher(u32 idx, u32 flag, u32 nargs,
>  >>  				u32 arg1, u32 arg2, u32 arg3, u32 arg4);
>  >>  extern u32 omap_smc2(u32 id, u32 falg, u32 pargs);
>  >> +extern u32 omap_smc3(u32 id, u32 process, u32 flag, u32 pargs);
>  >>  extern phys_addr_t omap_secure_ram_mempool_base(void);
>  >>  extern int omap_secure_ram_reserve_memblock(void);
>  >>  
>  >> diff --git a/arch/arm/mach-omap2/omap-smc.S b/arch/arm/mach-omap2/omap-smc.S
>  >> index f6441c1..5c02b8d 100644
>  >> --- a/arch/arm/mach-omap2/omap-smc.S
>  >> +++ b/arch/arm/mach-omap2/omap-smc.S
>  >> @@ -1,9 +1,11 @@
>  >>  /*
>  >> - * OMAP44xx secure APIs file.
>  >> + * OMAP34xx and OMAP44xx secure APIs file.
>  >>   *
>  >>   * Copyright (C) 2010 Texas Instruments, Inc.
>  >>   * Written by Santosh Shilimkar 
>  >>   *
>  >> + * Copyright (C) 2012 Ivaylo Dimitrov 
>  >> + * Copyright (C) 2013 Pali Rohár 
>  >>   *
>  >>   * This program is free software,you can redistribute it and/or modify
>  >>   * it under the terms of the GNU General Public License version 2 as
>  >> @@ -54,6 +56,24 @@ ENTRY(omap_smc2)
>  >>  	ldmfd   sp!, {r4-r12, pc}
>  >>  ENDPROC(omap_smc2)
>  >>  
>  >> +/**
>  >> + * u32 omap_smc3(u32 service_id, u32 process_id, u32 flag, u32 pargs)
>  >> + * Low level common routine for secure HAL and PPA APIs via smc #1
>  >> + * r0 - @service_id: Secure Service ID
>  >> + * r1 - @process_id: Process ID
>  >> + * r2 - @flag: Flag to indicate the criticality of operation
>  >> + * r3 - @pargs: Physical address of parameter list
>  >> + */
>  >> +ENTRY(omap_smc3)
>  >> +	stmfd	sp!, {r4-r12, lr}
>  >
>  >You don't need to save/restore r12.  The ABI allows it to be clobbered
>  >across function calls.
>  >
>  >> +	mov	r12, r0		@ Copy the secure service ID
>  >> +	mov	r6, #0xff	@ Indicate new Task call
>  >> +	dsb
>  >> +	dmb
>  >
>  >dsb synchronises a superset of what dmb synchronises, so the dmb here is
>  >not useful.
>  >
>  >In any case, any code calling this must flush the region addressed by
>  >r3 beforehand anyway, which will include a dsb as part of its semantics
>  >-- this is how you call it from rx51_secure_dispatcher().
>  >
>  >So I think the dsb may not be needed here (?)
>  >
>  >Cheers
>  >---Dave
>  >
>  >
> 
> Could be, but I wonder why almost all the kernel code(I am aware of) that uses SMC and is written by TI, is storing r12 and is using both DSB and DMB. See arch/arm/mach-omap2/sleep34xx.S or arch/arm/mach-omap2/omap-smc.S for examples. I'd rather play it safe and leave it that way, unless someone confirms the other code using SMC has extra DSB/DMB instructions too. I wouldn't risk passing invalid/stale data to the Secure Monitor to just save 8 bytes and barriers in a performance non-critical code which will be called only a couple of times during the boot-up process. r12 save/restore is a legacy from omap_smc2 in omap-smc.S, so I guess it can go away without much of a trouble.
> 
Dave pointed out about the dsb and r12 to me in another thread. R12 can be easily removed
but the DSB's were needed on OMAP for power sequencing. Without those, we have seen
many issues. So you can leave the dsb's to be consistent with rest of the code.

Regards
Santosh
P.S: Please sensibly wrap your message while replying. You reply apears like
one single line and I needed to keep scrolling to read it.


