Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280AbaJaPem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:34:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:41981 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaJaPel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:34:41 -0400
Date: Fri, 31 Oct 2014 16:34:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Juergen Gross <jgross@suse.com>
cc: hpa@zytor.com, x86@kernel.org, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH 10/17] x86: Use new cache mode type in setting page
 attributes
In-Reply-To: <1414764033-30011-11-git-send-email-jgross@suse.com>
Message-ID: <alpine.DEB.2.11.1410311617260.5308@nanos>
References: <1414764033-30011-1-git-send-email-jgross@suse.com> <1414764033-30011-11-git-send-email-jgross@suse.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, Juergen Gross wrote:
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -1304,12 +1304,6 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
>  	return 0;
>  }
>  
> -static inline int cache_attr(pgprot_t attr)
> -{
> -	return pgprot_val(attr) &
> -		(_PAGE_PAT | _PAGE_PAT_LARGE | _PAGE_PWT | _PAGE_PCD);
> -}
> -
>  static int change_page_attr_set_clr(unsigned long *addr, int numpages,
>  				    pgprot_t mask_set, pgprot_t mask_clr,
>  				    int force_split, int in_flag,
> @@ -1390,7 +1384,7 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
>  	 * No need to flush, when we did not set any of the caching
>  	 * attributes:
>  	 */
> -	cache = cache_attr(mask_set);
> +	cache = !!pgprot2cachemode(mask_set);

So this loses _PAGE_PAT_LARGE, right ?

>  int set_memory_uc(unsigned long addr, int numpages)
> @@ -1456,7 +1451,7 @@ int set_memory_uc(unsigned long addr, int numpages)
>  	 * for now UC MINUS. see comments in ioremap_nocache()
>  	 */
>  	ret = reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
> -			    _PAGE_CACHE_UC_MINUS, NULL);
> +			      _PAGE_CACHE_UC_MINUS, NULL);

That should be in the patch which added the _PAGE_CACHE_UC_MINUS

>  int _set_memory_wb(unsigned long addr, int numpages)
>  {
> +	/* WB cache mode is hard wired to all cache attribute bits being 0 */

I like the comment, but shouldn't we compile time check that
assumption somewhere?

>  	return change_page_attr_clear(&addr, numpages,
>  				      __pgprot(_PAGE_CACHE_MASK), 0);

Thanks,

	tglx
