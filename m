Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab3KTGsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 01:48:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:45231 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3KTGsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 01:48:07 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-52-528c5b26f56c
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
References: 
In-reply-to: 
Subject: [f2fs-dev] [PATCH V2 2/2 RESEND] f2fs: read contiguous sit entry pages
 by merging for mount performance
Date: Wed, 20 Nov 2013 14:47:37 +0800
Message-id: <001d01cee5bc$779c2fe0$66d48fa0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7ltIsmukEgZNsFRni7xDl/86kK2QABdSMA
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t9jAV216J4ggyerrC2u7/rLZHFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoErY/exH4wF
	bzUqVr66xN7A2K/YxcjJISFgInF72hVmCFtM4sK99WwgtpDAIkaJDctUIewfjBJPZqWA2GwC
	KhLLO/4zgdgiAooSG95vYO9i5OJgFpjBKHF47j/WLkYOoAZuidXNQSA1nAI8Euv+dILNFxYo
	kth44hmYzSKgKrG+8zdYOa+ApcSlPk2QMK+AoMSPyfdYQGxmAQ2J/kUb2CBseYnNa95Cnakg
	sePsa0aIE4wkrry5CVUjLrHxyC2WCYxCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk910iv
	ODG3uDQvXS85P3cTIzj8n0nvYFzVYHGIUYCDUYmHt2BRd5AQa2JZcWXuIUYJDmYlEd5b7j1B
	QrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhgdL33oM97R
	2Lck6e2U8taKuJ4zCdbWdSwfs2/772qqtr+zdvpKVf9Lj95vMl/3Ik88QVVs5YmmrllXembz
	sPw5ZerkGljiZPc42Tp91+HHcxavLPapX8RyQuJwhfEb456JV6dNZfo1f6LT6ivTZP1zkjju
	btP34mOJuZI4MXWt1rK+i8vDd61XYinOSDTUYi4qTgQAvM3eWnsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we read sit entries page one by one, this method lost the chance 
of reading contiguous page together. So we read pages as contiguous as 
possible for better mount performance.

v1-->v2:
 o merge judgements/use 'Continue' or 'Break' instead of 'Goto' as Gu Zheng 
    suggested.
 o add mark_page_accessed() before release page to delay VM reclaiming them.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/segment.c |  108 ++++++++++++++++++++++++++++++++++++++++-------------
 fs/f2fs/segment.h |    2 +
 2 files changed, 84 insertions(+), 26 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 8149eba..52c88de 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -14,6 +14,7 @@
 #include <linux/blkdev.h>
 #include <linux/prefetch.h>
 #include <linux/vmalloc.h>
+#include <linux/swap.h>
 
 #include "f2fs.h"
 #include "segment.h"
@@ -1488,41 +1489,96 @@ static int build_curseg(struct f2fs_sb_info *sbi)
 	return restore_curseg_summaries(sbi);
 }
 
+static int ra_sit_pages(struct f2fs_sb_info *sbi, int start,
+					int nrpages, bool *is_order)
+{
+	struct address_space *mapping = sbi->meta_inode->i_mapping;
+	struct sit_info *sit_i = SIT_I(sbi);
+	struct page *page;
+	block_t blk_addr;
+	int blkno = start, readcnt = 0;
+	int sit_blk_cnt = SIT_BLK_CNT(sbi);
+
+	for (; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++) {
+
+		if ((!f2fs_test_bit(blkno, sit_i->sit_bitmap) ^ !*is_order)) {
+			*is_order = !*is_order;
+			break;
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
+			mark_page_accessed(page);
+			f2fs_put_page(page, 1);
+			readcnt++;
+			continue;
+		}
+
+		submit_read_page(sbi, page, blk_addr, READ_SYNC);
+
+		mark_page_accessed(page);
+		f2fs_put_page(page, 0);
+		readcnt++;
+	}
+
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
-
-	for (start = 0; start < TOTAL_SEGS(sbi); start++) {
-		struct seg_entry *se = &sit_i->sentries[start];
-		struct f2fs_sit_block *sit_blk;
-		struct f2fs_sit_entry sit;
-		struct page *page;
-		int i;
+	bool is_order = f2fs_test_bit(0, sit_i->sit_bitmap) ? true : false;
+	int sit_blk_cnt = SIT_BLK_CNT(sbi);
+	unsigned int i, start, end;
+	unsigned int readed, start_blk = 0;
 
-		mutex_lock(&curseg->curseg_mutex);
-		for (i = 0; i < sits_in_cursum(sum); i++) {
-			if (le32_to_cpu(segno_in_journal(sum, i)) == start) {
-				sit = sit_in_journal(sum, i);
-				mutex_unlock(&curseg->curseg_mutex);
-				goto got_it;
+	do {
+		readed = ra_sit_pages(sbi, start_blk, sit_blk_cnt, &is_order);
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

