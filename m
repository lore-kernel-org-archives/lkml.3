Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaILTmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:42:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37085 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaILTmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:42:32 -0400
Date: Fri, 12 Sep 2014 15:41:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, luto@amacapital.net, hmh@hmh.eng.br,
        yigal@plexistor.com
Subject: Re: [PATCH v2 2/6] x86, mm, pat: Change reserve_memtype() to handle
 WT
Message-ID: <20140912194158.GI15656@laptop.dumpdata.com>
References: <1410367910-6026-1-git-send-email-toshi.kani@hp.com>
 <1410367910-6026-3-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410367910-6026-3-git-send-email-toshi.kani@hp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:51:46AM -0600, Toshi Kani wrote:
> This patch changes reserve_memtype() to handle the WT cache mode.
> When PAT is not enabled, it continues to set UC- to *new_type for
> any non-WB request.
> 
> When a target range is RAM, reserve_ram_pages_type() fails for WT
> for now.  This function may not reserve a RAM range for WT since
> reserve_ram_pages_type() uses the page flags limited to three memory
> types, WB, WC and UC.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/include/asm/cacheflush.h |    4 ++++
>  arch/x86/mm/pat.c                 |   16 +++++++++++++---
>  2 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
> index 157644b..c912680 100644
> --- a/arch/x86/include/asm/cacheflush.h
> +++ b/arch/x86/include/asm/cacheflush.h
> @@ -53,6 +53,10 @@ static inline void set_page_memtype(struct page *pg,
>  	case _PAGE_CACHE_MODE_WB:
>  		memtype_flags = _PGMT_WB;
>  		break;
> +	case _PAGE_CACHE_MODE_WT:
> +	case _PAGE_CACHE_MODE_WP:
> +		pr_err("set_page_memtype: unsupported cachemode %d\n", memtype);
> +		BUG();
>  	default:
>  		memtype_flags = _PGMT_DEFAULT;
>  		break;
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index 598d7c7..7644967 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -268,6 +268,8 @@ static int pat_pagerange_is_ram(resource_size_t start, resource_size_t end)
>  
>  /*
>   * For RAM pages, we use page flags to mark the pages with appropriate type.
> + * The page flags are currently limited to three types, WB, WC and UC. Hence,
> + * any request to WT or WP will fail with -EINVAL.
>   * Here we do two pass:
>   * - Find the memtype of all the pages in the range, look for any conflicts
>   * - In case of no conflicts, set the new memtype for pages in the range
> @@ -279,6 +281,13 @@ static int reserve_ram_pages_type(u64 start, u64 end,
>  	struct page *page;
>  	u64 pfn;
>  
> +	if ((req_type == _PAGE_CACHE_MODE_WT) ||
> +	    (req_type == _PAGE_CACHE_MODE_WP)) {
> +		if (new_type)
> +			*new_type = _PAGE_CACHE_MODE_UC_MINUS;
> +		return -EINVAL;
> +	}
> +
>  	if (req_type == _PAGE_CACHE_MODE_UC) {
>  		/* We do not support strong UC */
>  		WARN_ON_ONCE(1);
> @@ -328,6 +337,7 @@ static int free_ram_pages_type(u64 start, u64 end)
>   * - _PAGE_CACHE_MODE_WC
>   * - _PAGE_CACHE_MODE_UC_MINUS
>   * - _PAGE_CACHE_MODE_UC
> + * - _PAGE_CACHE_MODE_WT
>   *
>   * If new_type is NULL, function will return an error if it cannot reserve the
>   * region with req_type. If new_type is non-NULL, function will return
> @@ -347,10 +357,10 @@ int reserve_memtype(u64 start, u64 end, enum page_cache_mode req_type,
>  	if (!pat_enabled) {
>  		/* This is identical to page table setting without PAT */
>  		if (new_type) {
> -			if (req_type == _PAGE_CACHE_MODE_WC)
> -				*new_type = _PAGE_CACHE_MODE_UC_MINUS;
> +			if (req_type == _PAGE_CACHE_MODE_WB)
> +				*new_type = _PAGE_CACHE_MODE_WB;
>  			else
> -				*new_type = req_type;
> +				*new_type = _PAGE_CACHE_MODE_UC_MINUS;
>  		}
>  		return 0;
>  	}
