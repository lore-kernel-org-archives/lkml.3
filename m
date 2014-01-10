Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbaAJCmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:42:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:49025 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbaAJCkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:40:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,635,1384329600"; 
   d="scan'208";a="436681360"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 3/6] swap: Use bdev_read_page() / bdev_write_page()
Date: Thu,  9 Jan 2014 21:39:48 -0500
Message-Id: <1389321591-25455-3-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1387748522.git.matthew.r.wilcox@intel.com>
References: <cover.1387748522.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 mm/page_io.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 8c79a47..559697e 100644
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
 
 	VM_BUG_ON(!PageLocked(page));
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
1.8.5.2

