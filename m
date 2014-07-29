Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaG2Hxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 03:53:45 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:60172 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaG2Hxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 03:53:44 -0400
Date: Tue, 29 Jul 2014 00:53:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
cc: Dave Hansen <dave.hansen@intel.com>, mgorman@suse.de,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, wangnan0@huawei.com,
        Linux MM <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] memory hotplug: update the variables after memory
 removed
In-Reply-To: <53D74EE5.1070308@huawei.com>
Message-ID: <alpine.DEB.2.02.1407290046470.7998@chino.kir.corp.google.com>
References: <1406619310-20555-1-git-send-email-zhenzhang.zhang@huawei.com> <53D74EE5.1070308@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014, Zhang Zhen wrote:

> Commit ea0854170c95245a258b386c7a9314399c949fe0 added a fuction

This would normally be written as

Commit ea0854170c95 ("memory hotplug: fix a bug on /dev/mem for 64-bit 
kernels") ...

> update_end_of_memory_vars() to update high_memory, max_pfn and
> max_low_pfn.
> 
> I modified the function according to Dave Hansen and David Rientjes's
> suggestions.
> And call it in arch_remove_memory() to update these variables too.
> 

When the x86 maintainers merge this patch, they'll need to make a judgment 
call on how urgent the fix is and that will guide them in whether they 
want it backported to stable kernels as well.  It would be useful to 
provide the rationale for the change; in other words, why is the change 
needed and what breaks if we don't have it?

> Change v1->v2:
> - according to Dave Hansen and David Rientjes's suggestions modified
>   update_end_of_memory_vars().
> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>

Acked-by: David Rientjes <rientjes@google.com>

You'll want to email all the x86 maintainers who would handle this patch, 
check the output of scripts/get_maintainer.pl when run on this diff.

> ---
>  arch/x86/mm/init_64.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index df1a992..fd7bd6b 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -673,15 +673,11 @@ void __init paging_init(void)
>   * After memory hotplug the variables max_pfn, max_low_pfn and high_memory need
>   * updating.
>   */
> -static void  update_end_of_memory_vars(u64 start, u64 size)
> +static void  update_end_of_memory_vars(u64 end_pfn)

Extra space that can be removed here at the same time as a cleanup.

>  {
> -	unsigned long end_pfn = PFN_UP(start + size);
> -
> -	if (end_pfn > max_pfn) {
> -		max_pfn = end_pfn;
> -		max_low_pfn = end_pfn;
> -		high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
> -	}
> +	max_pfn = end_pfn;
> +	max_low_pfn = end_pfn;
> +	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
>  }
> 
>  /*
> @@ -694,6 +690,7 @@ int arch_add_memory(int nid, u64 start, u64 size)
>  	struct zone *zone = pgdat->node_zones + ZONE_NORMAL;
>  	unsigned long start_pfn = start >> PAGE_SHIFT;
>  	unsigned long nr_pages = size >> PAGE_SHIFT;
> +	unsigned long end_pfn;
>  	int ret;
> 
>  	init_memory_mapping(start, start + size);
> @@ -702,7 +699,9 @@ int arch_add_memory(int nid, u64 start, u64 size)
>  	WARN_ON_ONCE(ret);
> 
>  	/* update max_pfn, max_low_pfn and high_memory */
> -	update_end_of_memory_vars(start, size);
> +	end_pfn = start_pfn + nr_pages;
> +	if (end_pfn > max_pfn)
> +		update_end_of_memory_vars(end_pfn);
> 
>  	return ret;
>  }
> @@ -1018,6 +1017,7 @@ int __ref arch_remove_memory(u64 start, u64 size)
>  	unsigned long start_pfn = start >> PAGE_SHIFT;
>  	unsigned long nr_pages = size >> PAGE_SHIFT;
>  	struct zone *zone;
> +	unsigned long end_pfn;
>  	int ret;
> 
>  	zone = page_zone(pfn_to_page(start_pfn));
> @@ -1025,6 +1025,11 @@ int __ref arch_remove_memory(u64 start, u64 size)
>  	ret = __remove_pages(zone, start_pfn, nr_pages);
>  	WARN_ON_ONCE(ret);
> 
> +	/* update max_pfn, max_low_pfn and high_memory */
> +	end_pfn = start_pfn + nr_pages;
> +	if ((max_pfn >= start_pfn) && (max_pfn < end_pfn))
> +		update_end_of_memory_vars(start_pfn);

Not sure if we really need the new variable here; if you choose to 
repropose this patch then you may want to consider just using 
start_pfn + nr_pages in the conditional.

> +
>  	return ret;
>  }
>  #endif
