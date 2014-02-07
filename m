Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaBGJuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:50:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaBGJuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:50:39 -0500
Message-ID: <52F4AC6B.5080101@suse.cz>
Date: Fri, 07 Feb 2014 10:50:35 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Joonsoo Kim <js1304@gmail.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] mm/compaction: change the timing to check to drop
 the spinlock
References: <1391749726-28910-1-git-send-email-iamjoonsoo.kim@lge.com> <1391749726-28910-4-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1391749726-28910-4-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 06:08 AM, Joonsoo Kim wrote:
> It is odd to drop the spinlock when we scan (SWAP_CLUSTER_MAX - 1) th pfn
> page. This may results in below situation while isolating migratepage.
> 
> 1. try isolate 0x0 ~ 0x200 pfn pages.
> 2. When low_pfn is 0x1ff, ((low_pfn+1) % SWAP_CLUSTER_MAX) == 0, so drop
> the spinlock.
> 3. Then, to complete isolating, retry to aquire the lock.
> 
> I think that it is better to use SWAP_CLUSTER_MAX th pfn for checking
> the criteria about dropping the lock. This has no harm 0x0 pfn, because,
> at this time, locked variable would be false.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> diff --git a/mm/compaction.c b/mm/compaction.c
> index 0d821a2..b1ba297 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -481,7 +481,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>  	cond_resched();
>  	for (; low_pfn < end_pfn; low_pfn++) {
>  		/* give a chance to irqs before checking need_resched() */
> -		if (locked && !((low_pfn+1) % SWAP_CLUSTER_MAX)) {
> +		if (locked && !(low_pfn % SWAP_CLUSTER_MAX)) {
>  			if (should_release_lock(&zone->lru_lock)) {
>  				spin_unlock_irqrestore(&zone->lru_lock, flags);
>  				locked = false;
> 

