Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaG2Ao2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 20:44:28 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:55176 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaG2AoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 20:44:25 -0400
Date: Mon, 28 Jul 2014 17:44:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm:;
Subject: Re: [PATCH v5 06/14] mm, compaction: reduce zone checking frequency
 in the migration scanner
In-Reply-To: <1406553101-29326-7-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1407281742580.8998@chino.kir.corp.google.com>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-7-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Vlastimil Babka wrote:

> The unification of the migrate and free scanner families of function has
> highlighted a difference in how the scanners ensure they only isolate pages
> of the intended zone. This is important for taking zone lock or lru lock of
> the correct zone. Due to nodes overlapping, it is however possible to
> encounter a different zone within the range of the zone being compacted.
> 
> The free scanner, since its inception by commit 748446bb6b5a ("mm: compaction:
> memory compaction core"), has been checking the zone of the first valid page
> in a pageblock, and skipping the whole pageblock if the zone does not match.
> 
> This checking was completely missing from the migration scanner at first, and
> later added by commit dc9086004b3d ("mm: compaction: check for overlapping
> nodes during isolation for migration") in a reaction to a bug report.
> But the zone comparison in migration scanner is done once per a single scanned
> page, which is more defensive and thus more costly than a check per pageblock.
> 
> This patch unifies the checking done in both scanners to once per pageblock,
> through a new pageblock_within_zone() function, which also includes pfn_valid()
> checks. It is more defensive than the current free scanner checks, as it checks
> both the first and last page of the pageblock, but less defensive by the
> migration scanner per-page checks. It assumes that node overlapping may result
> (on some architecture) in a boundary between two nodes falling into the middle
> of a pageblock, but that there cannot be a node0 node1 node0 interleaving
> within a single pageblock.
> 
> The result is more code being shared and a bit less per-page CPU cost in the
> migration scanner.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> Acked-by: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>

Minor comments below.

> ---
>  mm/compaction.c | 91 ++++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 57 insertions(+), 34 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index bac6e37..76a9775 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -67,6 +67,49 @@ static inline bool migrate_async_suitable(int migratetype)
>  	return is_migrate_cma(migratetype) || migratetype == MIGRATE_MOVABLE;
>  }
>  
> +/*
> + * Check that the whole (or subset of) a pageblock given by the interval of
> + * [start_pfn, end_pfn) is valid and within the same zone, before scanning it
> + * with the migration of free compaction scanner. The scanners then need to
> + * use only pfn_valid_within() check for arches that allow holes within
> + * pageblocks.
> + *
> + * Return struct page pointer of start_pfn, or NULL if checks were not passed.
> + *
> + * It's possible on some configurations to have a setup like node0 node1 node0
> + * i.e. it's possible that all pages within a zones range of pages do not
> + * belong to a single zone. We assume that a border between node0 and node1
> + * can occur within a single pageblock, but not a node0 node1 node0
> + * interleaving within a single pageblock. It is therefore sufficient to check
> + * the first and last page of a pageblock and avoid checking each individual
> + * page in a pageblock.
> + */
> +static struct page *pageblock_within_zone(unsigned long start_pfn,
> +				unsigned long end_pfn, struct zone *zone)

The name of this function is quite strange, it's returning a pointer to  
the actual start page but the name implies it would be a boolean.

> +{
> +	struct page *start_page;
> +	struct page *end_page;
> +
> +	/* end_pfn is one past the range we are checking */
> +	end_pfn--;
> +

With the given implementation, yes, but I'm not sure if that should be
assumed for any class of callers.  It seems better to call with
end_pfn - 1.            

> +	if (!pfn_valid(start_pfn) || !pfn_valid(end_pfn))
> +		return NULL;
> +

Ok, so even with this check, we still need to check pfn_valid_within() for
all pfns between start_pfn and end_pfn if there are memory holes.  I 
checked that both the migration and freeing scanners do that before 
reading your comment above the function, looks good.
