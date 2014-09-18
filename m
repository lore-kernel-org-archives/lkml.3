Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbaIRFhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 01:37:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:43293 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaIRFhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 01:37:47 -0400
Date: Wed, 17 Sep 2014 22:37:44 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 09/10] f2fs: use MAX_BIO_BLOCKS(sbi)
Message-ID: <20140918053744.GA1922@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
 <1410732864-53069-9-git-send-email-jaegeuk@kernel.org>
 <1410734091.917.26.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410734091.917.26.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for the review.
I changed the return value of MAX_BIO_BLOCKS to int.
IMO, it's the best way that I can do for now.

Thanks,

>From f3bcd1d658d1c4aa8178ddc2d4e6a7e45d8405cd Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Thu, 11 Sep 2014 14:37:35 -0700
Subject: [PATCH] f2fs: use MAX_BIO_BLOCKS(sbi)

Change log from v1:
 o change the return value of MAX_BIO_BLOCKS to int type.

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
index fdc3dbe..7749f30 100644
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
index 7a2d9c9..21ed91b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1697,7 +1697,7 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 	struct f2fs_summary *sum_entry;
 	struct inode *inode = sbi->sb->s_bdev->bd_inode;
 	block_t addr;
-	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+	int bio_blocks = MAX_BIO_BLOCKS(sbi);
 	struct page *pages[bio_blocks];
 	int i, idx, last_offset, nrpages, err = 0;
 
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 78ef10c..1ccee36 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -180,7 +180,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 		page = get_meta_page(sbi, blkaddr);
 
 		ra_meta_pages(sbi, next_blkaddr_of_node(page),
-				MAX_BIO_BLOCKS(max_hw_blocks(sbi)), META_POR);
+					MAX_BIO_BLOCKS(sbi), META_POR);
 
 		if (cp_ver != cpver_of_node(page))
 			break;
@@ -444,7 +444,7 @@ static int recover_data(struct f2fs_sb_info *sbi,
 		page = get_meta_page(sbi, blkaddr);
 
 		ra_meta_pages(sbi, next_blkaddr_of_node(page),
-				MAX_BIO_BLOCKS(max_hw_blocks(sbi)), META_POR);
+					MAX_BIO_BLOCKS(sbi), META_POR);
 
 		if (cp_ver != cpver_of_node(page)) {
 			f2fs_put_page(page, 1);
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
index c6f37f2..633e822 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -93,8 +93,8 @@
 	(((sector_t)blk_addr) << (sbi)->log_sectors_per_block)
 #define SECTOR_TO_BLOCK(sbi, sectors)					\
 	(sectors >> (sbi)->log_sectors_per_block)
-#define MAX_BIO_BLOCKS(max_hw_blocks)					\
-	(min((int)max_hw_blocks, BIO_MAX_PAGES))
+#define MAX_BIO_BLOCKS(sbi)						\
+	((int)min(max_hw_blocks(sbi), BIO_MAX_PAGES))
 
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

