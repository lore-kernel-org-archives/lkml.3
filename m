Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaDTJ1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 05:27:05 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:52086 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbaDTJ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 05:26:52 -0400
Date: Sun, 20 Apr 2014 12:26:47 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Nadav Amit <namit@cs.technion.ac.il>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: x86: RSI/RDI/RCX are zero-extended when
 affected by string ops
Message-ID: <20140420092646.GB30377@minantech.com>
References: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il>
 <1397794294-8414-1-git-send-email-namit@cs.technion.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397794294-8414-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 07:11:33AM +0300, Nadav Amit wrote:
> When using address-size override prefix with string instructions in long-mode,
> ESI/EDI/ECX are zero extended if they are affected by the instruction
> (incremented/decremented).  Currently, the KVM emulator does not do so.
> 
> In addition, although it is not well-documented, when address override prefix
> is used with REP-string instruction, RCX high half is zeroed even if ECX was
> zero on the first iteration. Therefore, the emulator should clear the upper
> part of RCX in this case, as x86 CPUs do.
> 
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
> :100644 100644 69e2636... a69ed67... M	arch/x86/kvm/emulate.c
>  arch/x86/kvm/emulate.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 69e2636..a69ed67 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -491,6 +491,8 @@ register_address_increment(struct x86_emulate_ctxt *ctxt, unsigned long *reg, in
>  	else
>  		mask = ad_mask(ctxt);
>  	masked_increment(reg, mask, inc);
> +	if (ctxt->ad_bytes == 4)
> +		*reg &= 0xffffffff;
*reg=(u32)*reg; and you can do it inside else part.

register_address_increment() is used also by jmp_rel and loop instructions,
is this correct for both of those too? Probably yes.

>  }
>  
>  static void rsp_increment(struct x86_emulate_ctxt *ctxt, int inc)
> @@ -4567,6 +4569,8 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
>  	if (ctxt->rep_prefix && (ctxt->d & String)) {
>  		/* All REP prefixes have the same first termination condition */
>  		if (address_mask(ctxt, reg_read(ctxt, VCPU_REGS_RCX)) == 0) {
> +			if (ctxt->ad_bytes == 4)
> +				*reg_write(ctxt, VCPU_REGS_RCX) = 0;
Does zero extension happens even if ECX was zero at the beginning on an instruction or only during
ECX modification. If later it is already covered in register_address_increment, no?

>  			ctxt->eip = ctxt->_eip;
>  			goto done;
>  		}
> -- 
> 1.7.10.4
> 

--
			Gleb.
