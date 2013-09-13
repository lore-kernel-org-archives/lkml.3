Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab3IMN2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:28:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9910 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab3IMN2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:28:05 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-4a-523312e32741
From: Chao Yu <chao2.yu@samsung.com>
To: Kim Jaegeuk <jaegeuk.kim@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev][PATCH RESEND] f2fs: avoid allocating failure in bio_alloc
Date: Fri, 13 Sep 2013 21:27:22 +0800
Message-id: <000301ceb085$13189480$3949bd80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6wg0wxnNTqEcG4SXSCx+iC8kLuVg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t9jAd3HQsZBBuub9SxuX5nEYnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vHzll32T12L/jM5NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	t++cYSr4wF9x+HU/SwPjJu4uRk4OCQETiQ1PdjFC2GISF+6tZ+ti5OIQEljEKHHl62ko5wej
	xLXdF9hAqtgEVCSWd/xnArFFBNQlvv2ZwwJSxCwwjVFi/pLvYEXCAr4SX148ArNZBFQlft1a
	zgJi8wpYSizf/4kZwhaU+DH5HlicWUBDon/RBjYIW15i85q3zBAnKUjsOPuaEWKZnsTC6VMY
	IWrEJTYeucUygVFgFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525i
	BAf4M6kdjCsbLA4xCnAwKvHwdsQYBQmxJpYVV+YeYpTgYFYS4Z11FyjEm5JYWZValB9fVJqT
	WnyIUZqDRUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qBUXSJcHaxIOtG7u9nFgl9yGDsj72b
	trXEILM1vZ1l6XbziSw7C8sstoQ0zPXLvPrf/vV0+5aFX68uTH77arI70yFGj0flZu8+1n5M
	2OWzNLkyZNHuN3uZGqLmia3wS4tJ/3B1UedW8Qu2LybwVU2Ldn93+8kRK678nZUqlsucu8Jz
	5USnTV7WocRSnJFoqMVcVJwIAHEeXsBsAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add macro MAX_BIO_BLOCKS to limit value of npages in
f2fs_bio_alloc,
it can avoid allocating failure in bio_alloc caused by npages is larger than
UIO_MAXIOV.

Signed-off-by: Yu Chao <chao2.yu@samsung.com>
 ---
 fs/f2fs/segment.c |    4 +++-
 fs/f2fs/segment.h |    3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 09af9c7..bd79bbe 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -657,6 +657,7 @@ static void submit_write_page(struct f2fs_sb_info *sbi,
struct page *page,
                                block_t blk_addr, enum page_type type)
 {
        struct block_device *bdev = sbi->sb->s_bdev;
+       int bio_blocks;
 
        verify_block_addr(sbi, blk_addr);
 
@@ -676,7 +677,8 @@ retry:
                        goto retry;
                }
 
-               sbi->bio[type] = f2fs_bio_alloc(bdev, max_hw_blocks(sbi));
+               bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+               sbi->bio[type] = f2fs_bio_alloc(bdev, bio_blocks);
                sbi->bio[type]->bi_sector = SECTOR_FROM_BLOCK(sbi,
blk_addr);
                sbi->bio[type]->bi_private = priv;
                /*
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index bdd10ea..6352af1 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/blkdev.h>
+#include <linux/uio.h>
 
 /* constant macro */
 #define NULL_SEGNO                     ((unsigned int)(~0))
@@ -90,6 +91,8 @@
        (blk_addr << ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
 #define SECTOR_TO_BLOCK(sbi, sectors)                                  \
        (sectors >> ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
+#define MAX_BIO_BLOCKS(max_hw_blocks)                                  \
+       (min((int)max_hw_blocks, UIO_MAXIOV))
 
 /* during checkpoint, bio_private is used to synchronize the last bio */
 struct bio_private {
---

