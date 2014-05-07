Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbaEGOus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:50:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbaEGOur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:50:47 -0400
From: Bandan Das <bsd@redhat.com>
To: Nadav Amit <namit@cs.technion.ac.il>
Cc: mtosatti@redhat.com, pbonzini@redhat.com, hpa@zytor.com, gleb@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: x86: Wrong register masking in 64-bit mode
References: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>
	<1399465972-4026-5-git-send-email-namit@cs.technion.ac.il>
Date: Wed, 07 May 2014 10:50:15 -0400
In-Reply-To: <1399465972-4026-5-git-send-email-namit@cs.technion.ac.il> (Nadav
	Amit's message of "Wed, 7 May 2014 15:32:51 +0300")
Message-ID: <jpglhudej88.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nadav Amit <namit@cs.technion.ac.il> writes:

> 32-bit operations are zero extended in 64-bit mode. Currently, the code does
> not handle them correctly and keeps the high bits. In 16-bit mode, the high
> 32-bits are kept intact.
>
> In addition, although it is not well-documented, when address override prefix

It would be helpful to have a pointer in the SDM especially for cases 
that are not well-documented.

> is used with REP-string instruction, RCX high half is zeroed even if ECX was
> zero on the first iteration (as if an assignment was performed to ECX).
>
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/kvm/emulate.c | 38 +++++++++++++++++++++++---------------
>  1 file changed, 23 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 743e8e3..6833b41 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -434,9 +434,21 @@ static int emulator_check_intercept(struct x86_emulate_ctxt *ctxt,
>  	return ctxt->ops->intercept(ctxt, &info, stage);
>  }
>  
> -static void assign_masked(ulong *dest, ulong src, ulong mask)
> +static void assign_masked(ulong *dest, ulong src, int bytes)
>  {
> -	*dest = (*dest & ~mask) | (src & mask);
> +	switch (bytes) {
> +	case 2:
> +		*dest = (u16)src | (*dest & ~0xfffful);
> +		break;
> +	case 4:
> +		*dest = (u32)src;
> +		break;
> +	case 8:
> +		*dest = src;
> +		break;
> +	default:
> +		BUG();

IIRC, Paolo mentioned that a WARN() is preferable. But I see
a lot other places where BUG() is called, maybe, he can confirm.

> +	}
>  }
>  
>  static inline unsigned long ad_mask(struct x86_emulate_ctxt *ctxt)
> @@ -476,26 +488,20 @@ register_address(struct x86_emulate_ctxt *ctxt, unsigned long reg)
>  	return address_mask(ctxt, reg);
>  }
>  
> -static void masked_increment(ulong *reg, ulong mask, int inc)
> +static void masked_increment(ulong *reg, int size, int inc)
>  {
> -	assign_masked(reg, *reg + inc, mask);
> +	assign_masked(reg, *reg + inc, size);
>  }
>  
>  static inline void
>  register_address_increment(struct x86_emulate_ctxt *ctxt, unsigned long *reg, int inc)
>  {
> -	ulong mask;
> -
> -	if (ctxt->ad_bytes == sizeof(unsigned long))
> -		mask = ~0UL;
> -	else
> -		mask = ad_mask(ctxt);
> -	masked_increment(reg, mask, inc);
> +	masked_increment(reg, ctxt->ad_bytes, inc);
>  }
>  
>  static void rsp_increment(struct x86_emulate_ctxt *ctxt, int inc)
>  {
> -	masked_increment(reg_rmw(ctxt, VCPU_REGS_RSP), stack_mask(ctxt), inc);
> +	masked_increment(reg_rmw(ctxt, VCPU_REGS_RSP), stack_size(ctxt), inc);
>  }
>  
>  static inline void jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
> @@ -1712,17 +1718,17 @@ static int em_enter(struct x86_emulate_ctxt *ctxt)
>  	if (rc != X86EMUL_CONTINUE)
>  		return rc;
>  	assign_masked(reg_rmw(ctxt, VCPU_REGS_RBP), reg_read(ctxt, VCPU_REGS_RSP),
> -		      stack_mask(ctxt));
> +		      stack_size(ctxt));
>  	assign_masked(reg_rmw(ctxt, VCPU_REGS_RSP),
>  		      reg_read(ctxt, VCPU_REGS_RSP) - frame_size,
> -		      stack_mask(ctxt));
> +		      stack_size(ctxt));
>  	return X86EMUL_CONTINUE;
>  }
>  
>  static int em_leave(struct x86_emulate_ctxt *ctxt)
>  {
>  	assign_masked(reg_rmw(ctxt, VCPU_REGS_RSP), reg_read(ctxt, VCPU_REGS_RBP),
> -		      stack_mask(ctxt));
> +		      stack_size(ctxt));
>  	return emulate_pop(ctxt, reg_rmw(ctxt, VCPU_REGS_RBP), ctxt->op_bytes);
>  }
>  
> @@ -4570,6 +4576,8 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
>  	if (ctxt->rep_prefix && (ctxt->d & String)) {
>  		/* All REP prefixes have the same first termination condition */
>  		if (address_mask(ctxt, reg_read(ctxt, VCPU_REGS_RCX)) == 0) {
> +			assign_masked(reg_write(ctxt, VCPU_REGS_RCX), 0,
> +				      ctxt->ad_bytes);
>  			ctxt->eip = ctxt->_eip;
>  			goto done;
>  		}
