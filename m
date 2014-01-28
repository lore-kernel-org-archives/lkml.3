Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaA1C30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 21:29:26 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35607 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbaA1C3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 21:29:24 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-04-52e71602787e
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH] f2fs: introduce ra_meta_pages to readahead
 CP/NAT/SIT pages
Date: Tue, 28 Jan 2014 10:28:32 +0800
Message-id: <000001cf1bd0$bec85020$3c58f060$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac8aNh+BaX7Ab4LkTwm4r2aNOLIQYA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jQV0msedBBkdP8Ftc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlTFt8nK2gp3mFX/W
	n2ZvYFyt08XIySEhYCJx7847RghbTOLCvfVsXYxcHEIC0xklula9ZYdwfjBKTP36jg2kik1A
	RWJ5x38mEFtEQFFiw/sN7CA2s0CmxJzXk1lBbGGBSInmJ9tZQGwWAVWJ1/3/wGp4BSwldl78
	yAphC0r8mHyPBaJXS2L9zuNMELa8xOY1b5khLlKQ2HH2NSPELj2J3mkbGSFqxCU2HrnFMoFR
	YBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSH8jOpHYwrGywO
	MQpwMCrx8HZ0PgsSYk0sK67MPcQowcGsJMJ7dgpQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+B
	VutAIYH0xJLU7NTUgtQimCwTB6dUA6Pesi3Lv51aYbRgZ/Z1Bc5E/QUCn04cdWxyziqPl9o7
	6+X+ZjVfV6UqJu9buvuaPocuCjhv+JJ7kUTv6/ceUsseTNO45ZI613RD7unenfufy6rnb+VR
	v7+sNagiU1PsyCuRBUbn3m2XSbzN9s55acjMLx9EtzXI/D3+J6Lg3VrX32ey9TbVXXBWYinO
	SDTUYi4qTgQA49bHP2ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch help us to cleanup the readahead code by merging ra_{sit,nat}_pages
function into ra_meta_pages.
Additionally the new function is used to readahead cp block in
recover_orphan_inodes.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/f2fs.h       |   10 +++++++
 fs/f2fs/node.c       |   38 +-----------------------
 fs/f2fs/segment.c    |   43 +---------------------------
 4 files changed, 90 insertions(+), 79 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 293d048..a1986c3 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -75,6 +75,82 @@ out:
 	return page;
 }
 
+inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
+{
+	switch (type) {
+	case META_NAT:
+		return NM_I(sbi)->max_nid / NAT_ENTRY_PER_BLOCK;
+	case META_SIT:
+		return SIT_BLK_CNT(sbi);
+	case META_CP:
+		return 0;
+	default:
+		BUG();
+	}
+}
+
+/*
+ * Readahead CP/NAT/SIT pages
+ */
+int ra_meta_pages(struct f2fs_sb_info *sbi, int start, int nrpages, int type)
+{
+	struct address_space *mapping = sbi->meta_inode->i_mapping;
+	struct page *page;
+	block_t blk_addr, prev_blk_addr = 0;
+	int blkno = start;
+	int max_blks = get_max_meta_blks(sbi, type);
+
+	struct f2fs_io_info fio = {
+		.type = META,
+		.rw = READ_SYNC | REQ_META | REQ_PRIO
+	};
+
+	for (blkno = start; blkno < start + nrpages; blkno++) {
+
+		switch (type) {
+		case META_NAT:
+			/* get nat block addr */
+			if (unlikely(blkno >= max_blks))
+				blkno = 0;
+			blk_addr = current_nat_addr(sbi,
+					blkno * NAT_ENTRY_PER_BLOCK);
+			break;
+		case META_SIT:
+			/* get sit block addr */
+			if (unlikely(blkno >= max_blks))
+				goto out;
+			blk_addr = current_sit_addr(sbi,
+					blkno * SIT_ENTRY_PER_BLOCK);
+			if (blkno != start && prev_blk_addr + 1 != blk_addr)
+				goto out;
+			prev_blk_addr = blk_addr;
+			break;
+		case META_CP:
+			/* get cp block addr */
+			blk_addr = blkno;
+			break;
+		default:
+			BUG();
+		}
+
+		page = grab_cache_page(mapping, blk_addr);
+		if (!page)
+			continue;
+		if (PageUptodate(page)) {
+			mark_page_accessed(page);
+			f2fs_put_page(page, 1);
+			continue;
+		}
+
+		f2fs_submit_page_mbio(sbi, page, blk_addr, &fio);
+		mark_page_accessed(page);
+		f2fs_put_page(page, 0);
+	}
+out:
+	f2fs_submit_merged_bio(sbi, META, READ);
+	return blkno - start;
+}
+
 static int f2fs_write_meta_page(struct page *page,
 				struct writeback_control *wbc)
 {
@@ -285,6 +361,8 @@ void recover_orphan_inodes(struct f2fs_sb_info *sbi)
 	start_blk = __start_cp_addr(sbi) + 1;
 	orphan_blkaddr = __start_sum_addr(sbi) - 1;
 
+	ra_meta_pages(sbi, start_blk, orphan_blkaddr, META_CP);
+
 	for (i = 0; i < orphan_blkaddr; i++) {
 		struct page *page = get_meta_page(sbi, start_blk + i);
 		struct f2fs_orphan_block *orphan_blk;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index af51a0b..69ffc1b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -88,6 +88,15 @@ enum {
 	SIT_BITMAP
 };
 
+/*
+ * For CP/NAT/SIT readahead
+ */
+enum {
+	META_CP,
+	META_NAT,
+	META_SIT
+};
+
 /* for the list of orphan inodes */
 struct orphan_inode_entry {
 	struct list_head list;	/* list head */
@@ -1158,6 +1167,7 @@ void destroy_segment_manager_caches(void);
  */
 struct page *grab_meta_page(struct f2fs_sb_info *, pgoff_t);
 struct page *get_meta_page(struct f2fs_sb_info *, pgoff_t);
+int ra_meta_pages(struct f2fs_sb_info *, int, int, int);
 long sync_meta_pages(struct f2fs_sb_info *, enum page_type, long);
 int acquire_orphan_inode(struct f2fs_sb_info *);
 void release_orphan_inode(struct f2fs_sb_info *);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index b0649b7..2f7ae6f 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -82,42 +82,6 @@ static struct page *get_next_nat_page(struct f2fs_sb_info *sbi, nid_t nid)
 	return dst_page;
 }
 
-/*
- * Readahead NAT pages
- */
-static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
-{
-	struct address_space *mapping = META_MAPPING(sbi);
-	struct f2fs_nm_info *nm_i = NM_I(sbi);
-	struct page *page;
-	pgoff_t index;
-	int i;
-	struct f2fs_io_info fio = {
-		.type = META,
-		.rw = READ_SYNC | REQ_META | REQ_PRIO
-	};
-
-
-	for (i = 0; i < FREE_NID_PAGES; i++, nid += NAT_ENTRY_PER_BLOCK) {
-		if (unlikely(nid >= nm_i->max_nid))
-			nid = 0;
-		index = current_nat_addr(sbi, nid);
-
-		page = grab_cache_page(mapping, index);
-		if (!page)
-			continue;
-		if (PageUptodate(page)) {
-			mark_page_accessed(page);
-			f2fs_put_page(page, 1);
-			continue;
-		}
-		f2fs_submit_page_mbio(sbi, page, index, &fio);
-		mark_page_accessed(page);
-		f2fs_put_page(page, 0);
-	}
-	f2fs_submit_merged_bio(sbi, META, READ);
-}
-
 static struct nat_entry *__lookup_nat_cache(struct f2fs_nm_info *nm_i, nid_t n)
 {
 	return radix_tree_lookup(&nm_i->nat_root, n);
@@ -1413,7 +1377,7 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
 		return;
 
 	/* readahead nat pages to be scanned */
-	ra_nat_pages(sbi, nid);
+	ra_meta_pages(sbi, NAT_BLOCK_OFFSET(nid), FREE_NID_PAGES, META_NAT);
 
 	while (1) {
 		struct page *page = get_current_nat_page(sbi, nid);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 7caac5f..4c2b35b 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1583,47 +1583,6 @@ static int build_curseg(struct f2fs_sb_info *sbi)
 	return restore_curseg_summaries(sbi);
 }
 
-static int ra_sit_pages(struct f2fs_sb_info *sbi, int start, int nrpages)
-{
-	struct address_space *mapping = META_MAPPING(sbi);
-	struct page *page;
-	block_t blk_addr, prev_blk_addr = 0;
-	int sit_blk_cnt = SIT_BLK_CNT(sbi);
-	int blkno = start;
-	struct f2fs_io_info fio = {
-		.type = META,
-		.rw = READ_SYNC | REQ_META | REQ_PRIO
-	};
-
-	for (; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++) {
-
-		blk_addr = current_sit_addr(sbi, blkno * SIT_ENTRY_PER_BLOCK);
-
-		if (blkno != start && prev_blk_addr + 1 != blk_addr)
-			break;
-		prev_blk_addr = blk_addr;
-repeat:
-		page = grab_cache_page(mapping, blk_addr);
-		if (!page) {
-			cond_resched();
-			goto repeat;
-		}
-		if (PageUptodate(page)) {
-			mark_page_accessed(page);
-			f2fs_put_page(page, 1);
-			continue;
-		}
-
-		f2fs_submit_page_mbio(sbi, page, blk_addr, &fio);
-
-		mark_page_accessed(page);
-		f2fs_put_page(page, 0);
-	}
-
-	f2fs_submit_merged_bio(sbi, META, READ);
-	return blkno - start;
-}
-
 static void build_sit_entries(struct f2fs_sb_info *sbi)
 {
 	struct sit_info *sit_i = SIT_I(sbi);
@@ -1635,7 +1594,7 @@ static void build_sit_entries(struct f2fs_sb_info *sbi)
 	int nrpages = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
 
 	do {
-		readed = ra_sit_pages(sbi, start_blk, nrpages);
+		readed = ra_meta_pages(sbi, start_blk, nrpages, META_SIT);
 
 		start = start_blk * sit_i->sents_per_block;
 		end = (start_blk + readed) * sit_i->sents_per_block;
-- 
1.7.9.5

