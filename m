Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3I3Kvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:51:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57259 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab3I3Kvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:51:32 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-d0-5249578f5488
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev][PATCH DISCUSS] f2fs: readahead continuous sit entry pages
 for better mount performance
Date: Mon, 30 Sep 2013 18:49:54 +0800
Message-id: <000301cebdca$ebcd5930$c3680b90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac69x6HbXJQtLesKQ7e4ABEYMwLvKA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQd0J4Z5BBmcfM1tc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxuOzJ1gL
	HiVU/Jzv1cB4yaeLkYNDQsBE4scJ5y5GTiBTTOLCvfVsXYxcHEIC0xklGu/2MUI4Pxgljt1d
	xwxSxSagIrG84z8TiC0ioCix4f0GdpAiZoFpjBLzl3xnA0kIC+RIzLr7EcxmEVCVWH/nKlgD
	r4ClxNvVF6BsQYkfk++xgNjMAhoS/Ys2sEHY8hKb17xlhjhJQWLH2deMEMv0JM7P/A9VIy6x
	8cgtlgmMArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4pJ9J
	7WBc2WBxiFGAg1GJh3fCco8gIdbEsuLK3EOMEhzMSiK8E9w8g4R4UxIrq1KL8uOLSnNSiw8x
	SnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwtoktvvjlU//+g31Pjt4qbnmRq3Xj0/Zd
	/VLJa88Km9VINqYoGB0v506O1rVbnaP9+SLfu81nlP0d1+5Yvfr0jOOB7MYa1rbzIt5+0zS6
	pXf94IRFgq82VjtLGCXU6vaJ1zbzraqcmbPmEudqlwDxvIt1thmt1581vnT+Uscm2peWp8lz
	98R6JZbijERDLeai4kQAMMq8u2UCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since f2fs mount process should scanning all valid SIT entries and reserve
information in memory for following operations during mount process, the
mount performance is worse than ext4 in embedded devices. We found a way to
improve the mount performance based on current f2fs design strategy. For the
tests on Galaxy SIII, the mount performance can be improved by 20% ~ 30%.

Considering following items:
1.	The maximum count of sit journal entries reserved in current
CURSEG_COLD_DATA segment information is 6 (SIT_JOURNAL_ENTRIES), that means,
the actual journal entries are no more than 6;
2.	Each block in SIT area can contain 55 entries (SIT_ENTRY_PER_BLOCK).
Because there are no more than 6 journal entries in checkpoint area, most
sit entries is achieved from SIT#0 or SIT#1 and all the valid sit pages are
read out for organizing all sit entries in memory. 
3.	Mostly the valid sit blocks exist in SIT#0 or SIT#1 continuously.
4.	Read multiple continuous pages within one bio is faster than read
page one by one in multiple bio.

Thinking about the items above, we tried to read multiple continues pages
within one bio for build sit entries in memory.

Following is current design of mount function build_sit_entries:
1.	Cycle from first segment to final segment;
2.	Scan all checkpoint journal entries, if the segment number is the
same as current cycle segment number, read sit and reserve in memory and go
to step 1; otherwise, continue with step 3;
3.	Read one meta page from SIT#0 or SIT#1 considering current valid
meta page bitmap and reserve sit information in memory, go to step 1;

We change the design of build_sit_entries as:
1.	Create a page_array with maximum size as max_hw_blocks(sbi) (one
page array can contain maximum size of pages). 
2.	Cycle from first SIT entry block to final SIT entry block.
3.	ra_sit_pages: read multiple continuous sit pages. If a) reached
maximum size of page_array or b) sit blocks are converted from SIT#0 to
SIT#1 or from SIT#1 to SIT#0, return to build_sit_entries; (that means, try
to read continuous pages in SIT#0 or SIT#1 within one bio)
4.	get pages that is read previously one by one, and reserve sit entry
information in memory; go to step 2;
5.	After all valid sit entries in SIT#0 or SIT#1 are reserved in
memory, free page_array, scanning all journal sit entries in checkpoint area
and cover the information to memory sit entries (sit_i->sentries). 

One more optimization is, considering most sit entries contain totally valid
blocks or totally invalid blocks in one page because of f2fs allocation and
garbage collection strategy, we changed the check function check_block_count
for sit entry:

Here is our temp patch base on f2fs of linux-next:

Signed-off-by: Tan Shu <shu.tan@samsung.com>
Reviewed-by: Li Fan < fanofcode.li@samsung.com>
Reviewed-by: Yu Chao <chao2.yu@samsung.com>
---
 fs/f2fs/data.c    |    2 +-
 fs/f2fs/f2fs.h    |    1 +
 fs/f2fs/segment.c |  211
+++++++++++++++++++++++++++++++++++++++++++++--------
 fs/f2fs/segment.h |   18 +++++
 4 files changed, 202 insertions(+), 30 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
old mode 100644
new mode 100755
index 2c02ec8..7d8e9f6
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -355,7 +355,7 @@ repeat:
 	return page;
 }
 
-static void read_end_io(struct bio *bio, int err)
+void read_end_io(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
old mode 100644
new mode 100755
index 7fd99d8..9f3a784
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1117,6 +1117,7 @@ struct page *get_lock_data_page(struct inode *,
pgoff_t);
 struct page *get_new_data_page(struct inode *, struct page *, pgoff_t,
bool);
 int f2fs_readpage(struct f2fs_sb_info *, struct page *, block_t, int);
 int do_write_data_page(struct page *);
+void read_end_io(struct bio *bio, int err);
 
 /*
  * gc.c
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
old mode 100644
new mode 100755
index bd79bbe..971838d
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -14,6 +14,9 @@
 #include <linux/blkdev.h>
 #include <linux/prefetch.h>
 #include <linux/vmalloc.h>
+#include <linux/mpage.h>
+#include <linux/pagevec.h>
+#include <linux/swap.h>
 
 #include "f2fs.h"
 #include "segment.h"
@@ -1210,21 +1213,108 @@ int lookup_journal_in_cursum(struct
f2fs_summary_block *sum, int type,
 	}
 	return -1;
 }
-
-static struct page *get_current_sit_page(struct f2fs_sb_info *sbi,
-					unsigned int segno)
+static void ra_sit_pages(struct f2fs_sb_info *sbi, 
+							struct page**
page_array, 
+							int array_size, 
+							unsigned int start, 
+							unsigned int* next, 
+							unsigned int* base)
 {
+	struct address_space *mapping = sbi->meta_inode->i_mapping;
 	struct sit_info *sit_i = SIT_I(sbi);
-	unsigned int offset = SIT_BLOCK_OFFSET(sit_i, segno);
-	block_t blk_addr = sit_i->sit_base_addr + offset;
-
-	check_seg_range(sbi, segno);
+	block_t blk_addr = sit_i->sit_base_addr;
+	unsigned int sit_blk_cnt = (TOTAL_SEGS(sbi) + SIT_ENTRY_PER_BLOCK -
1)/SIT_ENTRY_PER_BLOCK;
+	unsigned int end = sit_blk_cnt;
+	struct block_device *bdev = sbi->sb->s_bdev;
+	struct bio *bio = NULL;
+	struct blk_plug plug;
+	int writecnt = 0;
+	int sit_blkaddr;
+	int i;
+	unsigned int start_idx = 0, end_idx;
 
-	/* calculate sit block address */
-	if (f2fs_test_bit(offset, sit_i->sit_bitmap))
+	if (f2fs_test_bit(start, sit_i->sit_bitmap)) {
 		blk_addr += sit_i->sit_blocks;
+		for (i = start + 1; i < sit_blk_cnt; i++) {
+			if (((i - start) == array_size) ||
(!f2fs_test_bit(i, sit_i->sit_bitmap))){
+				end = i;
+				break;
+			}
+		}
+	}
+	else {
+		for (i = start + 1; i < sit_blk_cnt; i++){
+			if (((i - start) == array_size) || (f2fs_test_bit(i,
sit_i->sit_bitmap))){
+				end = i;
+				break;
+			}
+		}
+	}
+
+	*next = end;
+	*base = blk_addr;
+
+	blk_start_plug(&plug);
+	down_read(&sbi->bio_sem);
+	
+	for (i = 0; i < end - start; i++) {
+		sit_blkaddr = blk_addr + start + i;
+repeat:
+		page_array[i] = grab_cache_page(mapping, sit_blkaddr);
+		if (!page_array[i]) {
+			cond_resched();
+			goto repeat;
+		}
 
-	return get_meta_page(sbi, blk_addr);
+		if (PageUptodate(page_array[i])) {
+			/*Actually, this should not happen. But we add codes
for confirmation*/
+			f2fs_put_page(page_array[i], 1);
+			page_array[i] = NULL;
+			if (writecnt != 0){
+				submit_bio(READ_SYNC, bio);
+				writecnt = 0;
+			}
+			continue;
+		}
+
+		if (writecnt == 0){  
+			/* If writecnt is zero, we should allocate a new bio
for submit */
+			bio = f2fs_bio_alloc(bdev, array_size);
+			bio->bi_sector = SECTOR_FROM_BLOCK(sbi,
sit_blkaddr);
+			bio->bi_end_io = read_end_io;
+			start_idx = i;
+		}
+
+		if (bio_add_page(bio, page_array[i], PAGE_CACHE_SIZE, 0) <
+								PAGE_CACHE_S
IZE) {
+			kfree(bio->bi_private);
+			bio_put(bio);
+			up_read(&sbi->bio_sem);
+			blk_finish_plug(&plug);
+			/*Here we should put page from start_idx to end_idx.

+			For the pages in previous submitted bio, we can
ignore them.*/
+			end_idx = i;
+			goto exit;
+		}
+		writecnt++;
+	}
+
+	if (writecnt)
+		submit_bio(READ_SYNC, bio);
+	
+	up_read(&sbi->bio_sem);
+	blk_finish_plug(&plug);
+
+	return;
+
+exit:  /*ATTENTIONS: If failed, build_sit_entries will check and call
get_meta_page later*/
+	for (i = start_idx; i <= end_idx; i++){
+		if (page_array[i]){
+			f2fs_put_page(page_array[i], 1);
+			page_array[i] = NULL;
+		}
+	}
+	return;
 }
 
 static struct page *get_next_sit_page(struct f2fs_sb_info *sbi,
@@ -1481,36 +1571,99 @@ static void build_sit_entries(struct f2fs_sb_info
*sbi)
 	struct sit_info *sit_i = SIT_I(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_COLD_DATA);
 	struct f2fs_summary_block *sum = curseg->sum_blk;
-	unsigned int start;
-
-	for (start = 0; start < TOTAL_SEGS(sbi); start++) {
-		struct seg_entry *se = &sit_i->sentries[start];
+	unsigned int start_sitblk = 0;
+	unsigned int next_sitblk = 0;
+	unsigned int base_sitblk = 0;
 		struct f2fs_sit_block *sit_blk;
 		struct f2fs_sit_entry sit;
-		struct page *page;
-		int i;
+	struct seg_entry *se;
+	unsigned int i, j;
+	struct page** page_array = NULL;
+	int array_size;
+	unsigned int sit_blk_cnt = (TOTAL_SEGS(sbi) + SIT_ENTRY_PER_BLOCK -
1)/SIT_ENTRY_PER_BLOCK;
+	struct address_space *mapping = sbi->meta_inode->i_mapping;
+
+	array_size = max_hw_blocks(sbi);
+	page_array = (struct page**)vzalloc(sizeof(struct page*) *
array_size);
+
+	while (1){
+		memset(page_array, 0x00, sizeof(struct page*) * array_size);
+		ra_sit_pages(sbi, page_array, array_size, start_sitblk,
&next_sitblk, &base_sitblk);
+		
+		for (i = 0; i < next_sitblk - start_sitblk; i++) {
+			unsigned int sit_blkno;
+			
+			if (page_array[i])
+			{
+				/* Get page from ra_sit_pages previously */
+				lock_page(page_array[i]);
+
+				if ((page_array[i]->mapping == mapping)
+					&& PageUptodate(page_array[i]))
+				{
+					mark_page_accessed(page_array[i]);
+				}
+				else
+				{
+					/* Read single page, actually , this
branch should not be entered.
+					We add this branch just for
ensurance */
+					f2fs_put_page(page_array[i], 1);
+					page_array[i] = NULL;
+				}
+			}
+
+			if (!page_array[i])
+			{
+				/* Read single page, actually , this branch
should not be entered.
+				We add this branch just for ensurance */
+				page_array[i] = get_meta_page(sbi,
base_sitblk + start_sitblk + i);
+			}
+
+			sit_blkno = i + start_sitblk;
+			sit_blk = (struct f2fs_sit_block
*)page_address(page_array[i]);
+			for (j = 0; j < sit_i->sents_per_block; j++){
+				unsigned int segno;
+				segno = sit_blkno * sit_i->sents_per_block +
j;
+				if (segno >= TOTAL_SEGS(sbi)){
+					break;
+				}
+
+				se = &sit_i->sentries[segno];
+				sit = sit_blk->entries[j];
+				check_block_count(sbi, segno, &sit);
+				seg_info_from_raw_sit(se, &sit);
+				if (sbi->segs_per_sec > 1) {
+					struct sec_entry *e =
get_sec_entry(sbi, segno);
+					e->valid_blocks += se->valid_blocks;
+				}
+			}
+
+			f2fs_put_page(page_array[i], 1);
+		}
+
+		if (next_sitblk >= sit_blk_cnt){
+			break;
+		}
+
+		start_sitblk = next_sitblk;
+	}
+
+	vfree(page_array);
 
 		mutex_lock(&curseg->curseg_mutex);
 		for (i = 0; i < sits_in_cursum(sum); i++) {
-			if (le32_to_cpu(segno_in_journal(sum, i)) == start)
{
+		j = le32_to_cpu(segno_in_journal(sum, i));
 				sit = sit_in_journal(sum, i);
-				mutex_unlock(&curseg->curseg_mutex);
-				goto got_it;
-			}
-		}
-		mutex_unlock(&curseg->curseg_mutex);
-		page = get_current_sit_page(sbi, start);
-		sit_blk = (struct f2fs_sit_block *)page_address(page);
-		sit = sit_blk->entries[SIT_ENTRY_OFFSET(sit_i, start)];
-		f2fs_put_page(page, 1);
-got_it:
-		check_block_count(sbi, start, &sit);
+		se = &sit_i->sentries[j];
+		check_block_count(sbi, j, &sit);
 		seg_info_from_raw_sit(se, &sit);
 		if (sbi->segs_per_sec > 1) {
-			struct sec_entry *e = get_sec_entry(sbi, start);
+			struct sec_entry *e = get_sec_entry(sbi, j);
 			e->valid_blocks += se->valid_blocks;
 		}
 	}
+	mutex_unlock(&curseg->curseg_mutex);
+
 }
 
 static void init_free_segmap(struct f2fs_sb_info *sbi)
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
old mode 100644
new mode 100755
index 7f94d78..fabcb25
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -552,6 +552,24 @@ static inline void check_block_count(struct
f2fs_sb_info *sbi,
 	/* check boundary of a given segment number */
 	BUG_ON(segno > end_segno);
 
+	if (GET_SIT_VBLOCKS(raw_sit) == 0) {
+		for (i = 0; i < SIT_VBLOCK_MAP_SIZE; i++) {
+			if (raw_sit->valid_map[i] != 0) {
+				goto mismatch_check;
+			}
+		}
+		return;
+	}
+	else if (GET_SIT_VBLOCKS(raw_sit) == sbi->blocks_per_seg) {
+		for (i = 0; i < SIT_VBLOCK_MAP_SIZE; i++) {
+			if (raw_sit->valid_map[i] != 0xFF) {
+				goto mismatch_check;
+			}
+		}
+		return;
+	}
+
+mismatch_check:
 	/* check bitmap with valid block count */
 	for (i = 0; i < sbi->blocks_per_seg; i++)
 		if (f2fs_test_bit(i, raw_sit->valid_map))
---

