Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaJUAuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 20:50:19 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:57037 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbaJUAuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 20:50:18 -0400
X-Original-SENDERIP: 10.186.123.76
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <5445AD12.9080502@lge.com>
Date: Tue, 21 Oct 2014 09:47:14 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pintu Kumar <pintu.k@samsung.com>, akpm@linux-foundation.org,
        hannes@cmpxchg.org, riel@redhat.com, mgorman@suse.de,
        vdavydov@parallels.com, nasa4836@gmail.com, ddstreet@ieee.org,
        m.szyprowski@samsung.com, mina86@mina86.com, iamjoonsoo.kim@lge.com,
        aneesh.kumar@linux.vnet.ibm.com, lauraa@codeaurora.org,
        rientjes@google.com, vbabka@suse.cz, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
CC: cpgs@samsung.com, pintu_agarwal@yahoo.com, vishnu.ps@samsung.com,
        rohit.kr@samsung.com, ed.savinay@samsung.com,
        =?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>
Subject: Re: [PATCH] mm: cma: split cma-reserved in dmesg log
References: <1413790391-31686-1-git-send-email-pintu.k@samsung.com>
In-Reply-To: <1413790391-31686-1-git-send-email-pintu.k@samsung.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-10-20 오후 4:33, Pintu Kumar 쓴 글:
> When the system boots up, in the dmesg logs we can see
> the memory statistics along with total reserved as below.
> Memory: 458840k/458840k available, 65448k reserved, 0K highmem
> 
> When CMA is enabled, still the total reserved memory remains the same.
> However, the CMA memory is not considered as reserved.
> But, when we see /proc/meminfo, the CMA memory is part of free memory.
> This creates confusion.
> This patch corrects the problem by properly substracting the CMA reserved
> memory from the total reserved memory in dmesg logs.
> 
> Below is the dmesg snaphot from an arm based device with 512MB RAM and
> 12MB single CMA region.
> 
> Before this change:
> Memory: 458840k/458840k available, 65448k reserved, 0K highmem
> 
> After this change:
> Memory: 458840k/458840k available, 53160k reserved, 12288k cma-reserved, 0K highmem
> 
> Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
> Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
> ---
>   include/linux/swap.h | 3 +++
>   mm/cma.c             | 2 ++
>   mm/page_alloc.c      | 8 ++++++++
>   3 files changed, 13 insertions(+)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 37a585b..beb84be 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -295,6 +295,9 @@ static inline void workingset_node_shadows_dec(struct radix_tree_node *node)
>   /* linux/mm/page_alloc.c */
>   extern unsigned long totalram_pages;
>   extern unsigned long totalreserve_pages;
> +#ifdef CONFIG_CMA
> +extern unsigned long totalcma_pages;
> +#endif
>   extern unsigned long dirty_balance_reserve;
>   extern unsigned long nr_free_buffer_pages(void);
>   extern unsigned long nr_free_pagecache_pages(void);
> diff --git a/mm/cma.c b/mm/cma.c
> index 963bc4a..73fe7be 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -45,6 +45,7 @@ struct cma {
>   static struct cma cma_areas[MAX_CMA_AREAS];
>   static unsigned cma_area_count;
>   static DEFINE_MUTEX(cma_mutex);
> +unsigned long totalcma_pages __read_mostly;

I think __read_mostly is not good here.
Cma areas often are rare
but we cannot expect how many cma areas exists.

>   
>   phys_addr_t cma_get_base(struct cma *cma)
>   {
> @@ -288,6 +289,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
>   	if (ret)
>   		goto err;
>   
> +	totalcma_pages += (size / PAGE_SIZE);
>   	pr_info("Reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
>   		(unsigned long)base);
>   	return 0;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index dd73f9a..c6165ac 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5521,6 +5521,9 @@ void __init mem_init_print_info(const char *str)
>   	pr_info("Memory: %luK/%luK available "
>   	       "(%luK kernel code, %luK rwdata, %luK rodata, "
>   	       "%luK init, %luK bss, %luK reserved"
> +#ifdef CONFIG_CMA
> +		", %luK cma-reserved"
> +#endif
>   #ifdef	CONFIG_HIGHMEM
>   	       ", %luK highmem"
>   #endif
> @@ -5528,7 +5531,12 @@ void __init mem_init_print_info(const char *str)
>   	       nr_free_pages() << (PAGE_SHIFT-10), physpages << (PAGE_SHIFT-10),
>   	       codesize >> 10, datasize >> 10, rosize >> 10,
>   	       (init_data_size + init_code_size) >> 10, bss_size >> 10,
> +#ifdef CONFIG_CMA
> +	       (physpages - totalram_pages - totalcma_pages) << (PAGE_SHIFT-10),
> +	       totalcma_pages << (PAGE_SHIFT-10),
> +#else
>   	       (physpages - totalram_pages) << (PAGE_SHIFT-10),
> +#endif
>   #ifdef	CONFIG_HIGHMEM
>   	       totalhigh_pages << (PAGE_SHIFT-10),
>   #endif
> 

I basically agree with your point.
But CMA feature is not popular yet, so memory develoers probably doesn't like this.

I'm not sure but I think there is a debugfs file for cma.
Can you use it?

Or what do you think about making another proc file to show cma area size and address?
For instance,

# cat /proc/cmainfo
CMATotal:    400kB
0x10000000   300kB
0x20000000   100kB

