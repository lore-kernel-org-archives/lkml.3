Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbaEPJPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:15:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44211 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529AbaEPJPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:15:40 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-03-5375d73a45f5
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: avoid crash when trace f2fs_submit_page_mbio
 event in ra_sum_pages
Date: Fri, 16 May 2014 17:14:47 +0800
Message-id: <005801cf70e7$66cb0090$346101b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9w3QsckpzRhHniT+KFOs2fMW2uqg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQV2r66XBBrd+CFpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAldFwo7Dgr3LFseuv
	WBsYZ8l2MXJySAiYSHz+8JYdwhaTuHBvPVsXIxeHkMB0RokL57azQDg/GCU2nJ8HVsUmoCKx
	vOM/E4gtIqAp8Xj5ZmYQm1kgU+Je0wwwW1ggVeL39/1gNouAqsSHPXtZQGxeAUuJY23r2SFs
	QYkfk++xQPRqSWze1sQKYctLbF7zlhniIgWJHWdfM0Ls0pNY+ns7O0SNuMTGI7dYJjAKzEIy
	ahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBAfia1g3Flg8UhRgEO
	RiUe3gtapcFCrIllxZW5hxglOJiVRHhdrwGFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4U
	EkhPLEnNTk0tSC2CyTJxcEo1MPKVnQyr+JYiFfIt3+11jkmE7EqxHRZJjJwCaQvLJ9xKOHTJ
	dVJubsIi2zN+3nGX7yjEaKdZq7RNr79g5+6yonCT6t9Kh4yUOO0zTM94+1N6p9eV7vOdzBoa
	/f5d5DvD0zt6nzLVZ3BvLo2S8TihduaNtdmMhxv+rv8THs53YnNyf1bMhnNCSizFGYmGWsxF
	xYkAmSZzGWACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we allocate pages with no mapping in ra_sum_pages(), so we may
encounter a crash in event trace of f2fs_submit_page_mbio where we access
mapping data of the page.

We'd better allocate pages in bd_inode mapping and invalidate these pages after
we restore data from pages. It could avoid crash in above scenario.

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

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c |   49 ++++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 3d60d3d..b5cd814 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1658,13 +1658,16 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
 
 /*
  * ra_sum_pages() merge contiguous pages into one bio and submit.
- * these pre-readed pages are linked in pages list.
+ * these pre-readed pages are alloced in bd_inode's mapping tree.
  */
-static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
+static int ra_sum_pages(struct f2fs_sb_info *sbi, struct page **pages,
 				int start, int nrpages)
 {
 	struct page *page;
+	struct inode *inode = sbi->sb->s_bdev->bd_inode;
+	struct address_space *mapping = inode->i_mapping;
 	int page_idx = start;
+	int alloced, readed;
 	struct f2fs_io_info fio = {
 		.type = META,
 		.rw = READ_SYNC | REQ_META | REQ_PRIO
@@ -1672,21 +1675,23 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
 
 	for (; page_idx < start + nrpages; page_idx++) {
 		/* alloc temporal page for read node summary info*/
-		page = alloc_page(GFP_F2FS_ZERO);
+		page = grab_cache_page(mapping, page_idx);
 		if (!page)
 			break;
-
-		lock_page(page);
-		page->index = page_idx;
-		list_add_tail(&page->lru, pages);
+		page_cache_release(page);
 	}
 
-	list_for_each_entry(page, pages, lru)
-		f2fs_submit_page_mbio(sbi, page, page->index, &fio);
+	alloced = page_idx - start;
+	readed = find_get_pages_contig(mapping, start, alloced, pages);
+	BUG_ON(alloced != readed);
+
+	for (page_idx = 0; page_idx < readed; page_idx++)
+		f2fs_submit_page_mbio(sbi, pages[page_idx],
+					pages[page_idx]->index, &fio);
 
 	f2fs_submit_merged_bio(sbi, META, READ);
 
-	return page_idx - start;
+	return readed;
 }
 
 int restore_node_summary(struct f2fs_sb_info *sbi,
@@ -1694,11 +1699,11 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
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
+	int i, index, last_offset, nrpages, err = 0;
 
 	/* scan the node segment */
 	last_offset = sbi->blocks_per_seg;
@@ -1709,29 +1714,31 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 		nrpages = min(last_offset - i, bio_blocks);
 
 		/* read ahead node pages */
-		nrpages = ra_sum_pages(sbi, &page_list, addr, nrpages);
+		nrpages = ra_sum_pages(sbi, pages, addr, nrpages);
 		if (!nrpages)
 			return -ENOMEM;
 
-		list_for_each_entry_safe(page, tmp, &page_list, lru) {
+		for (index = 0; index < nrpages; index++) {
 			if (err)
 				goto skip;
 
-			lock_page(page);
-			if (unlikely(!PageUptodate(page))) {
+			lock_page(pages[index]);
+			if (unlikely(!PageUptodate(pages[index]))) {
 				err = -EIO;
 			} else {
-				rn = F2FS_NODE(page);
+				rn = F2FS_NODE(pages[index]);
 				sum_entry->nid = rn->footer.nid;
 				sum_entry->version = 0;
 				sum_entry->ofs_in_node = 0;
 				sum_entry++;
 			}
-			unlock_page(page);
+			unlock_page(pages[index]);
 skip:
-			list_del(&page->lru);
-			__free_pages(page, 0);
+			page_cache_release(pages[index]);
 		}
+
+		invalidate_mapping_pages(inode->i_mapping, addr,
+							addr + nrpages);
 	}
 	return err;
 }
-- 
1.7.10.4


