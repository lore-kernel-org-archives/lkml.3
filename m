Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaINWOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 18:14:38 -0400
Received: from mail.kernel.org ([198.145.19.201]:32908 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbaINWOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 18:14:36 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 09/10] f2fs: use MAX_BIO_BLOCKS(sbi)
Date: Sun, 14 Sep 2014 15:14:23 -0700
Message-Id: <1410732864-53069-9-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
References: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up a simple macro.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c     | 2 +-
 fs/f2fs/node.c     | 2 +-
 fs/f2fs/recovery.c | 4 ++--
 fs/f2fs/segment.c  | 2 +-
 fs/f2fs/segment.h  | 8 ++++----
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 6637741..e800d71 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -193,7 +193,7 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
 		__submit_merged_bio(io);
 alloc_new:
 	if (io->bio == NULL) {
-		int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+		int bio_blocks = MAX_BIO_BLOCKS(sbi);
 
 		io->bio = __bio_alloc(sbi, blk_addr, bio_blocks, is_read);
 		io->fio = *fio;
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 653aa71..e38343d 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1692,7 +1692,7 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 	struct f2fs_summary *sum_entry;
 	struct inode *inode = sbi->sb->s_bdev->bd_inode;
 	block_t addr;
-	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+	int bio_blocks = MAX_BIO_BLOCKS(sbi);
 	struct page *pages[bio_blocks];
 	int i, idx, last_offset, nrpages, err = 0;
 
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 95d9dc9..dbeb32d 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -181,7 +181,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 			return PTR_ERR(page);
 
 		ra_meta_pages(sbi, next_blkaddr_of_node(page),
-				MAX_BIO_BLOCKS(max_hw_blocks(sbi)), META_POR);
+					MAX_BIO_BLOCKS(sbi), META_POR);
 
 		if (cp_ver != cpver_of_node(page))
 			break;
@@ -433,7 +433,7 @@ static int recover_data(struct f2fs_sb_info *sbi,
 			return PTR_ERR(page);
 
 		ra_meta_pages(sbi, next_blkaddr_of_node(page),
-				MAX_BIO_BLOCKS(max_hw_blocks(sbi)), META_POR);
+					MAX_BIO_BLOCKS(sbi), META_POR);
 
 		if (cp_ver != cpver_of_node(page))
 			break;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index c6f627b..4ea53aa 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1757,7 +1757,7 @@ static void build_sit_entries(struct f2fs_sb_info *sbi)
 	int sit_blk_cnt = SIT_BLK_CNT(sbi);
 	unsigned int i, start, end;
 	unsigned int readed, start_blk = 0;
-	int nrpages = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+	int nrpages = MAX_BIO_BLOCKS(sbi);
 
 	do {
 		readed = ra_meta_pages(sbi, start_blk, nrpages, META_SIT);
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index c6f37f2..1ae6c35 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -93,8 +93,8 @@
 	(((sector_t)blk_addr) << (sbi)->log_sectors_per_block)
 #define SECTOR_TO_BLOCK(sbi, sectors)					\
 	(sectors >> (sbi)->log_sectors_per_block)
-#define MAX_BIO_BLOCKS(max_hw_blocks)					\
-	(min((int)max_hw_blocks, BIO_MAX_PAGES))
+#define MAX_BIO_BLOCKS(sbi)					\
+	(min((int)max_hw_blocks(sbi), BIO_MAX_PAGES))
 
 /*
  * indicate a block allocation direction: RIGHT and LEFT.
@@ -728,7 +728,7 @@ static inline int nr_pages_to_skip(struct f2fs_sb_info *sbi, int type)
 	else if (type == NODE)
 		return 3 * sbi->blocks_per_seg;
 	else if (type == META)
-		return MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+		return MAX_BIO_BLOCKS(sbi);
 	else
 		return 0;
 }
@@ -751,7 +751,7 @@ static inline long nr_pages_to_write(struct f2fs_sb_info *sbi, int type,
 	else if (type == NODE)
 		desired = 3 * max_hw_blocks(sbi);
 	else
-		desired = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+		desired = MAX_BIO_BLOCKS(sbi);
 
 	wbc->nr_to_write = desired;
 	return desired - nr_to_write;
-- 
1.8.5.2 (Apple Git-48)

