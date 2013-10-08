Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3JHTGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:06:25 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:59091 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752705Ab3JHTGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:06:08 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19LW8ezQhhMq4xseyS3MAbO
Date: Tue, 8 Oct 2013 12:05:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>, nm@ti.com, aaro.koskinen@iki.fi,
        pdeschrijver@nvidia.com, linux-kernel@vger.kernel.org,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        santosh.shilimkar@ti.com, pavel@ucw.cz, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/2] ARM: OMAP: Add secure function omap_smc3()
 which calling instruction smc #1
Message-ID: <20131008190555.GN8313@atomide.com>
References: <20130904124303.GA2369@localhost.localdomain>
 <201309080943.30542@pali>
 <5253B08C.4020305@codethink.co.uk>
 <20131008080908.GA25039@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131008080908.GA25039@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [131008 01:17]:
> On Tue, Oct 08, 2013 at 09:13:16AM +0200, Ben Dooks wrote:
> > On 08/09/13 09:43, Pali Rohár wrote:
> >> Here is new version (v4) of omap secure part patch:
> >>
> >> Other secure functions omap_smc1() and omap_smc2() calling instruction smc #0
> >> but Nokia RX-51 board needs to call smc #1 for PPA access.
> >>
> >> Signed-off-by: Ivaylo Dimitrov<freemangordon@abv.bg>
> >> Signed-off-by: Pali Rohár<pali.rohar@gmail.com>
> >> ---
> >> diff --git a/arch/arm/mach-omap2/omap-secure.h b/arch/arm/mach-omap2/omap-secure.h
> >> index 0e72917..c4586f4 100644
> >> --- a/arch/arm/mach-omap2/omap-secure.h
> >> +++ b/arch/arm/mach-omap2/omap-secure.h
> >> @@ -51,6 +51,7 @@
> >>   extern u32 omap_secure_dispatcher(u32 idx, u32 flag, u32 nargs,
> >>   				u32 arg1, u32 arg2, u32 arg3, u32 arg4);
> >>   extern u32 omap_smc2(u32 id, u32 falg, u32 pargs);
> >> +extern u32 omap_smc3(u32 id, u32 process, u32 flag, u32 pargs);
> >>   extern phys_addr_t omap_secure_ram_mempool_base(void);
> >>   extern int omap_secure_ram_reserve_memblock(void);
> >>
> >> diff --git a/arch/arm/mach-omap2/omap-smc.S b/arch/arm/mach-omap2/omap-smc.S
> >> index f6441c1..fd90125 100644
> >> --- a/arch/arm/mach-omap2/omap-smc.S
> >> +++ b/arch/arm/mach-omap2/omap-smc.S
> >> @@ -1,9 +1,11 @@
> >>   /*
> >> - * OMAP44xx secure APIs file.
> >> + * OMAP34xx and OMAP44xx secure APIs file.
> >>    *
> >>    * Copyright (C) 2010 Texas Instruments, Inc.
> >>    * Written by Santosh Shilimkar<santosh.shilimkar@ti.com>
> >>    *
> >> + * Copyright (C) 2012 Ivaylo Dimitrov<freemangordon@abv.bg>
> >> + * Copyright (C) 2013 Pali Rohár<pali.rohar@gmail.com>
> >>    *
> >>    * This program is free software,you can redistribute it and/or modify
> >>    * it under the terms of the GNU General Public License version 2 as
> >> @@ -54,6 +56,23 @@ ENTRY(omap_smc2)
> >>   	ldmfd   sp!, {r4-r12, pc}
> >>   ENDPROC(omap_smc2)
> >>
> >> +/**
> >> + * u32 omap_smc3(u32 service_id, u32 process_id, u32 flag, u32 pargs)
> >> + * Low level common routine for secure HAL and PPA APIs via smc #1
> >> + * r0 - @service_id: Secure Service ID
> >> + * r1 - @process_id: Process ID
> >> + * r2 - @flag: Flag to indicate the criticality of operation
> >> + * r3 - @pargs: Physical address of parameter list
> >> + */
> >> +ENTRY(omap_smc3)
> >> +	stmfd	sp!, {r4-r11, lr}
> >> +	mov	r12, r0		@ Copy the secure service ID
> >
> > I think you should save r12 in the call.
> 
> Not necessary.

Assuming there are no other comments I'll apply these into
omap-for-v3.13/n900 branch.

Regards,

Tony
