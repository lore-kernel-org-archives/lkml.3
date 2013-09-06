Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750941Ab3IFGmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:42:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20413 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3IFGmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:42:14 -0400
Message-ID: <5229792F.9000803@oracle.com>
Date: Fri, 06 Sep 2013 14:41:51 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Weijie Yang <weijie.yang@samsung.com>
CC: sjenning@linux.vnet.ibm.com, minchan@kernel.org, weijie.yang.kh@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm/zswap: use GFP_NOIO instead of GFP_KERNEL
References: <000601ceaac0$5be39f90$13aadeb0$%yang@samsung.com>
In-Reply-To: <000601ceaac0$5be39f90$13aadeb0$%yang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/06/2013 01:16 PM, Weijie Yang wrote:
> To avoid zswap store and reclaim functions called recursively,
> use GFP_NOIO instead of GFP_KERNEL
> 

The reason of using GFP_KERNEL in write back path is we want to try our
best to move those pages from zswap to real swap device.

I think it would be better to keep GFP_KERNEL flag but find some other
ways to skip zswap/zswap_frontswap_store() if zswap write back is in
progress.

What I can think of currently is adding a mutex to zswap, take that
mutex when zswap write back happens and check the mutex in
zswap_frontswap_store().


> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> ---
>  mm/zswap.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index cc40e6a..3d05ed8 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -427,7 +427,7 @@ static int zswap_get_swap_cache_page(swp_entry_t entry,
>  		 * Get a new page to read into from swap.
>  		 */
>  		if (!new_page) {
> -			new_page = alloc_page(GFP_KERNEL);
> +			new_page = alloc_page(GFP_NOIO);
>  			if (!new_page)
>  				break; /* Out of memory */
>  		}
> @@ -435,7 +435,7 @@ static int zswap_get_swap_cache_page(swp_entry_t entry,
>  		/*
>  		 * call radix_tree_preload() while we can wait.
>  		 */
> -		err = radix_tree_preload(GFP_KERNEL);
> +		err = radix_tree_preload(GFP_NOIO);
>  		if (err)
>  			break;
>  
> @@ -636,7 +636,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
>  	}
>  
>  	/* allocate entry */
> -	entry = zswap_entry_cache_alloc(GFP_KERNEL);
> +	entry = zswap_entry_cache_alloc(GFP_NOIO);
>  	if (!entry) {
>  		zswap_reject_kmemcache_fail++;
>  		ret = -ENOMEM;
> 

-- 
Regards,
-Bob
