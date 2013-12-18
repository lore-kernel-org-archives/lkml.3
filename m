Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3LRDaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 22:30:05 -0500
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:2054
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752235Ab3LRDaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 22:30:03 -0500
Message-ID: <1387337393.3140.27.camel@snotra.buserror.net>
Subject: Re: [v3][PATCH 2/8] powerpc/book3e: support CONFIG_RELOCATABLE
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 17 Dec 2013 21:29:53 -0600
In-Reply-To: <1373357007-30785-3-git-send-email-tiejun.chen@windriver.com>
References: <1373357007-30785-1-git-send-email-tiejun.chen@windriver.com>
	 <1373357007-30785-3-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BY2PR09CA009.namprd09.prod.outlook.com (10.242.32.19) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 0064B3273C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(51704005)(189002)(199002)(377424004)(24454002)(19580395003)(80976001)(56816005)(23676002)(53806001)(90146001)(42186004)(51856001)(89996001)(85306002)(76482001)(49866001)(65816001)(79102001)(63696002)(47776003)(19580405001)(50986001)(81816001)(47736001)(4396001)(83322001)(47976001)(81686001)(69226001)(46102001)(87976001)(59766001)(88136002)(85852003)(77096001)(87266001)(77982001)(54316002)(87286001)(74366001)(56776001)(76786001)(83072002)(80022001)(81542001)(31966008)(74502001)(74662001)(47446002)(81342001)(74706001)(50226001)(50466002)(76796001)(77156001)(74876001)(33646001)(62966002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-09 at 16:03 +0800, Tiejun Chen wrote:
> book3e is different with book3s since 3s includes the exception
> vectors code in head_64.S as it relies on absolute addressing
> which is only possible within this compilation unit. So we have
> to get that label address with got.
> 
> And when boot a relocated kernel, we should reset ipvr properly again
> after .relocate.

ivpr?

> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  arch/powerpc/include/asm/exception-64e.h |   11 +++++++++++
>  arch/powerpc/kernel/exceptions-64e.S     |   18 +++++++++++++++++-
>  arch/powerpc/kernel/head_64.S            |   25 +++++++++++++++++++++++++
>  3 files changed, 53 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/include/asm/exception-64e.h b/arch/powerpc/include/asm/exception-64e.h
> index 51fa43e..371a77f 100644
> --- a/arch/powerpc/include/asm/exception-64e.h
> +++ b/arch/powerpc/include/asm/exception-64e.h
> @@ -214,10 +214,21 @@ exc_##label##_book3e:
>  #define TLB_MISS_STATS_SAVE_INFO_BOLTED
>  #endif
>  
> +#ifndef CONFIG_RELOCATABLE

Please use positive logic (ifdef/else, rather than ifndef/else).

>  #define SET_IVOR(vector_number, vector_offset)	\
>  	li	r3,vector_offset@l; 		\
>  	ori	r3,r3,interrupt_base_book3e@l;	\
>  	mtspr	SPRN_IVOR##vector_number,r3;
> +#else /* !CONFIG_RELOCATABLE */
> +/* In relocatable case the value of the constant expression 'expr' is only
> + * offset. So instead, we should loads the address of label 'name'.
> + */
> +#define SET_IVOR(vector_number, vector_offset)	\
> +	LOAD_REG_ADDR(r3,interrupt_base_book3e);\
> +	rlwinm	r3,r3,0,15,0;			\
> +	ori	r3,r3,vector_offset@l;		\
> +	mtspr	SPRN_IVOR##vector_number,r3;
> +#endif /* CONFIG_RELOCATABLE */

Please use the more readable 4-operand version of "rlwinm".

Is there a reason why this new code is only used with
CONFIG_RELOCATABLE?  If @got doesn't work without CONFIG_RELOCATABLE,
then the ifdef should be pushed into LOAD_REG_ADDR.

Likewise with other ifdefs on CONFIG_RELOCATABLE.

> -_STATIC(init_core_book3e)
> +_GLOBAL(init_core_book3e)
>  	/* Establish the interrupt vector base */
> +#ifdef CONFIG_RELOCATABLE
> +/* In relocatable case the value of the constant expression 'expr' is only
> + * offset. So instead, we should loads the address of label 'name'.
> + */
> +	tovirt(r2,r2)
> +	LOAD_REG_ADDR(r3, interrupt_base_book3e)
> +#else
>  	LOAD_REG_IMMEDIATE(r3, interrupt_base_book3e)
> +#endif

I'm having a hard time parsing the comment.  Plus, it feels wrong to
decouple tovirt(r2,r2) from the call to relative_toc.

>  	mtspr	SPRN_IVPR,r3
>  	sync
>  	blr
> diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
> index b61363d..550f8fb 100644
> --- a/arch/powerpc/kernel/head_64.S
> +++ b/arch/powerpc/kernel/head_64.S
> @@ -414,12 +414,25 @@ _STATIC(__after_prom_start)
>  	/* process relocations for the final address of the kernel */
>  	lis	r25,PAGE_OFFSET@highest	/* compute virtual base of kernel */
>  	sldi	r25,r25,32
> +#if defined(CONFIG_PPC_BOOK3E)
> +	tovirt(r26,r26)			/* on booke, we already run at PAGE_OFFSET */
> +#endif
>  	lwz	r7,__run_at_load-_stext(r26)
> +#if defined(CONFIG_PPC_BOOK3E)
> +	tophys(r26,r26)			/* Restore for the remains. */
> +#endif
>  	cmplwi	cr0,r7,1	/* flagged to stay where we are ? */
>  	bne	1f
>  	add	r25,r25,r26
>  1:	mr	r3,r25
>  	bl	.relocate
> +#if defined(CONFIG_PPC_BOOK3E)
> +	/* In relocatable case we always have to load the address of label 'name'
> +	 * to set IVPR. So after .relocate we have to update IVPR with current
> +	 * address of label.
> +	 */
> +	bl	.init_core_book3e
> +#endif

Maybe this function should be renamed to something ivpr-specific, so
nothing else gets added there.

>  #endif
>  
>  /*
> @@ -447,12 +460,24 @@ _STATIC(__after_prom_start)
>   * variable __run_at_load, if it is set the kernel is treated as relocatable
>   * kernel, otherwise it will be moved to PHYSICAL_START
>   */
> +#if defined(CONFIG_PPC_BOOK3E)
> +	tovirt(r26,r26)			/* on booke, we already run at PAGE_OFFSET */
> +#endif
>  	lwz	r7,__run_at_load-_stext(r26)
> +#if defined(CONFIG_PPC_BOOK3E)
> +	tophys(r26,r26)			/* Restore for the remains. */
> +#endif
>  	cmplwi	cr0,r7,1
>  	bne	3f
>  
> +#ifdef CONFIG_PPC_BOOK3E
> +	LOAD_REG_ADDR(r5, __end_interrupts)
> +	LOAD_REG_ADDR(r11, _stext)
> +	sub	r5,r5,r11
> +#else
>  	/* just copy interrupts */
>  	LOAD_REG_IMMEDIATE(r5, __end_interrupts - _stext)
> +#endif

Can't we skip the interrupt copying on book3e?  And if not for some
reason, why start at _stext?

-Scott


