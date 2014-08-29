Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaH2PGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:06:10 -0400
Received: from gw1.transmode.se ([195.58.98.146]:56498 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbaH2PGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:06:08 -0400
In-Reply-To: <20140829091437.832C41ABD65@localhost.localdomain>
References: <20140829091437.832C41ABD65@localhost.localdomain>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>, scottwood@freescale.com
MIME-Version: 1.0
Subject: Re: [PATCH v2 02/19] powerpc/8xx: Use SCRATCH0 and SCRATCH1 also for TLB
 handlers
X-KeepSent: 79DA9719:90FA0859-C1257D43:0052506D;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OF79DA9719.90FA0859-ONC1257D43.0052506D-C1257D43.0052F4B4@transmode.se>
Date: Fri, 29 Aug 2014 17:06:05 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP6|November 21, 2013) at
 29/08/2014 17:06:05,
	Serialize complete at 29/08/2014 17:06:05
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christophe Leroy <christophe.leroy@c-s.fr> wrote on 2014/08/29 11:14:37:
> 
> SCRATCH0 and SCRATCH1 are only used in Exceptions prologs where no other
> exception can happen. There is therefore no need to preserve them 
accross
> TLB handlers, we can use them there as in other exceptions. One of the
> advantages is that they do not suffer CPU6 errata unlike M_TW register.

Really nice! Some comments below

> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> ---
>  arch/powerpc/kernel/head_8xx.S |  104 
++++++++++++----------------------
>  1 files changed, 36 insertions(+), 68 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/head_8xx.S 
b/arch/powerpc/kernel/head_8xx.S
> index 1329c5a..3af6db1 100644
> --- a/arch/powerpc/kernel/head_8xx.S
> +++ b/arch/powerpc/kernel/head_8xx.S
> @@ -104,12 +104,15 @@ turn_on_mmu:
>   * task's thread_struct.
>   */
>  #define EXCEPTION_PROLOG   \
> -   mtspr   SPRN_SPRG_SCRATCH0,r10;   \
> -   mtspr   SPRN_SPRG_SCRATCH1,r11;   \
> -   mfcr   r10;      \
> +   EXCEPTION_PROLOG_0;   \
>     EXCEPTION_PROLOG_1;   \
>     EXCEPTION_PROLOG_2
> 
> +#define EXCEPTION_PROLOG_0   \
> +   mtspr   SPRN_SPRG_SCRATCH0,r10;   \
> +   mtspr   SPRN_SPRG_SCRATCH1,r11;   \
> +   mfcr   r10
> +
>  #define EXCEPTION_PROLOG_1   \
>     mfspr   r11,SPRN_SRR1;      /* check whether user or kernel */ \
>     andi.   r11,r11,MSR_PR;   \
> @@ -145,6 +148,14 @@ turn_on_mmu:
>     SAVE_2GPRS(7, r11)
> 
>  /*
> + * Exception exit code.
> + */
> +#define EXCEPTION_EPILOG_0   \
> +   mtcr   r10;      \
> +   mfspr   r10,SPRN_SPRG_SCRATCH0;   \
> +   mfspr   r11,SPRN_SPRG_SCRATCH1
> +
> +/*
>   * Note: code which follows this uses cr0.eq (set if from kernel),
>   * r11, r12 (SRR0), and r9 (SRR1).
>   *
> @@ -293,16 +304,8 @@ InstructionTLBMiss:
>  #ifdef CONFIG_8xx_CPU6
>     stw   r3, 8(r0)

Perhaps you can use SPRN_DAR to stash R3 now that it is free ?

     Jocke
