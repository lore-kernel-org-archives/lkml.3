Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab3CEOXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:23:33 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:33773 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3CEOXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:23:30 -0500
Date: Tue, 5 Mar 2013 22:23:26 +0800 (HKT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mm: clean-up in order to reduce to call
 kmap_high_get()
In-Reply-To: <1362372609-877-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.LFD.2.03.1303052221010.28820@syhkavp.arg>
References: <1362372609-877-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Mar 2013, Joonsoo Kim wrote:

> In kmap_atomic(), kmap_high_get() is invoked for checking already
> mapped area. In __flush_dcache_page() and dma_cache_maint_page(),
> we explicitly call kmap_high_get() before kmap_atomic()
> when cache_is_vipt(), so kmap_high_get() can be invoked twice.
> This is useless operation, so remove one.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Nicolas Pitre <nico@linaro.org>

> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index c7e3759..b7711be 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -822,16 +822,16 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
>  		if (PageHighMem(page)) {
>  			if (len + offset > PAGE_SIZE)
>  				len = PAGE_SIZE - offset;
> -			vaddr = kmap_high_get(page);
> -			if (vaddr) {
> -				vaddr += offset;
> -				op(vaddr, len, dir);
> -				kunmap_high(page);
> -			} else if (cache_is_vipt()) {
> -				/* unmapped pages might still be cached */
> +			if (cache_is_vipt()) {
>  				vaddr = kmap_atomic(page);
>  				op(vaddr + offset, len, dir);
>  				kunmap_atomic(vaddr);
> +			} else {
> +				vaddr = kmap_high_get(page);
> +				if (vaddr) {
> +					op(vaddr + offset, len, dir);
> +					kunmap_high(page);
> +				}
>  			}
>  		} else {
>  			vaddr = page_address(page) + offset;
> diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
> index 1c8f7f5..e6a03d0 100644
> --- a/arch/arm/mm/flush.c
> +++ b/arch/arm/mm/flush.c
> @@ -170,15 +170,18 @@ void __flush_dcache_page(struct address_space *mapping, struct page *page)
>  	if (!PageHighMem(page)) {
>  		__cpuc_flush_dcache_area(page_address(page), PAGE_SIZE);
>  	} else {
> -		void *addr = kmap_high_get(page);
> -		if (addr) {
> -			__cpuc_flush_dcache_area(addr, PAGE_SIZE);
> -			kunmap_high(page);
> -		} else if (cache_is_vipt()) {
> -			/* unmapped pages might still be cached */
> +		void *addr;
> +
> +		if (cache_is_vipt()) {
>  			addr = kmap_atomic(page);
>  			__cpuc_flush_dcache_area(addr, PAGE_SIZE);
>  			kunmap_atomic(addr);
> +		} else {
> +			addr = kmap_high_get(page);
> +			if (addr) {
> +				__cpuc_flush_dcache_area(addr, PAGE_SIZE);
> +				kunmap_high(page);
> +			}
>  		}
>  	}
>  
> -- 
> 1.7.9.5
> 
