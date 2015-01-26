Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbbAZFtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 00:49:10 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:56343 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbbAZFtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 00:49:06 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-a9-54c5d5505b80
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH v2 04/10] f2fs: introduce universal lookup/update
 interface of extent cache
Date: Mon, 26 Jan 2015 13:48:18 +0800
Message-id: <006001d0392b$caf6c010$60e44030$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdA23lzBI0JQPQ3SRQei9MovrGOSAQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAd2Aq0dDDGa2KFtc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEro32Pe8Ej
	s4qO++dYGhgv63QxcnJICJhINH/5wwRhi0lcuLeerYuRi0NIYBGjxKtnDVDOD0aJXZOuMINU
	sQmoSCzv+A/WISLgJTFp/wkWEJtZwEOiseM7K4gtLJAusWDXT7AaFgFViTnb3oDV8ApYSjzt
	vs0GYQtK/Jh8D6pXS2L9zuNMELa8xOY1b5khLlKQ2HH2NSPELj2Jr/2zoWrEJTYeucUygVFg
	FpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBIf0M+kdjKsaLA4x
	CnAwKvHwajQeDRFiTSwrrsw9xCjBwawkwls+BSjEm5JYWZValB9fVJqTWnyIUZqDRUmcV8m+
	LURIID2xJDU7NbUgtQgmy8TBKdXAWHX3zL5nO08sPLpMOtO3RphJZJ9p8xG5nT/seSKsd674
	POFk8ddtjNbman7JKhZb0hfLzw+9FKW77FHMCQVxR5W+MxvYUux/LDtwb7eozCGZ4vuNbq4c
	BfIScxX+bfUuUQqwXlR0NO3u3EAdtV/fr8/46HdNxjvIUkViptTtpb4yDjo1Jb/+KrEUZyQa
	ajEXFScCAGpcFOBlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch, we do these jobs:
1. rename {check,update}_extent_cache to {lookup,update}_extent_info;
2. introduce universal lookup/update interface of extent cache:
f2fs_{lookup,update}_extent_cache including above two real functions, then
export them to function callers.

So after above cleanup, we can add new rb-tree based extent cache into exported
interfaces.

v2:
 o remove "f2fs_" for inner function {lookup,update}_extent_info suggested by
   Jaegeuk Kim.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c     | 66 +++++++++++++++++++++++++++++++++---------------------
 fs/f2fs/f2fs.h     |  2 +-
 fs/f2fs/file.c     |  2 +-
 fs/f2fs/inline.c   |  2 +-
 fs/f2fs/recovery.c |  2 +-
 5 files changed, 44 insertions(+), 30 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 09e1e36..69b0781 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -263,20 +263,20 @@ static void f2fs_map_bh(struct super_block *sb, pgoff_t pgofs,
 		bh_result->b_size = UINT_MAX;
 }
 
-static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
-					struct extent_info *ei)
+static bool lookup_extent_info(struct inode *inode, pgoff_t pgofs,
+							struct extent_info *ei)
 {
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	pgoff_t start_fofs, end_fofs;
 	block_t start_blkaddr;
 
 	if (is_inode_flag_set(fi, FI_NO_EXTENT))
-		return 0;
+		return false;
 
 	read_lock(&fi->ext_lock);
 	if (fi->ext.len == 0) {
 		read_unlock(&fi->ext_lock);
-		return 0;
+		return false;
 	}
 
 	stat_inc_total_hit(inode->i_sb);
@@ -289,29 +289,22 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 		*ei = fi->ext;
 		stat_inc_read_hit(inode->i_sb);
 		read_unlock(&fi->ext_lock);
-		return 1;
+		return true;
 	}
 	read_unlock(&fi->ext_lock);
-	return 0;
+	return false;
 }
 
-void update_extent_cache(struct dnode_of_data *dn)
+static bool update_extent_info(struct inode *inode, pgoff_t fofs,
+								block_t blkaddr)
 {
-	struct f2fs_inode_info *fi = F2FS_I(dn->inode);
-	pgoff_t fofs, start_fofs, end_fofs;
+	struct f2fs_inode_info *fi = F2FS_I(inode);
+	pgoff_t start_fofs, end_fofs;
 	block_t start_blkaddr, end_blkaddr;
 	int need_update = true;
 
-	f2fs_bug_on(F2FS_I_SB(dn->inode), dn->data_blkaddr == NEW_ADDR);
-
-	/* Update the page address in the parent node */
-	__set_data_blkaddr(dn);
-
 	if (is_inode_flag_set(fi, FI_NO_EXTENT))
-		return;
-
-	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
-							dn->ofs_in_node;
+		return false;
 
 	write_lock(&fi->ext_lock);
 
@@ -326,16 +319,16 @@ void update_extent_cache(struct dnode_of_data *dn)
 
 	/* Initial extent */
 	if (fi->ext.len == 0) {
-		if (dn->data_blkaddr != NULL_ADDR) {
+		if (blkaddr != NULL_ADDR) {
 			fi->ext.fofs = fofs;
-			fi->ext.blk = dn->data_blkaddr;
+			fi->ext.blk = blkaddr;
 			fi->ext.len = 1;
 		}
 		goto end_update;
 	}
 
 	/* Front merge */
-	if (fofs == start_fofs - 1 && dn->data_blkaddr == start_blkaddr - 1) {
+	if (fofs == start_fofs - 1 && blkaddr == start_blkaddr - 1) {
 		fi->ext.fofs--;
 		fi->ext.blk--;
 		fi->ext.len++;
@@ -343,7 +336,7 @@ void update_extent_cache(struct dnode_of_data *dn)
 	}
 
 	/* Back merge */
-	if (fofs == end_fofs + 1 && dn->data_blkaddr == end_blkaddr + 1) {
+	if (fofs == end_fofs + 1 && blkaddr == end_blkaddr + 1) {
 		fi->ext.len++;
 		goto end_update;
 	}
@@ -370,9 +363,30 @@ void update_extent_cache(struct dnode_of_data *dn)
 	}
 end_update:
 	write_unlock(&fi->ext_lock);
-	if (need_update)
+	return need_update;
+}
+
+static bool f2fs_lookup_extent_cache(struct inode *inode, pgoff_t pgofs,
+							struct extent_info *ei)
+{
+	return lookup_extent_info(inode, pgofs, ei);
+}
+
+void f2fs_update_extent_cache(struct dnode_of_data *dn)
+{
+	struct f2fs_inode_info *fi = F2FS_I(dn->inode);
+	pgoff_t fofs;
+
+	f2fs_bug_on(F2FS_I_SB(dn->inode), dn->data_blkaddr == NEW_ADDR);
+
+	/* Update the page address in the parent node */
+	__set_data_blkaddr(dn);
+
+	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
+							dn->ofs_in_node;
+
+	if (update_extent_info(dn->inode, fofs, dn->data_blkaddr))
 		sync_inode_page(dn);
-	return;
 }
 
 struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
@@ -618,7 +632,7 @@ static int __get_data_block(struct inode *inode, sector_t iblock,
 	/* Get the page offset from the block offset(iblock) */
 	pgofs =	(pgoff_t)(iblock >> (PAGE_CACHE_SHIFT - blkbits));
 
-	if (check_extent_cache(inode, pgofs, &ei)) {
+	if (f2fs_lookup_extent_cache(inode, pgofs, &ei)) {
 		f2fs_map_bh(inode->i_sb, pgofs, &ei, bh_result);
 		goto out;
 	}
@@ -785,7 +799,7 @@ int do_write_data_page(struct page *page, struct f2fs_io_info *fio)
 		set_inode_flag(F2FS_I(inode), FI_UPDATE_WRITE);
 	} else {
 		write_data_page(page, &dn, fio);
-		update_extent_cache(&dn);
+		f2fs_update_extent_cache(&dn);
 		set_inode_flag(F2FS_I(inode), FI_APPEND_WRITE);
 	}
 out_writepage:
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f67efec..8e1d78d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1476,7 +1476,7 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *, struct page *,
 						struct f2fs_io_info *);
 int reserve_new_block(struct dnode_of_data *);
 int f2fs_reserve_block(struct dnode_of_data *, pgoff_t);
-void update_extent_cache(struct dnode_of_data *);
+void f2fs_update_extent_cache(struct dnode_of_data *);
 struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
 struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 0d88a28..a1f65d7 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -434,7 +434,7 @@ int truncate_data_blocks_range(struct dnode_of_data *dn, int count)
 			continue;
 
 		dn->data_blkaddr = NULL_ADDR;
-		update_extent_cache(dn);
+		f2fs_update_extent_cache(dn);
 		invalidate_blocks(sbi, blkaddr);
 		nr_free++;
 	}
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index fa2aa2f..9f6c745 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -116,7 +116,7 @@ no_update:
 	set_page_writeback(page);
 	fio.blk_addr = dn->data_blkaddr;
 	write_data_page(page, dn, &fio);
-	update_extent_cache(dn);
+	f2fs_update_extent_cache(dn);
 	f2fs_wait_on_page_writeback(page, DATA);
 	if (dirty)
 		inode_dec_dirty_pages(dn->inode);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 57603a7..82ea0d8 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -401,7 +401,7 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 			/* write dummy data page */
 			recover_data_page(sbi, NULL, &sum, src, dest);
 			dn.data_blkaddr = dest;
-			update_extent_cache(&dn);
+			f2fs_update_extent_cache(&dn);
 			recovered++;
 		}
 		dn.ofs_in_node++;
-- 
2.2.1


