Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab3DYCoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 22:44:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22357 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758473Ab3DYCoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 22:44:19 -0400
X-AuditID: cbfee690-b7f136d000000fea-2a-517898823de3
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: give a chance to merge IOs by IO scheduler
Date: Thu, 25 Apr 2013 11:43:05 +0900
Message-id: <1366857785-17117-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zQ92mGRWBBnvXcllc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXH60WqWgpcOFf13
	mxkbGFtNuhg5OSQETCQe/+tkgbDFJC7cW8/WxcjFISSwjFFi2dfdzDBFZ+ZeYoRITGeUOHWt
	nRXCaWOSODhjEVAVBwebgLbE5v0GIA0iAswSC6aeB2tgFpjAKPF/0XuwFcICjhK3D89gB6ln
	EVCVeHPCGyTMK+AusfDRIkaIZboSq/8/ZwfplRB4zCaxZsE7VpAEi4CAxLfJh1hAeiUEZCU2
	HYA6TlLi4IobLBMYBRcwMqxiFE0tSC4oTkovMtErTswtLs1L10vOz93ECAnBCTsY7x2wPsSY
	DDRuIrOUaHI+MITzSuINjc2MLExNTI2NzC3NSBNWEudVb7EOFBJITyxJzU5NLUgtii8qzUkt
	PsTIxMEp1cC47phKePuZd5sXPrnpNTMmbMmcc5UbT1z7aTfb+W6D2RGfRX36lemZ/lyXJ1+6
	UGPAsnp/fOm6zvV/4/WO5Fo7+Kut+xJ5KcK9bGbzZIcjaZx7vc+EZVXFNF0WnHCBa+LW3iuT
	UrqYnrnMWXw87XOe4F3/3gNTXgf+qRee5yqU/VmresXGres3K7EUZyQaajEXFScCAGxssY9X	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd2mGRWBBgfOslhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hx+tFqloKXDhX9d5sZGxhbTboYOTkkBEwkzsy9xAhhi0lcuLeerYuRi0NI
	YDqjxKlr7awQThuTxMEZi5i7GDk42AS0JTbvNwBpEBFgllgw9TwjSA2zwARGif+L3rOAJIQF
	HCVuH57BDlLPIqAq8eaEN0iYV8BdYuGjRVDLdCVW/3/OPoGRewEjwypG0dSC5ILipPRcQ73i
	xNzi0rx0veT83E2M4AB/JrWDcWWDxSFGAQ5GJR5egVflgUKsiWXFlbmHGCU4mJVEeJc5VAQK
	8aYkVlalFuXHF5XmpBYfYkwGWj6RWUo0OR8YfXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4U
	EkhPLEnNTk0tSC2C2cLEwSnVwDh1Un2b8eFHEjJ8tVO+N71vudK6x9BKepE6b+bBVh3zAyeS
	mrJWn/rKzrAyw7129boDnInCn01r+K3f7nzBsszhu1OGu/S6G1EMB+5YrVTerLPm8sIVUpfW
	VtiExNRVGJ2sO3ZtWbuob9qUB0/XHppunxeWc4rD8dfMNV16E+XkZkyNjGF84qDEUpyRaKjF
	XFScCADmglEWtAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, background GC submits many 4KB read requests to load victim blocks
and/or its (i)node blocks.

...
f2fs_gc : f2fs_readpage: ino = 1, page_index = 0xb61, blkaddr = 0x3b964ed
f2fs_gc : block_rq_complete: 8,16 R () 499854968 + 8 [0]
f2fs_gc : f2fs_readpage: ino = 1, page_index = 0xb6f, blkaddr = 0x3b964ee
f2fs_gc : block_rq_complete: 8,16 R () 499854976 + 8 [0]
f2fs_gc : f2fs_readpage: ino = 1, page_index = 0xb79, blkaddr = 0x3b964ef
f2fs_gc : block_rq_complete: 8,16 R () 499854984 + 8 [0]
...

However, by the fact that many IOs are sequential, we can give a chance to merge
the IOs by IO scheduler.
In order to do that, let's use blk_plug.

...
f2fs_gc : f2fs_iget: ino = 143
f2fs_gc : f2fs_readpage: ino = 143, page_index = 0x1c6, blkaddr = 0x2e6ee
f2fs_gc : f2fs_iget: ino = 143
f2fs_gc : f2fs_readpage: ino = 143, page_index = 0x1c7, blkaddr = 0x2e6ef
<idle> : block_rq_complete: 8,16 R () 1519616 + 8 [0]
<idle> : block_rq_complete: 8,16 R () 1519848 + 8 [0]
<idle> : block_rq_complete: 8,16 R () 1520432 + 96 [0]
<idle> : block_rq_complete: 8,16 R () 1520536 + 104 [0]
<idle> : block_rq_complete: 8,16 R () 1521008 + 112 [0]
<idle> : block_rq_complete: 8,16 R () 1521440 + 152 [0]
<idle> : block_rq_complete: 8,16 R () 1521688 + 144 [0]
<idle> : block_rq_complete: 8,16 R () 1522128 + 192 [0]
<idle> : block_rq_complete: 8,16 R () 1523256 + 328 [0]
...

Note that this issue should be addressed in checkpoint, and some readahead
flows too.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c |  5 +++++
 fs/f2fs/data.c       | 15 +++++++++------
 fs/f2fs/dir.c        |  2 +-
 fs/f2fs/f2fs.h       |  2 +-
 fs/f2fs/file.c       |  2 +-
 fs/f2fs/gc.c         | 11 ++++++++++-
 fs/f2fs/node.c       |  9 +++++++++
 7 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index f54b83b..590ea50 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -549,6 +549,10 @@ static void block_operations(struct f2fs_sb_info *sbi)
 		.nr_to_write = LONG_MAX,
 		.for_reclaim = 0,
 	};
+	struct blk_plug plug;
+
+	blk_start_plug(&plug);
+
 retry_flush_dents:
 	mutex_lock_all(sbi);
 
@@ -571,6 +575,7 @@ retry_flush_nodes:
 		sync_node_pages(sbi, 0, &wbc);
 		goto retry_flush_nodes;
 	}
+	blk_finish_plug(&plug);
 }
 
 static void unblock_operations(struct f2fs_sb_info *sbi)
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 1220b5c..eba7e84 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -172,7 +172,7 @@ end_update:
 	return;
 }
 
-struct page *find_data_page(struct inode *inode, pgoff_t index)
+struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct address_space *mapping = inode->i_mapping;
@@ -207,11 +207,14 @@ struct page *find_data_page(struct inode *inode, pgoff_t index)
 		return page;
 	}
 
-	err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
-	wait_on_page_locked(page);
-	if (!PageUptodate(page)) {
-		f2fs_put_page(page, 0);
-		return ERR_PTR(-EIO);
+	err = f2fs_readpage(sbi, page, dn.data_blkaddr,
+					sync ? READ_SYNC : READA);
+	if (sync) {
+		wait_on_page_locked(page);
+		if (!PageUptodate(page)) {
+			f2fs_put_page(page, 0);
+			return ERR_PTR(-EIO);
+		}
 	}
 	return page;
 }
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index cd3342d..3ddb1bc 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -148,7 +148,7 @@ static struct f2fs_dir_entry *find_in_level(struct inode *dir,
 
 	for (; bidx < end_block; bidx++) {
 		/* no need to allocate new dentry pages to all the indices */
-		dentry_page = find_data_page(dir, bidx);
+		dentry_page = find_data_page(dir, bidx, true);
 		if (IS_ERR(dentry_page)) {
 			room = true;
 			continue;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 06cc75c..6283c8d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1023,7 +1023,7 @@ void destroy_checkpoint_caches(void);
  */
 int reserve_new_block(struct dnode_of_data *);
 void update_extent_cache(block_t, struct dnode_of_data *);
-struct page *find_data_page(struct inode *, pgoff_t);
+struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
 struct page *get_new_data_page(struct inode *, pgoff_t, bool);
 int f2fs_readpage(struct f2fs_sb_info *, struct page *, block_t, int);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 0e56db2..9dfcdab 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -212,7 +212,7 @@ static void truncate_partial_data_page(struct inode *inode, u64 from)
 	if (!offset)
 		return;
 
-	page = find_data_page(inode, from >> PAGE_CACHE_SHIFT);
+	page = find_data_page(inode, from >> PAGE_CACHE_SHIFT, false);
 	if (IS_ERR(page))
 		return;
 
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 1ca3324..ad67306 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -389,6 +389,7 @@ static void gc_node_segment(struct f2fs_sb_info *sbi,
 
 next_step:
 	entry = sum;
+
 	for (off = 0; off < sbi->blocks_per_seg; off++, entry++) {
 		nid_t nid = le32_to_cpu(entry->nid);
 		struct page *node_page;
@@ -420,6 +421,7 @@ next_step:
 		f2fs_put_page(node_page, 1);
 		stat_inc_node_blk_count(sbi, 1);
 	}
+
 	if (initial) {
 		initial = false;
 		goto next_step;
@@ -548,6 +550,7 @@ static void gc_data_segment(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 
 next_step:
 	entry = sum;
+
 	for (off = 0; off < sbi->blocks_per_seg; off++, entry++) {
 		struct page *data_page;
 		struct inode *inode;
@@ -585,7 +588,7 @@ next_step:
 				continue;
 
 			data_page = find_data_page(inode,
-					start_bidx + ofs_in_node);
+					start_bidx + ofs_in_node, false);
 			if (IS_ERR(data_page))
 				goto next_iput;
 
@@ -606,6 +609,7 @@ next_step:
 next_iput:
 		iput(inode);
 	}
+
 	if (++phase < 4)
 		goto next_step;
 
@@ -639,12 +643,15 @@ static void do_garbage_collect(struct f2fs_sb_info *sbi, unsigned int segno,
 {
 	struct page *sum_page;
 	struct f2fs_summary_block *sum;
+	struct blk_plug plug;
 
 	/* read segment summary of victim */
 	sum_page = get_sum_page(sbi, segno);
 	if (IS_ERR(sum_page))
 		return;
 
+	blk_start_plug(&plug);
+
 	sum = page_address(sum_page);
 
 	switch (GET_SUM_TYPE((&sum->footer))) {
@@ -655,6 +662,8 @@ static void do_garbage_collect(struct f2fs_sb_info *sbi, unsigned int segno,
 		gc_data_segment(sbi, sum->entries, ilist, segno, gc_type);
 		break;
 	}
+	blk_finish_plug(&plug);
+
 	stat_inc_seg_count(sbi, GET_SUM_TYPE((&sum->footer)));
 	stat_inc_call_count(sbi->stat_info);
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 5a82550..a0aa044 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -89,10 +89,13 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
 {
 	struct address_space *mapping = sbi->meta_inode->i_mapping;
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
+	struct blk_plug plug;
 	struct page *page;
 	pgoff_t index;
 	int i;
 
+	blk_start_plug(&plug);
+
 	for (i = 0; i < FREE_NID_PAGES; i++, nid += NAT_ENTRY_PER_BLOCK) {
 		if (nid >= nm_i->max_nid)
 			nid = 0;
@@ -110,6 +113,7 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
 
 		f2fs_put_page(page, 0);
 	}
+	blk_finish_plug(&plug);
 }
 
 static struct nat_entry *__lookup_nat_cache(struct f2fs_nm_info *nm_i, nid_t n)
@@ -942,6 +946,7 @@ struct page *get_node_page_ra(struct page *parent, int start)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(parent->mapping->host->i_sb);
 	struct address_space *mapping = sbi->node_inode->i_mapping;
+	struct blk_plug plug;
 	struct page *page;
 	int err, i, end;
 	nid_t nid;
@@ -961,6 +966,8 @@ struct page *get_node_page_ra(struct page *parent, int start)
 	else if (err == LOCKED_PAGE)
 		goto page_hit;
 
+	blk_start_plug(&plug);
+
 	/* Then, try readahead for siblings of the desired node */
 	end = start + MAX_RA_NODE;
 	end = min(end, NIDS_PER_BLOCK);
@@ -971,6 +978,8 @@ struct page *get_node_page_ra(struct page *parent, int start)
 		ra_node_page(sbi, nid);
 	}
 
+	blk_finish_plug(&plug);
+
 	lock_page(page);
 
 page_hit:
-- 
1.8.1.3.566.gaa39828

