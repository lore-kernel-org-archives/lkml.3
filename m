Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbaHAXTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 19:19:41 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:43699 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaHAXTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 19:19:39 -0400
Date: Sat, 2 Aug 2014 01:19:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct
 pt_regs"
Message-ID: <20140801231929.GB26491@localhost.localdomain>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
 <1406904498-21647-4-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406904498-21647-4-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 04:48:17PM +0200, Denys Vlasenko wrote:
>  
>  /* 0(%rsp): ~(interrupt number) */
>  	.macro interrupt func
> -	/* reserve pt_regs for scratch regs and rbp */
> -	subq $ORIG_RAX-RBP, %rsp
> -	CFI_ADJUST_CFA_OFFSET ORIG_RAX-RBP
> -	cld
> -	/* start from rbp in pt_regs and jump over */
> -	movq_cfi rdi, (RDI-RBP)
> -	movq_cfi rsi, (RSI-RBP)
> -	movq_cfi rdx, (RDX-RBP)
> -	movq_cfi rcx, (RCX-RBP)
> -	movq_cfi rax, (RAX-RBP)
> -	movq_cfi  r8,  (R8-RBP)
> -	movq_cfi  r9,  (R9-RBP)
> -	movq_cfi r10, (R10-RBP)
> -	movq_cfi r11, (R11-RBP)
> -
> -	/* Save rbp so that we can unwind from get_irq_regs() */
> -	movq_cfi rbp, 0

Hmm SAVEE_C_REGS below doesn't seem to save rbp like we did before.
Perhaps it's implicitely saved somewhere?

> -
> -	/* Save previous stack value */
> -	movq %rsp, %rsi

Also rsp isn't saved in %rsi like before. Maybe
that's because we already save it in rdi? Makes sense since
now arg1 == rsp. More on that later.

> -
> -	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
> -	testl $3, CS-RBP(%rsi)
> +	ALLOC_PTREGS_ON_STACK
> +	SAVE_C_REGS
> +	movq %rsp, %rdi	/* arg1 for handler */
> +	testl $3, CS(%rsp)
>  	je 1f
>  	SWAPGS
> -	/*
> +1:	/*
>  	 * irq_count is used to check if a CPU is already on an interrupt stack
>  	 * or not. While this is essentially redundant with preempt_count it is
>  	 * a little cheaper to use a separate counter in the PDA (short of
>  	 * moving irq_enter into assembly, which would be too much work)
>  	 */
> -1:	incl PER_CPU_VAR(irq_count)
> +	incl PER_CPU_VAR(irq_count)
>  	cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
> -	CFI_DEF_CFA_REGISTER	rsi
> +	CFI_DEF_CFA_REGISTER	rdi
>  
>  	/* Store previous stack value */
> -	pushq %rsi
> +	pushq %rdi

So you push rdi instead...

>  	CFI_ESCAPE	0x0f /* DW_CFA_def_cfa_expression */, 6, \
>  			0x77 /* DW_OP_breg7 */, 0, \
>  			0x06 /* DW_OP_deref */, \
> -			0x08 /* DW_OP_const1u */, SS+8-RBP, \
> +			0x08 /* DW_OP_const1u */, SS+8, \
>  			0x22 /* DW_OP_plus */
>  	/* We entered an interrupt context - irqs are off: */
>  	TRACE_IRQS_OFF
> -
>  	call \func
>  	.endm
>  
> @@ -749,10 +719,9 @@ ret_from_intr:
>  
>  	/* Restore saved previous stack */
>  	popq %rsi

And then you pop to rsi. Ok that indeed works but perhaps we should keep it symetrical
just for clarity? Any reason why we can't reuse rdi here?

> -	CFI_DEF_CFA rsi,SS+8-RBP	/* reg/off reset after def_cfa_expr */
> -	leaq ARGOFFSET-RBP(%rsi), %rsp
> +	CFI_DEF_CFA rsi,SS+8	/* reg/off reset after def_cfa_expr */
> +	movq %rsi, %rsp
>  	CFI_DEF_CFA_REGISTER	rsp
> -	CFI_ADJUST_CFA_OFFSET	RBP-ARGOFFSET

Thanks.
