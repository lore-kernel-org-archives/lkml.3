Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaKGQnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:43:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbaKGQnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:43:45 -0500
Date: Fri, 7 Nov 2014 17:43:37 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, namit@cs.technion.ac.il
Subject: Re: [PATCH] KVM: x86: save a bit in the decoding flags
Message-ID: <20141107164337.GA22459@potion.brq.redhat.com>
References: <1415296011-15062-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415296011-15062-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-06 18:46+0100, Paolo Bonzini:
> AVX instructions are just tweaks of the operand length and the alignment
> restrictions of SSE instructions, and in fact the Avx bit is just a
> duplicate of Unaligned.  Drop it.
> 
> Suggested-by: Nadav Amit <namit@cs.technion.ac.il>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

I think this forces our future AVX implementation to be very hacky,
we couldn't tell explicitly (un)aligned SSE2/AVX apart.

>  arch/x86/kvm/emulate.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 9cc476f..87c9431 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -157,7 +157,7 @@
>  #define Mmx         ((u64)1 << 40)  /* MMX Vector instruction */
>  #define Aligned     ((u64)1 << 41)  /* Explicitly aligned (e.g. MOVDQA) */
>  #define Unaligned   ((u64)1 << 42)  /* Explicitly unaligned (e.g. MOVDQU) */
> -#define Avx         ((u64)1 << 43)  /* Advanced Vector Extensions */
> +#define No16        ((u64)1 << 43)  /* No 16 bit operand */
>  #define Fastop      ((u64)1 << 44)  /* Use opcode::u.fastop */
>  #define NoWrite     ((u64)1 << 45)  /* No writeback */
>  #define SrcWrite    ((u64)1 << 46)  /* Write back src operand */
> @@ -167,7 +167,6 @@
>  #define NoBigReal   ((u64)1 << 50)  /* No big real mode */
>  #define PrivUD      ((u64)1 << 51)  /* #UD instead of #GP on CPL > 0 */
>  #define NearBranch  ((u64)1 << 52)  /* Near branches */
> -#define No16	    ((u64)1 << 53)  /* No 16 bit operand */
>  
>  #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
>  
> @@ -646,8 +645,6 @@ static bool insn_aligned(struct x86_emulate_ctxt *ctxt, unsigned size)
>  		return true;
>  	else if (ctxt->d & Unaligned)
>  		return false;
> -	else if (ctxt->d & Avx)
> -		return false;
>  	else
>  		return true;

(return !(ctxt->d & Unaligned);)

>  }
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
