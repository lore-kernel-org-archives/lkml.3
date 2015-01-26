Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbbAZFsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 00:48:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:57637 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbbAZFsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 00:48:08 -0500
X-AuditID: cbfee61a-f79c06d000004e71-ae-54c5d50290f4
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH v2 03/10] f2fs: introduce f2fs_map_bh to simplify
 codes of check_extent_cache
Date: Mon, 26 Jan 2015 13:46:48 +0800
Message-id: <005f01d0392b$9c348910$d49d9b30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdA5Ds+tvnsUdlrKTFG3pL33BqUw9g==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAV2mq0dDDI484ra4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxpUjTcwF
	s4Qr7t85y9LAuJe/i5GTQ0LAROLh/tXsELaYxIV769lAbCGBRYwS65f6dTFyAdk/GCX+PpvN
	DJJgE1CRWN7xnwnEFhHwkpi0/wQLiM0s4CHR2PGdtYuRnUNYIFPiinMXIwcHi4CqxMSPQiAF
	vAKWEvfXvWOFsAUlfky+B9WoJbF+53EmCFteYvOat8wQ1yhI7Dj7mhFikZ7Eoc+rGCFqxCU2
	HrnFMoFRYBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQH8zOp
	HYwrGywOMQpwMCrx8DY0Hw0RYk0sK67MPcQowcGsJMJbPgUoxJuSWFmVWpQfX1Sak1p8iFGa
	g0VJnFfJvi1ESCA9sSQ1OzW1ILUIJsvEwSnVwCiavC7d81etf8GV2oW/+tZMe6q1N/29/vpj
	dZkeP4wv/v3g5S7waPFf1qdCrKZHNok8W8/1Z37Gl/2m/68ln5CtOJlxSynn0w/tA5ei6zWT
	/GR0r12YoyoWW7bgrto14xt5PD2H7Kedu6a7m0P54MmphT2F//km/JHlEo6IuSP5O9Bne5xe
	ZKcSS3FGoqEWc1FxIgBOt9BDYgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces f2fs_map_bh to simplify codes of check_extent_cache.

v2:
 o clean up f2fs_map_bh pointed out by Jaegeuk Kim.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 935a23b..09e1e36 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -248,8 +248,23 @@ int f2fs_reserve_block(struct dnode_of_data *dn, pgoff_t index)
 	return err;
 }
 
+static void f2fs_map_bh(struct super_block *sb, pgoff_t pgofs,
+			struct extent_info *ei, struct buffer_head *bh_result)
+{
+	unsigned int blkbits = sb->s_blocksize_bits;
+	size_t count;
+
+	clear_buffer_new(bh_result);
+	map_bh(bh_result, sb, ei->blk + pgofs - ei->fofs);
+	count = ei->fofs + ei->len - pgofs;
+	if (count < (UINT_MAX >> blkbits))
+		bh_result->b_size = (count << blkbits);
+	else
+		bh_result->b_size = UINT_MAX;
+}
+
 static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
-					struct buffer_head *bh_result)
+					struct extent_info *ei)
 {
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	pgoff_t start_fofs, end_fofs;
@@ -271,18 +286,7 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 	start_blkaddr = fi->ext.blk;
 
 	if (pgofs >= start_fofs && pgofs <= end_fofs) {
-		unsigned int blkbits = inode->i_sb->s_blocksize_bits;
-		size_t count;
-
-		clear_buffer_new(bh_result);
-		map_bh(bh_result, inode->i_sb,
-				start_blkaddr + pgofs - start_fofs);
-		count = end_fofs - pgofs + 1;
-		if (count < (UINT_MAX >> blkbits))
-			bh_result->b_size = (count << blkbits);
-		else
-			bh_result->b_size = UINT_MAX;
-
+		*ei = fi->ext;
 		stat_inc_read_hit(inode->i_sb);
 		read_unlock(&fi->ext_lock);
 		return 1;
@@ -608,13 +612,16 @@ static int __get_data_block(struct inode *inode, sector_t iblock,
 	int mode = create ? ALLOC_NODE : LOOKUP_NODE_RA;
 	pgoff_t pgofs, end_offset;
 	int err = 0, ofs = 1;
+	struct extent_info ei;
 	bool allocated = false;
 
 	/* Get the page offset from the block offset(iblock) */
 	pgofs =	(pgoff_t)(iblock >> (PAGE_CACHE_SHIFT - blkbits));
 
-	if (check_extent_cache(inode, pgofs, bh_result))
+	if (check_extent_cache(inode, pgofs, &ei)) {
+		f2fs_map_bh(inode->i_sb, pgofs, &ei, bh_result);
 		goto out;
+	}
 
 	if (create) {
 		f2fs_balance_fs(F2FS_I_SB(inode));
-- 
2.2.1


