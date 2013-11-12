Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab3KLFTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 00:19:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:30083 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3KLFTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 00:19:30 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-49-5281ba6089cc
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH 2/2] f2fs: read contiguous sit entry pages by
 merging for mount performance
Date: Tue, 12 Nov 2013 13:18:40 +0800
Message-id: <000101cedf66$c2e7ea40$48b7bec0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7euxMlaKtf0HlpR+u4biF3LvZHxg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jAd3EXY1BBsvesFhc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxoIZzgXn
	lCpO3FjM1sC4UKaLkYNDQsBEYupZlS5GTiBTTOLCvfVsXYxcHEICixgl9i79zwLh/GCU6PzZ
	yA5SxSagIrG84z8TiC0ioCix4f0GdpAiZoEZjBKH5/5jBZkqLJAhMeVzFkgNi4CqxJQfLawg
	Nq+ApUTbnE8sELagxI/J98BsZgENif5FG9ggbHmJzWveMkNcpCCx4+xrRohdehJvrjxkh6gR
	l9h45BbLBEaBWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzQ
	z6R3MK5qsDjEKMDBqMTDu4OrMUiINbGsuDL3EKMEB7OSCG/4YqAQb0piZVVqUX58UWlOavEh
	RmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYOTilgkP+/uch+RUCa1JH7N7msZ/M8lRE4p7Xx
	Vc0j76OGnBoXAh49Mf9VfLr0k96looVrl+tbG788V+F8h+XZo8LFl+qCtvJk1af+NEr4wKPR
	H8V3TnR1gv3OuO0v97pIbFnzsVQ+4rvSgdc7rOvCv75dUGdyKHBmGPsmV6/StG8c83i62ne3
	sEx8pcRSnJFoqMVcVJwIACsps1pkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we read sit entries page one by one, this method lost the chance of reading contiguous page together.
So we read pages as contiguous as possible for better mount performance.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h    |    2 ++
 fs/f2fs/segment.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/f2fs/segment.h |    2 ++
 3 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 0afdcec..bfe9d87 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1113,6 +1113,8 @@ struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
 struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
 int f2fs_readpage(struct f2fs_sb_info *, struct page *, block_t, int);
+void f2fs_submit_read_bio(struct f2fs_sb_info *, int);
+void submit_read_page(struct f2fs_sb_info *, struct page *, block_t, int);
 int do_write_data_page(struct page *);
 
 /*
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 86dc289..414c351 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1474,19 +1474,72 @@ static int build_curseg(struct f2fs_sb_info *sbi)
 	return restore_curseg_summaries(sbi);
 }
 
+static int ra_sit_pages(struct f2fs_sb_info *sbi, int start,
+					int nrpages, bool *is_order)
+{
+	struct address_space *mapping = sbi->meta_inode->i_mapping;
+	struct sit_info *sit_i = SIT_I(sbi);
+	struct page *page;
+	block_t blk_addr;
+	int blkno, readcnt = 0;
+	int sit_blk_cnt = SIT_BLK_CNT(sbi);
+
+	for (blkno = start; blkno < start + nrpages; blkno++) {
+
+		if (blkno >= sit_blk_cnt)
+			goto out;
+		if ((!f2fs_test_bit(blkno, sit_i->sit_bitmap) ^ !*is_order)) {
+			*is_order = !*is_order;
+			goto out;
+		}
+
+		blk_addr = sit_i->sit_base_addr + blkno;
+		if (*is_order)
+			blk_addr += sit_i->sit_blocks;
+repeat:
+		page = grab_cache_page(mapping, blk_addr);
+		if (!page) {
+			cond_resched();
+			goto repeat;
+		}
+		if (PageUptodate(page)) {
+			f2fs_put_page(page, 1);
+			readcnt++;
+			goto out;
+		}
+
+		submit_read_page(sbi, page, blk_addr, READ_SYNC);
+
+		page_cache_release(page);
+		readcnt++;
+	}
+out:
+	f2fs_submit_read_bio(sbi, READ_SYNC);
+	return readcnt;
+}
+
 static void build_sit_entries(struct f2fs_sb_info *sbi)
 {
 	struct sit_info *sit_i = SIT_I(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_COLD_DATA);
 	struct f2fs_summary_block *sum = curseg->sum_blk;
-	unsigned int start;
+	bool is_order = f2fs_test_bit(0, sit_i->sit_bitmap) ? true : false;
+	int sit_blk_cnt = SIT_BLK_CNT(sbi);
+	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+	unsigned int i, start, end;
+	unsigned int readed, start_blk = 0;
 
-	for (start = 0; start < TOTAL_SEGS(sbi); start++) {
+next:
+	readed = ra_sit_pages(sbi, start_blk, bio_blocks, &is_order);
+
+	start = start_blk * sit_i->sents_per_block;
+	end = (start_blk + readed) * sit_i->sents_per_block;
+
+	for (; start < end && start < TOTAL_SEGS(sbi); start++) {
 		struct seg_entry *se = &sit_i->sentries[start];
 		struct f2fs_sit_block *sit_blk;
 		struct f2fs_sit_entry sit;
 		struct page *page;
-		int i;
 
 		mutex_lock(&curseg->curseg_mutex);
 		for (i = 0; i < sits_in_cursum(sum); i++) {
@@ -1497,6 +1550,7 @@ static void build_sit_entries(struct f2fs_sb_info *sbi)
 			}
 		}
 		mutex_unlock(&curseg->curseg_mutex);
+
 		page = get_current_sit_page(sbi, start);
 		sit_blk = (struct f2fs_sit_block *)page_address(page);
 		sit = sit_blk->entries[SIT_ENTRY_OFFSET(sit_i, start)];
@@ -1509,6 +1563,11 @@ got_it:
 			e->valid_blocks += se->valid_blocks;
 		}
 	}
+
+	start_blk += readed;
+	if (start_blk >= sit_blk_cnt)
+		return;
+	goto next;
 }
 
 static void init_free_segmap(struct f2fs_sb_info *sbi)
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 269f690..ad5b9f1 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -83,6 +83,8 @@
 	(segno / SIT_ENTRY_PER_BLOCK)
 #define	START_SEGNO(sit_i, segno)		\
 	(SIT_BLOCK_OFFSET(sit_i, segno) * SIT_ENTRY_PER_BLOCK)
+#define SIT_BLK_CNT(sbi)			\
+	((TOTAL_SEGS(sbi) + SIT_ENTRY_PER_BLOCK - 1) / SIT_ENTRY_PER_BLOCK)
 #define f2fs_bitmap_size(nr)			\
 	(BITS_TO_LONGS(nr) * sizeof(unsigned long))
 #define TOTAL_SEGS(sbi)	(SM_I(sbi)->main_segments)
-- 
1.7.9.5

