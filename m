Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaLABa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 20:30:29 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:3565 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbaLABa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 20:30:26 -0500
Message-ID: <547BC490.9020806@huawei.com>
Date: Mon, 1 Dec 2014 09:29:52 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <linux@arm.linux.org.uk>,
        <will.deacon@arm.com>, <taras.kondratiuk@linaro.org>,
        <ben.dooks@codethink.co.uk>, <cl@linux.com>, <rabin@rab.in>,
        <davem@davemloft.net>, <lizefan@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 2/2] ARM: kprobes: enable OPTPROBES for ARM 32
References: <1416551751-50846-1-git-send-email-wangnan0@huawei.com>	 <1416551751-50846-3-git-send-email-wangnan0@huawei.com> <1417099007.2041.6.camel@linaro.org>
In-Reply-To: <1417099007.2041.6.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A02020A.547BC4AF.0095,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 5eab2da87ec146b6f25dc31e7f8256c7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  
>> +/* optinsn template addresses */
>> +extern __visible kprobe_opcode_t optprobe_template_entry;
> 
> Why do we need the __visible annotation? I'm not suggesting that we
> don't, just curious what it achieves. (Code compiles and links OK for me
> without it).
> 

These '__visible' are inherited from x86 code. Commit 04bb591 adds them explicitly.
It is part from https://lkml.org/lkml/2013/8/5/595 , which is a patch series
to make all C functions which may be called from asm code LTO safety. Without
such __visible directive, LTO may do some asm-unfriendly optimization, like
triming them all because gcc think they are not used.

>> +extern __visible kprobe_opcode_t optprobe_template_val;
>> +extern __visible kprobe_opcode_t optprobe_template_call;
>> +extern __visible kprobe_opcode_t optprobe_template_end;
>> +
>> +#define MAX_OPTIMIZED_LENGTH	(4)
> 
> The parenthesis around the 4 are not needed. Same for RELATIVEJUMP_SIZE
> below.
> 

This is my old habit... I'll fix it in next version.

> 
>> +#define MAX_OPTINSN_SIZE				\
>> +	(((unsigned long)&optprobe_template_end -	\
>> +	  (unsigned long)&optprobe_template_entry))
>> +#define RELATIVEJUMP_SIZE	(4)
>> +

Also.

>> +struct arch_optimized_insn {
>> +	/*
>> +	 * copy of the original instructions.
>> +	 * Different from x86, ARM kprobe_opcode_t is u32.
>> +	 */
>> +#define MAX_COPIED_INSN	((RELATIVEJUMP_SIZE) / sizeof(kprobe_opcode_t))
> 
> Whilst the above gives the correct value, I think for correctness it
> should be expressed as
> 
> #define MAX_COPIED_INSN	(DIV_ROUND_UP(RELATIVEJUMP_SIZE, sizeof(kprobe_opcode_t))
> 

Agree.

> 
>> +	kprobe_opcode_t copied_insn[MAX_COPIED_INSN];
>> +	/* detour code buffer */
>> +	kprobe_opcode_t *insn;
>> +	/*
>> +	 *  we always copies one instruction on arm32,
>> +	 *  size always be 4, so no size field.
>> +	 */
> 
> Not sure we need the above comment, it only makes sense if the person
> reading it knows what the x86 implementation looks like.
> 
>> +};
>>  
>>  #endif /* _ARM_KPROBES_H */
>> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
>> index 45aed4b..8a16fcf 100644
>> --- a/arch/arm/kernel/Makefile
>> +++ b/arch/arm/kernel/Makefile
>> @@ -52,11 +52,12 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o insn.o
>>  obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o insn.o patch.o
>>  obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
>>  obj-$(CONFIG_UPROBES)		+= probes.o probes-arm.o uprobes.o uprobes-arm.o
>> -obj-$(CONFIG_KPROBES)		+= probes.o kprobes.o kprobes-common.o patch.o probes-checkers-common.o
>> +obj-$(CONFIG_KPROBES)		+= probes.o kprobes.o kprobes-common.o patch.o probes-checkers-common.o insn.o
>>  ifdef CONFIG_THUMB2_KERNEL
>>  obj-$(CONFIG_KPROBES)		+= kprobes-thumb.o probes-thumb.o probes-checkers-thumb.o
>>  else
>>  obj-$(CONFIG_KPROBES)		+= kprobes-arm.o probes-arm.o probes-checkers-arm.o
>> +obj-$(CONFIG_OPTPROBES)		+= kprobes-opt-arm.o
>>  endif
>>  obj-$(CONFIG_ARM_KPROBES_TEST)	+= test-kprobes.o
>>  test-kprobes-objs		:= kprobes-test.o
>> diff --git a/arch/arm/kernel/kprobes-opt-arm.c b/arch/arm/kernel/kprobes-opt-arm.c
>> new file mode 100644
>> index 0000000..f9d213c
>> --- /dev/null
>> +++ b/arch/arm/kernel/kprobes-opt-arm.c
>> @@ -0,0 +1,290 @@
>> +/*
>> + *  Kernel Probes Jump Optimization (Optprobes)
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
>> + *
>> + * Copyright (C) IBM Corporation, 2002, 2004
>> + * Copyright (C) Hitachi Ltd., 2012
>> + * Copyright (C) Huawei Inc., 2014
>> + */
>> +
>> +#include <linux/kprobes.h>
>> +#include <linux/jump_label.h>
>> +#include <asm/kprobes.h>
>> +#include <asm/cacheflush.h>
>> +/* for arm_gen_branch */
>> +#include "insn.h"
>> +/* for patch_text */
>> +#include "patch.h"
>> +
>> +/*
>> + * NOTE: the first sub and add instruction will be modified according
>> + * to the stack cost of the instruction.
>> + */
>> +asm (
>> +			".global optprobe_template_entry\n"
>> +			"optprobe_template_entry:\n"
>> +			"	sub	sp, sp, #0xff\n"
>> +			"	stmia	sp, {r0 - r14} \n"
> 
> AEABI requires that the stack be aligned to a multiple of 8 bytes at
> function call boundaries, however kprobes can be inserted in the middle
> of functions where such alignment isn't guaranteed to be maintained.
> Therefore, this trampoline code needs to make adjust SP if necessary to
> ensure that alignment. See svc_entry in arch/arm/kernel/entry-armv.S for
> an example of how this is done; though note, we can't use that exact
> method because we can't change the flags value without saving them
> first. (Exception handlers don't have to worry about that because the
> flags are saved in spsr).
> 

So I think we have to push a flag into stack for it.

> 
>> +			"	add	r3, sp, #0xff\n"
>> +			"	str	r3, [sp, #52]\n"
>> +			"	mrs	r4, cpsr\n"
>> +			"	str	r4, [sp, #64]\n"
>> +			"	mov	r1, sp\n"
>> +			"	ldr	r0, 1f\n"
>> +			"	ldr	r2, 2f\n"
>> +			"	blx	r2\n"
>> +			"	ldr	r1, [sp, #64]\n"
>> +			"	msr	cpsr_fs, r1\n"
> 
> 
> The above instruction should be "msr cpsr_cxsf, r1" so that other flags
> in CPSR (like GE bits) are also restored. And as even that won't switch
> to Thumb mode (as required when simulating the BLX instruction) we also
> need something like the following before that "msr cpsr_cxsf, r1"
> 
> 			"	tst	r1, #"__stringify(PSR_T_BIT)"\n"
> 			"	ldrne	r2, [sp, #60]\n"
> 			"	orrne	r2, #1\n"
> 			"	strne	r2, [sp, #60]  @ set bit0 of PC for thumb\n"
> 

I didn't think about ARM -> Thumb switching before. Thank you for your fix!

> 
>> +			"	ldmia	sp, {r0 - r15}\n"
>> +			".global optprobe_template_val\n"
>> +			"optprobe_template_val:\n"
>> +			"1:	.long 0\n"
>> +			".global optprobe_template_call\n"
>> +			"optprobe_template_call:\n"
>> +			"2:	.long 0\n"
>> +			".global optprobe_template_end\n"
>> +			"optprobe_template_end:\n");
>> +
>> +#define TMPL_VAL_IDX \
>> +	((long)&optprobe_template_val - (long)&optprobe_template_entry)
>> +#define TMPL_CALL_IDX \
>> +	((long)&optprobe_template_call - (long)&optprobe_template_entry)
>> +#define TMPL_END_IDX \
>> +	((long)&optprobe_template_end - (long)&optprobe_template_entry)
>> +
>> +/*
>> + * ARM can always optimize an instruction when using ARM ISA, except
>> + * instructions like 'str r0, [sp, r1]' which store to stack and unable
>> + * to determine stack space consumption statically.
>> + */
>> +int arch_prepared_optinsn(struct arch_optimized_insn *optinsn)
>> +{
>> +	return optinsn->insn != NULL;
>> +}
>> +
>> +/*
>> + * In ARM ISA, kprobe opt always replace one instruction (4 bytes
>> + * aligned and 4 bytes long). It is impossiable to encounter another
> 
> There's a typo above, s/impossiable/impossible/
> 
> 
>> + * kprobe in the address range. So always return 0.
>> + */
>> +int arch_check_optimized_kprobe(struct optimized_kprobe *op)
>> +{
>> +	return 0;
>> +}
>> +
>> +/* Caller must ensure addr & 3 == 0 */
>> +static int can_optimize(struct kprobe *kp)
>> +{
>> +	if (kp->ainsn.stack_space < 0)
>> +		return 0;
>> +	/*
>> +	 * 255 is the biggest imm can be used in 'sub r0, r0, #<imm>'.
>> +	 * Number larger than 255 needs special encoding.
>> +	 */
>> +	if (kp->ainsn.stack_space > 255 - sizeof(struct pt_regs))
>> +		return 0;
>> +	return 1;
>> +}
>> +
>> +/* Free optimized instruction slot */
>> +static void
>> +__arch_remove_optimized_kprobe(struct optimized_kprobe *op, int dirty)
>> +{
>> +	if (op->optinsn.insn) {
>> +		free_optinsn_slot(op->optinsn.insn, dirty);
>> +		op->optinsn.insn = NULL;
>> +	}
>> +}
>> +
>> +extern void kprobe_handler(struct pt_regs *regs);
>> +
>> +static void
>> +optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
>> +{
>> +	unsigned long flags;
>> +	struct kprobe *p = &op->kp;
>> +	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
>> +
>> +	/* Save skipped registers */
>> +	regs->ARM_pc = (unsigned long)op->kp.addr;
>> +	regs->ARM_ORIG_r0 = ~0UL;
>> +
>> +	local_irq_save(flags);
>> +
>> +	if (kprobe_running()) {
>> +		kprobes_inc_nmissed_count(&op->kp);
>> +	} else {
>> +		__this_cpu_write(current_kprobe, &op->kp);
>> +		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
>> +		opt_pre_handler(&op->kp, regs);
>> +		__this_cpu_write(current_kprobe, NULL);
>> +	}
>> +
>> +	/* In each case, we must singlestep the replaced instruction. */
>> +	op->kp.ainsn.insn_singlestep(p->opcode, &p->ainsn, regs);
>> +
>> +	local_irq_restore(flags);
>> +}
>> +
>> +int arch_prepare_optimized_kprobe(struct optimized_kprobe *op, struct kprobe *orig)
>> +{
>> +	u8 *buf;
>> +	unsigned long *code;
>> +	unsigned long rel_chk;
>> +	unsigned long val;
>> +	unsigned long stack_protect = sizeof(struct pt_regs);
>> +
>> +	if (!can_optimize(orig))
>> +		return -EILSEQ;
>> +
>> +	buf = (u8 *)get_optinsn_slot();
>> +	if (!buf)
>> +		return -ENOMEM;
>> +
>> +	/*
>> +	 * Verify if the address gap is in 32MiB range, because this uses
>> +	 * a relative jump.
>> +	 *
>> +	 * kprobe opt use a 'b' instruction to branch to optinsn.insn.
>> +	 * According to ARM manual, branch instruction is:
>> +	 *
>> +	 *   31  28 27           24 23             0
>> +	 *  +------+---+---+---+---+----------------+
>> +	 *  | cond | 1 | 0 | 1 | 0 |      imm24     |
>> +	 *  +------+---+---+---+---+----------------+
>> +	 *
>> +	 * imm24 is a signed 24 bits integer. The real branch offset is computed
>> +	 * by: imm32 = SignExtend(imm24:'00', 32);
>> +	 *
>> +	 * So the maximum forward branch should be:
>> +	 *   (0x007fffff << 2) = 0x01fffffc =  0x1fffffc
>> +	 * The maximum backword branch should be:
>> +	 *   (0xff800000 << 2) = 0xfe000000 = -0x2000000
>> +	 *
>> +	 * We can simply check (rel & 0xfe000003):
>> +	 *  if rel is positive, (rel & 0xfe000000) shoule be 0
>> +	 *  if rel is negitive, (rel & 0xfe000000) should be 0xfe000000
>> +	 *  the last '3' is used for alignment checking.
>> +	 */
>> +	rel_chk = (unsigned long)((long)buf -
>> +			(long)orig->addr + 8) & 0xfe000003;
>> +
>> +	if ((rel_chk != 0) && (rel_chk != 0xfe000000)) {
>> +		/*
>> +		 * Different from x86, we free buf directly instead of
>> +		 * calling __arch_remove_optimized_kprobe() because
>> +		 * we have not fill any field in op.
>> +		 */
>> +		free_optinsn_slot((kprobe_opcode_t *)buf, 0);
>> +		return -ERANGE;
>> +	}
>> +
>> +	/* Copy arch-dep-instance from template. */
>> +	memcpy(buf, &optprobe_template_entry, TMPL_END_IDX);
>> +

[..]

>> +	/* Adjust buffer according to instruction. */
>> +	BUG_ON(orig->ainsn.stack_space < 0);
>> +	stack_protect += orig->ainsn.stack_space;
>> +
>> +	/* Should have been filtered by can_optimize(). */
>> +	BUG_ON(stack_protect > 255);
>> +
>> +	/* Create a 'sub sp, sp, #<stack_protect>' */
>> +	code = (unsigned long *)(buf);
>> +	code[0] = __opcode_to_mem_arm(0xe24dd000 | stack_protect);
>> +	/* Create a 'add r3, sp, #<stack_protect>' */
>> +	code[2] = __opcode_to_mem_arm(0xe28d3000 | stack_protect);
> 
> Rather than use code[0] and code[2] it's best to use index values
> calculated from labels in the template code, like we do with
> TMPL_VAL_IDX and TMPL_CALL_IDX...
> 
> 
>> +
>> +	/* Set probe information */
>> +	val = (unsigned long)op;
>> +	memcpy(buf + TMPL_VAL_IDX, &val, sizeof(val));
> 
> As this, and the other values in the template that we modify are 32-bit
> values, and must be aligned to 32-bit addresses, we could avoid using
> memcpy by treating the template as an array of longs. E.g. change
> TMPL_VAL_IDX to be
> 
> #define TMPL_VAL_IDX \
> 	((unsigned long *)&optprobe_template_val - (unsigned long *)&optprobe_template_entry)
> 
> then instead of memcpy we could do
> 
> 	code[TMPL_VAL_IDX] = (unsigned long)op;
> 

I find that the insn page allocation function 'alloc_insn_page' uses 'module_alloc(PAGE_SIZE);'
to alloc insn slots, which is unfortunately only ensures 1 byte aligned.
I'd like to deal with it in my next version.

Due to this modification, the above

  memcpy(buf, &optprobe_template_entry, TMPL_END_IDX);

sould also change to

  memcpy(buf, &optprobe_template_entry,
                 TMPL_END_IDX * sizeof(kprobe_opcode_t));


Also, if we ensure 'buf' is 4 bytes aligned, we can use 'kprobe_opcode_t *code' to replace 'u8 *buf'
totally to clean our code.

> 
>> +
>> +	/* Set probe function call */
>> +	val = (unsigned long)optimized_callback;
>> +	memcpy(buf + TMPL_CALL_IDX, &val, sizeof(val));
>> +
>> +	flush_icache_range((unsigned long)buf,
>> +			   (unsigned long)buf + TMPL_END_IDX);
>> +
>> +	/* Set op->optinsn.insn means prepared */
>> +	op->optinsn.insn = (kprobe_opcode_t *)buf;
>> +	return 0;
>> +}
>> +
>> +void arch_optimize_kprobes(struct list_head *oplist)
>> +{
>> +	struct optimized_kprobe *op, *tmp;
>> +
>> +	list_for_each_entry_safe(op, tmp, oplist, list) {
>> +		unsigned long insn;
>> +		WARN_ON(kprobe_disabled(&op->kp));
>> +
>> +		/*
>> +		 * Backup instructions which will be replaced
>> +		 * by jump address
>> +		 */
>> +		memcpy(op->optinsn.copied_insn, op->kp.addr,
>> +				RELATIVEJUMP_SIZE);
>> +
>> +		insn = arm_gen_branch((unsigned long)op->kp.addr,
>> +				(unsigned long)op->optinsn.insn);
>> +		BUG_ON(insn == 0);
>> +
>> +		/*
>> +		 * Make it a conditional branch if replaced insn
>> +		 * is consitional
> 
> There's a typo above, s/consitional/conditional/
> 
> [Rest of patch trimmed]
> 


