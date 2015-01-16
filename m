Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbbAPT3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:29:17 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:60104 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbbAPT2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:28:37 -0500
Message-ID: <54B96662.3030201@linaro.org>
Date: Fri, 16 Jan 2015 14:28:34 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Pratyush Anand <pratyush.anand@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        William Cohen <wcohen@redhat.com>,
        Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        Pratyush Anand <panand@redhat.com>
Subject: Re: [PATCH v4 3/6] arm64: Kprobes with single stepping support
References: <1420949002-3726-1-git-send-email-dave.long@linaro.org>	<1420949002-3726-4-git-send-email-dave.long@linaro.org> <CAHM4w1no=A1kTxN26znXD42USzO+ByHWHy76F2UMnmXhPKH0kQ@mail.gmail.com>
In-Reply-To: <CAHM4w1no=A1kTxN26znXD42USzO+ByHWHy76F2UMnmXhPKH0kQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/15 04:30, Pratyush Anand wrote:
> Hi Dave,
>
> On Sun, Jan 11, 2015 at 9:33 AM, David Long <dave.long@linaro.org> wrote:
>> From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
>>
>> Add support for basic kernel probes(kprobes) and jump probes
>> (jprobes) for ARM64.
>>
>> Kprobes will utilize software breakpoint and single step debug
>> exceptions supported on ARM v8.
>>
>> Software breakpoint is placed at the probe address to trap the
>> kernel execution into kprobe handler.
>>
>> ARM v8 supports single stepping to be enabled while exception return
>> (ERET) with next PC in exception return address (ELR_EL1). The
>> kprobe handler prepares an executable memory slot for out-of-line
>> execution with a copy of the original instruction being probed, and
>> enables single stepping from the instruction slot. With this scheme,
>> the instruction is executed with the exact same register context
>> 'except PC' that points to instruction slot.
>>
>> Debug mask(PSTATE.D) is enabled only when single stepping a recursive
>> kprobe, e.g.: during kprobes reenter so that probed instruction can be
>> single stepped within the kprobe handler -exception- context.
>> The recursion depth of kprobe is always 2, i.e. upon probe re-entry,
>> any further re-entry is prevented by not calling handlers and the case
>> counted as a missed kprobe).
>>
>> Single stepping from slot has a drawback on PC-relative accesses
>> like branching and symbolic literals access as offset from new PC
>> (slot address) may not be ensured to fit in immediate value of
>> opcode. Such instructions needs simulation, so reject
>> probing such instructions.
>>
>> Instructions generating exceptions or cpu mode change are rejected,
>> and not allowed to insert probe for these instructions.
>>
>> Instructions using Exclusive Monitor are rejected too.
>>
>> System instructions are mostly enabled for stepping, except MSR
>> immediate that updates "daif" flags in PSTATE, which are not safe
>> for probing.
>>
>> Changes since v3:
>> from David Long:
>> 1) Removed unnecessary addtion of NOP after out-of-line instruction.
>> 2) Replaced table-driven instruction parsing with calls to external
>>     test functions.
>> from Steve Capper:
>> 3) Disable local irq while executing out of line instruction.
>>
>> Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
>> Signed-off-by: Steve Capper <steve.capper@linaro.org>
>> Signed-off-by: David A. Long <dave.long@linaro.org>
>> ---
>>   arch/arm64/Kconfig                |   1 +
>>   arch/arm64/include/asm/kprobes.h  |  60 +++++
>>   arch/arm64/include/asm/probes.h   |  50 ++++
>>   arch/arm64/include/asm/ptrace.h   |   3 +-
>>   arch/arm64/kernel/Makefile        |   1 +
>>   arch/arm64/kernel/kprobes-arm64.c |  65 +++++
>>   arch/arm64/kernel/kprobes-arm64.h |  28 ++
>>   arch/arm64/kernel/kprobes.c       | 551 ++++++++++++++++++++++++++++++++++++++
>>   arch/arm64/kernel/kprobes.h       |  30 +++
>>   arch/arm64/kernel/vmlinux.lds.S   |   1 +
>>   10 files changed, 789 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm64/include/asm/kprobes.h
>>   create mode 100644 arch/arm64/include/asm/probes.h
>>   create mode 100644 arch/arm64/kernel/kprobes-arm64.c
>>   create mode 100644 arch/arm64/kernel/kprobes-arm64.h
>>   create mode 100644 arch/arm64/kernel/kprobes.c
>>   create mode 100644 arch/arm64/kernel/kprobes.h
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 12b3fd6..b3f61ba 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -67,6 +67,7 @@ config ARM64
>>          select HAVE_REGS_AND_STACK_ACCESS_API
>>          select HAVE_RCU_TABLE_FREE
>>          select HAVE_SYSCALL_TRACEPOINTS
>> +       select HAVE_KPROBES if !XIP_KERNEL
>>          select IRQ_DOMAIN
>>          select MODULES_USE_ELF_RELA
>>          select NO_BOOTMEM
>> diff --git a/arch/arm64/include/asm/kprobes.h b/arch/arm64/include/asm/kprobes.h
>> new file mode 100644
>> index 0000000..b35d3b9
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/kprobes.h
>> @@ -0,0 +1,60 @@
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
>> +#define MAX_INSN_SIZE                  1
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
>> +       unsigned long ss_status;
>> +       unsigned long match_addr;
>> +};
>> +
>> +/* per-cpu kprobe control block */
>> +struct kprobe_ctlblk {
>> +       unsigned int kprobe_status;
>> +       unsigned long saved_irqflag;
>> +       struct prev_kprobe prev_kprobe;
>> +       struct kprobe_step_ctx ss_ctx;
>> +       struct pt_regs jprobe_saved_regs;
>> +       char jprobes_stack[MAX_STACK_SIZE];
>> +};
>> +
>> +void arch_remove_kprobe(struct kprobe *);
>> +int kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr);
>> +int kprobe_exceptions_notify(struct notifier_block *self,
>> +                            unsigned long val, void *data);
>> +
>> +#endif /* _ARM_KPROBES_H */
>> diff --git a/arch/arm64/include/asm/probes.h b/arch/arm64/include/asm/probes.h
>> new file mode 100644
>> index 0000000..9dba74d
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/probes.h
>> @@ -0,0 +1,50 @@
>> +/*
>> + * arch/arm64/include/asm/probes.h
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
>> +#ifndef _ARM_PROBES_H
>> +#define _ARM_PROBES_H
>> +
>> +struct kprobe;
>> +struct arch_specific_insn;
>> +
>> +typedef u32 kprobe_opcode_t;
>> +typedef unsigned long (kprobes_pstate_check_t)(unsigned long);
>> +typedef unsigned long
>> +(kprobes_condition_check_t)(struct kprobe *p, struct pt_regs *);
>
> Can we make kprobes_condition_check_t as struct kprobe indepedent, so
> that it is usable by uprobe as
> well..
>
>   typedef unsigned long
> (kprobes_condition_check_t)(u32 opcode, struct arch_specific_insn *asi,
>                 struct pt_regs *);
>

We can.  I had intended that to happen with the uprobes patch, but we 
can do that up front.

>> +typedef void
>> +(kprobes_prepare_t)(struct kprobe *, struct arch_specific_insn *);
>
> Similarly,
>
>   typedef void
> (kprobes_prepare_t)(u32 insn, struct arch_specific_insn *);
>

Yes.

>> +typedef void (kprobes_handler_t) (u32 opcode, long addr, struct pt_regs *);
>> +
>> +enum pc_restore_type {
>> +       NO_RESTORE,
>> +       RESTORE_PC,
>> +};
>> +
>
> [...]
>
>> +static bool aarch64_insn_is_steppable(u32 insn)
>> +{
>> +       if (aarch64_get_insn_class(insn) == AARCH64_INSN_CLS_BR_SYS) {
>> +               if (aarch64_insn_is_branch(insn))
>> +                       return false;
>> +
>> +               /* modification of daif creates issues */
>> +               if (aarch64_insn_is_msr_daif(insn))
>> +                       return false;
>> +
>> +               if (aarch64_insn_is_hint(insn))
>> +                       return aarch64_insn_is_nop(insn);
>> +
>> +               return true;
>> +       }
>> +
>> +       if (aarch64_insn_uses_literal(insn))
>> +               return false;
>> +
>> +       if (aarch64_insn_is_exclusive(insn))
>> +               return false;
>> +
>> +       return true;
>
> Default true return may not be a good idea until we are sure that we
> are returning false for all possible
> simulation and rejection cases. In my opinion, its better to return
> true only for steppable and false for
> all remaining.
>

I struggled a little with this when I did it but I decided if the 
question was:  "should we have to recognize every instruction before 
deciding it was single-steppable or should we only recognize 
instructions that are *not* single-steppable", maybe it was OK to do the 
latter while recognizing extensions to the instruction set *could* end 
up (temporarly) allowing us to try and fail (badly) at single-stepping 
any problematic new instructions.  Certainly opinions could differ.  If 
the consensus is that we can't allow this to ever happen (because old 
kprobe code is running on new hardware) then I think the only choice is 
to return to parsing binary tables.  Hopefully I could still find a way 
to leverage insn.c in that case.

>> +}
>
> [...]
>
>> +#ifndef _ARM_KERNEL_KPROBES_H
>> +#define _ARM_KERNEL_KPROBES_H
>> +
>> +/* BRK opcodes with ESR encoding  */
>> +#define BRK64_ESR_MASK         0xFFFF
>> +#define BRK64_ESR_KPROBES      0x0004
>> +#define BRK64_OPCODE_KPROBES   0xD4200080      /* "brk 0x4" */
>
> As will deacon suggested, these can be moved to debug-monitor.h and
> then uprobe can also add
> its defines there only.
>

Not seeing an earlier email about this that I've been copied on, but it 
makes sense.

>> +#define ARCH64_NOP_OPCODE      0xD503201F
>
> It is not being used, so can be removed.
>

A leftover from the previous patchset.  I'll remove it, assuming it 
doesn't become needed again in v5.

> ~Pratyush
>

-dl

