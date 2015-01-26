Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbbAZMXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:23:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63278 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbbAZMXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:23:42 -0500
X-AuditID: cbfee61a-f79c06d000004e71-29-54c631ccf02f
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] f2fs: make truncate_inline_date static
Date: Mon, 26 Jan 2015 20:22:55 +0800
Message-id: <008701d03962$eafecdd0$c0fc6970$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdA5YYnNYACHhsWpSBijmYuBtQPzjA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQd0zhsdCDM4cNrW4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxo25M9kL
	jopVtP04ytrA+FGoi5GTQ0LARGLD/zlsELaYxIV768FsIYHpjBKbHql0MXIB2T8YJXav72cB
	SbAJqEgs7/jPBGKLCHhJTNp/AizOLOAh0djxnRXEFhawllgwcxJYDYuAqkTLkz4wm1fAUuL+
	w49sELagxI/J96B6tSTW7zzOBGHLS2xe85YZ4iAFiR1nXzNC7NKTuLZ8IVSNuMTGI7dYJjAK
	zEIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCQfia1g3Flg8Uh
	RgEORiUe3obmoyFCrIllxZW5hxglOJiVRHgd1Y+FCPGmJFZWpRblxxeV5qQWH2KU5mBREudV
	sm8LERJITyxJzU5NLUgtgskycXBKNTDuzpksl7rxzqRsFpW7bW8dt768bauUncr18tmOla5P
	Sz/Pt1vYfp0tz2NzjWG11Y2DrqZ2p94Vh5Q3Fu5pThNk1/+TvW+1w6nJrm9fM2wurPLcLTz/
	5Lzd/nMiMn4yibYe1UjcceXeJiV7geCSGZfVRIpu+//4p3rfe91Dsalfz++4v/29QMBlJZbi
	jERDLeai4kQAQFG6J2UCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. make truncate_inline_date static;
2. remove parameter @from of truncate_inline_date as callers only pass zero.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h   |  1 -
 fs/f2fs/inline.c | 25 +++++++++----------------
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1bd1752..5f47496 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1645,7 +1645,6 @@ int f2fs_read_inline_data(struct inode *, struct page *);
 int f2fs_convert_inline_page(struct dnode_of_data *, struct page *);
 int f2fs_convert_inline_inode(struct inode *);
 int f2fs_write_inline_data(struct inode *, struct page *);
-void truncate_inline_data(struct page *, u64);
 bool recover_inline_data(struct inode *, struct page *);
 struct f2fs_dir_entry *find_in_inline_dir(struct inode *, struct qstr *,
 							struct page **);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index fa2aa2f..1484c00 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -50,6 +50,12 @@ void read_inline_data(struct page *page, struct page *ipage)
 	SetPageUptodate(page);
 }
 
+static void truncate_inline_data(struct page *ipage)
+{
+	f2fs_wait_on_page_writeback(ipage, NODE);
+	memset(inline_data_addr(ipage), 0, MAX_INLINE_DATA);
+}
+
 int f2fs_read_inline_data(struct inode *inode, struct page *page)
 {
 	struct page *ipage;
@@ -125,7 +131,7 @@ no_update:
 	set_inode_flag(F2FS_I(dn->inode), FI_APPEND_WRITE);
 
 	/* clear inline data and flag after data writeback */
-	truncate_inline_data(dn->inode_page, 0);
+	truncate_inline_data(dn->inode_page);
 clear_out:
 	stat_dec_inline_inode(dn->inode);
 	f2fs_clear_inline_inode(dn->inode);
@@ -198,19 +204,6 @@ int f2fs_write_inline_data(struct inode *inode, struct page *page)
 	return 0;
 }
 
-void truncate_inline_data(struct page *ipage, u64 from)
-{
-	void *addr;
-
-	if (from >= MAX_INLINE_DATA)
-		return;
-
-	f2fs_wait_on_page_writeback(ipage, NODE);
-
-	addr = inline_data_addr(ipage);
-	memset(addr + from, 0, MAX_INLINE_DATA - from);
-}
-
 bool recover_inline_data(struct inode *inode, struct page *npage)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
@@ -252,7 +245,7 @@ process_inline:
 	if (f2fs_has_inline_data(inode)) {
 		ipage = get_node_page(sbi, inode->i_ino);
 		f2fs_bug_on(sbi, IS_ERR(ipage));
-		truncate_inline_data(ipage, 0);
+		truncate_inline_data(ipage);
 		f2fs_clear_inline_inode(inode);
 		update_inode(inode, ipage);
 		f2fs_put_page(ipage, 1);
@@ -370,7 +363,7 @@ static int f2fs_convert_inline_dir(struct inode *dir, struct page *ipage,
 	set_page_dirty(page);
 
 	/* clear inline dir and flag after data writeback */
-	truncate_inline_data(ipage, 0);
+	truncate_inline_data(ipage);
 
 	stat_dec_inline_dir(dir);
 	clear_inode_flag(F2FS_I(dir), FI_INLINE_DENTRY);
-- 
2.2.2


