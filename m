Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab3D2KWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 06:22:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13778 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab3D2KWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 06:22:47 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-90-517e49f539ca
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: modify the number of issued pages to merge IOs
Date: Mon, 29 Apr 2013 19:21:44 +0900
Message-id: <1367230904-10223-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zI92vnnWBBhu/qFlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfH9m2LBC+mKVwsW
	sjUwfhPrYuTkkBAwkfgycz0zhC0mceHeejYQW0hgGaNE1xl3mJo3j68ydTFyAcWnM0osm7wb
	ymljkji1qYu9i5GDg01AW2LzfgOQBhEBZokFU88zgtQwC0xglPi/6D0LSEJYwFXi3ZwGMJtF
	QFXi95X3rCA2r4C7xNQ16xghtulKrP7/nB2kWULgPpvE47nNjBANAhLfJh9iAVkmISArsekA
	1NWSEgdX3GCZwCi4gJFhFaNoakFyQXFSepGRXnFibnFpXrpecn7uJkZIAPbtYLx5wPoQYzLQ
	uInMUqLJ+cAAziuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QDY77BiY4nBzi/Hl67O/YRh3AxT5Pjn+lefYnHWArfX6iUlvmupdW0vGVTYvcpca0f
	6QESx2YelNi5/8Uvq91Z10sWeu9279hqqJnp+1Nh2qzt3P+bGT3rZtRJ/HjXf8b/Q3D64T+G
	djJP3xTfsBDnL9GZ8HlitPeUM3NfTZRtTdVlW6s4/+r9S0osxRmJhlrMRcWJADZyu0xWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd2vnnWBBvteKFlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jx/ZtiwQvpilcLFrI1MH4T62Lk5JAQMJF48/gqE4QtJnHh3nq2LkYuDiGB
	6YwSyybvZoJw2pgkTm3qYu9i5OBgE9CW2LzfAKRBRIBZYsHU84wgNcwCExgl/i96zwKSEBZw
	lXg3pwHMZhFQlfh95T0riM0r4C4xdc06RohtuhKr/z9nn8DIvYCRYRWjaGpBckFxUnqukV5x
	Ym5xaV66XnJ+7iZGcIA/k97BuKrB4hCjAAejEg9vwObaQCHWxLLiytxDjBIczEoivGcc6wKF
	eFMSK6tSi/Lji0pzUosPMSYDbZ/ILCWanA+MvrySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcK
	CaQnlqRmp6YWpBbBbGHi4JRqYJw/c2Zi/eJ7PkoPFLYxOYh/XqT3v2rv5QvTK43cKhXvuF/U
	VX+eG3gkca63cpaM2IcdBS/Z+CVnnDTL1Zo/Zfet88aGdn0Vj3jmq7hU9myazh+srqB7xtsg
	8pMG56fjJXbVx8VZXbvZhR8Kf9B/ePqFiLLFop4JF6W+3e6cMGedoWu4WVLGPSWW4oxEQy3m
	ouJEANJjPG20AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When testing f2fs on an SSD, I found some 128 page IOs followed by 1 page IO
were issued by f2fs_write_node_pages.
This means that there were some mishandling flows which degrades performance.

Previous f2fs_write_node_pages determines the number of pages to be written,
nr_to_write, as follows.

1. The bio_get_nr_vecs returns 129 pages.
2. The bio_alloc makes a room for 128 pages.
3. The initial 128 pages go into one bio.
4. The existing bio is submitted, and a new bio is prepared for the last 1 page.
5. Finally, sync_node_pages submits the last 1 page bio.

The problem is from the use of bio_get_nr_vecs, so this patch replace it
with max_hw_blocks using queue_max_sectors.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c    |  6 ++----
 fs/f2fs/segment.c |  2 +-
 fs/f2fs/segment.h | 11 +++++++++++
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index f14eb7b..7209d63 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1171,7 +1171,6 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
-	struct block_device *bdev = sbi->sb->s_bdev;
 	long nr_to_write = wbc->nr_to_write;
 
 	/* First check balancing cached NAT entries */
@@ -1185,10 +1184,9 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 		return 0;
 
 	/* if mounting is failed, skip writing node pages */
-	wbc->nr_to_write = bio_get_nr_vecs(bdev);
+	wbc->nr_to_write = max_hw_blocks(sbi);
 	sync_node_pages(sbi, 0, wbc);
-	wbc->nr_to_write = nr_to_write -
-		(bio_get_nr_vecs(bdev) - wbc->nr_to_write);
+	wbc->nr_to_write = nr_to_write - (max_hw_blocks(sbi) - wbc->nr_to_write);
 	return 0;
 }
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 392ccb3..d8e84e4 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -734,7 +734,7 @@ static void submit_write_page(struct f2fs_sb_info *sbi, struct page *page,
 		do_submit_bio(sbi, type, false);
 alloc_new:
 	if (sbi->bio[type] == NULL) {
-		sbi->bio[type] = f2fs_bio_alloc(bdev, bio_get_nr_vecs(bdev));
+		sbi->bio[type] = f2fs_bio_alloc(bdev, max_hw_blocks(sbi));
 		sbi->bio[type]->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
 		/*
 		 * The end_io will be assigned at the sumbission phase.
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 26fc054..062424a 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -8,6 +8,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/blkdev.h>
+
 /* constant macro */
 #define NULL_SEGNO			((unsigned int)(~0))
 #define NULL_SECNO			((unsigned int)(~0))
@@ -86,6 +88,8 @@
 
 #define SECTOR_FROM_BLOCK(sbi, blk_addr)				\
 	(blk_addr << ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
+#define SECTOR_TO_BLOCK(sbi, sectors)					\
+	(sectors >> ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
 
 /* during checkpoint, bio_private is used to synchronize the last bio */
 struct bio_private {
@@ -624,3 +628,10 @@ static inline bool sec_usage_check(struct f2fs_sb_info *sbi, unsigned int secno)
 		return true;
 	return false;
 }
+
+static inline unsigned int max_hw_blocks(struct f2fs_sb_info *sbi)
+{
+	struct block_device *bdev = sbi->sb->s_bdev;
+	struct request_queue *q = bdev_get_queue(bdev);
+	return SECTOR_TO_BLOCK(sbi, queue_max_sectors(q));
+}
-- 
1.8.1.3.566.gaa39828

