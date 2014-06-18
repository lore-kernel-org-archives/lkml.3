Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaFRQ3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:29:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaFRQ3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:29:39 -0400
Message-ID: <53A1BE5E.3060809@redhat.com>
Date: Wed, 18 Jun 2014 18:29:18 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joro@8bytes.org
Subject: Re: [PATCH 2/3] KVM: x86: Emulator support for #UD on CPL>0
References: <1403101176-23664-1-git-send-email-namit@cs.technion.ac.il> <1403101176-23664-3-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1403101176-23664-3-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/06/2014 16:19, Nadav Amit ha scritto:
> Certain instructions (e.g., mwait and monitor) cause a #UD exception when they
> are executed in privilaged mode.

It's actually "non-privileged mode" (Priv means the instruction is 
privileged, not the mode).  So I've renamed the flag to PrivUD.

Paolo

  This is in contrast to the regular privilaged
> instructions which cause #GP. In order not to mess with SVM interception of
> mwait and monitor which assumes privilage level assertions take place before
> interception, a flag has been added.
>
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/kvm/emulate.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index f90194d..ef7a5a0 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -163,6 +163,7 @@
>  #define SrcWrite    ((u64)1 << 46)  /* Write back src operand */
>  #define NoMod	    ((u64)1 << 47)  /* Mod field is ignored */
>  #define NoBigReal   ((u64)1 << 48)  /* No big real mode */
> +#define UDOnPriv    ((u64)1 << 49)  /* #UD instead of #GP on CPL > 0 */
>
>  #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
>
> @@ -4560,7 +4561,10 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
>
>  	/* Privileged instruction can be executed only in CPL=0 */
>  	if ((ctxt->d & Priv) && ops->cpl(ctxt)) {
> -		rc = emulate_gp(ctxt, 0);
> +		if (ctxt->d & UDOnPriv)
> +			rc = emulate_ud(ctxt);
> +		else
> +			rc = emulate_gp(ctxt, 0);
>  		goto done;
>  	}
>
>

