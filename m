Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab3DBXJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:09:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933179Ab3DBWM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>,
        Alexandre Oliva <oliva@gnu.org>
Subject: [ 056/124] Btrfs: fix race between mmap writes and compression
Date: Tue,  2 Apr 2013 15:10:38 -0700
Message-Id: <20130402221110.725229421@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent_io.c |   33 +++++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.h |    2 ++
 fs/btrfs/inode.c     |   14 ++++++++++++++
 3 files changed, 49 insertions(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1258,6 +1258,39 @@ int unlock_extent(struct extent_io_tree
 				GFP_NOFS);
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
@@ -329,6 +329,8 @@ int map_private_extent_buffer(struct ext
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
@@ -352,6 +352,7 @@ static noinline int compress_file_range(
 	int i;
 	int will_compress;
 	int compress_type = root->fs_info->compress_type;
+	int redirty = 0;
 
 	/* if this is a small write inside eof, kick off a defrag */
 	if ((end - start + 1) < 16 * 1024 &&
@@ -414,6 +415,17 @@ again:
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
@@ -555,6 +567,8 @@ cleanup_and_bail_uncompressed:
 			__set_page_dirty_nobuffers(locked_page);
 			/* unlocked later on in the async handlers */
 		}
+		if (redirty)
+			extent_range_redirty_for_io(inode, start, end);
 		add_async_extent(async_cow, start, end - start + 1,
 				 0, NULL, 0, BTRFS_COMPRESS_NONE);
 		*num_added += 1;


