Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbbADFZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 00:25:56 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39544 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbbADFZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 00:25:55 -0500
Message-ID: <54A8CEDC.8060808@hitachi.com>
Date: Sun, 04 Jan 2015 14:25:48 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: tixy@linaro.org, linux@arm.linux.org.uk, lizefan@huawei.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v18 11/11] ARM: optprobes: execute instruction during
 restoring if possible.
References: <54A07FBE.3010206@hitachi.com> <1419826053-27988-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1419826053-27988-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/29 13:07), Wang Nan wrote:
> This patch removes software emulation or simulation for most of probed
> instructions. If the instruction doesn't use PC relative addressing,
> it will be translated into following instructions in the restore code
> in code template:
> 
>  ldmia {r0 - r14}  // restore all instruction except PC
>  <instruction>     // direct execute the probed instruction
>  b next_insn       // branch to next instruction.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

[...]
>  /*
> + * See register_usage_mask. If the probed instruction doesn't use PC,
> + * we can copy it into template and have it executed directly without
> + * simulation or emulation.
> + */
> +#define can_kprobe_direct_exec(m)	(!((m) & __register_usage_mask(15)))

BTW, is there any macro which indicates 15 is the number of PC register?
If we can do something like below, it will be easier to understand.

#define can_kprobe_direct_exec(m)	(!test_bit(ARM_REG_PC/* == 15*/, &m))

Thank you,

> +
> +/*
>   * NOTE: the first sub and add instruction will be modified according
>   * to the stack cost of the instruction.
>   */
> @@ -66,7 +73,15 @@ asm (
>  			"	orrne	r2, #1\n"
>  			"	strne	r2, [sp, #60] @ set bit0 of PC for thumb\n"
>  			"	msr	cpsr_cxsf, r1\n"
> +			".global optprobe_template_restore_begin\n"
> +			"optprobe_template_restore_begin:\n"
>  			"	ldmia	sp, {r0 - r15}\n"
> +			".global optprobe_template_restore_orig_insn\n"
> +			"optprobe_template_restore_orig_insn:\n"
> +			"	nop\n"
> +			".global optprobe_template_restore_end\n"
> +			"optprobe_template_restore_end:\n"
> +			"	nop\n"
>  			".global optprobe_template_val\n"
>  			"optprobe_template_val:\n"
>  			"1:	.long 0\n"
> @@ -86,6 +101,12 @@ asm (
>  	((unsigned long *)&optprobe_template_add_sp - (unsigned long *)&optprobe_template_entry)
>  #define TMPL_SUB_SP \
>  	((unsigned long *)&optprobe_template_sub_sp - (unsigned long *)&optprobe_template_entry)
> +#define TMPL_RESTORE_BEGIN \
> +	((unsigned long *)&optprobe_template_restore_begin - (unsigned long *)&optprobe_template_entry)
> +#define TMPL_RESTORE_ORIGN_INSN \
> +	((unsigned long *)&optprobe_template_restore_orig_insn - (unsigned long *)&optprobe_template_entry)
> +#define TMPL_RESTORE_END \
> +	((unsigned long *)&optprobe_template_restore_end - (unsigned long *)&optprobe_template_entry)
>  
>  /*
>   * ARM can always optimize an instruction when using ARM ISA, except
> @@ -155,8 +176,12 @@ optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
>  		__this_cpu_write(current_kprobe, NULL);
>  	}
>  
> -	/* In each case, we must singlestep the replaced instruction. */
> -	op->kp.ainsn.insn_singlestep(p->opcode, &p->ainsn, regs);
> +	/*
> +	 * We singlestep the replaced instruction only when it can't be
> +	 * executed directly during restore.
> +	 */
> +	if (!p->ainsn.kprobe_direct_exec)
> +		op->kp.ainsn.insn_singlestep(p->opcode, &p->ainsn, regs);
>  
>  	local_irq_restore(flags);
>  }
> @@ -238,6 +263,28 @@ int arch_prepare_optimized_kprobe(struct optimized_kprobe *op, struct kprobe *or
>  	val = (unsigned long)optimized_callback;
>  	code[TMPL_CALL_IDX] = val;
>  
> +	/* If possible, copy insn and have it executed during restore */
> +	orig->ainsn.kprobe_direct_exec = false;
> +	if (can_kprobe_direct_exec(orig->ainsn.register_usage_mask)) {
> +		kprobe_opcode_t final_branch = arm_gen_branch(
> +				(unsigned long)(&code[TMPL_RESTORE_END]),
> +				(unsigned long)(op->kp.addr) + 4);
> +		if (final_branch != 0) {
> +			/*
> +			 * Replace original 'ldmia sp, {r0 - r15}' with
> +			 * 'ldmia {r0 - r14}', restore all registers except pc.
> +			 */
> +			code[TMPL_RESTORE_BEGIN] = __opcode_to_mem_arm(0xe89d7fff);
> +
> +			/* The original probed instruction */
> +			code[TMPL_RESTORE_ORIGN_INSN] = __opcode_to_mem_arm(orig->opcode);
> +
> +			/* Jump back to next instruction */
> +			code[TMPL_RESTORE_END] = __opcode_to_mem_arm(final_branch);
> +			orig->ainsn.kprobe_direct_exec = true;
> +		}
> +	}
> +
>  	flush_icache_range((unsigned long)code,
>  			   (unsigned long)(&code[TMPL_END_IDX]));
>  
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


