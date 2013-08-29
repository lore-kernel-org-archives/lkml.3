Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab3H2OgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:36:17 -0400
Received: from queue01c.mail.zen.net.uk ([212.23.3.237]:50545 "EHLO
	queue01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab3H2OgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:36:15 -0400
X-Greylist: delayed 1501 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Aug 2013 10:36:14 EDT
Message-ID: <1377785283.3529.37.camel@linaro1.home>
Subject: Re: [PATCH 7/9] ARM: Move uprobes/kprobes shared functions to
 common file
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Aug 2013 15:08:03 +0100
In-Reply-To: <1375400753-3454-8-git-send-email-dave.long@linaro.org>
References: <1375400753-3454-1-git-send-email-dave.long@linaro.org>
	 <1375400753-3454-8-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 19:45 -0400, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> Separate the kprobe-only functions from the functions needed by
> both kprobes and uprobes.
> 
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---

This re-factoring looks a bit back-to-front to me, e.g. the instruction
emulation routines in kprobes-arm.c, which are only used by kprobes are
moved into the common probes-arm.c file, whilst the common decoding
tables are left in the kprobes-arm.c. Surely it should be the other way
around, or have I missed something?

As is, it leads to things like emulate_rd12rn16rm0rs8_rwflags being
defined in probes-arm.c and used in kprobes-arm.c with a prototype added
to kprobes.h, when it could just stay completely local to kprobes-arm.c.

And in a later patch when uprobes is added, it has to link in
kprobes-arm.o to get the generic decoding table. That was the red flag
which made meet look again, as it seems wrong that after all this  code
re-factoring uprobes should need any kprobe files.

I have no other comments on this patch, save you scrolling down :-)
but I'm leaving the patch quoted here for others' reference as I'm late
in replying and people may no longer have the original...

>  arch/arm/kernel/Makefile         |   2 +-
>  arch/arm/kernel/kprobes-arm.c    | 298 +------------------------------------
>  arch/arm/kernel/kprobes-common.c | 266 ---------------------------------
>  arch/arm/kernel/kprobes-thumb.c  |  14 +-
>  arch/arm/kernel/kprobes.h        |   4 +-
>  arch/arm/kernel/probes-arm.c     | 311 +++++++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/probes.c         | 286 +++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/probes.h         |  23 +++
>  8 files changed, 635 insertions(+), 569 deletions(-)
>  create mode 100644 arch/arm/kernel/probes-arm.c
>  create mode 100644 arch/arm/kernel/probes.c
>  create mode 100644 arch/arm/kernel/probes.h
> 
> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
> index 86d10dd..3292023 100644
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -49,7 +49,7 @@ obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o insn.o
>  obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o insn.o
>  obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o insn.o patch.o
>  obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
> -obj-$(CONFIG_KPROBES)		+= kprobes.o kprobes-common.o patch.o
> +obj-$(CONFIG_KPROBES)		+= probes.o probes-arm.o kprobes.o kprobes-common.o patch.o
>  ifdef CONFIG_THUMB2_KERNEL
>  obj-$(CONFIG_KPROBES)		+= kprobes-thumb.o
>  else
> diff --git a/arch/arm/kernel/kprobes-arm.c b/arch/arm/kernel/kprobes-arm.c
> index 8a30c89..d6503cc 100644
> --- a/arch/arm/kernel/kprobes-arm.c
> +++ b/arch/arm/kernel/kprobes-arm.c
> @@ -62,19 +62,9 @@
>  #include <linux/kprobes.h>
>  #include <linux/module.h>
>  
> +#include "probes.h"
>  #include "kprobes.h"
>  
> -#define sign_extend(x, signbit) ((x) | (0 - ((x) & (1 << (signbit)))))
> -
> -#define branch_displacement(insn) sign_extend(((insn) & 0xffffff) << 2, 25)
> -
> -#if  __LINUX_ARM_ARCH__ >= 6
> -#define BLX(reg)	"blx	"reg"		\n\t"
> -#else
> -#define BLX(reg)	"mov	lr, pc		\n\t"	\
> -			"mov	pc, "reg"	\n\t"
> -#endif
> -
>  /*
>   * To avoid the complications of mimicing single-stepping on a
>   * processor without a Next-PC or a single-step mode, and to
> @@ -105,284 +95,6 @@
>   * read and write of flags.
>   */
>  
> -static void __kprobes simulate_bbl(struct kprobe *p, struct pt_regs *regs)
> -{
> -	kprobe_opcode_t insn = p->opcode;
> -	long iaddr = (long)p->addr;
> -	int disp  = branch_displacement(insn);
> -
> -	if (insn & (1 << 24))
> -		regs->ARM_lr = iaddr + 4;
> -
> -	regs->ARM_pc = iaddr + 8 + disp;
> -}
> -
> -static void __kprobes simulate_blx1(struct kprobe *p, struct pt_regs *regs)
> -{
> -	kprobe_opcode_t insn = p->opcode;
> -	long iaddr = (long)p->addr;
> -	int disp = branch_displacement(insn);
> -
> -	regs->ARM_lr = iaddr + 4;
> -	regs->ARM_pc = iaddr + 8 + disp + ((insn >> 23) & 0x2);
> -	regs->ARM_cpsr |= PSR_T_BIT;
> -}
> -
> -static void __kprobes simulate_blx2bx(struct kprobe *p, struct pt_regs *regs)
> -{
> -	kprobe_opcode_t insn = p->opcode;
> -	int rm = insn & 0xf;
> -	long rmv = regs->uregs[rm];
> -
> -	if (insn & (1 << 5))
> -		regs->ARM_lr = (long)p->addr + 4;
> -
> -	regs->ARM_pc = rmv & ~0x1;
> -	regs->ARM_cpsr &= ~PSR_T_BIT;
> -	if (rmv & 0x1)
> -		regs->ARM_cpsr |= PSR_T_BIT;
> -}
> -
> -static void __kprobes simulate_mrs(struct kprobe *p, struct pt_regs *regs)
> -{
> -	kprobe_opcode_t insn = p->opcode;
> -	int rd = (insn >> 12) & 0xf;
> -	unsigned long mask = 0xf8ff03df; /* Mask out execution state */
> -	regs->uregs[rd] = regs->ARM_cpsr & mask;
> -}
> -
> -static void __kprobes simulate_mov_ipsp(struct kprobe *p, struct pt_regs *regs)
> -{
> -	regs->uregs[12] = regs->uregs[13];
> -}
> -
> -static void __kprobes
> -emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs)
> -{
> -	kprobe_opcode_t insn = p->opcode;
> -	unsigned long pc = (unsigned long)p->addr + 8;
> -	int rt = (insn >> 12) & 0xf;
> -	int rn = (insn >> 16) & 0xf;
> -	int rm = insn & 0xf;
> -
> -	register unsigned long rtv asm("r0") = regs->uregs[rt];
> -	register unsigned long rt2v asm("r1") = regs->uregs[rt+1];
> -	register unsigned long rnv asm("r2") = (rn == 15) ? pc
> -							  : regs->uregs[rn];
> -	register unsigned long rmv asm("r3") = regs->uregs[rm];
> -
> -	__asm__ __volatile__ (
> -		BLX("%[fn]")
> -		: "=r" (rtv), "=r" (rt2v), "=r" (rnv)
> -		: "0" (rtv), "1" (rt2v), "2" (rnv), "r" (rmv),
> -		  [fn] "r" (p->ainsn.insn_fn)
> -		: "lr", "memory", "cc"
> -	);
> -
> -	regs->uregs[rt] = rtv;
> -	regs->uregs[rt+1] = rt2v;
> -	if (is_writeback(insn))
> -		regs->uregs[rn] = rnv;
> -}
> -
> -static void __kprobes
> -emulate_ldr(struct kprobe *p, struct pt_regs *regs)
> -{
> -	kprobe_opcode_t insn = p->opcode;
> -	unsigned long pc = (unsigned long)p->addr + 8;
> -	int rt = (insn >> 12) & 0xf;
> -	int rn = (insn >> 16) & 0xf;
> -	int rm = insn & 0xf;
> -
> -	register unsigned long rtv asm("r0");
> -	register unsigned long rnv asm("r2") = (rn == 15) ? pc
> -							  : regs->uregs[rn];
> -	register unsigned long rmv asm("r3") = regs->uregs[rm];
> -
> -	__asm__ __volatile__ (
> -		BLX("%[fn]")
> -		: "=r" (rtv), "=r" (rnv)
> -		: "1" (rnv), "r" (rmv), [fn] "r" (p->ainsn.insn_fn)
> -		: "lr", "memory", "cc"
> -	);
> -
> -	if (rt == 15)
> -		load_write_pc(rtv, regs);
> -	else
> -		regs->uregs[rt] = rtv;
> -
> -	if (is_writeback(insn))
> -		regs->uregs[rn] = rnv;
> -}
> -
> -static void __kprobes
> -emulate_str(struct kprobe *p, struct pt_regs *regs)
> -{
> -	kprobe_opcode_t insn = p->opcode;
> -	unsigned long rtpc = (unsigned long)p->addr + str_pc_offset;
> -	unsigned long rnpc = (unsigned long)p->addr + 8;
> -	int rt = (insn >> 12) & 0xf;
> -	int rn = (insn >> 16) & 0xf;
> -	int rm = insn & 0xf;
> -
> -	register unsigned long rtv asm("r0") = (rt == 15) ? rtpc
> -							  : regs->uregs[rt];
> -	register unsigned long rnv asm("r2") = (rn == 15) ? rnpc
> -							  : regs->uregs[rn];
> -	register unsigned long rmv asm("r3") = regs->uregs[rm];
> -
> -	__asm__ __volatile__ (
> -		BLX("%[fn]")
> -		: "=r" (rnv)
> -		: "r" (rtv), "0" (rnv), "r" (rmv), [fn] "r" (p->ainsn.insn_fn)
> -		: "lr", "memory", "cc"
> -	);
> -
> -	if (is_writeback(insn))
> -		regs->uregs[rn] = rnv;
> -}
> -
> -static void __kprobes
> -emulate_rd12rn16rm0rs8_rwflags(struct kprobe *p, struct pt_regs *regs)
> -{
> -	kprobe_opcode_t insn = p->opcode;
> -	unsigned long pc = (unsigned long)p->addr + 8;
> -	int rd = (insn >> 12) & 0xf;
> -	int rn = (insn >> 16) & 0xf;
> -	int rm = insn & 0xf;
> -	int rs = (insn >> 8) & 0xf;
> -
> -	register unsigned long rdv asm("r0") = regs->uregs[rd];
> -	register unsigned long rnv asm("r2") = (rn == 15) ? pc
> -							  : regs->uregs[rn];
> -	register unsigned long rmv asm("r3") = (rm == 15) ? pc
> -							  : regs->uregs[rm];
> -	register unsigned long rsv asm("r1") = regs->uregs[rs];
> -	unsigned long cpsr = regs->ARM_cpsr;
> -
> -	__asm__ __volatile__ (
> -		"msr	cpsr_fs, %[cpsr]	\n\t"
> -		BLX("%[fn]")
> -		"mrs	%[cpsr], cpsr		\n\t"
> -		: "=r" (rdv), [cpsr] "=r" (cpsr)
> -		: "0" (rdv), "r" (rnv), "r" (rmv), "r" (rsv),
> -		  "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
> -		: "lr", "memory", "cc"
> -	);
> -
> -	if (rd == 15)
> -		alu_write_pc(rdv, regs);
> -	else
> -		regs->uregs[rd] = rdv;
> -	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
> -}
> -
> -static void __kprobes
> -emulate_rd12rn16rm0_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
> -{
> -	kprobe_opcode_t insn = p->opcode;
> -	int rd = (insn >> 12) & 0xf;
> -	int rn = (insn >> 16) & 0xf;
> -	int rm = insn & 0xf;
> -
> -	register unsigned long rdv asm("r0") = regs->uregs[rd];
> -	register unsigned long rnv asm("r2") = regs->uregs[rn];
> -	register unsigned long rmv asm("r3") = regs->uregs[rm];
> -	unsigned long cpsr = regs->ARM_cpsr;
> -
> -	__asm__ __volatile__ (
> -		"msr	cpsr_fs, %[cpsr]	\n\t"
> -		BLX("%[fn]")
> -		"mrs	%[cpsr], cpsr		\n\t"
> -		: "=r" (rdv), [cpsr] "=r" (cpsr)
> -		: "0" (rdv), "r" (rnv), "r" (rmv),
> -		  "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
> -		: "lr", "memory", "cc"
> -	);
> -
> -	regs->uregs[rd] = rdv;
> -	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
> -}
> -
> -static void __kprobes
> -emulate_rd16rn12rm0rs8_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
> -{
> -	kprobe_opcode_t insn = p->opcode;
> -	int rd = (insn >> 16) & 0xf;
> -	int rn = (insn >> 12) & 0xf;
> -	int rm = insn & 0xf;
> -	int rs = (insn >> 8) & 0xf;
> -
> -	register unsigned long rdv asm("r2") = regs->uregs[rd];
> -	register unsigned long rnv asm("r0") = regs->uregs[rn];
> -	register unsigned long rmv asm("r3") = regs->uregs[rm];
> -	register unsigned long rsv asm("r1") = regs->uregs[rs];
> -	unsigned long cpsr = regs->ARM_cpsr;
> -
> -	__asm__ __volatile__ (
> -		"msr	cpsr_fs, %[cpsr]	\n\t"
> -		BLX("%[fn]")
> -		"mrs	%[cpsr], cpsr		\n\t"
> -		: "=r" (rdv), [cpsr] "=r" (cpsr)
> -		: "0" (rdv), "r" (rnv), "r" (rmv), "r" (rsv),
> -		  "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
> -		: "lr", "memory", "cc"
> -	);
> -
> -	regs->uregs[rd] = rdv;
> -	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
> -}
> -
> -static void __kprobes
> -emulate_rd12rm0_noflags_nopc(struct kprobe *p, struct pt_regs *regs)
> -{
> -	kprobe_opcode_t insn = p->opcode;
> -	int rd = (insn >> 12) & 0xf;
> -	int rm = insn & 0xf;
> -
> -	register unsigned long rdv asm("r0") = regs->uregs[rd];
> -	register unsigned long rmv asm("r3") = regs->uregs[rm];
> -
> -	__asm__ __volatile__ (
> -		BLX("%[fn]")
> -		: "=r" (rdv)
> -		: "0" (rdv), "r" (rmv), [fn] "r" (p->ainsn.insn_fn)
> -		: "lr", "memory", "cc"
> -	);
> -
> -	regs->uregs[rd] = rdv;
> -}
> -
> -static void __kprobes
> -emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
> -{
> -	kprobe_opcode_t insn = p->opcode;
> -	int rdlo = (insn >> 12) & 0xf;
> -	int rdhi = (insn >> 16) & 0xf;
> -	int rn = insn & 0xf;
> -	int rm = (insn >> 8) & 0xf;
> -
> -	register unsigned long rdlov asm("r0") = regs->uregs[rdlo];
> -	register unsigned long rdhiv asm("r2") = regs->uregs[rdhi];
> -	register unsigned long rnv asm("r3") = regs->uregs[rn];
> -	register unsigned long rmv asm("r1") = regs->uregs[rm];
> -	unsigned long cpsr = regs->ARM_cpsr;
> -
> -	__asm__ __volatile__ (
> -		"msr	cpsr_fs, %[cpsr]	\n\t"
> -		BLX("%[fn]")
> -		"mrs	%[cpsr], cpsr		\n\t"
> -		: "=r" (rdlov), "=r" (rdhiv), [cpsr] "=r" (cpsr)
> -		: "0" (rdlov), "1" (rdhiv), "r" (rnv), "r" (rmv),
> -		  "2" (cpsr), [fn] "r" (p->ainsn.insn_fn)
> -		: "lr", "memory", "cc"
> -	);
> -
> -	regs->uregs[rdlo] = rdlov;
> -	regs->uregs[rdhi] = rdhiv;
> -	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
> -}
> -
>  /*
>   * For the instruction masking and comparisons in all the "space_*"
>   * functions below, Do _not_ rearrange the order of tests unless
> @@ -400,13 +112,13 @@ static const union decode_item arm_1111_table[] = {
>  	/* PLDI (immediate)	1111 0100 x101 xxxx xxxx xxxx xxxx xxxx */
>  	/* PLDW (immediate)	1111 0101 x001 xxxx xxxx xxxx xxxx xxxx */
>  	/* PLD (immediate)	1111 0101 x101 xxxx xxxx xxxx xxxx xxxx */
> -	DECODE_SIMULATE	(0xfe300000, 0xf4100000, kprobe_simulate_nop),
> +	DECODE_SIMULATE	(0xfe300000, 0xf4100000, probes_simulate_nop),
>  
>  	/* memory hint		1111 0110 x001 xxxx xxxx xxxx xxx0 xxxx */
>  	/* PLDI (register)	1111 0110 x101 xxxx xxxx xxxx xxx0 xxxx */
>  	/* PLDW (register)	1111 0111 x001 xxxx xxxx xxxx xxx0 xxxx */
>  	/* PLD (register)	1111 0111 x101 xxxx xxxx xxxx xxx0 xxxx */
> -	DECODE_SIMULATE	(0xfe300010, 0xf6100000, kprobe_simulate_nop),
> +	DECODE_SIMULATE	(0xfe300010, 0xf6100000, probes_simulate_nop),
>  
>  	/* BLX (immediate)	1111 101x xxxx xxxx xxxx xxxx xxxx xxxx */
>  	DECODE_SIMULATE	(0xfe000000, 0xfa000000, simulate_blx1),
> @@ -649,11 +361,11 @@ static const union decode_item arm_cccc_001x_table[] = {
>  	/* YIELD		cccc 0011 0010 0000 xxxx xxxx 0000 0001 */
>  	DECODE_OR	(0x0fff00ff, 0x03200001),
>  	/* SEV			cccc 0011 0010 0000 xxxx xxxx 0000 0100 */
> -	DECODE_EMULATE	(0x0fff00ff, 0x03200004, kprobe_emulate_none),
> +	DECODE_EMULATE	(0x0fff00ff, 0x03200004, probes_emulate_none),
>  	/* NOP			cccc 0011 0010 0000 xxxx xxxx 0000 0000 */
>  	/* WFE			cccc 0011 0010 0000 xxxx xxxx 0000 0010 */
>  	/* WFI			cccc 0011 0010 0000 xxxx xxxx 0000 0011 */
> -	DECODE_SIMULATE	(0x0fff00fc, 0x03200000, kprobe_simulate_nop),
> +	DECODE_SIMULATE	(0x0fff00fc, 0x03200000, probes_simulate_nop),
>  	/* DBG			cccc 0011 0010 0000 xxxx xxxx ffff xxxx */
>  	/* unallocated hints	cccc 0011 0010 0000 xxxx xxxx xxxx xxxx */
>  	/* MSR (immediate)	cccc 0011 0x10 xxxx xxxx xxxx xxxx xxxx */
> diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
> index 18a7628..b66e9f7 100644
> --- a/arch/arm/kernel/kprobes-common.c
> +++ b/arch/arm/kernel/kprobes-common.c
> @@ -173,15 +173,6 @@ kprobe_check_cc * const kprobe_condition_checks[16] = {
>  };
>  
> 
> -void __kprobes kprobe_simulate_nop(struct kprobe *p, struct pt_regs *regs)
> -{
> -}
> -
> -void __kprobes kprobe_emulate_none(struct kprobe *p, struct pt_regs *regs)
> -{
> -	p->ainsn.insn_fn();
> -}
> -
>  static void __kprobes simulate_ldm1stm1(struct kprobe *p, struct pt_regs *regs)
>  {
>  	kprobe_opcode_t insn = p->opcode;
> @@ -319,260 +310,3 @@ kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi)
>  	return INSN_GOOD_NO_SLOT;
>  }
>  
> -
> -/*
> - * Prepare an instruction slot to receive an instruction for emulating.
> - * This is done by placing a subroutine return after the location where the
> - * instruction will be placed. We also modify ARM instructions to be
> - * unconditional as the condition code will already be checked before any
> - * emulation handler is called.
> - */
> -static kprobe_opcode_t __kprobes
> -prepare_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> -								bool thumb)
> -{
> -#ifdef CONFIG_THUMB2_KERNEL
> -	if (thumb) {
> -		u16 *thumb_insn = (u16 *)asi->insn;
> -		thumb_insn[1] = 0x4770; /* Thumb bx lr */
> -		thumb_insn[2] = 0x4770; /* Thumb bx lr */
> -		return insn;
> -	}
> -	asi->insn[1] = 0xe12fff1e; /* ARM bx lr */
> -#else
> -	asi->insn[1] = 0xe1a0f00e; /* mov pc, lr */
> -#endif
> -	/* Make an ARM instruction unconditional */
> -	if (insn < 0xe0000000)
> -		insn = (insn | 0xe0000000) & ~0x10000000;
> -	return insn;
> -}
> -
> -/*
> - * Write a (probably modified) instruction into the slot previously prepared by
> - * prepare_emulated_insn
> - */
> -static void  __kprobes
> -set_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> -								bool thumb)
> -{
> -#ifdef CONFIG_THUMB2_KERNEL
> -	if (thumb) {
> -		u16 *ip = (u16 *)asi->insn;
> -		if (is_wide_instruction(insn))
> -			*ip++ = insn >> 16;
> -		*ip++ = insn;
> -		return;
> -	}
> -#endif
> -	asi->insn[0] = insn;
> -}
> -
> -/*
> - * When we modify the register numbers encoded in an instruction to be emulated,
> - * the new values come from this define. For ARM and 32-bit Thumb instructions
> - * this gives...
> - *
> - *	bit position	  16  12   8   4   0
> - *	---------------+---+---+---+---+---+
> - *	register	 r2  r0  r1  --  r3
> - */
> -#define INSN_NEW_BITS		0x00020103
> -
> -/* Each nibble has same value as that at INSN_NEW_BITS bit 16 */
> -#define INSN_SAMEAS16_BITS	0x22222222
> -
> -/*
> - * Validate and modify each of the registers encoded in an instruction.
> - *
> - * Each nibble in regs contains a value from enum decode_reg_type. For each
> - * non-zero value, the corresponding nibble in pinsn is validated and modified
> - * according to the type.
> - */
> -static bool __kprobes decode_regs(kprobe_opcode_t* pinsn, u32 regs)
> -{
> -	kprobe_opcode_t insn = *pinsn;
> -	kprobe_opcode_t mask = 0xf; /* Start at least significant nibble */
> -
> -	for (; regs != 0; regs >>= 4, mask <<= 4) {
> -
> -		kprobe_opcode_t new_bits = INSN_NEW_BITS;
> -
> -		switch (regs & 0xf) {
> -
> -		case REG_TYPE_NONE:
> -			/* Nibble not a register, skip to next */
> -			continue;
> -
> -		case REG_TYPE_ANY:
> -			/* Any register is allowed */
> -			break;
> -
> -		case REG_TYPE_SAMEAS16:
> -			/* Replace register with same as at bit position 16 */
> -			new_bits = INSN_SAMEAS16_BITS;
> -			break;
> -
> -		case REG_TYPE_SP:
> -			/* Only allow SP (R13) */
> -			if ((insn ^ 0xdddddddd) & mask)
> -				goto reject;
> -			break;
> -
> -		case REG_TYPE_PC:
> -			/* Only allow PC (R15) */
> -			if ((insn ^ 0xffffffff) & mask)
> -				goto reject;
> -			break;
> -
> -		case REG_TYPE_NOSP:
> -			/* Reject SP (R13) */
> -			if (((insn ^ 0xdddddddd) & mask) == 0)
> -				goto reject;
> -			break;
> -
> -		case REG_TYPE_NOSPPC:
> -		case REG_TYPE_NOSPPCX:
> -			/* Reject SP and PC (R13 and R15) */
> -			if (((insn ^ 0xdddddddd) & 0xdddddddd & mask) == 0)
> -				goto reject;
> -			break;
> -
> -		case REG_TYPE_NOPCWB:
> -			if (!is_writeback(insn))
> -				break; /* No writeback, so any register is OK */
> -			/* fall through... */
> -		case REG_TYPE_NOPC:
> -		case REG_TYPE_NOPCX:
> -			/* Reject PC (R15) */
> -			if (((insn ^ 0xffffffff) & mask) == 0)
> -				goto reject;
> -			break;
> -		}
> -
> -		/* Replace value of nibble with new register number... */
> -		insn &= ~mask;
> -		insn |= new_bits & mask;
> -	}
> -
> -	*pinsn = insn;
> -	return true;
> -
> -reject:
> -	return false;
> -}
> -
> -static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
> -	[DECODE_TYPE_TABLE]	= sizeof(struct decode_table),
> -	[DECODE_TYPE_CUSTOM]	= sizeof(struct decode_custom),
> -	[DECODE_TYPE_SIMULATE]	= sizeof(struct decode_simulate),
> -	[DECODE_TYPE_EMULATE]	= sizeof(struct decode_emulate),
> -	[DECODE_TYPE_OR]	= sizeof(struct decode_or),
> -	[DECODE_TYPE_REJECT]	= sizeof(struct decode_reject)
> -};
> -
> -/*
> - * kprobe_decode_insn operates on data tables in order to decode an ARM
> - * architecture instruction onto which a kprobe has been placed.
> - *
> - * These instruction decoding tables are a concatenation of entries each
> - * of which consist of one of the following structs:
> - *
> - *	decode_table
> - *	decode_custom
> - *	decode_simulate
> - *	decode_emulate
> - *	decode_or
> - *	decode_reject
> - *
> - * Each of these starts with a struct decode_header which has the following
> - * fields:
> - *
> - *	type_regs
> - *	mask
> - *	value
> - *
> - * The least significant DECODE_TYPE_BITS of type_regs contains a value
> - * from enum decode_type, this indicates which of the decode_* structs
> - * the entry contains. The value DECODE_TYPE_END indicates the end of the
> - * table.
> - *
> - * When the table is parsed, each entry is checked in turn to see if it
> - * matches the instruction to be decoded using the test:
> - *
> - *	(insn & mask) == value
> - *
> - * If no match is found before the end of the table is reached then decoding
> - * fails with INSN_REJECTED.
> - *
> - * When a match is found, decode_regs() is called to validate and modify each
> - * of the registers encoded in the instruction; the data it uses to do this
> - * is (type_regs >> DECODE_TYPE_BITS). A validation failure will cause decoding
> - * to fail with INSN_REJECTED.
> - *
> - * Once the instruction has passed the above tests, further processing
> - * depends on the type of the table entry's decode struct.
> - *
> - */
> -int __kprobes
> -kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> -				const union decode_item *table, bool thumb)
> -{
> -	const struct decode_header *h = (struct decode_header *)table;
> -	const struct decode_header *next;
> -	bool matched = false;
> -
> -	insn = prepare_emulated_insn(insn, asi, thumb);
> -
> -	for (;; h = next) {
> -		enum decode_type type = h->type_regs.bits & DECODE_TYPE_MASK;
> -		u32 regs = h->type_regs.bits >> DECODE_TYPE_BITS;
> -
> -		if (type == DECODE_TYPE_END)
> -			return INSN_REJECTED;
> -
> -		next = (struct decode_header *)
> -				((uintptr_t)h + decode_struct_sizes[type]);
> -
> -		if (!matched && (insn & h->mask.bits) != h->value.bits)
> -			continue;
> -
> -		if (!decode_regs(&insn, regs))
> -			return INSN_REJECTED;
> -
> -		switch (type) {
> -
> -		case DECODE_TYPE_TABLE: {
> -			struct decode_table *d = (struct decode_table *)h;
> -			next = (struct decode_header *)d->table.table;
> -			break;
> -		}
> -
> -		case DECODE_TYPE_CUSTOM: {
> -			struct decode_custom *d = (struct decode_custom *)h;
> -			return (*d->decoder.decoder)(insn, asi);
> -		}
> -
> -		case DECODE_TYPE_SIMULATE: {
> -			struct decode_simulate *d = (struct decode_simulate *)h;
> -			asi->insn_handler = d->handler.handler;
> -			return INSN_GOOD_NO_SLOT;
> -		}
> -
> -		case DECODE_TYPE_EMULATE: {
> -			struct decode_emulate *d = (struct decode_emulate *)h;
> -			asi->insn_handler = d->handler.handler;
> -			set_emulated_insn(insn, asi, thumb);
> -			return INSN_GOOD;
> -		}
> -
> -		case DECODE_TYPE_OR:
> -			matched = true;
> -			break;
> -
> -		case DECODE_TYPE_REJECT:
> -		default:
> -			return INSN_REJECTED;
> -		}
> -		}
> -	}
> diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
> index 6123daf..173b2bc 100644
> --- a/arch/arm/kernel/kprobes-thumb.c
> +++ b/arch/arm/kernel/kprobes-thumb.c
> @@ -544,11 +544,11 @@ static const union decode_item t32_table_1111_0xxx___1[] = {
>  	/* YIELD		1111 0011 1010 xxxx 10x0 x000 0000 0001 */
>  	DECODE_OR	(0xfff0d7ff, 0xf3a08001),
>  	/* SEV			1111 0011 1010 xxxx 10x0 x000 0000 0100 */
> -	DECODE_EMULATE	(0xfff0d7ff, 0xf3a08004, kprobe_emulate_none),
> +	DECODE_EMULATE	(0xfff0d7ff, 0xf3a08004, probes_emulate_none),
>  	/* NOP			1111 0011 1010 xxxx 10x0 x000 0000 0000 */
>  	/* WFE			1111 0011 1010 xxxx 10x0 x000 0000 0010 */
>  	/* WFI			1111 0011 1010 xxxx 10x0 x000 0000 0011 */
> -	DECODE_SIMULATE	(0xfff0d7fc, 0xf3a08000, kprobe_simulate_nop),
> +	DECODE_SIMULATE	(0xfff0d7fc, 0xf3a08000, probes_simulate_nop),
>  
>  	/* MRS Rd, CPSR		1111 0011 1110 xxxx 10x0 xxxx xxxx xxxx */
>  	DECODE_SIMULATEX(0xfff0d000, 0xf3e08000, t32_simulate_mrs,
> @@ -589,7 +589,7 @@ static const union decode_item t32_table_1111_100x_x0x1__1111[] = {
>  
>  	/* PLD (literal)	1111 1000 x001 1111 1111 xxxx xxxx xxxx */
>  	/* PLI (literal)	1111 1001 x001 1111 1111 xxxx xxxx xxxx */
> -	DECODE_SIMULATE	(0xfe7ff000, 0xf81ff000, kprobe_simulate_nop),
> +	DECODE_SIMULATE	(0xfe7ff000, 0xf81ff000, probes_simulate_nop),
>  
>  	/* PLD{W} (immediate)	1111 1000 10x1 xxxx 1111 xxxx xxxx xxxx */
>  	DECODE_OR	(0xffd0f000, 0xf890f000),
> @@ -598,13 +598,13 @@ static const union decode_item t32_table_1111_100x_x0x1__1111[] = {
>  	/* PLI (immediate)	1111 1001 1001 xxxx 1111 xxxx xxxx xxxx */
>  	DECODE_OR	(0xfff0f000, 0xf990f000),
>  	/* PLI (immediate)	1111 1001 0001 xxxx 1111 1100 xxxx xxxx */
> -	DECODE_SIMULATEX(0xfff0ff00, 0xf910fc00, kprobe_simulate_nop,
> +	DECODE_SIMULATEX(0xfff0ff00, 0xf910fc00, probes_simulate_nop,
>  						 REGS(NOPCX, 0, 0, 0, 0)),
>  
>  	/* PLD{W} (register)	1111 1000 00x1 xxxx 1111 0000 00xx xxxx */
>  	DECODE_OR	(0xffd0ffc0, 0xf810f000),
>  	/* PLI (register)	1111 1001 0001 xxxx 1111 0000 00xx xxxx */
> -	DECODE_SIMULATEX(0xfff0ffc0, 0xf910f000, kprobe_simulate_nop,
> +	DECODE_SIMULATEX(0xfff0ffc0, 0xf910f000, probes_simulate_nop,
>  						 REGS(NOPCX, 0, 0, 0, NOSPPC)),
>  
>  	/* Other unallocated instructions...				*/
> @@ -1274,11 +1274,11 @@ static const union decode_item t16_table_1011[] = {
>  	/* YIELD			1011 1111 0001 0000 */
>  	DECODE_OR	(0xffff, 0xbf10),
>  	/* SEV				1011 1111 0100 0000 */
> -	DECODE_EMULATE	(0xffff, 0xbf40, kprobe_emulate_none),
> +	DECODE_EMULATE	(0xffff, 0xbf40, probes_emulate_none),
>  	/* NOP				1011 1111 0000 0000 */
>  	/* WFE				1011 1111 0010 0000 */
>  	/* WFI				1011 1111 0011 0000 */
> -	DECODE_SIMULATE	(0xffcf, 0xbf00, kprobe_simulate_nop),
> +	DECODE_SIMULATE	(0xffcf, 0xbf00, probes_simulate_nop),
>  	/* Unassigned hints		1011 1111 xxxx 0000 */
>  	DECODE_REJECT	(0xff0f, 0xbf00),
>  	/* IT				1011 1111 xxxx xxxx */
> diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
> index 38945f7..9aa2f15 100644
> --- a/arch/arm/kernel/kprobes.h
> +++ b/arch/arm/kernel/kprobes.h
> @@ -161,8 +161,8 @@ static inline void __kprobes alu_write_pc(long pcv, struct pt_regs *regs)
>  }
>  
> 
> -void __kprobes kprobe_simulate_nop(struct kprobe *p, struct pt_regs *regs);
> -void __kprobes kprobe_emulate_none(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes probes_simulate_nop(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes probes_emulate_none(struct kprobe *p, struct pt_regs *regs);
>  
>  enum kprobe_insn __kprobes
>  kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi);
> diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
> new file mode 100644
> index 0000000..e1b1a6e
> --- /dev/null
> +++ b/arch/arm/kernel/probes-arm.c
> @@ -0,0 +1,311 @@
> +/*
> + * arch/arm/kernel/probes-arm.c
> + *
> + * Some code moved here from arch/arm/kernel/kprobes-arm.c
> + *
> + * Copyright (C) 2006, 2007 Motorola Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/kprobes.h>
> +
> +#include "probes.h"
> +#include "kprobes.h"
> +
> +#define sign_extend(x, signbit) ((x) | (0 - ((x) & (1 << (signbit)))))
> +
> +#define branch_displacement(insn) sign_extend(((insn) & 0xffffff) << 2, 25)
> +
> +#if  __LINUX_ARM_ARCH__ >= 6
> +#define BLX(reg)	"blx	"reg"		\n\t"
> +#else
> +#define BLX(reg)	"mov	lr, pc		\n\t"	\
> +			"mov	pc, "reg"	\n\t"
> +#endif
> +
> +void __kprobes simulate_bbl(struct kprobe *p, struct pt_regs *regs)
> +{
> +	kprobe_opcode_t insn = p->opcode;
> +	long iaddr = (long)p->addr;
> +	int disp  = branch_displacement(insn);
> +
> +	if (insn & (1 << 24))
> +		regs->ARM_lr = iaddr + 4;
> +
> +	regs->ARM_pc = iaddr + 8 + disp;
> +}
> +
> +void __kprobes simulate_blx1(struct kprobe *p, struct pt_regs *regs)
> +{
> +	kprobe_opcode_t insn = p->opcode;
> +	long iaddr = (long)p->addr;
> +	int disp = branch_displacement(insn);
> +
> +	regs->ARM_lr = iaddr + 4;
> +	regs->ARM_pc = iaddr + 8 + disp + ((insn >> 23) & 0x2);
> +	regs->ARM_cpsr |= PSR_T_BIT;
> +}
> +
> +void __kprobes simulate_blx2bx(struct kprobe *p, struct pt_regs *regs)
> +{
> +	kprobe_opcode_t insn = p->opcode;
> +	int rm = insn & 0xf;
> +	long rmv = regs->uregs[rm];
> +
> +	if (insn & (1 << 5))
> +		regs->ARM_lr = (long)p->addr + 4;
> +
> +	regs->ARM_pc = rmv & ~0x1;
> +	regs->ARM_cpsr &= ~PSR_T_BIT;
> +	if (rmv & 0x1)
> +		regs->ARM_cpsr |= PSR_T_BIT;
> +}
> +
> +void __kprobes simulate_mrs(struct kprobe *p, struct pt_regs *regs)
> +{
> +	kprobe_opcode_t insn = p->opcode;
> +	int rd = (insn >> 12) & 0xf;
> +	unsigned long mask = 0xf8ff03df; /* Mask out execution state */
> +	regs->uregs[rd] = regs->ARM_cpsr & mask;
> +}
> +
> +void __kprobes simulate_mov_ipsp(struct kprobe *p, struct pt_regs *regs)
> +{
> +	regs->uregs[12] = regs->uregs[13];
> +}
> +
> +void __kprobes
> +emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs)
> +{
> +	kprobe_opcode_t insn = p->opcode;
> +	unsigned long pc = (unsigned long)p->addr + 8;
> +	int rt = (insn >> 12) & 0xf;
> +	int rn = (insn >> 16) & 0xf;
> +	int rm = insn & 0xf;
> +
> +	register unsigned long rtv asm("r0") = regs->uregs[rt];
> +	register unsigned long rt2v asm("r1") = regs->uregs[rt+1];
> +	register unsigned long rnv asm("r2") = (rn == 15) ? pc
> +							  : regs->uregs[rn];
> +	register unsigned long rmv asm("r3") = regs->uregs[rm];
> +
> +	__asm__ __volatile__ (
> +		BLX("%[fn]")
> +		: "=r" (rtv), "=r" (rt2v), "=r" (rnv)
> +		: "0" (rtv), "1" (rt2v), "2" (rnv), "r" (rmv),
> +		  [fn] "r" (p->ainsn.insn_fn)
> +		: "lr", "memory", "cc"
> +	);
> +
> +	regs->uregs[rt] = rtv;
> +	regs->uregs[rt+1] = rt2v;
> +	if (is_writeback(insn))
> +		regs->uregs[rn] = rnv;
> +}
> +
> +void __kprobes
> +emulate_ldr(struct kprobe *p, struct pt_regs *regs)
> +{
> +	kprobe_opcode_t insn = p->opcode;
> +	unsigned long pc = (unsigned long)p->addr + 8;
> +	int rt = (insn >> 12) & 0xf;
> +	int rn = (insn >> 16) & 0xf;
> +	int rm = insn & 0xf;
> +
> +	register unsigned long rtv asm("r0");
> +	register unsigned long rnv asm("r2") = (rn == 15) ? pc
> +							  : regs->uregs[rn];
> +	register unsigned long rmv asm("r3") = regs->uregs[rm];
> +
> +	__asm__ __volatile__ (
> +		BLX("%[fn]")
> +		: "=r" (rtv), "=r" (rnv)
> +		: "1" (rnv), "r" (rmv), [fn] "r" (p->ainsn.insn_fn)
> +		: "lr", "memory", "cc"
> +	);
> +
> +	if (rt == 15)
> +		load_write_pc(rtv, regs);
> +	else
> +		regs->uregs[rt] = rtv;
> +
> +	if (is_writeback(insn))
> +		regs->uregs[rn] = rnv;
> +}
> +
> +void __kprobes
> +emulate_str(struct kprobe *p, struct pt_regs *regs)
> +{
> +	kprobe_opcode_t insn = p->opcode;
> +	unsigned long rtpc = (unsigned long)p->addr + str_pc_offset;
> +	unsigned long rnpc = (unsigned long)p->addr + 8;
> +	int rt = (insn >> 12) & 0xf;
> +	int rn = (insn >> 16) & 0xf;
> +	int rm = insn & 0xf;
> +
> +	register unsigned long rtv asm("r0") = (rt == 15) ? rtpc
> +							  : regs->uregs[rt];
> +	register unsigned long rnv asm("r2") = (rn == 15) ? rnpc
> +							  : regs->uregs[rn];
> +	register unsigned long rmv asm("r3") = regs->uregs[rm];
> +
> +	__asm__ __volatile__ (
> +		BLX("%[fn]")
> +		: "=r" (rnv)
> +		: "r" (rtv), "0" (rnv), "r" (rmv), [fn] "r" (p->ainsn.insn_fn)
> +		: "lr", "memory", "cc"
> +	);
> +
> +	if (is_writeback(insn))
> +		regs->uregs[rn] = rnv;
> +}
> +
> +void __kprobes
> +emulate_rd12rn16rm0rs8_rwflags(struct kprobe *p, struct pt_regs *regs)
> +{
> +	kprobe_opcode_t insn = p->opcode;
> +	unsigned long pc = (unsigned long)p->addr + 8;
> +	int rd = (insn >> 12) & 0xf;
> +	int rn = (insn >> 16) & 0xf;
> +	int rm = insn & 0xf;
> +	int rs = (insn >> 8) & 0xf;
> +
> +	register unsigned long rdv asm("r0") = regs->uregs[rd];
> +	register unsigned long rnv asm("r2") = (rn == 15) ? pc
> +							  : regs->uregs[rn];
> +	register unsigned long rmv asm("r3") = (rm == 15) ? pc
> +							  : regs->uregs[rm];
> +	register unsigned long rsv asm("r1") = regs->uregs[rs];
> +	unsigned long cpsr = regs->ARM_cpsr;
> +
> +	__asm__ __volatile__ (
> +		"msr	cpsr_fs, %[cpsr]	\n\t"
> +		BLX("%[fn]")
> +		"mrs	%[cpsr], cpsr		\n\t"
> +		: "=r" (rdv), [cpsr] "=r" (cpsr)
> +		: "0" (rdv), "r" (rnv), "r" (rmv), "r" (rsv),
> +		  "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
> +		: "lr", "memory", "cc"
> +	);
> +
> +	if (rd == 15)
> +		alu_write_pc(rdv, regs);
> +	else
> +		regs->uregs[rd] = rdv;
> +	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
> +}
> +
> +void __kprobes
> +emulate_rd12rn16rm0_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
> +{
> +	kprobe_opcode_t insn = p->opcode;
> +	int rd = (insn >> 12) & 0xf;
> +	int rn = (insn >> 16) & 0xf;
> +	int rm = insn & 0xf;
> +
> +	register unsigned long rdv asm("r0") = regs->uregs[rd];
> +	register unsigned long rnv asm("r2") = regs->uregs[rn];
> +	register unsigned long rmv asm("r3") = regs->uregs[rm];
> +	unsigned long cpsr = regs->ARM_cpsr;
> +
> +	__asm__ __volatile__ (
> +		"msr	cpsr_fs, %[cpsr]	\n\t"
> +		BLX("%[fn]")
> +		"mrs	%[cpsr], cpsr		\n\t"
> +		: "=r" (rdv), [cpsr] "=r" (cpsr)
> +		: "0" (rdv), "r" (rnv), "r" (rmv),
> +		  "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
> +		: "lr", "memory", "cc"
> +	);
> +
> +	regs->uregs[rd] = rdv;
> +	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
> +}
> +
> +void __kprobes
> +emulate_rd16rn12rm0rs8_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
> +{
> +	kprobe_opcode_t insn = p->opcode;
> +	int rd = (insn >> 16) & 0xf;
> +	int rn = (insn >> 12) & 0xf;
> +	int rm = insn & 0xf;
> +	int rs = (insn >> 8) & 0xf;
> +
> +	register unsigned long rdv asm("r2") = regs->uregs[rd];
> +	register unsigned long rnv asm("r0") = regs->uregs[rn];
> +	register unsigned long rmv asm("r3") = regs->uregs[rm];
> +	register unsigned long rsv asm("r1") = regs->uregs[rs];
> +	unsigned long cpsr = regs->ARM_cpsr;
> +
> +	__asm__ __volatile__ (
> +		"msr	cpsr_fs, %[cpsr]	\n\t"
> +		BLX("%[fn]")
> +		"mrs	%[cpsr], cpsr		\n\t"
> +		: "=r" (rdv), [cpsr] "=r" (cpsr)
> +		: "0" (rdv), "r" (rnv), "r" (rmv), "r" (rsv),
> +		  "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
> +		: "lr", "memory", "cc"
> +	);
> +
> +	regs->uregs[rd] = rdv;
> +	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
> +}
> +
> +void __kprobes
> +emulate_rd12rm0_noflags_nopc(struct kprobe *p, struct pt_regs *regs)
> +{
> +	kprobe_opcode_t insn = p->opcode;
> +	int rd = (insn >> 12) & 0xf;
> +	int rm = insn & 0xf;
> +
> +	register unsigned long rdv asm("r0") = regs->uregs[rd];
> +	register unsigned long rmv asm("r3") = regs->uregs[rm];
> +
> +	__asm__ __volatile__ (
> +		BLX("%[fn]")
> +		: "=r" (rdv)
> +		: "0" (rdv), "r" (rmv), [fn] "r" (p->ainsn.insn_fn)
> +		: "lr", "memory", "cc"
> +	);
> +
> +	regs->uregs[rd] = rdv;
> +}
> +
> +void __kprobes
> +emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
> +{
> +	kprobe_opcode_t insn = p->opcode;
> +	int rdlo = (insn >> 12) & 0xf;
> +	int rdhi = (insn >> 16) & 0xf;
> +	int rn = insn & 0xf;
> +	int rm = (insn >> 8) & 0xf;
> +
> +	register unsigned long rdlov asm("r0") = regs->uregs[rdlo];
> +	register unsigned long rdhiv asm("r2") = regs->uregs[rdhi];
> +	register unsigned long rnv asm("r3") = regs->uregs[rn];
> +	register unsigned long rmv asm("r1") = regs->uregs[rm];
> +	unsigned long cpsr = regs->ARM_cpsr;
> +
> +	__asm__ __volatile__ (
> +		"msr	cpsr_fs, %[cpsr]	\n\t"
> +		BLX("%[fn]")
> +		"mrs	%[cpsr], cpsr		\n\t"
> +		: "=r" (rdlov), "=r" (rdhiv), [cpsr] "=r" (cpsr)
> +		: "0" (rdlov), "1" (rdhiv), "r" (rnv), "r" (rmv),
> +		  "2" (cpsr), [fn] "r" (p->ainsn.insn_fn)
> +		: "lr", "memory", "cc"
> +	);
> +
> +	regs->uregs[rdlo] = rdlov;
> +	regs->uregs[rdhi] = rdhiv;
> +	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
> +}
> diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
> new file mode 100644
> index 0000000..86c63f3
> --- /dev/null
> +++ b/arch/arm/kernel/probes.c
> @@ -0,0 +1,286 @@
> +/*
> + * arch/arm/kernel/probes.c
> + *
> + * Some contents moved here from arch/arm/include/asm/kprobes-common.c
> + *
> + * Copyright (C) 2011 Jon Medhurst <tixy@yxit.co.uk>.
> + *
> + * Some contents moved here from arch/arm/include/asm/kprobes-arm.c which is
> + * Copyright (C) 2006, 2007 Motorola Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/kprobes.h>
> +
> +#include "probes.h"
> +#include "kprobes.h"
> +
> +void __kprobes probes_simulate_nop(struct kprobe *p, struct pt_regs *regs)
> +{
> +}
> +
> +void __kprobes probes_emulate_none(struct kprobe *p, struct pt_regs *regs)
> +{
> +	p->ainsn.insn_fn();
> +}
> +
> +/*
> + * Prepare an instruction slot to receive an instruction for emulating.
> + * This is done by placing a subroutine return after the location where the
> + * instruction will be placed. We also modify ARM instructions to be
> + * unconditional as the condition code will already be checked before any
> + * emulation handler is called.
> + */
> +static kprobe_opcode_t __kprobes
> +prepare_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> +								bool thumb)
> +{
> +#ifdef CONFIG_THUMB2_KERNEL
> +	if (thumb) {
> +		u16 *thumb_insn = (u16 *)asi->insn;
> +		thumb_insn[1] = 0x4770; /* Thumb bx lr */
> +		thumb_insn[2] = 0x4770; /* Thumb bx lr */
> +		return insn;
> +	}
> +	asi->insn[1] = 0xe12fff1e; /* ARM bx lr */
> +#else
> +	asi->insn[1] = 0xe1a0f00e; /* mov pc, lr */
> +#endif
> +	/* Make an ARM instruction unconditional */
> +	if (insn < 0xe0000000)
> +		insn = (insn | 0xe0000000) & ~0x10000000;
> +	return insn;
> +}
> +
> +/*
> + * Write a (probably modified) instruction into the slot previously prepared by
> + * prepare_emulated_insn
> + */
> +static void  __kprobes
> +set_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> +								bool thumb)
> +{
> +#ifdef CONFIG_THUMB2_KERNEL
> +	if (thumb) {
> +		u16 *ip = (u16 *)asi->insn;
> +		if (is_wide_instruction(insn))
> +			*ip++ = insn >> 16;
> +		*ip++ = insn;
> +		return;
> +	}
> +#endif
> +	asi->insn[0] = insn;
> +}
> +
> +/*
> + * When we modify the register numbers encoded in an instruction to be emulated,
> + * the new values come from this define. For ARM and 32-bit Thumb instructions
> + * this gives...
> + *
> + *	bit position	  16  12   8   4   0
> + *	---------------+---+---+---+---+---+
> + *	register	 r2  r0  r1  --  r3
> + */
> +#define INSN_NEW_BITS		0x00020103
> +
> +/* Each nibble has same value as that at INSN_NEW_BITS bit 16 */
> +#define INSN_SAMEAS16_BITS	0x22222222
> +
> +/*
> + * Validate and modify each of the registers encoded in an instruction.
> + *
> + * Each nibble in regs contains a value from enum decode_reg_type. For each
> + * non-zero value, the corresponding nibble in pinsn is validated and modified
> + * according to the type.
> + */
> +static bool __kprobes decode_regs(kprobe_opcode_t *pinsn, u32 regs)
> +{
> +	kprobe_opcode_t insn = *pinsn;
> +	kprobe_opcode_t mask = 0xf; /* Start at least significant nibble */
> +
> +	for (; regs != 0; regs >>= 4, mask <<= 4) {
> +
> +		kprobe_opcode_t new_bits = INSN_NEW_BITS;
> +
> +		switch (regs & 0xf) {
> +
> +		case REG_TYPE_NONE:
> +			/* Nibble not a register, skip to next */
> +			continue;
> +
> +		case REG_TYPE_ANY:
> +			/* Any register is allowed */
> +			break;
> +
> +		case REG_TYPE_SAMEAS16:
> +			/* Replace register with same as at bit position 16 */
> +			new_bits = INSN_SAMEAS16_BITS;
> +			break;
> +
> +		case REG_TYPE_SP:
> +			/* Only allow SP (R13) */
> +			if ((insn ^ 0xdddddddd) & mask)
> +				goto reject;
> +			break;
> +
> +		case REG_TYPE_PC:
> +			/* Only allow PC (R15) */
> +			if ((insn ^ 0xffffffff) & mask)
> +				goto reject;
> +			break;
> +
> +		case REG_TYPE_NOSP:
> +			/* Reject SP (R13) */
> +			if (((insn ^ 0xdddddddd) & mask) == 0)
> +				goto reject;
> +			break;
> +
> +		case REG_TYPE_NOSPPC:
> +		case REG_TYPE_NOSPPCX:
> +			/* Reject SP and PC (R13 and R15) */
> +			if (((insn ^ 0xdddddddd) & 0xdddddddd & mask) == 0)
> +				goto reject;
> +			break;
> +
> +		case REG_TYPE_NOPCWB:
> +			if (!is_writeback(insn))
> +				break; /* No writeback, so any register is OK */
> +			/* fall through... */
> +		case REG_TYPE_NOPC:
> +		case REG_TYPE_NOPCX:
> +			/* Reject PC (R15) */
> +			if (((insn ^ 0xffffffff) & mask) == 0)
> +				goto reject;
> +			break;
> +		}
> +
> +		/* Replace value of nibble with new register number... */
> +		insn &= ~mask;
> +		insn |= new_bits & mask;
> +	}
> +
> +	*pinsn = insn;
> +	return true;
> +
> +reject:
> +	return false;
> +}
> +
> +static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
> +	[DECODE_TYPE_TABLE]	= sizeof(struct decode_table),
> +	[DECODE_TYPE_CUSTOM]	= sizeof(struct decode_custom),
> +	[DECODE_TYPE_SIMULATE]	= sizeof(struct decode_simulate),
> +	[DECODE_TYPE_EMULATE]	= sizeof(struct decode_emulate),
> +	[DECODE_TYPE_OR]	= sizeof(struct decode_or),
> +	[DECODE_TYPE_REJECT]	= sizeof(struct decode_reject)
> +};
> +
> +/*
> + * kprobe_decode_insn operates on data tables in order to decode an ARM
> + * architecture instruction onto which a kprobe has been placed.
> + *
> + * These instruction decoding tables are a concatenation of entries each
> + * of which consist of one of the following structs:
> + *
> + *	decode_table
> + *	decode_custom
> + *	decode_simulate
> + *	decode_emulate
> + *	decode_or
> + *	decode_reject
> + *
> + * Each of these starts with a struct decode_header which has the following
> + * fields:
> + *
> + *	type_regs
> + *	mask
> + *	value
> + *
> + * The least significant DECODE_TYPE_BITS of type_regs contains a value
> + * from enum decode_type, this indicates which of the decode_* structs
> + * the entry contains. The value DECODE_TYPE_END indicates the end of the
> + * table.
> + *
> + * When the table is parsed, each entry is checked in turn to see if it
> + * matches the instruction to be decoded using the test:
> + *
> + *	(insn & mask) == value
> + *
> + * If no match is found before the end of the table is reached then decoding
> + * fails with INSN_REJECTED.
> + *
> + * When a match is found, decode_regs() is called to validate and modify each
> + * of the registers encoded in the instruction; the data it uses to do this
> + * is (type_regs >> DECODE_TYPE_BITS). A validation failure will cause decoding
> + * to fail with INSN_REJECTED.
> + *
> + * Once the instruction has passed the above tests, further processing
> + * depends on the type of the table entry's decode struct.
> + *
> + */
> +int __kprobes
> +kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> +				const union decode_item *table, bool thumb)
> +{
> +	const struct decode_header *h = (struct decode_header *)table;
> +	const struct decode_header *next;
> +	bool matched = false;
> +
> +	insn = prepare_emulated_insn(insn, asi, thumb);
> +
> +	for (;; h = next) {
> +		enum decode_type type = h->type_regs.bits & DECODE_TYPE_MASK;
> +		u32 regs = h->type_regs.bits >> DECODE_TYPE_BITS;
> +
> +		if (type == DECODE_TYPE_END)
> +			return INSN_REJECTED;
> +
> +		next = (struct decode_header *)
> +				((uintptr_t)h + decode_struct_sizes[type]);
> +
> +		if (!matched && (insn & h->mask.bits) != h->value.bits)
> +			continue;
> +
> +		if (!decode_regs(&insn, regs))
> +			return INSN_REJECTED;
> +
> +		switch (type) {
> +
> +		case DECODE_TYPE_TABLE: {
> +			struct decode_table *d = (struct decode_table *)h;
> +			next = (struct decode_header *)d->table.table;
> +			break;
> +		}
> +
> +		case DECODE_TYPE_CUSTOM: {
> +			struct decode_custom *d = (struct decode_custom *)h;
> +			return (*d->decoder.decoder)(insn, asi);
> +		}
> +
> +		case DECODE_TYPE_SIMULATE: {
> +			struct decode_simulate *d = (struct decode_simulate *)h;
> +			asi->insn_handler = d->handler.handler;
> +			return INSN_GOOD_NO_SLOT;
> +		}
> +
> +		case DECODE_TYPE_EMULATE: {
> +			struct decode_emulate *d = (struct decode_emulate *)h;
> +			asi->insn_handler = d->handler.handler;
> +			set_emulated_insn(insn, asi, thumb);
> +			return INSN_GOOD;
> +		}
> +
> +		case DECODE_TYPE_OR:
> +			matched = true;
> +			break;
> +
> +		case DECODE_TYPE_REJECT:
> +		default:
> +			return INSN_REJECTED;
> +		}
> +	}
> +}
> diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
> new file mode 100644
> index 0000000..56eec12
> --- /dev/null
> +++ b/arch/arm/kernel/probes.h
> @@ -0,0 +1,23 @@
> +#ifndef _ARM_KERNEL_PROBES_H
> +#define  _ARM_KERNEL_PROBES_H
> +
> +void __kprobes simulate_bbl(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes simulate_blx1(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes simulate_blx2bx(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes simulate_mrs(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes simulate_mov_ipsp(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes emulate_ldr(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes emulate_str(struct kprobe *p, struct pt_regs *regs);
> +void __kprobes emulate_rd12rn16rm0rs8_rwflags(struct kprobe *p,
> +					      struct pt_regs *regs);
> +void __kprobes emulate_rd12rn16rm0_rwflags_nopc(struct kprobe *p,
> +						struct pt_regs *regs);
> +void __kprobes emulate_rd16rn12rm0rs8_rwflags_nopc(struct kprobe *p,
> +						   struct pt_regs *regs);
> +void __kprobes emulate_rd12rm0_noflags_nopc(struct kprobe *p,
> +					    struct pt_regs *regs);
> +void __kprobes emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(struct kprobe *p,
> +						       struct pt_regs *regs);
> +
> +#endif

-- 
Tixy




