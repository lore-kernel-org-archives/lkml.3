Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750895Ab3HSGKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:10:15 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37807 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3HSGKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:10:12 -0400
Message-ID: <5211B6C0.7090806@hitachi.com>
Date: Mon, 19 Aug 2013 15:10:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tony Lu <zlu@tilera.com>
Cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] tile: support kprobes on tilegx
References: <52087770.1080500@hitachi.com> <201308131529.r7DFTNFY028823@farm-0021.internal.tilera.com>
In-Reply-To: <201308131529.r7DFTNFY028823@farm-0021.internal.tilera.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/13 23:08), Tony Lu wrote:
> This change includes support for Kprobes, Jprobes and Return Probes.
> 

This looks OK for me, just reviewed, not tested :).

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> Signed-off-by: Tony Lu <zlu@tilera.com>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> v2: implement Masami Hiramatsu's suggestion to add an insn_has_control()
> check to disallow placing probes on instructions that modify control flow.
> We can improve this in a later change if it seems useful.
> 
>  arch/tile/Kconfig                            |   2 +
>  arch/tile/include/asm/Kbuild                 |   1 -
>  arch/tile/include/asm/kdebug.h               |  28 ++
>  arch/tile/include/asm/kprobes.h              |  79 ++++
>  arch/tile/include/asm/ptrace.h               |   1 +
>  arch/tile/include/uapi/arch/opcode_tilegx.h  |   1 +
>  arch/tile/include/uapi/arch/opcode_tilepro.h |   1 +
>  arch/tile/kernel/Makefile                    |   1 +
>  arch/tile/kernel/kprobes.c                   | 528 +++++++++++++++++++++++++++
>  arch/tile/kernel/smp.c                       |  14 +-
>  arch/tile/kernel/traps.c                     |  42 +++
>  arch/tile/kernel/vmlinux.lds.S               |   1 +
>  arch/tile/mm/fault.c                         |  12 +
>  samples/kprobes/kprobe_example.c             |   9 +
>  14 files changed, 716 insertions(+), 4 deletions(-)
>  create mode 100644 arch/tile/include/asm/kdebug.h
>  create mode 100644 arch/tile/include/asm/kprobes.h
>  create mode 100644 arch/tile/kernel/kprobes.c
> 
> diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
> index e1600be..ecff467 100644
> --- a/arch/tile/Kconfig
> +++ b/arch/tile/Kconfig
> @@ -125,6 +125,8 @@ config TILEGX
>  	select HAVE_FUNCTION_GRAPH_TRACER
>  	select HAVE_DYNAMIC_FTRACE
>  	select HAVE_FTRACE_MCOUNT_RECORD
> +	select HAVE_KPROBES
> +	select HAVE_KRETPROBES
>  
>  config TILEPRO
>  	def_bool !TILEGX
> diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
> index b17b9b8..4c0b3c2 100644
> --- a/arch/tile/include/asm/Kbuild
> +++ b/arch/tile/include/asm/Kbuild
> @@ -15,7 +15,6 @@ generic-y += ioctl.h
>  generic-y += ioctls.h
>  generic-y += ipcbuf.h
>  generic-y += irq_regs.h
> -generic-y += kdebug.h
>  generic-y += local.h
>  generic-y += msgbuf.h
>  generic-y += mutex.h
> diff --git a/arch/tile/include/asm/kdebug.h b/arch/tile/include/asm/kdebug.h
> new file mode 100644
> index 0000000..5bbbfa9
> --- /dev/null
> +++ b/arch/tile/include/asm/kdebug.h
> @@ -0,0 +1,28 @@
> +/*
> + * Copyright 2012 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +
> +#ifndef _ASM_TILE_KDEBUG_H
> +#define _ASM_TILE_KDEBUG_H
> +
> +#include <linux/notifier.h>
> +
> +enum die_val {
> +	DIE_OOPS = 1,
> +	DIE_BREAK,
> +	DIE_SSTEPBP,
> +	DIE_PAGE_FAULT,
> +	DIE_COMPILED_BPT
> +};
> +
> +#endif /* _ASM_TILE_KDEBUG_H */
> diff --git a/arch/tile/include/asm/kprobes.h b/arch/tile/include/asm/kprobes.h
> new file mode 100644
> index 0000000..d8f9a83
> --- /dev/null
> +++ b/arch/tile/include/asm/kprobes.h
> @@ -0,0 +1,79 @@
> +/*
> + * arch/tile/include/asm/kprobes.h
> + *
> + * Copyright 2012 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +
> +#ifndef _ASM_TILE_KPROBES_H
> +#define _ASM_TILE_KPROBES_H
> +
> +#include <linux/types.h>
> +#include <linux/ptrace.h>
> +#include <linux/percpu.h>
> +
> +#include <arch/opcode.h>
> +
> +#define __ARCH_WANT_KPROBES_INSN_SLOT
> +#define MAX_INSN_SIZE			2
> +
> +#define kretprobe_blacklist_size 0
> +
> +typedef tile_bundle_bits kprobe_opcode_t;
> +
> +#define flush_insn_slot(p)						\
> +	flush_icache_range((unsigned long)p->addr,			\
> +			   (unsigned long)p->addr +			\
> +			   (MAX_INSN_SIZE * sizeof(kprobe_opcode_t)))
> +
> +struct kprobe;
> +
> +/* Architecture specific copy of original instruction. */
> +struct arch_specific_insn {
> +	kprobe_opcode_t *insn;
> +};
> +
> +struct prev_kprobe {
> +	struct kprobe *kp;
> +	unsigned long status;
> +	unsigned long saved_pc;
> +};
> +
> +#define MAX_JPROBES_STACK_SIZE 128
> +#define MAX_JPROBES_STACK_ADDR \
> +	(((unsigned long)current_thread_info()) + THREAD_SIZE - 32 \
> +		- sizeof(struct pt_regs))
> +
> +#define MIN_JPROBES_STACK_SIZE(ADDR)					\
> +	((((ADDR) + MAX_JPROBES_STACK_SIZE) > MAX_JPROBES_STACK_ADDR)	\
> +		? MAX_JPROBES_STACK_ADDR - (ADDR)			\
> +		: MAX_JPROBES_STACK_SIZE)
> +
> +/* per-cpu kprobe control block. */
> +struct kprobe_ctlblk {
> +	unsigned long kprobe_status;
> +	unsigned long kprobe_saved_pc;
> +	unsigned long jprobe_saved_sp;
> +	struct prev_kprobe prev_kprobe;
> +	struct pt_regs jprobe_saved_regs;
> +	char jprobes_stack[MAX_JPROBES_STACK_SIZE];
> +};
> +
> +extern tile_bundle_bits breakpoint2_insn;
> +extern tile_bundle_bits breakpoint_insn;
> +
> +void arch_remove_kprobe(struct kprobe *);
> +
> +extern int kprobe_exceptions_notify(struct notifier_block *self,
> +			     unsigned long val, void *data);
> +
> +#endif /* _ASM_TILE_KPROBES_H */
> diff --git a/arch/tile/include/asm/ptrace.h b/arch/tile/include/asm/ptrace.h
> index 73b681b..0d25c21 100644
> --- a/arch/tile/include/asm/ptrace.h
> +++ b/arch/tile/include/asm/ptrace.h
> @@ -33,6 +33,7 @@ typedef unsigned long pt_reg_t;
>  
>  #ifndef __ASSEMBLY__
>  
> +#define regs_return_value(regs) ((regs)->regs[0])
>  #define instruction_pointer(regs) ((regs)->pc)
>  #define profile_pc(regs) instruction_pointer(regs)
>  #define user_stack_pointer(regs) ((regs)->sp)
> diff --git a/arch/tile/include/uapi/arch/opcode_tilegx.h b/arch/tile/include/uapi/arch/opcode_tilegx.h
> index c14d02c..d76ff2d 100644
> --- a/arch/tile/include/uapi/arch/opcode_tilegx.h
> +++ b/arch/tile/include/uapi/arch/opcode_tilegx.h
> @@ -61,6 +61,7 @@ typedef tilegx_bundle_bits tile_bundle_bits;
>  #define TILE_BUNDLE_ALIGNMENT_IN_BYTES TILEGX_BUNDLE_ALIGNMENT_IN_BYTES
>  #define TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES \
>    TILEGX_LOG2_BUNDLE_ALIGNMENT_IN_BYTES
> +#define TILE_BPT_BUNDLE TILEGX_BPT_BUNDLE
>  
>  /* 64-bit pattern for a { bpt ; nop } bundle. */
>  #define TILEGX_BPT_BUNDLE 0x286a44ae51485000ULL
> diff --git a/arch/tile/include/uapi/arch/opcode_tilepro.h b/arch/tile/include/uapi/arch/opcode_tilepro.h
> index 71b763b..4451cff 100644
> --- a/arch/tile/include/uapi/arch/opcode_tilepro.h
> +++ b/arch/tile/include/uapi/arch/opcode_tilepro.h
> @@ -71,6 +71,7 @@ typedef tilepro_bundle_bits tile_bundle_bits;
>  #define TILE_BUNDLE_ALIGNMENT_IN_BYTES TILEPRO_BUNDLE_ALIGNMENT_IN_BYTES
>  #define TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES \
>    TILEPRO_LOG2_BUNDLE_ALIGNMENT_IN_BYTES
> +#define TILE_BPT_BUNDLE TILEPRO_BPT_BUNDLE
>  
>  /* 64-bit pattern for a { bpt ; nop } bundle. */
>  #define TILEPRO_BPT_BUNDLE 0x400b3cae70166000ULL
> diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
> index 2e6eaa1..b7c8b5e 100644
> --- a/arch/tile/kernel/Makefile
> +++ b/arch/tile/kernel/Makefile
> @@ -28,5 +28,6 @@ endif
>  obj-$(CONFIG_TILE_USB)		+= usb.o
>  obj-$(CONFIG_TILE_HVGLUE_TRACE)	+= hvglue_trace.o
>  obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o mcount_64.o
> +obj-$(CONFIG_KPROBES)		+= kprobes.o
>  
>  obj-y				+= vdso/
> diff --git a/arch/tile/kernel/kprobes.c b/arch/tile/kernel/kprobes.c
> new file mode 100644
> index 0000000..1129f52
> --- /dev/null
> +++ b/arch/tile/kernel/kprobes.c
> @@ -0,0 +1,528 @@
> +/*
> + * arch/tile/kernel/kprobes.c
> + * Kprobes on TILE-Gx
> + *
> + * Some portions copied from the MIPS version.
> + *
> + * Copyright (C) IBM Corporation, 2002, 2004
> + * Copyright 2006 Sony Corp.
> + * Copyright 2010 Cavium Networks
> + *
> + * Copyright 2012 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +
> +#include <linux/kprobes.h>
> +#include <linux/kdebug.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +#include <asm/cacheflush.h>
> +
> +#include <arch/opcode.h>
> +
> +DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
> +DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
> +
> +tile_bundle_bits breakpoint_insn = TILEGX_BPT_BUNDLE;
> +tile_bundle_bits breakpoint2_insn = TILEGX_BPT_BUNDLE | DIE_SSTEPBP;
> +
> +/*
> + * Check whether instruction is branch or jump, or if executing it
> + * has different results depending on where it is executed (e.g. lnk).
> + */
> +static int __kprobes insn_has_control(kprobe_opcode_t insn)
> +{
> +	if (get_Mode(insn) != 0) {   /* Y-format bundle */
> +		if (get_Opcode_Y1(insn) != RRR_1_OPCODE_Y1 ||
> +		    get_RRROpcodeExtension_Y1(insn) != UNARY_RRR_1_OPCODE_Y1)
> +			return 0;
> +
> +		switch (get_UnaryOpcodeExtension_Y1(insn)) {
> +		case JALRP_UNARY_OPCODE_Y1:
> +		case JALR_UNARY_OPCODE_Y1:
> +		case JRP_UNARY_OPCODE_Y1:
> +		case JR_UNARY_OPCODE_Y1:
> +		case LNK_UNARY_OPCODE_Y1:
> +			return 1;
> +		default:
> +			return 0;
> +		}
> +	}
> +
> +	switch (get_Opcode_X1(insn)) {
> +	case BRANCH_OPCODE_X1:	/* branch instructions */
> +	case JUMP_OPCODE_X1:	/* jump instructions: j and jal */
> +		return 1;
> +
> +	case RRR_0_OPCODE_X1:   /* other jump instructions */
> +		if (get_RRROpcodeExtension_X1(insn) != UNARY_RRR_0_OPCODE_X1)
> +			return 0;
> +		switch (get_UnaryOpcodeExtension_X1(insn)) {
> +		case JALRP_UNARY_OPCODE_X1:
> +		case JALR_UNARY_OPCODE_X1:
> +		case JRP_UNARY_OPCODE_X1:
> +		case JR_UNARY_OPCODE_X1:
> +		case LNK_UNARY_OPCODE_X1:
> +			return 1;
> +		default:
> +			return 0;
> +		}
> +	default:
> +		return 0;
> +	}
> +}
> +
> +int __kprobes arch_prepare_kprobe(struct kprobe *p)
> +{
> +	unsigned long addr = (unsigned long)p->addr;
> +
> +	if (addr & (sizeof(kprobe_opcode_t) - 1))
> +		return -EINVAL;
> +
> +	if (insn_has_control(*p->addr)) {
> +		pr_notice("Kprobes for control instructions are not "
> +			  "supported\n");
> +		return -EINVAL;
> +	}
> +
> +	/* insn: must be on special executable page on tile. */
> +	p->ainsn.insn = get_insn_slot();
> +	if (!p->ainsn.insn)
> +		return -ENOMEM;
> +
> +	/*
> +	 * In the kprobe->ainsn.insn[] array we store the original
> +	 * instruction at index zero and a break trap instruction at
> +	 * index one.
> +	 */
> +	memcpy(&p->ainsn.insn[0], p->addr, sizeof(kprobe_opcode_t));
> +	p->ainsn.insn[1] = breakpoint2_insn;
> +	p->opcode = *p->addr;
> +
> +	return 0;
> +}
> +
> +void __kprobes arch_arm_kprobe(struct kprobe *p)
> +{
> +	unsigned long addr_wr;
> +
> +	/* Operate on writable kernel text mapping. */
> +	addr_wr = (unsigned long)p->addr - MEM_SV_START + PAGE_OFFSET;
> +
> +	if (probe_kernel_write((void *)addr_wr, &breakpoint_insn,
> +		sizeof(breakpoint_insn)))
> +		pr_err("%s: failed to enable kprobe\n", __func__);
> +
> +	smp_wmb();
> +	flush_insn_slot(p);
> +}
> +
> +void __kprobes arch_disarm_kprobe(struct kprobe *kp)
> +{
> +	unsigned long addr_wr;
> +
> +	/* Operate on writable kernel text mapping. */
> +	addr_wr = (unsigned long)kp->addr - MEM_SV_START + PAGE_OFFSET;
> +
> +	if (probe_kernel_write((void *)addr_wr, &kp->opcode,
> +		sizeof(kp->opcode)))
> +		pr_err("%s: failed to enable kprobe\n", __func__);
> +
> +	smp_wmb();
> +	flush_insn_slot(kp);
> +}
> +
> +void __kprobes arch_remove_kprobe(struct kprobe *p)
> +{
> +	if (p->ainsn.insn) {
> +		free_insn_slot(p->ainsn.insn, 0);
> +		p->ainsn.insn = NULL;
> +	}
> +}
> +
> +static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
> +{
> +	kcb->prev_kprobe.kp = kprobe_running();
> +	kcb->prev_kprobe.status = kcb->kprobe_status;
> +	kcb->prev_kprobe.saved_pc = kcb->kprobe_saved_pc;
> +}
> +
> +static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
> +{
> +	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
> +	kcb->kprobe_status = kcb->prev_kprobe.status;
> +	kcb->kprobe_saved_pc = kcb->prev_kprobe.saved_pc;
> +}
> +
> +static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
> +			struct kprobe_ctlblk *kcb)
> +{
> +	__get_cpu_var(current_kprobe) = p;
> +	kcb->kprobe_saved_pc = regs->pc;
> +}
> +
> +static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
> +{
> +	/* Single step inline if the instruction is a break. */
> +	if (p->opcode == breakpoint_insn ||
> +	    p->opcode == breakpoint2_insn)
> +		regs->pc = (unsigned long)p->addr;
> +	else
> +		regs->pc = (unsigned long)&p->ainsn.insn[0];
> +}
> +
> +static int __kprobes kprobe_handler(struct pt_regs *regs)
> +{
> +	struct kprobe *p;
> +	int ret = 0;
> +	kprobe_opcode_t *addr;
> +	struct kprobe_ctlblk *kcb;
> +
> +	addr = (kprobe_opcode_t *)regs->pc;
> +
> +	/*
> +	 * We don't want to be preempted for the entire
> +	 * duration of kprobe processing.
> +	 */
> +	preempt_disable();
> +	kcb = get_kprobe_ctlblk();
> +
> +	/* Check we're not actually recursing. */
> +	if (kprobe_running()) {
> +		p = get_kprobe(addr);
> +		if (p) {
> +			if (kcb->kprobe_status == KPROBE_HIT_SS &&
> +			    p->ainsn.insn[0] == breakpoint_insn) {
> +				goto no_kprobe;
> +			}
> +			/*
> +			 * We have reentered the kprobe_handler(), since
> +			 * another probe was hit while within the handler.
> +			 * We here save the original kprobes variables and
> +			 * just single step on the instruction of the new probe
> +			 * without calling any user handlers.
> +			 */
> +			save_previous_kprobe(kcb);
> +			set_current_kprobe(p, regs, kcb);
> +			kprobes_inc_nmissed_count(p);
> +			prepare_singlestep(p, regs);
> +			kcb->kprobe_status = KPROBE_REENTER;
> +			return 1;
> +		} else {
> +			if (*addr != breakpoint_insn) {
> +				/*
> +				 * The breakpoint instruction was removed by
> +				 * another cpu right after we hit, no further
> +				 * handling of this interrupt is appropriate.
> +				 */
> +				ret = 1;
> +				goto no_kprobe;
> +			}
> +			p = __get_cpu_var(current_kprobe);
> +			if (p->break_handler && p->break_handler(p, regs))
> +				goto ss_probe;
> +		}
> +		goto no_kprobe;
> +	}
> +
> +	p = get_kprobe(addr);
> +	if (!p) {
> +		if (*addr != breakpoint_insn) {
> +			/*
> +			 * The breakpoint instruction was removed right
> +			 * after we hit it.  Another cpu has removed
> +			 * either a probepoint or a debugger breakpoint
> +			 * at this address.  In either case, no further
> +			 * handling of this interrupt is appropriate.
> +			 */
> +			ret = 1;
> +		}
> +		/* Not one of ours: let kernel handle it. */
> +		goto no_kprobe;
> +	}
> +
> +	set_current_kprobe(p, regs, kcb);
> +	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
> +
> +	if (p->pre_handler && p->pre_handler(p, regs)) {
> +		/* Handler has already set things up, so skip ss setup. */
> +		return 1;
> +	}
> +
> +ss_probe:
> +	prepare_singlestep(p, regs);
> +	kcb->kprobe_status = KPROBE_HIT_SS;
> +	return 1;
> +
> +no_kprobe:
> +	preempt_enable_no_resched();
> +	return ret;
> +}
> +
> +/*
> + * Called after single-stepping.  p->addr is the address of the
> + * instruction that has been replaced by the breakpoint. To avoid the
> + * SMP problems that can occur when we temporarily put back the
> + * original opcode to single-step, we single-stepped a copy of the
> + * instruction.  The address of this copy is p->ainsn.insn.
> + *
> + * This function prepares to return from the post-single-step
> + * breakpoint trap.
> + */
> +static void __kprobes resume_execution(struct kprobe *p,
> +				       struct pt_regs *regs,
> +				       struct kprobe_ctlblk *kcb)
> +{
> +	unsigned long orig_pc = kcb->kprobe_saved_pc;
> +	regs->pc = orig_pc + 8;
> +}
> +
> +static inline int post_kprobe_handler(struct pt_regs *regs)
> +{
> +	struct kprobe *cur = kprobe_running();
> +	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
> +
> +	if (!cur)
> +		return 0;
> +
> +	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
> +		kcb->kprobe_status = KPROBE_HIT_SSDONE;
> +		cur->post_handler(cur, regs, 0);
> +	}
> +
> +	resume_execution(cur, regs, kcb);
> +
> +	/* Restore back the original saved kprobes variables and continue. */
> +	if (kcb->kprobe_status == KPROBE_REENTER) {
> +		restore_previous_kprobe(kcb);
> +		goto out;
> +	}
> +	reset_current_kprobe();
> +out:
> +	preempt_enable_no_resched();
> +
> +	return 1;
> +}
> +
> +static inline int kprobe_fault_handler(struct pt_regs *regs, int trapnr)
> +{
> +	struct kprobe *cur = kprobe_running();
> +	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
> +
> +	if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
> +		return 1;
> +
> +	if (kcb->kprobe_status & KPROBE_HIT_SS) {
> +		/*
> +		 * We are here because the instruction being single
> +		 * stepped caused a page fault. We reset the current
> +		 * kprobe and the ip points back to the probe address
> +		 * and allow the page fault handler to continue as a
> +		 * normal page fault.
> +		 */
> +		resume_execution(cur, regs, kcb);
> +		reset_current_kprobe();
> +		preempt_enable_no_resched();
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Wrapper routine for handling exceptions.
> + */
> +int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
> +				       unsigned long val, void *data)
> +{
> +	struct die_args *args = (struct die_args *)data;
> +	int ret = NOTIFY_DONE;
> +
> +	switch (val) {
> +	case DIE_BREAK:
> +		if (kprobe_handler(args->regs))
> +			ret = NOTIFY_STOP;
> +		break;
> +	case DIE_SSTEPBP:
> +		if (post_kprobe_handler(args->regs))
> +			ret = NOTIFY_STOP;
> +		break;
> +	case DIE_PAGE_FAULT:
> +		/* kprobe_running() needs smp_processor_id(). */
> +		preempt_disable();
> +
> +		if (kprobe_running()
> +		    && kprobe_fault_handler(args->regs, args->trapnr))
> +			ret = NOTIFY_STOP;
> +		preempt_enable();
> +		break;
> +	default:
> +		break;
> +	}
> +	return ret;
> +}
> +
> +int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
> +{
> +	struct jprobe *jp = container_of(p, struct jprobe, kp);
> +	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
> +
> +	kcb->jprobe_saved_regs = *regs;
> +	kcb->jprobe_saved_sp = regs->sp;
> +
> +	memcpy(kcb->jprobes_stack, (void *)kcb->jprobe_saved_sp,
> +	       MIN_JPROBES_STACK_SIZE(kcb->jprobe_saved_sp));
> +
> +	regs->pc = (unsigned long)(jp->entry);
> +
> +	return 1;
> +}
> +
> +/* Defined in the inline asm below. */
> +void jprobe_return_end(void);
> +
> +void __kprobes jprobe_return(void)
> +{
> +	asm volatile(
> +		"bpt\n\t"
> +		".globl jprobe_return_end\n"
> +		"jprobe_return_end:\n");
> +}
> +
> +int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
> +{
> +	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
> +
> +	if (regs->pc >= (unsigned long)jprobe_return &&
> +	    regs->pc <= (unsigned long)jprobe_return_end) {
> +		*regs = kcb->jprobe_saved_regs;
> +		memcpy((void *)kcb->jprobe_saved_sp, kcb->jprobes_stack,
> +		       MIN_JPROBES_STACK_SIZE(kcb->jprobe_saved_sp));
> +		preempt_enable_no_resched();
> +
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Function return probe trampoline:
> + * - init_kprobes() establishes a probepoint here
> + * - When the probed function returns, this probe causes the
> + *   handlers to fire
> + */
> +static void __used kretprobe_trampoline_holder(void)
> +{
> +	asm volatile(
> +		"nop\n\t"
> +		".global kretprobe_trampoline\n"
> +		"kretprobe_trampoline:\n\t"
> +		"nop\n\t"
> +		: : : "memory");
> +}
> +
> +void kretprobe_trampoline(void);
> +
> +void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
> +				      struct pt_regs *regs)
> +{
> +	ri->ret_addr = (kprobe_opcode_t *) regs->lr;
> +
> +	/* Replace the return addr with trampoline addr */
> +	regs->lr = (unsigned long)kretprobe_trampoline;
> +}
> +
> +/*
> + * Called when the probe at kretprobe trampoline is hit.
> + */
> +static int __kprobes trampoline_probe_handler(struct kprobe *p,
> +						struct pt_regs *regs)
> +{
> +	struct kretprobe_instance *ri = NULL;
> +	struct hlist_head *head, empty_rp;
> +	struct hlist_node *tmp;
> +	unsigned long flags, orig_ret_address = 0;
> +	unsigned long trampoline_address = (unsigned long)kretprobe_trampoline;
> +
> +	INIT_HLIST_HEAD(&empty_rp);
> +	kretprobe_hash_lock(current, &head, &flags);
> +
> +	/*
> +	 * It is possible to have multiple instances associated with a given
> +	 * task either because multiple functions in the call path have
> +	 * a return probe installed on them, and/or more than one return
> +	 * return probe was registered for a target function.
> +	 *
> +	 * We can handle this because:
> +	 *     - instances are always inserted at the head of the list
> +	 *     - when multiple return probes are registered for the same
> +	 *       function, the first instance's ret_addr will point to the
> +	 *       real return address, and all the rest will point to
> +	 *       kretprobe_trampoline
> +	 */
> +	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
> +		if (ri->task != current)
> +			/* another task is sharing our hash bucket */
> +			continue;
> +
> +		if (ri->rp && ri->rp->handler)
> +			ri->rp->handler(ri, regs);
> +
> +		orig_ret_address = (unsigned long)ri->ret_addr;
> +		recycle_rp_inst(ri, &empty_rp);
> +
> +		if (orig_ret_address != trampoline_address) {
> +			/*
> +			 * This is the real return address. Any other
> +			 * instances associated with this task are for
> +			 * other calls deeper on the call stack
> +			 */
> +			break;
> +		}
> +	}
> +
> +	kretprobe_assert(ri, orig_ret_address, trampoline_address);
> +	instruction_pointer(regs) = orig_ret_address;
> +
> +	reset_current_kprobe();
> +	kretprobe_hash_unlock(current, &flags);
> +	preempt_enable_no_resched();
> +
> +	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
> +		hlist_del(&ri->hlist);
> +		kfree(ri);
> +	}
> +	/*
> +	 * By returning a non-zero value, we are telling
> +	 * kprobe_handler() that we don't want the post_handler
> +	 * to run (and have re-enabled preemption)
> +	 */
> +	return 1;
> +}
> +
> +int __kprobes arch_trampoline_kprobe(struct kprobe *p)
> +{
> +	if (p->addr == (kprobe_opcode_t *)kretprobe_trampoline)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static struct kprobe trampoline_p = {
> +	.addr = (kprobe_opcode_t *)kretprobe_trampoline,
> +	.pre_handler = trampoline_probe_handler
> +};
> +
> +int __init arch_init_kprobes(void)
> +{
> +	register_kprobe(&trampoline_p);
> +	return 0;
> +}
> diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
> index 6cc520d..0ae1c59 100644
> --- a/arch/tile/kernel/smp.c
> +++ b/arch/tile/kernel/smp.c
> @@ -20,6 +20,7 @@
>  #include <linux/irq.h>
>  #include <linux/module.h>
>  #include <asm/cacheflush.h>
> +#include <asm/homecache.h>
>  
>  HV_Topology smp_topology __write_once;
>  EXPORT_SYMBOL(smp_topology);
> @@ -167,9 +168,16 @@ static void ipi_flush_icache_range(void *info)
>  void flush_icache_range(unsigned long start, unsigned long end)
>  {
>  	struct ipi_flush flush = { start, end };
> -	preempt_disable();
> -	on_each_cpu(ipi_flush_icache_range, &flush, 1);
> -	preempt_enable();
> +
> +	/* If invoked with irqs disabled, we can not issue IPIs. */
> +	if (irqs_disabled())
> +		flush_remote(0, HV_FLUSH_EVICT_L1I, NULL, 0, 0, 0,
> +			NULL, NULL, 0);
> +	else {
> +		preempt_disable();
> +		on_each_cpu(ipi_flush_icache_range, &flush, 1);
> +		preempt_enable();
> +	}
>  }
>  
>  
> diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
> index a1bbc5de..f110785 100644
> --- a/arch/tile/kernel/traps.c
> +++ b/arch/tile/kernel/traps.c
> @@ -15,6 +15,7 @@
>  #include <linux/sched.h>
>  #include <linux/kernel.h>
>  #include <linux/kprobes.h>
> +#include <linux/kdebug.h>
>  #include <linux/module.h>
>  #include <linux/reboot.h>
>  #include <linux/uaccess.h>
> @@ -214,6 +215,43 @@ static const char *const int_name[] = {
>  #endif
>  };
>  
> +static int do_bpt(struct pt_regs *regs)
> +{
> +	unsigned long bundle, bcode, bpt;
> +
> +	bundle = *(unsigned long *)instruction_pointer(regs);
> +
> +	/*
> +	 * bpt shoule be { bpt; nop }, which is 0x286a44ae51485000ULL.
> +	 * we encode the unused least significant bits for other purpose.
> +	 */
> +	bpt = bundle & ~((1ULL << 12) - 1);
> +	if (bpt != TILE_BPT_BUNDLE)
> +		return 0;
> +
> +	bcode = bundle & ((1ULL << 12) - 1);
> +	/*
> +	 * notify the kprobe handlers, if instruction is likely to
> +	 * pertain to them.
> +	 */
> +	switch (bcode) {
> +	/* breakpoint_insn */
> +	case 0:
> +		notify_die(DIE_BREAK, "debug", regs, bundle,
> +			INT_ILL, SIGTRAP);
> +		break;
> +	/* breakpoint2_insn */
> +	case DIE_SSTEPBP:
> +		notify_die(DIE_SSTEPBP, "single_step", regs, bundle,
> +			INT_ILL, SIGTRAP);
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
>  void __kprobes do_trap(struct pt_regs *regs, int fault_num,
>  		       unsigned long reason)
>  {
> @@ -233,6 +271,10 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
>  	if (!user_mode(regs)) {
>  		const char *name;
>  		char buf[100];
> +		if (fault_num == INT_ILL && do_bpt(regs)) {
> +			/* breakpoint */
> +			return;
> +		}
>  		if (fixup_exception(regs))  /* ILL_TRANS or UNALIGN_DATA */
>  			return;
>  		if (fault_num >= 0 &&
> diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
> index 673d00a..aab9955 100644
> --- a/arch/tile/kernel/vmlinux.lds.S
> +++ b/arch/tile/kernel/vmlinux.lds.S
> @@ -43,6 +43,7 @@ SECTIONS
>      HEAD_TEXT
>      SCHED_TEXT
>      LOCK_TEXT
> +    KPROBES_TEXT
>      IRQENTRY_TEXT
>      __fix_text_end = .;   /* tile-cpack won't rearrange before this */
>      TEXT_TEXT
> diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
> index 502664a..64eec3f 100644
> --- a/arch/tile/mm/fault.c
> +++ b/arch/tile/mm/fault.c
> @@ -34,6 +34,7 @@
>  #include <linux/hugetlb.h>
>  #include <linux/syscalls.h>
>  #include <linux/uaccess.h>
> +#include <linux/kdebug.h>
>  
>  #include <asm/pgalloc.h>
>  #include <asm/sections.h>
> @@ -721,6 +722,17 @@ void do_page_fault(struct pt_regs *regs, int fault_num,
>  {
>  	int is_page_fault;
>  
> +#ifdef CONFIG_KPROBES
> +	/*
> +	 * This is to notify the fault handler of the kprobes.  The
> +	 * exception code is redundant as it is also carried in REGS,
> +	 * but we pass it anyhow.
> +	 */
> +	if (notify_die(DIE_PAGE_FAULT, "page fault", regs, -1,
> +		       regs->faultnum, SIGSEGV) == NOTIFY_STOP)
> +		return;
> +#endif
> +
>  #ifdef __tilegx__
>  	/*
>  	 * We don't need early do_page_fault_ics() support, since unlike
> diff --git a/samples/kprobes/kprobe_example.c b/samples/kprobes/kprobe_example.c
> index ebf5e0c..366db1a 100644
> --- a/samples/kprobes/kprobe_example.c
> +++ b/samples/kprobes/kprobe_example.c
> @@ -37,6 +37,11 @@ static int handler_pre(struct kprobe *p, struct pt_regs *regs)
>  			" status = 0x%lx\n",
>  		p->addr, regs->cp0_epc, regs->cp0_status);
>  #endif
> +#ifdef CONFIG_TILEGX
> +	printk(KERN_INFO "pre_handler: p->addr = 0x%p, pc = 0x%lx,"
> +			" ex1 = 0x%lx\n",
> +		p->addr, regs->pc, regs->ex1);
> +#endif
>  
>  	/* A dump_stack() here will give a stack backtrace */
>  	return 0;
> @@ -58,6 +63,10 @@ static void handler_post(struct kprobe *p, struct pt_regs *regs,
>  	printk(KERN_INFO "post_handler: p->addr = 0x%p, status = 0x%lx\n",
>  		p->addr, regs->cp0_status);
>  #endif
> +#ifdef CONFIG_TILEGX
> +	printk(KERN_INFO "post_handler: p->addr = 0x%p, ex1 = 0x%lx\n",
> +		p->addr, regs->ex1);
> +#endif
>  }
>  
>  /*
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


