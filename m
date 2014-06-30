Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964950AbaF3Mf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:35:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbaF3Mbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 123/181] ext4: fix data integrity sync in ordered mode
Date: Mon, 30 Jun 2014 13:52:24 +0200
Message-Id: <0fb604ac1358e6d0ebb0a41347e08376c03b6d28.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1c8349a17137b93f0a83f276c764a6df1b9a116e upstream.

When we perform a data integrity sync we tag all the dirty pages with
PAGECACHE_TAG_TOWRITE at start of ext4_da_writepages.  Later we check
for this tag in write_cache_pages_da and creates a struct
mpage_da_data containing contiguously indexed pages tagged with this
tag and sync these pages with a call to mpage_da_map_and_submit.  This
process is done in while loop until all the PAGECACHE_TAG_TOWRITE
pages are synced. We also do journal start and stop in each iteration.
journal_stop could initiate journal commit which would call
ext4_writepage which in turn will call ext4_bio_write_page even for
delayed OR unwritten buffers. When ext4_bio_write_page is called for
such buffers, even though it does not sync them but it clears the
PAGECACHE_TAG_TOWRITE of the corresponding page and hence these pages
are also not synced by the currently running data integrity sync. We
will end up with dirty pages although sync is completed.

This could cause a potential data loss when the sync call is followed
by a truncate_pagecache call, which is exactly the case in
collapse_range.  (It will cause generic/127 failure in xfstests)

To avoid this issue, we can use set_page_writeback_keepwrite instead of
set_page_writeback, which doesn't clear TOWRITE tag.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/ext4.h             |  3 ++-
 fs/ext4/inode.c            |  6 ++++--
 fs/ext4/page-io.c          |  8 ++++++--
 include/linux/page-flags.h | 12 +++++++++++-
 mm/page-writeback.c        | 11 ++++++-----
 5 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1e25d6b57bc5..54d94db2cf03 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2749,7 +2749,8 @@ extern void ext4_io_submit(struct ext4_io_submit *io);
 extern int ext4_bio_write_page(struct ext4_io_submit *io,
 			       struct page *page,
 			       int len,
-			       struct writeback_control *wbc);
+			       struct writeback_control *wbc,
+			       bool keep_towrite);
 
 /* mmp.c */
 extern int ext4_multi_mount_protect(struct super_block *, ext4_fsblk_t);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ea9793d8a77f..e5d9908c0bc3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1835,6 +1835,7 @@ static int ext4_writepage(struct page *page,
 	struct buffer_head *page_bufs = NULL;
 	struct inode *inode = page->mapping->host;
 	struct ext4_io_submit io_submit;
+	bool keep_towrite = false;
 
 	trace_ext4_writepage(page);
 	size = i_size_read(inode);
@@ -1865,6 +1866,7 @@ static int ext4_writepage(struct page *page,
 			unlock_page(page);
 			return 0;
 		}
+		keep_towrite = true;
 	}
 
 	if (PageChecked(page) && ext4_should_journal_data(inode))
@@ -1881,7 +1883,7 @@ static int ext4_writepage(struct page *page,
 		unlock_page(page);
 		return -ENOMEM;
 	}
-	ret = ext4_bio_write_page(&io_submit, page, len, wbc);
+	ret = ext4_bio_write_page(&io_submit, page, len, wbc, keep_towrite);
 	ext4_io_submit(&io_submit);
 	/* Drop io_end reference we got from init */
 	ext4_put_io_end_defer(io_submit.io_end);
@@ -1900,7 +1902,7 @@ static int mpage_submit_page(struct mpage_da_data *mpd, struct page *page)
 	else
 		len = PAGE_CACHE_SIZE;
 	clear_page_dirty_for_io(page);
-	err = ext4_bio_write_page(&mpd->io_submit, page, len, mpd->wbc);
+	err = ext4_bio_write_page(&mpd->io_submit, page, len, mpd->wbc, false);
 	if (!err)
 		mpd->wbc->nr_to_write--;
 	mpd->first_page++;
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 02e94ef1489b..0881ede35baa 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -400,7 +400,8 @@ submit_and_retry:
 int ext4_bio_write_page(struct ext4_io_submit *io,
 			struct page *page,
 			int len,
-			struct writeback_control *wbc)
+			struct writeback_control *wbc,
+			bool keep_towrite)
 {
 	struct inode *inode = page->mapping->host;
 	unsigned block_start, blocksize;
@@ -413,7 +414,10 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	BUG_ON(!PageLocked(page));
 	BUG_ON(PageWriteback(page));
 
-	set_page_writeback(page);
+	if (keep_towrite)
+		set_page_writeback_keepwrite(page);
+	else
+		set_page_writeback(page);
 	ClearPageError(page);
 
 	/*
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 6d53675c2b54..dd7d45b5c496 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -317,13 +317,23 @@ CLEARPAGEFLAG(Uptodate, uptodate)
 extern void cancel_dirty_page(struct page *page, unsigned int account_size);
 
 int test_clear_page_writeback(struct page *page);
-int test_set_page_writeback(struct page *page);
+int __test_set_page_writeback(struct page *page, bool keep_write);
+
+#define test_set_page_writeback(page)			\
+	__test_set_page_writeback(page, false)
+#define test_set_page_writeback_keepwrite(page)	\
+	__test_set_page_writeback(page, true)
 
 static inline void set_page_writeback(struct page *page)
 {
 	test_set_page_writeback(page);
 }
 
+static inline void set_page_writeback_keepwrite(struct page *page)
+{
+	test_set_page_writeback_keepwrite(page);
+}
+
 #ifdef CONFIG_PAGEFLAGS_EXTENDED
 /*
  * System with lots of page flags available. This allows separate
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 8f6daa62206d..d013dba21429 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2398,7 +2398,7 @@ int test_clear_page_writeback(struct page *page)
 	return ret;
 }
 
-int test_set_page_writeback(struct page *page)
+int __test_set_page_writeback(struct page *page, bool keep_write)
 {
 	struct address_space *mapping = page_mapping(page);
 	int ret;
@@ -2423,9 +2423,10 @@ int test_set_page_writeback(struct page *page)
 			radix_tree_tag_clear(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_DIRTY);
-		radix_tree_tag_clear(&mapping->page_tree,
-				     page_index(page),
-				     PAGECACHE_TAG_TOWRITE);
+		if (!keep_write)
+			radix_tree_tag_clear(&mapping->page_tree,
+						page_index(page),
+						PAGECACHE_TAG_TOWRITE);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 	} else {
 		ret = TestSetPageWriteback(page);
@@ -2436,7 +2437,7 @@ int test_set_page_writeback(struct page *page)
 	return ret;
 
 }
-EXPORT_SYMBOL(test_set_page_writeback);
+EXPORT_SYMBOL(__test_set_page_writeback);
 
 /*
  * Return true if any of the pages in the mapping are marked with the
-- 
2.0.0

