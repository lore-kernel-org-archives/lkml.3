Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3HFJnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:43:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38634 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab3HFJnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:43:18 -0400
Message-ID: <5200C527.5030006@oracle.com>
Date: Tue, 06 Aug 2013 17:43:03 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Piotr Sarna <p.sarna@partner.samsung.com>
CC: b.zolnierkie@samsung.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] mm: zcache: zcache_cleancache_flush_fs fix
References: <1375781762-15344-1-git-send-email-p.sarna@partner.samsung.com>
In-Reply-To: <1375781762-15344-1-git-send-email-p.sarna@partner.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Piotr,

On 08/06/2013 05:36 PM, Piotr Sarna wrote:
> This patch fixes "mm: zcache: core functions added" patch,
> available at https://lkml.org/lkml/2013/7/20/90.
> It regards incorrect implementation of zcache_cleancache_flush_fs().
> 
> Function above should be effective only if cleancache pool referred
> by pool_id is valid. This issue is checked by testing whether zpool
> points to NULL.
> 
> Unfortunately, if filesystem mount fails, such pool is never created
> and fs/super.c calls cleancache_invalidate_fs() function with pool_id
> parameter set to -1. This results in assigning zpool with pools[-1],
> which causes zpool to be not NULL and thus whole function hangs on
> uninitialized read-write lock.
> 
> To prevent that behaviour, pool_id should be checked for being positive
> before assigning zpool variable with pools[pool_id].
> 
> Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
> Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Yes, that's a problem. Thank you very much!
I'm so glad you are also interesting in zcache. I'm preparing a update
version of zcache which is still under testing currently.

> ---
>  mm/zcache.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/zcache.c b/mm/zcache.c
> index a2408e8..7e6d2e7 100644
> --- a/mm/zcache.c
> +++ b/mm/zcache.c
> @@ -600,8 +600,12 @@ static void zcache_cleancache_flush_fs(int pool_id)
>  	struct zcache_rb_entry *entry = NULL;
>  	struct rb_node *node;
>  	unsigned long flags1, flags2;
> -	struct zcache_pool *zpool = zcache.pools[pool_id];
> +	struct zcache_pool *zpool;
> +
> +	if (pool_id < 0)
> +		return;
>  
> +	zpool = zcache.pools[pool_id];
>  	if (!zpool)
>  		return;
>  
> 

-- 
Regards,
-Bob
