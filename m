Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaCWTXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:23:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:3672 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbaCWTIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:08:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,715,1389772800"; 
   d="scan'208";a="478413219"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com
Subject: [PATCH v2 2/6] Factor page_endio() out of mpage_end_io()
Date: Sun, 23 Mar 2014 15:08:24 -0400
Message-Id: <18abc0366b7231f89576b93e80c2be8a7d147345.1395593198.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1395593198.git.matthew.r.wilcox@intel.com>
References: <cover.1395593198.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1395593198.git.matthew.r.wilcox@intel.com>
References: <cover.1395593198.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page_endio() takes care of updating all the appropriate page flags once I/O
has finished to a page.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/mpage.c              | 18 +-----------------
 include/linux/pagemap.h |  2 ++
 mm/filemap.c            | 25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index 4cc9c5d..10da0da 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -48,23 +48,7 @@ static void mpage_end_io(struct bio *bio, int err)
 
 	bio_for_each_segment_all(bv, bio, i) {
 		struct page *page = bv->bv_page;
-
-		if (bio_data_dir(bio) == READ) {
-			if (!err) {
-				SetPageUptodate(page);
-			} else {
-				ClearPageUptodate(page);
-				SetPageError(page);
-			}
-			unlock_page(page);
-		} else { /* bio_data_dir(bio) == WRITE */
-			if (err) {
-				SetPageError(page);
-				if (page->mapping)
-					set_bit(AS_EIO, &page->mapping->flags);
-			}
-			end_page_writeback(page);
-		}
+		page_endio(page, bio_data_dir(bio), err);
 	}
 
 	bio_put(bio);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 1710d1b..396fddf 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -416,6 +416,8 @@ static inline void wait_on_page_writeback(struct page *page)
 extern void end_page_writeback(struct page *page);
 void wait_for_stable_page(struct page *page);
 
+void page_endio(struct page *page, int rw, int err);
+
 /*
  * Add an arbitrary waiter to a page's wait queue
  */
diff --git a/mm/filemap.c b/mm/filemap.c
index 7a13f6a..1b8c028 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -631,6 +631,31 @@ void end_page_writeback(struct page *page)
 }
 EXPORT_SYMBOL(end_page_writeback);
 
+/*
+ * After completing I/O on a page, call this routine to update the page
+ * flags appropriately
+ */
+void page_endio(struct page *page, int rw, int err)
+{
+	if (rw == READ) {
+		if (!err) {
+			SetPageUptodate(page);
+		} else {
+			ClearPageUptodate(page);
+			SetPageError(page);
+		}
+		unlock_page(page);
+	} else { /* rw == WRITE */
+		if (err) {
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
1.9.0

