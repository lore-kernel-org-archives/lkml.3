Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbbALOc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:32:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbbALOc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:32:56 -0500
Message-ID: <54B3DB16.8030205@suse.cz>
Date: Mon, 12 Jan 2015 15:32:54 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] mm/compaction: enhance tracepoint output for compaction
 begin/end
References: <1421050875-26332-1-git-send-email-iamjoonsoo.kim@lge.com> <1421050875-26332-2-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1421050875-26332-2-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 09:21 AM, Joonsoo Kim wrote:
> We now have tracepoint for begin event of compaction and it prints
> start position of both scanners, but, tracepoint for end event of
> compaction doesn't print finish position of both scanners. It'd be
> also useful to know finish position of both scanners so this patch
> add it. It will help to find odd behavior or problem on compaction
> internal logic.
> 
> And, mode is added to both begin/end tracepoint output, since
> according to mode, compaction behavior is quite different.
> 
> And, lastly, status format is changed to string rather than
> status number for readability.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  include/linux/compaction.h        |    2 ++
>  include/trace/events/compaction.h |   49 ++++++++++++++++++++++++++-----------
>  mm/compaction.c                   |   14 +++++++++--
>  3 files changed, 49 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
> index 3238ffa..a9547b6 100644
> --- a/include/linux/compaction.h
> +++ b/include/linux/compaction.h
> @@ -12,6 +12,7 @@
>  #define COMPACT_PARTIAL		3
>  /* The full zone was compacted */
>  #define COMPACT_COMPLETE	4
> +/* When adding new state, please change compaction_status_string, too */
>  
>  /* Used to signal whether compaction detected need_sched() or lock contention */
>  /* No contention detected */
> @@ -22,6 +23,7 @@
>  #define COMPACT_CONTENDED_LOCK	2
>  
>  #ifdef CONFIG_COMPACTION
> +extern char *compaction_status_string[];
>  extern int sysctl_compact_memory;
>  extern int sysctl_compaction_handler(struct ctl_table *table, int write,
>  			void __user *buffer, size_t *length, loff_t *ppos);
> diff --git a/include/trace/events/compaction.h b/include/trace/events/compaction.h
> index 1337d9e..839f6fa 100644
> --- a/include/trace/events/compaction.h
> +++ b/include/trace/events/compaction.h
> @@ -85,46 +85,67 @@ TRACE_EVENT(mm_compaction_migratepages,
>  );
>  
>  TRACE_EVENT(mm_compaction_begin,
> -	TP_PROTO(unsigned long zone_start, unsigned long migrate_start,
> -		unsigned long free_start, unsigned long zone_end),
> +	TP_PROTO(unsigned long zone_start, unsigned long migrate_pfn,
> +		unsigned long free_pfn, unsigned long zone_end, bool sync),
>  
> -	TP_ARGS(zone_start, migrate_start, free_start, zone_end),
> +	TP_ARGS(zone_start, migrate_pfn, free_pfn, zone_end, sync),
>  
>  	TP_STRUCT__entry(
>  		__field(unsigned long, zone_start)
> -		__field(unsigned long, migrate_start)
> -		__field(unsigned long, free_start)
> +		__field(unsigned long, migrate_pfn)
> +		__field(unsigned long, free_pfn)
>  		__field(unsigned long, zone_end)
> +		__field(bool, sync)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->zone_start = zone_start;
> -		__entry->migrate_start = migrate_start;
> -		__entry->free_start = free_start;
> +		__entry->migrate_pfn = migrate_pfn;
> +		__entry->free_pfn = free_pfn;
>  		__entry->zone_end = zone_end;
> +		__entry->sync = sync;
>  	),
>  
> -	TP_printk("zone_start=0x%lx migrate_start=0x%lx free_start=0x%lx zone_end=0x%lx",
> +	TP_printk("zone_start=0x%lx migrate_pfn=0x%lx free_pfn=0x%lx zone_end=0x%lx, mode=%s",
>  		__entry->zone_start,
> -		__entry->migrate_start,
> -		__entry->free_start,
> -		__entry->zone_end)
> +		__entry->migrate_pfn,
> +		__entry->free_pfn,
> +		__entry->zone_end,
> +		__entry->sync ? "sync" : "async")
>  );
>  
>  TRACE_EVENT(mm_compaction_end,
> -	TP_PROTO(int status),
> +	TP_PROTO(unsigned long zone_start, unsigned long migrate_pfn,
> +		unsigned long free_pfn, unsigned long zone_end, bool sync,
> +		int status),
>  
> -	TP_ARGS(status),
> +	TP_ARGS(zone_start, migrate_pfn, free_pfn, zone_end, sync, status),
>  
>  	TP_STRUCT__entry(
> +		__field(unsigned long, zone_start)
> +		__field(unsigned long, migrate_pfn)
> +		__field(unsigned long, free_pfn)
> +		__field(unsigned long, zone_end)
> +		__field(bool, sync)
>  		__field(int, status)
>  	),
>  
>  	TP_fast_assign(
> +		__entry->zone_start = zone_start;
> +		__entry->migrate_pfn = migrate_pfn;
> +		__entry->free_pfn = free_pfn;
> +		__entry->zone_end = zone_end;
> +		__entry->sync = sync;
>  		__entry->status = status;
>  	),
>  
> -	TP_printk("status=%d", __entry->status)
> +	TP_printk("zone_start=0x%lx migrate_pfn=0x%lx free_pfn=0x%lx zone_end=0x%lx, mode=%s status=%s",
> +		__entry->zone_start,
> +		__entry->migrate_pfn,
> +		__entry->free_pfn,
> +		__entry->zone_end,
> +		__entry->sync ? "sync" : "async",
> +		compaction_status_string[__entry->status])
>  );
>  
>  #endif /* _TRACE_COMPACTION_H */
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 546e571..2d86a20 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -19,6 +19,14 @@
>  #include "internal.h"
>  
>  #ifdef CONFIG_COMPACTION
> +char *compaction_status_string[] = {
> +	"deferred",
> +	"skipped",
> +	"continue",
> +	"partial",
> +	"complete",
> +};
> +
>  static inline void count_compact_event(enum vm_event_item item)
>  {
>  	count_vm_event(item);
> @@ -1197,7 +1205,8 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
>  		zone->compact_cached_migrate_pfn[1] = cc->migrate_pfn;
>  	}
>  
> -	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn, cc->free_pfn, end_pfn);
> +	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn,
> +				cc->free_pfn, end_pfn, sync);
>  
>  	migrate_prep_local();
>  
> @@ -1299,7 +1308,8 @@ out:
>  			zone->compact_cached_free_pfn = free_pfn;
>  	}
>  
> -	trace_mm_compaction_end(ret);
> +	trace_mm_compaction_end(start_pfn, cc->migrate_pfn,
> +				cc->free_pfn, end_pfn, sync, ret);
>  
>  	return ret;
>  }
> 

