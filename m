Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaBRVrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:47:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:56624 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbaBRVrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:47:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,503,1389772800"; 
   d="scan'208";a="485433896"
Message-ID: <5303D4EF.7040906@intel.com>
Date: Tue, 18 Feb 2014 13:47:27 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>, Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Vegard Nossum <vegardno@ifi.uio.no>, Pekka Enberg <penberg@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH V2] mm: add a new command-line kmemcheck value
References: <53017544.90908@huawei.com>
In-Reply-To: <53017544.90908@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2014 06:34 PM, Xishi Qiu wrote:
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index f971306..cd7d75f 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -135,6 +135,15 @@ static void __init probe_page_size_mask(void)
>  		page_size_mask |= 1 << PG_LEVEL_2M;
>  #endif
>  
> +#if defined(CONFIG_KMEMCHECK)
> +	if (!kmemcheck_on) {
> +		if (direct_gbpages)
> +			page_size_mask |= 1 << PG_LEVEL_1G;
> +		if (cpu_has_pse)
> +			page_size_mask |= 1 << PG_LEVEL_2M;
> +	}
> +#endif

This is a copy-n-paste from just above which is inside a:

#if !defined(CONFIG_DEBUG_PAGEALLOC) && !defined(CONFIG_KMEMCHECK)

This gets really confusing to figure out which one of these options will
rule.  Maybe it's just time to add a kmemcheck_active() function which
gets #ifdef'd to 0 if the config option is off.

>  	/* Enable PSE if available */
>  	if (cpu_has_pse)
>  		set_in_cr4(X86_CR4_PSE);
> @@ -331,6 +340,8 @@ bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn)
>  	return false;
>  }
>  
> +extern int kmemcheck_on;

Didn't you _just_ reference this?  Either it's unnecessary, or this code
doesn't compile.

>  /*
>   * Setup the direct mapping of the physical memory at PAGE_OFFSET.
>   * This runs before bootmem is initialized and gets pages directly from
> diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
> index d87dd6d..d686ee0 100644
> --- a/arch/x86/mm/kmemcheck/kmemcheck.c
> +++ b/arch/x86/mm/kmemcheck/kmemcheck.c
> @@ -44,30 +44,35 @@
>  #ifdef CONFIG_KMEMCHECK_ONESHOT_BY_DEFAULT
>  #  define KMEMCHECK_ENABLED 2
>  #endif
> +#define KMEMCHECK_CLOSED 3
>  
> -int kmemcheck_enabled = KMEMCHECK_ENABLED;
> +int kmemcheck_enabled = KMEMCHECK_CLOSED;
> +int kmemcheck_on = 0;

This is pretty confusing.  If I see "kmemcheck_on" and
"kmemcheck_enabled" in the code, it's hard to figure out which one to
trust and infer what they were _supposed_ to be doing.

Please add some documentation for these, at least.  The commit message
isn't enough.

I'd also suggest breaking this up in to at least two pieces: one which
adds the functions to check at runtime if we want to use kmemcheck, and
then a second one to actually add this tunable.
