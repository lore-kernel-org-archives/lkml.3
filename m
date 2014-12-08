Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaLHHCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:02:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24474 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaLHHCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:02:15 -0500
X-AuditID: cbfee61a-f79c06d000004e71-4e-54854cede29e
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 3/4] f2fs: readahead contiguous current summary
 blocks in checkpoint
Date: Mon, 08 Dec 2014 15:01:16 +0800
Message-id: <001a01d012b4$dfe9d040$9fbd70c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdASn9qSiwpg8jz+TDCB4nM3eVU0hA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jAd23Pq0hBkfem1hc29fIZPFk/Sxm
	i0uL3C327D3JYnF51xw2B1aPTas62Tx2L/jM5NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	Uw98ZSlYKFXxcssUpgbGh6JdjJwcEgImEutPfmeBsMUkLtxbz9bFyMUhJLCIUeLK+9PMEM4P
	Ron1506CVbEJqEgs7/jPBGKLCHhJTNp/AizOLJApca9pBjOILSyQIPG15ShYnEVAVaL/90Gw
	el4BS4kDt3cwQtiCEj8m34Pq1ZLYvK2JFcKWl9i85i0zxEUKEjvOvmaE2KUncefrQ3aIGnGJ
	jUdusUxgFJiFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB4f1M
	agfjygaLQ4wCHIxKPLwLHrSECLEmlhVX5h5ilOBgVhLh9bRvDRHiTUmsrEotyo8vKs1JLT7E
	KM3BoiTOe+NmboiQQHpiSWp2ampBahFMlomDU6qBkb3nQuDOSpYmmcMaITH3PwXNyme6dyFS
	TFRt8h2R12IfK4s9fdgSFf9XLpkcHPvSZEHphK+9eQbhKUX37wgVPLRKPP08wrFtpa3NpwWb
	3y37d+1lksk5Rokzi/9c/39jxQ5vkb8T/rULx3H/s7DouGNoE7veYb9M0Rn71YXdH9p3r9pn
	MHVbqxJLcUaioRZzUXEiAAYBZ5hrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's add readahead code for reading contiguous compact/normal summary blocks
in checkpoint, then we will gain better performance in mount procedure.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c |  2 +-
 fs/f2fs/f2fs.h       |  2 +-
 fs/f2fs/segment.c    | 21 ++++++++++++++++++---
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index e0ff75e..aa2a21c 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -915,7 +915,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 	ckpt->next_free_nid = cpu_to_le32(last_nid);
 
 	/* 2 cp  + n data seg summary + orphan inode blocks */
-	data_sum_blocks = npages_for_summary_flush(sbi);
+	data_sum_blocks = npages_for_summary_flush(sbi, false);
 	if (data_sum_blocks < NR_CURSEG_DATA_TYPE)
 		set_ckpt_flags(ckpt, CP_COMPACT_SUM_FLAG);
 	else
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index d042813..fc88e8a 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1393,7 +1393,7 @@ void refresh_sit_entry(struct f2fs_sb_info *, block_t, block_t);
 void clear_prefree_segments(struct f2fs_sb_info *);
 void release_discard_addrs(struct f2fs_sb_info *);
 void discard_next_dnode(struct f2fs_sb_info *, block_t);
-int npages_for_summary_flush(struct f2fs_sb_info *);
+int npages_for_summary_flush(struct f2fs_sb_info *, bool);
 void allocate_new_segments(struct f2fs_sb_info *);
 int f2fs_trim_fs(struct f2fs_sb_info *, struct fstrim_range *);
 struct page *get_sum_page(struct f2fs_sb_info *, unsigned int);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 9a33e34..e3bec6e 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -731,7 +731,7 @@ static void __add_sum_entry(struct f2fs_sb_info *sbi, int type,
 /*
  * Calculate the number of current summary pages for writing
  */
-int npages_for_summary_flush(struct f2fs_sb_info *sbi)
+int npages_for_summary_flush(struct f2fs_sb_info *sbi, bool for_ra)
 {
 	int valid_sum_count = 0;
 	int i, sum_in_page;
@@ -739,8 +739,13 @@ int npages_for_summary_flush(struct f2fs_sb_info *sbi)
 	for (i = CURSEG_HOT_DATA; i <= CURSEG_COLD_DATA; i++) {
 		if (sbi->ckpt->alloc_type[i] == SSR)
 			valid_sum_count += sbi->blocks_per_seg;
-		else
-			valid_sum_count += curseg_blkoff(sbi, i);
+		else {
+			if (unlikely(for_ra))
+				valid_sum_count += le16_to_cpu(
+					F2FS_CKPT(sbi)->cur_data_blkoff[i]);
+			else
+				valid_sum_count += curseg_blkoff(sbi, i);
+		}
 	}
 
 	sum_in_page = (PAGE_CACHE_SIZE - 2 * SUM_JOURNAL_SIZE -
@@ -1446,12 +1451,22 @@ static int restore_curseg_summaries(struct f2fs_sb_info *sbi)
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


