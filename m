Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab3LRCpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 21:45:51 -0500
Received: from mail-bn1lp0155.outbound.protection.outlook.com ([207.46.163.155]:33344
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab3LRCpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 21:45:49 -0500
Message-ID: <1387334740.3140.9.camel@snotra.buserror.net>
Subject: Re: [v6][PATCH 2/5] powerpc/book3e: store crit/mc/dbg exception
 thread info
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 17 Dec 2013 20:45:40 -0600
In-Reply-To: <1382520685-11609-3-git-send-email-tiejun.chen@windriver.com>
References: <1382520685-11609-1-git-send-email-tiejun.chen@windriver.com>
	 <1382520685-11609-3-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BLUPR08CA016.namprd08.prod.outlook.com (10.141.30.36) To
 DM2PR03MB399.namprd03.prod.outlook.com (10.141.84.148)
X-Forefront-PRVS: 0064B3273C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(199002)(51704005)(24454002)(377424004)(189002)(76796001)(80976001)(76786001)(65816001)(80022001)(19580405001)(83322001)(74706001)(81686001)(79102001)(54316002)(81342001)(62966002)(19580395003)(23676002)(87286001)(56776001)(87976001)(74366001)(47776003)(77982001)(90146001)(63696002)(89996001)(69226001)(50466002)(81542001)(50986001)(47736001)(56816005)(47976001)(49866001)(4396001)(50226001)(88136002)(31966008)(74662001)(47446002)(74502001)(51856001)(46102001)(83072002)(85852003)(77096001)(77156001)(74876001)(87266001)(76482001)(53806001)(85306002)(42186004)(59766001)(33646001)(81816001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB399;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-23 at 17:31 +0800, Tiejun Chen wrote:
> We need to store thread info to these exception thread info like something
> we already did for PPC32.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  arch/powerpc/kernel/exceptions-64e.S |   22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
> index 68d74b4..a55cf62 100644
> --- a/arch/powerpc/kernel/exceptions-64e.S
> +++ b/arch/powerpc/kernel/exceptions-64e.S
> @@ -36,6 +36,19 @@
>   */
>  #define	SPECIAL_EXC_FRAME_SIZE	INT_FRAME_SIZE
>  
> +/* Now we only store something to exception thread info */
> +#define	EXC_LEVEL_EXCEPTION_PROLOG(type)				\
> +	ld	r14,PACAKSAVE(r13);					\
> +	CURRENT_THREAD_INFO(r14, r14);					\
> +	CURRENT_THREAD_INFO(r15, r1);					\
> +	ld	r10,TI_FLAGS(r14);		     			\
> +	std	r10,TI_FLAGS(r15);			     		\
> +	ld	r10,TI_PREEMPT(r14);		     			\
> +	std	r10,TI_PREEMPT(r15);		     			\
> +	ld	r10,TI_TASK(r14);			     		\
> +	std	r10,TI_TASK(r15);
> +
> +
>  /* Exception prolog code for all exceptions */
>  #define EXCEPTION_PROLOG(n, intnum, type, addition)	    		    \
>  	mtspr	SPRN_SPRG_##type##_SCRATCH,r13;	/* get spare registers */   \
> @@ -69,19 +82,22 @@
>  
>  #define CRIT_SET_KSTACK						            \
>  	ld	r1,PACA_CRIT_STACK(r13);				    \
> -	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;
> +	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;				    \
> +	EXC_LEVEL_EXCEPTION_PROLOG(CRIT);
>  #define SPRN_CRIT_SRR0	SPRN_CSRR0
>  #define SPRN_CRIT_SRR1	SPRN_CSRR1
>  
>  #define DBG_SET_KSTACK						            \
>  	ld	r1,PACA_DBG_STACK(r13);					    \
> -	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;
> +	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;				    \
> +	EXC_LEVEL_EXCEPTION_PROLOG(DBG);
>  #define SPRN_DBG_SRR0	SPRN_DSRR0
>  #define SPRN_DBG_SRR1	SPRN_DSRR1
>  
>  #define MC_SET_KSTACK						            \
>  	ld	r1,PACA_MC_STACK(r13);					    \
> -	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;
> +	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;				    \
> +	EXC_LEVEL_EXCEPTION_PROLOG(MC);
>  #define SPRN_MC_SRR0	SPRN_MCSRR0
>  #define SPRN_MC_SRR1	SPRN_MCSRR1
>  

We should rename these if they're going to do more than set up a stack.

-Scott


