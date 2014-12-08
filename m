Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbaLHHDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:03:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24906 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbaLHHDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:03:43 -0500
X-AuditID: cbfee61a-f79c06d000004e71-97-54854d4d4b46
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 4/4] f2fs: avoid to ra unneeded blocks in recover flow
Date: Mon, 08 Dec 2014 15:02:52 +0800
Message-id: <001b01d012b5$18f786c0$4ae69440$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdASn+wYraURdvbLSjmQoJmm3Anegw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jAV1f39YQg+a1KhbX9jUyWTxZP4vZ
	4tIid4s9e0+yWFzeNYfNgdVj06pONo/dCz4zefRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG
	o4UzWApWyVZcan/F1MDYLNHFyMkhIWAiMefKZnYIW0ziwr31bF2MXBxCAosYJdrXnINyfjBK
	PJ3dxAJSxSagIrG84z8TiC0i4CUxaf8JsDizQKbEvaYZzCC2sECAxPJTD1m7GDk4WARUJb42
	VYGEeQUsJeY+vccMYQtK/Jh8D6pVS2LztiZWCFteYvOat8wQBylI7Dj7mhFkjIiAnsT+n54Q
	JeISG4/cYpnAKDALyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC
	Q/uZ1A7GlQ0WhxgFOBiVeHgXPGgJEWJNLCuuzD3EKMHBrCTC62nfGiLEm5JYWZValB9fVJqT
	WnyIUZqDRUmc98bN3BAhgfTEktTs1NSC1CKYLBMHp1QDo+y2p9vyL5s8SrKbFi/e5XpdavKS
	9JdJDfskNmZu7CqO5zXPCVNJf3Nppf2pE0WnHn48N9skqnN+cZS16ZdpC3qPvHh06ekdyYvN
	UjJGTzQnLSqecHfa3ViHT7cVf32acMUgc4b/0W8+F1au28n0XPHFV4ak7G9p9R+UmUxqOB/c
	fOne/eB0oYkSS3FGoqEWc1FxIgAOIvpXaQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To improve recovery speed, f2fs try to readahead many contiguous blocks in warm
node segment, but for most time, abnormal power-off do not occur frequently, so
when mount a normal power-off f2fs image, by contrary ra so many blocks and then
invalid them will hurt the performance of mount.
It's better to just ra the first next-block for normal condition.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c | 29 ++++++++++++++---------------
 fs/f2fs/f2fs.h       |  2 +-
 fs/f2fs/recovery.c   | 10 ++++++++--
 3 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index aa2a21c..5eb4d1a 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -72,21 +72,6 @@ out:
 	return page;
 }
 
-struct page *get_meta_page_ra(struct f2fs_sb_info *sbi, pgoff_t index)
-{
-	bool readahead = false;
-	struct page *page;
-
-	page = find_get_page(META_MAPPING(sbi), index);
-	if (!page || (page && !PageUptodate(page)))
-		readahead = true;
-	f2fs_put_page(page, 0);
-
-	if (readahead)
-		ra_meta_pages(sbi, index, MAX_BIO_BLOCKS(sbi), META_POR);
-	return get_meta_page(sbi, index);
-}
-
 static inline bool is_valid_blkaddr(struct f2fs_sb_info *sbi,
 						block_t blkaddr, int type)
 {
@@ -181,6 +166,20 @@ out:
 	return blkno - start;
 }
 
+void ra_meta_pages_cond(struct f2fs_sb_info *sbi, pgoff_t index)
+{
+	struct page *page;
+	bool readahead = false;
+
+	page = find_get_page(META_MAPPING(sbi), index);
+	if (!page || (page && !PageUptodate(page)))
+		readahead = true;
+	f2fs_put_page(page, 0);
+
+	if (readahead)
+		ra_meta_pages(sbi, index, MAX_BIO_BLOCKS(sbi), META_POR);
+}
+
 static int f2fs_write_meta_page(struct page *page,
 				struct writeback_control *wbc)
 {
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index fc88e8a..b465896 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1423,8 +1423,8 @@ void destroy_segment_manager_caches(void);
  */
 struct page *grab_meta_page(struct f2fs_sb_info *, pgoff_t);
 struct page *get_meta_page(struct f2fs_sb_info *, pgoff_t);
-struct page *get_meta_page_ra(struct f2fs_sb_info *, pgoff_t);
 int ra_meta_pages(struct f2fs_sb_info *, block_t, int, int);
+void ra_meta_pages_cond(struct f2fs_sb_info *, pgoff_t);
 long sync_meta_pages(struct f2fs_sb_info *, enum page_type, long);
 void add_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
 void remove_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 9a93a6e..9160a37 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -170,13 +170,15 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 	curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
 	blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
 
+	ra_meta_pages(sbi, blkaddr, 1, META_POR);
+
 	while (1) {
 		struct fsync_inode_entry *entry;
 
 		if (blkaddr < MAIN_BLKADDR(sbi) || blkaddr >= MAX_BLKADDR(sbi))
 			return 0;
 
-		page = get_meta_page_ra(sbi, blkaddr);
+		page = get_meta_page(sbi, blkaddr);
 
 		if (cp_ver != cpver_of_node(page))
 			break;
@@ -227,6 +229,8 @@ next:
 		/* check next segment */
 		blkaddr = next_blkaddr_of_node(page);
 		f2fs_put_page(page, 1);
+
+		ra_meta_pages_cond(sbi, blkaddr);
 	}
 	f2fs_put_page(page, 1);
 	return err;
@@ -436,7 +440,9 @@ static int recover_data(struct f2fs_sb_info *sbi,
 		if (blkaddr < MAIN_BLKADDR(sbi) || blkaddr >= MAX_BLKADDR(sbi))
 			break;
 
-		page = get_meta_page_ra(sbi, blkaddr);
+		ra_meta_pages_cond(sbi, blkaddr);
+
+		page = get_meta_page(sbi, blkaddr);
 
 		if (cp_ver != cpver_of_node(page)) {
 			f2fs_put_page(page, 1);
-- 
2.1.2


