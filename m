Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaINWOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 18:14:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:32888 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbaINWOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 18:14:33 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 07/10] f2fs: use meta_inode cache to improve roll-forward speed
Date: Sun, 14 Sep 2014 15:14:21 -0700
Message-Id: <1410732864-53069-7-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
References: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, all the dnode pages should be read during the roll-forward recovery.
Even worsely, whole the chain was traversed twice.
This patch removes that redundant and costly read operations by using page cache
of meta_inode and readahead function as well.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 11 ++++++++--
 fs/f2fs/f2fs.h       |  5 +++--
 fs/f2fs/recovery.c   | 59 +++++++++++++++++++++++++---------------------------
 fs/f2fs/segment.h    |  5 +++--
 4 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 7262d99..d1ed889 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -82,6 +82,8 @@ static inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
 	case META_SSA:
 	case META_CP:
 		return 0;
+	case META_POR:
+		return SM_I(sbi)->main_blkaddr + sbi->user_block_count;
 	default:
 		BUG();
 	}
@@ -90,11 +92,11 @@ static inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
 /*
  * Readahead CP/NAT/SIT/SSA pages
  */
-int ra_meta_pages(struct f2fs_sb_info *sbi, int start, int nrpages, int type)
+int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages, int type)
 {
 	block_t prev_blk_addr = 0;
 	struct page *page;
-	int blkno = start;
+	block_t blkno = start;
 	int max_blks = get_max_meta_blks(sbi, type);
 
 	struct f2fs_io_info fio = {
@@ -128,6 +130,11 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, int start, int nrpages, int type)
 			/* get ssa/cp block addr */
 			blk_addr = blkno;
 			break;
+		case META_POR:
+			if (unlikely(blkno >= max_blks))
+				goto out;
+			blk_addr = blkno;
+			break;
 		default:
 			BUG();
 		}
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 4f84d2a..48d7d46 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -103,7 +103,8 @@ enum {
 	META_CP,
 	META_NAT,
 	META_SIT,
-	META_SSA
+	META_SSA,
+	META_POR,
 };
 
 /* for the list of ino */
@@ -1291,7 +1292,7 @@ void destroy_segment_manager_caches(void);
  */
 struct page *grab_meta_page(struct f2fs_sb_info *, pgoff_t);
 struct page *get_meta_page(struct f2fs_sb_info *, pgoff_t);
-int ra_meta_pages(struct f2fs_sb_info *, int, int, int);
+int ra_meta_pages(struct f2fs_sb_info *, block_t, int, int);
 long sync_meta_pages(struct f2fs_sb_info *, enum page_type, long);
 void add_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
 void remove_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 3736728..6f7fbfa 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -173,7 +173,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 {
 	unsigned long long cp_ver = cur_cp_version(F2FS_CKPT(sbi));
 	struct curseg_info *curseg;
-	struct page *page;
+	struct page *page = NULL;
 	block_t blkaddr;
 	int err = 0;
 
@@ -181,20 +181,19 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 	curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
 	blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
 
-	/* read node page */
-	page = alloc_page(GFP_F2FS_ZERO);
-	if (!page)
-		return -ENOMEM;
-	lock_page(page);
-
 	while (1) {
 		struct fsync_inode_entry *entry;
 
-		err = f2fs_submit_page_bio(sbi, page, blkaddr, READ_SYNC);
-		if (err)
-			return err;
+		if (blkaddr < SM_I(sbi)->main_blkaddr ||
+					blkaddr > TOTAL_BLKS(sbi))
+			break;
 
-		lock_page(page);
+		page = get_meta_page(sbi, blkaddr);
+		if (IS_ERR(page))
+			return PTR_ERR(page);
+
+		ra_meta_pages(sbi, next_blkaddr_of_node(page),
+				MAX_BIO_BLOCKS(max_hw_blocks(sbi)), META_POR);
 
 		if (cp_ver != cpver_of_node(page))
 			break;
@@ -243,11 +242,9 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 next:
 		/* check next segment */
 		blkaddr = next_blkaddr_of_node(page);
+		f2fs_put_page(page, 1);
 	}
-
-	unlock_page(page);
-	__free_pages(page, 0);
-
+	f2fs_put_page(page, 1);
 	return err;
 }
 
@@ -427,7 +424,7 @@ static int recover_data(struct f2fs_sb_info *sbi,
 {
 	unsigned long long cp_ver = cur_cp_version(F2FS_CKPT(sbi));
 	struct curseg_info *curseg;
-	struct page *page;
+	struct page *page = NULL;
 	int err = 0;
 	block_t blkaddr;
 
@@ -435,21 +432,19 @@ static int recover_data(struct f2fs_sb_info *sbi,
 	curseg = CURSEG_I(sbi, type);
 	blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
 
-	/* read node page */
-	page = alloc_page(GFP_F2FS_ZERO);
-	if (!page)
-		return -ENOMEM;
-
-	lock_page(page);
-
 	while (1) {
 		struct fsync_inode_entry *entry;
 
-		err = f2fs_submit_page_bio(sbi, page, blkaddr, READ_SYNC);
-		if (err)
-			return err;
+		if (blkaddr < SM_I(sbi)->main_blkaddr ||
+					blkaddr > TOTAL_BLKS(sbi))
+			break;
 
-		lock_page(page);
+		page = get_meta_page(sbi, blkaddr);
+		if (IS_ERR(page))
+			return PTR_ERR(page);
+
+		ra_meta_pages(sbi, next_blkaddr_of_node(page),
+				MAX_BIO_BLOCKS(max_hw_blocks(sbi)), META_POR);
 
 		if (cp_ver != cpver_of_node(page))
 			break;
@@ -477,11 +472,9 @@ static int recover_data(struct f2fs_sb_info *sbi,
 next:
 		/* check next segment */
 		blkaddr = next_blkaddr_of_node(page);
+		f2fs_put_page(page, 1);
 	}
-
-	unlock_page(page);
-	__free_pages(page, 0);
-
+	f2fs_put_page(page, 1);
 	if (!err)
 		allocate_new_segments(sbi);
 	return err;
@@ -527,6 +520,10 @@ out:
 	destroy_fsync_dnodes(&inode_list);
 	kmem_cache_destroy(fsync_entry_slab);
 
+	/* truncate meta pages to be used by the recovery */
+	truncate_inode_pages_range(META_MAPPING(sbi),
+		SM_I(sbi)->main_blkaddr << PAGE_CACHE_SHIFT, -1);
+
 	if (err) {
 		truncate_inode_pages_final(NODE_MAPPING(sbi));
 		truncate_inode_pages_final(META_MAPPING(sbi));
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 013aed2..c6f37f2 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -87,6 +87,7 @@
 	(BITS_TO_LONGS(nr) * sizeof(unsigned long))
 #define TOTAL_SEGS(sbi)	(SM_I(sbi)->main_segments)
 #define TOTAL_SECS(sbi)	(sbi->total_sections)
+#define TOTAL_BLKS(sbi)	(SM_I(sbi)->segment_count << sbi->log_blocks_per_seg)
 
 #define SECTOR_FROM_BLOCK(sbi, blk_addr)				\
 	(((sector_t)blk_addr) << (sbi)->log_sectors_per_block)
@@ -553,7 +554,7 @@ static inline void check_seg_range(struct f2fs_sb_info *sbi, unsigned int segno)
 static inline void verify_block_addr(struct f2fs_sb_info *sbi, block_t blk_addr)
 {
 	struct f2fs_sm_info *sm_info = SM_I(sbi);
-	block_t total_blks = sm_info->segment_count << sbi->log_blocks_per_seg;
+	block_t total_blks = TOTAL_BLKS(sbi);
 	block_t start_addr = sm_info->seg0_blkaddr;
 	block_t end_addr = start_addr + total_blks - 1;
 	BUG_ON(blk_addr < start_addr);
@@ -606,7 +607,7 @@ static inline void check_seg_range(struct f2fs_sb_info *sbi, unsigned int segno)
 static inline void verify_block_addr(struct f2fs_sb_info *sbi, block_t blk_addr)
 {
 	struct f2fs_sm_info *sm_info = SM_I(sbi);
-	block_t total_blks = sm_info->segment_count << sbi->log_blocks_per_seg;
+	block_t total_blks = TOTAL_BLKS(sbi);
 	block_t start_addr = sm_info->seg0_blkaddr;
 	block_t end_addr = start_addr + total_blks - 1;
 
-- 
1.8.5.2 (Apple Git-48)

