Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3KKFgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 00:36:09 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:50889 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3KKFfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:35:39 -0500
MIME-Version: 1.0
In-Reply-To: <20131108165639.GD15074@mudshark.cambridge.arm.com>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
	<1382008671-4515-3-git-send-email-sandeepa.prabhu@linaro.org>
	<20131108165639.GD15074@mudshark.cambridge.arm.com>
Date: Mon, 11 Nov 2013 11:05:37 +0530
Message-ID: <CA+b37P2Yt8Hb_fgtLfw56DO=ZGC0LxVkxJHftHdxa45HQTXJcQ@mail.gmail.com>
Subject: Re: [PATCH RFC 2/6] arm64: Kprobes with single stepping support
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2013 22:26, Will Deacon <will.deacon@arm.com> wrote:
> Hi Sandeepa,
>
> On Thu, Oct 17, 2013 at 12:17:47PM +0100, Sandeepa Prabhu wrote:
>> Add support for basic kernel probes(kprobes), jump probes (jprobes)
>> for ARM64.
>
> I think this series will conflict quite heavily with the jump_label series,
> since they both introduce some common instruction manipulation code. On the
> debug side, there will also be conflicts with the kgdb series, so it might
> make sense for us to merge those two first, then you can rebase on a stable
> branch from us.
Yes, I understand, also the 3 features (kgdb, kprobes, jump_labels)
share some API dependencies.
I can rebase and re-post kprobes after the other 2 are merged.

The patch  "[PATCH RFC v3 1/5] AArch64: Add single-step and breakpoint
handler hooks"  will merge first along with kgdb?

>
> [...]
>
>> diff --git a/arch/arm64/include/asm/kprobes.h b/arch/arm64/include/asm/kprobes.h
>> new file mode 100644
>> index 0000000..9b491d0
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/kprobes.h
>> @@ -0,0 +1,59 @@
>> +/*
>> + * arch/arm64/include/asm/kprobes.h
>> + *
>> + * Copyright (C) 2013 Linaro Limited
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +
>> +#ifndef _ARM_KPROBES_H
>> +#define _ARM_KPROBES_H
>> +
>> +#include <linux/types.h>
>> +#include <linux/ptrace.h>
>> +#include <linux/percpu.h>
>> +
>> +#define __ARCH_WANT_KPROBES_INSN_SLOT
>> +#define MAX_INSN_SIZE                  2
>
> Why is this 2?
Second entry is to hold NOP instruction, absence of it cause abort
while instruction decode.

>
>> +#define MAX_STACK_SIZE                 128
>> +
>> +#define flush_insn_slot(p)             do { } while (0)
>> +#define kretprobe_blacklist_size       0
>> +
>> +#include <asm/probes.h>
>> +
>> +struct prev_kprobe {
>> +       struct kprobe *kp;
>> +       unsigned int status;
>> +};
>> +
>> +/* Single step context for kprobe */
>> +struct kprobe_step_ctx {
>> +#define KPROBES_STEP_NONE      0x0
>> +#define KPROBES_STEP_PENDING   0x1
>
> Maybe use an enum to stay consistent with what you did for pc_restore_t?
OK, I will change it to enums.
>
>> diff --git a/arch/arm64/kernel/kprobes-arm64.c b/arch/arm64/kernel/kprobes-arm64.c
>> new file mode 100644
>> index 0000000..30d1c14
>> --- /dev/null
>> +++ b/arch/arm64/kernel/kprobes-arm64.c
>> @@ -0,0 +1,211 @@
>> +/*
>> + * arch/arm64/kernel/kprobes-arm64.c
>> + *
>> + * Copyright (C) 2013 Linaro Limited.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/kprobes.h>
>> +#include <linux/module.h>
>> +#include <asm/kprobes.h>
>> +
>> +#include "probes-decode.h"
>> +#include "kprobes-arm64.h"
>> +
>> +/* AArch64 instruction decode table for kprobes:
>> + * The instruction will fall into one of the 3 groups:
>> + *  1. Single stepped out-of-the-line slot.
>> + *     -Most instructions fall in this group, those does not
>> + *      depend on PC address.
>> + *
>> + *  2. Should be simulated because of PC-relative/literal access.
>> + *     -All branching and PC-relative insrtcutions are simulated
>> + *      in C code, making use of saved pt_regs
>> + *      Catch: SIMD/NEON register context are not saved while
>> + *      entering debug exception, so are rejected for now.
>> + *
>> + *  3. Cannot be probed(not safe) so are rejected.
>> + *     - Exception generation and exception return instructions
>> + *     - Exclusive monitor(LDREX/STREX family)
>> + *
>> + */
>> +static const struct aarch64_decode_item aarch64_decode_table[] = {
>> +       /*
>> +        * Data processing - PC relative(literal) addressing:
>> +        * Encoding: xxx1 0000 xxxx xxxx xxxx xxxx xxxx xxxx
>> +        */
>> +       DECODE_REJECT(0x10000000, 0x1F000000),
>> +
>> +       /*
>> +        * Data processing - Add/Substract Immediate:
>> +        * Encoding: xxx1 0001 xxxx xxxx xxxx xxxx xxxx xxxx
>> +        */
>> +       DECODE_SINGLESTEP(0x11000000, 0x1F000000),
>> +
>> +       /*
>> +        * Data processing
>> +        * Encoding:
>> +        *      xxx1 0010 0xxx xxxx xxxx xxxx xxxx xxxx (Logical)
>> +        *      xxx1 0010 1xxx xxxx xxxx xxxx xxxx xxxx (Move wide)
>> +        *      xxx1 0011 0xxx xxxx xxxx xxxx xxxx xxxx (Bitfield)
>> +        *      xxx1 0011 1xxx xxxx xxxx xxxx xxxx xxxx (Extract)
>> +        */
>> +       DECODE_SINGLESTEP(0x12000000, 0x1E000000),
>> +
>> +       /*
>> +        * Data processing - SIMD/FP/AdvSIMD/Crypto-AES/SHA
>> +        * Encoding: xxx0 111x xxxx xxxx xxxx xxxx xxxx xxxx
>> +        * Encoding: xxx1 111x xxxx xxxx xxxx xxxx xxxx xxxx
>> +        */
>> +       DECODE_SINGLESTEP(0x0E000000, 0x0E000000),
>> +
>> +       /*
>> +        * Data processing - Register
>> +        * Encoding: xxxx 101x xxxx xxxx xxxx xxxx xxxx xxxx
>> +        */
>> +       DECODE_SINGLESTEP(0x0A000000, 0x0E000000),
>> +
>> +       /* Branching Instructions
>> +        *
>> +        * Encoding:
>> +        *  x001 01xx xxxx xxxx xxxx xxxx xxxx xxxx (uncondtional Branch)
>
> Unconditional
OK, I will make all the descriptions consistent (capitalised).
>
>> +        *  x011 010x xxxx xxxx xxxx xxxx xxxx xxxx (compare & branch)
>
> Compare (capitalisation)
>
>> +        *  x011 011x xxxx xxxx xxxx xxxx xxxx xxxx (Test & Branch)
>> +        *  0101 010x xxxx xxxx xxxx xxxx xxxx xxxx (Conditional, immediate)
>> +        *  1101 011x xxxx xxxx xxxx xxxx xxxx xxxx (Unconditional,register)
>> +        */
>> +       DECODE_REJECT(0x14000000, 0x7C000000),
>> +       DECODE_REJECT(0x14000000, 0x7C000000),
>> +       DECODE_REJECT(0x34000000, 0x7E000000),
>> +       DECODE_REJECT(0x36000000, 0x7E000000),
>> +       DECODE_REJECT(0x54000000, 0xFE000000),
>> +       DECODE_REJECT(0xD6000000, 0xFE000000),
>> +
>> +       /* System insn:
>> +        * Encoding: 1101 0101 00xx xxxx xxxx xxxx xxxx xxxx
>> +        *
>> +        * Note: MSR immediate (update PSTATE daif) is not safe handling
>> +        * within kprobes, rejected.
>> +        *
>> +        * Don't re-arrange these decode table entries.
>> +        */
>> +       DECODE_REJECT(0xD500401F, 0xFFF8F01F),
>> +       DECODE_SINGLESTEP(0xD5000000, 0xFFC00000),
>> +
>> +       /* Exception Generation:
>> +        * Encoding:  1101 0100 xxxx xxxx xxxx xxxx xxxx xxxx
>> +        * Instructions: SVC, HVC, SMC, BRK, HLT, DCPS1, DCPS2, DCPS3
>> +        */
>> +       DECODE_REJECT(0xD4000000, 0xFF000000),
>> +
>> +       /*
>> +        * Load/Store - Exclusive monitor
>> +        * Encoding: xx00 1000 xxxx xxxx xxxx xxxx xxxx xxxx
>> +        *
>> +        * Reject exlusive monitor'ed instructions
>
> exclusive. Also, omit `monitor'ed' -- it doesn't mean anything.
Sure.
>
>> +        */
>> +       DECODE_REJECT(0x08000000, 0x3F000000),
>> +
>> +       /*
>> +        * Load/Store - PC relative(literal):
>> +        * Encoding:  xx01 1x00 xxxx xxxx xxxx xxxx xxxx xxxx
>> +        */
>> +       DECODE_REJECT(0x18000000, 0x3B000000),
>> +
>> +       /*
>> +        * Load/Store - Register Pair
>> +        * Encoding:
>> +        *      xx10 1x00 0xxx xxxx xxxx xxxx xxxx xxxx
>> +        *      xx10 1x00 1xxx xxxx xxxx xxxx xxxx xxxx
>> +        *      xx10 1x01 0xxx xxxx xxxx xxxx xxxx xxxx
>> +        *      xx10 1x01 1xxx xxxx xxxx xxxx xxxx xxxx
>> +        */
>> +       DECODE_SINGLESTEP(0x28000000, 0x3A000000),
>> +
>> +       /*
>> +        * Load/Store - Register
>> +        * Encoding:
>> +        *      xx11 1x00 xx0x xxxx xxxx 00xx xxxx xxxx (unscaled imm)
>> +        *      xx11 1x00 xx0x xxxx xxxx 01xx xxxx xxxx (imm post-indexed)
>> +        *      xx11 1x00 xx0x xxxx xxxx 10xx xxxx xxxx (unpriviledged)
>> +        *      xx11 1x00 xx0x xxxx xxxx 11xx xxxx xxxx (imm pre-indexed)
>> +        *
>> +        *      xx11 1x00 xx10 xxxx xxxx xx10 xxxx xxxx (register offset)
>> +        *
>> +        *      xx11 1x01 xxxx xxxx xxxx xxxx xxxx xxxx (unsigned imm)
>> +        */
>> +       DECODE_SINGLESTEP(0x38000000, 0x3B200000),
>> +       DECODE_SINGLESTEP(0x38200200, 0x38300300),
>> +       DECODE_SINGLESTEP(0x39000000, 0x3B000000),
>> +
>> +       /*
>> +        * Load/Store - AdvSIMD
>> +        * Encoding:
>> +        *  0x00 1100 0x00 0000 xxxx xxxx xxxx xxxx (Multiple-structure)
>> +        *  0x00 1100 1x0x xxxx xxxx xxxx xxxx xxxx (Multi-struct post-indexed)
>> +        *  0x00 1101 0xx0 0000 xxxx xxxx xxxx xxxx (Single-structure))
>> +        *  0x00 1101 1xxx xxxx xxxx xxxx xxxx xxxx (Single-struct post-index)
>> +        */
>> +       DECODE_SINGLESTEP(0x0C000000, 0xBFBF0000),
>> +       DECODE_SINGLESTEP(0x0C800000, 0xBFA00000),
>> +       DECODE_SINGLESTEP(0x0D000000, 0xBF9F0000),
>> +       DECODE_SINGLESTEP(0x0D800000, 0xBF800000),
>> +
>> +       /* Unallocated:         xxx0 0xxx xxxx xxxx xxxx xxxx xxxx xxxx */
>> +       DECODE_REJECT(0x00000000, 0x18000000),
>> +       DECODE_END,
>> +};
>> +
>> +static int __kprobes
>> +kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
>> +                  const struct aarch64_decode_item *tbl)
>> +{
>> +       unsigned int entry, ret = INSN_REJECTED;
>> +
>> +       for (entry = 0; !decode_table_end(tbl[entry]); entry++) {
>> +               if (decode_table_hit(tbl[entry], insn))
>> +                       break;
>> +       }
>> +
>> +       switch (decode_get_type(tbl[entry])) {
>> +       case DECODE_TYPE_END:
>> +       case DECODE_TYPE_REJECT:
>> +       default:
>> +               ret = INSN_REJECTED;
>> +               break;
>> +
>> +       case DECODE_TYPE_SINGLESTEP:
>> +               ret = INSN_GOOD;
>> +               break;
>> +
>> +       case DECODE_TYPE_SIMULATE:
>> +               ret = INSN_REJECTED;
>> +               break;
>> +
>> +       case DECODE_TYPE_TABLE:
>> +               /* recurse with next level decode table */
>> +               ret = kprobe_decode_insn(insn, asi,
>> +                                        decode_sub_table(tbl[entry]));
>> +       };
>> +       return ret;
>> +}
>> +
>> +/* Return:
>> + *   INSN_REJECTED     If instruction is one not allowed to kprobe,
>> + *   INSN_GOOD         If instruction is supported and uses instruction slot,
>> + *   INSN_GOOD_NO_SLOT If instruction is supported but doesn't use its slot.
>> + */
>> +enum kprobe_insn __kprobes
>> +arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi)
>> +{
>> +       return kprobe_decode_insn(insn, asi, aarch64_decode_table);
>> +}
>> diff --git a/arch/arm64/kernel/kprobes-arm64.h b/arch/arm64/kernel/kprobes-arm64.h
>> new file mode 100644
>> index 0000000..87e7891
>> --- /dev/null
>> +++ b/arch/arm64/kernel/kprobes-arm64.h
>> @@ -0,0 +1,28 @@
>> +/*
>> + * arch/arm64/kernel/kprobes-arm64.h
>> + *
>> + * Copyright (C) 2013 Linaro Limited.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +
>> +#ifndef _ARM_KERNEL_KPROBES_ARM64_H
>> +#define _ARM_KERNEL_KPROBES_ARM64_H
>> +
>> +enum kprobe_insn {
>> +       INSN_REJECTED,
>> +       INSN_GOOD_NO_SLOT,
>> +       INSN_GOOD,
>> +};
>> +
>> +enum kprobe_insn __kprobes
>> +arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi);
>> +
>> +#endif /* _ARM_KERNEL_KPROBES_ARM64_H */
>> diff --git a/arch/arm64/kernel/kprobes.c b/arch/arm64/kernel/kprobes.c
>> new file mode 100644
>> index 0000000..def10b6
>> --- /dev/null
>> +++ b/arch/arm64/kernel/kprobes.c
>> @@ -0,0 +1,538 @@
>> +/*
>> + * arch/arm64/kernel/kprobes.c
>> + *
>> + * Kprobes support for ARM64
>> + *
>> + * Copyright (C) 2013 Linaro Limited.
>> + * Author: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + */
>> +#include <linux/kernel.h>
>> +#include <linux/kprobes.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/stop_machine.h>
>> +#include <linux/stringify.h>
>> +#include <asm/traps.h>
>> +#include <asm/cacheflush.h>
>> +#include <asm/debug-monitors.h>
>> +#include <asm/system_misc.h>
>> +#include <asm/insn.h>
>> +
>> +#include "kprobes.h"
>> +#include "kprobes-arm64.h"
>> +
>> +#define MIN_STACK_SIZE(addr)   min((unsigned long)MAX_STACK_SIZE,      \
>> +       (unsigned long)current_thread_info() + THREAD_START_SP - (addr))
>
> Why is this not defined along with MAX_STACK_SIZE?
Hmm can be move to header file.
>
>> +DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
>> +DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>> +
>> +static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
>> +{
>> +       int i;
>> +       /* prepare insn slot */
>> +       p->ainsn.insn[0] = p->opcode;
>> +       /* NOP for superscalar uArch decode */
>
> superscalar uArch?
well, the comment needs refining, what we mean is that one NOP should
follow the instruction in memory slot, for the decode stage(not to hit
undefined instruction).
>
>> +       for (i = 1; i < MAX_INSN_SIZE; i++)
>> +               p->ainsn.insn[i] = ARCH64_NOP_OPCODE;
>
> Should be AARCH64 (yes, that's two adjacent 'A's!). Also, I think the
> jump_label stuff had helpers to give you a NOP hint.
will check, all we need here is 'opcode' value to fill-in the memory location.
>
>> +
>> +       flush_icache_range((uintptr_t) (p->ainsn.insn),
>> +                          (uintptr_t) (p->ainsn.insn) + MAX_INSN_SIZE);
>> +}
>> +
>> +int __kprobes arch_prepare_kprobe(struct kprobe *p)
>> +{
>> +       kprobe_opcode_t insn;
>> +       unsigned long probe_addr = (unsigned long)p->addr;
>> +
>> +       /* copy instruction */
>> +       insn = *p->addr;
>> +       p->opcode = insn;
>> +
>> +       if (in_exception_text(probe_addr))
>> +               return -EINVAL;
>> +
>> +       /* decode instruction */
>> +       switch (arm_kprobe_decode_insn(insn, &p->ainsn)) {
>> +       case INSN_REJECTED:     /* insn not supported */
>> +               return -EINVAL;
>> +               break;
>> +
>> +       case INSN_GOOD_NO_SLOT: /* insn need simulation */
>> +               return -EINVAL;
>> +               break;
>> +
>> +       case INSN_GOOD: /* instruction uses slot */
>> +               p->ainsn.insn = get_insn_slot();
>> +               if (!p->ainsn.insn)
>> +                       return -ENOMEM;
>> +               break;
>> +       };
>> +
>> +       /* prepare the instruction */
>> +       arch_prepare_ss_slot(p);
>> +
>> +       return 0;
>> +}
>> +
>> +static int __kprobes patch_text(kprobe_opcode_t *addr, u32 opcode)
>> +{
>> +       void *addrs[1];
>> +       u32 insns[1];
>> +
>> +       addrs[0] = (void *)addr;
>> +       insns[0] = (u32)opcode;
>> +
>> +       return aarch64_insn_patch_text_sync(addrs, insns, 1);
>> +}
>> +
>> +/* arm kprobe: install breakpoint in text */
>> +void __kprobes arch_arm_kprobe(struct kprobe *p)
>> +{
>> +       patch_text(p->addr, BRK64_OPCODE_KPROBES);
>> +}
>> +
>> +/* disarm kprobe: remove breakpoint from text */
>> +void __kprobes arch_disarm_kprobe(struct kprobe *p)
>> +{
>> +       patch_text(p->addr, p->opcode);
>> +}
>> +
>> +void __kprobes arch_remove_kprobe(struct kprobe *p)
>> +{
>> +       if (p->ainsn.insn) {
>> +               free_insn_slot(p->ainsn.insn, 0);
>> +               p->ainsn.insn = NULL;
>> +       }
>> +}
>> +
>> +static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
>> +{
>> +       kcb->prev_kprobe.kp = kprobe_running();
>> +       kcb->prev_kprobe.status = kcb->kprobe_status;
>> +}
>> +
>> +static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
>> +{
>> +       __get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
>> +       kcb->kprobe_status = kcb->prev_kprobe.status;
>> +}
>> +
>> +static void __kprobes set_current_kprobe(struct kprobe *p)
>> +{
>> +       __get_cpu_var(current_kprobe) = p;
>> +}
>
> __get_cpu_var uses were being cleaned up by Christoph recently. Take a look
> in -next to see some examples of conversions over to this_cpu_*.
Ok, would check this, can change in next version of the patch.
>
>> +static void __kprobes
>> +set_ss_context(struct kprobe_ctlblk *kcb, unsigned long addr)
>> +{
>> +       kcb->ss_ctx.ss_status = KPROBES_STEP_PENDING;
>> +       kcb->ss_ctx.match_addr = addr + sizeof(kprobe_opcode_t);
>> +}
>> +
>> +static void __kprobes clear_ss_context(struct kprobe_ctlblk *kcb)
>> +{
>> +       kcb->ss_ctx.ss_status = KPROBES_STEP_NONE;
>> +       kcb->ss_ctx.match_addr = 0;
>> +}
>> +
>> +static void __kprobes
>> +nop_singlestep_skip(struct kprobe *p, struct pt_regs *regs)
>> +{
>> +       /* set return addr to next pc to continue */
>> +       instruction_pointer(regs) += sizeof(kprobe_opcode_t);
>> +       return;
>> +}
>> +
>> +/* Mask/Unmask PSTATE.D flag
>> + *
>> + * Unmasking D-flag enables recursing into another debug
>> + * exception (breakpoint or single step).
>> + *
>> + * Upon every exception entry, D-flag is disabled by the
>> + * hardware. We shall unmask this flag only after safely
>> + * saved the previous context and kprobes state machines.
>> + *
>> + * kprobes can generate recursing in breakpoint (followed
>> + * by single stepping) within user-provided handlers only.
>> + *
>> + * All other places, keep the D-flag masked.
>> + */
>> +static void mask_pstate_debug_flag(u32 mask)
>> +{
>> +       if (mask)
>> +               asm volatile("msr daifset, #9\n\t");
>> +       else
>> +               asm volatile("msr daifclr, #9\n\t");
>> +}
>
> NAK. Unmasking debug exceptions from within a debug exception is not safe.
> I'd much rather we returned from handling this exception, then took whatever
> other pending exception there was.
well, kprobes needs recursive breakpoints to be handled, and I am not
sure if this can be achieved other way than unmasking D-flag for a
shorter duration where we can expect re-entry (I would check if this
can be done without re-cursing)
I want to understand why unmasking D-flag is unsafe here, kprobes make
sure that recursion depth is only 2 (i.e. does not generate 3rd
Breakpoint trap) and interrupts are kept masked while recursion/single
stepping. Is it unsafe only if conflict with hardware breakpoint on
same CPU?

>
> In fact, how do you avoid a race with hardware breakpoints? E.g., somebody
> places a hardware breakpoint on an instruction in the kernel for which
> kprobes has patched in a brk. We take the hardware breakpoint, disable the
> breakpoint and set up a single step before returning to the brk. The brk
> then traps, but we must take care not to disable single-step and/or unmask
> debug exceptions, because that will cause the hardware breakpoint code to
> re-arm its breakpoint before we've stepped off the brk instruction.
Not sure if kprobes can work together with hardware breakpoint or kgdb
when multiple breakpoints (h/w and s/w) are placed on same text
address. How arm32 and x86 handle this kind of scenario?
Probably, the person debugging hardware breakpoint or kgdb should have
control over the flow and disable kprobes (sysfs interface available)?

>
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
