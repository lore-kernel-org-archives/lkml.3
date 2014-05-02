Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaEBPXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:23:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbaEBPXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:23:02 -0400
Message-ID: <5363B854.3010401@suse.cz>
Date: Fri, 02 May 2014 17:23:00 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch v2 2/4] mm, compaction: return failed migration target
 pages back to freelist
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011434420.23898@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1405011434420.23898@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 11:35 PM, David Rientjes wrote:
> Memory compaction works by having a "freeing scanner" scan from one end of a
> zone which isolates pages as migration targets while another "migrating scanner"
> scans from the other end of the same zone which isolates pages for migration.
>
> When page migration fails for an isolated page, the target page is returned to
> the system rather than the freelist built by the freeing scanner.  This may
> require the freeing scanner to continue scanning memory after suitable migration
> targets have already been returned to the system needlessly.
>
> This patch returns destination pages to the freeing scanner freelist when page
> migration fails.  This prevents unnecessary work done by the freeing scanner but
> also encourages memory to be as compacted as possible at the end of the zone.

Note that the free scanner work can be further reduced as it does not 
anymore need to restart on the highest pageblock where it isolated 
something. It now does that exactly for the reason that something might 
have been returned back to the allocator and we don't want to miss that.
I'll reply with a patch for that shortly (that applies on top of 
isolate_freepages() changes in -mm plus Joonsoo's not-yet-included patch 
from http://marc.info/?l=linux-mm&m=139841452326021&w=2 )

> Reported-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>   mm/compaction.c | 27 ++++++++++++++++++---------
>   1 file changed, 18 insertions(+), 9 deletions(-)
>
> diff --git a/mm/compaction.c b/mm/compaction.c
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -797,23 +797,32 @@ static struct page *compaction_alloc(struct page *migratepage,
>   }
>
>   /*
> - * We cannot control nr_migratepages and nr_freepages fully when migration is
> - * running as migrate_pages() has no knowledge of compact_control. When
> - * migration is complete, we count the number of pages on the lists by hand.
> + * This is a migrate-callback that "frees" freepages back to the isolated
> + * freelist.  All pages on the freelist are from the same zone, so there is no
> + * special handling needed for NUMA.
> + */
> +static void compaction_free(struct page *page, unsigned long data)
> +{
> +	struct compact_control *cc = (struct compact_control *)data;
> +
> +	list_add(&page->lru, &cc->freepages);
> +	cc->nr_freepages++;
> +}
> +
> +/*
> + * We cannot control nr_migratepages fully when migration is running as
> + * migrate_pages() has no knowledge of of compact_control.  When migration is
> + * complete, we count the number of pages on the list by hand.

Actually migrate_pages() returns the number of failed pages except when 
it returns an error. And then we only use the value for the tracepoint. 
I'll send a followup patch for this.

>    */
>   static void update_nr_listpages(struct compact_control *cc)
>   {
>   	int nr_migratepages = 0;
> -	int nr_freepages = 0;
>   	struct page *page;
>
>   	list_for_each_entry(page, &cc->migratepages, lru)
>   		nr_migratepages++;
> -	list_for_each_entry(page, &cc->freepages, lru)
> -		nr_freepages++;
>
>   	cc->nr_migratepages = nr_migratepages;
> -	cc->nr_freepages = nr_freepages;
>   }
>
>   /* possible outcome of isolate_migratepages */
> @@ -1023,8 +1032,8 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
>   		}
>
>   		nr_migrate = cc->nr_migratepages;
> -		err = migrate_pages(&cc->migratepages, compaction_alloc, NULL,
> -				(unsigned long)cc,
> +		err = migrate_pages(&cc->migratepages, compaction_alloc,
> +				compaction_free, (unsigned long)cc,
>   				cc->sync ? MIGRATE_SYNC_LIGHT : MIGRATE_ASYNC,
>   				MR_COMPACTION);
>   		update_nr_listpages(cc);
>

