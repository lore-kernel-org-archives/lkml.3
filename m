Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbbAWAJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:09:02 -0500
Received: from mail.kernel.org ([198.145.29.136]:51786 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbbAWAI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:08:59 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/2] f2fs: trigger correct checkpoint during umount
Date: Thu, 22 Jan 2015 16:08:49 -0800
Message-Id: <1421971730-17024-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes to trigger checkpoint with umount flag when kill_sb was called.
In kill_sb, f2fs_sync_fs was finally called, but at this time, f2fs can't do
checkpoint with CP_UMOUNT.
After then, f2fs_put_super is not doing checkpoint, since it is not dirty.

So, this patch adds a flag to indicate f2fs_sync_fs is called during umount.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h  |  1 +
 fs/f2fs/super.c | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c2cf040..1795ce2 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -525,6 +525,7 @@ struct f2fs_sb_info {
 	struct f2fs_super_block *raw_super;	/* raw super block pointer */
 	int s_dirty;				/* dirty flag for checkpoint */
 	bool need_fsck;				/* need fsck.f2fs to fix */
+	bool s_closing;				/* specify unmounting */
 
 	/* for node-related operations */
 	struct f2fs_nm_info *nm_info;		/* node manager */
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 0e97974..84f95cd 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -487,7 +487,8 @@ int f2fs_sync_fs(struct super_block *sb, int sync)
 	if (sync) {
 		struct cp_control cpc;
 
-		cpc.reason = test_opt(sbi, FASTBOOT) ? CP_UMOUNT : CP_SYNC;
+		cpc.reason = (test_opt(sbi, FASTBOOT) || sbi->s_closing) ?
+							CP_UMOUNT : CP_SYNC;
 		mutex_lock(&sbi->gc_mutex);
 		write_checkpoint(sbi, &cpc);
 		mutex_unlock(&sbi->gc_mutex);
@@ -1190,11 +1191,18 @@ static struct dentry *f2fs_mount(struct file_system_type *fs_type, int flags,
 	return mount_bdev(fs_type, flags, dev_name, data, f2fs_fill_super);
 }
 
+static void kill_f2fs_super(struct super_block *sb)
+{
+	if (sb->s_root)
+		F2FS_SB(sb)->s_closing = true;
+	kill_block_super(sb);
+}
+
 static struct file_system_type f2fs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "f2fs",
 	.mount		= f2fs_mount,
-	.kill_sb	= kill_block_super,
+	.kill_sb	= kill_f2fs_super,
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 MODULE_ALIAS_FS("f2fs");
-- 
2.1.1

