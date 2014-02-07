Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaBGFJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:09:49 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57432 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaBGFIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:08:50 -0500
X-AuditID: 9c93016f-b7b0cae0000024a7-3b-52f46a5f1741
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/5] mm/compaction: change the timing to check to drop the spinlock
Date: Fri,  7 Feb 2014 14:08:44 +0900
Message-Id: <1391749726-28910-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391749726-28910-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1391749726-28910-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is odd to drop the spinlock when we scan (SWAP_CLUSTER_MAX - 1) th pfn
page. This may results in below situation while isolating migratepage.

1. try isolate 0x0 ~ 0x200 pfn pages.
2. When low_pfn is 0x1ff, ((low_pfn+1) % SWAP_CLUSTER_MAX) == 0, so drop
the spinlock.
3. Then, to complete isolating, retry to aquire the lock.

I think that it is better to use SWAP_CLUSTER_MAX th pfn for checking
the criteria about dropping the lock. This has no harm 0x0 pfn, because,
at this time, locked variable would be false.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/compaction.c b/mm/compaction.c
index 0d821a2..b1ba297 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -481,7 +481,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 	cond_resched();
 	for (; low_pfn < end_pfn; low_pfn++) {
 		/* give a chance to irqs before checking need_resched() */
-		if (locked && !((low_pfn+1) % SWAP_CLUSTER_MAX)) {
+		if (locked && !(low_pfn % SWAP_CLUSTER_MAX)) {
 			if (should_release_lock(&zone->lru_lock)) {
 				spin_unlock_irqrestore(&zone->lru_lock, flags);
 				locked = false;
-- 
1.7.9.5

