Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaJTFVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:21:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:59984 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbaJTFTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:19:52 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 05/11] f2fs: add stat info for inline_dentry inodes
Date: Sun, 19 Oct 2014 22:19:33 -0700
Message-Id: <1413782379-11758-5-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
References: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds status information for inline_dentry inodes.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/debug.c  |  3 +++
 fs/f2fs/f2fs.h   | 16 ++++++++++++++--
 fs/f2fs/inline.c |  2 +-
 fs/f2fs/inode.c  |  3 +++
 fs/f2fs/namei.c  |  1 +
 5 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 0a91ab8..86e6e92 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -46,6 +46,7 @@ static void update_general_status(struct f2fs_sb_info *sbi)
 	si->valid_node_count = valid_node_count(sbi);
 	si->valid_inode_count = valid_inode_count(sbi);
 	si->inline_inode = sbi->inline_inode;
+	si->inline_dir = sbi->inline_dir;
 	si->utilization = utilization(sbi);
 
 	si->free_segs = free_segments(sbi);
@@ -200,6 +201,8 @@ static int stat_show(struct seq_file *s, void *v)
 			   si->valid_count - si->valid_node_count);
 		seq_printf(s, "  - Inline_data Inode: %u\n",
 			   si->inline_inode);
+		seq_printf(s, "  - Inline_dentry Inode: %u\n",
+			   si->inline_dir);
 		seq_printf(s, "\nMain area: %d segs, %d secs %d zones\n",
 			   si->main_area_segs, si->main_area_sections,
 			   si->main_area_zones);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index d4dcd93..9c4c8d1 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -560,6 +560,7 @@ struct f2fs_sb_info {
 	unsigned int block_count[2];		/* # of allocated blocks */
 	int total_hit_ext, read_hit_ext;	/* extent cache hit ratio */
 	int inline_inode;			/* # of inline_data inodes */
+	int inline_dir;				/* # of inline_dentry inodes */
 	int bg_gc;				/* background gc calls */
 	unsigned int n_dirty_dirs;		/* # of dir inodes */
 #endif
@@ -1434,7 +1435,7 @@ struct f2fs_stat_info {
 	int ndirty_node, ndirty_dent, ndirty_dirs, ndirty_meta;
 	int nats, sits, fnids;
 	int total_count, utilization;
-	int bg_gc, inline_inode;
+	int bg_gc, inline_inode, inline_dir;
 	unsigned int valid_count, valid_node_count, valid_inode_count;
 	unsigned int bimodal, avg_vblocks;
 	int util_free, util_valid, util_invalid;
@@ -1474,7 +1475,16 @@ static inline struct f2fs_stat_info *F2FS_STAT(struct f2fs_sb_info *sbi)
 		if (f2fs_has_inline_data(inode))			\
 			((F2FS_I_SB(inode))->inline_inode--);		\
 	} while (0)
-
+#define stat_inc_inline_dir(inode)					\
+	do {								\
+		if (f2fs_has_inline_dentry(inode))			\
+			((F2FS_I_SB(inode))->inline_dir++);		\
+	} while (0)
+#define stat_dec_inline_dir(inode)					\
+	do {								\
+		if (f2fs_has_inline_dentry(inode))			\
+			((F2FS_I_SB(inode))->inline_dir--);		\
+	} while (0)
 #define stat_inc_seg_type(sbi, curseg)					\
 		((sbi)->segment_count[(curseg)->alloc_type]++)
 #define stat_inc_block_count(sbi, curseg)				\
@@ -1521,6 +1531,8 @@ void f2fs_destroy_root_stats(void);
 #define stat_inc_read_hit(sb)
 #define stat_inc_inline_inode(inode)
 #define stat_dec_inline_inode(inode)
+#define stat_inc_inline_dir(inode)
+#define stat_dec_inline_dir(inode)
 #define stat_inc_seg_type(sbi, curseg)
 #define stat_inc_block_count(sbi, curseg)
 #define stat_inc_seg_count(si, type)
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 3d44947..633d5e8 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -384,8 +384,8 @@ int f2fs_convert_inline_dir(struct inode *dir, struct page *ipage,
 	/* clear inline dir and flag after data writeback */
 	zero_user_segment(ipage, INLINE_DATA_OFFSET,
 				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
+	stat_dec_inline_dir(dir);
 	clear_inode_flag(F2FS_I(dir), FI_INLINE_DENTRY);
-	stat_dec_inline_inode(dir);
 
 	if (i_size_read(dir) < PAGE_CACHE_SIZE) {
 		i_size_write(dir, PAGE_CACHE_SIZE);
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 52d6f54..b9b1d6b 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -169,6 +169,7 @@ make_now:
 		goto bad_inode;
 	}
 	unlock_new_inode(inode);
+	stat_inc_inline_dir(inode);
 	trace_f2fs_iget(inode);
 	return inode;
 
@@ -300,6 +301,7 @@ void f2fs_evict_inode(struct inode *inode)
 
 	sb_end_intwrite(inode->i_sb);
 no_delete:
+	stat_dec_inline_dir(inode);
 	invalidate_mapping_pages(NODE_MAPPING(sbi), inode->i_ino, inode->i_ino);
 	if (xnid)
 		invalidate_mapping_pages(NODE_MAPPING(sbi), xnid, xnid);
@@ -327,6 +329,7 @@ void handle_failed_inode(struct inode *inode)
 	remove_inode_page(inode);
 	stat_dec_inline_inode(inode);
 
+	clear_inode_flag(F2FS_I(inode), FI_INLINE_DENTRY);
 	alloc_nid_failed(sbi, inode->i_ino);
 	f2fs_unlock_op(sbi);
 
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index c8290da..94ba291 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -297,6 +297,7 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		goto out_fail;
 	f2fs_unlock_op(sbi);
 
+	stat_inc_inline_dir(inode);
 	alloc_nid_done(sbi, inode->i_ino);
 
 	d_instantiate(dentry, inode);
-- 
2.1.1

