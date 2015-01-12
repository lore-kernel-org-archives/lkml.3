Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbbALOe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:34:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49426 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbbALOe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:34:56 -0500
Message-ID: <54B3DB8D.3000005@suse.cz>
Date: Mon, 12 Jan 2015 15:34:53 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] mm/compaction: print current range where compaction
 work
References: <1421050875-26332-1-git-send-email-iamjoonsoo.kim@lge.com> <1421050875-26332-3-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1421050875-26332-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 09:21 AM, Joonsoo Kim wrote:
> It'd be useful to know current range where compaction work for detailed
> analysis. With it, we can know pageblock where we actually scan and
> isolate, and, how much pages we try in that pageblock and can guess why
> it doesn't become freepage with pageblock order roughly.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  include/trace/events/compaction.h |   30 +++++++++++++++++++++++-------
>  mm/compaction.c                   |    9 ++++++---
>  2 files changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/include/trace/events/compaction.h b/include/trace/events/compaction.h
> index 839f6fa..139020b 100644
> --- a/include/trace/events/compaction.h
> +++ b/include/trace/events/compaction.h
> @@ -11,39 +11,55 @@
>  
>  DECLARE_EVENT_CLASS(mm_compaction_isolate_template,
>  
> -	TP_PROTO(unsigned long nr_scanned,
> +	TP_PROTO(
> +		unsigned long start_pfn,
> +		unsigned long end_pfn,
> +		unsigned long nr_scanned,
>  		unsigned long nr_taken),
>  
> -	TP_ARGS(nr_scanned, nr_taken),
> +	TP_ARGS(start_pfn, end_pfn, nr_scanned, nr_taken),
>  
>  	TP_STRUCT__entry(
> +		__field(unsigned long, start_pfn)
> +		__field(unsigned long, end_pfn)
>  		__field(unsigned long, nr_scanned)
>  		__field(unsigned long, nr_taken)
>  	),
>  
>  	TP_fast_assign(
> +		__entry->start_pfn = start_pfn;
> +		__entry->end_pfn = end_pfn;
>  		__entry->nr_scanned = nr_scanned;
>  		__entry->nr_taken = nr_taken;
>  	),
>  
> -	TP_printk("nr_scanned=%lu nr_taken=%lu",
> +	TP_printk("range=(0x%lx ~ 0x%lx) nr_scanned=%lu nr_taken=%lu",
> +		__entry->start_pfn,
> +		__entry->end_pfn,
>  		__entry->nr_scanned,
>  		__entry->nr_taken)
>  );
>  
>  DEFINE_EVENT(mm_compaction_isolate_template, mm_compaction_isolate_migratepages,
>  
> -	TP_PROTO(unsigned long nr_scanned,
> +	TP_PROTO(
> +		unsigned long start_pfn,
> +		unsigned long end_pfn,
> +		unsigned long nr_scanned,
>  		unsigned long nr_taken),
>  
> -	TP_ARGS(nr_scanned, nr_taken)
> +	TP_ARGS(start_pfn, end_pfn, nr_scanned, nr_taken)
>  );
>  
>  DEFINE_EVENT(mm_compaction_isolate_template, mm_compaction_isolate_freepages,
> -	TP_PROTO(unsigned long nr_scanned,
> +
> +	TP_PROTO(
> +		unsigned long start_pfn,
> +		unsigned long end_pfn,
> +		unsigned long nr_scanned,
>  		unsigned long nr_taken),
>  
> -	TP_ARGS(nr_scanned, nr_taken)
> +	TP_ARGS(start_pfn, end_pfn, nr_scanned, nr_taken)
>  );
>  
>  TRACE_EVENT(mm_compaction_migratepages,
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 2d86a20..be28469 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -429,11 +429,12 @@ isolate_fail:
>  
>  	}
>  
> +	trace_mm_compaction_isolate_freepages(*start_pfn, blockpfn,
> +					nr_scanned, total_isolated);
> +
>  	/* Record how far we have got within the block */
>  	*start_pfn = blockpfn;
>  
> -	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);
> -
>  	/*
>  	 * If strict isolation is requested by CMA then check that all the
>  	 * pages requested were isolated. If there were any failures, 0 is
> @@ -589,6 +590,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  	unsigned long flags = 0;
>  	bool locked = false;
>  	struct page *page = NULL, *valid_page = NULL;
> +	unsigned long start_pfn = low_pfn;
>  
>  	/*
>  	 * Ensure that there are not too many pages isolated from the LRU
> @@ -749,7 +751,8 @@ isolate_success:
>  	if (low_pfn == end_pfn)
>  		update_pageblock_skip(cc, valid_page, nr_isolated, true);
>  
> -	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
> +	trace_mm_compaction_isolate_migratepages(start_pfn, low_pfn,
> +						nr_scanned, nr_isolated);
>  
>  	count_compact_events(COMPACTMIGRATE_SCANNED, nr_scanned);
>  	if (nr_isolated)
> 

