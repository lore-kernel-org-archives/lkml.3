Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbaCZQko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:40:44 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:40837 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbaCZQki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:40:38 -0400
Date: Wed, 26 Mar 2014 17:40:28 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: remove unused arg of set_page_dirty_balance()
Message-ID: <20140326164028.GA10187@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

There's only one caller of set_page_dirty_balance() and that will call it
with page_mkwrite == 0.

The page_mkwrite argument was unused since commit b827e496c893 "mm: close
page_mkwrite races".

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 include/linux/writeback.h |    2 +-
 mm/memory.c               |    2 +-
 mm/page-writeback.c       |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -178,7 +178,7 @@ int write_cache_pages(struct address_spa
 		      struct writeback_control *wbc, writepage_t writepage,
 		      void *data);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
-void set_page_dirty_balance(struct page *page, int page_mkwrite);
+void set_page_dirty_balance(struct page *page);
 void writeback_set_ratelimit(void);
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end);
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2752,7 +2752,7 @@ static int do_wp_page(struct mm_struct *
 		 */
 		if (!page_mkwrite) {
 			wait_on_page_locked(dirty_page);
-			set_page_dirty_balance(dirty_page, page_mkwrite);
+			set_page_dirty_balance(dirty_page);
 			/* file_update_time outside page_lock */
 			if (vma->vm_file)
 				file_update_time(vma->vm_file);
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1562,9 +1562,9 @@ static void balance_dirty_pages(struct a
 		bdi_start_background_writeback(bdi);
 }
 
-void set_page_dirty_balance(struct page *page, int page_mkwrite)
+void set_page_dirty_balance(struct page *page)
 {
-	if (set_page_dirty(page) || page_mkwrite) {
+	if (set_page_dirty(page)) {
 		struct address_space *mapping = page_mapping(page);
 
 		if (mapping)
