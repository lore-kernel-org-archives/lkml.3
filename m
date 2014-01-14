Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaANBTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:19:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35030 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaANBTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 20:19:39 -0500
Message-ID: <52D4909B.7070107@oracle.com>
Date: Tue, 14 Jan 2014 09:19:23 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Cai Liu <cai.liu@samsung.com>, sjenning@linux.vnet.ibm.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, liucai.lfn@gmail.com
Subject: Re: [PATCH] mm/zswap: Check all pool pages instead of one pool pages
References: <000101cf0ea0$f4e7c560$deb75020$@samsung.com> <20140113233505.GS1992@bbox>
In-Reply-To: <20140113233505.GS1992@bbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/14/2014 07:35 AM, Minchan Kim wrote:
> Hello,
> 
> On Sat, Jan 11, 2014 at 03:43:07PM +0800, Cai Liu wrote:
>> zswap can support multiple swapfiles. So we need to check
>> all zbud pool pages in zswap.
> 
> True but this patch is rather costly that we should iterate
> zswap_tree[MAX_SWAPFILES] to check it. SIGH.
> 
> How about defining zswap_tress as linked list instead of static
> array? Then, we could reduce unnecessary iteration too much.
> 

But if use linked list, it might not easy to access the tree like this:
struct zswap_tree *tree = zswap_trees[type];

BTW: I'm still prefer to use dynamic pool size, instead of use
zswap_is_full(). AFAIR, Seth has a plan to replace the rbtree with radix
which will be more flexible to support this feature and page migration
as well.

> Other question:
> Why do we need to update zswap_pool_pages too frequently?
> As I read the code, I think it's okay to update it only when user
> want to see it by debugfs and zswap_is_full is called.
> So could we optimize it out?
> 
>>
>> Signed-off-by: Cai Liu <cai.liu@samsung.com>

Reviewed-by: Bob Liu <bob.liu@oracle.com>

>> ---
>>  mm/zswap.c |   18 +++++++++++++++---
>>  1 file changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index d93afa6..2438344 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -291,7 +291,6 @@ static void zswap_free_entry(struct zswap_tree *tree,
>>  	zbud_free(tree->pool, entry->handle);
>>  	zswap_entry_cache_free(entry);
>>  	atomic_dec(&zswap_stored_pages);
>> -	zswap_pool_pages = zbud_get_pool_size(tree->pool);
>>  }
>>  
>>  /* caller must hold the tree lock */
>> @@ -405,10 +404,24 @@ cleanup:
>>  /*********************************
>>  * helpers
>>  **********************************/
>> +static u64 get_zswap_pool_pages(void)
>> +{
>> +	int i;
>> +	u64 pool_pages = 0;
>> +
>> +	for (i = 0; i < MAX_SWAPFILES; i++) {
>> +		if (zswap_trees[i])
>> +			pool_pages += zbud_get_pool_size(zswap_trees[i]->pool);
>> +	}
>> +	zswap_pool_pages = pool_pages;
>> +
>> +	return pool_pages;
>> +}
>> +
>>  static bool zswap_is_full(void)
>>  {
>>  	return (totalram_pages * zswap_max_pool_percent / 100 <
>> -		zswap_pool_pages);
>> +		get_zswap_pool_pages());
>>  }
>>  
>>  /*********************************
>> @@ -716,7 +729,6 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
>>  
>>  	/* update stats */
>>  	atomic_inc(&zswap_stored_pages);
>> -	zswap_pool_pages = zbud_get_pool_size(tree->pool);
>>  
>>  	return 0;
>>  
>> -- 
>> 1.7.10.4
-- 
Regards,
-Bob
