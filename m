Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaEHFaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 01:30:10 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34138 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaEHFaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 01:30:07 -0400
Date: Wed, 7 May 2014 22:30:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch -mm] mm, thp: avoid excessive compaction latency during fault
 fix
In-Reply-To: <alpine.DEB.2.02.1405061922010.18635@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1405072229390.19108@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1405061922010.18635@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm-thp-avoid-excessive-compaction-latency-during-fault.patch excludes sync
compaction for all high order allocations other than thp.  What we really
want to do is suppress sync compaction for thp, but only during the page
fault path.

Orders greater than PAGE_ALLOC_COSTLY_ORDER aren't necessarily going to
loop again so this is the only way to exhaust our capabilities before
declaring that we can't allocate.

Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2585,16 +2585,13 @@ rebalance:
 	if (page)
 		goto got_pg;
 
-	if (gfp_mask & __GFP_NO_KSWAPD) {
-		/*
-		 * Khugepaged is allowed to try MIGRATE_SYNC_LIGHT, the latency
-		 * of this allocation isn't critical.  Everything else, however,
-		 * should only be allowed to do MIGRATE_ASYNC to avoid excessive
-		 * stalls during fault.
-		 */
-		if ((current->flags & (PF_KTHREAD | PF_KSWAPD)) == PF_KTHREAD)
-			migration_mode = MIGRATE_SYNC_LIGHT;
-	}
+	/*
+	 * It can become very expensive to allocate transparent hugepages at
+	 * fault, so use asynchronous memory compaction for THP unless it is
+	 * khugepaged trying to collapse.
+	 */
+	if (!(gfp_mask & __GFP_NO_KSWAPD) || (current->flags & PF_KTHREAD))
+		migration_mode = MIGRATE_SYNC_LIGHT;
 
 	/*
 	 * If compaction is deferred for high-order allocations, it is because
