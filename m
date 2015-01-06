Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbbAFTUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:20:49 -0500
Received: from mail.kernel.org ([198.145.29.136]:43561 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbbAFTUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:20:44 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/4] f2fs: clean up to remove parameter
Date: Tue,  6 Jan 2015 11:20:31 -0800
Message-Id: <1420572034-53758-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses dn->data_blkaddr as a parameter for the destination block
address.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c     | 27 ++++++++++++++-------------
 fs/f2fs/f2fs.h     |  2 +-
 fs/f2fs/file.c     |  3 ++-
 fs/f2fs/inline.c   |  2 +-
 fs/f2fs/recovery.c |  3 ++-
 fs/f2fs/segment.c  |  1 +
 6 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 6308435..2c0cb66 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -197,7 +197,7 @@ alloc_new:
  *  ->node_page
  *    update block addresses in the node page
  */
-static void __set_data_blkaddr(struct dnode_of_data *dn, block_t new_addr)
+static void __set_data_blkaddr(struct dnode_of_data *dn)
 {
 	struct f2fs_node *rn;
 	__le32 *addr_array;
@@ -210,7 +210,7 @@ static void __set_data_blkaddr(struct dnode_of_data *dn, block_t new_addr)
 
 	/* Get physical address of data block */
 	addr_array = blkaddr_in_node(rn);
-	addr_array[ofs_in_node] = cpu_to_le32(new_addr);
+	addr_array[ofs_in_node] = cpu_to_le32(dn->data_blkaddr);
 	set_page_dirty(node_page);
 }
 
@@ -225,8 +225,8 @@ int reserve_new_block(struct dnode_of_data *dn)
 
 	trace_f2fs_reserve_new_block(dn->inode, dn->nid, dn->ofs_in_node);
 
-	__set_data_blkaddr(dn, NEW_ADDR);
 	dn->data_blkaddr = NEW_ADDR;
+	__set_data_blkaddr(dn);
 	mark_inode_dirty(dn->inode);
 	sync_inode_page(dn);
 	return 0;
@@ -291,19 +291,19 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 	return 0;
 }
 
-void update_extent_cache(block_t blk_addr, struct dnode_of_data *dn)
+void update_extent_cache(struct dnode_of_data *dn)
 {
 	struct f2fs_inode_info *fi = F2FS_I(dn->inode);
 	pgoff_t fofs, start_fofs, end_fofs;
 	block_t start_blkaddr, end_blkaddr;
 	int need_update = true;
 
-	f2fs_bug_on(F2FS_I_SB(dn->inode), blk_addr == NEW_ADDR);
+	f2fs_bug_on(F2FS_I_SB(dn->inode), dn->data_blkaddr == NEW_ADDR);
 	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
 							dn->ofs_in_node;
 
 	/* Update the page address in the parent node */
-	__set_data_blkaddr(dn, blk_addr);
+	__set_data_blkaddr(dn);
 
 	if (is_inode_flag_set(fi, FI_NO_EXTENT))
 		return;
@@ -321,16 +321,16 @@ void update_extent_cache(block_t blk_addr, struct dnode_of_data *dn)
 
 	/* Initial extent */
 	if (fi->ext.len == 0) {
-		if (blk_addr != NULL_ADDR) {
+		if (dn->data_blkaddr != NULL_ADDR) {
 			fi->ext.fofs = fofs;
-			fi->ext.blk_addr = blk_addr;
+			fi->ext.blk_addr = dn->data_blkaddr;
 			fi->ext.len = 1;
 		}
 		goto end_update;
 	}
 
 	/* Front merge */
-	if (fofs == start_fofs - 1 && blk_addr == start_blkaddr - 1) {
+	if (fofs == start_fofs - 1 && dn->data_blkaddr == start_blkaddr - 1) {
 		fi->ext.fofs--;
 		fi->ext.blk_addr--;
 		fi->ext.len++;
@@ -338,7 +338,7 @@ void update_extent_cache(block_t blk_addr, struct dnode_of_data *dn)
 	}
 
 	/* Back merge */
-	if (fofs == end_fofs + 1 && blk_addr == end_blkaddr + 1) {
+	if (fofs == end_fofs + 1 && dn->data_blkaddr == end_blkaddr + 1) {
 		fi->ext.len++;
 		goto end_update;
 	}
@@ -572,8 +572,8 @@ static int __allocate_data_block(struct dnode_of_data *dn)
 	if (unlikely(!inc_valid_block_count(sbi, dn->inode, 1)))
 		return -ENOSPC;
 
-	__set_data_blkaddr(dn, NEW_ADDR);
 	dn->data_blkaddr = NEW_ADDR;
+	__set_data_blkaddr(dn);
 
 	get_node_info(sbi, dn->nid, &ni);
 	set_summary(&sum, dn->nid, dn->ofs_in_node, ni.version);
@@ -584,7 +584,8 @@ static int __allocate_data_block(struct dnode_of_data *dn)
 
 	/* direct IO doesn't use extent cache to maximize the performance */
 	set_inode_flag(F2FS_I(dn->inode), FI_NO_EXTENT);
-	update_extent_cache(new_blkaddr, dn);
+	dn->data_blkaddr = new_blkaddr;
+	update_extent_cache(dn);
 	clear_inode_flag(F2FS_I(dn->inode), FI_NO_EXTENT);
 
 	/* update i_size */
@@ -784,7 +785,7 @@ int do_write_data_page(struct page *page, struct f2fs_io_info *fio)
 		set_inode_flag(F2FS_I(inode), FI_UPDATE_WRITE);
 	} else {
 		write_data_page(page, &dn, fio);
-		update_extent_cache(fio->blk_addr, &dn);
+		update_extent_cache(&dn);
 		set_inode_flag(F2FS_I(inode), FI_APPEND_WRITE);
 	}
 out_writepage:
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c48847e..37e935a 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1478,7 +1478,7 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *, struct page *,
 						struct f2fs_io_info *);
 int reserve_new_block(struct dnode_of_data *);
 int f2fs_reserve_block(struct dnode_of_data *, pgoff_t);
-void update_extent_cache(block_t, struct dnode_of_data *);
+void update_extent_cache(struct dnode_of_data *);
 struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
 struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index f172ddc4..5df3367 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -429,7 +429,8 @@ int truncate_data_blocks_range(struct dnode_of_data *dn, int count)
 		if (blkaddr == NULL_ADDR)
 			continue;
 
-		update_extent_cache(NULL_ADDR, dn);
+		dn->data_blkaddr = NULL_ADDR;
+		update_extent_cache(dn);
 		invalidate_blocks(sbi, blkaddr);
 		nr_free++;
 	}
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 0c3f3f9..fa2aa2f 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -116,7 +116,7 @@ no_update:
 	set_page_writeback(page);
 	fio.blk_addr = dn->data_blkaddr;
 	write_data_page(page, dn, &fio);
-	update_extent_cache(fio.blk_addr, dn);
+	update_extent_cache(dn);
 	f2fs_wait_on_page_writeback(page, DATA);
 	if (dirty)
 		inode_dec_dirty_pages(dn->inode);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 9160a37..c4211a5 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -396,7 +396,8 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 
 			/* write dummy data page */
 			recover_data_page(sbi, NULL, &sum, src, dest);
-			update_extent_cache(dest, &dn);
+			dn.data_blkaddr = dest;
+			update_extent_cache(&dn);
 			recovered++;
 		}
 		dn.ofs_in_node++;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index f995a85..8144a30 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1226,6 +1226,7 @@ void write_data_page(struct page *page, struct dnode_of_data *dn,
 	get_node_info(sbi, dn->nid, &ni);
 	set_summary(&sum, dn->nid, dn->ofs_in_node, ni.version);
 	do_write_page(sbi, page, &sum, fio);
+	dn->data_blkaddr = fio->blk_addr;
 }
 
 void rewrite_data_page(struct page *page, struct f2fs_io_info *fio)
-- 
2.1.1

