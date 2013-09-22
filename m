Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3IVHvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 03:51:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55757 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3IVHvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 03:51:45 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-17-523ea18fa1e9
From: Chao Yu <chao2.yu@samsung.com>
To: Kim Jaegeuk <jaegeuk.kim@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH] f2fs: avoid allocating failure in bio_alloc
Date: Sun, 22 Sep 2013 15:50:50 +0800
Message-id: <000001ceb768$9478ce70$bd6a6b50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac63WmQDvJ9cv75TQyWMADDR941ugw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t9jQd3+hXZBBtP/GlrcvjKJxeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aPnbPusnvsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	nvyZzFawnafi/u2fzA2MC7i6GDk5JARMJGbsvcsIYYtJXLi3nq2LkYtDSGA6o0TDvYVMEM4P
	RomJ/xazg1SxCahILO/4zwRiiwioS3z7M4cFpIhZYBqjxPwl39lAEsIC7hL/P14Ha2ARUJU4
	+mMC2ApeAUuJ11MuskPYghI/Jt9jAbGZBTQk+hdtYIOw5SU2r3nLDHGSgsSOs68ZIZbpSax+
	d5cJokZcYuORWywTGAVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcIA/k97BuKrB4hCjAAejEg9vBZtdkBBrYllxZe4hRgkOZiURXqVqoBBvSmJlVWpRfnxR
	aU5q8SFGaQ4WJXHeg63WgUIC6YklqdmpqQWpRTBZJg5OqQZGpUl13yR33//BEa/5/GPi0YiP
	63P+GmTn6h0SLAwNqn4rHvL3Ecu9tQyPTF7Efv24XfT67xdMLx3n5XqweyieVBYzfvDNUi3z
	GDfry8N68/PWbM78++5eak/cnNqHt97ZR3zeK2CfeXYne775jdKmgt6vz0qO8Yf/lRZLyfzG
	kT/d//KFSdWJSizFGYmGWsxFxYkAz+v3PWwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add macro MAX_BIO_BLOCKS to limit value of npages in
f2fs_bio_alloc, it can avoid allocating failure in bio_alloc caused by
npages is larger than BIO_MAX_PAGES.

Signed-off-by: Yu Chao <chao2.yu@samsung.com>
---
 fs/f2fs/segment.c |    4 +++-
 fs/f2fs/segment.h |    2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 09af9c7..bd79bbe 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -657,6 +657,7 @@ static void submit_write_page(struct f2fs_sb_info *sbi,
struct page *page,
 				block_t blk_addr, enum page_type type)
 {
 	struct block_device *bdev = sbi->sb->s_bdev;
+	int bio_blocks;
 
 	verify_block_addr(sbi, blk_addr);
 
@@ -676,7 +677,8 @@ retry:
 			goto retry;
 		}
 
-		sbi->bio[type] = f2fs_bio_alloc(bdev, max_hw_blocks(sbi));
+		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+		sbi->bio[type] = f2fs_bio_alloc(bdev, bio_blocks);
 		sbi->bio[type]->bi_sector = SECTOR_FROM_BLOCK(sbi,
blk_addr);
 		sbi->bio[type]->bi_private = priv;
 		/*
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index bdd10ea..7f94d78 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -90,6 +90,8 @@
 	(blk_addr << ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
 #define SECTOR_TO_BLOCK(sbi, sectors)					\
 	(sectors >> ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
+#define MAX_BIO_BLOCKS(max_hw_blocks)					\
+	(min((int)max_hw_blocks, BIO_MAX_PAGES))
 
 /* during checkpoint, bio_private is used to synchronize the last bio */
 struct bio_private {
---

