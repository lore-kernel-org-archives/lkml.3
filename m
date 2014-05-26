Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaEZMSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 08:18:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaEZMSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 08:18:15 -0400
Message-ID: <538330D8.40602@redhat.com>
Date: Mon, 26 May 2014 14:17:28 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: MOV CR/DR emulation should ignore mod
References: <1401048321-4917-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1401048321-4917-1-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/05/2014 22:05, Nadav Amit ha scritto:
> MOV CR/DR instructions ignore the mod field (in the ModR/M byte). As the SDM
> states: "The 2 bits in the mod field are ignored".  Accordingly, the second
> operand of these instructions is always a general purpose register.
>
> The current emulator implementation does not do so. If the mod bits do not
> equal 3, it expects the second operand to be in memory.
>
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/kvm/emulate.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 2fa7ab0..e4e833d 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -161,6 +161,7 @@
>  #define Fastop      ((u64)1 << 44)  /* Use opcode::u.fastop */
>  #define NoWrite     ((u64)1 << 45)  /* No writeback */
>  #define SrcWrite    ((u64)1 << 46)  /* Write back src operand */
> +#define NoMod	    ((u64)1 << 47)  /* Mod field is ignored */
>
>  #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
>
> @@ -1077,7 +1078,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
>  	ctxt->modrm_rm |= (ctxt->modrm & 0x07);
>  	ctxt->modrm_seg = VCPU_SREG_DS;
>
> -	if (ctxt->modrm_mod == 3) {
> +	if (ctxt->modrm_mod == 3 || (ctxt->d & NoMod)) {
>  		op->type = OP_REG;
>  		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
>  		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm,
> @@ -3877,10 +3878,12 @@ static const struct opcode twobyte_table[256] = {
>  	N, N, N, N, N, N, N, N,
>  	D(ImplicitOps | ModRM), N, N, N, N, N, N, D(ImplicitOps | ModRM),
>  	/* 0x20 - 0x2F */
> -	DIP(ModRM | DstMem | Priv | Op3264, cr_read, check_cr_read),
> -	DIP(ModRM | DstMem | Priv | Op3264, dr_read, check_dr_read),
> -	IIP(ModRM | SrcMem | Priv | Op3264, em_cr_write, cr_write, check_cr_write),
> -	IIP(ModRM | SrcMem | Priv | Op3264, em_dr_write, dr_write, check_dr_write),
> +	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, cr_read, check_cr_read),
> +	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, dr_read, check_dr_read),
> +	IIP(ModRM | SrcMem | Priv | Op3264 | NoMod, em_cr_write, cr_write,
> +						check_cr_write),
> +	IIP(ModRM | SrcMem | Priv | Op3264 | NoMod, em_dr_write, dr_write,
> +						check_dr_write),
>  	N, N, N, N,
>  	GP(ModRM | DstReg | SrcMem | Mov | Sse, &pfx_0f_28_0f_29),
>  	GP(ModRM | DstMem | SrcReg | Mov | Sse, &pfx_0f_28_0f_29),
>

This is easy to test in kvm-unit-tests.  Please provide a patch for that 
as well. :)

Paolo
