Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3CZWpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:45:42 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:53158 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3CZWpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:45:39 -0400
Date: Tue, 26 Mar 2013 15:45:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: devel@driverdev.osuosl.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: zsmalloc: Fix link error on ARM
Message-ID: <20130326224536.GA29952@kroah.com>
References: <1364337232-3513-1-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364337232-3513-1-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 11:33:52PM +0100, Joerg Roedel wrote:
> Testing the arm chromebook config against the upstream
> kernel produces a linker error for the zsmalloc module from
> staging. The symbol flush_tlb_kernel_range is not available
> there. Fix this by removing the reimplementation of
> unmap_kernel_range in the zsmalloc module and using the
> function directly.
> 
> Signed-off-by: Joerg Roedel <joro@8bytes.org>

Why is this not an error for any other architecture?  Why is arm
special?

> ---
>  drivers/staging/zsmalloc/zsmalloc-main.c |    5 +----
>  mm/vmalloc.c                             |    1 +
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> index e78d262..324e123 100644
> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> @@ -656,11 +656,8 @@ static inline void __zs_unmap_object(struct mapping_area *area,
>  				struct page *pages[2], int off, int size)
>  {
>  	unsigned long addr = (unsigned long)area->vm_addr;
> -	unsigned long end = addr + (PAGE_SIZE * 2);
>  
> -	flush_cache_vunmap(addr, end);
> -	unmap_kernel_range_noflush(addr, PAGE_SIZE * 2);
> -	flush_tlb_kernel_range(addr, end);
> +	unmap_kernel_range(addr, PAGE_SIZE * 2);
>  }
>  
>  #else /* USE_PGTABLE_MAPPING */
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 0f751f2..f7cba11 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1266,6 +1266,7 @@ void unmap_kernel_range(unsigned long addr, unsigned long size)
>  	vunmap_page_range(addr, end);
>  	flush_tlb_kernel_range(addr, end);
>  }
> +EXPORT_SYMBOL_GPL(unmap_kernel_range);

I _really_ don't like adding core exports for a staging driver, there is
no guarantee that the staging driver will not just be deleted tomorrow.

So, if at all possible, I don't want to do this.

Perhaps, just make it so the staging code can't be a module?

greg k-h
