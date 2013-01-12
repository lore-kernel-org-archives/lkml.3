Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3ALFmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 00:42:17 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53960 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3ALFmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 00:42:13 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 4/4] f2fs: add blk plugging support in f2fs
Date: Sat, 12 Jan 2013 14:42:03 +0900
Message-Id: <1357969323-9396-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

With f2fs having different writepages support for data, node and metapages.
It will not be covered under the generic blk plug support.
So,
1) modified the writepages for data pages.
2) Added blk plugging in node/metapages.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/checkpoint.c |    3 +++
 fs/f2fs/data.c       |   14 +++++++++++++-
 fs/f2fs/node.c       |    4 +++-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 448f728..127a904 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -129,10 +129,12 @@ long sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 	struct writeback_control wbc = {
 		.for_reclaim = 0,
 	};
+	struct blk_plug plug;
 
 	trace_f2fs_sync_pages(sbi->sb, type, nr_to_write);
 	pagevec_init(&pvec, 0);
 
+	blk_start_plug(&plug);
 	while (index <= end) {
 		int i, nr_pages;
 		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
@@ -158,6 +160,7 @@ long sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 	if (nwritten)
 		f2fs_submit_bio(sbi, type, nr_to_write == LONG_MAX);
 
+	blk_finish_plug(&plug);
 	return nwritten;
 }
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 1d7dbb4..5203a5d 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -558,6 +558,15 @@ redirty_out:
 
 #define MAX_DESIRED_PAGES_WP	4096
 
+static int __f2fs_writepage(struct page *page, struct writeback_control *wbc,
+			void *data)
+{
+	struct address_space *mapping = data;
+	int ret = mapping->a_ops->writepage(page, wbc);
+	mapping_set_error(mapping, ret);
+	return ret;
+}
+
 static int f2fs_write_data_pages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
@@ -565,6 +574,7 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	int ret;
 	long excess_nrtw = 0, desired_nrtw;
+	struct blk_plug plug;
 
 	if (wbc->nr_to_write < MAX_DESIRED_PAGES_WP) {
 		desired_nrtw = MAX_DESIRED_PAGES_WP;
@@ -572,12 +582,14 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 		wbc->nr_to_write = desired_nrtw;
 	}
 
+	blk_start_plug(&plug);
 	if (!S_ISDIR(inode->i_mode))
 		mutex_lock(&sbi->writepages);
-	ret = generic_writepages(mapping, wbc);
+	ret = write_cache_pages(mapping, wbc, __f2fs_writepage, mapping);
 	if (!S_ISDIR(inode->i_mode))
 		mutex_unlock(&sbi->writepages);
 	f2fs_submit_bio(sbi, DATA, (wbc->sync_mode == WB_SYNC_ALL));
+	blk_finish_plug(&plug);
 
 	remove_dirty_dir_inode(inode);
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 40ceda2..49a5806 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -999,9 +999,10 @@ int sync_node_pages(struct f2fs_sb_info *sbi, nid_t ino,
 	struct pagevec pvec;
 	int step = ino ? 2 : 0;
 	int nwritten = 0, wrote = 0;
-
+	struct blk_plug plug;
 	pagevec_init(&pvec, 0);
 
+	blk_start_plug(&plug);
 next_step:
 	index = 0;
 	end = LONG_MAX;
@@ -1090,6 +1091,7 @@ continue_unlock:
 
 	if (wrote)
 		f2fs_submit_bio(sbi, NODE, wbc->sync_mode == WB_SYNC_ALL);
+	blk_finish_plug(&plug);
 
 	return nwritten;
 }
-- 
1.7.9.5

