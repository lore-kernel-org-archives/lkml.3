Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaFKCq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:46:28 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:35530 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751634AbaFKCq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:46:27 -0400
X-IronPort-AV: E=Sophos;i="5.00,686,1396972800"; 
   d="scan'208";a="31740728"
Message-ID: <5397C2BA.5030808@cn.fujitsu.com>
Date: Wed, 11 Jun 2014 10:45:14 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>
CC: David Rientjes <rientjes@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 01/10] mm, compaction: do not recheck suitable_migration_target
 under lock
References: <1402305982-6928-1-git-send-email-vbabka@suse.cz>
In-Reply-To: <1402305982-6928-1-git-send-email-vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 05:26 PM, Vlastimil Babka wrote:
> isolate_freepages_block() rechecks if the pageblock is suitable to be a target
> for migration after it has taken the zone->lock. However, the check has been
> optimized to occur only once per pageblock, and compact_checklock_irqsave()
> might be dropping and reacquiring lock, which means somebody else might have
> changed the pageblock's migratetype meanwhile.
> 
> Furthermore, nothing prevents the migratetype to change right after
> isolate_freepages_block() has finished isolating. Given how imperfect this is,
> it's simpler to just rely on the check done in isolate_freepages() without
> lock, and not pretend that the recheck under lock guarantees anything. It is
> just a heuristic after all.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> ---
> I suggest folding mm-compactionc-isolate_freepages_block-small-tuneup.patch into this
> 
>  mm/compaction.c | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 5175019..b73b182 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -276,7 +276,6 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  	struct page *cursor, *valid_page = NULL;
>  	unsigned long flags;
>  	bool locked = false;
> -	bool checked_pageblock = false;
>  
>  	cursor = pfn_to_page(blockpfn);
>  
> @@ -307,18 +306,6 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  		if (!locked)
>  			break;
>  
> -		/* Recheck this is a suitable migration target under lock */
> -		if (!strict && !checked_pageblock) {
> -			/*
> -			 * We need to check suitability of pageblock only once
> -			 * and this isolate_freepages_block() is called with
> -			 * pageblock range, so just check once is sufficient.
> -			 */
> -			checked_pageblock = true;
> -			if (!suitable_migration_target(page))
> -				break;
> -		}
> -
>  		/* Recheck this is a buddy page under lock */
>  		if (!PageBuddy(page))
>  			goto isolate_fail;
> 


-- 
Thanks.
Zhang Yanfei
