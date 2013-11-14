Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab3KNAJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 19:09:19 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:48100 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3KNAJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 19:09:13 -0500
Message-ID: <528414A6.8090208@tilera.com>
Date: Wed, 13 Nov 2013 19:09:10 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/17] tile: Remove tile-specific _sinitdata and _einitdata
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org> <1384285347-13506-11-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1384285347-13506-11-git-send-email-geert@linux-m68k.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 2:42 PM, Geert Uytterhoeven wrote:
> Use standard __init_begin and __init_end instead.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
[...]
> @@ -534,7 +534,7 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
>  
>  		BUG_ON(address != (unsigned long)_text);
>  		pte = NULL;
> -		for (; address < (unsigned long)_einittext;
> +		for (; address < (unsigned long)__init_end;
>  		     pfn++, address += PAGE_SIZE) {
>  			pte_ofs = pte_index(address);
>  			if (pte_ofs == 0) {
> @@ -572,7 +572,7 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
>  		else
>  			pteval = hv_pte_set_mode(pteval,
>  						 HV_PTE_MODE_CACHE_NO_L3);
> -		for (; address < (unsigned long)_einittext;
> +		for (; address < (unsigned long)__init_end;
>  		     pfn += PFN_DOWN(HPAGE_SIZE), address += HPAGE_SIZE)
>  			*(pte_t *)(pmd++) = pfn_pte(pfn, pteval);
>  	}
> @@ -632,9 +632,9 @@ int devmem_is_allowed(unsigned long pagenr)
>  {
>  	return pagenr < kaddr_to_pfn(_end) &&
>  		!(pagenr >= kaddr_to_pfn(&init_thread_union) ||
> -		  pagenr < kaddr_to_pfn(_einitdata)) &&
> +		  pagenr < kaddr_to_pfn(__init_end)) &&
>  		!(pagenr >= kaddr_to_pfn(_sinittext) ||
> -		  pagenr <= kaddr_to_pfn(_einittext-1));
> +		  pagenr <= kaddr_to_pfn(__init_end-1));
>  }
>  
>  #ifdef CONFIG_HIGHMEM
[...]
> @@ -984,7 +984,7 @@ void free_initmem(void)
>  	 */
>  	free_init_pages("unused kernel text",
>  			(unsigned long)_sinittext - text_delta,
> -			(unsigned long)_einittext - text_delta);
> +			(unsigned long)__init_end - text_delta);
>  	/* Do a global TLB flush so everyone sees the changes. */
>  	flush_tlb_all();
>  }

These changes are touching _einittext, and they shouldn't.  Only bomb _einitdata (and _sinitdata).

With those changes removed:

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

or let me know if you'd rather I staged your v2 change into the tile tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

