Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaCLJnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:43:07 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:24357
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbaCLJnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:43:02 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z579ehz98dI936eIe0eah1dbaI1432Ic8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h1806h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1de2h1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
Date: Wed, 12 Mar 2014 17:42:37 +0800
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>,
        Wang Dongsheng-B40534 <B40534@freescale.com>
Subject: Re: [PATCH 8/9] powerpc/85xx: add save/restore functions for core
 registers
Message-ID: <20140312094237.GG4706@localhost.localdomain>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
 <1394168285-32275-8-git-send-email-chenhui.zhao@freescale.com>
 <1394585114.13761.112.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1394585114.13761.112.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 07:45:14PM -0500, Scott Wood wrote:
> On Fri, 2014-03-07 at 12:58 +0800, Chenhui Zhao wrote:
> > From: Wang Dongsheng <dongsheng.wang@freescale.com>
> > 
> > Add booke_cpu_state_save() and booke_cpu_state_restore() functions which can be
> > used to save/restore CPU's registers in the case of deep sleep and hibernation.
> > 
> > Supported processors: E6500, E5500, E500MC, E500v2 and E500v1.
> > 
> > Signed-off-by: Wang Dongsheng <dongsheng.wang@freescale.com>
> > Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
> > ---
> >  arch/powerpc/include/asm/booke_save_regs.h |   96 ++++++++
> >  arch/powerpc/kernel/Makefile               |    1 +
> >  arch/powerpc/kernel/booke_save_regs.S      |  361 ++++++++++++++++++++++++++++
> >  3 files changed, 458 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/powerpc/include/asm/booke_save_regs.h
> >  create mode 100644 arch/powerpc/kernel/booke_save_regs.S
> > 
> > diff --git a/arch/powerpc/include/asm/booke_save_regs.h b/arch/powerpc/include/asm/booke_save_regs.h
> > new file mode 100644
> > index 0000000..87c357a
> > --- /dev/null
> > +++ b/arch/powerpc/include/asm/booke_save_regs.h
> > @@ -0,0 +1,96 @@
> > +/*
> > + *  Save/restore e500 series core registers
> 
> Filename says booke, comment says e500.
> 
> Filename and comment also fail to point out that this is specifically
> for standby/suspend, not for hibernate which is implemented in
> swsusp_booke.S/swsusp_asm64.S.

Sorry for inconsistency. Will changes e500 to booke.
Hibernation and suspend can share the code.

> 
> > + *
> > + * Author: Wang Dongsheng <dongsheng.wang@freescale.com>
> > + *
> > + * Copyright 2014 Freescale Semiconductor Inc.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#ifndef __ASM_FSL_SLEEP_H
> > +#define __ASM_FSL_SLEEP_H
> > +
> > +/*
> > + * 8 bytes for each register, which is compatible with
> > + * both 32-bit and 64-bit registers
> > + *
> > + * Acronyms:
> > + *	dw(data width)	0x08
> > + *
> > + * Map:
> > + * General-Purpose Registers
> > + *	GPR1(sp)		0
> > + *	GPR2			0x8		(dw * 1)
> > + *	GPR13 - GPR31		0x10 ~ 0xa0	(dw * 2 ~ dw * 20)
> 
> Putting these values in a comment separate from the code that defines it
> sounds like a good way to get a mismatch between the two.

Ok.

> 
> > + * Foating-point registers
> > + *	FPR14 - FPR31		0xa8 ~ 0x130	(dw * 21 ~ dw * 38)
> 
> Call enable_kernel_fp() or similar, rather than saving FP regs here.
> Likewise with altivec.  And why starting at FPR14?  Volatile versus
> nonvolatile is irrelevant because Linux doesn't participate in the FP
> ABI.  Everything is non-volatile *if* we have a user FP context
> resident, and everything is volatile otherwise.

Will remove them.

> 
> > + * Timer Registers
> > + *	TCR			0x168		(dw * 45)
> > + *	TB(64bit)		0x170		(dw * 46)
> > + *	TBU(32bit)		0x178		(dw * 47)
> > + *	TBL(32bit)		0x180		(dw * 48)
> 
> Why are you saving TBU/L separate from TB?  They're the same thing.

Will remove TBU and TBL.

> 
> > + * Interrupt Registers
> > + *	IVPR			0x188		(dw * 49)
> > + *	IVOR0 - IVOR15		0x190 ~ 0x208	(dw * 50 ~ dw * 65)
> > + *	IVOR32 - IVOR41		0x210 ~ 0x258	(dw * 66 ~ dw * 75)
> 
> What about IVOR42 (LRAT error)?

Will add it.

> 
> > + * Software-Use Registers
> > + *	SPRG1			0x260		(dw * 76), 64-bit need to save.
> > + *	SPRG3			0x268		(dw * 77), 32-bit need to save.
> 
> What about "CPU and NUMA node for VDSO getcpu" on 64-bit?  Currently
> SPRG3, but it will need to change for critical interrupt support.
> 
> > + * MMU Registers
> > + *	PID0 - PID2		0x270 ~ 0x280	(dw * 78 ~ dw * 80)
> 
> PID1/PID2 are e500v1/v2 only -- and Linux doesn't use them outside of
> KVM (and you're not in KVM when you're running this code).
> 
> Are we ever going to have a non-zero PID at this point?

I incline to the view that saving all registers regardless of used or
unused. The good point is that it can be compliant to the future
changes of the usage of registers.

What do you think?

> 
> > + * Debug Registers
> > + *	DBCR0 - DBCR2		0x288 ~ 0x298	(dw * 81 ~ dw * 83)
> > + *	IAC1 - IAC4		0x2a0 ~ 0x2b8	(dw * 84 ~ dw * 87)
> > + *	DAC1 - DAC2		0x2c0 ~ 0x2c8	(dw * 88 ~ dw * 89)
> > + *
> > + */
> 
> IAC3-4 are not implemented on e500.
> 
> Do we really need to save the debug registers?  We're not going to be in
> a debugged process when we do suspend.  If the concern is kgdb, it
> probably needs to be told to get out of the way during suspend for other
> reasons.

I think in the ideal case the suspend would not break any context. We
should try to save/restore all cpu state. Of cause, trade-off is
unavoidable in practice.

> 
> > +#define SR_GPR1			0x000
> > +#define SR_GPR2			0x008
> > +#define SR_GPR13		0x010
> > +#define SR_FPR14		0x0a8
> > +#define SR_CR			0x138
> > +#define SR_LR			0x140
> > +#define SR_MSR			0x148
> 
> These are very vague names to be putting in a header file.

How about BOOKE_xx_OFFSET?

> 
> > +/*
> > + * hibernation and deepsleep save/restore different number of registers,
> > + * use these flags to indicate.
> > + */
> > +#define HIBERNATION_FLAG	1
> > +#define DEEPSLEEP_FLAG		2
> 
> Again, namespacing -- but why is hibernation using this at all?  What's
> wrong with the existing hibernation support?

How about BOOKE_HIBERNATION_FLAG?

Just wish to share code between hibernation and suspend.

> 
> > diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> > index fcc9a89..64acae6 100644
> > --- a/arch/powerpc/kernel/Makefile
> > +++ b/arch/powerpc/kernel/Makefile
> > @@ -73,6 +73,7 @@ obj-$(CONFIG_HIBERNATION)	+= swsusp_booke.o
> >  else
> >  obj-$(CONFIG_HIBERNATION)	+= swsusp_$(CONFIG_WORD_SIZE).o
> >  endif
> > +obj-$(CONFIG_E500)		+= booke_save_regs.o
> 
> Shouldn't this depend on whether suspend is enabled?
> 
> > diff --git a/arch/powerpc/kernel/booke_save_regs.S b/arch/powerpc/kernel/booke_save_regs.S
> > new file mode 100644
> > index 0000000..9ccd576
> > --- /dev/null
> > +++ b/arch/powerpc/kernel/booke_save_regs.S
> > @@ -0,0 +1,361 @@
> > +/*
> > + * Freescale Power Management, Save/Restore core state
> > + *
> > + * Copyright 2014 Freescale Semiconductor, Inc.
> > + * Author: Wang Dongsheng <dongsheng.wang@freescale.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version
> > + * 2 of the License, or (at your option) any later version.
> > + */
> > +
> > +#include <asm/ppc_asm.h>
> > +#include <asm/booke_save_regs.h>
> > +
> > +/*
> > + * Supported Core List:
> > + * E500v1, E500v2, E500MC, E5500, E6500.
> > + */
> > +
> > +/* Save/Restore register operation define */
> > +#define do_save_gpr_reg(reg, addr) \
> > +	PPC_STL reg, addr(r10)
> > +
> > +#define do_save_fpr_reg(reg, addr) \
> > +	stfd	reg, addr(r10)
> > +
> > +#define do_save_spr_reg(reg, addr) \
> > +	mfspr	r0, SPRN_##reg ;\
> > +	PPC_STL r0, addr(r10)
> > +
> > +#define do_save_special_reg(special, addr) \
> > +	mf##special	r0 ;\
> > +	PPC_STL r0, addr(r10)
> > +
> > +#define do_restore_gpr_reg(reg, addr) \
> > +	PPC_LL reg, addr(r10)
> > +
> > +#define do_restore_fpr_reg(reg, addr) \
> > +	lfd	reg, addr(r10)
> > +
> > +#define do_restore_spr_reg(reg, addr) \
> > +	PPC_LL r0, addr(r10) ;\
> > +	mtspr	SPRN_##reg, r0
> > +
> > +#define do_restore_special_reg(special, addr) \
> > +	PPC_LL r0, addr(r10) ;\
> > +	mt##special	r0
> > +
> > +#define do_sr_general_gpr_regs(func) \
> > +	do_##func##_gpr_reg(r1, SR_GPR1) ;\
> > +	do_##func##_gpr_reg(r2, SR_GPR2) ;\
> > +	do_##func##_gpr_reg(r13, SR_GPR13 + 0x00) ;\
> > +	do_##func##_gpr_reg(r14, SR_GPR13 + 0x08) ;\
> > +	do_##func##_gpr_reg(r15, SR_GPR13 + 0x10) ;\
> > +	do_##func##_gpr_reg(r16, SR_GPR13 + 0x18) ;\
> > +	do_##func##_gpr_reg(r17, SR_GPR13 + 0x20) ;\
> > +	do_##func##_gpr_reg(r18, SR_GPR13 + 0x28) ;\
> > +	do_##func##_gpr_reg(r19, SR_GPR13 + 0x30) ;\
> > +	do_##func##_gpr_reg(r20, SR_GPR13 + 0x38) ;\
> > +	do_##func##_gpr_reg(r21, SR_GPR13 + 0x40) ;\
> > +	do_##func##_gpr_reg(r22, SR_GPR13 + 0x48) ;\
> > +	do_##func##_gpr_reg(r23, SR_GPR13 + 0x50) ;\
> > +	do_##func##_gpr_reg(r24, SR_GPR13 + 0x58) ;\
> > +	do_##func##_gpr_reg(r25, SR_GPR13 + 0x60) ;\
> > +	do_##func##_gpr_reg(r26, SR_GPR13 + 0x68) ;\
> > +	do_##func##_gpr_reg(r27, SR_GPR13 + 0x70) ;\
> > +	do_##func##_gpr_reg(r28, SR_GPR13 + 0x78) ;\
> > +	do_##func##_gpr_reg(r29, SR_GPR13 + 0x80) ;\
> > +	do_##func##_gpr_reg(r30, SR_GPR13 + 0x88) ;\
> > +	do_##func##_gpr_reg(r31, SR_GPR13 + 0x90)
> > +
> > +#define do_sr_general_pcr_regs(func) \
> > +	do_##func##_spr_reg(EPCR, SR_EPCR) ;\
> > +	do_##func##_spr_reg(HID0, SR_HID0 + 0x00)
> > +
> > +#define do_sr_e500_pcr_regs(func) \
> > +	do_##func##_spr_reg(HID1, SR_HID0 + 0x08)
> 
> PCR?
> 
> In the comments you said "Only e500, e500v2 need to save HID0 - HID1",
> yet you save HID0 in the "general" macro.

Will change it.

> 
> > +#define do_sr_save_tb_regs \
> > +	do_save_spr_reg(TBRU, SR_TBU) ;\
> > +	do_save_spr_reg(TBRL, SR_TBL)
> 
> What if TBU increments between those two reads?  Use the standard
> sequence to read the timebase.
> 
> > +#define do_sr_interrupt_regs(func) \
> > +	do_##func##_spr_reg(IVPR, SR_IVPR) ;\
> > +	do_##func##_spr_reg(IVOR0, SR_IVOR0 + 0x00) ;\
> > +	do_##func##_spr_reg(IVOR1, SR_IVOR0 + 0x08) ;\
> > +	do_##func##_spr_reg(IVOR2, SR_IVOR0 + 0x10) ;\
> > +	do_##func##_spr_reg(IVOR3, SR_IVOR0 + 0x18) ;\
> > +	do_##func##_spr_reg(IVOR4, SR_IVOR0 + 0x20) ;\
> > +	do_##func##_spr_reg(IVOR5, SR_IVOR0 + 0x28) ;\
> > +	do_##func##_spr_reg(IVOR6, SR_IVOR0 + 0x30) ;\
> > +	do_##func##_spr_reg(IVOR7, SR_IVOR0 + 0x38) ;\
> > +	do_##func##_spr_reg(IVOR8, SR_IVOR0 + 0x40) ;\
> > +	do_##func##_spr_reg(IVOR10, SR_IVOR0 + 0x50) ;\
> > +	do_##func##_spr_reg(IVOR11, SR_IVOR0 + 0x58) ;\
> > +	do_##func##_spr_reg(IVOR12, SR_IVOR0 + 0x60) ;\
> > +	do_##func##_spr_reg(IVOR13, SR_IVOR0 + 0x68) ;\
> > +	do_##func##_spr_reg(IVOR14, SR_IVOR0 + 0x70) ;\
> > +	do_##func##_spr_reg(IVOR15, SR_IVOR0 + 0x78)
> > +
> > +#define do_e500_sr_interrupt_regs(func) \
> > +	do_##func##_spr_reg(IVOR32, SR_IVOR32 + 0x00) ;\
> > +	do_##func##_spr_reg(IVOR33, SR_IVOR32 + 0x08) ;\
> > +	do_##func##_spr_reg(IVOR34, SR_IVOR32 + 0x10)
> > +
> > +#define do_e500mc_sr_interrupt_regs(func) \
> > +	do_##func##_spr_reg(IVOR9, SR_IVOR0 + 0x48) ;\
> > +	do_##func##_spr_reg(IVOR35, SR_IVOR32 + 0x18) ;\
> > +	do_##func##_spr_reg(IVOR36, SR_IVOR32 + 0x20) ;\
> > +	do_##func##_spr_reg(IVOR37, SR_IVOR32 + 0x28) ;\
> > +	do_##func##_spr_reg(IVOR38, SR_IVOR32 + 0x30) ;\
> > +	do_##func##_spr_reg(IVOR39, SR_IVOR32 + 0x38) ;\
> > +	do_##func##_spr_reg(IVOR40, SR_IVOR32 + 0x40) ;\
> > +	do_##func##_spr_reg(IVOR41, SR_IVOR32 + 0x48)
> > +
> > +#define do_e5500_sr_interrupt_regs(func) \
> > +	do_e500mc_sr_interrupt_regs(func)
> > +
> > +#define do_e6500_sr_interrupt_regs(func) \
> > +	do_##func##_spr_reg(IVOR32, SR_IVOR32 + 0x00) ;\
> > +	do_##func##_spr_reg(IVOR33, SR_IVOR32 + 0x08) ;\
> > +	do_e5500_sr_interrupt_regs(func)
> > +
> > +#define do_sr_general_software_regs(func) \
> > +	do_##func##_spr_reg(SPRG1, SR_SPRG1) ;\
> > +	do_##func##_spr_reg(SPRG3, SR_SPRG3) ;\
> > +	do_##func##_spr_reg(PID0, SR_PID0)
> > +
> > +#define do_sr_e500_mmu_regs(func) \
> > +	do_##func##_spr_reg(PID1, SR_PID0 + 0x08) ;\
> > +	do_##func##_spr_reg(PID2, SR_PID0 + 0x10)
> > +
> > +#define do_sr_debug_regs(func) \
> > +	do_##func##_spr_reg(DBCR0, SR_DBCR0 + 0x00) ;\
> > +	do_##func##_spr_reg(DBCR1, SR_DBCR0 + 0x08) ;\
> > +	do_##func##_spr_reg(DBCR2, SR_DBCR0 + 0x10) ;\
> > +	do_##func##_spr_reg(IAC1, SR_IAC1 + 0x00) ;\
> > +	do_##func##_spr_reg(IAC2, SR_IAC1 + 0x08) ;\
> > +	do_##func##_spr_reg(DAC1, SR_DAC1 + 0x00) ;\
> > +	do_##func##_spr_reg(DAC2, SR_DAC1 + 0x08)
> > +
> > +#define do_e6500_sr_debug_regs(func) \
> > +	do_##func##_spr_reg(IAC3, SR_IAC1 + 0x10) ;\
> > +	do_##func##_spr_reg(IAC4, SR_IAC1 + 0x18)
> > +
> > +	.section .text
> > +	.align	5
> > +booke_cpu_base_save:
> > +	do_sr_general_gpr_regs(save)
> > +	do_sr_general_pcr_regs(save)
> > +	do_sr_general_software_regs(save)
> > +1:
> > +	mfspr	r5, SPRN_TBRU
> > +	do_sr_general_time_regs(save)
> > +	mfspr	r6, SPRN_TBRU
> > +	cmpw	r5, r6
> > +	bne	1b
> 
> Oh, here's where you deal with that.  Why?  It just obfuscates things.

Will make it more readable.

> 
> > +booke_cpu_base_restore:
> > +	do_sr_general_gpr_regs(restore)
> > +	do_sr_general_pcr_regs(restore)
> > +	do_sr_general_software_regs(restore)
> > +
> > +	isync
> > +
> > +	/* Restore Time registers, clear tb lower to avoid wrap */
> > +	li	r0, 0
> > +	mtspr	SPRN_TBWL, r0
> > +	do_sr_general_time_regs(restore)
> 
> Why is zeroing TBL not done in the same place as you load the new TB?

Will fix it.

> 
> > +/* Base registers, e500v1, e500v2 need to do some special save/restore */
> > +e500_base_special_save:
> > +	lis	r12, 0
> > +	ori	r12, r12, PVR_VER_E500V1@l
> > +	cmpw	r11, r12
> > +	beq	1f
> > +
> > +	lis	r12, 0
> > +	ori	r12, r12, PVR_VER_E500V2@l
> > +	cmpw	r11, r12
> > +	bne	2f
> > +1:
> > +	do_sr_e500_pcr_regs(save)
> > +	do_sr_e500_mmu_regs(save)
> > +2:
> > +	blr
> > +
> > +e500_base_special_restore:
> > +	lis	r12, 0
> > +	ori	r12, r12, PVR_VER_E500V1@l
> > +	cmpw	r11, r12
> > +	beq	1f
> > +
> > +	lis	r12, 0
> > +	ori	r12, r12, PVR_VER_E500V2@l
> > +	cmpw	r11, r12
> > +	bne	2f
> > +1:
> > +	do_sr_e500_pcr_regs(save)
> > +	do_sr_e500_mmu_regs(save)
> > +2:
> > +	blr
> 
> Why is this separate from the other CPU-specific "append" code?
> 
> > +booke_cpu_append_save:
> > +	mfspr	r0, SPRN_PVR
> > +	rlwinm	r11, r0, 16, 16, 31
> > +
> > +	lis	r12, 0
> > +	ori	r12, r12, PVR_VER_E6500@l
> > +	cmpw	r11, r12
> > +	beq	e6500_append_save
> > +
> > +	lis	r12, 0
> > +	ori	r12, r12, PVR_VER_E5500@l
> > +	cmpw	r11, r12
> > +	beq	e5500_append_save
> > +
> > +	lis	r12, 0
> > +	ori	r12, r12, PVR_VER_E500MC@l
> > +	cmpw	r11, r12
> > +	beq	e500mc_append_save
> > +
> > +	lis	r12, 0
> > +	ori	r12, r12, PVR_VER_E500V2@l
> > +	cmpw	r11, r12
> > +	beq	e500v2_append_save
> > +
> > +	lis	r12, 0
> > +	ori	r12, r12, PVR_VER_E500V1@l
> > +	cmpw	r11, r12
> > +	beq	e500v1_append_save
> > +	b	1f
> > +
> > +e6500_append_save:
> > +	do_e6500_sr_interrupt_regs(save)
> > +	do_e6500_sr_debug_regs(save)
> > +	b	1f
> > +
> > +e5500_append_save:
> > +	do_e5500_sr_interrupt_regs(save)
> > +	b	1f
> > +
> > +e500mc_append_save:
> > +	do_e500mc_sr_interrupt_regs(save)
> > +	b	1f
> > +
> > +e500v2_append_save:
> > +e500v1_append_save:
> > +	do_e500_sr_interrupt_regs(save)
> > +1:
> > +	do_sr_interrupt_regs(save)
> > +	do_sr_debug_regs(save)
> > +
> > +	blr
> 
> What is meant by "append" here?

Means extra registers for specific e500 derivative core.

> 
> > +/*
> > + * r3 = the address of buffer
> > + * r4 = type: HIBERNATION_FLAG or DEEPSLEEP_FLAG
> > + */
> > +_GLOBAL(booke_cpu_state_save)
> > +	mflr	r9
> > +	mr	r10, r3
> > +
> > +	cmpwi	r4, HIBERNATION_FLAG
> > +	beq	1f
> > +	bl	booke_cpu_append_save
> > +1:
> > +	bl	e500_base_special_save
> > +	bl	booke_cpu_base_save
> > +
> > +	mtlr	r9
> > +	blr
> 
> You're assuming a special ABI from these subfunctions (e.g. r9
> non-volatile) but I don't see any comment to that effect on those
> functions.
> 
> -Scott

Will add comments.

-Chenhui


