Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaKCS1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:27:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:54837 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaKCS1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:27:44 -0500
Date: Mon, 3 Nov 2014 19:27:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Toshi Kani <toshi.kani@hp.com>
cc: hpa@zytor.com, mingo@redhat.com, akpm@linux-foundation.org, arnd@arndb.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, luto@amacapital.net, hmh@hmh.eng.br,
        yigal@plexistor.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v4 2/7] x86, mm, pat: Change reserve_memtype() to handle
 WT
In-Reply-To: <1414450545-14028-3-git-send-email-toshi.kani@hp.com>
Message-ID: <alpine.DEB.2.11.1411031916360.5308@nanos>
References: <1414450545-14028-1-git-send-email-toshi.kani@hp.com> <1414450545-14028-3-git-send-email-toshi.kani@hp.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Toshi Kani wrote:
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
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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

You already catch the cases with the hunk below at the entry of
reserve_ram_pages_type(). So what's the point of the BUG()?

If you are worried about other usage sites: This function should not
at all be in arch/x86/include/asm/cacheflush.h. It's solely used by
PAT, so we really should move it there before changing it.

>  	default:
>  		memtype_flags = _PGMT_DEFAULT;
>  		break;
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index db687c3..a214f5a 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -289,6 +289,8 @@ static int pat_pagerange_is_ram(resource_size_t start, resource_size_t end)
>  
>  /*
>   * For RAM pages, we use page flags to mark the pages with appropriate type.
> + * The page flags are currently limited to three types, WB, WC and UC. Hence,
> + * any request to WT or WP will fail with -EINVAL.
>   * Here we do two pass:
>   * - Find the memtype of all the pages in the range, look for any conflicts
>   * - In case of no conflicts, set the new memtype for pages in the range
> @@ -300,6 +302,13 @@ static int reserve_ram_pages_type(u64 start, u64 end,
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
> @@ -349,6 +358,7 @@ static int free_ram_pages_type(u64 start, u64 end)
>   * - _PAGE_CACHE_MODE_WC
>   * - _PAGE_CACHE_MODE_UC_MINUS
>   * - _PAGE_CACHE_MODE_UC
> + * - _PAGE_CACHE_MODE_WT
>   *
>   * If new_type is NULL, function will return an error if it cannot reserve the
>   * region with req_type. If new_type is non-NULL, function will return
> @@ -368,10 +378,10 @@ int reserve_memtype(u64 start, u64 end, enum page_cache_mode req_type,
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

So until now we supported WB, UC- and UC and mapped WC to UC-. Now we
map everything except WB to UC-

Why feels that wrong without a comment explaining it?

Thanks,

	tglx
