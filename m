Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaGBKel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:34:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:54015 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbaGBKej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:34:39 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs: do checkpoint for the renamed inode
Date: Wed,  2 Jul 2014 03:34:30 -0700
Message-Id: <1404297270-26809-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an inode is renamed, it should be registered as file_lost_pino to conduct
checkpoint at f2fs_sync_file.
Otherwise, the inode cannot be recovered due to no dent_mark in the following
scenario.

Note that, this scenario is from xfstests/322.

1. create "a"
2. fsync "a"
3. rename "a" to "b"
4. fsync "b"
5. Sudden power-cut

After recovery is done, "b" should be seen.
However, the result shows "a", since the recovery procedure does not enter
recover_dentry due to no dent_mark.

The reason is like below.
- The nid of "a" is checkpointed during #2, f2fs_sync_file.
- The inode page for "b" produced by #3 is written without dent_mark by
sync_node_pages.

So, this patch fixes this bug by assinging file_lost_pino to the "a"'s inode.
If the pino is lost, f2fs_sync_file conducts checkpoint, and then recovers
the latest pino and its dentry information for further recovery.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/namei.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 96f1dd1..1b3cae0 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -411,9 +411,6 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 
 		f2fs_set_link(new_dir, new_entry, new_page, old_inode);
-		down_write(&F2FS_I(old_inode)->i_sem);
-		F2FS_I(old_inode)->i_pino = new_dir->i_ino;
-		up_write(&F2FS_I(old_inode)->i_sem);
 
 		new_inode->i_ctime = CURRENT_TIME;
 		down_write(&F2FS_I(new_inode)->i_sem);
@@ -446,6 +443,10 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 	}
 
+	down_write(&F2FS_I(old_inode)->i_sem);
+	file_lost_pino(old_inode);
+	up_write(&F2FS_I(old_inode)->i_sem);
+
 	old_inode->i_ctime = CURRENT_TIME;
 	mark_inode_dirty(old_inode);
 
@@ -455,9 +456,6 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (old_dir != new_dir) {
 			f2fs_set_link(old_inode, old_dir_entry,
 						old_dir_page, new_dir);
-			down_write(&F2FS_I(old_inode)->i_sem);
-			F2FS_I(old_inode)->i_pino = new_dir->i_ino;
-			up_write(&F2FS_I(old_inode)->i_sem);
 			update_inode_page(old_inode);
 		} else {
 			kunmap(old_dir_page);
-- 
1.8.5.2 (Apple Git-48)

