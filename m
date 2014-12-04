Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbaLDQV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:21:28 -0500
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:59843 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932161AbaLDQVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:21:25 -0500
Message-ID: <1417710073.2239.10.camel@linaro.org>
Subject: Re: [PATCH v12 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux@arm.linux.org.uk,
        lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 04 Dec 2014 16:21:13 +0000
In-Reply-To: <1417671360-53399-1-git-send-email-wangnan0@huawei.com>
References: <1417671172-52915-1-git-send-email-wangnan0@huawei.com>
	 <1417671360-53399-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-04 at 13:36 +0800, Wang Nan wrote:
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


I have retested this patch and on one of the arm test cases I get an
undefined instruction exception in kprobe_arm_test_cases. When this
happens PC points to the second nop below. 


80028a38:	e320f000 	nop	{0}
80028a3c:	e11000b2 	ldrh	r0, [r0, -r2]
80028a40:	e320f000 	nop	{0}

As all three instructions will have probes on them during testing, and
un-optimised probes are implemented by using an undefined instruction to
act as a breakpoint, my first thought was that we have a race condition
somewhere with adding, removing or optimizing probes. Though a reboot a
retest failed in the same way on the same instruction, so I'm not 100%
convinced about strictly timing related bugs.
 
Meanwhile, I have some review comments of the code below...


>
> v1 -> v2:
>  - Improvement: if replaced instruction is conditional, generate a
>    conditional branch instruction for it;
>  - Introduces RELATIVEJUMP_OPCODES due to ARM kprobe_opcode_t is 4
>    bytes;
>  - Removes size field in struct arch_optimized_insn;
>  - Use arm_gen_branch() to generate branch instruction;
>  - Remove all recover logic: ARM doesn't use tail buffer, no need
>    recover replaced instructions like x86;
>  - Remove incorrect CONFIG_THUMB checking;
>  - can_optimize() always returns true if address is well aligned;
>  - Improve optimized_callback: using opt_pre_handler();
>  - Bugfix: correct range checking code and improve comments;
>  - Fix commit message.
> 
> v2 -> v3:
>  - Rename RELATIVEJUMP_OPCODES to MAX_COPIED_INSNS;
>  - Remove unneeded checking:
>       arch_check_optimized_kprobe(), can_optimize();
>  - Add missing flush_icache_range() in arch_prepare_optimized_kprobe();
>  - Remove unneeded 'return;'.
> 
> v3 -> v4:
>  - Use __mem_to_opcode_arm() to translate copied_insn to ensure it
>    works in big endian kernel;
>  - Replace 'nop' placeholder in trampoline code template with
>    '.long 0' to avoid confusion: reader may regard 'nop' as an
>    instruction, but it is value in fact.
> 
> v4 -> v5:
>  - Don't optimize stack store operations.
>  - Introduce prepared field to arch_optimized_insn to indicate whether
>    it is prepared. Similar to size field with x86. See v1 -> v2.
> 
> v5 -> v6:
>  - Dynamically reserve stack according to instruction.
>  - Rename: kprobes-opt.c -> kprobes-opt-arm.c.
>  - Set op->optinsn.insn after all works are done.
> 
> v6 -> v7:
>   - Using checker to check stack consumption.
> 
> v7 -> v8:
>   - Small code adjustments.
> 
> v8 -> v9:
>   - Utilize original kprobe passed to arch_prepare_optimized_kprobe()
>     to avoid copy ainsn twice.
>   - A bug in arch_prepare_optimized_kprobe() is found and fixed.
> 
> v9 -> v10:
>   - Commit message improvements.
> 
> v10 -> v11:
>   - Move to arch/arm/probes/, insn.h is moved to arch/arm/include/asm.
>   - Code cleanup.
>   - Bugfix based on Tixy's test result:
>     - Trampoline deal with ARM -> Thumb transision instructions and
>       AEABI stack alignment requirement correctly.
>     - Trampoline code buffer should start at 4 byte aligned address.
>       We enforces it in this series by using macro to wrap 'code' var.
> 
> v11 -> v12:
>   - Remove trampoline code stack trick and use r4 to save original
>     stack.
>   - Remove trampoline code buffer alignment trick.
>   - Names of files are changed.
> ---


Looks like you accidentally have the '---' break in the wrong place,
should be before the version changes description.


>  arch/arm/Kconfig                        |   1 +
>  arch/arm/{kernel => include/asm}/insn.h |   0
>  arch/arm/include/asm/kprobes.h          |  34 ++++
>  arch/arm/kernel/Makefile                |   2 +-
>  arch/arm/kernel/ftrace.c                |   3 +-
>  arch/arm/kernel/jump_label.c            |   3 +-
>  arch/arm/probes/kprobes/Makefile        |   1 +
>  arch/arm/probes/kprobes/core.c          |   1 +
>  arch/arm/probes/kprobes/opt-arm.c       | 322 ++++++++++++++++++++++++++++++++
>  9 files changed, 362 insertions(+), 5 deletions(-)
>  rename arch/arm/{kernel => include/asm}/insn.h (100%)
>  create mode 100644 arch/arm/probes/kprobes/opt-arm.c
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 89c4b5c..8281cea 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -59,6 +59,7 @@ config ARM
>  	select HAVE_MEMBLOCK
>  	select HAVE_MOD_ARCH_SPECIFIC if ARM_UNWIND
>  	select HAVE_OPROFILE if (HAVE_PERF_EVENTS)
> +	select HAVE_OPTPROBES if (!THUMB2_KERNEL)
>  	select HAVE_PERF_EVENTS
>  	select HAVE_PERF_REGS
>  	select HAVE_PERF_USER_STACK_DUMP
> diff --git a/arch/arm/kernel/insn.h b/arch/arm/include/asm/insn.h
> similarity index 100%
> rename from arch/arm/kernel/insn.h
> rename to arch/arm/include/asm/insn.h
> diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
> index 56f9ac6..5574008 100644
> --- a/arch/arm/include/asm/kprobes.h
> +++ b/arch/arm/include/asm/kprobes.h
> @@ -50,5 +50,39 @@ int kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr);
>  int kprobe_exceptions_notify(struct notifier_block *self,
>  			     unsigned long val, void *data);
>  
> +/* optinsn template addresses */
> +extern __visible kprobe_opcode_t optprobe_template_entry;
> +extern __visible kprobe_opcode_t optprobe_template_val;
> +extern __visible kprobe_opcode_t optprobe_template_call;
> +extern __visible kprobe_opcode_t optprobe_template_end;
> +extern __visible kprobe_opcode_t optprobe_template_sub_sp;
> +extern __visible kprobe_opcode_t optprobe_template_add_sp;
> +
> +/*
> + * Plus 4 for potential alignment adjustment. See comments
> + * in arch_prepare_optimized_kprobe() in
> + * arch/arm/probes/kprobes-opt-arm.c .
> + */
> +#define MAX_OPTIMIZED_LENGTH	4
> +#define MAX_OPTINSN_SIZE				\
> +	(((unsigned long)&optprobe_template_end -	\
> +	  (unsigned long)&optprobe_template_entry) + 4)

Is this "+ 4" needed now? I think it might be left over from the
previous version where you were aligning code in the slot to a 4 byte
boundary.



> +#define RELATIVEJUMP_SIZE	4
> +
> +struct arch_optimized_insn {
> +	/*
> +	 * copy of the original instructions.
> +	 * Different from x86, ARM kprobe_opcode_t is u32.
> +	 */
> +#define MAX_COPIED_INSN	(DIV_ROUND_UP(RELATIVEJUMP_SIZE, sizeof(kprobe_opcode_t)))
> +	kprobe_opcode_t copied_insn[MAX_COPIED_INSN];
> +	/* detour code buffer */
> +	kprobe_opcode_t *insn;
> +	/*
> +	 * We always copy one instruction on arm32,
> +	 * size always be 4, so didn't like x86, there is no
> +	 * size field.

The above comment doesn't parse very well, how about...

	 * We always copy one instruction on arm,
	 * so size will always be 4, and unlike x86, there is no
	 * need for a size field.


> +	 */
> +};
>  
>  #endif /* _ARM_KPROBES_H */
> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
> index 40d3e00..1d0f4e7 100644
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -52,7 +52,7 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o insn.o
>  obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o insn.o patch.o
>  obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
>  # Main staffs in KPROBES are in arch/arm/probes/ .
> -obj-$(CONFIG_KPROBES)		+= patch.o
> +obj-$(CONFIG_KPROBES)		+= patch.o insn.o
>  obj-$(CONFIG_OABI_COMPAT)	+= sys_oabi-compat.o
>  obj-$(CONFIG_ARM_THUMBEE)	+= thumbee.o
>  obj-$(CONFIG_KGDB)		+= kgdb.o
> diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
> index af9a8a9..ec7e332 100644
> --- a/arch/arm/kernel/ftrace.c
> +++ b/arch/arm/kernel/ftrace.c
> @@ -19,8 +19,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/opcodes.h>
>  #include <asm/ftrace.h>
> -
> -#include "insn.h"
> +#include <asm/insn.h>
>  
>  #ifdef CONFIG_THUMB2_KERNEL
>  #define	NOP		0xf85deb04	/* pop.w {lr} */
> diff --git a/arch/arm/kernel/jump_label.c b/arch/arm/kernel/jump_label.c
> index c6c73ed..35a8fbb 100644
> --- a/arch/arm/kernel/jump_label.c
> +++ b/arch/arm/kernel/jump_label.c
> @@ -1,8 +1,7 @@
>  #include <linux/kernel.h>
>  #include <linux/jump_label.h>
>  #include <asm/patch.h>
> -
> -#include "insn.h"
> +#include <asm/insn.h>
>  
>  #ifdef HAVE_JUMP_LABEL
>  
> diff --git a/arch/arm/probes/kprobes/Makefile b/arch/arm/probes/kprobes/Makefile
> index bc8d504..76a36bf 100644
> --- a/arch/arm/probes/kprobes/Makefile
> +++ b/arch/arm/probes/kprobes/Makefile
> @@ -7,5 +7,6 @@ obj-$(CONFIG_KPROBES)		+= actions-thumb.o checkers-thumb.o
>  test-kprobes-objs		+= test-thumb.o
>  else
>  obj-$(CONFIG_KPROBES)		+= actions-arm.o checkers-arm.o
> +obj-$(CONFIG_OPTPROBES)		+= opt-arm.o
>  test-kprobes-objs		+= test-arm.o
>  endif
> diff --git a/arch/arm/probes/kprobes/core.c b/arch/arm/probes/kprobes/core.c
> index 3a58db4..4a2cf40 100644
> --- a/arch/arm/probes/kprobes/core.c
> +++ b/arch/arm/probes/kprobes/core.c
> @@ -630,6 +630,7 @@ static struct undef_hook kprobes_arm_break_hook = {
>  
>  int __init arch_init_kprobes()
>  {
> +

Looks like an accidental blank line got added here.


>  	arm_probes_decode_init();
>  #ifdef CONFIG_THUMB2_KERNEL
>  	register_undef_hook(&kprobes_thumb16_break_hook);
> diff --git a/arch/arm/probes/kprobes/opt-arm.c b/arch/arm/probes/kprobes/opt-arm.c
> new file mode 100644
> index 0000000..46e4474
> --- /dev/null
> +++ b/arch/arm/probes/kprobes/opt-arm.c
> @@ -0,0 +1,322 @@
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
> +			/*
> +			 * AEABI requires a 8-bytes alignment stack. If
> +			 * SP % 8 != 0, alloc more bytes here.
> +			 */
> +			"	and	r4, sp, #7\n"

We already know that the stack must be aligned to 4 bytes here, because
if it weren't, pushing the registers to the stack which we did earlier
would cause an exception. We are also assuming that alignment because
otherwise the pt_regs* we pass to optimized_callback would be
misaligned. So whilst ANDing with 7 is functionally correct I think it's
a bit misleading as it implies we aren't sure of the current alignment.

Therefore I suggest sticking with '4', which matches the method used by
the exception handling code in svc_entry to align the stack. It also
matches arch_prepare_optimized_kprobe which you have allocating only 4
extra bytes for alignment rather than 7.


> +			"	sub	sp, sp, r4\n"
> +			"	blx	r2\n"
> +			"	add	sp, sp, r4\n"
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
> +#define TMPL_VAL_IDX \
> +	((unsigned long *)&optprobe_template_val - (unsigned long *)&optprobe_template_entry)
> +#define TMPL_CALL_IDX \
> +	((unsigned long *)&optprobe_template_call - (unsigned long *)&optprobe_template_entry)
> +#define TMPL_END_IDX \
> +	((unsigned long *)&optprobe_template_end - (unsigned long *)&optprobe_template_entry)
> +#define TMPL_ADD_SP \
> +	((unsigned long *)&optprobe_template_add_sp - (unsigned long *)&optprobe_template_entry)
> +#define TMPL_SUB_SP \
> +	((unsigned long *)&optprobe_template_sub_sp - (unsigned long *)&optprobe_template_entry)
> +
> +/*
> + * ARM can always optimize an instruction when using ARM ISA, except
> + * instructions like 'str r0, [sp, r1]' which store to stack and unable
> + * to determine stack space consumption statically.
> + */
> +int arch_prepared_optinsn(struct arch_optimized_insn *optinsn)
> +{
> +	return optinsn->insn != NULL;
> +}
> +
> +/*
> + * In ARM ISA, kprobe opt always replace one instruction (4 bytes
> + * aligned and 4 bytes long). It is impossible to encounter another
> + * kprobe in the address range. So always return 0.
> + */
> +int arch_check_optimized_kprobe(struct optimized_kprobe *op)
> +{
> +	return 0;
> +}
> +
> +/* Caller must ensure addr & 3 == 0 */
> +static int can_optimize(struct kprobe *kp)
> +{
> +	if (kp->ainsn.stack_space < 0)
> +		return 0;
> +	/*
> +	 * 255 is the biggest imm can be used in 'sub r0, r0, #<imm>'.
> +	 * Number larger than 255 needs special encoding.
> +	 */
> +	if (kp->ainsn.stack_space > 255 - sizeof(struct pt_regs))
> +		return 0;
> +	return 1;
> +}
> +
> +/* Free optimized instruction slot */
> +static void
> +__arch_remove_optimized_kprobe(struct optimized_kprobe *op, int dirty)
> +{
> +	if (op->optinsn.insn) {
> +		free_optinsn_slot(op->optinsn.insn, dirty);
> +		op->optinsn.insn = NULL;
> +	}
> +}
> +
> +extern void kprobe_handler(struct pt_regs *regs);
> +
> +static void
> +optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
> +{
> +	unsigned long flags;
> +	struct kprobe *p = &op->kp;
> +	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
> +
> +	/* Save skipped registers */
> +	regs->ARM_pc = (unsigned long)op->kp.addr;
> +	regs->ARM_ORIG_r0 = ~0UL;
> +
> +	local_irq_save(flags);
> +
> +	if (kprobe_running()) {
> +		kprobes_inc_nmissed_count(&op->kp);
> +	} else {
> +		__this_cpu_write(current_kprobe, &op->kp);
> +		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
> +		opt_pre_handler(&op->kp, regs);
> +		__this_cpu_write(current_kprobe, NULL);
> +	}
> +
> +	/* In each case, we must singlestep the replaced instruction. */
> +	op->kp.ainsn.insn_singlestep(p->opcode, &p->ainsn, regs);
> +
> +	local_irq_restore(flags);
> +}
> +
> +int arch_prepare_optimized_kprobe(struct optimized_kprobe *op, struct kprobe *orig)
> +{
> +	kprobe_opcode_t *code;
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

Don't think we need the above comment now, cerntainly not the last two
lines, because we've decided that slots are aligned after all. 


> +	code = get_optinsn_slot();
> +	if (!code)
> +		return -ENOMEM;
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

The above comment and code don't match up any more with the code in
optprobe_template_entry, it should be '+ 7' here. Alternatively, change
the code in optprobe_template_entry back to use 4 as I suggested.


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
> +	op->optinsn.insn = code;
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

-- 
Tixy

