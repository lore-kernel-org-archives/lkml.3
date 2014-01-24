Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaAXHyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 02:54:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41073 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaAXHyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 02:54:54 -0500
Message-ID: <52E21C3B.50107@ti.com>
Date: Fri, 24 Jan 2014 02:54:35 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Panic on 8-node system in memblock_virt_alloc_try_nid()
References: <52E19C7D.7050603@intel.com> <CAE9FiQX9kTxnaqpWNgg3dUzr7+60YCrEx3q3xxO-G1n6z64xVQ@mail.gmail.com> <52E20A56.1000507@ti.com> <52E20E98.7010703@ti.com> <CAE9FiQWRkP1Hir6UFuPRGu6bXNd_SHonuaC-MG1UD-tSeE0teQ@mail.gmail.com> <52E214C7.9050309@ti.com> <CAE9FiQXEYb5bkLTS9oMUWB_tQ=2-0EUeRDb0DHPS_YH83CC7nA@mail.gmail.com>
In-Reply-To: <CAE9FiQXEYb5bkLTS9oMUWB_tQ=2-0EUeRDb0DHPS_YH83CC7nA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 January 2014 02:46 AM, Yinghai Lu wrote:
>> OK. So we need '__alloc_bootmem_low()' equivalent memblock API. We will try
>> > to come up with a patch for the same. Thanks for inputs.
> Yes,
> 
> Andrew, can you try attached two patches in your setup?
> 
> Assume your system does not have intel iommu support?
> 
You are fast.. I was cooking up very similar patch as yours.
Thanks for help. Its should mostly fix the issue on Andrew's
box after the revert of commit 5b6e529521
 
> 
> ---
>  arch/arm/kernel/setup.c |    2 +-
>  include/linux/bootmem.h |   37 +++++++++++++++++++++++++++++++++++++
>  lib/swiotlb.c           |    4 ++--
>  3 files changed, 40 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/include/linux/bootmem.h
> ===================================================================
> --- linux-2.6.orig/include/linux/bootmem.h
> +++ linux-2.6/include/linux/bootmem.h
> @@ -175,6 +175,27 @@ static inline void * __init memblock_vir
>  						    NUMA_NO_NODE);
>  }
>  
> +#ifndef ARCH_LOW_ADDRESS_LIMIT
> +#define ARCH_LOW_ADDRESS_LIMIT  0xffffffffUL
> +#endif
> +
> +static inline void * __init memblock_virt_alloc_low(
> +                                        phys_addr_t size, phys_addr_t align)
> +{
> +        return memblock_virt_alloc_try_nid(size, align,
> +						   BOOTMEM_LOW_LIMIT,
> +						   ARCH_LOW_ADDRESS_LIMIT,
> +						   NUMA_NO_NODE);
> +}
> +static inline void * __init memblock_virt_alloc_low_nopanic(
> +                                        phys_addr_t size, phys_addr_t align)
> +{
> +        return memblock_virt_alloc_try_nid_nopanic(size, align,
> +						   BOOTMEM_LOW_LIMIT,
> +						   ARCH_LOW_ADDRESS_LIMIT,
> +						   NUMA_NO_NODE);
> +}
> +
>  static inline void * __init memblock_virt_alloc_from_nopanic(
>  		phys_addr_t size, phys_addr_t align, phys_addr_t min_addr)
>  {
> @@ -238,6 +259,22 @@ static inline void * __init memblock_vir
>  	return __alloc_bootmem_nopanic(size, align, BOOTMEM_LOW_LIMIT);
>  }
>  
> +static inline void * __init memblock_virt_alloc_low(
> +                                        phys_addr_t size, phys_addr_t align)
> +{
> +	if (!align)
> +		align = SMP_CACHE_BYTES;
> +	return __alloc_bootmem_low(size, align, BOOTMEM_LOW_LIMIT);
> +}
> +
> +static inline void * __init memblock_virt_alloc_low_nopanic(
> +                                        phys_addr_t size, phys_addr_t align)
> +{
> +	if (!align)
> +		align = SMP_CACHE_BYTES;
> +	return __alloc_bootmem_low_nopanic(size, align, BOOTMEM_LOW_LIMIT);
> +}
> +
>  static inline void * __init memblock_virt_alloc_from_nopanic(
>  		phys_addr_t size, phys_addr_t align, phys_addr_t min_addr)
>  {
> Index: linux-2.6/lib/swiotlb.c
> ===================================================================
> --- linux-2.6.orig/lib/swiotlb.c
> +++ linux-2.6/lib/swiotlb.c
> @@ -172,7 +172,7 @@ int __init swiotlb_init_with_tbl(char *t
>  	/*
>  	 * Get the overflow emergency buffer
>  	 */
> -	v_overflow_buffer = memblock_virt_alloc_nopanic(
> +	v_overflow_buffer = memblock_virt_alloc_low_nopanic(
>  						PAGE_ALIGN(io_tlb_overflow),
>  						PAGE_SIZE);
>  	if (!v_overflow_buffer)
> @@ -220,7 +220,7 @@ swiotlb_init(int verbose)
>  	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
>  
>  	/* Get IO TLB memory from the low pages */
> -	vstart = memblock_virt_alloc_nopanic(PAGE_ALIGN(bytes), PAGE_SIZE);
> +	vstart = memblock_virt_alloc_low_nopanic(PAGE_ALIGN(bytes), PAGE_SIZE);
>  	if (vstart && !swiotlb_init_with_tbl(vstart, io_tlb_nslabs, verbose))
>  		return;
>  
> Index: linux-2.6/arch/arm/kernel/setup.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/kernel/setup.c
> +++ linux-2.6/arch/arm/kernel/setup.c
> @@ -717,7 +717,7 @@ static void __init request_standard_reso
>  	kernel_data.end     = virt_to_phys(_end - 1);
>  
>  	for_each_memblock(memory, region) {
> -		res = memblock_virt_alloc(sizeof(*res), 0);
> +		res = memblock_virt_alloc_low(sizeof(*res), 0);
>  		res->name  = "System RAM";
>  		res->start = __pfn_to_phys(memblock_region_memory_base_pfn(region));
>  		res->end = __pfn_to_phys(memblock_region_memory_end_pfn(region)) - 1;

