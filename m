Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaG2NBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:01:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:48906 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbaG2NBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:01:35 -0400
Date: Tue, 29 Jul 2014 06:01:54 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v2 11/11] f2fs: avoid retrying wrong recovery routine
 when error was occurred
Message-ID: <20140729130154.GB86905@jaegeuk-mac02>
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
 <1406328445-63707-11-git-send-email-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406328445-63707-11-git-send-email-jaegeuk@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log from v1:
 o adjust need_writecp condition, pointed by Chao

>From 387830bd09845dce83bf277bf8416c986c108eb7 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Fri, 25 Jul 2014 15:47:25 -0700
Subject: [PATCH] f2fs: avoid retrying wrong recovery routine when error was
 occurred

This patch eliminates the propagation of recovery errors to the next mount.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c |  3 ++-
 fs/f2fs/f2fs.h       |  2 +-
 fs/f2fs/recovery.c   | 20 +++++++++++++++++++-
 fs/f2fs/segment.c    |  5 +----
 4 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 26b94bb..cea20b8 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -796,6 +796,7 @@ static void wait_on_all_pages_writeback(struct f2fs_sb_info *sbi)
 static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 {
 	struct f2fs_checkpoint *ckpt = F2FS_CKPT(sbi);
+	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
 	nid_t last_nid = 0;
 	block_t start_blk;
 	struct page *cp_page;
@@ -809,7 +810,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 	 * This avoids to conduct wrong roll-forward operations and uses
 	 * metapages, so should be called prior to sync_meta_pages below.
 	 */
-	discard_next_dnode(sbi);
+	discard_next_dnode(sbi, NEXT_FREE_BLKADDR(sbi, curseg));
 
 	/* Flush all the NAT/SIT pages */
 	while (get_pages(sbi, F2FS_DIRTY_META))
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 475f97c..14b9f74 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1225,7 +1225,7 @@ void destroy_flush_cmd_control(struct f2fs_sb_info *);
 void invalidate_blocks(struct f2fs_sb_info *, block_t);
 void refresh_sit_entry(struct f2fs_sb_info *, block_t, block_t);
 void clear_prefree_segments(struct f2fs_sb_info *);
-void discard_next_dnode(struct f2fs_sb_info *);
+void discard_next_dnode(struct f2fs_sb_info *, block_t);
 int npages_for_summary_flush(struct f2fs_sb_info *);
 void allocate_new_segments(struct f2fs_sb_info *);
 struct page *get_sum_page(struct f2fs_sb_info *, unsigned int);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index a112368..b2aa53b 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -434,7 +434,9 @@ next:
 
 int recover_fsync_data(struct f2fs_sb_info *sbi)
 {
+	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
 	struct list_head inode_list;
+	block_t blkaddr;
 	int err;
 	bool need_writecp = false;
 
@@ -447,6 +449,9 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 
 	/* step #1: find fsynced inode numbers */
 	sbi->por_doing = true;
+
+	blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
+
 	err = find_fsync_dnodes(sbi, &inode_list);
 	if (err)
 		goto out;
@@ -462,8 +467,21 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 out:
 	destroy_fsync_dnodes(&inode_list);
 	kmem_cache_destroy(fsync_entry_slab);
+
+	if (err) {
+		truncate_inode_pages_final(NODE_MAPPING(sbi));
+		truncate_inode_pages_final(META_MAPPING(sbi));
+	}
+
 	sbi->por_doing = false;
-	if (!err && need_writecp)
+	if (err) {
+		discard_next_dnode(sbi, blkaddr);
+
+		/* Flush all the NAT/SIT pages */
+		while (get_pages(sbi, F2FS_DIRTY_META))
+			sync_meta_pages(sbi, META, LONG_MAX);
+	} else if (need_writecp) {
 		write_checkpoint(sbi, false);
+	}
 	return err;
 }
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 9fce0f47..e016b97 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -379,11 +379,8 @@ static int f2fs_issue_discard(struct f2fs_sb_info *sbi,
 	return blkdev_issue_discard(sbi->sb->s_bdev, start, len, GFP_NOFS, 0);
 }
 
-void discard_next_dnode(struct f2fs_sb_info *sbi)
+void discard_next_dnode(struct f2fs_sb_info *sbi, block_t blkaddr)
 {
-	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
-	block_t blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
-
 	if (f2fs_issue_discard(sbi, blkaddr, 1)) {
 		struct page *page = grab_meta_page(sbi, blkaddr);
 		/* zero-filled page */
-- 
1.8.5.2 (Apple Git-48)


