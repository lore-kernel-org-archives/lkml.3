Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3KVBK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:10:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54222 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab3KVBK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:10:56 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-f6-528eaf1eccd0
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH V3 2/2] f2fs: read contiguous sit entry pages by
 merging for mount performance
Date: Fri, 22 Nov 2013 09:09:59 +0800
Message-id: <000301cee71f$b0e54160$12afc420$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7nHt35lUwHoahZSFKr0eNoeKUDXA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jQV259X1BBpd+6Flc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxrPNVxgL
	ZmpUXFlziL2B8apCFyMnh4SAicSCp8tYIWwxiQv31rN1MXJxCAlMZ5S4+ugYM4TzA8jZeYwd
	pIpNQEViecd/JhBbREBRYsP7DewgRcwCMxglDs/9BzZKWCBb4uGWLhYQm0VAVWLaulWMIDav
	gKXEie3bWCFsQYkfk++B1TALaEj0L9rABmHLS2xe85YZ4iQFiR1nXzNCLNOT2LN/CTtEjbjE
	xiO3WCYwCsxCMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgsH4m
	tYNxZYPFIUYBDkYlHl4Bm74gIdbEsuLK3EOMEhzMSiK8UwuBQrwpiZVVqUX58UWlOanFhxil
	OViUxHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhj3xGw4FKZ5Q2n/CU7VdIfLzxOV5WeYt3oF
	PnrCcjNh6xn58CVhYtGhkmY3VvzcYNCsofnGzuNpX8SvuTPO7ujdscpl5/7ZCvk2i2qMnh3K
	UDpxyLrRv2mdT/OM2/3rWixSyw/lWiie3SPKoWMUdC1wlpOo520W9nffFcR71852Mnn8/tfb
	hc+UWIozEg21mIuKEwH/ov82ZwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we read sit entries page one by one, this method lost the chance 
of reading contiguous page together. So we read pages as contiguous as 
possible for better mount performance.

change log:
 o merge judgements/use 'Continue' or 'Break' instead of 'Goto' as Gu Zheng 
   suggested.
 o add mark_page_accessed() before release page to delay VM reclaiming.
 o remove '*order' for simplification of function as Jaegeuk Kim suggested.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/segment.c |  103 +++++++++++++++++++++++++++++++++++++++--------------
 fs/f2fs/segment.h |    2 ++
 2 files changed, 78 insertions(+), 27 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 8149eba..998e7d3 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -14,6 +14,7 @@
 #include <linux/blkdev.h>
 #include <linux/prefetch.h>
 #include <linux/vmalloc.h>
+#include <linux/swap.h>
 
 #include "f2fs.h"
 #include "segment.h"
@@ -1488,41 +1489,89 @@ static int build_curseg(struct f2fs_sb_info *sbi)
 	return restore_curseg_summaries(sbi);
 }
 
+static int ra_sit_pages(struct f2fs_sb_info *sbi, int start, int nrpages)
+{
+	struct address_space *mapping = sbi->meta_inode->i_mapping;
+	struct page *page;
+	block_t blk_addr, prev_blk_addr = 0;
+	int sit_blk_cnt = SIT_BLK_CNT(sbi);
+	int blkno = start;
+
+	for (; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++) {
+
+		blk_addr = current_sit_addr(sbi, start * SIT_ENTRY_PER_BLOCK);
+
+		if (blkno != start && prev_blk_addr + 1 != blk_addr)
+			break;
+		prev_blk_addr = blk_addr;
+repeat:
+		page = grab_cache_page(mapping, blk_addr);
+		if (!page) {
+			cond_resched();
+			goto repeat;
+		}
+		if (PageUptodate(page)) {
+			mark_page_accessed(page);
+			f2fs_put_page(page, 1);
+			continue;
+		}
+
+		submit_read_page(sbi, page, blk_addr, READ_SYNC);
+
+		mark_page_accessed(page);
+		f2fs_put_page(page, 0);
+	}
+
+	f2fs_submit_read_bio(sbi, READ_SYNC);
+	return blkno - start;
+}
+
 static void build_sit_entries(struct f2fs_sb_info *sbi)
 {
 	struct sit_info *sit_i = SIT_I(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_COLD_DATA);
 	struct f2fs_summary_block *sum = curseg->sum_blk;
-	unsigned int start;
-
-	for (start = 0; start < TOTAL_SEGS(sbi); start++) {
-		struct seg_entry *se = &sit_i->sentries[start];
-		struct f2fs_sit_block *sit_blk;
-		struct f2fs_sit_entry sit;
-		struct page *page;
-		int i;
-
-		mutex_lock(&curseg->curseg_mutex);
-		for (i = 0; i < sits_in_cursum(sum); i++) {
-			if (le32_to_cpu(segno_in_journal(sum, i)) == start) {
-				sit = sit_in_journal(sum, i);
-				mutex_unlock(&curseg->curseg_mutex);
-				goto got_it;
+	int sit_blk_cnt = SIT_BLK_CNT(sbi);
+	unsigned int i, start, end;
+	unsigned int readed, start_blk = 0;
+	int nrpages = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+	
+	do {
+		readed = ra_sit_pages(sbi, start_blk, nrpages);
+
+		start = start_blk * sit_i->sents_per_block;
+		end = (start_blk + readed) * sit_i->sents_per_block;
+
+		for (; start < end && start < TOTAL_SEGS(sbi); start++) {
+			struct seg_entry *se = &sit_i->sentries[start];
+			struct f2fs_sit_block *sit_blk;
+			struct f2fs_sit_entry sit;
+			struct page *page;
+
+			mutex_lock(&curseg->curseg_mutex);
+			for (i = 0; i < sits_in_cursum(sum); i++) {
+				if (le32_to_cpu(segno_in_journal(sum, i)) == start) {
+					sit = sit_in_journal(sum, i);
+					mutex_unlock(&curseg->curseg_mutex);
+					goto got_it;
+				}
 			}
-		}
-		mutex_unlock(&curseg->curseg_mutex);
-		page = get_current_sit_page(sbi, start);
-		sit_blk = (struct f2fs_sit_block *)page_address(page);
-		sit = sit_blk->entries[SIT_ENTRY_OFFSET(sit_i, start)];
-		f2fs_put_page(page, 1);
+			mutex_unlock(&curseg->curseg_mutex);
+
+			page = get_current_sit_page(sbi, start);
+			sit_blk = (struct f2fs_sit_block *)page_address(page);
+			sit = sit_blk->entries[SIT_ENTRY_OFFSET(sit_i, start)];
+			f2fs_put_page(page, 1);
 got_it:
-		check_block_count(sbi, start, &sit);
-		seg_info_from_raw_sit(se, &sit);
-		if (sbi->segs_per_sec > 1) {
-			struct sec_entry *e = get_sec_entry(sbi, start);
-			e->valid_blocks += se->valid_blocks;
+			check_block_count(sbi, start, &sit);
+			seg_info_from_raw_sit(se, &sit);
+			if (sbi->segs_per_sec > 1) {
+				struct sec_entry *e = get_sec_entry(sbi, start);
+				e->valid_blocks += se->valid_blocks;
+			}
 		}
-	}
+		start_blk += readed;
+	} while (start_blk < sit_blk_cnt);
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

