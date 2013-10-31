Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3JaHwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 03:52:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40600 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab3JaHwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 03:52:14 -0400
X-AuditID: cbfee68e-b7f416d0000020d6-ce-52720c2c8fc0
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: avoid to wait all the node blocks during fsync
Date: Thu, 31 Oct 2013 16:51:31 +0900
Message-id: <1383205891-25065-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zI10dnqIgg43PTCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgynh19x9rwVbxiqWz
	PzM1MHYKdzFyckgImEgcnLWRBcIWk7hwbz1bFyMXh5DAMkaJCfcmscAUbbp9EyqxiFFi0bxN
	rBBOM5PE5WMLmbsYOTjYBLQlNu83AGkQEWCWWDD1PCNIDbPABEaJ/4veg00SFnCV+H/1KxOI
	zSKgKrFtw2ywOK+Au0TP2YPsENu0JbY9nwjWLCFwn01izaEuVogGAYlvkw+xgCyTEJCV2HSA
	GaJeUuLgihssExgFFzAyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQICcK+HYw3D1gfYkwG
	GjeRWUo0OR8YxHkl8YbGZkYWpiamxkbmlmakCSuJ8y56mBQkJJCeWJKanZpakFoUX1Sak1p8
	iJGJg1OqgdFplY/1zqx98VrKEbX758gY7bscwGUsonTdLPmub+lFqcBfz6ewX5jE7/nCLCf2
	+HKVvb/NU+sZqjq8Ps73EH7CUb21pf31ioULTROYv0UbcLrM+Pr4ZVAY95zZdr8nrzrS7bkq
	LmOV6te7c56YeyjVv7l31faawzFxLyONvAsBC7ffagl2rFViKc5INNRiLipOBAC53zEDWAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jAV0dnqIggy2bDSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8x4dfcfa8FW8Yqlsz8zNTB2CncxcnJICJhIbLp9kw3CFpO4cG89kM3FISSw
	iFFi0bxNrBBOM5PE5WMLmbsYOTjYBLQlNu83AGkQEWCWWDD1PCNIDbPABEaJ/4ves4AkhAVc
	Jf5f/coEYrMIqEps2zAbLM4r4C7Rc/YgO8Q2bYltzycyTmDkXsDIsIpRNLUguaA4KT3XUK84
	Mbe4NC9dLzk/dxMjOMSfSe1gXNlgcYhRgINRiYeXQbcwSIg1say4MvcQowQHs5II77aTQCHe
	lMTKqtSi/Pii0pzU4kOMyUDbJzJLiSbnA+MvryTe0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC
	6YklqdmpqQWpRTBbmDg4pRoYRQRXJQo/2Pvu5n2uUqfstJNlgdznauslWey2cCZJVC1YtTh2
	2f6LvBXMZ3hsPmtf43vG4tvG3l3N8m+qtL1I/XYt8ZeHmhgF9CMV1n1Y/nXpIsMahqVLqt89
	n3or76RH5PNy/SwGt2qb+gjlkhcc6vf6L5zobfotW5hW06R2/SSDnF1WkLESS3FGoqEWc1Fx
	IgDQ9RpRtQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, f2fs_sync_file() waits for all the node blocks to be written.
But, we don't need to do that, but wait only the inode-related node blocks.

This patch adds wait_on_node_pages_writeback() in which waits inode-related
node blocks that are on writeback.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h |  1 +
 fs/f2fs/file.c |  5 +++--
 fs/f2fs/node.c | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 6aaefdb..625eb4b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1026,6 +1026,7 @@ void get_node_info(struct f2fs_sb_info *, nid_t, struct node_info *);
 int get_dnode_of_data(struct dnode_of_data *, pgoff_t, int);
 int truncate_inode_blocks(struct inode *, pgoff_t);
 int truncate_xattr_node(struct inode *, struct page *);
+int wait_on_node_pages_writeback(struct f2fs_sb_info *, nid_t);
 int remove_inode_page(struct inode *);
 struct page *new_inode_page(struct inode *, const struct qstr *);
 struct page *new_node_page(struct dnode_of_data *, unsigned int, struct page *);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 58ed19a..7d714f4 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -189,8 +189,9 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 			if (ret)
 				goto out;
 		}
-		filemap_fdatawait_range(sbi->node_inode->i_mapping,
-							0, LONG_MAX);
+		ret = wait_on_node_pages_writeback(sbi, inode->i_ino);
+		if (ret)
+			goto out;
 		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 	}
 out:
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 8e331d5..b527ed4 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1148,6 +1148,46 @@ continue_unlock:
 	return nwritten;
 }
 
+int wait_on_node_pages_writeback(struct f2fs_sb_info *sbi, nid_t ino)
+{
+	struct address_space *mapping = sbi->node_inode->i_mapping;
+	pgoff_t index = 0, end = LONG_MAX;
+	struct pagevec pvec;
+	int nr_pages;
+	int ret2 = 0, ret = 0;
+
+	pagevec_init(&pvec, 0);
+	while ((index <= end) &&
+			(nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+			PAGECACHE_TAG_WRITEBACK,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1)) != 0) {
+		unsigned i;
+
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+
+			/* until radix tree lookup accepts end_index */
+			if (page->index > end)
+				continue;
+
+			if (ino && ino_of_node(page) == ino)
+				wait_on_page_writeback(page);
+			if (TestClearPageError(page))
+				ret = -EIO;
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+
+	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
+		ret2 = -ENOSPC;
+	if (test_and_clear_bit(AS_EIO, &mapping->flags))
+		ret2 = -EIO;
+	if (!ret)
+		ret = ret2;
+	return ret;
+}
+
 static int f2fs_write_node_page(struct page *page,
 				struct writeback_control *wbc)
 {
-- 
1.8.4.474.g128a96c

