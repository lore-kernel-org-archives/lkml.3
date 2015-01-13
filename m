Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbbAMSWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:22:08 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:1986 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbbAMSVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:21:53 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgENAGNhtVRbtBuH/2dsb2JhbABbgwYigQizPQUBAQEBAQEFAXeRQoV7gRtEAQEBAQF9hDovI4EaN4gwAcFvjjyGBYl0HYIXDECBMAWFNo5Xg0KJf4d9IoFFAWyBPT0xgkMBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, linux-mm@kvack.org
Subject: [PATCH V2 linux-next] mm,compaction: move suitable_migration_target() under CONFIG_COMPACTION
Date: Tue, 13 Jan 2015 19:21:44 +0100
Message-Id: <1421173304-11514-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

suitable_migration_target() is only used by isolate_freepages()
Define it under CONFIG_COMPACTION || CONFIG_CMA is not needed.

Fix the following warning:
mm/compaction.c:311:13: warning: 'suitable_migration_target' defined
but not used [-Wunused-function]

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
v2: move function below update_pageblock_skip() instead of above 
isolate_freepages() (suggested by Vlastimil Babka)


 mm/compaction.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 546e571..580790d 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -207,6 +207,28 @@ static void update_pageblock_skip(struct compact_control *cc,
 			zone->compact_cached_free_pfn = pfn;
 	}
 }
+
+/* Returns true if the page is within a block suitable for migration to */
+static bool suitable_migration_target(struct page *page)
+{
+	/* If the page is a large free page, then disallow migration */
+	if (PageBuddy(page)) {
+		/*
+		 * We are checking page_order without zone->lock taken. But
+		 * the only small danger is that we skip a potentially suitable
+		 * pageblock, so it's not worth to check order for valid range.
+		 */
+		if (page_order_unsafe(page) >= pageblock_order)
+			return false;
+	}
+
+	/* If the block is MIGRATE_MOVABLE or MIGRATE_CMA, allow migration */
+	if (migrate_async_suitable(get_pageblock_migratetype(page)))
+		return true;
+
+	/* Otherwise skip the block */
+	return false;
+}
 #else
 static inline bool isolation_suitable(struct compact_control *cc,
 					struct page *page)
@@ -307,28 +329,6 @@ static inline bool compact_should_abort(struct compact_control *cc)
 	return false;
 }
 
-/* Returns true if the page is within a block suitable for migration to */
-static bool suitable_migration_target(struct page *page)
-{
-	/* If the page is a large free page, then disallow migration */
-	if (PageBuddy(page)) {
-		/*
-		 * We are checking page_order without zone->lock taken. But
-		 * the only small danger is that we skip a potentially suitable
-		 * pageblock, so it's not worth to check order for valid range.
-		 */
-		if (page_order_unsafe(page) >= pageblock_order)
-			return false;
-	}
-
-	/* If the block is MIGRATE_MOVABLE or MIGRATE_CMA, allow migration */
-	if (migrate_async_suitable(get_pageblock_migratetype(page)))
-		return true;
-
-	/* Otherwise skip the block */
-	return false;
-}
-
 /*
  * Isolate free pages onto a private freelist. If @strict is true, will abort
  * returning 0 on any invalid PFNs or non-free pages inside of the pageblock
-- 
2.1.0

