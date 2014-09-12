Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaILTsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:48:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49393 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaILTsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:48:22 -0400
Date: Fri, 12 Sep 2014 15:47:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, luto@amacapital.net, hmh@hmh.eng.br,
        yigal@plexistor.com
Subject: Re: [PATCH v2 5/6] x86, mm, pat: Add pgprot_writethrough() for WT
Message-ID: <20140912194755.GL15656@laptop.dumpdata.com>
References: <1410367910-6026-1-git-send-email-toshi.kani@hp.com>
 <1410367910-6026-6-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410367910-6026-6-git-send-email-toshi.kani@hp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:51:49AM -0600, Toshi Kani wrote:
> This patch adds pgprot_writethrough() for setting WT to a given
> pgprot_t.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/include/asm/pgtable_types.h |    3 +++
>  arch/x86/mm/pat.c                    |   10 ++++++++++
>  include/asm-generic/pgtable.h        |    4 ++++
>  3 files changed, 17 insertions(+)
> 
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index bd2f50f..cc7c65d 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -394,6 +394,9 @@ extern int nx_enabled;
>  #define pgprot_writecombine	pgprot_writecombine
>  extern pgprot_t pgprot_writecombine(pgprot_t prot);
>  
> +#define pgprot_writethrough	pgprot_writethrough
> +extern pgprot_t pgprot_writethrough(pgprot_t prot);
> +
>  /* Indicate that x86 has its own track and untrack pfn vma functions */
>  #define __HAVE_PFNMAP_TRACKING
>  
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index 7644967..97aab95 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -875,6 +875,16 @@ pgprot_t pgprot_writecombine(pgprot_t prot)
>  }
>  EXPORT_SYMBOL_GPL(pgprot_writecombine);
>  
> +pgprot_t pgprot_writethrough(pgprot_t prot)
> +{
> +	if (pat_enabled)
> +		return __pgprot(pgprot_val(prot) |
> +				cachemode2protval(_PAGE_CACHE_MODE_WT));
> +	else
> +		return pgprot_noncached(prot);
> +}
> +EXPORT_SYMBOL_GPL(pgprot_writethrough);
> +
>  #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_X86_PAT)
>  
>  static struct memtype *memtype_get_idx(loff_t pos)
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> index 53b2acc..1af0ed9 100644
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -249,6 +249,10 @@ static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
>  #define pgprot_writecombine pgprot_noncached
>  #endif
>  
> +#ifndef pgprot_writethrough
> +#define pgprot_writethrough pgprot_noncached
> +#endif
> +
>  /*
>   * When walking page tables, get the address of the next boundary,
>   * or the end address of the range if that comes earlier.  Although no
