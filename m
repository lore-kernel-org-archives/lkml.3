Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbaAJCkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:40:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:38667 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbaAJCkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:40:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,635,1384329600"; 
   d="scan'208";a="464478251"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 2/6] Factor page_endio() out of mpage_end_io()
Date: Thu,  9 Jan 2014 21:39:47 -0500
Message-Id: <1389321591-25455-2-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1387748522.git.matthew.r.wilcox@intel.com>
References: <cover.1387748522.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page_endio() takes care of updating all the appropriate page flags once I/O
has finished to a page.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/mpage.c              | 17 +----------------
 include/linux/pagemap.h |  2 ++
 mm/filemap.c            | 25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index b8552ae..9c21dc0 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -51,22 +51,7 @@ static void mpage_end_io(struct bio *bio, int err)
 
 		if (--bvec >= bio->bi_io_vec)
 			prefetchw(&bvec->bv_page->flags);
-		if (bio_data_dir(bio) == READ) {
-			if (uptodate) {
-				SetPageUptodate(page);
-			} else {
-				ClearPageUptodate(page);
-				SetPageError(page);
-			}
-			unlock_page(page);
-		} else { /* bio_data_dir(bio) == WRITE */
-			if (!uptodate) {
-				SetPageError(page);
-				if (page->mapping)
-					set_bit(AS_EIO, &page->mapping->flags);
-			}
-			end_page_writeback(page);
-		}
+		page_endio(page, bio_data_dir(bio), uptodate);
 	} while (bvec >= bio->bi_io_vec);
 	bio_put(bio);
 }
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index e3dea75..2271f19 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -416,6 +416,8 @@ static inline void wait_on_page_writeback(struct page *page)
 extern void end_page_writeback(struct page *page);
 void wait_for_stable_page(struct page *page);
 
+void page_endio(struct page *page, int rw, int success);
+
 /*
  * Add an arbitrary waiter to a page's wait queue
  */
diff --git a/mm/filemap.c b/mm/filemap.c
index b7749a9..763753d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -631,6 +631,31 @@ void end_page_writeback(struct page *page)
 }
 EXPORT_SYMBOL(end_page_writeback);
 
+/*
+ * After completing I/O on a page, call this routine to update the page
+ * flags appropriately
+ */
+void page_endio(struct page *page, int rw, int success)
+{
+	if (rw == READ) {
+		if (success) {
+			SetPageUptodate(page);
+		} else {
+			ClearPageUptodate(page);
+			SetPageError(page);
+		}
+		unlock_page(page);
+	} else { /* rw == WRITE */
+		if (!success) {
+			SetPageError(page);
+			if (page->mapping)
+				set_bit(AS_EIO, &page->mapping->flags);
+		}
+		end_page_writeback(page);
+	}
+}
+EXPORT_SYMBOL_GPL(page_endio);
+
 /**
  * __lock_page - get a lock on the page, assuming we need to sleep to get it
  * @page: the page to lock
-- 
1.8.5.2

