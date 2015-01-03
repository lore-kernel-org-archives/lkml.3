Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbbACQEs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 11:04:48 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:28138 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100AbbACQEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 11:04:45 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkKAAgSqFRXQzKq/2dsb2JhbABcgwYigQizcAUBAQEBAQEFAXeROYV7gQUXAQEBAQF9hDovI4EaN4gwAa8hjjeGA4l0HYIXDECBMAWFJ44sgzWJZ4dpIoFFAWyBPT0xgkMBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, linux-mm@kvack.org
Subject: [PATCH 1/1 linux-next] mm,compaction: move suitable_migration_target() under CONFIG_COMPACTION
Date: Sat,  3 Jan 2015 17:04:28 +0100
Message-Id: <1420301068-19447-1-git-send-email-fabf@skynet.be>
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
 mm/compaction.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 546e571..38b151c 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -307,28 +307,6 @@ static inline bool compact_should_abort(struct compact_control *cc)
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
@@ -802,6 +780,28 @@ isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
 
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 #ifdef CONFIG_COMPACTION
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
+
 /*
  * Based on information in the current compact_control, find blocks
  * suitable for isolating free pages from and then isolate them.
-- 
2.1.0

