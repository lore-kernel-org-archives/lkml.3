Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3LEJFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 04:05:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab3LEJFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 04:05:49 -0500
Date: Thu, 5 Dec 2013 09:05:44 +0000
From: Mel Gorman <mgorman@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: compaction: Trace compaction begin and end
Message-ID: <20131205090544.GF11295@suse.de>
References: <1385389570-11393-1-git-send-email-vbabka@suse.cz>
 <20131204143045.GZ11295@suse.de>
 <529F418D.3070108@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <529F418D.3070108@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 03:51:57PM +0100, Vlastimil Babka wrote:
> On 12/04/2013 03:30 PM, Mel Gorman wrote:
> >This patch adds two tracepoints for compaction begin and end of a zone. Using
> >this it is possible to calculate how much time a workload is spending
> >within compaction and potentially debug problems related to cached pfns
> >for scanning.
> 
> I guess for debugging pfns it would be also useful to print their
> values also in mm_compaction_end.
> 

What additional information would we get from it and what new
conclusions could we draw? We could guess how much work the
scanners did but the trace_mm_compaction_isolate_freepages and
trace_mm_compaction_isolate_migratepages tracepoints already accurately
tell us that. The scanner PFNs alone do not tell us if the cached pfns
were updated and even if it did, the information can be changed by
parallel resets so it would be hard to draw reasonable conclusions from
the information. We could guess where compaction hotspots might be but
without the skip information, we could not detect it accurately.  If we
wanted to detect that accurately, the mm_compaction_isolate* tracepoints
would be the one to update.

I was primarily concerned about compaction time so I might be looking
at this the wrong way but it feels like having the PFNs at the end of a
compaction cycle would be of marginal benefit.

> >In combination with the direct reclaim and slab trace points
> >it should be possible to estimate most allocation-related overhead for
> >a workload.
> >
> >Signed-off-by: Mel Gorman <mgorman@suse.de>
> >---
> >  include/trace/events/compaction.h | 42 +++++++++++++++++++++++++++++++++++++++
> >  mm/compaction.c                   |  4 ++++
> >  2 files changed, 46 insertions(+)
> >
> >diff --git a/include/trace/events/compaction.h b/include/trace/events/compaction.h
> >index fde1b3e..f4e115a 100644
> >--- a/include/trace/events/compaction.h
> >+++ b/include/trace/events/compaction.h
> >@@ -67,6 +67,48 @@ TRACE_EVENT(mm_compaction_migratepages,
> >  		__entry->nr_failed)
> >  );
> >
> >+TRACE_EVENT(mm_compaction_begin,
> >+	TP_PROTO(unsigned long zone_start, unsigned long migrate_start,
> >+		unsigned long zone_end, unsigned long free_start),
> >+
> >+	TP_ARGS(zone_start, migrate_start, zone_end, free_start),
> 
> IMHO a better order would be:
>  zone_start, migrate_start, free_start, zone_end
> (well especially in the TP_printk part anyway).
> 

Ok, that would put them in PFN order which may be easier to visualise.
I'll post a V2 with that change at least.

-- 
Mel Gorman
SUSE Labs
