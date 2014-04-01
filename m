Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaDADVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:21:47 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:34947 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaDADVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:21:46 -0400
Message-ID: <533A30C1.5010407@hitachi.com>
Date: Tue, 01 Apr 2014 12:21:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] uprobes/x86: Gather "riprel" functions together
References: <20140331194409.GA9297@redhat.com>
In-Reply-To: <20140331194409.GA9297@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/01 4:44), Oleg Nesterov wrote:
> Cosmetic. Move pre_xol_rip_insn() and handle_riprel_post_xol() up
> to the closely related handle_riprel_insn().
> 
> This way it is simpler to read and understand this code, and this
> lessens the number of ifdef's.
> 
> TODO: rename them somehow to make the naming consistent.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Looks good to me:)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> ---
>  arch/x86/kernel/uprobes.c |  118 ++++++++++++++++++++-------------------------
>  1 files changed, 53 insertions(+), 65 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 382a69d..e8d7b38 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -313,6 +313,48 @@ handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
>  	}
>  }
>  
> +/*
> + * If we're emulating a rip-relative instruction, save the contents
> + * of the scratch register and store the target address in that register.
> + */
> +static void
> +pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs,
> +				struct arch_uprobe_task *autask)
> +{
> +	if (auprobe->fixups & UPROBE_FIX_RIP_AX) {
> +		autask->saved_scratch_register = regs->ax;
> +		regs->ax = current->utask->vaddr;
> +		regs->ax += auprobe->rip_rela_target_address;
> +	} else if (auprobe->fixups & UPROBE_FIX_RIP_CX) {
> +		autask->saved_scratch_register = regs->cx;
> +		regs->cx = current->utask->vaddr;
> +		regs->cx += auprobe->rip_rela_target_address;
> +	}
> +}
> +
> +static void
> +handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs, long *correction)
> +{
> +	if (auprobe->fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) {
> +		struct arch_uprobe_task *autask;
> +
> +		autask = &current->utask->autask;
> +		if (auprobe->fixups & UPROBE_FIX_RIP_AX)
> +			regs->ax = autask->saved_scratch_register;
> +		else
> +			regs->cx = autask->saved_scratch_register;
> +
> +		/*
> +		 * The original instruction includes a displacement, and so
> +		 * is 4 bytes longer than what we've just single-stepped.
> +		 * Fall through to handle stuff like "jmpq *...(%rip)" and
> +		 * "callq *...(%rip)".
> +		 */
> +		if (correction)
> +			*correction += 4;
> +	}
> +}
> +
>  static int validate_insn_64bits(struct arch_uprobe *auprobe, struct insn *insn)
>  {
>  	insn_init(insn, auprobe->insn, true);
> @@ -339,9 +381,19 @@ static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,
>  	return validate_insn_64bits(auprobe, insn);
>  }
>  #else /* 32-bit: */
> +/*
> + * No RIP-relative addressing on 32-bit
> + */
>  static void handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
>  {
> -	/* No RIP-relative addressing on 32-bit */
> +}
> +static void pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs,
> +				struct arch_uprobe_task *autask)
> +{
> +}
> +static void handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs,
> +					long *correction)
> +{
>  }
>  
>  static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,  struct insn *insn)
> @@ -413,34 +465,6 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
>  	return 0;
>  }
>  
> -#ifdef CONFIG_X86_64
> -/*
> - * If we're emulating a rip-relative instruction, save the contents
> - * of the scratch register and store the target address in that register.
> - */
> -static void
> -pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs,
> -				struct arch_uprobe_task *autask)
> -{
> -	if (auprobe->fixups & UPROBE_FIX_RIP_AX) {
> -		autask->saved_scratch_register = regs->ax;
> -		regs->ax = current->utask->vaddr;
> -		regs->ax += auprobe->rip_rela_target_address;
> -	} else if (auprobe->fixups & UPROBE_FIX_RIP_CX) {
> -		autask->saved_scratch_register = regs->cx;
> -		regs->cx = current->utask->vaddr;
> -		regs->cx += auprobe->rip_rela_target_address;
> -	}
> -}
> -#else
> -static void
> -pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs,
> -				struct arch_uprobe_task *autask)
> -{
> -	/* No RIP-relative addressing on 32-bit */
> -}
> -#endif
> -
>  /*
>   * arch_uprobe_pre_xol - prepare to execute out of line.
>   * @auprobe: the probepoint information.
> @@ -490,42 +514,6 @@ static int adjust_ret_addr(unsigned long sp, long correction)
>  	return 0;
>  }
>  
> -#ifdef CONFIG_X86_64
> -static bool is_riprel_insn(struct arch_uprobe *auprobe)
> -{
> -	return ((auprobe->fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) != 0);
> -}
> -
> -static void
> -handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs, long *correction)
> -{
> -	if (is_riprel_insn(auprobe)) {
> -		struct arch_uprobe_task *autask;
> -
> -		autask = &current->utask->autask;
> -		if (auprobe->fixups & UPROBE_FIX_RIP_AX)
> -			regs->ax = autask->saved_scratch_register;
> -		else
> -			regs->cx = autask->saved_scratch_register;
> -
> -		/*
> -		 * The original instruction includes a displacement, and so
> -		 * is 4 bytes longer than what we've just single-stepped.
> -		 * Fall through to handle stuff like "jmpq *...(%rip)" and
> -		 * "callq *...(%rip)".
> -		 */
> -		if (correction)
> -			*correction += 4;
> -	}
> -}
> -#else
> -static void
> -handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs, long *correction)
> -{
> -	/* No RIP-relative addressing on 32-bit */
> -}
> -#endif
> -
>  /*
>   * If xol insn itself traps and generates a signal(Say,
>   * SIGILL/SIGSEGV/etc), then detect the case where a singlestepped
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


