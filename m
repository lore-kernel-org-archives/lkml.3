Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbaEGOoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:44:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbaEGOoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:44:02 -0400
From: Bandan Das <bsd@redhat.com>
To: Nadav Amit <namit@cs.technion.ac.il>
Cc: mtosatti@redhat.com, pbonzini@redhat.com, hpa@zytor.com, gleb@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] KVM: x86: Fix wrong masking on relative jump/call
References: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il>
	<1399465972-4026-6-git-send-email-namit@cs.technion.ac.il>
Date: Wed, 07 May 2014 10:43:50 -0400
In-Reply-To: <1399465972-4026-6-git-send-email-namit@cs.technion.ac.il> (Nadav
	Amit's message of "Wed, 7 May 2014 15:32:52 +0300")
Message-ID: <jpgppjpejix.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nadav Amit <namit@cs.technion.ac.il> writes:

> Relative jumps and calls do the masking according to the operand size, and not
> according to the address size as the KVM emulator does today.  In 64-bit mode,
> the resulting RIP is always 64-bit. Otherwise it is masked according to the
> instruction operand-size. Note that when 16-bit address size is used, bits
> 63:32 are unmodified.
>
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/kvm/emulate.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 6833b41..e406705 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -506,7 +506,9 @@ static void rsp_increment(struct x86_emulate_ctxt *ctxt, int inc)
>  
>  static inline void jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
>  {
> -	register_address_increment(ctxt, &ctxt->_eip, rel);
> +	/* 64-bit mode relative jumps are always 64-bit; otherwise mask */
> +	int op_bytes = ctxt->mode == X86EMUL_MODE_PROT64 ? 8 : ctxt->op_bytes;

Just a nit, probably break this up for readability ?

> +	masked_increment(&ctxt->eip, op_bytes, rel);
>  }
>  
>  static u32 desc_limit_scaled(struct desc_struct *desc)
