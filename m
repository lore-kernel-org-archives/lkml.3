Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3LRKgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:36:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:26064 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab3LRKgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:36:41 -0500
X-IronPort-AV: E=Sophos;i="4.95,507,1384272000"; 
   d="scan'208";a="9283488"
Message-ID: <52B17905.7040708@cn.fujitsu.com>
Date: Wed, 18 Dec 2013 18:29:25 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [f2fs-dev][PATCH] f2fs: move all the bio initialization into __bio_alloc
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/18 18:36:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/18 18:36:01,
	Serialize complete at 2013/12/18 18:36:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all the bio initialization into __bio_alloc, and some minor cleanups are
also added.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/data.c |   93 ++++++++++++++++++++++++++------------------------------
 1 files changed, 43 insertions(+), 50 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 9bdacc6..da5c52d 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -24,20 +24,6 @@
 #include "segment.h"
 #include <trace/events/f2fs.h>
 
-/*
- * Low-level block read/write IO operations.
- */
-static struct bio *__bio_alloc(struct block_device *bdev, int npages)
-{
-	struct bio *bio;
-
-	/* No failure on bio allocation */
-	bio = bio_alloc(GFP_NOIO, npages);
-	bio->bi_bdev = bdev;
-	bio->bi_private = NULL;
-	return bio;
-}
-
 static void f2fs_read_end_io(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -93,6 +79,25 @@ static void f2fs_write_end_io(struct bio *bio, int err)
 	bio_put(bio);
 }
 
+/*
+ * Low-level block read/write IO operations.
+ */
+static struct bio *__bio_alloc(struct f2fs_sb_info *sbi, block_t blk_addr,
+				int npages, int rw)
+{
+	struct bio *bio;
+
+	/* No failure on bio allocation */
+	bio = bio_alloc(GFP_NOIO, npages);
+
+	bio->bi_bdev = sbi->sb->s_bdev;
+	bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
+	bio->bi_end_io = rw ? f2fs_read_end_io : f2fs_write_end_io;
+	bio->bi_private = NULL;
+
+	return bio;
+}
+
 static void __submit_merged_bio(struct f2fs_bio_info *io)
 {
 	struct f2fs_io_info *fio = &io->fio;
@@ -104,25 +109,26 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
 	rw = fio->rw | fio->rw_flag;
 
 	if (is_read_io(rw)) {
-		trace_f2fs_submit_read_bio(io->sbi->sb, rw, fio->type, io->bio);
-		submit_bio(rw, io->bio);
-		io->bio = NULL;
-		return;
-	}
-	trace_f2fs_submit_write_bio(io->sbi->sb, rw, fio->type, io->bio);
-
-	/*
-	 * META_FLUSH is only from the checkpoint procedure, and we should wait
-	 * this metadata bio for FS consistency.
-	 */
-	if (fio->type == META_FLUSH) {
-		DECLARE_COMPLETION_ONSTACK(wait);
-		io->bio->bi_private = &wait;
+		trace_f2fs_submit_read_bio(io->sbi->sb, rw,
+						fio->type, io->bio);
 		submit_bio(rw, io->bio);
-		wait_for_completion(&wait);
 	} else {
-		submit_bio(rw, io->bio);
+		trace_f2fs_submit_write_bio(io->sbi->sb, rw,
+						fio->type, io->bio);
+		/*
+		 * META_FLUSH is only from the checkpoint procedure, and we
+		 * should wait this metadata bio for FS consistency.
+		 */
+		if (fio->type == META_FLUSH) {
+			DECLARE_COMPLETION_ONSTACK(wait);
+			io->bio->bi_private = &wait;
+			submit_bio(rw, io->bio);
+			wait_for_completion(&wait);
+		} else {
+			submit_bio(rw, io->bio);
+		}
 	}
+
 	io->bio = NULL;
 }
 
@@ -152,17 +158,12 @@ void f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
 int f2fs_submit_page_bio(struct f2fs_sb_info *sbi, struct page *page,
 					block_t blk_addr, int rw)
 {
-	struct block_device *bdev = sbi->sb->s_bdev;
 	struct bio *bio;
 
 	trace_f2fs_submit_page_bio(page, blk_addr, rw);
 
 	/* Allocate a new bio */
-	bio = __bio_alloc(bdev, 1);
-
-	/* Initialize the bio */
-	bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
-	bio->bi_end_io = is_read_io(rw) ? f2fs_read_end_io : f2fs_write_end_io;
+	bio = __bio_alloc(sbi, blk_addr, 1, is_read_io(rw));
 
 	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
 		bio_put(bio);
@@ -178,17 +179,16 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
 			block_t blk_addr, struct f2fs_io_info *fio)
 {
 	enum page_type btype = PAGE_TYPE_OF_BIO(fio->type);
-	struct block_device *bdev = sbi->sb->s_bdev;
 	struct f2fs_bio_info *io;
-	int bio_blocks;
+	int rw = is_read_io(fio->rw);
 
-	io = is_read_io(fio->rw) ? &sbi->read_io : &sbi->write_io[btype];
+	io = rw ? &sbi->read_io : &sbi->write_io[btype];
 
 	verify_block_addr(sbi, blk_addr);
 
 	mutex_lock(&io->io_mutex);
 
-	if (!is_read_io(fio->rw))
+	if (!rw)
 		inc_page_count(sbi, F2FS_WRITEBACK);
 
 	if (io->bio && (io->last_block_in_bio != blk_addr - 1 ||
@@ -196,17 +196,10 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
 		__submit_merged_bio(io);
 alloc_new:
 	if (io->bio == NULL) {
-		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
-		io->bio = __bio_alloc(bdev, bio_blocks);
-		io->bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
-		io->bio->bi_end_io = is_read_io(fio->rw) ? f2fs_read_end_io :
-							f2fs_write_end_io;
+		int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+
+		io->bio = __bio_alloc(sbi, blk_addr, bio_blocks, rw);
 		io->fio = *fio;
-		/*
-		 * The end_io will be assigned at the sumbission phase.
-		 * Until then, let bio_add_page() merge consecutive IOs as much
-		 * as possible.
-		 */
 	}
 
 	if (bio_add_page(io->bio, page, PAGE_CACHE_SIZE, 0) <
-- 
1.7.7

