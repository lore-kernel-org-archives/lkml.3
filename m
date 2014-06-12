Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaFLS5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:57:42 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:51913 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaFLS5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:57:41 -0400
From: j.glisse@gmail.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
Subject: [PATCH 1/5] mm: differentiate unmap for vmscan from other unmap.
Date: Thu, 12 Jun 2014 14:57:30 -0400
Message-Id: <1402599454-3526-1-git-send-email-j.glisse@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402598029-3331-1-git-send-email-j.glisse@gmail.com>
References: <1402598029-3331-1-git-send-email-j.glisse@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

New code will need to be able to differentiate between a regular unmap and
an unmap trigger by vmscan in which case we want to be as quick as possible.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
---
 include/linux/rmap.h | 15 ++++++++-------
 mm/memory-failure.c  |  2 +-
 mm/vmscan.c          |  4 ++--
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index be57450..eddbc07 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -72,13 +72,14 @@ struct anon_vma_chain {
 };
 
 enum ttu_flags {
-	TTU_UNMAP = 1,			/* unmap mode */
-	TTU_MIGRATION = 2,		/* migration mode */
-	TTU_MUNLOCK = 4,		/* munlock mode */
-
-	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
-	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
-	TTU_IGNORE_HWPOISON = (1 << 10),/* corrupted page is recoverable */
+	TTU_VMSCAN = 1,			/* unmap for vmscan */
+	TTU_POISON = 2,			/* unmap for poison */
+	TTU_MIGRATION = 4,		/* migration mode */
+	TTU_MUNLOCK = 8,		/* munlock mode */
+
+	TTU_IGNORE_MLOCK = (1 << 9),	/* ignore mlock */
+	TTU_IGNORE_ACCESS = (1 << 10),	/* don't age */
+	TTU_IGNORE_HWPOISON = (1 << 11),/* corrupted page is recoverable */
 };
 
 #ifdef CONFIG_MMU
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 6f57250..11811fb 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -887,7 +887,7 @@ static int page_action(struct page_state *ps, struct page *p,
 static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 				  int trapno, int flags, struct page **hpagep)
 {
-	enum ttu_flags ttu = TTU_UNMAP | TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
+	enum ttu_flags ttu = TTU_POISON | TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	int ret;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d47f8aa..3b3137b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1161,7 +1161,7 @@ unsigned long reclaim_clean_pages_from_list(struct zone *zone,
 	}
 
 	ret = shrink_page_list(&clean_pages, zone, &sc,
-			TTU_UNMAP|TTU_IGNORE_ACCESS,
+			TTU_VMSCAN|TTU_IGNORE_ACCESS,
 			&dummy1, &dummy2, &dummy3, &dummy4, &dummy5, true);
 	list_splice(&clean_pages, page_list);
 	mod_zone_page_state(zone, NR_ISOLATED_FILE, -ret);
@@ -1514,7 +1514,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (nr_taken == 0)
 		return 0;
 
-	nr_reclaimed = shrink_page_list(&page_list, zone, sc, TTU_UNMAP,
+	nr_reclaimed = shrink_page_list(&page_list, zone, sc, TTU_VMSCAN,
 				&nr_dirty, &nr_unqueued_dirty, &nr_congested,
 				&nr_writeback, &nr_immediate,
 				false);
-- 
1.9.0

