Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbbALHL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 02:11:58 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:53445 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbbALHLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 02:11:53 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-a1-54b373b87ca9
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][RFC PATCH 03/10] f2fs: introduce f2fs_map_bh to clean codes
 of check_extent_cache
Date: Mon, 12 Jan 2015 15:11:04 +0800
Message-id: <000701d02e37$0b11cfa0$21356ee0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAsy6dMiZu8xZwcSMe5p1AFP002UA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAd0dxZtDDH63ilpc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr48XNHraC
	HpGK56ueMTYwzhHoYuTkkBAwkXi+5BgThC0mceHeerYuRi4OIYFFjBLfJ8xkhXB+MEpcXvOC
	FaSKTUBFYnnHf7AOEQEviUn7T7CA2MwCHhKNHd/BaoQF0iWuvvvABmKzCKhKHF55lrmLkYOD
	V8BS4tbKQpAwr4CgxI/J96BatSTW7zzOBGHLS2xe85YZ4iAFiR1nXzNCrNKTOLPjPhtEjbjE
	xiO3WCYwCsxCMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgkH4m
	vYNxVYPFIUYBDkYlHl4Lqc0hQqyJZcWVuYcYJTiYlUR4w6yBQrwpiZVVqUX58UWlOanFhxil
	OViUxHmV7NtChATSE0tSs1NTC1KLYLJMHJxSDYyOq0ru86+crNuzKOtox6snOxeevzuRa/qu
	F/LbZnDcmdKQ6XbNRunor2e/s2/O4YyrbTte5L2kczJny7K4Tt+nLy76am9c4ru98SNfjL5Y
	i7gvX3je553tHs5KNrf3z2xfeNil1iJB0T17W9HzmHMrn/Kc1MlLfKnYMXFXe+iqgMuSr86V
	Rj9UYinOSDTUYi4qTgQAxGoY92UCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces f2fs_map_bh to clean codes of check_extent_cache.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 935a23b..5a3e489 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -248,8 +248,30 @@ int f2fs_reserve_block(struct dnode_of_data *dn, pgoff_t index)
 	return err;
 }
 
+static void f2fs_map_bh(struct inode *inode, pgoff_t pgofs,
+			struct extent_info *ei, struct buffer_head *bh_result)
+{
+	unsigned int blkbits = inode->i_sb->s_blocksize_bits;
+	pgoff_t start_fofs, end_fofs;
+	block_t start_blkaddr;
+	size_t count;
+
+	start_fofs = ei->fofs;
+	end_fofs = ei->fofs + ei->len - 1;
+	start_blkaddr = ei->blk;
+
+	clear_buffer_new(bh_result);
+	map_bh(bh_result, inode->i_sb,
+			start_blkaddr + pgofs - start_fofs);
+	count = end_fofs - pgofs + 1;
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
@@ -271,18 +293,7 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
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
@@ -608,13 +619,16 @@ static int __get_data_block(struct inode *inode, sector_t iblock,
 	int mode = create ? ALLOC_NODE : LOOKUP_NODE_RA;
 	pgoff_t pgofs, end_offset;
 	int err = 0, ofs = 1;
+	struct extent_info ei;
 	bool allocated = false;
 
 	/* Get the page offset from the block offset(iblock) */
 	pgofs =	(pgoff_t)(iblock >> (PAGE_CACHE_SHIFT - blkbits));
 
-	if (check_extent_cache(inode, pgofs, bh_result))
+	if (check_extent_cache(inode, pgofs, &ei)) {
+		f2fs_map_bh(inode, pgofs, &ei, bh_result);
 		goto out;
+	}
 
 	if (create) {
 		f2fs_balance_fs(F2FS_I_SB(inode));
-- 
2.2.1


