Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837AbaD2TJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:09:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932759AbaD2TJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:09:48 -0400
Date: Tue, 29 Apr 2014 21:09:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3] uprobes: simplify rip-relative handling
Message-ID: <20140429190933.GA1230@redhat.com>
References: <1398704774-25173-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398704774-25173-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version looks fine to me.

Masami, Jim, Srikar, can you ack the change in riprel_analyze() ?

On 04/28, Denys Vlasenko wrote:
>
> It is possible to replace rip-relative addressing mode
> with addressing mode of the same length: (reg+disp32).
> This eliminates the need to fix up immediate
> and correct for changing instruction length.
>
> v2: Rebased on top of Oleg's latest changes and run-tested.
> v3: Removed unnecessary cast.
> Improved comments based on Oleg's feedback.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Jim Keniston <jkenisto@us.ibm.com>
> CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/include/asm/uprobes.h |  3 ---
>  arch/x86/kernel/uprobes.c      | 61 ++++++++++++++++++------------------------
>  2 files changed, 26 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index a040d49..7be3c07 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -50,9 +50,6 @@ struct arch_uprobe {
>  			u8	opc1;
>  		}			branch;
>  		struct {
> -#ifdef CONFIG_X86_64
> -			long	riprel_target;
> -#endif
>  			u8	fixups;
>  			u8	ilen;
>  		} 			def;
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index c229b5f..ae6df8e 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -251,9 +251,9 @@ static inline bool is_64bit_mm(struct mm_struct *mm)
>   * If arch_uprobe->insn doesn't use rip-relative addressing, return
>   * immediately.  Otherwise, rewrite the instruction so that it accesses
>   * its memory operand indirectly through a scratch register.  Set
> - * def->fixups and def->riprel_target accordingly. (The contents of the
> - * scratch register will be saved before we single-step the modified
> - * instruction, and restored afterward).
> + * def->fixups accordingly. (The contents of the scratch register
> + * will be saved before we single-step the modified instruction,
> + * and restored afterward).
>   *
>   * We do this because a rip-relative instruction can access only a
>   * relatively small area (+/- 2 GB from the instruction), and the XOL
> @@ -264,9 +264,12 @@ static inline bool is_64bit_mm(struct mm_struct *mm)
>   *
>   * Some useful facts about rip-relative instructions:
>   *
> - *  - There's always a modrm byte.
> + *  - There's always a modrm byte with bit layout "00 reg 101".
>   *  - There's never a SIB byte.
>   *  - The displacement is always 4 bytes.
> + *  - REX.B=1 bit in REX prefix, which normally extends r/m field,
> + *    has no effect on rip-relative mode. It doesn't make modrm byte
> + *    with r/m=101 refer to register 1101 = R13.
>   */
>  static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
>  {
> @@ -293,9 +296,8 @@ static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
>  	 */
>  	cursor = auprobe->insn + insn_offset_modrm(insn);
>  	/*
> -	 * Convert from rip-relative addressing to indirect addressing
> -	 * via a scratch register.  Change the r/m field from 0x5 (%rip)
> -	 * to 0x0 (%rax) or 0x1 (%rcx), and squeeze out the offset field.
> +	 * Convert from rip-relative addressing to register-relative addressing
> +	 * via a scratch register.
>  	 */
>  	reg = MODRM_REG(insn);
>  	if (reg == 0) {
> @@ -307,22 +309,21 @@ static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
>  		 * #1) for the scratch register.
>  		 */
>  		auprobe->def.fixups |= UPROBE_FIX_RIP_CX;
> -		/* Change modrm from 00 000 101 to 00 000 001. */
> -		*cursor = 0x1;
> +		/*
> +		 * Change modrm from "00 000 101" to "10 000 001". Example:
> +		 * 89 05 disp32  mov %eax,disp32(%rip) becomes
> +		 * 89 81 disp32  mov %eax,disp32(%rcx)
> +		 */
> +		*cursor = 0x81;
>  	} else {
>  		/* Use %rax (register #0) for the scratch register. */
>  		auprobe->def.fixups |= UPROBE_FIX_RIP_AX;
> -		/* Change modrm from 00 xxx 101 to 00 xxx 000 */
> -		*cursor = (reg << 3);
> -	}
> -
> -	/* Target address = address of next instruction + (signed) offset */
> -	auprobe->def.riprel_target = (long)insn->length + insn->displacement.value;
> -
> -	/* Displacement field is gone; slide immediate field (if any) over. */
> -	if (insn->immediate.nbytes) {
> -		cursor++;
> -		memmove(cursor, cursor + insn->displacement.nbytes, insn->immediate.nbytes);
> +		/*
> +		 * Change modrm from "00 reg 101" to "10 reg 000". Example:
> +		 * 89 1d disp32  mov %edx,disp32(%rip) becomes
> +		 * 89 98 disp32  mov %edx,disp32(%rax)
> +		 */
> +		*cursor = (reg << 3) | 0x80;
>  	}
>  }
>  
> @@ -343,26 +344,17 @@ static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  		unsigned long *sr = scratch_reg(auprobe, regs);
>  
>  		utask->autask.saved_scratch_register = *sr;
> -		*sr = utask->vaddr + auprobe->def.riprel_target;
> +		*sr = utask->vaddr + auprobe->def.ilen;
>  	}
>  }
>  
> -static void riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs,
> -				long *correction)
> +static void riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
>  	if (auprobe->def.fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) {
>  		struct uprobe_task *utask = current->utask;
>  		unsigned long *sr = scratch_reg(auprobe, regs);
>  
>  		*sr = utask->autask.saved_scratch_register;
> -		/*
> -		 * The original instruction includes a displacement, and so
> -		 * is 4 bytes longer than what we've just single-stepped.
> -		 * Caller may need to apply other fixups to handle stuff
> -		 * like "jmpq *...(%rip)" and "callq *...(%rip)".
> -		 */
> -		if (correction)
> -			*correction += 4;
>  	}
>  }
>  #else /* 32-bit: */
> @@ -379,8 +371,7 @@ static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
>  static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
>  }
> -static void riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs,
> -					long *correction)
> +static void riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
>  }
>  #endif /* CONFIG_X86_64 */
> @@ -419,7 +410,7 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
>  	struct uprobe_task *utask = current->utask;
>  	long correction = (long)(utask->vaddr - utask->xol_vaddr);
>  
> -	riprel_post_xol(auprobe, regs, &correction);
> +	riprel_post_xol(auprobe, regs);
>  	if (auprobe->def.fixups & UPROBE_FIX_IP) {
>  		regs->ip += correction;
>  	} else if (auprobe->def.fixups & UPROBE_FIX_CALL) {
> @@ -436,7 +427,7 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
>  
>  static void default_abort_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
> -	riprel_post_xol(auprobe, regs, NULL);
> +	riprel_post_xol(auprobe, regs);
>  }
>  
>  static struct uprobe_xol_ops default_xol_ops = {
> -- 
> 1.8.1.4
> 

