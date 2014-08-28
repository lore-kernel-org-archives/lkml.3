Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbaH1TEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:04:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbaH1SgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:19 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 30/97] mm/compaction: change the timing to check to drop the spinlock
Date: Thu, 28 Aug 2014 19:34:38 +0100
Message-Id: <1409250945-30874-31-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

commit be1aa03b973c7dcdc576f3503f7a60429825c35d upstream.

It is odd to drop the spinlock when we scan (SWAP_CLUSTER_MAX - 1) th
pfn page.  This may results in below situation while isolating
migratepage.

1. try isolate 0x0 ~ 0x200 pfn pages.
2. When low_pfn is 0x1ff, ((low_pfn+1) % SWAP_CLUSTER_MAX) == 0, so drop
   the spinlock.
3. Then, to complete isolating, retry to aquire the lock.

I think that it is better to use SWAP_CLUSTER_MAX th pfn for checking the
criteria about dropping the lock.  This has no harm 0x0 pfn, because, at
this time, locked variable would be false.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 6718a91..4730a2f 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -488,7 +488,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 	cond_resched();
 	for (; low_pfn < end_pfn; low_pfn++) {
 		/* give a chance to irqs before checking need_resched() */
-		if (locked && !((low_pfn+1) % SWAP_CLUSTER_MAX)) {
+		if (locked && !(low_pfn % SWAP_CLUSTER_MAX)) {
 			if (should_release_lock(&zone->lru_lock)) {
 				spin_unlock_irqrestore(&zone->lru_lock, flags);
 				locked = false;
-- 
1.8.4.5

