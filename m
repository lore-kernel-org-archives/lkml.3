Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaH1TEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:04:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbaH1SgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:20 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 32/97] mm/compaction: clean-up code on success of ballon isolation
Date: Thu, 28 Aug 2014 19:34:40 +0100
Message-Id: <1409250945-30874-33-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

commit b6c750163c0d138f5041d95fcdbd1094b6928057 upstream.

It is just for clean-up to reduce code size and improve readability.
There is no functional change.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 229c6f7..10f9f8c 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -560,11 +560,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			if (unlikely(balloon_page_movable(page))) {
 				if (locked && balloon_page_isolate(page)) {
 					/* Successfully isolated */
-					cc->finished_update_migrate = true;
-					list_add(&page->lru, migratelist);
-					cc->nr_migratepages++;
-					nr_isolated++;
-					goto check_compact_cluster;
+					goto isolate_success;
 				}
 			}
 			continue;
@@ -625,13 +621,14 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		VM_BUG_ON(PageTransCompound(page));
 
 		/* Successfully isolated */
-		cc->finished_update_migrate = true;
 		del_page_from_lru_list(page, lruvec, page_lru(page));
+
+isolate_success:
+		cc->finished_update_migrate = true;
 		list_add(&page->lru, migratelist);
 		cc->nr_migratepages++;
 		nr_isolated++;
 
-check_compact_cluster:
 		/* Avoid isolating too much */
 		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX) {
 			++low_pfn;
-- 
1.8.4.5

