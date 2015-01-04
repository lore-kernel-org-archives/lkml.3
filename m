Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbbADNuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 08:50:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbbADNum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 08:50:42 -0500
Message-ID: <54A944ED.5010408@redhat.com>
Date: Sun, 04 Jan 2015 19:19:33 +0530
From: Pratyush Anand <panand@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        tixy@linaro.org, ananth@in.ibm.com, sandeepa.prabhu@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com, wcohen@redhat.com
Subject: Re: [RFC 8/8] ARM64: Add uprobe support
References: <cover.1420038188.git.panand@redhat.com> <0694af6935f9c6873ef8d25ad51630a40a74a116.1420038188.git.panand@redhat.com> <20150102172333.GA6264@redhat.com>
In-Reply-To: <20150102172333.GA6264@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Friday 02 January 2015 10:53 PM, Oleg Nesterov wrote:
> Hi Pratyush,
>
> I'll try to actually read this patch (and the whole series) later, just
> a couple of quick questions for now.
>
> On 12/31, Pratyush Anand wrote:
>>
>> --- a/arch/arm64/include/asm/ptrace.h
>> +++ b/arch/arm64/include/asm/ptrace.h
>> @@ -205,6 +205,7 @@ static inline int valid_user_regs(struct user_pt_regs *regs)
>>
>>   #define instruction_pointer(regs)	((regs)->pc)
>>   #define stack_pointer(regs)		((regs)->sp)
>> +#define procedure_link_pointer(regs)	((regs)->regs[30])
>
> perhaps it makes sense to change (at least) arch_prepare_kretprobe() to use
> the new helper? OK, we can do this later.

Yes.

>
>> +/* Single step context for uprobe */
>> +struct uprobe_step_ctx {
>> +	struct list_head node;
>> +	unsigned long match_addr;
>> +};
>
> I don't understand this... please see below.
>
>> +struct arch_uprobe_task {
>> +	unsigned long saved_fault_code;
>> +	u64 saved_user_pc;
>> +	struct uprobe_step_ctx ss_ctx;
>> +};
>
> saved_user_pc looks unneeded, you can rely on uprobe_task->vaddr ?

Probably yes. Will change.

>
>> +++ b/arch/arm64/kernel/uprobes.c
>> @@ -0,0 +1,255 @@
>> +/*
>> + * Copyright (C) 2014 Pratyush Anand <panand@redhat.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +#include <linux/highmem.h>
>> +#include <linux/ptrace.h>
>> +#include <linux/uprobes.h>
>> +#include <asm/debug-monitors.h>
>> +#include <asm/probes.h>
>> +
>> +#include "probes-arm64.h"
>> +
>> +#define UPROBE_INV_FAULT_CODE	UINT_MAX
>> +
>> +static LIST_HEAD(step_ctx);
>> +static DEFINE_RWLOCK(step_ctx_lock);
>> +
>> +static void add_ss_context(struct uprobe_task *utask)
>> +{
>> +	struct uprobe_step_ctx *ss_ctx = &utask->autask.ss_ctx;
>> +
>> +	ss_ctx->match_addr = utask->xol_vaddr;
>> +	write_lock(&step_ctx_lock);
>> +	list_add(&ss_ctx->node, &step_ctx);
>> +	write_unlock(&step_ctx_lock);
>> +}
>> +
>> +static struct uprobe_step_ctx *find_ss_context(unsigned long vaddr)
>> +{
>> +	struct uprobe_step_ctx *ss_ctx;
>> +
>> +	read_lock(&step_ctx_lock);
>> +	list_for_each_entry(ss_ctx, &step_ctx, node)	{
>> +		if (ss_ctx->match_addr == vaddr) {
>> +			read_unlock(&step_ctx_lock);
>> +			return ss_ctx;
>> +		}
>> +	}
>> +	read_unlock(&step_ctx_lock);
>> +
>> +	return NULL;
>> +}
>
> This looks very wrong to me, but perhaps because I do not understand
> why do we need these *_ss_context() helpers.
>
>> +static void del_ss_context(struct uprobe_task *utask)
>> +{
>> +	struct uprobe_step_ctx *ss_ctx = find_ss_context(utask->xol_vaddr);
>> +
>> +	if (ss_ctx) {
>> +		write_lock(&step_ctx_lock);
>> +		list_del(&ss_ctx->node);
>> +		write_unlock(&step_ctx_lock);
>> +	} else {
>> +		WARN_ON(1);
>> +	}
>> +}
>
> Don't we need del_ss_context() in arch_uprobe_abort_xol() ? But this is
> minor.

Thanks. Yes, we need del_ss_context() in arch_uprobe_abort_xol().

>
> Why we can trust find_ss_context() ? What if another thread also called
> add_ss_context() with the same (virtual) ->xol_vaddr ?

OK..So xol_vaddr is not unique, then need to look for something else 
which could be unique for each probe.

>
> But the main question is: why do we need add/find_ss_context ?? Please
> explain.
>

See arch/arm64/kernel/debug-monitors.c: call_step_hook

Unlike breakpoint exception, there is no ESR info check for step 
exception. So, it is the responsibility of step handler 
(uprobe_single_step_handler) to make sure that exception was generated 
for it.

>> +int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>> +{
>> +	struct uprobe_task *utask = current->utask;
>> +
>> +	/* saved fault code is restored in post_xol */
>> +	utask->autask.saved_fault_code = current->thread.fault_code;
>> +
>> +	/* An invalid fault code between pre/post xol event */
>> +	current->thread.fault_code = UPROBE_INV_FAULT_CODE;
>> +
>> +	/* Save user pc */
>> +	utask->autask.saved_user_pc = task_pt_regs(current)->user_regs.pc;
>> +
>> +	/* Instruction point to execute ol */
>> +	instruction_pointer_set(regs, utask->xol_vaddr);
>> +
>> +	add_ss_context(utask);
>> +
>> +	user_enable_single_step(current);
>> +
>> +	return 0;
>> +}
>> +
>> +int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>> +{
>> +	struct uprobe_task *utask = current->utask;
>> +
>> +	WARN_ON_ONCE(current->thread.fault_code != UPROBE_INV_FAULT_CODE);
>> +
>> +	/* restore fault code */
>> +	current->thread.fault_code = utask->autask.saved_fault_code;
>> +
>> +	/* restore user pc */
>> +	task_pt_regs(current)->user_regs.pc = utask->autask.saved_user_pc;
>> +
>> +	/* Instruction point to execute next to breakpoint address */
>> +	instruction_pointer_set(regs, utask->vaddr + 4);
>> +
>> +	del_ss_context(utask);
>> +
>> +	user_disable_single_step(current);
>> +
>> +	return 0;
>> +}
>
> task_pt_regs() above looks strange. We we can't use "struct pt_regs *regs"
> passed as an argument?
>
> See also the note about .saved_user_pc above. I think you can use
> utask->vaddr instead.
>
> And why do you need to play with ->user_regs.pc?? instruction_pointer_set()
> after that modifies the same word?
>
> Or it is possible that regs != task_pt_regs(current) ? (to remind, I do not
> know arm ;)
>
> Could you also explain
>
> 	instruction_pointer_set(regs, utask->vaddr + 4);
>
> ?
>

Correct, saved_user_pc is not needed and also no need to play with 
->user_regs.pc. instruction_pointer_set should be sufficient.


> I mean, I do not understand why this is always correct. What if the probed
> insn is "jmp" (I do not know arm64's name for jump) ?
>
> Probably this is correct because in this case arm_probe_decode_insn() should
> return INSN_GOOD_NO_SLOT and this insn will be emulated? If yes, this needs a
> comment, imo.
>

Yes, a branch instruction like b or bl or ret will be simulated.

>> +static int uprobe_breakpoint_handler(struct pt_regs *regs, unsigned int esr)
>> +{
>> +	unsigned long flags;
>> +
>> +	local_irq_save(flags);
>> +	uprobe_pre_sstep_notifier(regs);
>> +	local_irq_restore(flags);
>> +
>> +	return 0;
>> +}
>
> Again, you do not need to disable irqs around uprobe_pre_sstep_notifier().

OK. (Actually took it from arch/arm/kernel/uprobe.c)

>
> And I am not sure I understand the logic... "return 0" actually means
> "return DBG_HOOK_HANDLED", right?

Yes. So better I will put return DBG_HOOK_HANDLED;

>
> I do not understand this register_break_hook() interface and the usage
> of .esr_mask/esr_val. But given that this patch adds BRK64_ESR_UPROBES
> and uses BRK64_OPCODE_UPROBES, I will assume that uprobe_breakpoint_handler()
> will be called if this exception was triggered by UPROBE_SWBP_INSN.

Correct.

>
> In this case, why the unconditional DBG_HOOK_HANDLED is correct? For example,
> what if the application itself or debugger use UPROBE_SWBP_INSN for (self)
> debugging and this task has no uprobes? In this case uprobe_pre_sstep_notifier()
> will do nothing, it won't set TIF_UPROBES and handle_swbp() won't be called.
>
> IOW, shouldn't it do
>
> 	if (user_mode(regs) && uprobe_pre_sstep_notifier(regs))
> 		return DBG_HOOK_HANDLED;
> 	return DBG_HOOK_ERROR;
>
> ?

Thanks for pointing out this bug with the code.
Your point seems pretty valid.

>
>> +static int uprobe_single_step_handler(struct pt_regs *regs, unsigned int esr)
>> +{
>> +	unsigned long flags;
>> +
>> +	if (!find_ss_context(regs->pc - 4))
>> +		return DBG_HOOK_ERROR;
>> +
>> +	local_irq_save(flags);
>> +	uprobe_post_sstep_notifier(regs);
>> +	local_irq_restore(flags);
>> +
>> +	return 0;
>> +}
>
> The same. No need to clear irqs, and please explain why we can't rely
> on user_mode() && uprobe_post_sstep_notifier(), and why do we
> need find_ss_context().
>

I had not looked into uprobe_post_sstep_notifier implementtaion.I think, 
you are right.


Thanks for all these valuable comments.

~Pratyush


>> +void flush_uprobe_xol_access(struct page *page, unsigned long uaddr,
>> +		void *kaddr, unsigned long len)
>> +{
>> +	__flush_ptrace_access(page, uaddr, kaddr, len);
>> +}
>
> I have some concerns... I'll reply to 5/8 which adds __flush_ptrace_access.
>
> Oleg.
>
