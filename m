Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3HKSgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 14:36:47 -0400
Received: from smtp-out.abv.bg ([194.153.145.99]:43956 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab3HKSgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 14:36:42 -0400
DomainKey-Signature: a=rsa-sha1; s=smtp-out; d=abv.bg; c=simple; q=dns;
	b=I40PN6RzkoD0pT5LPi22F8jFaE8ZpkywC5BCsp9OYFO2DGWM+8xVoX2v1RwOVXcX2
	UztfULrvJH+oZgKjh6Umjm9jjrMNkogVfocx/UQYJreOpvFqk7wcvKLv9LkSojPvM8F
	rNRwuR+DQDcqGcVn28jkHeD1llauDdOzI7BaIwg=
Date: Sun, 11 Aug 2013 21:36:40 +0300 (EEST)
From: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
To: Dave Martin <Dave.Martin@arm.com>
Cc: pali.rohar@gmail.com, tony@atomide.com, nm@ti.com, linux@arm.linux.org.uk,
        aaro.koskinen@iki.fi, pdeschrijver@nvidia.com,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com, pavel@ucw.cz,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <2121638991.49538.1376246200421.JavaMail.apache@mail81.abv.bg>
Subject: Re: [PATCH v3 1/2] ARM: OMAP: Add secure function omap_smc3() which calling instruction smc #1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-Mailer: AbvMail 1.0
X-Originating-IP: 130.204.50.168
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  >-------- Оригинално писмо --------
 >От:  Dave Martin 
 >Относно: Re: [PATCH v3 1/2] ARM: OMAP: Add secure function omap_smc3() which
 calling instruction smc #1
 >До: Pali Rohár 
 >Изпратено на: Понеделник, 2013, Август 5 16:29:44 EEST
 >
 >
 >On Sun, Aug 04, 2013 at 10:45:00AM +0200, Pali Rohár wrote:
 >> Here is new version (v3) of omap secure part patch:
 >> 
 >> Other secure functions omap_smc1() and omap_smc2() calling instruction smc #0
 >> but Nokia RX-51 board needs to call smc #1 for PPA access.
 >> 
 >> Signed-off-by: Ivaylo Dimitrov 
 >> Signed-off-by: Pali Rohár 
 >> ---
 >> diff --git a/arch/arm/mach-omap2/omap-secure.h b/arch/arm/mach-omap2/omap-secure.h
 >> index 0e72917..c4586f4 100644
 >> --- a/arch/arm/mach-omap2/omap-secure.h
 >> +++ b/arch/arm/mach-omap2/omap-secure.h
 >> @@ -51,6 +51,7 @@
 >>  extern u32 omap_secure_dispatcher(u32 idx, u32 flag, u32 nargs,
 >>  				u32 arg1, u32 arg2, u32 arg3, u32 arg4);
 >>  extern u32 omap_smc2(u32 id, u32 falg, u32 pargs);
 >> +extern u32 omap_smc3(u32 id, u32 process, u32 flag, u32 pargs);
 >>  extern phys_addr_t omap_secure_ram_mempool_base(void);
 >>  extern int omap_secure_ram_reserve_memblock(void);
 >>  
 >> diff --git a/arch/arm/mach-omap2/omap-smc.S b/arch/arm/mach-omap2/omap-smc.S
 >> index f6441c1..7bbc043 100644
 >> --- a/arch/arm/mach-omap2/omap-smc.S
 >> +++ b/arch/arm/mach-omap2/omap-smc.S
 >> @@ -1,9 +1,11 @@
 >>  /*
 >> - * OMAP44xx secure APIs file.
 >> + * OMAP34xx and OMAP44xx secure APIs file.
 >>   *
 >>   * Copyright (C) 2010 Texas Instruments, Inc.
 >>   * Written by Santosh Shilimkar 
 >>   *
 >> + * Copyright (C) 2012 Ivaylo Dimitrov 
 >> + * Copyright (C) 2013 Pali Rohár 
 >>   *
 >>   * This program is free software,you can redistribute it and/or modify
 >>   * it under the terms of the GNU General Public License version 2 as
 >> @@ -54,6 +56,23 @@ ENTRY(omap_smc2)
 >>  	ldmfd   sp!, {r4-r12, pc}
 >>  ENDPROC(omap_smc2)
 >>  
 >> +/**
 >> + * u32 omap_smc3(u32 service_id, u32 process_id, u32 flag, u32 pargs)
 >> + * Low level common routine for secure HAL and PPA APIs via smc #1
 >> + * r0 - @service_id: Secure Service ID
 >> + * r1 - @process_id: Process ID
 >> + * r2 - @flag: Flag to indicate the criticality of operation
 >> + * r3 - @pargs: Physical address of parameter list
 >> + */
 >> +ENTRY(omap_smc3)
 >> +	stmfd	sp!, {r4-r11, lr}
 >> +	mov	r12, r0		@ Copy the secure service ID
 >> +	mov	r6, #0xff	@ Indicate new Task call
 >> +	dsb			@ Memory Barrier
 >
 >Can you explain _why_ the barrier is there?  The reader doesn't need to
 >be told that a barrier instruction is a barrier instruction.
 >
 >Cheers
 >---Dave
 >
Hi Dave,

Would quoting Santosh's explanation "DSBs were needed on OMAP for power sequencing." do the job?
Something like "@ Needed on OMAP for power sequencing" instead of "@ Memory Barrier".

I want to be sure I correctly understand your requirement.

Regards,
Ivo

