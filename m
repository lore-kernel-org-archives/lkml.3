Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbaAWTPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:15:14 -0500
Received: from relais.videotron.ca ([24.201.245.36]:45558 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbaAWTPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:15:09 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 23 Jan 2014 14:15:07 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Wang Nan <wangnan0@huawei.com>
Cc: kexec@lists.infradead.org, Eric Biederman <ebiederm@xmission.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geng Hui <hui.geng@huawei.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: allow kernel to be loaded in middle of phymem
In-reply-to: <1390389916-8711-4-git-send-email-wangnan0@huawei.com>
Message-id: <alpine.LFD.2.11.1401231357520.1652@knanqh.ubzr>
References: <1390389916-8711-1-git-send-email-wangnan0@huawei.com>
 <1390389916-8711-4-git-send-email-wangnan0@huawei.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014, Wang Nan wrote:

> This patch allows the kernel to be loaded at the middle of kernel awared
> physical memory. Before this patch, users must use mem= or device tree to cheat
> kernel about the start address of physical memory.
> 
> This feature is useful in some special cases, for example, building a crash
> dump kernel. Without it, kernel command line, atag and devicetree must be
> adjusted carefully, sometimes is impossible.

With CONFIG_PATCH_PHYS_VIRT the value for PHYS_OFFSET is determined 
dynamically by rounding down the kernel image start address to the 
previous 16MB boundary.  In the case of a crash kernel, this might be 
cleaner to simply readjust __pv_phys_offset during early boot and call 
fixup_pv_table(), and then reserve away the memory from the previous 
kernel.  That will let you access that memory directly (with gdb for 
example) and no pointer address translation will be required.


> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Cc: <stable@vger.kernel.org> # 3.4+
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Geng Hui <hui.geng@huawei.com>
> ---
>  arch/arm/mm/init.c | 21 ++++++++++++++++++++-
>  arch/arm/mm/mmu.c  | 13 +++++++++++++
>  mm/page_alloc.c    |  7 +++++--
>  3 files changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index 3e8f106..4952726 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -334,9 +334,28 @@ void __init arm_memblock_init(struct meminfo *mi,
>  {
>  	int i;
>  
> -	for (i = 0; i < mi->nr_banks; i++)
> +	for (i = 0; i < mi->nr_banks; i++) {
>  		memblock_add(mi->bank[i].start, mi->bank[i].size);
>  
> +		/*
> +		 * In some special case, for example, building a crushdump
> +		 * kernel, we want the kernel to be loaded in the middle of
> +		 * physical memory. In such case, the physical memory before
> +		 * PHYS_OFFSET is awkward: it can't get directly mapped
> +		 * (because its address will be smaller than PAGE_OFFSET,
> +		 * disturbs user address space) also can't be mapped as
> +		 * HighMem. We reserve such pages here. The only way to access
> +		 * those pages is ioremap.
> +		 */
> +		if (mi->bank[i].start < PHYS_OFFSET) {
> +			unsigned long reserv_size = PHYS_OFFSET -
> +						    mi->bank[i].start;
> +			if (reserv_size > mi->bank[i].size)
> +				reserv_size = mi->bank[i].size;
> +			memblock_reserve(mi->bank[i].start, reserv_size);
> +		}
> +	}
> +
>  	/* Register the kernel text, kernel data and initrd with memblock. */
>  #ifdef CONFIG_XIP_KERNEL
>  	memblock_reserve(__pa(_sdata), _end - _sdata);
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index 580ef2d..2a17c24 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -1308,6 +1308,19 @@ static void __init map_lowmem(void)
>  		if (start >= end)
>  			break;
>  
> +		/*
> +		 * If this memblock contain memory before PAGE_OFFSET, memory
> +		 * before PAGE_OFFSET should't get directly mapped, see code
> +		 * in create_mapping(). However, memory after PAGE_OFFSET is
> +		 * occupyed by kernel and still need to be mapped.
> +		 */
> +		if (__phys_to_virt(start) < PAGE_OFFSET) {
> +			if (__phys_to_virt(end) > PAGE_OFFSET)
> +				start = __virt_to_phys(PAGE_OFFSET);
> +			else
> +				break;
> +		}
> +
>  		map.pfn = __phys_to_pfn(start);
>  		map.virtual = __phys_to_virt(start);
>  		map.length = end - start;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5248fe0..d2959e3 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4840,10 +4840,13 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
>  	 */
>  	if (pgdat == NODE_DATA(0)) {
>  		mem_map = NODE_DATA(0)->node_mem_map;
> -#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
> +		/*
> +		 * In case of CONFIG_HAVE_MEMBLOCK_NODE_MAP or when kernel
> +		 * loaded at the middle of physical memory, mem_map should
> +		 * be adjusted.
> +		 */
>  		if (page_to_pfn(mem_map) != pgdat->node_start_pfn)
>  			mem_map -= (pgdat->node_start_pfn - ARCH_PFN_OFFSET);
> -#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
>  	}
>  #endif
>  #endif /* CONFIG_FLAT_NODE_MEM_MAP */
> -- 
> 1.8.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
