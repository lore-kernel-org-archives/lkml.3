Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab3LFJvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:51:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897Ab3LFJvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:51:01 -0500
Message-ID: <52A19E02.2010907@suse.cz>
Date: Fri, 06 Dec 2013 10:50:58 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: compaction: Trace compaction begin and end v2
References: <1385389570-11393-1-git-send-email-vbabka@suse.cz> <20131204143045.GZ11295@suse.de> <529F418D.3070108@suse.cz> <20131205090742.GG11295@suse.de>
In-Reply-To: <20131205090742.GG11295@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 10:07 AM, Mel Gorman wrote:
> Changelog since V1
> o Print output parameters in pfn order			(vbabka)
>
> This patch adds two tracepoints for compaction begin and end of a zone. Using
> this it is possible to calculate how much time a workload is spending
> within compaction and potentially debug problems related to cached pfns
> for scanning. In combination with the direct reclaim and slab trace points
> it should be possible to estimate most allocation-related overhead for
> a workload.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>   include/trace/events/compaction.h | 42 +++++++++++++++++++++++++++++++++++++++
>   mm/compaction.c                   |  4 ++++
>   2 files changed, 46 insertions(+)
>
> diff --git a/include/trace/events/compaction.h b/include/trace/events/compaction.h
> index fde1b3e..06f544e 100644
> --- a/include/trace/events/compaction.h
> +++ b/include/trace/events/compaction.h
> @@ -67,6 +67,48 @@ TRACE_EVENT(mm_compaction_migratepages,
>   		__entry->nr_failed)
>   );
>
> +TRACE_EVENT(mm_compaction_begin,
> +	TP_PROTO(unsigned long zone_start, unsigned long migrate_start,
> +		unsigned long free_start, unsigned long zone_end),
> +
> +	TP_ARGS(zone_start, migrate_start, free_start, zone_end),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, zone_start)
> +		__field(unsigned long, migrate_start)
> +		__field(unsigned long, free_start)
> +		__field(unsigned long, zone_end)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->zone_start = zone_start;
> +		__entry->migrate_start = migrate_start;
> +		__entry->free_start = free_start;
> +		__entry->zone_end = zone_end;
> +	),
> +
> +	TP_printk("zone_start=%lu migrate_start=%lu free_start=%lu zone_end=%lu",
> +		__entry->zone_start,
> +		__entry->migrate_start,
> +		__entry->free_start,
> +		__entry->zone_end)
> +);
> +
> +TRACE_EVENT(mm_compaction_end,
> +	TP_PROTO(int status),
> +
> +	TP_ARGS(status),
> +
> +	TP_STRUCT__entry(
> +		__field(int, status)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->status = status;
> +	),
> +
> +	TP_printk("status=%d", __entry->status)
> +);
>
>   #endif /* _TRACE_COMPACTION_H */
>
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 805165b..bb50fd3 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -966,6 +966,8 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
>   	if (compaction_restarting(zone, cc->order) && !current_is_kswapd())
>   		__reset_isolation_suitable(zone);
>
> +	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn, cc->free_pfn, end_pfn);
> +
>   	migrate_prep_local();
>
>   	while ((ret = compact_finished(zone, cc)) == COMPACT_CONTINUE) {
> @@ -1011,6 +1013,8 @@ out:
>   	cc->nr_freepages -= release_freepages(&cc->freepages);
>   	VM_BUG_ON(cc->nr_freepages != 0);
>
> +	trace_mm_compaction_end(ret);
> +
>   	return ret;
>   }
>
>

