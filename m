Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3KVHt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 02:49:59 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58291 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3KVHt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 02:49:57 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-a2-528f0ca3e846
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH] f2fs: readahead contiguous pages for
 restore_node_summary
Date: Fri, 22 Nov 2013 15:48:54 +0800
Message-id: <000101cee757$6f3b4790$4db1d6b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7nVThOK8MIrc/MQQSG0VJCDOm6QA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQd3FPP1BBrM3aFtc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxryHwgWn
	pCrOzVzP2sD4UaSLkZNDQsBEYtr+6WwQtpjEhXvrgWwuDiGB6YwSjbvvsEM4Pxglpj5czgxS
	xSagIrG84z8TiC0ioCix4f0GsCJmgRmMEofn/mMFSQgLhEvsvt4G1sAioCrR9uMcC4jNK2Ap
	8fL8S2YIW1Dix+R7YHFmAQ2J/kUb2CBseYnNa94yQ5ykILHj7GtGiGV6ElNeLIGqF5fYeOQW
	ywRGgVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc1M+kdzCu
	arA4xCjAwajEw7vDsi9IiDWxrLgy9xCjBAezkgjvr6tAId6UxMqq1KL8+KLSnNTiQ4zSHCxK
	4rwHW60DhQTSE0tSs1NTC1KLYLJMHJxSDYwznyy8uZf5xDX78E+74960CDiZ7tXZ98hDY9LO
	i98VNWPeMNW8T/275FZU12NTg6P7xZZOza3avC316HdpY61rD8UaypzKL2quO/K1fcVd1UCL
	p4U3chcxf/7K57Q4XVWkNHROhpd9+GHOox1b1Dl3zFgtaucS9EdVnDFAyfTJ8sPMVnFZD32V
	WIozEg21mIuKEwEoXUwsZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If cp has no CP_UMOUNT_FLAG, we will read all pages in whole node segment 
one by one, it makes low performance. So let's merge contiguous pages and 
readahead for better performance.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c |   89 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 63 insertions(+), 26 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 4ac4150..81e704a 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1572,47 +1572,84 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
 	return 0;
 }
 
+/*
+ * ra_sum_pages() merge contiguous pages into one bio and submit.
+ * these pre-readed pages are linked in pages list.
+ */
+static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
+				int start, int nrpages)
+{
+	struct page *page;
+	int page_idx = start;
+
+	for (; page_idx < start + nrpages; page_idx++) {
+		/* alloc temporal page for read node summary info*/
+		page = alloc_page(GFP_NOFS | __GFP_ZERO);
+		if (!page) {
+			struct page *tmp;
+			list_for_each_entry_safe(page, tmp, pages, lru) {
+				list_del(&page->lru);
+				unlock_page(page);
+				__free_pages(page, 0);
+			}
+			return -ENOMEM;
+		}
+
+		lock_page(page);
+		page->index = page_idx;
+		list_add_tail(&page->lru, pages);
+	}
+
+	list_for_each_entry(page, pages, lru)
+		submit_read_page(sbi, page, page->index, READ_SYNC);
+
+	f2fs_submit_read_bio(sbi, READ_SYNC);
+	return 0;
+}
+
 int restore_node_summary(struct f2fs_sb_info *sbi,
 			unsigned int segno, struct f2fs_summary_block *sum)
 {
 	struct f2fs_node *rn;
 	struct f2fs_summary *sum_entry;
-	struct page *page;
+	struct page *page, *tmp;
 	block_t addr;
-	int i, last_offset;
-
-	/* alloc temporal page for read node */
-	page = alloc_page(GFP_NOFS | __GFP_ZERO);
-	if (!page)
-		return -ENOMEM;
-	lock_page(page);
+	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+	int i, last_offset, nrpages, err = 0;
+	LIST_HEAD(page_list);
 
 	/* scan the node segment */
 	last_offset = sbi->blocks_per_seg;
 	addr = START_BLOCK(sbi, segno);
 	sum_entry = &sum->entries[0];
 
-	for (i = 0; i < last_offset; i++, sum_entry++) {
-		/*
-		 * In order to read next node page,
-		 * we must clear PageUptodate flag.
-		 */
-		ClearPageUptodate(page);
+	for (i = 0; i < last_offset; i += nrpages, addr += nrpages) {
 
-		if (f2fs_readpage(sbi, page, addr, READ_SYNC))
-			goto out;
+		nrpages = min(last_offset - i, bio_blocks);
+		/* read ahead node pages */
+		err = ra_sum_pages(sbi, &page_list, addr, nrpages);
+		if (err)
+			return err;
 
-		lock_page(page);
-		rn = F2FS_NODE(page);
-		sum_entry->nid = rn->footer.nid;
-		sum_entry->version = 0;
-		sum_entry->ofs_in_node = 0;
-		addr++;
+		list_for_each_entry_safe(page, tmp, &page_list, lru) {
+
+			lock_page(page);
+			if(PageUptodate(page)) {
+				rn = F2FS_NODE(page);
+				sum_entry->nid = rn->footer.nid;
+				sum_entry->version = 0;
+				sum_entry->ofs_in_node = 0;
+				sum_entry++;
+			} else {
+				err = -EIO;
+			}
+
+			list_del(&page->lru);
+			unlock_page(page);
+			__free_pages(page, 0);
+		}
 	}
-	unlock_page(page);
-out:
-	__free_pages(page, 0);
-	return 0;
+	return err;
 }
 
 static bool flush_nats_in_journal(struct f2fs_sb_info *sbi)
-- 
1.7.9.5

