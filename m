Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaEAVgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:36:14 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:51027 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaEAVfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:35:52 -0400
Date: Thu, 1 May 2014 14:35:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch v2 4/4] mm, thp: do not perform sync compaction on
 pagefault
In-Reply-To: <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1405011435210.23898@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Synchronous memory compaction can be very expensive: it can iterate an enormous 
amount of memory without aborting, constantly rescheduling, waiting on page
locks and lru_lock, etc, if a pageblock cannot be defragmented.

Unfortunately, it's too expensive for pagefault for transparent hugepages and 
it's much better to simply fallback to pages.  On 128GB machines, we find that 
synchronous memory compaction can take O(seconds) for a single thp fault.

Now that async compaction remembers where it left off without strictly relying
on sync compaction, this makes thp allocations best-effort without causing
egregious latency during pagefault.

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
