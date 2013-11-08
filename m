Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab3KHK30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:29:26 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48547 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056Ab3KHK3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:29:20 -0500
Message-ID: <527CBCE4.3080106@oracle.com>
Date: Fri, 08 Nov 2013 18:28:52 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "changkun.li" <xfishcoder@gmail.com>
CC: sjenning@linux.vnet.ibm.com, linux-mm@kvack.org, luyi@360.cn,
        lichangkun@360.cn, linux-kernel@vger.kernel.org
Subject: Re: [Patch 3.11.7 1/1]mm: remove and free expired data in time in
 zswap
References: <1383904203.2715.2.camel@ubuntu>
In-Reply-To: <1383904203.2715.2.camel@ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 05:50 PM, changkun.li wrote:
> In zswap, store page A to zbud if the compression ratio is high, insert
> its entry into rbtree. if there is a entry B which has the same offset
> in the rbtree.Remove and free B before insert the entry of A.
> 
> case:
> if the compression ratio of page A is not high, return without checking
> the same offset one in rbtree.
> 
> if there is a entry B which has the same offset in the rbtree. Now, we
> make sure B is invalid or expired. But the entry and compressed memory
> of B are not freed in time.
> 
> Because zswap spaces data in memory, it makes the utilization of memory
> lower. the other valid data in zbud is writeback to swap device more
> possibility, when zswap is full.
> 
> So if we make sure a entry is expired, free it in time.
> 
> Signed-off-by: changkun.li<xfishcoder@gmail.com>
> ---
>  mm/zswap.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index cbd9578..90a2813 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -596,6 +596,7 @@ fail:
>  	return ret;
>  }
>  
> +static void zswap_frontswap_invalidate_page(unsigned type, pgoff_t
> offset);
>  /*********************************
>  * frontswap hooks
>  **********************************/
> @@ -614,7 +615,7 @@ static int zswap_frontswap_store(unsigned type,
> pgoff_t offset,
>  
>  	if (!tree) {
>  		ret = -ENODEV;
> -		goto reject;
> +		goto nodev;
>  	}
>  
>  	/* reclaim space if needed */
> @@ -695,6 +696,8 @@ freepage:
>  	put_cpu_var(zswap_dstmem);
>  	zswap_entry_cache_free(entry);
>  reject:
> +	zswap_frontswap_invalidate_page(type, offset);

I'm afraid when arrives here zswap_rb_search(offset) will always return
NULL entry. So most of the time, it's just waste time to call
zswap_frontswap_invalidate_page() to search rbtree.

-- 
Regards,
-Bob
