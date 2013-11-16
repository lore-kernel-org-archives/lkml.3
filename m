Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab3KPGPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 01:15:43 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:53834 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3KPGPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 01:15:35 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-09-52870d851fc3
From: Chao Yu <chao2.yu@samsung.com>
To: "'???'" <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH V2 1/2] f2fs: add a new function to support for
 merging contiguous read
Date: Sat, 16 Nov 2013 14:14:22 +0800
Message-id: <000001cee293$3b6e3030$b24a9090$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7h5jghUuGLhRONQR2Ypj7fdCl0Gw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jQd1W3vYgg1fLZS2u7/rLZHFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoErY0fnbNaC
	NvGKI0eWszYwfhXqYuTkkBAwkfi2ZyY7hC0mceHeerYuRi4OIYHpjBI3Nn5lhXB+MErMaPzE
	BlLFJqAisbzjPxOILSKgLLGqox2sg1lgBqPE4bn/WEESwgIpEr9vPGQEsVkEVCUaetpZQGxe
	AUuJ6Y2fGCFsQYkfk++BxZkFNCT6F21gg7DlJTavecsMcZKCxI6zrxkhlulJrHx2CapeXGLj
	kVssExgFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBYP5Pa
	wbiyweIQowAHoxIP746AtiAh1sSy4srcQ4wSHMxKIrzd3O1BQrwpiZVVqUX58UWlOanFhxil
	OViUxHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhjPbr558/z2nxMPdiUm/ha3key8uaH/SOOJ
	P9FrLIMFrzn/KtB7sWrqiwBR211yJS/72q5LrfjVUryi0qo2bNLJQ32uE32O+YqcLiyKEu01
	M+cPO8u/w/hSgMrmsw7x8fd/bnFIfuh3ZdIn/1UcDR0W0Y89O8ovFfg4b9y+94L295ATG6+r
	7f6rxFKckWioxVxUnAgAHtRsfWcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For better read performance, we add a new function to support for merging contiguous read as the one for write.

v1-->v2:
 o add declarations here as Gu Zheng suggested.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
Acked-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/data.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/f2fs.h |    4 ++++
 2 files changed, 49 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index aa3438c..18107cb 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -404,6 +404,51 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
 	return 0;
 }
 
+void f2fs_submit_read_bio(struct f2fs_sb_info *sbi, int rw)
+{
+	down_read(&sbi->bio_sem);
+	if (sbi->read_bio) {
+		submit_bio(rw, sbi->read_bio);
+		sbi->read_bio = NULL;
+	}
+	up_read(&sbi->bio_sem);
+}
+
+void submit_read_page(struct f2fs_sb_info *sbi, struct page *page,
+					block_t blk_addr, int rw)
+{
+	struct block_device *bdev = sbi->sb->s_bdev;
+	int bio_blocks;
+
+	verify_block_addr(sbi, blk_addr);
+
+	down_read(&sbi->bio_sem);
+
+	if (sbi->read_bio && sbi->last_read_block != blk_addr - 1) {
+		submit_bio(rw, sbi->read_bio);
+		sbi->read_bio = NULL;
+	}
+
+alloc_new:
+	if (sbi->read_bio == NULL) {
+		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+		sbi->read_bio = f2fs_bio_alloc(bdev, bio_blocks);
+		sbi->read_bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
+		sbi->read_bio->bi_end_io = read_end_io;
+	}
+
+	if (bio_add_page(sbi->read_bio, page, PAGE_CACHE_SIZE, 0) <
+							PAGE_CACHE_SIZE) {
+		submit_bio(rw, sbi->read_bio);
+		sbi->read_bio = NULL;
+		goto alloc_new;
+	}
+
+	sbi->last_read_block = blk_addr;
+
+	up_read(&sbi->bio_sem);
+}
+
 /*
  * This function should be used by the data read flow only where it
  * does not check the "create" flag that indicates block allocation.
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 89dc750..bfe9d87 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -359,6 +359,8 @@ struct f2fs_sb_info {
 
 	/* for segment-related operations */
 	struct f2fs_sm_info *sm_info;		/* segment manager */
+	struct bio *read_bio;			/* read bios to merge */
+	sector_t last_read_block;		/* last read block number */
 	struct bio *bio[NR_PAGE_TYPE];		/* bios to merge */
 	sector_t last_block_in_bio[NR_PAGE_TYPE];	/* last block number */
 	struct rw_semaphore bio_sem;		/* IO semaphore */
@@ -1111,6 +1113,8 @@ struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
 struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
 int f2fs_readpage(struct f2fs_sb_info *, struct page *, block_t, int);
+void f2fs_submit_read_bio(struct f2fs_sb_info *, int);
+void submit_read_page(struct f2fs_sb_info *, struct page *, block_t, int);
 int do_write_data_page(struct page *);
 
 /*
-- 
1.7.9.5

