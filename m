Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3KTF43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 00:56:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43448 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3KTF40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 00:56:26 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-9c-528c4efe161b
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH V2 1/2 RESEND] f2fs: add a new function to support
 for merging contiguous read
Date: Wed, 20 Nov 2013 13:54:35 +0800
Message-id: <001901cee5b5$2e28a520$8a79ef60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7lry7hQeiwBW3hTziushnsetuPhw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd1/fj1BBof7zSyu7/rLZHFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr48R6iYLl
	UhV9aw4wNzAeEO1i5OSQEDCRmDPlGDOELSZx4d56ti5GLg4hgUWMEu8PHodyfjBKLOvczghS
	xSagIrG84z8TiC0ioCix4f0GdpAiZoEZjBKH5/5jBUkIC2RLTP70gQXEZhFQlTi45zNYnFfA
	UuLBqxfMELagxI/J98BqmAU0JPoXbWCDsOUlNq95C3WSgsSOs68ZIZbpSZy+MJEVokZcYuOR
	WywTGAVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcFA/k9rB
	uLLB4hCjAAejEg+vxILuICHWxLLiytxDjBIczEoivLfce4KEeFMSK6tSi/Lji0pzUosPMUpz
	sCiJ8x5otQ4UEkhPLEnNTk0tSC2CyTJxcEo1MG6/IyJ9+tesH69vFGs/urRTweLswYJ+9+q6
	PtZ26fA+gTNPvyd+3eB9PKlD67hZOduPz1M6Ze71Ku8+znk+/YHzASbFZQ+uK0qzX7X5ozzj
	JBt373XuJzcYWB+x1cU7aPvrbG078f+xjsXzdx59T1IuvW5J////+/Kc9c9DLhhdEL+969TM
	h4uUWIozEg21mIuKEwFmYjvoZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For better read performance, we add a new function to support for merging contiguous read as the one for write.

v1-->v2:
 o add declarations here as Gu Zheng suggested.
 o use new structure f2fs_bio_info introduced by Jaegeuk Kim.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
Acked-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/data.c  |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/f2fs.h  |    3 +++
 fs/f2fs/super.c |    1 +
 3 files changed, 54 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index b4e4c7e..9cf3f6c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -400,6 +400,56 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
 	return 0;
 }
 
+void f2fs_submit_read_bio(struct f2fs_sb_info *sbi, int rw)
+{
+	struct f2fs_bio_info *io = &sbi->read_io;
+
+	if (!io->bio)
+		return;
+
+	mutex_lock(&io->io_mutex);
+	if (io->bio) {
+		submit_bio(rw, io->bio);
+		io->bio = NULL;
+	}
+	mutex_unlock(&io->io_mutex);
+}
+
+void submit_read_page(struct f2fs_sb_info *sbi, struct page *page,
+					block_t blk_addr, int rw)
+{
+	struct block_device *bdev = sbi->sb->s_bdev;
+	struct f2fs_bio_info *io = &sbi->read_io;
+	int bio_blocks;
+
+	verify_block_addr(sbi, blk_addr);
+
+	mutex_lock(&io->io_mutex);
+
+	if (io->bio && io->last_block_in_bio != blk_addr - 1) {
+		submit_bio(rw, io->bio);
+		io->bio = NULL;
+	}
+alloc_new:
+	if (io->bio == NULL) {
+		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+		io->bio = f2fs_bio_alloc(bdev, bio_blocks);
+		io->bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
+		io->bio->bi_end_io = read_end_io;
+	}
+
+	if (bio_add_page(io->bio, page, PAGE_CACHE_SIZE, 0) <
+							PAGE_CACHE_SIZE) {
+		submit_bio(rw, io->bio);
+		io->bio = NULL;
+		goto alloc_new;
+	}
+
+	io->last_block_in_bio = blk_addr;
+
+	mutex_unlock(&io->io_mutex);
+}
+
 /*
  * This function should be used by the data read flow only where it
  * does not check the "create" flag that indicates block allocation.
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index a54fac2..e2cb920 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -368,6 +368,7 @@ struct f2fs_sb_info {
 	struct f2fs_sm_info *sm_info;		/* segment manager */
 
 	/* for bio operations */
+	struct f2fs_bio_info read_io;			/* for read bios */
 	struct f2fs_bio_info write_io[NR_PAGE_TYPE];	/* for write bios */
 
 	/* for checkpoint */
@@ -1118,6 +1119,8 @@ struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
 struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
 int f2fs_readpage(struct f2fs_sb_info *, struct page *, block_t, int);
+void f2fs_submit_read_bio(struct f2fs_sb_info *, int);
+void submit_read_page(struct f2fs_sb_info *, struct page *, block_t, int);
 int do_write_data_page(struct page *);
 
 /*
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 344fb86..6d78fff 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -876,6 +876,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->por_doing = false;
 	spin_lock_init(&sbi->stat_lock);
 
+	mutex_init(&sbi->read_io.io_mutex);
 	for (i = 0; i < NR_PAGE_TYPE; i++)
 		mutex_init(&sbi->write_io[i].io_mutex);
 
-- 
1.7.9.5

