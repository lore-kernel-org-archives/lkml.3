Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaKXFwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 00:52:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:47578 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbaKXFww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 00:52:52 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/2] f2fs: introduce f2fs_dentry_kunmap to clean up
Date: Sun, 23 Nov 2014 21:52:52 -0800
Message-Id: <1416808373-24417-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces f2fs_dentry_kunmap to clean up dirty codes.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/dir.c      |  3 +--
 fs/f2fs/f2fs.h     |  6 ++++++
 fs/f2fs/namei.c    | 30 ++++++++++--------------------
 fs/f2fs/recovery.c |  3 +--
 4 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 5a49995..b1a7d57 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -271,8 +271,7 @@ ino_t f2fs_inode_by_name(struct inode *dir, struct qstr *qstr)
 	de = f2fs_find_entry(dir, qstr, &page);
 	if (de) {
 		res = le32_to_cpu(de->ino);
-		if (!f2fs_has_inline_dentry(dir))
-			kunmap(page);
+		f2fs_dentry_kunmap(dir, page);
 		f2fs_put_page(page, 0);
 	}
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 418c852..d042813 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1229,6 +1229,12 @@ static inline void *inline_dentry_addr(struct page *page)
 	return (void *)&(ri->i_addr[1]);
 }
 
+static inline void f2fs_dentry_kunmap(struct inode *dir, struct page *page)
+{
+	if (!f2fs_has_inline_dentry(dir))
+		kunmap(page);
+}
+
 static inline int f2fs_readonly(struct super_block *sb)
 {
 	return sb->s_flags & MS_RDONLY;
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 2bee559..547a2de 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -200,8 +200,7 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 	de = f2fs_find_entry(dir, &dentry->d_name, &page);
 	if (de) {
 		nid_t ino = le32_to_cpu(de->ino);
-		if (!f2fs_has_inline_dentry(dir))
-			kunmap(page);
+		f2fs_dentry_kunmap(dir, page);
 		f2fs_put_page(page, 0);
 
 		inode = f2fs_iget(dir->i_sb, ino);
@@ -231,8 +230,7 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 	err = acquire_orphan_inode(sbi);
 	if (err) {
 		f2fs_unlock_op(sbi);
-		if (!f2fs_has_inline_dentry(dir))
-			kunmap(page);
+		f2fs_dentry_kunmap(dir, page);
 		f2fs_put_page(page, 0);
 		goto fail;
 	}
@@ -469,8 +467,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 						old_dir_page, new_dir);
 			update_inode_page(old_inode);
 		} else {
-			if (!f2fs_has_inline_dentry(old_inode))
-				kunmap(old_dir_page);
+			f2fs_dentry_kunmap(old_inode, old_dir_page);
 			f2fs_put_page(old_dir_page, 0);
 		}
 		drop_nlink(old_dir);
@@ -486,18 +483,15 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 put_out_dir:
 	f2fs_unlock_op(sbi);
-	if (!f2fs_has_inline_dentry(new_dir))
-		kunmap(new_page);
+	f2fs_dentry_kunmap(new_dir, new_page);
 	f2fs_put_page(new_page, 0);
 out_dir:
 	if (old_dir_entry) {
-		if (!f2fs_has_inline_dentry(old_inode))
-			kunmap(old_dir_page);
+		f2fs_dentry_kunmap(old_inode, old_dir_page);
 		f2fs_put_page(old_dir_page, 0);
 	}
 out_old:
-	if (!f2fs_has_inline_dentry(old_dir))
-		kunmap(old_page);
+	f2fs_dentry_kunmap(old_dir, old_page);
 	f2fs_put_page(old_page, 0);
 out:
 	return err;
@@ -632,23 +626,19 @@ out_unlock:
 	f2fs_unlock_op(sbi);
 out_new_dir:
 	if (new_dir_entry) {
-		if (!f2fs_has_inline_dentry(new_inode))
-			kunmap(new_dir_page);
+		f2fs_dentry_kunmap(new_inode, new_dir_page);
 		f2fs_put_page(new_dir_page, 0);
 	}
 out_old_dir:
 	if (old_dir_entry) {
-		if (!f2fs_has_inline_dentry(old_inode))
-			kunmap(old_dir_page);
+		f2fs_dentry_kunmap(old_inode, old_dir_page);
 		f2fs_put_page(old_dir_page, 0);
 	}
 out_new:
-	if (!f2fs_has_inline_dentry(new_dir))
-		kunmap(new_page);
+	f2fs_dentry_kunmap(new_dir, new_page);
 	f2fs_put_page(new_page, 0);
 out_old:
-	if (!f2fs_has_inline_dentry(old_dir))
-		kunmap(old_page);
+	f2fs_dentry_kunmap(old_dir, old_page);
 	f2fs_put_page(old_page, 0);
 out:
 	return err;
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 4b180bb..9a93a6e 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -129,8 +129,7 @@ retry:
 	goto out;
 
 out_unmap_put:
-	if (!f2fs_has_inline_dentry(dir))
-		kunmap(page);
+	f2fs_dentry_kunmap(dir, page);
 	f2fs_put_page(page, 0);
 out_err:
 	iput(dir);
-- 
2.1.1

