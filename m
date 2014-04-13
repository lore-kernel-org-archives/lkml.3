Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaDMXA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 19:00:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:28935 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609AbaDMXAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 19:00:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,853,1389772800"; 
   d="scan'208";a="512366914"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com
Subject: [PATCH v3 5/7] swap: Use bdev_read_page() / bdev_write_page()
Date: Sun, 13 Apr 2014 18:59:54 -0400
Message-Id: <9fb0b4031b0fba312963a7cc21bf258d944cddcf.1397429628.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1397429628.git.matthew.r.wilcox@intel.com>
References: <cover.1397429628.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1397429628.git.matthew.r.wilcox@intel.com>
References: <cover.1397429628.git.matthew.r.wilcox@intel.com>
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
1.9.1

