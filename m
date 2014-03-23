Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaCWTYU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:24:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:3667 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaCWTIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:08:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,715,1389772800"; 
   d="scan'208";a="505943966"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com
Subject: [PATCH v2 4/6] swap: Use bdev_read_page() / bdev_write_page()
Date: Sun, 23 Mar 2014 15:08:26 -0400
Message-Id: <67a4f1fde869717a22bd22724b6449e6343406ba.1395593198.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1395593198.git.matthew.r.wilcox@intel.com>
References: <cover.1395593198.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1395593198.git.matthew.r.wilcox@intel.com>
References: <cover.1395593198.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 mm/page_io.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 7c59ef6..43d7220 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -248,11 +248,16 @@ out:
 	return ret;
 }
 
+static sector_t swap_page_sector(struct page *page)
+{
+	return (sector_t)__page_file_index(page) << (PAGE_CACHE_SHIFT - 9);
+}
+
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
 	void (*end_write_func)(struct bio *, int))
 {
 	struct bio *bio;
-	int ret = 0, rw = WRITE;
+	int ret, rw = WRITE;
 	struct swap_info_struct *sis = page_swap_info(page);
 
 	if (sis->flags & SWP_FILE) {
@@ -297,6 +302,13 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		return ret;
 	}
 
+	ret = bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc);
+	if (!ret) {
+		count_vm_event(PSWPOUT);
+		return 0;
+	}
+
+	ret = 0;
 	bio = get_swap_bio(GFP_NOIO, page, end_write_func);
 	if (bio == NULL) {
 		set_page_dirty(page);
@@ -317,7 +329,7 @@ out:
 int swap_readpage(struct page *page)
 {
 	struct bio *bio;
-	int ret = 0;
+	int ret;
 	struct swap_info_struct *sis = page_swap_info(page);
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
@@ -338,6 +350,13 @@ int swap_readpage(struct page *page)
 		return ret;
 	}
 
+	ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
+	if (!ret) {
+		count_vm_event(PSWPIN);
+		return 0;
+	}
+
+	ret = 0;
 	bio = get_swap_bio(GFP_KERNEL, page, end_swap_bio_read);
 	if (bio == NULL) {
 		unlock_page(page);
-- 
1.9.0

