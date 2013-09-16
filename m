Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab3IPRL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 13:11:56 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:55013 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751389Ab3IPRLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:11:54 -0400
Date: Mon, 16 Sep 2013 18:10:30 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: "tony@atomide.com" <tony@atomide.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "nm@ti.com" <nm@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "aaro.koskinen@iki.fi" <aaro.koskinen@iki.fi>,
        "pdeschrijver@nvidia.com" <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/2] ARM: OMAP: Add secure function omap_smc3() which
 calling instruction smc #1
Message-ID: <20130916171023.GA17477@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 10:37:12AM +0100, Pali Rohár wrote:
> On Sunday 08 September 2013 09:43:29 Pali Rohár wrote:
> > Here is new version (v4) of omap secure part patch:
> > 
> > Other secure functions omap_smc1() and omap_smc2() calling
> > instruction smc #0 but Nokia RX-51 board needs to call smc #1
> > for PPA access.
> > 
> > Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > ---
> > diff --git a/arch/arm/mach-omap2/omap-secure.h
> > b/arch/arm/mach-omap2/omap-secure.h index 0e72917..c4586f4
> > 100644
> > --- a/arch/arm/mach-omap2/omap-secure.h
> > +++ b/arch/arm/mach-omap2/omap-secure.h
> > @@ -51,6 +51,7 @@
> >  extern u32 omap_secure_dispatcher(u32 idx, u32 flag, u32
> > nargs, u32 arg1, u32 arg2, u32 arg3, u32 arg4);
> >  extern u32 omap_smc2(u32 id, u32 falg, u32 pargs);
> > +extern u32 omap_smc3(u32 id, u32 process, u32 flag, u32
> > pargs); extern phys_addr_t
> > omap_secure_ram_mempool_base(void); extern int
> > omap_secure_ram_reserve_memblock(void);
> > 
> > diff --git a/arch/arm/mach-omap2/omap-smc.S
> > b/arch/arm/mach-omap2/omap-smc.S index f6441c1..fd90125
> > 100644
> > --- a/arch/arm/mach-omap2/omap-smc.S
> > +++ b/arch/arm/mach-omap2/omap-smc.S
> > @@ -1,9 +1,11 @@
> >  /*
> > - * OMAP44xx secure APIs file.
> > + * OMAP34xx and OMAP44xx secure APIs file.
> >   *
> >   * Copyright (C) 2010 Texas Instruments, Inc.
> >   * Written by Santosh Shilimkar <santosh.shilimkar@ti.com>
> >   *
> > + * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
> > + * Copyright (C) 2013 Pali Rohár <pali.rohar@gmail.com>
> >   *
> >   * This program is free software,you can redistribute it
> > and/or modify * it under the terms of the GNU General Public
> > License version 2 as @@ -54,6 +56,23 @@ ENTRY(omap_smc2)
> >  	ldmfd   sp!, {r4-r12, pc}
> >  ENDPROC(omap_smc2)
> > 
> > +/**
> > + * u32 omap_smc3(u32 service_id, u32 process_id, u32 flag,
> > u32 pargs) + * Low level common routine for secure HAL and
> > PPA APIs via smc #1 + * r0 - @service_id: Secure Service ID
> > + * r1 - @process_id: Process ID
> > + * r2 - @flag: Flag to indicate the criticality of operation
> > + * r3 - @pargs: Physical address of parameter list
> > + */
> > +ENTRY(omap_smc3)
> > +	stmfd	sp!, {r4-r11, lr}
> > +	mov	r12, r0		@ Copy the secure service ID
> > +	mov	r6, #0xff	@ Indicate new Task call
> > +	dsb			@ Memory Barrier (not sure if needed, copied from
> > omap_smc2) +	smc	#1		@ Call PPA service
> > +	ldmfd	sp!, {r4-r11, pc}
> > +ENDPROC(omap_smc3)
> > +
> >  ENTRY(omap_modify_auxcoreboot0)
> >  	stmfd   sp!, {r1-r12, lr}
> >  	ldr	r12, =0x104
> 
> Dave, it is ok now?

Yes, that's sufficient to warn people to stop and think (at least, if
someone copy-pastes it, they will likely highlight the possible error by
copy-pasting the comment too).  Thanks.

Acked-by: Dave Martin <Dave.Martin@arm.com>

