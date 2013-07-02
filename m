Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab3GBFhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:37:42 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:22970
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097Ab3GBFhk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:37:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz9371I542I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [v2][PATCH 4/7] book3e/kexec/kdump: introduce a kexec kernel
 flag
Thread-Topic: [v2][PATCH 4/7] book3e/kexec/kdump: introduce a kexec kernel
 flag
Thread-Index: AQHObYuffsVpx0tbWEWLMVJd4PeoeZlQ8JMw
Date: Tue, 2 Jul 2013 05:37:36 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D070947A5@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1371714797-7898-1-git-send-email-tiejun.chen@windriver.com>
 <1371714797-7898-5-git-send-email-tiejun.chen@windriver.com>
In-Reply-To: <1371714797-7898-5-git-send-email-tiejun.chen@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.2]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Linuxppc-dev [mailto:linuxppc-dev-
> bounces+bharat.bhushan=freescale.com@lists.ozlabs.org] On Behalf Of Tiejun Chen
> Sent: Thursday, June 20, 2013 1:23 PM
> To: benh@kernel.crashing.org
> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Subject: [v2][PATCH 4/7] book3e/kexec/kdump: introduce a kexec kernel flag
> 
> We need to introduce a flag to indicate we're already running
> a kexec kernel then we can go proper path. For example, We
> shouldn't access spin_table from the bootloader to up any secondary
> cpu for kexec kernel, and kexec kernel already know how to jump to
> generic_secondary_smp_init.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  arch/powerpc/include/asm/smp.h    |    3 +++
>  arch/powerpc/kernel/head_64.S     |   12 ++++++++++++
>  arch/powerpc/kernel/misc_64.S     |    6 ++++++
>  arch/powerpc/platforms/85xx/smp.c |   14 ++++++++++++++
>  4 files changed, 35 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
> index ffbaabe..fbc3d9b 100644
> --- a/arch/powerpc/include/asm/smp.h
> +++ b/arch/powerpc/include/asm/smp.h
> @@ -200,6 +200,9 @@ extern void generic_secondary_thread_init(void);
>  extern unsigned long __secondary_hold_spinloop;
>  extern unsigned long __secondary_hold_acknowledge;
>  extern char __secondary_hold;
> +#if defined(CONFIG_KEXEC) || defined(CONFIG_CRASH_DUMP)
> +extern unsigned long __run_at_kexec;
> +#endif
> 
>  extern void __early_start(void);
>  #endif /* __ASSEMBLY__ */
> diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
> index 3e19ba2..ffa4b18 100644
> --- a/arch/powerpc/kernel/head_64.S
> +++ b/arch/powerpc/kernel/head_64.S
> @@ -89,6 +89,12 @@ __secondary_hold_spinloop:
>  __secondary_hold_acknowledge:
>  	.llong	0x0
> 
> +#if defined(CONFIG_KEXEC) || defined(CONFIG_CRASH_DUMP)
> +	.globl	__run_at_kexec
> +__run_at_kexec:
> +	.llong	0x0	/* Flag for the secondary kernel from kexec. */
> +#endif
> +
>  #ifdef CONFIG_RELOCATABLE
>  	/* This flag is set to 1 by a loader if the kernel should run
>  	 * at the loaded address instead of the linked address.  This
> @@ -417,6 +423,12 @@ _STATIC(__after_prom_start)
>  #if defined(CONFIG_PPC_BOOK3E)
>  	tovirt(r26,r26)			/* on booke, we already run at
> PAGE_OFFSET */
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
> diff --git a/arch/powerpc/platforms/85xx/smp.c
> b/arch/powerpc/platforms/85xx/smp.c
> index 6a17599..b308373 100644
> --- a/arch/powerpc/platforms/85xx/smp.c
> +++ b/arch/powerpc/platforms/85xx/smp.c
> @@ -150,6 +150,9 @@ static int __cpuinit smp_85xx_kick_cpu(int nr)
>  	int hw_cpu = get_hard_smp_processor_id(nr);
>  	int ioremappable;
>  	int ret = 0;
> +#if defined(CONFIG_KEXEC) || defined(CONFIG_CRASH_DUMP)
> +	unsigned long *ptr;
> +#endif

What about if we can remove the ifdef around *ptr ...

> 
>  	WARN_ON(nr < 0 || nr >= NR_CPUS);
>  	WARN_ON(hw_cpu < 0 || hw_cpu >= NR_CPUS);
> @@ -238,11 +241,22 @@ out:
>  #else
>  	smp_generic_kick_cpu(nr);
> 
> +#if defined(CONFIG_KEXEC) || defined(CONFIG_CRASH_DUMP)
> +	ptr  = (unsigned long *)((unsigned long)&__run_at_kexec);

... #endif here ...

> +	/* We shouldn't access spin_table from the bootloader to up any
> +	 * secondary cpu for kexec kernel, and kexec kernel already
> +	 * know how to jump to generic_secondary_smp_init.
> +	 */
> +	if (!*ptr) {
> +#endif

... remove #endif ...

>  	flush_spin_table(spin_table);
>  	out_be32(&spin_table->pir, hw_cpu);
>  	out_be64((u64 *)(&spin_table->addr_h),
>  	  __pa((u64)*((unsigned long long *)generic_secondary_smp_init)));
>  	flush_spin_table(spin_table);
> +#if defined(CONFIG_KEXEC) || defined(CONFIG_CRASH_DUMP)
> +	}
> +#endif

--- remove above 3 lines

-Bharat

>  #endif
> 
>  	local_irq_restore(flags);
> --
> 1.7.9.5
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


