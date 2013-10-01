Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab3JAQCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:02:04 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:61805 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab3JAQAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:00:17 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, tytso@mit.edu, mszeredi@suse.cz
Subject: [PATCH 7/7] ext4: add cross rename support
Date: Tue,  1 Oct 2013 18:00:39 +0200
Message-Id: <1380643239-16060-8-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
References: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Implement RENAME_EXCHANGE flag in renameat2 syscall.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ext4/namei.c | 103 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 73 insertions(+), 30 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index fb0f1db..6d87a09 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3141,8 +3141,9 @@ static void ext4_rename_delete(handle_t *handle, struct ext4_renament *ent)
  * while new_{dentry,inode) refers to the destination dentry/inode
  * This comes from rename(const char *oldpath, const char *newpath)
  */
-static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
-		       struct inode *new_dir, struct dentry *new_dentry)
+static int ext4_rename2(struct inode *old_dir, struct dentry *old_dentry,
+			struct inode *new_dir, struct dentry *new_dentry,
+			unsigned int flags)
 {
 	handle_t *handle = NULL;
 	struct ext4_renament old = {
@@ -3154,16 +3155,18 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		.dentry = new_dentry,
 	};
 	int retval;
+	bool overwrite = !(flags & RENAME_EXCHANGE);
 
 	dquot_initialize(old.dir);
 	dquot_initialize(new.dir);
 
 	/* Initialize quotas before so that eventual writes go
 	 * in separate transaction */
-	if (new.dentry->d_inode)
+	if (overwrite && new.dentry->d_inode)
 		dquot_initialize(new.dentry->d_inode);
 
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name,
+				 &old.de, &old.inlined);
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
 	 *  We might rmdir the source, keep it as pwd of some process
@@ -3178,18 +3181,22 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	new.inode = new.dentry->d_inode;
 	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
 				 &new.de, &new.inlined);
-	if (new.bh) {
-		if (!new.inode) {
-			brelse(new.bh);
-			new.bh = NULL;
+	if (overwrite) {
+		if (new.bh) {
+			if (!new.inode) {
+				brelse(new.bh);
+				new.bh = NULL;
+			}
 		}
+		if (new.inode && !test_opt(new.dir->i_sb, NO_AUTO_DA_ALLOC))
+			ext4_alloc_da_blocks(old.inode);
+	} else if (!new.bh || le32_to_cpu(new.de->inode) != new.inode->i_ino) {
+		goto end_rename;
 	}
-	if (new.inode && !test_opt(new.dir->i_sb, NO_AUTO_DA_ALLOC))
-		ext4_alloc_da_blocks(old.inode);
 
 	handle = ext4_journal_start(old.dir, EXT4_HT_DIR,
 		(2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
-		 EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2));
+		 2 * EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -3197,11 +3204,12 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		ext4_handle_sync(handle);
 
 	if (S_ISDIR(old.inode->i_mode)) {
-		if (new.inode) {
+		if (overwrite && new.inode) {
 			retval = -ENOTEMPTY;
 			if (!empty_dir(new.inode))
 				goto end_rename;
-		} else {
+		}
+		if (!new.inode || !S_ISDIR(new.inode->i_mode)) {
 			retval = -EMLINK;
 			if (new.dir != old.dir && EXT4_DIR_LINK_MAX(new.dir))
 				goto end_rename;
@@ -3210,15 +3218,34 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (retval)
 			goto end_rename;
 	}
+	if (!overwrite && S_ISDIR(new.inode->i_mode)) {
+		if (!S_ISDIR(old.inode->i_mode)) {
+			retval = -EMLINK;
+			if (new.dir != old.dir && EXT4_DIR_LINK_MAX(old.dir))
+				goto end_rename;
+		}
+		retval = ext4_rename_dir_prepare(handle, &new);
+		if (retval)
+			goto end_rename;
+	}
+
 	if (!new.bh) {
 		retval = ext4_add_entry(handle, new.dentry, old.inode);
 		if (retval)
 			goto end_rename;
 	} else {
+		u8 new_file_type = new.de->file_type;
 		retval = ext4_setent(handle, &new,
 				     old.inode->i_ino, old.de->file_type);
 		if (retval)
 			goto end_rename;
+
+		if (!overwrite) {
+			retval = ext4_setent(handle, &old,
+					     new.inode->i_ino, new_file_type);
+			if (retval)
+				goto end_rename;
+		}
 	}
 
 	/*
@@ -3228,35 +3255,51 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old.inode->i_ctime = ext4_current_time(old.inode);
 	ext4_mark_inode_dirty(handle, old.inode);
 
-	/*
-	 * ok, that's it
-	 */
-	ext4_rename_delete(handle, &old);
+	if (overwrite) {
+		/*
+		 * ok, that's it
+		 */
+		ext4_rename_delete(handle, &old);
 
-	if (new.inode) {
-		ext4_dec_count(handle, new.inode);
-		new.inode->i_ctime = ext4_current_time(new.inode);
+		old.dir->i_ctime = old.dir->i_mtime = ext4_current_time(old.dir);
+		ext4_update_dx_flag(old.dir);
 	}
-	old.dir->i_ctime = old.dir->i_mtime = ext4_current_time(old.dir);
-	ext4_update_dx_flag(old.dir);
+	/* S_ISDIR(old.inode->i_mode */
 	if (old.dir_bh) {
 		retval = ext4_rename_dir_finish(handle, &old, new.dir->i_ino);
 		if (retval)
 			goto end_rename;
 
-		ext4_dec_count(handle, old.dir);
-		if (new.inode) {
-			/* checked empty_dir above, can't have another parent,
-			 * ext4_dec_count() won't work for many-linked dirs */
-			clear_nlink(new.inode);
-		} else {
+		if (overwrite || !S_ISDIR(new.inode->i_mode))
+			ext4_dec_count(handle, old.dir);
+
+		if (!new.inode || !S_ISDIR(new.inode->i_mode)) {
 			ext4_inc_count(handle, new.dir);
 			ext4_update_dx_flag(new.dir);
 			ext4_mark_inode_dirty(handle, new.dir);
 		}
 	}
+	/* !overwrite && S_ISDIR(new.inode->i_mode */
+	if (new.dir_bh) {
+		retval = ext4_rename_dir_finish(handle, &new, old.dir->i_ino);
+		if (retval)
+			goto end_rename;
+
+		if (!S_ISDIR(old.inode->i_mode)) {
+			ext4_dec_count(handle, new.dir);
+			ext4_inc_count(handle, old.dir);
+			ext4_mark_inode_dirty(handle, new.dir);
+		}
+	}
 	ext4_mark_inode_dirty(handle, old.dir);
-	if (new.inode) {
+	if (overwrite && new.inode) {
+		ext4_dec_count(handle, new.inode);
+		new.inode->i_ctime = ext4_current_time(new.inode);
+		if (S_ISDIR(old.inode->i_mode)) {
+			/* checked empty_dir above, can't have another parent,
+			 * ext4_dec_count() won't work for many-linked dirs */
+			clear_nlink(new.inode);
+		}
 		ext4_mark_inode_dirty(handle, new.inode);
 		if (!new.inode->i_nlink)
 			ext4_orphan_add(handle, new.inode);
@@ -3285,7 +3328,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.rmdir		= ext4_rmdir,
 	.mknod		= ext4_mknod,
 	.tmpfile	= ext4_tmpfile,
-	.rename		= ext4_rename,
+	.rename2	= ext4_rename2,
 	.setattr	= ext4_setattr,
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
-- 
1.8.1.4

