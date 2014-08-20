Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaHTTgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:36:43 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:58021 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaHTTgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:36:42 -0400
Message-ID: <1408562787.28990.65.camel@misato.fc.hp.com>
Subject: Re: [PATCH RFC 1/3] x86: Make page cache mode a real type
From: Toshi Kani <toshi.kani@hp.com>
To: jgross@suse.com
Cc: stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, hpa@zytor.com, x86@kernel.org
Date: Wed, 20 Aug 2014 13:26:27 -0600
In-Reply-To: <1408454745-32358-2-git-send-email-jgross@suse.com>
References: <1408454745-32358-1-git-send-email-jgross@suse.com>
	 <1408454745-32358-2-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-19 at 15:25 +0200, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> At the moment there are a lot of places that handle setting or getting
> the page cache mode by treating the pgprot bits equal to the cache mode.
> This is only true because there are a lot of assumptions about the setup
> of the PAT MSR. Otherwise the cache type needs to get translated into
> pgprot bits and vice versa.
> 
> This patch tries to prepare for that by introducing a seperate type
> for the cache mode and adding functions to translate between those and pgprot
> values.
> 
> To avoid too much performance penalty the translation between cache mode
> and pgprot values is done via tables which contain the relevant information.
> Write-back cache mode is hard-wired to be 0, all other modes are configurable
> via those tables. For large pages there are translation functions as the
> PAT bit is located at different positions in the ptes of 4k and large pages.

Hi Juergen,

Thanks for driving this.  As we talked before, the changes look good to
me.  I will post a patchset to enable WT on top of your patchset once
this is settled a bit.

I have couples of minor comments below.

> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index f216963..7685b34 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
 :
>  /*         xwr */
>  #define __P000	PAGE_NONE
> @@ -328,6 +331,55 @@ static inline pteval_t pte_flags(pte_t pte)
>  #define pgprot_val(x)	((x).pgprot)
>  #define __pgprot(x)	((pgprot_t) { (x) } )
>  
> +extern uint16_t __cachemode2pte_tbl[_PAGE_CACHE_MODE_NUM];
> +extern uint8_t __pte2cachemode_tbl[8];
> +
> +#define __pte2cm_idx(cb)				\
> +	((((cb) >> (_PAGE_BIT_PAT - 2)) & 4) |		\
> +	 (((cb) >> (_PAGE_BIT_PCD - 1)) & 2) |		\
> +	 (((cb) >> _PAGE_BIT_PWT) & 1))
> +
> +static inline unsigned long protval_cachemode(enum page_cache_mode pct)
> +{
> +	if (likely(pct == 0))
> +		return 0;
> +	return __cachemode2pte_tbl[pct];
> +}

I think this function name is not intuitive. pgprot_val() works as
pgprot-to-protval, but protval_cachemode() works the other way around as
cachemode-to-protval.

How about renaming to cachemode_protval()?

Also, "pct" should probably be changed to "pcm".

> +static inline pgprot_t pgprot_cachemode(enum page_cache_mode pct)
> +{
> +	return __pgprot(protval_cachemode(pct));
> +}

Ditto.

> +static inline enum page_cache_mode cachemode_pgprot(pgprot_t pgprot)
> +{
> +	unsigned long masked;
> +
> +	masked = pgprot_val(pgprot) & _PAGE_CACHE_MASK;
> +	if (likely(masked == 0))
> +		return 0;
> +	return __pte2cachemode_tbl[__pte2cm_idx(masked)];
> +}

Ditto.

> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 66dba36..0500124 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -27,6 +27,35 @@
>  
>  #include "mm_internal.h"
>  
> +/*
> + * Tables translating between page_cache_type_t and pte encoding.
> + * Minimal supported modes are defined statically, modified if more supported
> + * cache modes are available.
> + * Index into __cachemode2pte_tbl is the cachemode.
> + * Index into __pte2cachemode_tbl are the caching attribute bits of the pte
> + * (_PAGE_PWT, _PAGE_PCD, _PAGE_PAT) at index bit positions 0, 1, 2.
> + */
> +uint16_t __cachemode2pte_tbl[_PAGE_CACHE_MODE_NUM] = {
> +	[_PAGE_CACHE_MODE_WB]		= 0,
> +	[_PAGE_CACHE_MODE_WC]		= _PAGE_PWT,
> +	[_PAGE_CACHE_MODE_UC_MINUS]	= _PAGE_PCD,
> +	[_PAGE_CACHE_MODE_UC]		= _PAGE_PCD | _PAGE_PWT,
> +	[_PAGE_CACHE_MODE_WT]		= _PAGE_PWT,
> +	[_PAGE_CACHE_MODE_WP]		= _PAGE_PWT,
> +};

I think WT and WP should be set to _PAGE_PCD (UC_MINUS) for safe.

> +EXPORT_SYMBOL_GPL(__cachemode2pte_tbl);
> +uint8_t __pte2cachemode_tbl[8] = {
> +	[__pte2cm_idx(0)] = _PAGE_CACHE_MODE_WB,
> +	[__pte2cm_idx(_PAGE_PWT)] = _PAGE_CACHE_MODE_WC,
> +	[__pte2cm_idx(_PAGE_PCD)] = _PAGE_CACHE_MODE_UC_MINUS,
> +	[__pte2cm_idx(_PAGE_PWT | _PAGE_PCD)] = _PAGE_CACHE_MODE_UC,
> +	[__pte2cm_idx(_PAGE_PAT)] = _PAGE_CACHE_MODE_WB,
> +	[__pte2cm_idx(_PAGE_PWT | _PAGE_PAT)] = _PAGE_CACHE_MODE_WC,
> +	[__pte2cm_idx(_PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC_MINUS,
> +	[__pte2cm_idx(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC,
> +};
 :
> diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
> index 7b179b4..91a2d3b 100644
> --- a/arch/x86/mm/iomap_32.c
> +++ b/arch/x86/mm/iomap_32.c
> @@ -33,17 +33,17 @@ static int is_io_mapping_possible(resource_size_t base, unsigned long size)
>  
>  int iomap_create_wc(resource_size_t base, unsigned long size, pgprot_t *prot)
>  {
> -	unsigned long flag = _PAGE_CACHE_WC;
> +	enum page_cache_mode pct = _PAGE_CACHE_MODE_WC;
>  	int ret;
>  
>  	if (!is_io_mapping_possible(base, size))
>  		return -EINVAL;
>  
> -	ret = io_reserve_memtype(base, base + size, &flag);
> +	ret = io_reserve_memtype(base, base + size, &pct);
>  	if (ret)
>  		return ret;
>  
> -	*prot = __pgprot(__PAGE_KERNEL | flag);
> +	*prot = __pgprot(__PAGE_KERNEL | pgprot_val(pgprot_cachemode(pct)));

pgrot_val(pgprot_cachemode(pct)) can be simply protval_cachemode(pct).
(again, this should be renamed as cachemode_protval().)

There are other places similar to this.

>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(iomap_create_wc);
> @@ -73,6 +73,9 @@ void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot)
>  /*
>   * Map 'pfn' using protections 'prot'
>   */
> +#define __PAGE_KERNEL_WC	(__PAGE_KERNEL | \
> +				 protval_cachemode(_PAGE_CACHE_TYPE_WC))

_PAGE_CACHE_TYPE_WC should be _PAGE_CACHE_MODE_WC.

There are a few other places where _PAGE_CACHE_TYPE_* are still used, so
please fix for that.


Thanks,
-Toshi

