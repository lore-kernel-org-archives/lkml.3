Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab3DVOmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:42:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51534 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754829Ab3DVOaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chris Mason" <chris.mason@fusionio.com>,
        "Alexandre Oliva" <oliva@gnu.org>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.298123476@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [55/75] Btrfs: fix race between mmap writes and compression
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <chris.mason@fusionio.com>

commit 4adaa611020fa6ac65b0ac8db78276af4ec04e63 upstream.

Btrfs uses page_mkwrite to ensure stable pages during
crc calculations and mmap workloads.  We call clear_page_dirty_for_io
before we do any crcs, and this forces any application with the file
mapped to wait for the crc to finish before it is allowed to change
the file.

With compression on, the clear_page_dirty_for_io step is happening after
we've compressed the pages.  This means the applications might be
changing the pages while we are compressing them, and some of those
modifications might not hit the disk.

This commit adds the clear_page_dirty_for_io before compression starts
and makes sure to redirty the page if we have to fallback to
uncompressed IO as well.

Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Reported-by: Alexandre Oliva <oliva@gnu.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/extent_io.c |   33 +++++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.h |    2 ++
 fs/btrfs/inode.c     |   14 ++++++++++++++
 3 files changed, 49 insertions(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1209,6 +1209,39 @@ int unlock_extent(struct extent_io_tree
 				mask);
 }
 
+int extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 end)
+{
+	unsigned long index = start >> PAGE_CACHE_SHIFT;
+	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
+	struct page *page;
+
+	while (index <= end_index) {
+		page = find_get_page(inode->i_mapping, index);
+		BUG_ON(!page); /* Pages should be in the extent_io_tree */
+		clear_page_dirty_for_io(page);
+		page_cache_release(page);
+		index++;
+	}
+	return 0;
+}
+
+int extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
+{
+	unsigned long index = start >> PAGE_CACHE_SHIFT;
+	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
+	struct page *page;
+
+	while (index <= end_index) {
+		page = find_get_page(inode->i_mapping, index);
+		BUG_ON(!page); /* Pages should be in the extent_io_tree */
+		account_page_redirty(page);
+		__set_page_dirty_nobuffers(page);
+		page_cache_release(page);
+		index++;
+	}
+	return 0;
+}
+
 /*
  * helper function to set both pages and extents in the tree writeback
  */
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -304,6 +304,8 @@ int map_private_extent_buffer(struct ext
 		      unsigned long *map_len);
 int extent_range_uptodate(struct extent_io_tree *tree,
 			  u64 start, u64 end);
+int extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 end);
+int extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end);
 int extent_clear_unlock_delalloc(struct inode *inode,
 				struct extent_io_tree *tree,
 				u64 start, u64 end, struct page *locked_page,
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -343,6 +343,7 @@ static noinline int compress_file_range(
 	int i;
 	int will_compress;
 	int compress_type = root->fs_info->compress_type;
+	int redirty = 0;
 
 	/* if this is a small write inside eof, kick off a defragbot */
 	if (end <= BTRFS_I(inode)->disk_i_size && (end - start + 1) < 16 * 1024)
@@ -404,6 +405,17 @@ again:
 		if (BTRFS_I(inode)->force_compress)
 			compress_type = BTRFS_I(inode)->force_compress;
 
+		/*
+		 * we need to call clear_page_dirty_for_io on each
+		 * page in the range.  Otherwise applications with the file
+		 * mmap'd can wander in and change the page contents while
+		 * we are compressing them.
+		 *
+		 * If the compression fails for any reason, we set the pages
+		 * dirty again later on.
+		 */
+		extent_range_clear_dirty_for_io(inode, start, end);
+		redirty = 1;
 		ret = btrfs_compress_pages(compress_type,
 					   inode->i_mapping, start,
 					   total_compressed, pages,
@@ -541,6 +553,8 @@ cleanup_and_bail_uncompressed:
 			__set_page_dirty_nobuffers(locked_page);
 			/* unlocked later on in the async handlers */
 		}
+		if (redirty)
+			extent_range_redirty_for_io(inode, start, end);
 		add_async_extent(async_cow, start, end - start + 1,
 				 0, NULL, 0, BTRFS_COMPRESS_NONE);
 		*num_added += 1;

