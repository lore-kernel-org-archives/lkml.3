Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaKCX51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:57:27 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:61126 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaKCX5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:57:25 -0500
Date: Mon, 3 Nov 2014 15:57:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pintu Kumar <pintu.k@samsung.com>
cc: akpm@linux-foundation.org, riel@redhat.com, aquini@redhat.com,
        paul.gortmaker@windriver.com, jmarchan@redhat.com,
        lcapitulino@redhat.com, kirill.shutemov@linux.intel.com,
        m.szyprowski@samsung.com, aneesh.kumar@linux.vnet.ibm.com,
        iamjoonsoo.kim@lge.com, mina86@mina86.com, lauraa@codeaurora.org,
        gioh.kim@lge.com, mgorman@suse.de, hannes@cmpxchg.org, vbabka@suse.cz,
        sasha.levin@oracle.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, pintu_agarwal@yahoo.com, cpgs@samsung.com,
        vishnu.ps@samsung.com, rohit.kr@samsung.com, ed.savinay@samsung.com
Subject: Re: [PATCH v2 1/2] mm: cma: split cma-reserved in dmesg log
In-Reply-To: <1413986796-19732-1-git-send-email-pintu.k@samsung.com>
Message-ID: <alpine.DEB.2.10.1411031556140.9845@chino.kir.corp.google.com>
References: <1413790391-31686-1-git-send-email-pintu.k@samsung.com> <1413986796-19732-1-git-send-email-pintu.k@samsung.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014, Pintu Kumar wrote:

> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 0430ed0..0b75896 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -15,6 +15,7 @@
>  
>  struct cma;
>  
> +extern unsigned long totalcma_pages;
>  extern phys_addr_t cma_get_base(struct cma *cma);
>  extern unsigned long cma_get_size(struct cma *cma);
>  
> diff --git a/mm/cma.c b/mm/cma.c
> index 963bc4a..8435762 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -288,6 +288,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
>  	if (ret)
>  		goto err;
>  
> +	totalcma_pages += (size / PAGE_SIZE);
>  	pr_info("Reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
>  		(unsigned long)base);
>  	return 0;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index dd73f9a..ababbd8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -110,6 +110,7 @@ static DEFINE_SPINLOCK(managed_page_count_lock);
>  
>  unsigned long totalram_pages __read_mostly;
>  unsigned long totalreserve_pages __read_mostly;
> +unsigned long totalcma_pages __read_mostly;

Shouldn't this be __initdata instead?

>  /*
>   * When calculating the number of globally allowed dirty pages, there
>   * is a certain number of per-zone reserves that should not be
> @@ -5520,7 +5521,7 @@ void __init mem_init_print_info(const char *str)
>  
>  	pr_info("Memory: %luK/%luK available "
>  	       "(%luK kernel code, %luK rwdata, %luK rodata, "
> -	       "%luK init, %luK bss, %luK reserved"
> +	       "%luK init, %luK bss, %luK reserved, %luK cma-reserved"
>  #ifdef	CONFIG_HIGHMEM
>  	       ", %luK highmem"
>  #endif
> @@ -5528,7 +5529,8 @@ void __init mem_init_print_info(const char *str)
>  	       nr_free_pages() << (PAGE_SHIFT-10), physpages << (PAGE_SHIFT-10),
>  	       codesize >> 10, datasize >> 10, rosize >> 10,
>  	       (init_data_size + init_code_size) >> 10, bss_size >> 10,
> -	       (physpages - totalram_pages) << (PAGE_SHIFT-10),
> +	       (physpages - totalram_pages - totalcma_pages) << (PAGE_SHIFT-10),
> +	       totalcma_pages << (PAGE_SHIFT-10),
>  #ifdef	CONFIG_HIGHMEM
>  	       totalhigh_pages << (PAGE_SHIFT-10),
>  #endif
