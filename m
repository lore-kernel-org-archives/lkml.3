Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaLIGWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 01:22:52 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:9686 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaLIGWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 01:22:50 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-8e-5486953934c9
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 3/4 v2] f2fs: readahead contiguous current summary
 blocks in checkpoint
Date: Tue, 09 Dec 2014 14:21:46 +0800
Message-id: <002301d01378$8dc9a4b0$a95cee10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdATd91Rsfppqq4RTAmB/tGkEhGb3w==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jQV3LqW0hBvcOC1hc29fIZPFk/Sxm
	i0uL3C327D3JYnF51xw2B1aPTas62Tx2L/jM5NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	Lxb9Zi14I1Wx6Mo85gbGuWJdjJwcEgImEot2nWWGsMUkLtxbz9bFyMUhJDCdUeLJ/H9MEM4P
	Ronej99YQarYBFQklnf8ZwKxRQS8JCbtP8ECYjMLZErca5oBNklYIFli8YkN7CA2i4CqxMJv
	C9lAbF4BS4nHu96yQtiCEj8m34Pq1ZLYvK2JFcKWl9i85i3URQoSO86+ZoTYpSfRfXIfE0SN
	uMTGI7dYJjAKzEIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODw
	fia9g3FVg8UhRgEORiUeXg3LthAh1sSy4srcQ4wSHMxKIrz364BCvCmJlVWpRfnxRaU5qcWH
	GKU5WJTEeZXsgVIC6YklqdmpqQWpRTBZJg5OqQbGLRZlck1vTRevNzZYdb5O+03qqf0n98+Z
	IXLszRSVS/mhTML/GvnYggqD+3qXr771wzrSM+lP0K8NM5TTvqa+3/vVUDX6RFZX+5RNr1tO
	7ZM2Wvo7a4NvLev9JjVOJs6l02ddrfffLlX65Yec0ALOZyuVdE/8/NWppz5dRTDuHEd0yauC
	V1fYlViKMxINtZiLihMBZu565WsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's add readahead code for reading contiguous compact/normal summary blocks
in checkpoint, then we will gain better performance in mount procedure.

Changes from v1
  o remove inappropriate 'unlikely' in npages_for_summary_flush.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c |  2 +-
 fs/f2fs/f2fs.h       |  2 +-
 fs/f2fs/segment.c    | 21 ++++++++++++++++++---
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index b2d5431..226f980 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -923,7 +923,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 	ckpt->next_free_nid = cpu_to_le32(last_nid);
 
 	/* 2 cp  + n data seg summary + orphan inode blocks */
-	data_sum_blocks = npages_for_summary_flush(sbi);
+	data_sum_blocks = npages_for_summary_flush(sbi, false);
 	if (data_sum_blocks < NR_CURSEG_DATA_TYPE)
 		set_ckpt_flags(ckpt, CP_COMPACT_SUM_FLAG);
 	else
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f60b817..1d36ff5 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1401,7 +1401,7 @@ void refresh_sit_entry(struct f2fs_sb_info *, block_t, block_t);
 void clear_prefree_segments(struct f2fs_sb_info *);
 void release_discard_addrs(struct f2fs_sb_info *);
 void discard_next_dnode(struct f2fs_sb_info *, block_t);
-int npages_for_summary_flush(struct f2fs_sb_info *);
+int npages_for_summary_flush(struct f2fs_sb_info *, bool);
 void allocate_new_segments(struct f2fs_sb_info *);
 int f2fs_trim_fs(struct f2fs_sb_info *, struct fstrim_range *);
 struct page *get_sum_page(struct f2fs_sb_info *, unsigned int);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 42607a6..e287e45 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -735,7 +735,7 @@ static void __add_sum_entry(struct f2fs_sb_info *sbi, int type,
 /*
  * Calculate the number of current summary pages for writing
  */
-int npages_for_summary_flush(struct f2fs_sb_info *sbi)
+int npages_for_summary_flush(struct f2fs_sb_info *sbi, bool for_ra)
 {
 	int valid_sum_count = 0;
 	int i, sum_in_page;
@@ -743,8 +743,13 @@ int npages_for_summary_flush(struct f2fs_sb_info *sbi)
 	for (i = CURSEG_HOT_DATA; i <= CURSEG_COLD_DATA; i++) {
 		if (sbi->ckpt->alloc_type[i] == SSR)
 			valid_sum_count += sbi->blocks_per_seg;
-		else
-			valid_sum_count += curseg_blkoff(sbi, i);
+		else {
+			if (for_ra)
+				valid_sum_count += le16_to_cpu(
+					F2FS_CKPT(sbi)->cur_data_blkoff[i]);
+			else
+				valid_sum_count += curseg_blkoff(sbi, i);
+		}
 	}
 
 	sum_in_page = (PAGE_CACHE_SIZE - 2 * SUM_JOURNAL_SIZE -
@@ -1450,12 +1455,22 @@ static int restore_curseg_summaries(struct f2fs_sb_info *sbi)
 	int err;
 
 	if (is_set_ckpt_flags(F2FS_CKPT(sbi), CP_COMPACT_SUM_FLAG)) {
+		int npages = npages_for_summary_flush(sbi, true);
+
+		if (npages >= 2)
+			ra_meta_pages(sbi, start_sum_block(sbi), npages,
+								META_CP);
+
 		/* restore for compacted data summary */
 		if (read_compacted_summaries(sbi))
 			return -EINVAL;
 		type = CURSEG_HOT_NODE;
 	}
 
+	if (is_set_ckpt_flags(F2FS_CKPT(sbi), CP_UMOUNT_FLAG))
+		ra_meta_pages(sbi, sum_blk_addr(sbi, NR_CURSEG_TYPE, type),
+					NR_CURSEG_TYPE - type, META_CP);
+
 	for (; type <= CURSEG_COLD_NODE; type++) {
 		err = read_normal_summaries(sbi, type);
 		if (err)
-- 
2.1.2


