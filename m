Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaG2AEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 20:04:41 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33883 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaG2AEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 20:04:39 -0400
Date: Mon, 28 Jul 2014 17:04:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm:;
Subject: Re: [PATCH v5 03/14] mm, compaction: do not count compact_stall if
 all zones skipped compaction
In-Reply-To: <1406553101-29326-4-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1407281703210.8998@chino.kir.corp.google.com>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-4-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Vlastimil Babka wrote:

> The compact_stall vmstat counter counts the number of allocations stalled by
> direct compaction. It does not count when all attempted zones had deferred
> compaction, but it does count when all zones skipped compaction. The skipping
> is decided based on very early check of compaction_suitable(), based on
> watermarks and memory fragmentation. Therefore it makes sense not to count
> skipped compactions as stalls. Moreover, compact_success or compact_fail is
> also already not being counted when compaction was skipped, so this patch
> changes the compact_stall counting to match the other two.
> 
> Additionally, restructure __alloc_pages_direct_compact() code for better
> readability.
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

This makes the second patch in the series more understandable but I still 
renew my suggestion that you should be doing the following as part of the 
second patch.
---
diff --git a/mm/compaction.c b/mm/compaction.c
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1136,7 +1136,7 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
 	int may_perform_io = gfp_mask & __GFP_IO;
 	struct zoneref *z;
 	struct zone *zone;
-	int rc = COMPACT_DEFERRED;
+	int rc = COMPACT_SKIPPED;
 	int alloc_flags = 0;
 
 	/* Check if the GFP flags allow compaction */
@@ -1147,6 +1147,7 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
 	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
 		alloc_flags |= ALLOC_CMA;
 #endif
+	rc = COMPACT_DEFERRED;
 	/* Compact each zone in the list */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
 								nodemask) {
