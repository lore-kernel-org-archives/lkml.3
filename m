Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbaHLTtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:49:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:58089 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134AbaHLTth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:49:37 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 10/13] f2fs: introduce f2fs_cp_error for readability
Date: Tue, 12 Aug 2014 12:49:24 -0700
Message-Id: <1407872967-26423-10-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds f2fs_cp_error for readability.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 4 ++--
 fs/f2fs/f2fs.h       | 5 +++++
 fs/f2fs/gc.c         | 2 +-
 fs/f2fs/super.c      | 2 +-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 7e1c13b..1161d2a 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -162,7 +162,7 @@ static int f2fs_write_meta_page(struct page *page,
 		goto redirty_out;
 
 	/* Should not write any meta pages, if any IO error was occurred */
-	if (unlikely(is_set_ckpt_flags(F2FS_CKPT(sbi), CP_ERROR_FLAG)))
+	if (unlikely(f2fs_cp_error(sbi)))
 		goto no_write;
 
 	f2fs_wait_on_page_writeback(page, META);
@@ -934,7 +934,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 	/* Here, we only have one bio having CP pack */
 	sync_meta_pages(sbi, META_FLUSH, LONG_MAX);
 
-	if (!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG)) {
+	if (!f2fs_cp_error(sbi)) {
 		clear_prefree_segments(sbi);
 		release_dirty_inode(sbi);
 		F2FS_RESET_SB_DIRT(sbi);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index cc5ead1..46ceb88 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1096,6 +1096,11 @@ static inline int f2fs_readonly(struct super_block *sb)
 	return sb->s_flags & MS_RDONLY;
 }
 
+static inline bool f2fs_cp_error(struct f2fs_sb_info *sbi)
+{
+	return is_set_ckpt_flags(sbi->ckpt, CP_ERROR_FLAG);
+}
+
 static inline void f2fs_stop_checkpoint(struct f2fs_sb_info *sbi)
 {
 	set_ckpt_flags(sbi->ckpt, CP_ERROR_FLAG);
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 87c50c5..e8507b1 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -693,7 +693,7 @@ int f2fs_gc(struct f2fs_sb_info *sbi)
 gc_more:
 	if (unlikely(!(sbi->sb->s_flags & MS_ACTIVE)))
 		goto stop;
-	if (unlikely(is_set_ckpt_flags(F2FS_CKPT(sbi), CP_ERROR_FLAG)))
+	if (unlikely(f2fs_cp_error(sbi)))
 		goto stop;
 
 	if (gc_type == BG_GC && has_not_enough_free_secs(sbi, nfree)) {
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 2856020..7e4b631 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -812,7 +812,7 @@ static int sanity_check_ckpt(struct f2fs_sb_info *sbi)
 	if (unlikely(fsmeta >= total))
 		return 1;
 
-	if (unlikely(is_set_ckpt_flags(ckpt, CP_ERROR_FLAG))) {
+	if (unlikely(f2fs_cp_error(sbi))) {
 		f2fs_msg(sbi->sb, KERN_ERR, "A bug case: need to run fsck");
 		return 1;
 	}
-- 
1.8.5.2 (Apple Git-48)

