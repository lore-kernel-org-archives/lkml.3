Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaH1Sym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:54:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbaH1Sgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:43 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 54/97] mm, compaction: return failed migration target pages back to freelist
Date: Thu, 28 Aug 2014 19:35:02 +0100
Message-Id: <1409250945-30874-55-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

commit d53aea3d46d64e95da9952887969f7533b9ab25e upstream.

Greg reported that he found isolated free pages were returned back to the
VM rather than the compaction freelist.  This will cause holes behind the
free scanner and cause it to reallocate additional memory if necessary
later.

He detected the problem at runtime seeing that ext4 metadata pages (esp
the ones read by "sbi->s_group_desc[i] = sb_bread(sb, block)") were
constantly visited by compaction calls of migrate_pages().  These pages
had a non-zero b_count which caused fallback_migrate_page() ->
try_to_release_page() -> try_to_free_buffers() to fail.

Memory compaction works by having a "freeing scanner" scan from one end of
a zone which isolates pages as migration targets while another "migrating
scanner" scans from the other end of the same zone which isolates pages
for migration.

When page migration fails for an isolated page, the target page is
returned to the system rather than the freelist built by the freeing
scanner.  This may require the freeing scanner to continue scanning memory
after suitable migration targets have already been returned to the system
needlessly.

This patch returns destination pages to the freeing scanner freelist when
page migration fails.  This prevents unnecessary work done by the freeing
scanner but also encourages memory to be as compacted as possible at the
end of the zone.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Greg Thelen <gthelen@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index fae59ea..e4add42 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -788,23 +788,32 @@ static struct page *compaction_alloc(struct page *migratepage,
 }
 
 /*
- * We cannot control nr_migratepages and nr_freepages fully when migration is
- * running as migrate_pages() has no knowledge of compact_control. When
- * migration is complete, we count the number of pages on the lists by hand.
+ * This is a migrate-callback that "frees" freepages back to the isolated
+ * freelist.  All pages on the freelist are from the same zone, so there is no
+ * special handling needed for NUMA.
+ */
+static void compaction_free(struct page *page, unsigned long data)
+{
+	struct compact_control *cc = (struct compact_control *)data;
+
+	list_add(&page->lru, &cc->freepages);
+	cc->nr_freepages++;
+}
+
+/*
+ * We cannot control nr_migratepages fully when migration is running as
+ * migrate_pages() has no knowledge of of compact_control.  When migration is
+ * complete, we count the number of pages on the list by hand.
  */
 static void update_nr_listpages(struct compact_control *cc)
 {
 	int nr_migratepages = 0;
-	int nr_freepages = 0;
 	struct page *page;
 
 	list_for_each_entry(page, &cc->migratepages, lru)
 		nr_migratepages++;
-	list_for_each_entry(page, &cc->freepages, lru)
-		nr_freepages++;
 
 	cc->nr_migratepages = nr_migratepages;
-	cc->nr_freepages = nr_freepages;
 }
 
 /* possible outcome of isolate_migratepages */
@@ -1014,8 +1023,8 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 		}
 
 		nr_migrate = cc->nr_migratepages;
-		err = migrate_pages(&cc->migratepages, compaction_alloc, NULL,
-				(unsigned long)cc,
+		err = migrate_pages(&cc->migratepages, compaction_alloc,
+				compaction_free, (unsigned long)cc,
 				cc->sync ? MIGRATE_SYNC_LIGHT : MIGRATE_ASYNC,
 				MR_COMPACTION);
 		update_nr_listpages(cc);
-- 
1.8.4.5

