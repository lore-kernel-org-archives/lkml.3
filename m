Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab3GBFRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:17:46 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:11106
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752238Ab3GBFRo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:17:44 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz9371I542I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [v2][PATCH 2/7] book3e/kexec/kdump: enable kexec for kernel
Thread-Topic: [v2][PATCH 2/7] book3e/kexec/kdump: enable kexec for kernel
Thread-Index: AQHObYt29qejOZCGXUuucHOLgILTs5lQ6qfw
Date: Tue, 2 Jul 2013 05:17:39 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D07094779@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1371714797-7898-1-git-send-email-tiejun.chen@windriver.com>
 <1371714797-7898-3-git-send-email-tiejun.chen@windriver.com>
In-Reply-To: <1371714797-7898-3-git-send-email-tiejun.chen@windriver.com>
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
> Subject: [v2][PATCH 2/7] book3e/kexec/kdump: enable kexec for kernel
> 
> We need to active KEXEC for book3e and bypass or convert non-book3e stuff
> in kexec coverage.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  arch/powerpc/Kconfig                   |    2 +-
>  arch/powerpc/kernel/machine_kexec_64.c |    6 ++++++
>  arch/powerpc/kernel/misc_64.S          |    6 ++++++
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index c33e3ad..6ecf3c9 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -364,7 +364,7 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
> 
>  config KEXEC
>  	bool "kexec system call"
> -	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP))
> +	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP)) || PPC_BOOK3E
>  	help
>  	  kexec is a system call that implements the ability to shutdown your
>  	  current kernel, and to start another kernel.  It is like a reboot
> diff --git a/arch/powerpc/kernel/machine_kexec_64.c
> b/arch/powerpc/kernel/machine_kexec_64.c
> index 611acdf..ef39271 100644
> --- a/arch/powerpc/kernel/machine_kexec_64.c
> +++ b/arch/powerpc/kernel/machine_kexec_64.c
> @@ -33,6 +33,7 @@
>  int default_machine_kexec_prepare(struct kimage *image)
>  {
>  	int i;
> +#ifndef CONFIG_PPC_BOOK3E
>  	unsigned long begin, end;	/* limits of segment */
>  	unsigned long low, high;	/* limits of blocked memory range */
>  	struct device_node *node;
> @@ -41,6 +42,7 @@ int default_machine_kexec_prepare(struct kimage *image)
> 
>  	if (!ppc_md.hpte_clear_all)
>  		return -ENOENT;
> +#endif

Do we really need this function for book3e? can we have a separate function rather than multiple confusing ifdef?

-Bharat

> 
>  	/*
>  	 * Since we use the kernel fault handlers and paging code to
> @@ -51,6 +53,7 @@ int default_machine_kexec_prepare(struct kimage *image)
>  		if (image->segment[i].mem < __pa(_end))
>  			return -ETXTBSY;
> 
> +#ifndef CONFIG_PPC_BOOK3E
>  	/*
>  	 * For non-LPAR, we absolutely can not overwrite the mmu hash
>  	 * table, since we are still using the bolted entries in it to
> @@ -92,6 +95,7 @@ int default_machine_kexec_prepare(struct kimage *image)
>  				return -ETXTBSY;
>  		}
>  	}
> +#endif
> 
>  	return 0;
>  }
> @@ -367,6 +371,7 @@ void default_machine_kexec(struct kimage *image)
>  	/* NOTREACHED */
>  }
> 
> +#ifndef CONFIG_PPC_BOOK3E
>  /* Values we need to export to the second kernel via the device tree. */
>  static unsigned long htab_base;
> 
> @@ -411,3 +416,4 @@ static int __init export_htab_values(void)
>  	return 0;
>  }
>  late_initcall(export_htab_values);
> +#endif
> diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
> index 6820e45..f1a7ce7 100644
> --- a/arch/powerpc/kernel/misc_64.S
> +++ b/arch/powerpc/kernel/misc_64.S
> @@ -543,9 +543,13 @@ _GLOBAL(kexec_sequence)
>  	lhz	r25,PACAHWCPUID(r13)	/* get our phys cpu from paca */
> 
>  	/* disable interrupts, we are overwriting kernel data next */
> +#ifndef CONFIG_PPC_BOOK3E
>  	mfmsr	r3
>  	rlwinm	r3,r3,0,17,15
>  	mtmsrd	r3,1
> +#else
> +	wrteei	0
> +#endif
> 
>  	/* copy dest pages, flush whole dest image */
>  	mr	r3,r29
> @@ -567,10 +571,12 @@ _GLOBAL(kexec_sequence)
>  	li	r6,1
>  	stw	r6,kexec_flag-1b(5)
> 
> +#ifndef CONFIG_PPC_BOOK3E
>  	/* clear out hardware hash page table and tlb */
>  	ld	r5,0(r27)		/* deref function descriptor */
>  	mtctr	r5
>  	bctrl				/* ppc_md.hpte_clear_all(void); */
> +#endif
> 
>  /*
>   *   kexec image calling is:
> --
> 1.7.9.5
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


