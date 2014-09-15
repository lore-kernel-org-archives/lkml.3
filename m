Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaIOKCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:02:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23169 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbaIOKCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:02:01 -0400
X-AuditID: cbfee61a-f79e46d00000134f-e8-5416b917fca1
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/5] f2fs: support large sector size
Date: Mon, 15 Sep 2014 18:01:10 +0800
Message-id: <002d01cfd0cc$16ec1470$44c43d50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/MC3wq0EDMV1F3SWaDp0wMhAQZLA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAV3xnWIhBnOPGFtc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr42DDQ6aC
	deoVl5t2sjYw/lDoYuTkkBAwkXj79xQzhC0mceHeerYuRi4OIYFFjBJ9X94wQTg/GCU6d55n
	B6liE1CRWN7xnwnEFhHwkpi0/wQLiM0s4CHR2PGdtYuRg0NYwE5ixu0qkDCLgKrEnNeXwBbw
	ClhKnJ1/mgXCFpT4MfkeVKuWxPqdx5kgbHmJzWveQh2kILHj7GtGiFV6EjsXTWWFqBGX2Hjk
	FssERoFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHNLPpHYw
	rmywOMQowMGoxMNb0CcWIsSaWFZcmXuIUYKDWUmEd+pWoBBvSmJlVWpRfnxRaU5q8SFGaQ4W
	JXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQbGQwpTshx+7Z7y+lW+htmkuHerd597kRhV6zyP
	xUfx7+uJh3InnFO1myN56izDnMxa4/PPr2T+zbf6VzZZU3DTh5PPd/5jT/nMfWSG0LcmyQ8L
	F5w49OfIUsU2B4e4U0tY7q4uipQ69OVzimTus513Wp4zr3qxqv3vkxzP2y8PmDxt9HuseeuT
	81UlluKMREMt5qLiRACCTOj5ZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block size in f2fs is 4096 bytes, so theoretically, f2fs can support 4096 bytes
sector device at maximum. But now f2fs only support 512 bytes size sector, so
block device such as zRAM which uses page cache as its block storage space will
not be mounted successfully as mismatch between sector size of zRAM and sector
size of f2fs supported.

In this patch we support large sector size in f2fs, so block device with sector
size of 512/1024/2048/4096 bytes can be supported in f2fs.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c          |  2 +-
 fs/f2fs/segment.c       |  4 ++--
 fs/f2fs/segment.h       | 10 +++++-----
 fs/f2fs/super.c         | 20 ++++++++++++++------
 include/linux/f2fs_fs.h |  5 +++--
 5 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 64d8550..abc0cf1 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -85,7 +85,7 @@ static struct bio *__bio_alloc(struct f2fs_sb_info *sbi, block_t blk_addr,
 	bio = bio_alloc(GFP_NOIO, npages);
 
 	bio->bi_bdev = sbi->sb->s_bdev;
-	bio->bi_iter.bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
+	bio->bi_iter.bi_sector = SECTOR_FROM_BLOCK(blk_addr);
 	bio->bi_end_io = is_read ? f2fs_read_end_io : f2fs_write_end_io;
 	bio->bi_private = sbi;
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index e158d63..e921438 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -370,8 +370,8 @@ static void locate_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno)
 static int f2fs_issue_discard(struct f2fs_sb_info *sbi,
 				block_t blkstart, block_t blklen)
 {
-	sector_t start = SECTOR_FROM_BLOCK(sbi, blkstart);
-	sector_t len = SECTOR_FROM_BLOCK(sbi, blklen);
+	sector_t start = SECTOR_FROM_BLOCK(blkstart);
+	sector_t len = SECTOR_FROM_BLOCK(blklen);
 	trace_f2fs_issue_discard(sbi->sb, blkstart, blklen);
 	return blkdev_issue_discard(sbi->sb->s_bdev, start, len, GFP_NOFS, 0);
 }
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index bed0dc9..06f7309 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -88,10 +88,10 @@
 #define TOTAL_SEGS(sbi)	(SM_I(sbi)->main_segments)
 #define TOTAL_SECS(sbi)	(sbi->total_sections)
 
-#define SECTOR_FROM_BLOCK(sbi, blk_addr)				\
-	(((sector_t)blk_addr) << (sbi)->log_sectors_per_block)
-#define SECTOR_TO_BLOCK(sbi, sectors)					\
-	(sectors >> (sbi)->log_sectors_per_block)
+#define SECTOR_FROM_BLOCK(blk_addr)				\
+	(((sector_t)blk_addr) << F2FS_LOG_SECTORS_PER_BLOCK)
+#define SECTOR_TO_BLOCK(sectors)				\
+	(sectors >> F2FS_LOG_SECTORS_PER_BLOCK)
 #define MAX_BIO_BLOCKS(max_hw_blocks)					\
 	(min((int)max_hw_blocks, BIO_MAX_PAGES))
 
@@ -704,7 +704,7 @@ static inline unsigned int max_hw_blocks(struct f2fs_sb_info *sbi)
 {
 	struct block_device *bdev = sbi->sb->s_bdev;
 	struct request_queue *q = bdev_get_queue(bdev);
-	return SECTOR_TO_BLOCK(sbi, queue_max_sectors(q));
+	return SECTOR_TO_BLOCK(queue_max_sectors(q));
 }
 
 /*
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 3275e73..54444bb 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -786,14 +786,22 @@ static int sanity_check_raw_super(struct super_block *sb,
 		return 1;
 	}
 
-	if (le32_to_cpu(raw_super->log_sectorsize) !=
-					F2FS_LOG_SECTOR_SIZE) {
-		f2fs_msg(sb, KERN_INFO, "Invalid log sectorsize");
+	/* Currently, support 512/1024/2048/4096 bytes sector size */
+	if (le32_to_cpu(raw_super->log_sectorsize) >
+				F2FS_MAX_LOG_SECTOR_SIZE ||
+		le32_to_cpu(raw_super->log_sectorsize) <
+				F2FS_MIN_LOG_SECTOR_SIZE) {
+		f2fs_msg(sb, KERN_INFO, "Invalid log sectorsize (%u)",
+			le32_to_cpu(raw_super->log_sectorsize));
 		return 1;
 	}
-	if (le32_to_cpu(raw_super->log_sectors_per_block) !=
-					F2FS_LOG_SECTORS_PER_BLOCK) {
-		f2fs_msg(sb, KERN_INFO, "Invalid log sectors per block");
+	if (le32_to_cpu(raw_super->log_sectors_per_block) +
+		le32_to_cpu(raw_super->log_sectorsize) !=
+			F2FS_MAX_LOG_SECTOR_SIZE) {
+		f2fs_msg(sb, KERN_INFO,
+			"Invalid log sectors per block(%u) log sectorsize(%u)",
+			le32_to_cpu(raw_super->log_sectors_per_block),
+			le32_to_cpu(raw_super->log_sectorsize));
 		return 1;
 	}
 	return 0;
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 9ca1ff3..860313a 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -15,8 +15,9 @@
 #include <linux/types.h>
 
 #define F2FS_SUPER_OFFSET		1024	/* byte-size offset */
-#define F2FS_LOG_SECTOR_SIZE		9	/* 9 bits for 512 byte */
-#define F2FS_LOG_SECTORS_PER_BLOCK	3	/* 4KB: F2FS_BLKSIZE */
+#define F2FS_MIN_LOG_SECTOR_SIZE	9	/* 9 bits for 512 bytes */
+#define F2FS_MAX_LOG_SECTOR_SIZE	12	/* 12 bits for 4096 bytes */
+#define F2FS_LOG_SECTORS_PER_BLOCK	3	/* log number for sector/blk */
 #define F2FS_BLKSIZE			4096	/* support only 4KB block */
 #define F2FS_MAX_EXTENSION		64	/* # of extension entries */
 #define F2FS_BLK_ALIGN(x)	(((x) + F2FS_BLKSIZE - 1) / F2FS_BLKSIZE)
-- 
2.0.1.474.g72c7794


