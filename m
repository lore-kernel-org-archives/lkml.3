Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaE0AmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:42:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50216 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaE0AmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:42:12 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-e9-5383df6219b5
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH v2] f2fs: avoid crash when trace
 f2fs_submit_page_mbio event in ra_sum_pages
Date: Tue, 27 May 2014 08:41:07 +0800
Message-id: <00f501cf7944$7e8a65d0$7b9f3170$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac95QzN+wgKstX0OSX+i8fXAhIjuEQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd2k+83BBg/vyVlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlTFv+lf2gn3KFcvX
	9jI3MN6W6WLk5JAQMJG4+6aNGcIWk7hwbz1bFyMXh5DAIkaJ7b+fskM4Pxgl3q35xApSxSag
	IrG84z8TiC0ioCnxePlmsG5mgUyJe00zgGwODmEg+9JuCZAwi4CqxMSWV+wgNq+ApcTHixCt
	vAKCEj8m32OBaNWSWL/zOBOELS+xec1bqIMUJHacfc0IsUpP4tuc2+wQNeISG4/cYpnAKDAL
	yahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCA/mZ9A7GVQ0WhxgF
	OBiVeHgn+DYHC7EmlhVX5h5ilOBgVhLh3XASKMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1
	oJBAemJJanZqakFqEUyWiYNTqoGx5IXBzul92zalsFkZFlhtNPn+y6K7xPJ4zvs3ltIL7jw7
	4nX3WGD2xUTWsqJD9w9bvFt++9WlsypX4mt8jF/MlPOfbrrbXbCUL/T+sbv3j5ZJOc3u+LZl
	3+XtxUZvp1sxsz15nMP/j2+S5ZGwIr/piV4drOYWiSGeh0JvhQfIle2fKeXneSlSiaU4I9FQ
	i7moOBEALDOGQ2ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we allocate pages with no mapping in ra_sum_pages(), so we may
encounter a crash in event trace of f2fs_submit_page_mbio where we access
mapping data of the page.

We'd better allocate pages in bd_inode mapping and invalidate these pages after
we restore data from pages. It could avoid crash in above scenario.

Changes from V1
 o remove redundant code in ra_sum_pages() suggested by Jaegeuk Kim.

Call Trace:
 [<f1031630>] ? ftrace_raw_event_f2fs_write_checkpoint+0x80/0x80 [f2fs]
 [<f10377bb>] f2fs_submit_page_mbio+0x1cb/0x200 [f2fs]
 [<f103c5da>] restore_node_summary+0x13a/0x280 [f2fs]
 [<f103e22d>] build_curseg+0x2bd/0x620 [f2fs]
 [<f104043b>] build_segment_manager+0x1cb/0x920 [f2fs]
 [<f1032c85>] f2fs_fill_super+0x535/0x8e0 [f2fs]
 [<c115b66a>] mount_bdev+0x16a/0x1a0
 [<f102f63f>] f2fs_mount+0x1f/0x30 [f2fs]
 [<c115c096>] mount_fs+0x36/0x170
 [<c1173635>] vfs_kern_mount+0x55/0xe0
 [<c1175388>] do_mount+0x1e8/0x900
 [<c1175d72>] SyS_mount+0x82/0xc0
 [<c16059cc>] sysenter_do_call+0x12/0x22

Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c |   52 ++++++++++++++++++++++++----------------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 3d60d3d..02a59e9 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1658,35 +1658,29 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
 
 /*
  * ra_sum_pages() merge contiguous pages into one bio and submit.
- * these pre-readed pages are linked in pages list.
+ * these pre-readed pages are alloced in bd_inode's mapping tree.
  */
-static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
+static int ra_sum_pages(struct f2fs_sb_info *sbi, struct page **pages,
 				int start, int nrpages)
 {
-	struct page *page;
-	int page_idx = start;
+	struct inode *inode = sbi->sb->s_bdev->bd_inode;
+	struct address_space *mapping = inode->i_mapping;
+	int i, page_idx = start;
 	struct f2fs_io_info fio = {
 		.type = META,
 		.rw = READ_SYNC | REQ_META | REQ_PRIO
 	};
 
-	for (; page_idx < start + nrpages; page_idx++) {
-		/* alloc temporal page for read node summary info*/
-		page = alloc_page(GFP_F2FS_ZERO);
-		if (!page)
+	for (i = 0; page_idx < start + nrpages; page_idx++, i++) {
+		/* alloc page in bd_inode for reading node summary info */
+		pages[i] = grab_cache_page(mapping, page_idx);
+		if (!pages[i])
 			break;
-
-		lock_page(page);
-		page->index = page_idx;
-		list_add_tail(&page->lru, pages);
+		f2fs_submit_page_mbio(sbi, pages[i], page_idx, &fio);
 	}
 
-	list_for_each_entry(page, pages, lru)
-		f2fs_submit_page_mbio(sbi, page, page->index, &fio);
-
 	f2fs_submit_merged_bio(sbi, META, READ);
-
-	return page_idx - start;
+	return i;
 }
 
 int restore_node_summary(struct f2fs_sb_info *sbi,
@@ -1694,11 +1688,11 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 {
 	struct f2fs_node *rn;
 	struct f2fs_summary *sum_entry;
-	struct page *page, *tmp;
+	struct inode *inode = sbi->sb->s_bdev->bd_inode;
 	block_t addr;
 	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
-	int i, last_offset, nrpages, err = 0;
-	LIST_HEAD(page_list);
+	struct page *pages[bio_blocks];
+	int i, idx, last_offset, nrpages, err = 0;
 
 	/* scan the node segment */
 	last_offset = sbi->blocks_per_seg;
@@ -1709,29 +1703,31 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 		nrpages = min(last_offset - i, bio_blocks);
 
 		/* read ahead node pages */
-		nrpages = ra_sum_pages(sbi, &page_list, addr, nrpages);
+		nrpages = ra_sum_pages(sbi, pages, addr, nrpages);
 		if (!nrpages)
 			return -ENOMEM;
 
-		list_for_each_entry_safe(page, tmp, &page_list, lru) {
+		for (idx = 0; idx < nrpages; idx++) {
 			if (err)
 				goto skip;
 
-			lock_page(page);
-			if (unlikely(!PageUptodate(page))) {
+			lock_page(pages[idx]);
+			if (unlikely(!PageUptodate(pages[idx]))) {
 				err = -EIO;
 			} else {
-				rn = F2FS_NODE(page);
+				rn = F2FS_NODE(pages[idx]);
 				sum_entry->nid = rn->footer.nid;
 				sum_entry->version = 0;
 				sum_entry->ofs_in_node = 0;
 				sum_entry++;
 			}
-			unlock_page(page);
+			unlock_page(pages[idx]);
 skip:
-			list_del(&page->lru);
-			__free_pages(page, 0);
+			page_cache_release(pages[idx]);
 		}
+
+		invalidate_mapping_pages(inode->i_mapping, addr,
+							addr + nrpages);
 	}
 	return err;
 }
-- 
1.7.9.5


