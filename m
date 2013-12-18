Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3LRDnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 22:43:04 -0500
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:7007
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752628Ab3LRDnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 22:43:01 -0500
Message-ID: <1387338152.3140.37.camel@snotra.buserror.net>
Subject: Re: [v3][PATCH 5/8] book3e/kexec/kdump: introduce a kexec kernel
 flag
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 17 Dec 2013 21:42:32 -0600
In-Reply-To: <1373357007-30785-6-git-send-email-tiejun.chen@windriver.com>
References: <1373357007-30785-1-git-send-email-tiejun.chen@windriver.com>
	 <1373357007-30785-6-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BN1PR08CA008.namprd08.prod.outlook.com (10.255.197.38) To
 DM2PR03MB399.namprd03.prod.outlook.com (10.141.84.148)
X-Forefront-PRVS: 0064B3273C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(199002)(51704005)(24454002)(377424004)(189002)(76796001)(80976001)(65816001)(76786001)(80022001)(83322001)(19580405001)(74706001)(79102001)(81686001)(54316002)(81342001)(62966002)(19580395003)(23676002)(87286001)(56776001)(87976001)(74366001)(47776003)(77982001)(90146001)(63696002)(89996001)(69226001)(50466002)(81542001)(50986001)(47736001)(56816005)(47976001)(49866001)(4396001)(50226001)(88136002)(31966008)(74662001)(47446002)(74502001)(51856001)(46102001)(83072002)(85852003)(77096001)(77156001)(74876001)(87266001)(76482001)(85306002)(59766001)(42186004)(53806001)(33646001)(81816001)(32563001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB399;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-09 at 16:03 +0800, Tiejun Chen wrote:
> We need to introduce a flag to indicate we're already running
> a kexec kernel then we can go proper path. For example, We
> shouldn't access spin_table from the bootloader to up any secondary
> cpu for kexec kernel, and kexec kernel already know how to jump to
> generic_secondary_smp_init.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  arch/powerpc/include/asm/smp.h    |    1 +
>  arch/powerpc/kernel/head_64.S     |   10 ++++++++++
>  arch/powerpc/kernel/misc_64.S     |    6 ++++++
>  arch/powerpc/platforms/85xx/smp.c |   20 +++++++++++++++-----
>  4 files changed, 32 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
> index ffbaabe..59165a3 100644
> --- a/arch/powerpc/include/asm/smp.h
> +++ b/arch/powerpc/include/asm/smp.h
> @@ -200,6 +200,7 @@ extern void generic_secondary_thread_init(void);
>  extern unsigned long __secondary_hold_spinloop;
>  extern unsigned long __secondary_hold_acknowledge;
>  extern char __secondary_hold;
> +extern unsigned long __run_at_kexec;
>  
>  extern void __early_start(void);
>  #endif /* __ASSEMBLY__ */
> diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
> index 7dc56be..0b46c9d 100644
> --- a/arch/powerpc/kernel/head_64.S
> +++ b/arch/powerpc/kernel/head_64.S
> @@ -89,6 +89,10 @@ __secondary_hold_spinloop:
>  __secondary_hold_acknowledge:
>  	.llong	0x0
>  
> +	.globl	__run_at_kexec
> +__run_at_kexec:
> +	.llong	0x0	/* Flag for the secondary kernel from kexec. */
> +

No leading underscores please -- and why does this need to be 64-bit?

>  #ifdef CONFIG_RELOCATABLE
>  	/* This flag is set to 1 by a loader if the kernel should run
>  	 * at the loaded address instead of the linked address.  This
> @@ -417,6 +421,12 @@ _STATIC(__after_prom_start)
>  #if defined(CONFIG_PPC_BOOK3E)
>  	tovirt(r26,r26)			/* on booke, we already run at PAGE_OFFSET */
>  #endif
> +#if defined(CONFIG_KEXEC) || defined(CONFIG_CRASH_DUMP)
> +	/* If relocated we need to restore this flag on that relocated address. */
> +	ld	r7,__run_at_kexec-_stext(r26)
> +	std	r7,__run_at_kexec-_stext(r26)
> +#endif
> +
>  	lwz	r7,__run_at_load-_stext(r26)
>  #if defined(CONFIG_PPC_BOOK3E)
>  	tophys(r26,r26)			/* Restore for the remains. */
> diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
> index 20cbb98..c89aead 100644
> --- a/arch/powerpc/kernel/misc_64.S
> +++ b/arch/powerpc/kernel/misc_64.S
> @@ -619,6 +619,12 @@ _GLOBAL(kexec_sequence)
>  	bl	.copy_and_flush	/* (dest, src, copy limit, start offset) */
>  1:	/* assume normal blr return */
>  
> +	/* notify we're going into kexec kernel for SMP. */
> +	LOAD_REG_ADDR(r3,__run_at_kexec)
> +	li	r4,1
> +	std	r4,0(r3)
> +	sync
> +
>  	/* release other cpus to the new kernel secondary start at 0x60 */
>  	mflr	r5
>  	li	r6,1
> diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
> index 5ced4f5..14d461b 100644
> --- a/arch/powerpc/platforms/85xx/smp.c
> +++ b/arch/powerpc/platforms/85xx/smp.c
> @@ -150,6 +150,9 @@ static int smp_85xx_kick_cpu(int nr)
>  	int hw_cpu = get_hard_smp_processor_id(nr);
>  	int ioremappable;
>  	int ret = 0;
> +#ifdef CONFIG_PPC64
> +	unsigned long *ptr = NULL;
> +#endif

Looks like an unnecessary initialization.

>  
>  	WARN_ON(nr < 0 || nr >= NR_CPUS);
>  	WARN_ON(hw_cpu < 0 || hw_cpu >= NR_CPUS);
> @@ -238,11 +241,18 @@ out:
>  #else
>  	smp_generic_kick_cpu(nr);
>  
> -	flush_spin_table(spin_table);
> -	out_be32(&spin_table->pir, hw_cpu);
> -	out_be64((u64 *)(&spin_table->addr_h),
> -	  __pa((u64)*((unsigned long long *)generic_secondary_smp_init)));
> -	flush_spin_table(spin_table);
> +	ptr  = (unsigned long *)((unsigned long)&__run_at_kexec);
> +	/* We shouldn't access spin_table from the bootloader to up any
> +	 * secondary cpu for kexec kernel, and kexec kernel already
> +	 * know how to jump to generic_secondary_smp_init.
> +	 */
> +	if (!*ptr) {
> +		flush_spin_table(spin_table);
> +		out_be32(&spin_table->pir, hw_cpu);
> +		out_be64((u64 *)(&spin_table->addr_h),
> +		 __pa((u64)*((unsigned long long *)generic_secondary_smp_init)));
> +		flush_spin_table(spin_table);
> +	}
>  #endif

Please use a more descriptive name than "ptr".

How is all that different than just:

	if (!__run_at_kexec) {
		...
	}

-Scott


