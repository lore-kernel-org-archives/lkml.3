Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293Ab3K1Rmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:42:32 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:65500 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab3K1Rmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:42:31 -0500
Date: Thu, 28 Nov 2013 18:41:57 +0100
From: Vladimir Murzin <murzin.v@gmail.com>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com,
        zhangyanfei@cn.fujitsu.com, liwanp@linux.vnet.ibm.com,
        rientjes@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]mm/vmalloc: interchage the implementation of
 vmalloc_to_{pfn,page}
Message-ID: <20131128174152.GA2258@hp530>
References: <20131128162913.GA4234@lcx>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20131128162913.GA4234@lcx>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:29:13AM +0800, Jianyu Zhan wrote:
> Currently we are implementing vmalloc_to_pfn() as a wrapper of 
> vmalloc_to_page(), which is implemented as follow: 
> 
>  1. walks the page talbes to generates the corresponding pfn,
>  2. then wraps the pfn to struct page,
>  3. returns it.
> 
> And vmalloc_to_pfn() re-wraps the vmalloc_to_page() to get the pfn.
> 
> This seems too circuitous, so this patch reverses the way:
> implementing the vmalloc_to_page() as a wrapper of vmalloc_to_pfn().
> This makes vmalloc_to_pfn() and vmalloc_to_page() slightly effective.

Any numbers for efficiency?

> 

> No functional change. 
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
> mm/vmalloc.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 0fdf968..a335e21 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -220,12 +220,12 @@ int is_vmalloc_or_module_addr(const void *x)
>  }
>  
>  /*
> - * Walk a vmap address to the struct page it maps.
> + * Walk a vmap address to the physical pfn it maps to.
>   */
> -struct page *vmalloc_to_page(const void *vmalloc_addr)
> +unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
>  {
>  	unsigned long addr = (unsigned long) vmalloc_addr;
> -	struct page *page = NULL;
> +	unsigned long pfn;

uninitialized pfn will lead to a bug.

>  	pgd_t *pgd = pgd_offset_k(addr);
>  
>  	/*
> @@ -244,23 +244,23 @@ struct page *vmalloc_to_page(const void *vmalloc_addr)
>  				ptep = pte_offset_map(pmd, addr);
>  				pte = *ptep;
>  				if (pte_present(pte))
> -					page = pte_page(pte);
> +					pfn = pte_page(pte);

page_to_pfn is missed here.

Have you ever tested there is no functional changes?

Vladimir

>  				pte_unmap(ptep);
>  			}
>  		}
>  	}
> -	return page;
> +	return pfn;
>  }
> -EXPORT_SYMBOL(vmalloc_to_page);
> +EXPORT_SYMBOL(vmalloc_to_pfn);
>  
>  /*
> - * Map a vmalloc()-space virtual address to the physical page frame number.
> + * Map a vmalloc()-space virtual address to the struct page.
>   */
> -unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
> +struct page *vmalloc_to_page(const void *vmalloc_addr)
>  {
> -	return page_to_pfn(vmalloc_to_page(vmalloc_addr));
> +	return pfn_to_page(vmalloc_to_pfn(vmalloc_addr));
>  }
> -EXPORT_SYMBOL(vmalloc_to_pfn);
> +EXPORT_SYMBOL(vmalloc_to_page);
>  
>  
>  /*** Global kva allocator ***/
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
