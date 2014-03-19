Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbaCSUmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:42:42 -0400
Received: from mail-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:58674
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753121AbaCSUmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:42:40 -0400
Date: Wed, 19 Mar 2014 15:42:31 -0500
From: Scott Wood <scottwood@freescale.com>
To: LEROY Christophe <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, v3] powerpc: Loading kernels over 8Mbytes without
 CONFIG_PIN_TLB
Message-ID: <20140319204230.GA13767@home.buserror.net>
References: <20131215150957.1F5C143E5B@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131215150957.1F5C143E5B@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BY2PR02CA002.namprd02.prod.outlook.com (10.255.247.22) To
 BL2PR03MB388.namprd03.prod.outlook.com (10.141.91.153)
X-Forefront-PRVS: 01559F388D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(979002)(6009001)(428001)(51704005)(24454002)(189002)(199002)(77982001)(59766001)(92726001)(95416001)(92566001)(65816001)(46102001)(80022001)(93516002)(93136001)(56816005)(76786001)(83072002)(16601075003)(77096001)(81342001)(76796001)(79102001)(85852003)(94946001)(69226001)(19580405001)(19580395003)(87976001)(15202345003)(74502001)(47446002)(47776003)(86362001)(81542001)(63696002)(83322001)(94316002)(90146001)(20776003)(51856001)(95666003)(74706001)(74876001)(33656001)(76482001)(81816001)(31966008)(54316002)(47736001)(4396001)(85306002)(56776001)(23756003)(53416003)(81686001)(97336001)(97186001)(47976001)(49866001)(83506001)(87266001)(74662001)(50986001)(80976001)(50466002)(74366001)(54356001)(53806001)(15975445006)(42186004)(3826001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB388;H:home.buserror.net;FPR:BE8DF5D6.95C297D1.F9F4157F.9295219.20582;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 04:09:57PM +0100, LEROY Christophe wrote:
> Hereunder is a try to implement the sizing of the initial memory size based on
> initial-mapped-area size given by uboot in r7.
> As this has an impact on all powerpc platforms due to the need to provide the
> info up to function setup_initial_memory_limit(), I'm not completly sure of the
> proper implementation.
> Thanks to provide comments.
> 
> Today on the 8xx, the only way to load kernels whose size is greater than
> 8Mbytes is to activate CONFIG_PIN_TLB. Otherwise, the physical memory initially
> mapped is limited to 8Mbytes. This patch uses the size of initial memory mapped
> by the bootloader and given to the kernel through register r7.
> This is done regardless of whether CONFIG_PIN_TLB is active or not. It allows to
> load "big" kernels (for instance when activating CONFIG_LOCKDEP_SUPPORT) without
> having to activate CONFIG_PIN_TLB.
> 
> Not-yet-signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> ---
> Ce courrier électronique ne contient aucun virus ou logiciel malveillant parce que la protection avast! Antivirus est active.
> http://www.avast.com
> 
> Index: linux/arch/powerpc/include/asm/mmu.h
> ===================================================================
> --- linux/arch/powerpc/include/asm/mmu.h	(revision 5484)
> +++ linux/arch/powerpc/include/asm/mmu.h	(copie de travail)
> @@ -138,7 +138,8 @@
>  extern void early_init_mmu_secondary(void);
>  
>  extern void setup_initial_memory_limit(phys_addr_t first_memblock_base,
> -				       phys_addr_t first_memblock_size);
> +				       phys_addr_t first_memblock_size,
> +				       u64 init_mem_size);

What is the difference between first_memblock_size and init_mem_size, in
terms of what you expect setup_initial_memory_limit to do with them?

Can you just pass in min(first_memblock_size, init_mem_size), with the
non-ePAPR fallback handled in head_8xx.S (just load r30 with 8M instead
of zero)?

>  #ifdef CONFIG_PPC64
>  /* This is our real memory area size on ppc64 server, on embedded, we
> Index: linux/arch/powerpc/kernel/head_8xx.S
> ===================================================================
> --- linux/arch/powerpc/kernel/head_8xx.S	(revision 5484)
> +++ linux/arch/powerpc/kernel/head_8xx.S	(copie de travail)
> @@ -31,6 +31,8 @@
>  #include <asm/asm-offsets.h>
>  #include <asm/ptrace.h>
>  
> +#define EPAPR_MAGIC	0x65504150
> +
>  /* Macro to make the code more readable. */
>  #ifdef CONFIG_8xx_CPU6
>  #define DO_8xx_CPU6(val, reg)	\
> @@ -77,10 +79,19 @@
>  	.globl	__start
>  __start:
>  	mr	r31,r3			/* save device tree ptr */
> +	li	r30,0
>  
> +	lis	r8,EPAPR_MAGIC@h
> +	ori	r8,r8, EPAPR_MAGIC@l
> +	cmpw	cr0,r8, r6

Whitespace

> +	bne	1f
> +
> +	mr	r30,r7			/* save initial ram size */
> +
>  	/* We have to turn on the MMU right away so we get cache modes
>  	 * set correctly.
>  	 */
> +1:
>  	bl	initial_mmu
>  
>  /* We now have the lower 8 Meg mapped into TLB entries, and the caches
> @@ -717,6 +728,8 @@
>   */
>  	li	r3,0
>  	mr	r4,r31
> +	li	r5,0
> +	mr	r6,r30
>  	bl	machine_init
>  	bl	MMU_init
>  
> @@ -841,11 +854,17 @@
>  	ori	r8, r8, MI_BOOTINIT|0x2 /* Inhibit cache -- Cort */
>  	mtspr	SPRN_MD_RPN, r8
>  
> +	/* Map two more 8M kernel data pages if needed
> +	 * We check how much memory is mapped by the bootloader
> +	*/

Whitespace

> Index: linux/arch/powerpc/kernel/prom.c
> ===================================================================
> --- linux/arch/powerpc/kernel/prom.c	(revision 5484)
> +++ linux/arch/powerpc/kernel/prom.c	(copie de travail)
> @@ -649,7 +649,7 @@
>  	}
>  }
>  
> -void __init early_init_devtree(void *params)
> +void __init early_init_devtree(void *params, u64 init_mem_size)
>  {
>  	phys_addr_t limit;
>  
> @@ -697,7 +697,7 @@
>  	/* make sure we've parsed cmdline for mem= before this */
>  	if (memory_limit)
>  		first_memblock_size = min_t(u64, first_memblock_size, memory_limit);
> -	setup_initial_memory_limit(memstart_addr, first_memblock_size);
> +	setup_initial_memory_limit(memstart_addr, first_memblock_size, init_mem_size);

Line length.
Yes, I know there's an existing violation on the previous line. :-)

> Index: linux/arch/powerpc/mm/init_32.c
> ===================================================================
> --- linux/arch/powerpc/mm/init_32.c	(revision 5484)
> +++ linux/arch/powerpc/mm/init_32.c	(copie de travail)
> @@ -206,19 +206,16 @@
>  
>  #ifdef CONFIG_8xx /* No 8xx specific .c file to put that in ... */
>  void setup_initial_memory_limit(phys_addr_t first_memblock_base,
> -				phys_addr_t first_memblock_size)
> +				phys_addr_t first_memblock_size,
> +				u64 init_mem_size)
>  {
>  	/* We don't currently support the first MEMBLOCK not mapping 0
>  	 * physical on those processors
>  	 */
>  	BUG_ON(first_memblock_base != 0);
>  
> -#ifdef CONFIG_PIN_TLB
> -	/* 8xx can only access 24MB at the moment */
> -	memblock_set_current_limit(min_t(u64, first_memblock_size, 0x01800000));
> -#else
> -	/* 8xx can only access 8MB at the moment */
> -	memblock_set_current_limit(min_t(u64, first_memblock_size, 0x00800000));
> -#endif
> +	if (!init_mem_size)
> +		init_mem_size = 0x00800000;
> +	memblock_set_current_limit(min_t(u64, first_memblock_size, init_mem_size));

Line length

>  }
>  #endif /* CONFIG_8xx */
> Index: linux/arch/powerpc/mm/ppc_mmu_32.c
> ===================================================================
> --- linux/arch/powerpc/mm/ppc_mmu_32.c	(revision 5484)
> +++ linux/arch/powerpc/mm/ppc_mmu_32.c	(copie de travail)
> @@ -273,7 +273,8 @@
>  }
>  
>  void setup_initial_memory_limit(phys_addr_t first_memblock_base,
> -				phys_addr_t first_memblock_size)
> +				phys_addr_t first_memblock_size,
> +				u64 init_mem_size)
>  {
>  	/* We don't currently support the first MEMBLOCK not mapping 0
>  	 * physical on those processors
> Index: linux/arch/powerpc/mm/tlb_nohash.c
> ===================================================================
> --- linux/arch/powerpc/mm/tlb_nohash.c	(revision 5484)
> +++ linux/arch/powerpc/mm/tlb_nohash.c	(copie de travail)
> @@ -654,7 +654,8 @@
>  }
>  
>  void setup_initial_memory_limit(phys_addr_t first_memblock_base,
> -				phys_addr_t first_memblock_size)
> +				phys_addr_t first_memblock_size,
> +				u64 init_mem_size)
>  {
>  	/* On non-FSL Embedded 64-bit, we adjust the RMA size to match
>  	 * the bolted TLB entry. We know for now that only 1G

It seems a bit odd for this function to take init_mem_size on these other
platforms, but not use it.

-Scott
