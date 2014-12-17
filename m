Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaLQKLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:11:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26512 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaLQKLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:11:38 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-8d-549156d7f572
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH v2] f2fs: use ra_meta_pages to simplify readahead
 code in restore_node_summary
Date: Wed, 17 Dec 2014 18:10:35 +0800
Message-id: <001d01d019e1$d6ad6c10$84084430$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAZ4RJpAgNe/ZLxRii8aE7r89n74w==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jQd3rYRNDDK5cVrG4tq+RyeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	mvtuMBfck66YtGcWUwPjT9EuRk4OCQETiUftT5khbDGJC/fWs3UxcnEICUxnlNj3bBcLSEJI
	4AejxNrrViA2m4CKxPKO/0wgtoiAl8Sk/SfAapgFMiXuNc0AGyQskCVx49hxsDiLgKrEtV9T
	gOo5OHgFLCXWbw8BCfMKCEr8mHwPqlVLYv3O40wQtrzE5jVvoe5RkNhx9jUjxCo9iXOvz7BD
	1IhLbDxyi2UCo8AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQI
	Du1n0jsYVzVYHGIU4GBU4uF9eX1CiBBrYllxZe4hRgkOZiUR3s+BE0OEeFMSK6tSi/Lji0pz
	UosPMUpzsCiJ8yrZt4UICaQnlqRmp6YWpBbBZJk4OKUaGCd/V1vQtXOqy+E9LpO6TgZ9bul/
	8mKnpt351yFbU5oeLO2McUt9s8vHMcu1U6zj758ww79lJ31zt9/rnfij5qf0vStfuKwls5Mq
	T/f+qj1xYLP6el0hlY78Su8WEf51ajOdzs43XKy2eO6CLsOvt3cHSvqYcEds973IkzXj8olH
	Cwyiw3yPLlFiKc5INNRiLipOBADjv7tVaQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more common function ra_meta_pages() with META_POR to readahead node blocks
in restore_node_summary() instead of ra_sum_pages(), hence we can simplify the
readahead code there, and also we can remove unused function ra_sum_pages().

changes from v1:
 o fix one bug when using truncate_inode_pages_range which is pointed out by
   Jaegeuk Kim.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c | 68 +++++++++++++---------------------------------------------
 1 file changed, 15 insertions(+), 53 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 5aa54a0..ab48b4c 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1726,80 +1726,42 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
 	return 0;
 }
 
-/*
- * ra_sum_pages() merge contiguous pages into one bio and submit.
- * these pre-read pages are allocated in bd_inode's mapping tree.
- */
-static int ra_sum_pages(struct f2fs_sb_info *sbi, struct page **pages,
-				int start, int nrpages)
-{
-	struct inode *inode = sbi->sb->s_bdev->bd_inode;
-	struct address_space *mapping = inode->i_mapping;
-	int i, page_idx = start;
-	struct f2fs_io_info fio = {
-		.type = META,
-		.rw = READ_SYNC | REQ_META | REQ_PRIO
-	};
-
-	for (i = 0; page_idx < start + nrpages; page_idx++, i++) {
-		/* alloc page in bd_inode for reading node summary info */
-		pages[i] = grab_cache_page(mapping, page_idx);
-		if (!pages[i])
-			break;
-		f2fs_submit_page_mbio(sbi, pages[i], page_idx, &fio);
-	}
-
-	f2fs_submit_merged_bio(sbi, META, READ);
-	return i;
-}
-
 int restore_node_summary(struct f2fs_sb_info *sbi,
 			unsigned int segno, struct f2fs_summary_block *sum)
 {
 	struct f2fs_node *rn;
 	struct f2fs_summary *sum_entry;
-	struct inode *inode = sbi->sb->s_bdev->bd_inode;
 	block_t addr;
 	int bio_blocks = MAX_BIO_BLOCKS(sbi);
-	struct page *pages[bio_blocks];
-	int i, idx, last_offset, nrpages, err = 0;
+	int i, idx, last_offset, nrpages;
 
 	/* scan the node segment */
 	last_offset = sbi->blocks_per_seg;
 	addr = START_BLOCK(sbi, segno);
 	sum_entry = &sum->entries[0];
 
-	for (i = 0; !err && i < last_offset; i += nrpages, addr += nrpages) {
+	for (i = 0; i < last_offset; i += nrpages, addr += nrpages) {
 		nrpages = min(last_offset - i, bio_blocks);
 
 		/* readahead node pages */
-		nrpages = ra_sum_pages(sbi, pages, addr, nrpages);
-		if (!nrpages)
-			return -ENOMEM;
+		ra_meta_pages(sbi, addr, nrpages, META_POR);
 
-		for (idx = 0; idx < nrpages; idx++) {
-			if (err)
-				goto skip;
+		for (idx = addr; idx < addr + nrpages; idx++) {
+			struct page *page = get_meta_page(sbi, idx);
 
-			lock_page(pages[idx]);
-			if (unlikely(!PageUptodate(pages[idx]))) {
-				err = -EIO;
-			} else {
-				rn = F2FS_NODE(pages[idx]);
-				sum_entry->nid = rn->footer.nid;
-				sum_entry->version = 0;
-				sum_entry->ofs_in_node = 0;
-				sum_entry++;
-			}
-			unlock_page(pages[idx]);
-skip:
-			page_cache_release(pages[idx]);
+			rn = F2FS_NODE(page);
+			sum_entry->nid = rn->footer.nid;
+			sum_entry->version = 0;
+			sum_entry->ofs_in_node = 0;
+			sum_entry++;
+			f2fs_put_page(page, 1);
 		}
 
-		invalidate_mapping_pages(inode->i_mapping, addr,
-							addr + nrpages);
+		truncate_inode_pages_range(META_MAPPING(sbi),
+				addr << PAGE_CACHE_SHIFT,
+				((addr + nrpages) << PAGE_CACHE_SHIFT) - 1);
 	}
-	return err;
+	return 0;
 }
 
 static void remove_nats_in_journal(struct f2fs_sb_info *sbi)
-- 
2.1.2


