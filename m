Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaEAApl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:45:41 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39985 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaEAApd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:45:33 -0400
Date: Wed, 30 Apr 2014 17:45:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] mm, thp: do not perform sync compaction on pagefault
Message-ID: <alpine.DEB.2.02.1404301744580.8415@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Synchronous memory compaction can be very expensive: it can iterate an enormous 
amount of memory without aborting and it can wait on page locks and writeback to 
complete if a pageblock cannot be defragmented.

Unfortunately, it's too expensive for pagefault for transparent hugepages and 
it's much better to simply fallback to pages.  On 128GB machines, we find that 
synchronous memory compaction can take O(seconds) for a single thp fault.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2656,7 +2656,7 @@ rebalance:
 		/* Wait for some write requests to complete then retry */
 		wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
 		goto rebalance;
-	} else {
+	} else if (!(gfp_mask & __GFP_NO_KSWAPD)) {
 		/*
 		 * High-order allocations do not necessarily loop after
 		 * direct reclaim and reclaim/compaction depends on compaction
