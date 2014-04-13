Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbaDMRez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 13:34:55 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:38416 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbaDMRex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 13:34:53 -0400
Date: Sun, 13 Apr 2014 13:34:51 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Liu hua <sdu.liu@huawei.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wangnan0@huawei.com, peifeiyue@huawei.com, liusdu@126.com,
        m.szyprowski@samsung.com
Subject: Re: [PATCH v2 2/2] ARM : change fixmap mapping region to support 32
 CPUs
In-Reply-To: <534A9031.5030006@huawei.com>
Message-ID: <alpine.LFD.2.11.1404131305120.980@knanqh.ubzr>
References: <1397203252-22977-1-git-send-email-sdu.liu@huawei.com> <1397203252-22977-3-git-send-email-sdu.liu@huawei.com> <alpine.LFD.2.11.1404112314560.980@knanqh.ubzr> <534A9031.5030006@huawei.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2014, Liu hua wrote:

> Hi Nicolas.
> 
> Sure, your suggestion made my patch looks better. How about that :
> 
> Thanks,
> Liu Hua

There is something else that bothers me.


> -------------------------------------------------
> 
> Changes from v2:
> 	moved new codes to highmem.c as more as possible.
> 	unchanged Document/arm/memory.txt.
> 
> 
> In 32-bit ARM systems, the fixmap mapping region can support
> no more than 14 CPUs(total: 896k; one CPU: 64K). And we can
> configure NR_CPUS up to 32. So there is a mismatch.
> 
> This patch moves fixmapping region downwards to region
> 0xffc00000-0xffe00000 . Then the fixmap mapping region can
> support up to 32 CPUs
> 
> Acked-by: Nicolas Pitre <nico@linaro.org>
> Signed-off-by: Liu Hua <sdu.liu@huawei.com>
> ---
>  arch/arm/include/asm/fixmap.h  |  4 ++--
>  arch/arm/include/asm/highmem.h |  1 +
>  arch/arm/mm/highmem.c          | 28 ++++++++++++++++++++++------
>  arch/arm/mm/mmu.c              |  4 ++++
>  4 files changed, 29 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
> index bbae919..014a70d 100644
> --- a/arch/arm/include/asm/fixmap.h
> +++ b/arch/arm/include/asm/fixmap.h
> @@ -13,8 +13,8 @@
>   * 0xfffe0000 and 0xfffeffff.
>   */
> 
> -#define FIXADDR_START		0xfff00000UL
> -#define FIXADDR_TOP		0xfffe0000UL
> +#define FIXADDR_START		0xffc00000UL
> +#define FIXADDR_TOP		0xffe00000UL
>  #define FIXADDR_SIZE		(FIXADDR_TOP - FIXADDR_START)
> 
>  #define FIX_KMAP_BEGIN		0
> diff --git a/arch/arm/include/asm/highmem.h b/arch/arm/include/asm/highmem.h
> index 91b99ab..5355795 100644
> --- a/arch/arm/include/asm/highmem.h
> +++ b/arch/arm/include/asm/highmem.h
> @@ -18,6 +18,7 @@
>  	} while (0)
> 
>  extern pte_t *pkmap_page_table;
> +extern pte_t *fixmap_page_table;
> 
>  extern void *kmap_high(struct page *page);
>  extern void kunmap_high(struct page *page);
> diff --git a/arch/arm/mm/highmem.c b/arch/arm/mm/highmem.c
> index 21b9e1b..fa97896 100644
> --- a/arch/arm/mm/highmem.c
> +++ b/arch/arm/mm/highmem.c
> @@ -18,6 +18,22 @@
>  #include <asm/tlbflush.h>
>  #include "mm.h"
> 
> +pte_t *fixmap_page_table;
> +
> +static inline void set_fixmap_pte(int idx, pte_t pte)
> +{
> +	unsigned long vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
> +	set_pte_ext(fixmap_page_table + idx, pte, 0);
> +	local_flush_tlb_kernel_page(vaddr);
> +}
> +
> +static inline pte_t get_fixmap_pte(unsigned long vaddr)
> +{
> +	unsigned long idx = __virt_to_fix(vaddr);
> +	idx -= FIX_KMAP_BEGIN;
> +	return *(fixmap_page_table + idx);

FIX_KMAP_BEGIN represents the starting point for mapping fixmap indices 
to page table entries.  So here you should _add_ the 
FIX_KMAP_BEGIN offset to the page table index not substract it.  
Currently FIX_KMAP_BEGIN is defined to 0 but still.

> +}
> +
>  void *kmap(struct page *page)
>  {
>  	might_sleep();
> @@ -69,14 +85,14 @@ void *kmap_atomic(struct page *page)
>  	 * With debugging enabled, kunmap_atomic forces that entry to 0.
>  	 * Make sure it was indeed properly unmapped.
>  	 */
> -	BUG_ON(!pte_none(get_top_pte(vaddr)));
> +	BUG_ON(!pte_none(*(fixmap_page_table + idx)));

This is therefore also wrong.  It should be
fixmap_page_table + idx + FIX_KMAP_BEGIN.

>  #endif
>  	/*
>  	 * When debugging is off, kunmap_atomic leaves the previous mapping
>  	 * in place, so the contained TLB flush ensures the TLB is updated
>  	 * with the new mapping.
>  	 */
> -	set_top_pte(vaddr, mk_pte(page, kmap_prot));
> +	set_fixmap_pte(idx, mk_pte(page, kmap_prot));
> 
>  	return (void *)vaddr;
>  }
> @@ -95,7 +111,7 @@ void __kunmap_atomic(void *kvaddr)
>  			__cpuc_flush_dcache_area((void *)vaddr, PAGE_SIZE);
>  #ifdef CONFIG_DEBUG_HIGHMEM
>  		BUG_ON(vaddr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
> -		set_top_pte(vaddr, __pte(0));
> +		set_fixmap_pte(idx, __pte(0));
>  #else
>  		(void) idx;  /* to kill a warning */
>  #endif
> @@ -119,9 +135,9 @@ void *kmap_atomic_pfn(unsigned long pfn)
>  	idx = type + KM_TYPE_NR * smp_processor_id();
>  	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
>  #ifdef CONFIG_DEBUG_HIGHMEM
> -	BUG_ON(!pte_none(get_top_pte(vaddr)));
> +	BUG_ON(!pte_none(*(fixmap_page_table + idx)));

Ditto here.

In fact, this FIX_KMAP_BEGIN is only creating more confusing code for 
nothing as we define it to 0 anyway, and it is not used by non 
architecture specific code.  So I'd suggest you create a patch to be 
applied before this one that simply gets rid of FIX_KMAP_BEGIN and 
FIX_KMAP_END altogether.  We could reintroduce them back if ever they're 
needed.


Nicolas
