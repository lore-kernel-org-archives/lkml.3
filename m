Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3JAQC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:02:26 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:51520 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3JAQAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:00:13 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, tytso@mit.edu, mszeredi@suse.cz
Subject: [PATCH 6/7] ext4: rename: split out helper functions
Date: Tue,  1 Oct 2013 18:00:38 +0200
Message-Id: <1380643239-16060-7-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
References: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Cross rename (exchange source and dest) will need to call some of these
helpers for both source and dest, while overwriting rename currently only
calls them for one or the other.  This also makes the code easier to
follow.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ext4/namei.c | 199 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 126 insertions(+), 73 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1348251..fb0f1db 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3014,6 +3014,125 @@ struct ext4_renament {
 	int parent_inlined;
 };
 
+static int ext4_rename_dir_prepare(handle_t *handle, struct ext4_renament *ent)
+{
+	int retval;
+
+	ent->dir_bh = ext4_get_first_dir_block(handle, ent->inode,
+					      &retval, &ent->parent_de,
+					      &ent->parent_inlined);
+	if (!ent->dir_bh)
+		return retval;
+	if (le32_to_cpu(ent->parent_de->inode) != ent->dir->i_ino)
+		return -EIO;
+	BUFFER_TRACE(ent->dir_bh, "get_write_access");
+	return ext4_journal_get_write_access(handle, ent->dir_bh);
+}
+
+static int ext4_rename_dir_finish(handle_t *handle, struct ext4_renament *ent,
+				  unsigned dir_ino)
+{
+	int retval;
+
+	ent->parent_de->inode = cpu_to_le32(dir_ino);
+	BUFFER_TRACE(ent->dir_bh, "call ext4_handle_dirty_metadata");
+	if (!ent->parent_inlined) {
+		if (is_dx(ent->inode)) {
+			retval = ext4_handle_dirty_dx_node(handle,
+							   ent->inode,
+							   ent->dir_bh);
+		} else {
+			retval = ext4_handle_dirty_dirent_node(handle,
+							       ent->inode,
+							       ent->dir_bh);
+		}
+	} else {
+		retval = ext4_mark_inode_dirty(handle, ent->inode);
+	}
+	if (retval) {
+		ext4_std_error(ent->dir->i_sb, retval);
+		return retval;
+	}
+	return 0;
+}
+
+static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
+		       unsigned ino, unsigned file_type)
+{
+	int retval;
+
+	BUFFER_TRACE(ent->bh, "get write access");
+	retval = ext4_journal_get_write_access(handle, ent->bh);
+	if (retval)
+		return retval;
+	ent->de->inode = cpu_to_le32(ino);
+	if (EXT4_HAS_INCOMPAT_FEATURE(ent->dir->i_sb,
+				      EXT4_FEATURE_INCOMPAT_FILETYPE))
+		ent->de->file_type = file_type;
+	ent->dir->i_version++;
+	ent->dir->i_ctime = ent->dir->i_mtime =
+		ext4_current_time(ent->dir);
+	ext4_mark_inode_dirty(handle, ent->dir);
+	BUFFER_TRACE(ent->bh, "call ext4_handle_dirty_metadata");
+	if (!ent->inlined) {
+		retval = ext4_handle_dirty_dirent_node(handle,
+						       ent->dir, ent->bh);
+		if (unlikely(retval)) {
+			ext4_std_error(ent->dir->i_sb, retval);
+			return retval;
+		}
+	}
+	brelse(ent->bh);
+	ent->bh = NULL;
+
+	return 0;
+}
+
+static int ext4_find_delete_entry(handle_t *handle, struct inode *dir,
+				  const struct qstr *d_name)
+{
+	int retval = -ENOENT;
+	struct buffer_head *bh;
+	struct ext4_dir_entry_2 *de;
+
+	bh = ext4_find_entry(dir, d_name, &de, NULL);
+	if (bh) {
+		retval = ext4_delete_entry(handle, dir, de, bh);
+		brelse(bh);
+	}
+	return retval;
+}
+
+static void ext4_rename_delete(handle_t *handle, struct ext4_renament *ent)
+{
+	int retval;
+	/*
+	 * ent->de could have moved from under us during htree split, so make
+	 * sure that we are deleting the right entry.  We might also be pointing
+	 * to a stale entry in the unused part of ent->bh so just checking inum
+	 * and the name isn't enough.
+	 */
+	if (le32_to_cpu(ent->de->inode) != ent->inode->i_ino ||
+	    ent->de->name_len != ent->dentry->d_name.len ||
+	    strncmp(ent->de->name, ent->dentry->d_name.name,
+		    ent->de->name_len)) {
+		retval = ext4_find_delete_entry(handle, ent->dir,
+						&ent->dentry->d_name);
+	} else {
+		retval = ext4_delete_entry(handle, ent->dir, ent->de, ent->bh);
+		if (retval == -ENOENT) {
+			retval = ext4_find_delete_entry(handle, ent->dir,
+							&ent->dentry->d_name);
+		}
+	}
+
+	if (retval) {
+		ext4_warning(ent->dir->i_sb,
+				"Deleting old file (%lu), %d, error=%d",
+				ent->dir->i_ino, ent->dir->i_nlink, retval);
+	}
+}
+
 /*
  * Anybody can rename anything with this: the permission checks are left to the
  * higher-level routines.
@@ -3087,16 +3206,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 			if (new.dir != old.dir && EXT4_DIR_LINK_MAX(new.dir))
 				goto end_rename;
 		}
-		retval = -EIO;
-		old.dir_bh = ext4_get_first_dir_block(handle, old.inode,
-						  &retval, &old.parent_de,
-						  &old.parent_inlined);
-		if (!old.dir_bh)
-			goto end_rename;
-		if (le32_to_cpu(old.parent_de->inode) != old.dir->i_ino)
-			goto end_rename;
-		BUFFER_TRACE(old.dir_bh, "get_write_access");
-		retval = ext4_journal_get_write_access(handle, old.dir_bh);
+		retval = ext4_rename_dir_prepare(handle, &old);
 		if (retval)
 			goto end_rename;
 	}
@@ -3105,29 +3215,10 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (retval)
 			goto end_rename;
 	} else {
-		BUFFER_TRACE(new.bh, "get write access");
-		retval = ext4_journal_get_write_access(handle, new.bh);
+		retval = ext4_setent(handle, &new,
+				     old.inode->i_ino, old.de->file_type);
 		if (retval)
 			goto end_rename;
-		new.de->inode = cpu_to_le32(old.inode->i_ino);
-		if (EXT4_HAS_INCOMPAT_FEATURE(new.dir->i_sb,
-					      EXT4_FEATURE_INCOMPAT_FILETYPE))
-			new.de->file_type = old.de->file_type;
-		new.dir->i_version++;
-		new.dir->i_ctime = new.dir->i_mtime =
-					ext4_current_time(new.dir);
-		ext4_mark_inode_dirty(handle, new.dir);
-		BUFFER_TRACE(new.bh, "call ext4_handle_dirty_metadata");
-		if (!new.inlined) {
-			retval = ext4_handle_dirty_dirent_node(handle,
-							       new.dir, new.bh);
-			if (unlikely(retval)) {
-				ext4_std_error(new.dir->i_sb, retval);
-				goto end_rename;
-			}
-		}
-		brelse(new.bh);
-		new.bh = NULL;
 	}
 
 	/*
@@ -3140,31 +3231,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	/*
 	 * ok, that's it
 	 */
-	if (le32_to_cpu(old.de->inode) != old.inode->i_ino ||
-	    old.de->name_len != old.dentry->d_name.len ||
-	    strncmp(old.de->name, old.dentry->d_name.name, old.de->name_len) ||
-	    (retval = ext4_delete_entry(handle, old.dir,
-					old.de, old.bh)) == -ENOENT) {
-		/* old.de could have moved from under us during htree split, so
-		 * make sure that we are deleting the right entry.  We might
-		 * also be pointing to a stale entry in the unused part of
-		 * old.bh so just checking inum and the name isn't enough. */
-		struct buffer_head *old_bh2;
-		struct ext4_dir_entry_2 *old_de2;
-
-		old_bh2 = ext4_find_entry(old.dir, &old.dentry->d_name,
-					  &old_de2, NULL);
-		if (old_bh2) {
-			retval = ext4_delete_entry(handle, old.dir,
-						   old_de2, old_bh2);
-			brelse(old_bh2);
-		}
-	}
-	if (retval) {
-		ext4_warning(old.dir->i_sb,
-				"Deleting old file (%lu), %d, error=%d",
-				old.dir->i_ino, old.dir->i_nlink, retval);
-	}
+	ext4_rename_delete(handle, &old);
 
 	if (new.inode) {
 		ext4_dec_count(handle, new.inode);
@@ -3173,24 +3240,10 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old.dir->i_ctime = old.dir->i_mtime = ext4_current_time(old.dir);
 	ext4_update_dx_flag(old.dir);
 	if (old.dir_bh) {
-		old.parent_de->inode = cpu_to_le32(new.dir->i_ino);
-		BUFFER_TRACE(old.dir_bh, "call ext4_handle_dirty_metadata");
-		if (!old.parent_inlined) {
-			if (is_dx(old.inode)) {
-				retval = ext4_handle_dirty_dx_node(handle,
-								   old.inode,
-								   old.dir_bh);
-			} else {
-				retval = ext4_handle_dirty_dirent_node(handle,
-							old.inode, old.dir_bh);
-			}
-		} else {
-			retval = ext4_mark_inode_dirty(handle, old.inode);
-		}
-		if (retval) {
-			ext4_std_error(old.dir->i_sb, retval);
+		retval = ext4_rename_dir_finish(handle, &old, new.dir->i_ino);
+		if (retval)
 			goto end_rename;
-		}
+
 		ext4_dec_count(handle, old.dir);
 		if (new.inode) {
 			/* checked empty_dir above, can't have another parent,
-- 
1.8.1.4

