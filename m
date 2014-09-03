Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbaICFCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:02:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:37784 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbaICFCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:02:39 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/6] f2fs: remain inconsistency information to initiate fsck.f2fs
Date: Tue,  2 Sep 2014 22:02:30 -0700
Message-Id: <1409720554-72925-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1409720554-72925-1-git-send-email-jaegeuk@kernel.org>
References: <1409720554-72925-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds sbi->need_fsck to conduct fsck.f2fs later.
This flag is only able to be removed by fsck.f2fs.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c    | 3 +++
 fs/f2fs/f2fs.h          | 1 +
 fs/f2fs/super.c         | 1 +
 include/linux/f2fs_fs.h | 1 +
 4 files changed, 6 insertions(+)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index cb5cb4c..5af97d9 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -882,6 +882,9 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 	else
 		clear_ckpt_flags(ckpt, CP_ORPHAN_PRESENT_FLAG);
 
+	if (sbi->need_fsck)
+		set_ckpt_flags(ckpt, CP_FSCK_FLAG);
+
 	/* update SIT/NAT bitmap */
 	get_sit_bitmap(sbi, __bitmap_ptr(sbi, SIT_BITMAP));
 	get_nat_bitmap(sbi, __bitmap_ptr(sbi, NAT_BITMAP));
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 222ff5b..210c62d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -434,6 +434,7 @@ struct f2fs_sb_info {
 	struct buffer_head *raw_super_buf;	/* buffer head of raw sb */
 	struct f2fs_super_block *raw_super;	/* raw super block pointer */
 	int s_dirty;				/* dirty flag for checkpoint */
+	bool need_fsck;				/* need fsck.f2fs to fix */
 
 	/* for node-related operations */
 	struct f2fs_nm_info *nm_info;		/* node manager */
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 41bdf51..a692304 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -849,6 +849,7 @@ static void init_sb_info(struct f2fs_sb_info *sbi)
 		atomic_set(&sbi->nr_pages[i], 0);
 
 	sbi->dir_level = DEF_DIR_LEVEL;
+	sbi->need_fsck = false;
 }
 
 /*
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 08ed2b0..9ca1ff3 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -85,6 +85,7 @@ struct f2fs_super_block {
 /*
  * For checkpoint
  */
+#define CP_FSCK_FLAG		0x00000010
 #define CP_ERROR_FLAG		0x00000008
 #define CP_COMPACT_SUM_FLAG	0x00000004
 #define CP_ORPHAN_PRESENT_FLAG	0x00000002
-- 
1.8.5.2 (Apple Git-48)

