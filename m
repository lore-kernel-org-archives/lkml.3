Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbaJ2K4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:56:54 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:40364 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaJ2K4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:56:53 -0400
Date: Wed, 29 Oct 2014 11:56:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Juergen Gross <jgross@suse.com>
Cc: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com
Subject: Re: [PATCH V4 2/3] x86: Enable PAT to use cache mode translation
 tables
Message-ID: <20141029105648.GB11648@gmail.com>
References: <1414392513-24645-1-git-send-email-jgross@suse.com>
 <1414392513-24645-3-git-send-email-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414392513-24645-3-git-send-email-jgross@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Juergen Gross <jgross@suse.com> wrote:

> Update the translation tables from cache mode to pgprot values
> according to the PAT settings. This enables changing the cache
> attributes of a PAT index in just one place without having to change
> at the users side.
> 
> With this change it is possible to use the same kernel with different
> PAT configurations, e.g. supporting Xen.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: Toshi Kani <toshi.kani@hp.com>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/include/asm/pat.h           |  1 +
>  arch/x86/include/asm/pgtable_types.h |  4 +++
>  arch/x86/mm/init.c                   |  8 ++++++
>  arch/x86/mm/mm_internal.h            |  2 ++
>  arch/x86/mm/pat.c                    | 55 ++++++++++++++++++++++++++++++++++--
>  5 files changed, 68 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pat.h b/arch/x86/include/asm/pat.h
> index 150407a..91bc4ba 100644
> --- a/arch/x86/include/asm/pat.h
> +++ b/arch/x86/include/asm/pat.h
> @@ -11,6 +11,7 @@ static const int pat_enabled;
>  #endif
>  
>  extern void pat_init(void);
> +void pat_init_cache_modes(void);
>  
>  extern int reserve_memtype(u64 start, u64 end,
>  		enum page_cache_mode req_pcm, enum page_cache_mode *ret_pcm);
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index 3a6cbb9..31c66c6 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -351,6 +351,10 @@ extern uint8_t __pte2cachemode_tbl[8];
>  	((((cb) >> (_PAGE_BIT_PAT - 2)) & 4) |		\
>  	 (((cb) >> (_PAGE_BIT_PCD - 1)) & 2) |		\
>  	 (((cb) >> _PAGE_BIT_PWT) & 1))
> +#define __cm_idx2pte(i)					\
> +	((((i) & 4) << (_PAGE_BIT_PAT - 2)) |		\
> +	 (((i) & 2) << (_PAGE_BIT_PCD - 1)) |		\
> +	 (((i) & 1) << _PAGE_BIT_PWT))
>  
>  static inline unsigned long cachemode2protval(enum page_cache_mode pcm)
>  {
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index a9776ba..82b41d5 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -716,3 +716,11 @@ void __init zone_sizes_init(void)
>  	free_area_init_nodes(max_zone_pfns);
>  }
>  
> +void update_cache_mode_entry(unsigned entry, enum page_cache_mode cache)
> +{
> +	/* entry 0 MUST be WB (hardwired to speed up translations) */
> +	BUG_ON(!entry && cache != _PAGE_CACHE_MODE_WB);
> +
> +	__cachemode2pte_tbl[cache] = __cm_idx2pte(entry);
> +	__pte2cachemode_tbl[entry] = cache;
> +}
> diff --git a/arch/x86/mm/mm_internal.h b/arch/x86/mm/mm_internal.h
> index 6b563a1..62474ba 100644
> --- a/arch/x86/mm/mm_internal.h
> +++ b/arch/x86/mm/mm_internal.h
> @@ -16,4 +16,6 @@ void zone_sizes_init(void);
>  
>  extern int after_bootmem;
>  
> +void update_cache_mode_entry(unsigned entry, enum page_cache_mode cache);
> +
>  #endif	/* __X86_MM_INTERNAL_H */
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index ef75f3f..ff31851 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -31,6 +31,7 @@
>  #include <asm/io.h>
>  
>  #include "pat_internal.h"
> +#include "mm_internal.h"
>  
>  #ifdef CONFIG_X86_PAT
>  int __read_mostly pat_enabled = 1;
> @@ -75,6 +76,57 @@ enum {
>  	PAT_UC_MINUS = 7,	/* UC, but can be overriden by MTRR */
>  };
>  
> +/*
> + * Update the cache mode to pgprot translation tables according to PAT
> + * configuration.
> + * Using lower indices is preferred, so we start with highest index.
> + */
> +void pat_init_cache_modes(void)
> +{
> +	int i;
> +	enum page_cache_mode cache;
> +	char pat_msg[33];
> +	char *cache_mode;
> +	u64 pat;
> +
> +	rdmsrl(MSR_IA32_CR_PAT, pat);
> +	pat_msg[32] = 0;
> +	for (i = 7; i >= 0; i--) {
> +		switch ((pat >> (i * 8)) & 7) {
> +		case PAT_UC:
> +			cache = _PAGE_CACHE_MODE_UC;
> +			cache_mode = "UC  ";
> +			break;
> +		case PAT_WC:
> +			cache = _PAGE_CACHE_MODE_WC;
> +			cache_mode = "WC  ";
> +			break;
> +		case PAT_WT:
> +			cache = _PAGE_CACHE_MODE_WT;
> +			cache_mode = "WT  ";
> +			break;
> +		case PAT_WP:
> +			cache = _PAGE_CACHE_MODE_WP;
> +			cache_mode = "WP  ";
> +			break;
> +		case PAT_WB:
> +			cache = _PAGE_CACHE_MODE_WB;
> +			cache_mode = "WB  ";
> +			break;
> +		case PAT_UC_MINUS:
> +			cache = _PAGE_CACHE_MODE_UC_MINUS;
> +			cache_mode = "UC- ";
> +			break;
> +		default:
> +			cache = _PAGE_CACHE_MODE_WB;
> +			cache_mode = "WB  ";

Please put the iterator into a helper function to make it all 
easier to read.

Within that helper function I'd also suggest organizing the 
initialization the following way:


	case PAT_UC:	   cache = _PAGE_CACHE_MODE_UC;	      cache_mode = "UC  "; break;
	case PAT_WC:	   cache = _PAGE_CACHE_MODE_WC;       cache_mode = "WC  "; break;
	case PAT_WT:	   cache = _PAGE_CACHE_MODE_WT;	      cache_mode = "WT  "; break;
	...
	case PAT_UC_MINUS: cache = _PAGE_CACHE_MODE_UC_MINUS; cache_mode = "UC- "; break;
	default:	   cache = _PAGE_CACHE_MODE_WB;       cache_mode = "WB  "; break;

Note how it's all tabular, vertically aligned and thus easier to 
cross check and review this way.

Thanks,

	Ingo
