Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaDOLG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:06:28 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:17670 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaDOLG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:06:26 -0400
Message-ID: <534D1243.20004@huawei.com>
Date: Tue, 15 Apr 2014 19:04:35 +0800
From: Liu hua <sdu.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wangnan0@huawei.com>, <peifeiyue@huawei.com>, <liusdu@126.com>,
        <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 2/2] ARM : change fixmap mapping region to support
 32 CPUs
References: <1397203252-22977-1-git-send-email-sdu.liu@huawei.com> <1397203252-22977-3-git-send-email-sdu.liu@huawei.com> <alpine.LFD.2.11.1404112314560.980@knanqh.ubzr> <534A9031.5030006@huawei.com> <alpine.LFD.2.11.1404131305120.980@knanqh.ubzr> <534BD488.3020606@huawei.com> <alpine.LFD.2.11.1404140936230.980@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1404140936230.980@knanqh.ubzr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.58.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014/4/14 21:50, Nicolas Pitre 写道:
> On Mon, 14 Apr 2014, Liu hua wrote:
> 
>> Yes, it seems that FIX_KMAP_BEGIN and FIX_KMAP_END are not as important for
>> ARM than that for other architectures (MIPS PowerPC x86), whose FIX_KMAP_BEGIN
>> is not 0. I will reminder this in my patch. Anyone who need them can get
>> imformantion there.
>>
>>
>> Now the new patchs are following. Maybe I sould resend the patch series
>> with a new tag. If It is time to do that. Can I add this information
>> "Reviewed-by: Nicolas Pitre <nico@linaro.org>" ?
>>
>> Thanks,
>> Liu Hua.
>>
>> -----------------patch 1-------------------------
>>
>> Subject: [PATCH 1/2] ARM : fixmap : remove FIX_KMAP_BEGIN and FIX_KMAP_END
>>
>> It seems that these two variables are not used by non
>> architecture specific code. And on ARM FIX_KMAP_BEGIN
>> equals zero; FIX_KMAP_END is totally not used by the
>> kernel.
>>
>> This patch removes these two variables. The code will
>> become clear when I introduce a bugfix on fixmap mapping
> 
> s/clear/clearer/
> 
>> region.
>>
>> Signed-off-by: Liu Hua <sdu.liu@huawei.com>
>> ---
>>  arch/arm/include/asm/fixmap.h | 12 ++++++++----
>>  arch/arm/mm/highmem.c         |  6 +++---
>>  2 files changed, 11 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
>> index bbae919..8675bb9 100644
>> --- a/arch/arm/include/asm/fixmap.h
>> +++ b/arch/arm/include/asm/fixmap.h
>> @@ -17,9 +17,13 @@
>>  #define FIXADDR_TOP		0xfffe0000UL
>>  #define FIXADDR_SIZE		(FIXADDR_TOP - FIXADDR_START)
>>
>> -#define FIX_KMAP_BEGIN		0
>> -#define FIX_KMAP_END		(FIXADDR_SIZE >> PAGE_SHIFT)
>> -
>> +/* Notice : FIX_KMAP_END and FIX_KMAP_BEGIN are removed.
>> + *
>> + * Instead, using FIX_KMAP_NR_PTES to tell the pte number
>> + * belonged to fixmap mapping region.
>> + *
>> + */
> 
> Please move this comment to the commit log instead.  This is not 
> important enough to occupy that much space in the code.
> 
>> +#define FIX_KMAP_NR_PTES	(FIXADDR_SIZE >> PAGE_SHIFT)
>>  #define __fix_to_virt(x)	(FIXADDR_START + ((x) << PAGE_SHIFT))
>>  #define __virt_to_fix(x)	(((x) - FIXADDR_START) >> PAGE_SHIFT)
>>
>> @@ -27,7 +31,7 @@ extern void __this_fixmap_does_not_exist(void);
>>
>>  static inline unsigned long fix_to_virt(const unsigned int idx)
>>  {
>> -	if (idx >= FIX_KMAP_END)
>> +	if (idx >= FIX_KMAP_NR_PTES)
>>  		__this_fixmap_does_not_exist();
>>  	return __fix_to_virt(idx);
>>  }
>> diff --git a/arch/arm/mm/highmem.c b/arch/arm/mm/highmem.c
>> index 21b9e1b..e05e8ad 100644
>> --- a/arch/arm/mm/highmem.c
>> +++ b/arch/arm/mm/highmem.c
>> @@ -63,7 +63,7 @@ void *kmap_atomic(struct page *page)
>>  	type = kmap_atomic_idx_push();
>>
>>  	idx = type + KM_TYPE_NR * smp_processor_id();
>> -	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
>> +	vaddr = __fix_to_virt(idx);
>>  #ifdef CONFIG_DEBUG_HIGHMEM
>>  	/*
>>  	 * With debugging enabled, kunmap_atomic forces that entry to 0.
>> @@ -94,7 +94,7 @@ void __kunmap_atomic(void *kvaddr)
>>  		if (cache_is_vivt())
>>  			__cpuc_flush_dcache_area((void *)vaddr, PAGE_SIZE);
>>  #ifdef CONFIG_DEBUG_HIGHMEM
>> -		BUG_ON(vaddr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
>> +		BUG_ON(vaddr != __fix_to_virt(idx));
>>  		set_top_pte(vaddr, __pte(0));
>>  #else
>>  		(void) idx;  /* to kill a warning */
>> @@ -117,7 +117,7 @@ void *kmap_atomic_pfn(unsigned long pfn)
>>
>>  	type = kmap_atomic_idx_push();
>>  	idx = type + KM_TYPE_NR * smp_processor_id();
>> -	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
>> +	vaddr = __fix_to_virt(idx);
>>  #ifdef CONFIG_DEBUG_HIGHMEM
>>  	BUG_ON(!pte_none(get_top_pte(vaddr)));
>>  #endif
>> -- 
>> 1.9.0
> 
> With the above details fixed you may add:
> 
> Reviewed-by: Nicolas Pitre <nico@linaro.org>
> 
>> -----------------patch 2-------------------------
>>
>>
>>
>> Subject: [PATCH 2/2] ARM : change fixmap mapping region to support 32 CPUs
>>
>> In 32-bit ARM systems, the fixmap mapping region can support
>> no more than 14 CPUs(total: 896k; one CPU: 64K). And we can
>> configure NR_CPUS up to 32. So there is a mismatch.
>>
>> This patch moves fixmapping region downwards to region
>> 0xffc00000-0xffe00000 . Then the fixmap mapping region can
>> support up to 32 CPUs
>>
>> Signed-off-by: Liu Hua <sdu.liu@huawei.com>
>> ---
>>  Documentation/arm/memory.txt   |  2 +-
>>  arch/arm/include/asm/fixmap.h  | 16 ++--------------
>>  arch/arm/include/asm/highmem.h |  1 +
>>  arch/arm/mm/highmem.c          | 27 +++++++++++++++++++++------
>>  arch/arm/mm/mmu.c              |  4 ++++
>>  5 files changed, 29 insertions(+), 21 deletions(-)
>>
>> diff --git a/Documentation/arm/memory.txt b/Documentation/arm/memory.txt
>> index d74e8a5..256c5e0 100644
>> --- a/Documentation/arm/memory.txt
>> +++ b/Documentation/arm/memory.txt
>> @@ -41,7 +41,7 @@ fffe8000	fffeffff	DTCM mapping area for platforms with
>>  fffe0000	fffe7fff	ITCM mapping area for platforms with
>>  				ITCM mounted inside the CPU.
>>
>> -fff00000	fffdffff	Fixmap mapping region.  Addresses provided
>> +fffc0000	ffdfffff	Fixmap mapping region.  Addresses provided
>>  				by fix_to_virt() will be located here.
>>
>>  fee00000	feffffff	Mapping of PCI I/O space. This is a static
>> diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
>> index 8675bb9..fb8a5a7 100644
>> --- a/arch/arm/include/asm/fixmap.h
>> +++ b/arch/arm/include/asm/fixmap.h
>> @@ -1,20 +1,8 @@
>>  #ifndef _ASM_FIXMAP_H
>>  #define _ASM_FIXMAP_H
>>
>> -/*
>> - * Nothing too fancy for now.
>> - *
>> - * On ARM we already have well known fixed virtual addresses imposed by
>> - * the architecture such as the vector page which is located at 0xffff0000,
>> - * therefore a second level page table is already allocated covering
>> - * 0xfff00000 upwards.
>> - *
>> - * The cache flushing code in proc-xscale.S uses the virtual area between
>> - * 0xfffe0000 and 0xfffeffff.
>> - */
>> -
>> -#define FIXADDR_START		0xfff00000UL
>> -#define FIXADDR_TOP		0xfffe0000UL
>> +#define FIXADDR_START		0xffc00000UL
>> +#define FIXADDR_TOP		0xffe00000UL
>>  #define FIXADDR_SIZE		(FIXADDR_TOP - FIXADDR_START)
>>
>>  /* Notice : FIX_KMAP_END and FIX_KMAP_BEGIN are removed.
>> diff --git a/arch/arm/include/asm/highmem.h b/arch/arm/include/asm/highmem.h
>> index 91b99ab..5355795 100644
>> --- a/arch/arm/include/asm/highmem.h
>> +++ b/arch/arm/include/asm/highmem.h
>> @@ -18,6 +18,7 @@
>>  	} while (0)
>>
>>  extern pte_t *pkmap_page_table;
>> +extern pte_t *fixmap_page_table;
>>
>>  extern void *kmap_high(struct page *page);
>>  extern void kunmap_high(struct page *page);
>> diff --git a/arch/arm/mm/highmem.c b/arch/arm/mm/highmem.c
>> index e05e8ad..45aeaac 100644
>> --- a/arch/arm/mm/highmem.c
>> +++ b/arch/arm/mm/highmem.c
>> @@ -18,6 +18,21 @@
>>  #include <asm/tlbflush.h>
>>  #include "mm.h"
>>
>> +pte_t *fixmap_page_table;
>> +
>> +static inline void set_fixmap_pte(int idx, pte_t pte)
>> +{
>> +	unsigned long vaddr = __fix_to_virt(idx);
>> +	set_pte_ext(fixmap_page_table + idx, pte, 0);
>> +	local_flush_tlb_kernel_page(vaddr);
>> +}
>> +
>> +static inline pte_t get_fixmap_pte(unsigned long vaddr)
>> +{
>> +	unsigned long idx = __virt_to_fix(vaddr);
>> +	return *(fixmap_page_table + idx);
>> +}
>> +
>>  void *kmap(struct page *page)
>>  {
>>  	might_sleep();
>> @@ -69,14 +84,14 @@ void *kmap_atomic(struct page *page)
>>  	 * With debugging enabled, kunmap_atomic forces that entry to 0.
>>  	 * Make sure it was indeed properly unmapped.
>>  	 */
>> -	BUG_ON(!pte_none(get_top_pte(vaddr)));
>> +	BUG_ON(!pte_none(*(fixmap_page_table + idx)));
>>  #endif
>>  	/*
>>  	 * When debugging is off, kunmap_atomic leaves the previous mapping
>>  	 * in place, so the contained TLB flush ensures the TLB is updated
>>  	 * with the new mapping.
>>  	 */
>> -	set_top_pte(vaddr, mk_pte(page, kmap_prot));
>> +	set_fixmap_pte(idx, mk_pte(page, kmap_prot));
>>
>>  	return (void *)vaddr;
>>  }
>> @@ -95,7 +110,7 @@ void __kunmap_atomic(void *kvaddr)
>>  			__cpuc_flush_dcache_area((void *)vaddr, PAGE_SIZE);
>>  #ifdef CONFIG_DEBUG_HIGHMEM
>>  		BUG_ON(vaddr != __fix_to_virt(idx));
>> -		set_top_pte(vaddr, __pte(0));
>> +		set_fixmap_pte(idx, __pte(0));
>>  #else
>>  		(void) idx;  /* to kill a warning */
>>  #endif
>> @@ -119,9 +134,9 @@ void *kmap_atomic_pfn(unsigned long pfn)
>>  	idx = type + KM_TYPE_NR * smp_processor_id();
>>  	vaddr = __fix_to_virt(idx);
>>  #ifdef CONFIG_DEBUG_HIGHMEM
>> -	BUG_ON(!pte_none(get_top_pte(vaddr)));
>> +	BUG_ON(!pte_none(*(fixmap_page_table + idx)));
>>  #endif
>> -	set_top_pte(vaddr, pfn_pte(pfn, kmap_prot));
>> +	set_fixmap_pte(idx, pfn_pte(pfn, kmap_prot));
>>
>>  	return (void *)vaddr;
>>  }
>> @@ -133,5 +148,5 @@ struct page *kmap_atomic_to_page(const void *ptr)
>>  	if (vaddr < FIXADDR_START)
>>  		return virt_to_page(ptr);
>>
>> -	return pte_page(get_top_pte(vaddr));
>> +	return pte_page(get_fixmap_pte(vaddr));
>>  }
>> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
>> index b68c6b2..09c0a16 100644
>> --- a/arch/arm/mm/mmu.c
>> +++ b/arch/arm/mm/mmu.c
>> @@ -35,6 +35,7 @@
>>  #include <asm/mach/arch.h>
>>  #include <asm/mach/map.h>
>>  #include <asm/mach/pci.h>
>> +#include <asm/fixmap.h>
>>
>>  #include "mm.h"
>>  #include "tcm.h"
>> @@ -1359,6 +1360,9 @@ static void __init kmap_init(void)
>>  #ifdef CONFIG_HIGHMEM
>>  	pkmap_page_table = early_pte_alloc(pmd_off_k(PKMAP_BASE),
>>  		PKMAP_BASE, _PAGE_KERNEL_TABLE);
>> +
>> +	fixmap_page_table = early_pte_alloc(pmd_off_k(FIXADDR_START),
>> +		FIXADDR_START, _PAGE_KERNEL_TABLE);
>>  #endif
>>  }
>>
>> -- 
>> 1.9.0
> 
> Reviewed-by: Nicolas Pitre <nico@linaro.org>
> 
>>
>>
Ok, I will send the patch series with tag "v3". If there is no
bothersome details. you can add "Reviewed-by:" at than time!

Thanks,
Liu Hua

