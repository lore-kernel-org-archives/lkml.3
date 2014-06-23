Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaFWBNG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:13:06 -0400
Received: from mail.kernel.org ([198.145.19.201]:47263 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbaFWBNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:13:04 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao2.yu@samsung.com>
Subject: [PATCH 1/2] f2fs: introduce f2fs_do_tmpfile for code consistency
Date: Mon, 23 Jun 2014 10:12:55 +0900
Message-Id: <1403485976-29398-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds f2fs_do_tmpfile to eliminate the redundant init_inode_metadata
flow.
Throught this, we can provide the consistent lock usage, e.g., fi->i_sem,  and
this will enable better debugging stuffs.

Cc: Chao Yu <chao2.yu@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/dir.c   | 27 ++++++++++++++++++++++++---
 fs/f2fs/f2fs.h  |  1 +
 fs/f2fs/namei.c | 30 ++++++++----------------------
 3 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 09760d5..fe6aaca 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -337,8 +337,7 @@ static struct page *init_inode_metadata(struct inode *inode,
 	struct page *page;
 	int err;
 
-	if (is_inode_flag_set(F2FS_I(inode), FI_NEW_INODE) &&
-			inode->i_nlink) {
+	if (is_inode_flag_set(F2FS_I(inode), FI_NEW_INODE)) {
 		page = new_inode_page(inode, name);
 		if (IS_ERR(page))
 			return page;
@@ -364,7 +363,8 @@ static struct page *init_inode_metadata(struct inode *inode,
 		set_cold_node(inode, page);
 	}
 
-	init_dent_inode(name, page);
+	if (name)
+		init_dent_inode(name, page);
 
 	/*
 	 * This file should be checkpointed during fsync.
@@ -537,6 +537,27 @@ fail:
 	return err;
 }
 
+int f2fs_do_tmpfile(struct inode *inode, struct inode *dir)
+{
+	struct page *page;
+	int err = 0;
+
+	down_write(&F2FS_I(inode)->i_sem);
+	page = init_inode_metadata(inode, dir, NULL);
+	if (IS_ERR(page)) {
+		err = PTR_ERR(page);
+		goto fail;
+	}
+	/* we don't need to mark_inode_dirty now */
+	update_inode(inode, page);
+	f2fs_put_page(page, 1);
+
+	update_parent_metadata(dir, inode, F2FS_I(dir)->i_current_depth);
+fail:
+	up_write(&F2FS_I(inode)->i_sem);
+	return err;
+}
+
 /*
  * It only removes the dentry from the dentry page,corresponding name
  * entry in name page does not need to be touched during deletion.
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 58df97e..ca421a8 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1136,6 +1136,7 @@ void f2fs_set_link(struct inode *, struct f2fs_dir_entry *,
 int update_dent_inode(struct inode *, const struct qstr *);
 int __f2fs_add_link(struct inode *, const struct qstr *, struct inode *);
 void f2fs_delete_entry(struct f2fs_dir_entry *, struct page *, struct inode *);
+int f2fs_do_tmpfile(struct inode *, struct inode *);
 int f2fs_make_empty(struct inode *, struct inode *);
 bool f2fs_empty_dir(struct inode *);
 
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 0d55517..9de4ab3 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -494,7 +494,6 @@ static int f2fs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct super_block *sb = dir->i_sb;
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 	struct inode *inode;
-	struct page *page;
 	int err;
 
 	inode = f2fs_new_inode(dir, mode);
@@ -509,38 +508,25 @@ static int f2fs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	err = acquire_orphan_inode(sbi);
 	if (err)
 		goto out;
+
+	err = f2fs_do_tmpfile(inode, dir);
+	if (err)
+		goto release_out;
+
 	/*
 	 * add this non-linked tmpfile to orphan list, in this way we could
 	 * remove all unused data of tmpfile after abnormal power-off.
 	 */
 	add_orphan_inode(sbi, inode->i_ino);
-
-	page = new_inode_page(inode, NULL);
-	if (IS_ERR(page)) {
-		err = PTR_ERR(page);
-		goto remove_out;
-	}
-
-	err = f2fs_init_acl(inode, dir, page);
-	if (err)
-		goto unlock_out;
-
-	err = f2fs_init_security(inode, dir, NULL, page);
-	if (err)
-		goto unlock_out;
-
-	f2fs_put_page(page, 1);
 	f2fs_unlock_op(sbi);
 
 	alloc_nid_done(sbi, inode->i_ino);
-	mark_inode_dirty(inode);
 	d_tmpfile(dentry, inode);
 	unlock_new_inode(inode);
 	return 0;
-unlock_out:
-	f2fs_put_page(page, 1);
-remove_out:
-	remove_orphan_inode(sbi, inode->i_ino);
+
+release_out:
+	release_orphan_inode(sbi);
 out:
 	f2fs_unlock_op(sbi);
 	clear_nlink(inode);
-- 
1.8.5.2 (Apple Git-48)

