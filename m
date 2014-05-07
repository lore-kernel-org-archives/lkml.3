Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbaEGCXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 22:23:43 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38530 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaEGCWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 22:22:52 -0400
Date: Tue, 6 May 2014 19:22:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch v3 5/6] mm, thp: avoid excessive compaction latency during
 fault
In-Reply-To: <alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1405061922010.18635@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Synchronous memory compaction can be very expensive: it can iterate an enormous 
amount of memory without aborting, constantly rescheduling, waiting on page
locks and lru_lock, etc, if a pageblock cannot be defragmented.

Unfortunately, it's too expensive for transparent hugepage page faults and 
it's much better to simply fallback to pages.  On 128GB machines, we find that 
synchronous memory compaction can take O(seconds) for a single thp fault.

Now that async compaction remembers where it left off without strictly relying
on sync compaction, this makes thp allocations best-effort without causing
egregious latency during fault.  We still need to retry async compaction after
reclaim, but this won't stall for seconds.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2584,7 +2584,17 @@ rebalance:
 					&did_some_progress);
 	if (page)
 		goto got_pg;
-	migration_mode = MIGRATE_SYNC_LIGHT;
+
+	if (gfp_mask & __GFP_NO_KSWAPD) {
+		/*
+		 * Khugepaged is allowed to try MIGRATE_SYNC_LIGHT, the latency
+		 * of this allocation isn't critical.  Everything else, however,
+		 * should only be allowed to do MIGRATE_ASYNC to avoid excessive
+		 * stalls during fault.
+		 */
+		if ((current->flags & (PF_KTHREAD | PF_KSWAPD)) == PF_KTHREAD)
+			migration_mode = MIGRATE_SYNC_LIGHT;
+	}
 
 	/*
 	 * If compaction is deferred for high-order allocations, it is because
