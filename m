Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693Ab3LIFgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:36:46 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:13969 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3LIFgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:36:42 -0500
X-AuditID: cbfee61a-b7f796d000004313-d4-52a556e512fe
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH 3/3 V3] f2fs: introduce f2fs_cache_node_page() to
 add page into node_inode cache
Date: Mon, 09 Dec 2013 13:35:48 +0800
Message-id: <000a01cef4a0$9f2d64a0$dd882de0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac70n9mz0txnZc/tTOWEfp/VeuMSdw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jQd2nYUuDDGY9UrC4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+NS01+2gisiFVP2
	djI2MB4X6GLk5JAQMJFYfWIHO4QtJnHh3nq2LkYuDiGB6YwSxzcdgXJ+MEo8aDkGVsUmoCKx
	vOM/E4gtIqAoseH9BrA4s0CmxJzXk1lBbGGBXIlX2/YxgtgsAqoSdy+8A7N5BSwlmm5fYoGw
	BSV+TL7HAtGrJbF+53EmCFteYvOat8wQFylI7Dj7mhFil57EgTlboerFJTYeucUygVFgFpJR
	s5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBIfyM6kdjCsbLA4xCnAw
	KvHwrmBdGiTEmlhWXJl7iFGCg1lJhFfpxJIgId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0D
	hQTSE0tSs1NTC1KLYLJMHJxSDYyeOb082vsefv6+daYs84WjKtGH5X63F2/VVeU69S/PwMGs
	MO1QvcNFPp6jKQsPz066x/n8gcXzL4sETrrMi9V742CilWh9W2XLnPaqj9tig8NnvCn5HvL6
	JcfjZg6z2mCbh2KGxlNvOJf5nygvPn5UfW8z96I7TIkBnBrV53LfFez+sHKmSpgSS3FGoqEW
	c1FxIgA9C3WVYQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces f2fs_cache_node_page(), in this function, page which is
readed ahead will be copy to node_inode's mapping cache.
It will avoid rereading these node pages.

change log:
 o check validity of page by searching NAT suggested by Jaegeuk Kim.
 o add 'unlikely' for compiler optimization suggested by Jaegeuk Kim.

Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 099f06f..4c6da98 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1600,13 +1600,46 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
 	return 0;
 }
 
+/*
+ * f2fs_cache_node_page() check validaty of input page by searching NAT.
+ * Then, it will copy updated data of vaild page to node_inode cache.
+ */
+void f2fs_cache_node_page(struct f2fs_sb_info *sbi, struct page *page,
+						nid_t nid, block_t blkaddr)
+{
+	struct address_space *mapping = sbi->node_inode->i_mapping;
+	struct page *npage;
+	struct node_info ni;
+
+	get_node_info(sbi, nid, &ni);
+
+	if (ni.blk_addr != blkaddr)
+		return;
+
+	npage = grab_cache_page(mapping, nid);
+	if (unlikely(!npage))
+		return;
+
+	if (PageUptodate(npage)) {
+		f2fs_put_page(npage, 1);
+		return;
+	}
+
+	memcpy(page_address(npage), page_address(page), PAGE_CACHE_SIZE);
+
+	SetPageUptodate(npage);
+	f2fs_put_page(npage, 1);
+
+	return;
+}
+
 int restore_node_summary(struct f2fs_sb_info *sbi,
 			unsigned int segno, struct f2fs_summary_block *sum)
 {
 	struct f2fs_node *rn;
 	struct f2fs_summary *sum_entry;
 	struct page *page, *tmp;
-	block_t addr;
+	block_t addr, blkaddr;
 	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
 	int i, last_offset, nrpages, err = 0;
 	LIST_HEAD(page_list);
@@ -1624,6 +1657,7 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 		if (err)
 			return err;
 
+		blkaddr = addr;
 		list_for_each_entry_safe(page, tmp, &page_list, lru) {
 
 			lock_page(page);
@@ -1633,6 +1667,8 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 				sum_entry->version = 0;
 				sum_entry->ofs_in_node = 0;
 				sum_entry++;
+				f2fs_cache_node_page(sbi, page,
+					le32_to_cpu(rn->footer.nid), blkaddr);
 			} else {
 				err = -EIO;
 			}
@@ -1640,6 +1676,7 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 			list_del(&page->lru);
 			unlock_page(page);
 			__free_pages(page, 0);
+			blkaddr++;
 		}
 	}
 	return err;
-- 
1.7.9.5

