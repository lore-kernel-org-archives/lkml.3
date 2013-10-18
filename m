Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab3JRWhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:37:17 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:34848
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757226Ab3JRWhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:37:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI936eI154dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1382135824.7979.906.camel@snotra.buserror.net>
Subject: Re: [v5][PATCH 1/6] powerpc/book3e: load critical/machine/debug
 exception stack
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 18 Oct 2013 17:37:04 -0500
In-Reply-To: <1371724110-8250-2-git-send-email-tiejun.chen@windriver.com>
References: <1371724110-8250-1-git-send-email-tiejun.chen@windriver.com>
	 <1371724110-8250-2-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 18:28 +0800, Tiejun Chen wrote:
> We always alloc critical/machine/debug check exceptions. This is
> different from the normal exception. So we should load these exception
> stack properly like we did for booke.

This is "booke".  Do you mean like "like we did for 32-bit"?

And the code is already trying to load the special stack; it just
happens that it's loading from a different location than the C code
placed the stack addresses.  The changelog should point out the specific
thing that is being fixed.

> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  arch/powerpc/kernel/exceptions-64e.S |   49 +++++++++++++++++++++++++++++++---
>  1 file changed, 46 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
> index 4b23119..4d8e57f 100644
> --- a/arch/powerpc/kernel/exceptions-64e.S
> +++ b/arch/powerpc/kernel/exceptions-64e.S
> @@ -36,6 +36,37 @@
>   */
>  #define	SPECIAL_EXC_FRAME_SIZE	INT_FRAME_SIZE
>  
> +/* only on book3e */
> +#define DBG_STACK_BASE		dbgirq_ctx
> +#define MC_STACK_BASE		mcheckirq_ctx
> +#define CRIT_STACK_BASE		critirq_ctx
> +
> +#ifdef CONFIG_RELOCATABLE
> +#define LOAD_STACK_BASE(reg, level)			\
> +	tovirt(r2,r2);					\
> +	LOAD_REG_ADDR(reg, level##_STACK_BASE);
> +#else
> +#define LOAD_STACK_BASE(reg, level)			\
> +	LOAD_REG_IMMEDIATE(reg, level##_STACK_BASE);
> +#endif
> +
> +#ifdef CONFIG_SMP
> +#define BOOK3E_LOAD_EXC_LEVEL_STACK(level)		\
> +	mfspr	r14,SPRN_PIR;				\
> +	slwi	r14,r14,3;				\
> +	LOAD_STACK_BASE(r10, level);			\
> +	add	r10,r10,r14;				\
> +	ld	r10,0(r10);				\
> +	addi	r10,r10,THREAD_SIZE;			\
> +	std	r10,PACA_##level##_STACK(r13);
> +#else
> +#define BOOK3E_LOAD_EXC_LEVEL_STACK(level)		\
> +	LOAD_STACK_BASE(r10, level);			\
> +	ld	r10,0(r10);				\
> +	addi	r10,r10,THREAD_SIZE;			\
> +	std	r10,PACA_##level##_STACK(r13);
> +#endif

It looks like you're loading the stack from *irq_ctx, storing it in
PACA_*_stack, and then (immediately after this in the caller) loading it
back from PACA_*_STACK.  Why not just load it from *irq_ctx and get rid
of PACA_*_STACK altogether -- or change the C code to initialize the
addresses in the PACA instead, and get ird of *irq_ctx on 64-bit?

>  /* Exception prolog code for all exceptions */
>  #define EXCEPTION_PROLOG(n, intnum, type, addition)	    		    \
>  	mtspr	SPRN_SPRG_##type##_SCRATCH,r13;	/* get spare registers */   \
> @@ -68,20 +99,32 @@
>  #define SPRN_GDBELL_SRR1	SPRN_GSRR1
>  
>  #define CRIT_SET_KSTACK						            \
> +	andi.	r10,r11,MSR_PR;							\
> +	bne	1f;								\
> +	BOOK3E_LOAD_EXC_LEVEL_STACK(CRIT);					\
>  	ld	r1,PACA_CRIT_STACK(r13);				    \
> -	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;
> +	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;					\

The caller will already check MSR_PR and override this if coming from
userspace; why do you need to check again here?

-Scott



