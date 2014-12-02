Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaLBSi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:38:26 -0500
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:33961 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906AbaLBSiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:38:24 -0500
Message-ID: <1417545498.2430.10.camel@linaro.org>
Subject: Re: [PATCH v11 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux@arm.linux.org.uk,
        lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 02 Dec 2014 18:38:18 +0000
In-Reply-To: <1417423751-47872-1-git-send-email-wangnan0@huawei.com>
References: <1417423513-47161-1-git-send-email-wangnan0@huawei.com>
	 <1417423751-47872-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 16:49 +0800, Wang Nan wrote:
> This patch introduce kprobeopt for ARM 32.
> 
> Limitations:
>  - Currently only kernel compiled with ARM ISA is supported.
> 
>  - Offset between probe point and optinsn slot must not larger than
>    32MiB. Masami Hiramatsu suggests replacing 2 words, it will make
>    things complex. Futher patch can make such optimization.
> 
> Kprobe opt on ARM is relatively simpler than kprobe opt on x86 because
> ARM instruction is always 4 bytes aligned and 4 bytes long. This patch
> replace probed instruction by a 'b', branch to trampoline code and then
> calls optimized_callback(). optimized_callback() calls opt_pre_handler()
> to execute kprobe handler. It also emulate/simulate replaced instruction.
> 
> When unregistering kprobe, the deferred manner of unoptimizer may leave
> branch instruction before optimizer is called. Different from x86_64,
> which only copy the probed insn after optprobe_template_end and
> reexecute them, this patch call singlestep to emulate/simulate the insn
> directly. Futher patch can optimize this behavior.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Jon Medhurst (Tixy) <tixy@linaro.org>
> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Cc: Will Deacon <will.deacon@arm.com>
> 
> ---
> 
[...]

> v10 -> v11:
>   - Move to arch/arm/probes/, insn.h is moved to arch/arm/include/asm.
>   - Code cleanup.
>   - Bugfix based on Tixy's test result:
>     - Trampoline deal with ARM -> Thumb transision instructions and
>       AEABI stack alignment requirement correctly.
>     - Trampoline code buffer should start at 4 byte aligned address.
>       We enforces it in this series by using macro to wrap 'code' var.

I'm wondering if this alignment is needed. I'm not familiar with the
Linux memory code but following it through...

- kernel/kprobes.c allocates memory for the instruction slots using
module_alloc()

- module_alloc calls __vmalloc_node_range and passes in an alignment of
1 byte however...

- __vmalloc_node_range has the comment "Allocate enough pages to cover
@size from the page level allocator". And it rounds size up to one page
and calls  __get_vm_area_node which also makes sure the size is page
aligned and also allocates a guard page afterwards.

So it looks to me as though allocated memory would always be page
aligned.

Another reason why I think this must be true is that module_alloc seems
to be used to allocate memory for loading modules to (see move_module in
kernel/module.c) and that code doesn't seem to align things.

Though, as I already said, I'm not familiar with this code so could well
have missed something. And the thing that is giving me most worries is
that all the vmalloc code takes an alignment value in bytes.

Anyway, I'll comment on this patch on the assumption that alignment is
needed...

[...]

> diff --git a/arch/arm/probes/kprobes-opt-arm.c b/arch/arm/probes/kprobes-opt-arm.c
> new file mode 100644
> index 0000000..cc0949c
> --- /dev/null
> +++ b/arch/arm/probes/kprobes-opt-arm.c
> @@ -0,0 +1,343 @@
> +/*
> + *  Kernel Probes Jump Optimization (Optprobes)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright (C) IBM Corporation, 2002, 2004
> + * Copyright (C) Hitachi Ltd., 2012
> + * Copyright (C) Huawei Inc., 2014
> + */
> +
> +#include <linux/kprobes.h>
> +#include <linux/jump_label.h>
> +#include <asm/kprobes.h>
> +#include <asm/cacheflush.h>
> +/* for arm_gen_branch */
> +#include <asm/insn.h>
> +/* for patch_text */
> +#include <asm/patch.h>
> +
> +/*
> + * NOTE: the first sub and add instruction will be modified according
> + * to the stack cost of the instruction.
> + */
> +asm (
> +			".global optprobe_template_entry\n"
> +			"optprobe_template_entry:\n"
> +			".global optprobe_template_sub_sp\n"
> +			"optprobe_template_sub_sp:"
> +			"	sub	sp, sp, #0xff\n"
> +			"	stmia	sp, {r0 - r14} \n"
> +			".global optprobe_template_add_sp\n"
> +			"optprobe_template_add_sp:"
> +			"	add	r3, sp, #0xff\n"
> +			"	str	r3, [sp, #52]\n"
> +			"	mrs	r4, cpsr\n"
> +			"	str	r4, [sp, #64]\n"
> +			"	mov	r1, sp\n"
> +			"	ldr	r0, 1f\n"
> +			"	ldr	r2, 2f\n"
> +
> +			/*
> +			 * AEABI require a 8-bytes alignment stack. If
> +			 * SP % 8 == 4, we alloc another 4 bytes here.
> +			 */
> +			"	tst	sp, #4\n"
> +			"	subne	sp, #4\n"
> +			"	blx	r2\n"
> +
> +			/*
> +			 * Here is a trick: the called handler should
> +			 * return its second param by r0, which is
> +			 * happens to be SP before the above AEABI
> +			 * adjustment. Therefore, we don't need to save
> +			 * and check whether we have done the above
> +			 * adjustment. See optimized_callback().
> +			 */
> +			"	mov	sp, r0\n"

I think this trick is a bit too tricky :-) and might cause unnecessary
problems for someone in the future. How about replacing the above 4
instruction with these 4 instead...

			"	and	r4, sp, #4\n"
			"	sub	sp, sp, r4\n"
			"	blx	r2\n"
			"	add	sp, sp, r4\n"

and that actually makes things slightly faster as optimized_callback no
longer needs to return a value.


> +			"	ldr	r1, [sp, #64]\n"
> +			"	tst	r1, #"__stringify(PSR_T_BIT)"\n"
> +			"	ldrne	r2, [sp, #60]\n"
> +			"	orrne	r2, #1\n"
> +			"	strne	r2, [sp, #60] @ set bit0 of PC for thumb\n"
> +			"	msr	cpsr_cxsf, r1\n"
> +			"	ldmia	sp, {r0 - r15}\n"
> +			".global optprobe_template_val\n"
> +			"optprobe_template_val:\n"
> +			"1:	.long 0\n"
> +			".global optprobe_template_call\n"
> +			"optprobe_template_call:\n"
> +			"2:	.long 0\n"
> +			".global optprobe_template_end\n"
> +			"optprobe_template_end:\n");
> +

[...]

> +int arch_prepare_optimized_kprobe(struct optimized_kprobe *op, struct kprobe *orig)
> +{
> +	kprobe_opcode_t *code_unaligned;

kprobe_opcode_t is a u32 and the ABI and compiler expect this to be
aligned, so best use a void * instead.

> +	unsigned long rel_chk;
> +	unsigned long val;
> +	unsigned long stack_protect = sizeof(struct pt_regs);
> +
> +	if (!can_optimize(orig))
> +		return -EILSEQ;
> +
> +	/*
> +	 * 'code' must be 4-bytes aligned on arm, so we can use
> +	 * 'code[x] = y' without triggering alignment exception.
> +	 * Unfortunately get_optinsn_slot() uses module_alloc and
> +	 * doesn't ensure any alignment.
> +	 */
> +	code_unaligned = get_optinsn_slot();
> +	if (!code_unaligned)
> +		return -ENOMEM;
> +
> +#define code	((kprobe_opcode_t *)(ALIGN((unsigned long)code_unaligned, 4)))

Using a macro like this doesn't seem quite right to me, why not use a
proper C variable called 'code' set to this value.


> +
> +	/*
> +	 * Verify if the address gap is in 32MiB range, because this uses
> +	 * a relative jump.
> +	 *
> +	 * kprobe opt use a 'b' instruction to branch to optinsn.insn.
> +	 * According to ARM manual, branch instruction is:
> +	 *
> +	 *   31  28 27           24 23             0
> +	 *  +------+---+---+---+---+----------------+
> +	 *  | cond | 1 | 0 | 1 | 0 |      imm24     |
> +	 *  +------+---+---+---+---+----------------+
> +	 *
> +	 * imm24 is a signed 24 bits integer. The real branch offset is computed
> +	 * by: imm32 = SignExtend(imm24:'00', 32);
> +	 *
> +	 * So the maximum forward branch should be:
> +	 *   (0x007fffff << 2) = 0x01fffffc =  0x1fffffc
> +	 * The maximum backword branch should be:
> +	 *   (0xff800000 << 2) = 0xfe000000 = -0x2000000
> +	 *
> +	 * We can simply check (rel & 0xfe000003):
> +	 *  if rel is positive, (rel & 0xfe000000) shoule be 0
> +	 *  if rel is negitive, (rel & 0xfe000000) should be 0xfe000000
> +	 *  the last '3' is used for alignment checking.
> +	 */
> +	rel_chk = (unsigned long)((long)code -
> +			(long)orig->addr + 8) & 0xfe000003;
> +
> +	if ((rel_chk != 0) && (rel_chk != 0xfe000000)) {
> +		/*
> +		 * Different from x86, we free code buf directly instead of
> +		 * calling __arch_remove_optimized_kprobe() because
> +		 * we have not fill any field in op.
> +		 */
> +		free_optinsn_slot(code, 0);
> +		return -ERANGE;
> +	}
> +
> +	/* Copy arch-dep-instance from template. */
> +	memcpy(code, &optprobe_template_entry,
> +			TMPL_END_IDX * sizeof(kprobe_opcode_t));
> +
> +	/* Adjust buffer according to instruction. */
> +	BUG_ON(orig->ainsn.stack_space < 0);
> +
> +	/*
> +	 * Add more 4 byte for potential AEABI requirement. If probing is triggered
> +	 * when SP % 8 == 4, we sub SP by another 4 bytes.
> +	 */
> +	stack_protect += orig->ainsn.stack_space + 4;
> +
> +	/* Should have been filtered by can_optimize(). */
> +	BUG_ON(stack_protect > 255);
> +
> +	/* Create a 'sub sp, sp, #<stack_protect>' */
> +	code[TMPL_SUB_SP] = __opcode_to_mem_arm(0xe24dd000 | stack_protect);
> +	/* Create a 'add r3, sp, #<stack_protect>' */
> +	code[TMPL_ADD_SP] = __opcode_to_mem_arm(0xe28d3000 | stack_protect);
> +
> +	/* Set probe information */
> +	val = (unsigned long)op;
> +	code[TMPL_VAL_IDX] = val;
> +
> +	/* Set probe function call */
> +	val = (unsigned long)optimized_callback;
> +	code[TMPL_CALL_IDX] = val;
> +
> +	flush_icache_range((unsigned long)code,
> +			   (unsigned long)(&code[TMPL_END_IDX]));
> +
> +	/*
> +	 * Set op->optinsn.insn means prepared.
> +	 * NOTE: what we saved here is potentially unaligned.
> +	 */
> +	op->optinsn.insn = code_unaligned;
> +	return 0;
> +}
> +
> +void arch_optimize_kprobes(struct list_head *oplist)
> +{
> +	struct optimized_kprobe *op, *tmp;
> +
> +	list_for_each_entry_safe(op, tmp, oplist, list) {
> +		unsigned long insn;
> +		WARN_ON(kprobe_disabled(&op->kp));
> +
> +		/*
> +		 * Backup instructions which will be replaced
> +		 * by jump address
> +		 */
> +		memcpy(op->optinsn.copied_insn, op->kp.addr,
> +				RELATIVEJUMP_SIZE);
> +
> +		insn = arm_gen_branch((unsigned long)op->kp.addr,
> +				(unsigned long)op->optinsn.insn);
> +		BUG_ON(insn == 0);
> +
> +		/*
> +		 * Make it a conditional branch if replaced insn
> +		 * is consitional
> +		 */
> +		insn = (__mem_to_opcode_arm(
> +			  op->optinsn.copied_insn[0]) & 0xf0000000) |
> +			(insn & 0x0fffffff);
> +
> +		patch_text(op->kp.addr, insn);
> +
> +		list_del_init(&op->list);
> +	}
> +}
> +
> +void arch_unoptimize_kprobe(struct optimized_kprobe *op)
> +{
> +	arch_arm_kprobe(&op->kp);
> +}
> +
> +/*
> + * Recover original instructions and breakpoints from relative jumps.
> + * Caller must call with locking kprobe_mutex.
> + */
> +void arch_unoptimize_kprobes(struct list_head *oplist,
> +			    struct list_head *done_list)
> +{
> +	struct optimized_kprobe *op, *tmp;
> +
> +	list_for_each_entry_safe(op, tmp, oplist, list) {
> +		arch_unoptimize_kprobe(op);
> +		list_move(&op->list, done_list);
> +	}
> +}
> +
> +int arch_within_optimized_kprobe(struct optimized_kprobe *op,
> +				unsigned long addr)
> +{
> +	return ((unsigned long)op->kp.addr <= addr &&
> +		(unsigned long)op->kp.addr + RELATIVEJUMP_SIZE > addr);
> +}
> +
> +void arch_remove_optimized_kprobe(struct optimized_kprobe *op)
> +{
> +	__arch_remove_optimized_kprobe(op, 1);
> +}
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 9f28aa7..010cbc2 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -120,6 +120,10 @@ enum kprobe_slot_state {
>  	SLOT_USED = 2,
>  };
>  
> +/*
> + * FIXME: here we should ensure opcode alignment for some platform like
> + * ARM. Currently module_alloc is only 1 byte alignment.
> + */
>  static void *alloc_insn_page(void)
>  {
>  	return module_alloc(PAGE_SIZE);


