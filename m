Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaKRRlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:41:53 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:54047 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbaKRRlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:41:52 -0500
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Nov 2014 12:41:51 EST
Date: Tue, 18 Nov 2014 17:34:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: Re: [PATCH RFC] ARM: option for loading modules into vmalloc area
Message-ID: <20141118173413.GB4042@n2100.arm.linux.org.uk>
References: <20141118172146.3784.81151.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118172146.3784.81151.stgit@buzz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 08:21:46PM +0400, Konstantin Khlebnikov wrote:
> Usually modules are loaded into small area prior to the kernel
> text because they are linked with the kernel using short calls.
> Compile-time instrumentation like GCOV or KASAN bloats code a lot,
> and as a result huge modules no longer fit into reserved area.
> 
> This patch adds option CONFIG_MODULES_USE_VMALLOC which lifts
> limitation on amount of loaded modules. It links modules using
> long-calls (option -mlong-calls) and loads them into vmalloc area.
> 
> In few places exported symbols are called from inline assembly.
> This patch adds macro for such call sites: __asmbl and __asmbl_clobber.
> Call turns into single 'bl' or sequence 'movw; movt; blx' depending on
> context and state of config option.
> 
> Unfortunately this option isn't compatible with CONFIG_FUNCTION_TRACER.
> Compiler emits short calls to profiling function despite of -mlong-calls.
> This is a bug in GCC, but ftrace anyway needs an update to handle this.

It also isn't compatible with the older architectures which don't have
"blx".

> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index 9d2cdda..9e0c4f4 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -1161,16 +1161,15 @@ void __init sanity_check_meminfo(void)
>  
>  static inline void prepare_page_table(void)
>  {
> -	unsigned long addr;
> +	unsigned long addr = 0;
>  	phys_addr_t end;
>  
>  	/*
>  	 * Clear out all the mappings below the kernel image.
>  	 */
> -	for (addr = 0; addr < MODULES_VADDR; addr += PMD_SIZE)
> -		pmd_clear(pmd_off_k(addr));
> -
>  #ifdef CONFIG_XIP_KERNEL
> +	for ( ; addr < MODULES_VADDR; addr += PMD_SIZE)
> +		pmd_clear(pmd_off_k(addr));
>  	/* The XIP kernel is mapped in the module area -- skip over it */
>  	addr = ((unsigned long)_etext + PMD_SIZE - 1) & PMD_MASK;
>  #endif

This seems to be an unrelated change.  In any case, it looks wrong to
me.  Please describe what you are trying to achieve here.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
