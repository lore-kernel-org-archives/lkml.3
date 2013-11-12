Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab3KLFQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 00:16:11 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:9948 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3KLFQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 00:16:06 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-6e-5281b994b7f0
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH 1/2] f2fs: add a new function to support for merging
 contiguous read
Date: Tue, 12 Nov 2013 13:15:08 +0800
Message-id: <000001cedf66$46a9bb70$d3fd3250$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7euU/d+/pUuq7ZR/6UBwBCf9FB2Q==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd0pOxuDDGae0Le4vusvk8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujN4rs9kK
	dglV3Fi9ia2BsZm/i5GTQ0LARGLGjjYmCFtM4sK99WxdjFwcQgKLGCUWHd7HAuH8YJTYevEJ
	G0gVm4CKxPKO/2AdIgKKEhveb2AHKWIWmMEocXjuP9YuRg4OYYFEiVebAkBqWARUJd4cPAxW
	zytgKbFtUwsbhC0o8WPyPRYQm1lAQ6J/0QY2CFteYvOat8wQFylI7Dj7mhFil55E65tDrBA1
	4hIbj9ximcAoMAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKD
	+pn0DsZVDRaHGAU4GJV4eHdwNQYJsSaWFVfmHmKU4GBWEuENXwwU4k1JrKxKLcqPLyrNSS0+
	xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwFgy+WJC+o0pP2decfp47g1XgGe3ftKF
	mYqyK24UhDDO+rcgLPPNv8xfJ5Uze1IT2EQdVpwUD7zWI1pjqvDD4IxL82Rl/SCRDtl3/9Ti
	z5ZkzXodd/qw+4MPGw6bFzo4Ji37sSiqqMzS5orPs7eiWyp99A2vlPMLPZP+8ybKhZORo51h
	v3T4CyWW4oxEQy3mouJEANhDrPpmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For better read performance, we add a new function to support for merging contiguous read as the one for write.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/f2fs.h |    2 ++
 2 files changed, 47 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index aa3438c..f30060b 100644
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
index 89dc750..0afdcec 100644
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
-- 
1.7.9.5

