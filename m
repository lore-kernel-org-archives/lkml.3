Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbaAHEJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 23:09:10 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:11823 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbaAHEJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 23:09:06 -0500
Message-ID: <52CCCF24.4080300@huawei.com>
Date: Wed, 8 Jan 2014 12:08:04 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
CC: <akpm@linux-foundation.org>, <jiang.liu@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <iamjoonsoo.kim@lge.com>, <hannes@cmpxchg.org>,
        <tangchen@cn.fujitsu.com>, <tj@kernel.org>, <toshi.kani@hp.com>
Subject: Re: [PATCH 2/2] mm: free memblock.memory in free_all_bootmem
References: <1389107774-54978-1-git-send-email-phacht@linux.vnet.ibm.com> <1389107774-54978-3-git-send-email-phacht@linux.vnet.ibm.com>
In-Reply-To: <1389107774-54978-3-git-send-email-phacht@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.155]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/7 23:16, Philipp Hachtmann wrote:

> When calling free_all_bootmem() the free areas under memblock's
> control are released to the buddy allocator. Additionally the
> reserved list is freed if it was reallocated by memblock.
> The same should apply for the memory list.
> 
> Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
> ---
>  include/linux/memblock.h |  1 +
>  mm/memblock.c            | 12 ++++++++++++
>  mm/nobootmem.c           |  7 ++++++-
>  3 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 77c60e5..d174922 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -52,6 +52,7 @@ phys_addr_t memblock_find_in_range_node(phys_addr_t start, phys_addr_t end,
>  phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
>  				   phys_addr_t size, phys_addr_t align);
>  phys_addr_t get_allocated_memblock_reserved_regions_info(phys_addr_t *addr);
> +phys_addr_t get_allocated_memblock_memory_regions_info(phys_addr_t *addr);
>  void memblock_allow_resize(void);
>  int memblock_add_node(phys_addr_t base, phys_addr_t size, int nid);
>  int memblock_add(phys_addr_t base, phys_addr_t size);
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 53e477b..1a11d04 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -271,6 +271,18 @@ phys_addr_t __init_memblock get_allocated_memblock_reserved_regions_info(
>  			  memblock.reserved.max);
>  }
>  
> +phys_addr_t __init_memblock get_allocated_memblock_memory_regions_info(
> +					phys_addr_t *addr)
> +{
> +	if (memblock.memory.regions == memblock_memory_init_regions)
> +		return 0;
> +
> +	*addr = __pa(memblock.memory.regions);
> +
> +	return PAGE_ALIGN(sizeof(struct memblock_region) *
> +			  memblock.memory.max);
> +}
> +
>  /**
>   * memblock_double_array - double the size of the memblock regions array
>   * @type: memblock type of the regions array being doubled
> diff --git a/mm/nobootmem.c b/mm/nobootmem.c
> index 3a7e14d..83f36d3 100644
> --- a/mm/nobootmem.c
> +++ b/mm/nobootmem.c
> @@ -122,11 +122,16 @@ static unsigned long __init free_low_memory_core_early(void)
>  	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL)
>  		count += __free_memory_core(start, end);
>  
> -	/* free range that is used for reserved array if we allocate it */
> +	/* Free memblock.reserved array if it was allocated */
>  	size = get_allocated_memblock_reserved_regions_info(&start);
>  	if (size)
>  		count += __free_memory_core(start, start + size);
>  
> +	/* Free memblock.memory array if it was allocated */
> +	size = get_allocated_memblock_memory_regions_info(&start);
> +	if (size)
> +		count += __free_memory_core(start, start + size);
> +

Hi Philipp,

For some archs, like arm64, would use memblock.memory after system booting,
so we can not simply released to the buddy allocator, maybe need !defined(CONFIG_ARCH_DISCARD_MEMBLOCK).

#ifdef CONFIG_HAVE_ARCH_PFN_VALID
int pfn_valid(unsigned long pfn)
{
	return memblock_is_memory(pfn << PAGE_SHIFT);
}
EXPORT_SYMBOL(pfn_valid);

Thanks,
Jianguo Wu

>  	return count;
>  }
>  



