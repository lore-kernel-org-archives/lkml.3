Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab3H2Oye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:54:34 -0400
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:44430 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753436Ab3H2Oyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:54:32 -0400
X-Greylist: delayed 2722 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Aug 2013 10:54:32 EDT
Message-ID: <1377788066.3529.49.camel@linaro1.home>
Subject: Re: [PATCH 9/9] ARM: add uprobes support
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Aug 2013 15:54:26 +0100
In-Reply-To: <1375400753-3454-10-git-send-email-dave.long@linaro.org>
References: <1375400753-3454-1-git-send-email-dave.long@linaro.org>
	 <1375400753-3454-10-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 19:45 -0400, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> Using Rabin Vincent's ARM uprobes patches as a base, enable uprobes
> support on ARM.
> 
> Caveats:
> 
>  - Thumb is not supported

Do you know if there any plans for this to be worked on? I believe most
distros targeting modern ARM chips build user side for Thumb.

>  - XOL abort/trap handling is not implemented

What are the consequences of this, e.g. is it possible for a probe to
get stuck in an infinite loop of faulting? I hope there are no integrity
issues for the kernel itself.

I've not reviewed this patch properly because I'm not very familiar with
how the uprobes work, but I did notice a rogue change at the very
end....

> 
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---
>  arch/arm/Kconfig                   |   4 +
>  arch/arm/include/asm/ptrace.h      |   6 +
>  arch/arm/include/asm/thread_info.h |   5 +-
>  arch/arm/include/asm/uprobes.h     |  34 ++++++
>  arch/arm/kernel/Makefile           |   1 +
>  arch/arm/kernel/signal.c           |   4 +
>  arch/arm/kernel/uprobes-arm.c      | 221 +++++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/uprobes.c          | 203 ++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/uprobes.h          |  25 +++++
>  arch/powerpc/include/asm/uprobes.h |   1 -
>  include/linux/uprobes.h            |   3 +
>  kernel/events/uprobes.c            |   1 +
>  12 files changed, 506 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm/include/asm/uprobes.h
>  create mode 100644 arch/arm/kernel/uprobes-arm.c
>  create mode 100644 arch/arm/kernel/uprobes.c
>  create mode 100644 arch/arm/kernel/uprobes.h
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 37c0f4e..06efe09 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -197,6 +197,10 @@ config ZONE_DMA
>  config NEED_DMA_MAP_STATE
>         def_bool y
>  
> +config ARCH_SUPPORTS_UPROBES
> +	depends on KPROBES
> +	def_bool y
> +

Why do we need kprobes for uprobes?

>  config ARCH_HAS_DMA_SET_COHERENT_MASK
>  	bool
>  
> diff --git a/arch/arm/include/asm/ptrace.h b/arch/arm/include/asm/ptrace.h
> index 04c99f3..ee688b0a 100644
> --- a/arch/arm/include/asm/ptrace.h
> +++ b/arch/arm/include/asm/ptrace.h
> @@ -80,6 +80,12 @@ static inline long regs_return_value(struct pt_regs *regs)
>  
>  #define instruction_pointer(regs)	(regs)->ARM_pc
>  
> +static inline void instruction_pointer_set(struct pt_regs *regs,
> +					   unsigned long val)
> +{
> +	instruction_pointer(regs) = val;
> +}
> +
>  #ifdef CONFIG_SMP
>  extern unsigned long profile_pc(struct pt_regs *regs);
>  #else
> diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
> index 214d415..c219f8d 100644
> --- a/arch/arm/include/asm/thread_info.h
> +++ b/arch/arm/include/asm/thread_info.h
> @@ -148,6 +148,7 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
>  #define TIF_SIGPENDING		0
>  #define TIF_NEED_RESCHED	1
>  #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
> +#define TIF_UPROBE		7
>  #define TIF_SYSCALL_TRACE	8
>  #define TIF_SYSCALL_AUDIT	9
>  #define TIF_SYSCALL_TRACEPOINT	10
> @@ -161,6 +162,7 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
>  #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
>  #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
> +#define _TIF_UPROBE		(1 << TIF_UPROBE)
>  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
>  #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
>  #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
> @@ -174,7 +176,8 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
>  /*
>   * Change these and you break ASM code in entry-common.S
>   */
> -#define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_NOTIFY_RESUME)
> +#define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
> +				 _TIF_NOTIFY_RESUME | _TIF_UPROBE)
>  
>  #endif /* __KERNEL__ */
>  #endif /* __ASM_ARM_THREAD_INFO_H */
> diff --git a/arch/arm/include/asm/uprobes.h b/arch/arm/include/asm/uprobes.h
> new file mode 100644
> index 0000000..fa4b81e
> --- /dev/null
> +++ b/arch/arm/include/asm/uprobes.h
> @@ -0,0 +1,34 @@
> +#ifndef _ASM_UPROBES_H
> +#define _ASM_UPROBES_H
> +
> +#include <asm/probes.h>
> +
> +typedef u32 uprobe_opcode_t;
> +
> +#define MAX_UINSN_BYTES		4
> +#define UPROBE_XOL_SLOT_BYTES	64
> +
> +#define UPROBE_SWBP_INSN	0x07f001f9
> +#define UPROBE_SS_INSN		0x07f001fa
> +#define UPROBE_SWBP_INSN_SIZE	4
> +
> +struct arch_uprobe_task {
> +	u32 backup;
> +};
> +
> +struct arch_uprobe {
> +	u8 insn[MAX_UINSN_BYTES];
> +	uprobe_opcode_t modinsn;
> +	uprobe_opcode_t bpinsn;
> +	bool simulate;
> +	u32 pcreg;
> +	void (*prehandler)(struct arch_uprobe *auprobe,
> +			   struct arch_uprobe_task *autask,
> +			   struct pt_regs *regs);
> +	void (*posthandler)(struct arch_uprobe *auprobe,
> +			    struct arch_uprobe_task *autask,
> +			    struct pt_regs *regs);
> +	struct arch_specific_insn asi;
> +};
> +
> +#endif
> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
> index 3292023..853f6f02 100644
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -49,6 +49,7 @@ obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o insn.o
>  obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o insn.o
>  obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o insn.o patch.o
>  obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
> +obj-$(CONFIG_UPROBES)		+= probes.o uprobes.o uprobes-arm.o kprobes-arm.o
>  obj-$(CONFIG_KPROBES)		+= probes.o probes-arm.o kprobes.o kprobes-common.o patch.o
>  ifdef CONFIG_THUMB2_KERNEL
>  obj-$(CONFIG_KPROBES)		+= kprobes-thumb.o
> diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
> index 1c16c35..20e4e61 100644
> --- a/arch/arm/kernel/signal.c
> +++ b/arch/arm/kernel/signal.c
> @@ -12,6 +12,7 @@
>  #include <linux/personality.h>
>  #include <linux/uaccess.h>
>  #include <linux/tracehook.h>
> +#include <linux/uprobes.h>
>  
>  #include <asm/elf.h>
>  #include <asm/cacheflush.h>
> @@ -598,6 +599,9 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
>  					return restart;
>  				}
>  				syscall = 0;
> +			} else if (thread_flags & _TIF_UPROBE) {
> +				clear_thread_flag(TIF_UPROBE);
> +				uprobe_notify_resume(regs);
>  			} else {
>  				clear_thread_flag(TIF_NOTIFY_RESUME);
>  				tracehook_notify_resume(regs);
> diff --git a/arch/arm/kernel/uprobes-arm.c b/arch/arm/kernel/uprobes-arm.c
> new file mode 100644
> index 0000000..dc298ec
> --- /dev/null
> +++ b/arch/arm/kernel/uprobes-arm.c
> @@ -0,0 +1,221 @@
> +#include <linux/kernel.h>
> +#include <linux/kprobes.h>
> +#include <linux/uprobes.h>
> +#include <linux/module.h>
> +
> +#include "kprobes.h"
> +#include "probes.h"
> +#include "probes-arm.h"
> +#include "uprobes.h"
> +
> +static int uprobes_substitute_pc(kprobe_opcode_t *pinsn, u32 oregs)
> +{
> +	kprobe_opcode_t insn = *pinsn;
> +	kprobe_opcode_t temp;
> +	kprobe_opcode_t mask;
> +	int freereg;
> +	u32 free = 0xffff;
> +	u32 regs;
> +
> +	for (regs = oregs; regs; regs >>= 4, insn >>= 4) {
> +		if ((regs & 0xf) == REG_TYPE_NONE)
> +			continue;
> +
> +		free &= ~(1 << (insn & 0xf));
> +	}
> +
> +	/* No PC, no problem */
> +	if (free & (1 << 15))
> +		return 15;
> +
> +	if (!free)
> +		return -1;
> +
> +	/*
> +	 * fls instead of ffs ensures that for "ldrd r0, r1, [pc]" we would
> +	 * pick LR instead of R1.
> +	 */
> +	freereg = free = fls(free) - 1;
> +
> +	temp = *pinsn;
> +	insn = *pinsn;
> +	regs = oregs;
> +	mask = 0xf;
> +
> +	for (; regs; regs >>= 4, mask <<= 4, free <<= 4, temp >>= 4) {
> +		if ((regs & 0xf) == REG_TYPE_NONE)
> +			continue;
> +
> +		if ((temp & 0xf) != 15)
> +			continue;
> +
> +		insn &= ~mask;
> +		insn |= free & mask;
> +	}
> +
> +	*pinsn = insn;
> +	return freereg;
> +}
> +
> +static void uprobe_set_pc(struct arch_uprobe *auprobe,
> +			  struct arch_uprobe_task *autask,
> +			  struct pt_regs *regs)
> +{
> +	u32 pcreg = auprobe->pcreg;
> +
> +	autask->backup = regs->uregs[pcreg];
> +	regs->uregs[pcreg] = regs->ARM_pc + 8;
> +}
> +
> +static void uprobe_unset_pc(struct arch_uprobe *auprobe,
> +			    struct arch_uprobe_task *autask,
> +			    struct pt_regs *regs)
> +{
> +	/* PC will be taken care of by common code */
> +	regs->uregs[auprobe->pcreg] = autask->backup;
> +}
> +
> +static void uprobe_aluwrite_pc(struct arch_uprobe *auprobe,
> +			       struct arch_uprobe_task *autask,
> +			       struct pt_regs *regs)
> +{
> +	u32 pcreg = auprobe->pcreg;
> +
> +	alu_write_pc(regs->uregs[pcreg], regs);
> +	regs->uregs[pcreg] = autask->backup;
> +}
> +
> +static void uprobe_write_pc(struct arch_uprobe *auprobe,
> +			    struct arch_uprobe_task *autask,
> +			    struct pt_regs *regs)
> +{
> +	u32 pcreg = auprobe->pcreg;
> +
> +	load_write_pc(regs->uregs[pcreg], regs);
> +	regs->uregs[pcreg] = autask->backup;
> +}
> +
> +enum kprobe_insn
> +decode_pc_ro(kprobe_opcode_t insn, struct arch_specific_insn *asi, void *d)
> +{
> +	struct arch_uprobe *auprobe = container_of(asi, struct arch_uprobe,
> +						   asi);
> +	struct decode_emulate *decode = d;
> +	u32 regs = decode->header.type_regs.bits >> DECODE_TYPE_BITS;
> +	int reg;
> +
> +	reg = uprobes_substitute_pc(&auprobe->modinsn, regs);
> +	if (reg == 15)
> +		return INSN_GOOD;
> +
> +	if (reg == -1)
> +		return INSN_REJECTED;
> +
> +	auprobe->pcreg = reg;
> +	auprobe->prehandler = uprobe_set_pc;
> +	auprobe->posthandler = uprobe_unset_pc;
> +
> +	return INSN_GOOD;
> +}
> +
> +enum kprobe_insn
> +decode_wb_pc(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> +	     void *d, bool alu)
> +{
> +	struct arch_uprobe *auprobe = container_of(asi, struct arch_uprobe,
> +						   asi);
> +	enum kprobe_insn ret = decode_pc_ro(insn, asi, d);
> +
> +	if (((insn >> 12) & 0xf) == 15)
> +		auprobe->posthandler = alu ? uprobe_aluwrite_pc
> +					   : uprobe_write_pc;
> +
> +	return ret;
> +}
> +
> +enum kprobe_insn
> +decode_rd12rn16rm0rs8_rwflags(kprobe_opcode_t insn,
> +			      struct arch_specific_insn *asi, void *d)
> +{
> +	return decode_wb_pc(insn, asi, d, true);
> +}
> +
> +enum kprobe_insn
> +decode_ldr(kprobe_opcode_t insn, struct arch_specific_insn *asi, void *d)
> +{
> +	return decode_wb_pc(insn, asi, d, false);
> +}
> +
> +enum kprobe_insn
> +uprobe_decode_ldmstm(kprobe_opcode_t insn,
> +		     struct arch_specific_insn *asi, void *d)
> +{
> +	struct arch_uprobe *auprobe = container_of(asi, struct arch_uprobe,
> +						   asi);
> +	unsigned reglist = insn & 0xffff;
> +	int rn = (insn >> 16) & 0xf;
> +	int lbit = insn & (1 << 20);
> +	unsigned used = reglist | (1 << rn);
> +
> +	if (rn == 15)
> +		return INSN_REJECTED;
> +
> +	if (!(used & (1 << 15)))
> +		return INSN_GOOD;
> +
> +	if (used & (1 << 14))
> +		return INSN_REJECTED;
> +
> +	/* Use LR instead of PC */
> +	insn ^= 0xc000;
> +
> +	auprobe->pcreg = 14;
> +	auprobe->modinsn = insn;
> +
> +	auprobe->prehandler = uprobe_set_pc;
> +	if (lbit)
> +		auprobe->posthandler = uprobe_write_pc;
> +	else
> +		auprobe->posthandler = uprobe_unset_pc;
> +
> +	return INSN_GOOD;
> +}
> +
> +const union decode_item uprobes_probes_actions[] = {
> +	[PROBES_EMULATE_NONE] {.handler = probes_simulate_nop},
> +	[PROBES_SIMULATE_NOP] = {.handler = probes_simulate_nop},
> +	[PROBES_PRELOAD_IMM] = {.handler = probes_simulate_nop},
> +	[PROBES_PRELOAD_REG] = {.handler = probes_simulate_nop},
> +	[PROBES_BRANCH_IMM] = {.handler = simulate_blx1},
> +	[PROBES_MRS] = {.handler = simulate_mrs},
> +	[PROBES_BRANCH_REG] = {.handler = simulate_blx2bx},
> +	[PROBES_CLZ] = {.handler = probes_simulate_nop},
> +	[PROBES_SATURATING_ARITHMETIC] = {.handler = probes_simulate_nop},
> +	[PROBES_MUL1] = {.handler = probes_simulate_nop},
> +	[PROBES_MUL2] = {.handler = probes_simulate_nop},
> +	[PROBES_SWP] = {.handler = probes_simulate_nop},
> +	[PROBES_LDRSTRD] = {.decoder = decode_pc_ro},
> +	[PROBES_LOAD_EXTRA] = {.decoder = decode_pc_ro},
> +	[PROBES_LOAD] = {.decoder = decode_ldr},
> +	[PROBES_STORE_EXTRA] = {.decoder = decode_pc_ro},
> +	[PROBES_STORE] = {.decoder = decode_pc_ro},
> +	[PROBES_MOV_IP_SP] = {.handler = simulate_mov_ipsp},
> +	[PROBES_DATA_PROCESSING_REG] = {
> +		.decoder = decode_rd12rn16rm0rs8_rwflags},
> +	[PROBES_DATA_PROCESSING_IMM] = {
> +		.decoder = decode_rd12rn16rm0rs8_rwflags},
> +	[PROBES_MOV_HALFWORD] = {.handler = probes_simulate_nop},
> +	[PROBES_SEV] = {.handler = probes_simulate_nop},
> +	[PROBES_WFE] = {.handler = probes_simulate_nop},
> +	[PROBES_SATURATE] = {.handler = probes_simulate_nop},
> +	[PROBES_REV] = {.handler = probes_simulate_nop},
> +	[PROBES_MMI] = {.handler = probes_simulate_nop},
> +	[PROBES_PACK] = {.handler = probes_simulate_nop},
> +	[PROBES_EXTEND] = {.handler = probes_simulate_nop},
> +	[PROBES_EXTEND_ADD] = {.handler = probes_simulate_nop},
> +	[PROBES_MUL_ADD_LONG] = {.handler = probes_simulate_nop},
> +	[PROBES_MUL_ADD] = {.handler = probes_simulate_nop},
> +	[PROBES_BITFIELD] = {.handler = probes_simulate_nop},
> +	[PROBES_BRANCH] = {.handler = simulate_bbl},
> +	[PROBES_LDMSTM] = {.decoder = uprobe_decode_ldmstm}
> +};
> diff --git a/arch/arm/kernel/uprobes.c b/arch/arm/kernel/uprobes.c
> new file mode 100644
> index 0000000..90a32d2
> --- /dev/null
> +++ b/arch/arm/kernel/uprobes.c
> @@ -0,0 +1,203 @@
> +/*
> + * Copyright (C) 2012 Rabin Vincent <rabin at rab.in>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/uprobes.h>
> +#include <linux/notifier.h>
> +#include <linux/kprobes.h>
> +
> +#include <asm/opcodes.h>
> +#include <asm/traps.h>
> +
> +#include "kprobes.h"
> +#include "probes.h"
> +#include "probes-arm.h"
> +#include "uprobes.h"
> +
> +bool is_swbp_insn(uprobe_opcode_t *insn)
> +{
> +	return (__mem_to_opcode_arm(*insn) & 0x0fffffff) == UPROBE_SWBP_INSN;
> +}
> +
> +bool arch_uprobe_ignore(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	if (!auprobe->asi.insn_check_cc(regs->ARM_cpsr)) {
> +		regs->ARM_pc += 4;
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	struct kprobe kp;
> +
> +	if (!auprobe->simulate)
> +		return false;
> +
> +	kp.addr = (void *) regs->ARM_pc;
> +	kp.opcode = __mem_to_opcode_arm(*(unsigned int *) auprobe->insn);
> +	kp.ainsn.insn_handler = auprobe->asi.insn_handler;
> +
> +	auprobe->asi.insn_singlestep(&kp, regs);
> +
> +	return true;
> +}
> +
> +unsigned long
> +arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr,
> +				  struct pt_regs *regs)
> +{
> +	regs->ARM_pc = trampoline_vaddr;
> +	return trampoline_vaddr;
> +}
> +
> +int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
> +			     unsigned long addr)
> +{
> +	unsigned int insn;
> +	unsigned int bpinsn;
> +	enum kprobe_insn ret;
> +
> +	/* Thumb not yet support */
> +	if (addr & 0x3)
> +		return -EINVAL;
> +
> +	insn = __mem_to_opcode_arm(*(unsigned int *)auprobe->insn);
> +	auprobe->modinsn = insn;
> +
> +	ret = arm_kprobe_decode_insn(insn, &auprobe->asi, true,
> +				     uprobes_probes_actions);
> +	switch (ret) {
> +	case INSN_REJECTED:
> +		return -EINVAL;
> +
> +	case INSN_GOOD_NO_SLOT:
> +		auprobe->simulate = true;
> +		break;
> +
> +	case INSN_GOOD:
> +	default:
> +		break;
> +	}
> +
> +	bpinsn = UPROBE_SWBP_INSN;
> +	if (insn >= 0xe0000000)
> +		bpinsn |= 0xe0000000;  /* Unconditional instruction */
> +	else
> +		bpinsn |= insn & 0xf0000000;  /* Copy condition from insn */
> +
> +	auprobe->bpinsn = bpinsn;
> +
> +	return 0;
> +}
> +
> +void arch_uprobe_write_opcode(struct arch_uprobe *auprobe, void *vaddr,
> +			      uprobe_opcode_t opcode)
> +{
> +	unsigned long *addr = vaddr;
> +
> +	if (opcode == UPROBE_SWBP_INSN)
> +		opcode = __opcode_to_mem_arm(auprobe->bpinsn);
> +
> +	*addr = opcode;
> +}
> +
> +void arch_uprobe_xol_copy(struct arch_uprobe *auprobe, void *vaddr)
> +{
> +	unsigned long *addr = vaddr;
> +
> +	addr[0] = __opcode_to_mem_arm(auprobe->modinsn);
> +	addr[1] = __opcode_to_mem_arm(0xe0000000 | UPROBE_SS_INSN);
> +}
> +
> +int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	struct uprobe_task *utask = current->utask;
> +
> +	if (auprobe->prehandler)
> +		auprobe->prehandler(auprobe, &utask->autask, regs);
> +
> +	regs->ARM_pc = utask->xol_vaddr;
> +
> +	return 0;
> +}
> +
> +int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	struct uprobe_task *utask = current->utask;
> +
> +	regs->ARM_pc = utask->vaddr + 4;
> +
> +	if (auprobe->posthandler)
> +		auprobe->posthandler(auprobe, &utask->autask, regs);
> +
> +	return 0;
> +}
> +
> +bool arch_uprobe_xol_was_trapped(struct task_struct *t)
> +{
> +	/* TODO: implement */
> +	return false;
> +}
> +
> +void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	/* TODO: implement */
> +}
> +
> +int arch_uprobe_exception_notify(struct notifier_block *self,
> +				 unsigned long val, void *data)
> +{
> +	return NOTIFY_DONE;
> +}
> +
> +static int uprobe_trap_handler(struct pt_regs *regs, unsigned int instr)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	if ((instr & 0x0fffffff) == UPROBE_SWBP_INSN)
> +		uprobe_pre_sstep_notifier(regs);
> +	else
> +		uprobe_post_sstep_notifier(regs);
> +	local_irq_restore(flags);
> +
> +	return 0;
> +}
> +
> +unsigned long uprobe_get_swbp_addr(struct pt_regs *regs)
> +{
> +	return instruction_pointer(regs);
> +}
> +
> +static struct undef_hook uprobes_arm_break_hook = {
> +	.instr_mask	= 0x0fffffff,
> +	.instr_val	= UPROBE_SWBP_INSN,
> +	.cpsr_mask	= MODE_MASK,
> +	.cpsr_val	= USR_MODE,
> +	.fn		= uprobe_trap_handler,
> +};
> +
> +static struct undef_hook uprobes_arm_ss_hook = {
> +	.instr_mask	= 0x0fffffff,
> +	.instr_val	= UPROBE_SS_INSN,
> +	.cpsr_mask	= MODE_MASK,
> +	.cpsr_val	= USR_MODE,
> +	.fn		= uprobe_trap_handler,
> +};
> +
> +int arch_uprobes_init(void)
> +{
> +	register_undef_hook(&uprobes_arm_break_hook);
> +	register_undef_hook(&uprobes_arm_ss_hook);
> +
> +	return 0;
> +}
> diff --git a/arch/arm/kernel/uprobes.h b/arch/arm/kernel/uprobes.h
> new file mode 100644
> index 0000000..3887c19
> --- /dev/null
> +++ b/arch/arm/kernel/uprobes.h
> @@ -0,0 +1,25 @@
> +#ifndef __ARM_KERNEL_UPROBES_H
> +#define __ARM_KERNEL_UPROBES_H
> +
> +enum kprobe_insn uprobe_decode_ldmstm(kprobe_opcode_t insn,
> +				      struct arch_specific_insn *asi,
> +				      void *d);
> +
> +enum kprobe_insn decode_ldr(kprobe_opcode_t insn,
> +			    struct arch_specific_insn *asi,
> +			    void *d);
> +
> +enum kprobe_insn
> +decode_rd12rn16rm0rs8_rwflags(kprobe_opcode_t insn,
> +			      struct arch_specific_insn *asi, void *d);
> +
> +enum kprobe_insn
> +decode_wb_pc(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> +	     void *d, bool alu);
> +
> +enum kprobe_insn
> +decode_pc_ro(kprobe_opcode_t insn, struct arch_specific_insn *asi, void *d);
> +
> +extern const union decode_item uprobes_probes_actions[];
> +
> +#endif
> diff --git a/arch/powerpc/include/asm/uprobes.h b/arch/powerpc/include/asm/uprobes.h
> index 2301602..b532060 100644
> --- a/arch/powerpc/include/asm/uprobes.h
> +++ b/arch/powerpc/include/asm/uprobes.h
> @@ -51,5 +51,4 @@ extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
>  extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
>  extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
>  extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> -extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
>  #endif	/* _ASM_UPROBES_H */
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index 9cd3b25..41341e9 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -139,6 +139,9 @@ extern int __weak arch_uprobes_init(void);
>  extern void __weak arch_uprobe_write_opcode(struct arch_uprobe *auprobe,
>  					    void *vaddr,
>  					    uprobe_opcode_t opcode);
> +extern
> +unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr,
> +						       struct pt_regs *regs);
>  #else /* !CONFIG_UPROBES */
>  struct uprobes_state {
>  };
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 6a60eec..3e9d596 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -271,6 +271,7 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
>  {
>  	struct page *old_page, *new_page;
>  	struct vm_area_struct *vma;
> +	void *vaddr_new;

This looks like it should be in patch 5 where vaddr_new is used but not
defined ;-)

>  	int ret;
>  
>  retry:





