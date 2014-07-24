Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbaGXWlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 18:41:11 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:64634 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaGXWlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 18:41:09 -0400
Date: Thu, 24 Jul 2014 15:41:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch] mm, thp: restructure thp avoidance of light synchronous
 migration
Message-ID: <alpine.DEB.2.02.1407241540190.22557@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__GFP_NO_KSWAPD, once the way to determine if an allocation was for thp or not, 
has gained more users.  Their use is not necessarily wrong, they are trying to 
do a memory allocation that can easily fail without disturbing kswapd, so the 
bit has gained additional usecases.

This restructures the check to determine whether MIGRATE_SYNC_LIGHT should be 
used for memory compaction in the page allocator.  Rather than testing solely 
for __GFP_NO_KSWAPD, test for all bits that must be set for thp allocations.

This also moves the check to be done only after the page allocator is aborted 
for deferred or contended memory compaction since setting migration_mode for 
this case is pointless.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2616,14 +2616,6 @@ rebalance:
 		goto got_pg;
 
 	/*
-	 * It can become very expensive to allocate transparent hugepages at
-	 * fault, so use asynchronous memory compaction for THP unless it is
-	 * khugepaged trying to collapse.
-	 */
-	if (!(gfp_mask & __GFP_NO_KSWAPD) || (current->flags & PF_KTHREAD))
-		migration_mode = MIGRATE_SYNC_LIGHT;
-
-	/*
 	 * If compaction is deferred for high-order allocations, it is because
 	 * sync compaction recently failed. In this is the case and the caller
 	 * requested a movable allocation that does not heavily disrupt the
@@ -2633,6 +2625,15 @@ rebalance:
 						(gfp_mask & __GFP_NO_KSWAPD))
 		goto nopage;
 
+	/*
+	 * It can become very expensive to allocate transparent hugepages at
+	 * fault, so use asynchronous memory compaction for THP unless it is
+	 * khugepaged trying to collapse.
+	 */
+	if ((gfp_mask & GFP_TRANSHUGE) != GFP_TRANSHUGE ||
+						(current->flags & PF_KTHREAD))
+		migration_mode = MIGRATE_SYNC_LIGHT;
+
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
