Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3KTNDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:03:13 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:50615 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3KTNCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:02:16 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: [PATCH 11/11] ext4: add cross rename support
Date: Wed, 20 Nov 2013 14:01:52 +0100
Message-Id: <1384952512-21600-12-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384952512-21600-1-git-send-email-miklos@szeredi.hu>
References: <1384952512-21600-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Implement RENAME_EXCHANGE flag in renameat2 syscall.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ext4/namei.c | 97 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 69 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index d258b354b937..5307e482f403 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3159,7 +3159,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	};
 	int retval;
 
-	if (flags & ~RENAME_NOREPLACE)
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EOPNOTSUPP;
 
 	dquot_initialize(old.dir);
@@ -3167,10 +3167,11 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	/* Initialize quotas before so that eventual writes go
 	 * in separate transaction */
-	if (new.dentry->d_inode)
+	if (!(flags & RENAME_EXCHANGE) && new.dentry->d_inode)
 		dquot_initialize(new.dentry->d_inode);
 
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name,
+				 &old.de, &old.inlined);
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
 	 *  We might rmdir the source, keep it as pwd of some process
@@ -3185,18 +3186,22 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	new.inode = new.dentry->d_inode;
 	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
 				 &new.de, &new.inlined);
-	if (new.bh) {
-		if (!new.inode) {
-			brelse(new.bh);
-			new.bh = NULL;
+	if (!(flags & RENAME_EXCHANGE)) {
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
 
@@ -3204,11 +3209,12 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		ext4_handle_sync(handle);
 
 	if (S_ISDIR(old.inode->i_mode)) {
-		if (new.inode) {
+		if (!(flags & RENAME_EXCHANGE) && new.inode) {
 			retval = -ENOTEMPTY;
 			if (!empty_dir(new.inode))
 				goto end_rename;
-		} else {
+		}
+		if (!new.inode || !S_ISDIR(new.inode->i_mode)) {
 			retval = -EMLINK;
 			if (new.dir != old.dir && EXT4_DIR_LINK_MAX(new.dir))
 				goto end_rename;
@@ -3217,15 +3223,34 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (retval)
 			goto end_rename;
 	}
+	if ((flags & RENAME_EXCHANGE) && S_ISDIR(new.inode->i_mode)) {
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
+		if (flags & RENAME_EXCHANGE) {
+			retval = ext4_setent(handle, &old,
+					     new.inode->i_ino, new_file_type);
+			if (retval)
+				goto end_rename;
+		}
 	}
 
 	/*
@@ -3235,35 +3260,51 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old.inode->i_ctime = ext4_current_time(old.inode);
 	ext4_mark_inode_dirty(handle, old.inode);
 
-	/*
-	 * ok, that's it
-	 */
-	ext4_rename_delete(handle, &old);
+	if (!(flags & RENAME_EXCHANGE)) {
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
+		if (!(flags & RENAME_EXCHANGE) || !S_ISDIR(new.inode->i_mode))
+			ext4_dec_count(handle, old.dir);
+
+		if (!new.inode || !S_ISDIR(new.inode->i_mode)) {
 			ext4_inc_count(handle, new.dir);
 			ext4_update_dx_flag(new.dir);
 			ext4_mark_inode_dirty(handle, new.dir);
 		}
 	}
+	/* (flags & RENAME_EXCHANGE) && S_ISDIR(new.inode->i_mode */
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
+	if (!(flags & RENAME_EXCHANGE) && new.inode) {
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
-- 
1.8.1.4

