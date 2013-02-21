Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab3BUTmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:42:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab3BUTmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:42:45 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] migrate: clean up migrate_huge_page()
Date: Thu, 21 Feb 2013 14:41:43 -0500
Message-Id: <1361475708-25991-5-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the previous patch, soft_offline_huge_page() switches to use
migrate_pages(), and migrate_huge_page() is not used any more.
So let's remove it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 include/linux/migrate.h |  6 ------
 mm/migrate.c            | 28 ----------------------------
 2 files changed, 34 deletions(-)

diff --git v3.8.orig/include/linux/migrate.h v3.8/include/linux/migrate.h
index d626c27..dc085e1 100644
--- v3.8.orig/include/linux/migrate.h
+++ v3.8/include/linux/migrate.h
@@ -45,9 +45,6 @@ extern int migrate_pages(struct list_head *l, new_page_t x,
 extern int migrate_movable_pages(struct list_head *from,
 		new_page_t get_new_page, unsigned long private, bool offlining,
 		enum migrate_mode mode, int reason);
-extern int migrate_huge_page(struct page *, new_page_t x,
-			unsigned long private, bool offlining,
-			enum migrate_mode mode);
 
 extern int fail_migrate_page(struct address_space *,
 			struct page *, struct page *);
@@ -70,9 +67,6 @@ static inline int migrate_pages(struct list_head *l, new_page_t x,
 static inline int migrate_movable_pages(struct list_head *from,
 		new_page_t get_new_page, unsigned long private, bool offlining,
 		enum migrate_mode mode, int reason) { return -ENOSYS; }
-static inline int migrate_huge_page(struct page *page, new_page_t x,
-		unsigned long private, bool offlining,
-		enum migrate_mode mode) { return -ENOSYS; }
 
 static inline int migrate_prep(void) { return -ENOSYS; }
 static inline int migrate_prep_local(void) { return -ENOSYS; }
diff --git v3.8.orig/mm/migrate.c v3.8/mm/migrate.c
index 8c13cc5..7b2ca1a 100644
--- v3.8.orig/mm/migrate.c
+++ v3.8/mm/migrate.c
@@ -1106,34 +1106,6 @@ int migrate_movable_pages(struct list_head *from, new_page_t get_new_page,
 	return err;
 }
 
-int migrate_huge_page(struct page *hpage, new_page_t get_new_page,
-		      unsigned long private, bool offlining,
-		      enum migrate_mode mode)
-{
-	int pass, rc;
-
-	for (pass = 0; pass < 10; pass++) {
-		rc = unmap_and_move_huge_page(get_new_page,
-					      private, hpage, pass > 2, offlining,
-					      mode);
-		switch (rc) {
-		case -ENOMEM:
-			goto out;
-		case -EAGAIN:
-			/* try again */
-			cond_resched();
-			break;
-		case MIGRATEPAGE_SUCCESS:
-			goto out;
-		default:
-			rc = -EIO;
-			goto out;
-		}
-	}
-out:
-	return rc;
-}
-
 #ifdef CONFIG_NUMA
 /*
  * Move a list of individual pages
-- 
1.7.11.7

