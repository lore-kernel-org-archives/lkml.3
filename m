Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbaDGOqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:46:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826AbaDGOqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:46:14 -0400
Message-ID: <5342BA34.8050006@suse.cz>
Date: Mon, 07 Apr 2014 16:46:12 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Heesub Shin <heesub.shin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Dongjun Shin <d.j.shin@samsung.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>
Subject: Re: [PATCH 2/2] mm/compaction: fix to initialize free scanner properly
References: <1396515424-18794-1-git-send-email-heesub.shin@samsung.com> <1396515424-18794-2-git-send-email-heesub.shin@samsung.com>
In-Reply-To: <1396515424-18794-2-git-send-email-heesub.shin@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 10:57 AM, Heesub Shin wrote:
> Free scanner does not works well on systems having zones which do not
> span to pageblock-aligned boundary.
>
> zone->compact_cached_free_pfn is reset when the migration and free
> scanner across or compaction restarts. After the reset, if end_pfn of
> the zone was not aligned to pageblock_nr_pages, free scanner tries to
> isolate free pages from the middle of pageblock to the end, which can
> be very small range.

Hm good catch. I think that the same problem can happen (at least 
theoretically) through zone->compact_cached_free_pfn with 
CONFIG_HOLES_IN_ZONE enabled. Then compact_cached_free_pfn could be set
to a non-aligned-to-pageblock pfn and spoil scans. I'll send a patch 
that solves it on isolate_freepages() level, which allows further 
simplification of the function.

Vlastimil

> Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
> Cc: Dongjun Shin <d.j.shin@samsung.com>
> Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
> ---
>   mm/compaction.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 1ef9144..fefe1da 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -983,7 +983,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
>   	 */
>   	cc->migrate_pfn = zone->compact_cached_migrate_pfn;
>   	cc->free_pfn = zone->compact_cached_free_pfn;
> -	if (cc->free_pfn < start_pfn || cc->free_pfn > end_pfn) {
> +	if (cc->free_pfn < start_pfn || cc->free_pfn >= end_pfn) {
>   		cc->free_pfn = end_pfn & ~(pageblock_nr_pages-1);
>   		zone->compact_cached_free_pfn = cc->free_pfn;
>   	}
>

