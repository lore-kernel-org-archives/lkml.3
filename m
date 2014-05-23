Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaEWJqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:46:39 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:49039 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbaEWJoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:44:07 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@gmail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 07/13] vfs: add RENAME_WHITEOUT
Date: Fri, 23 May 2014 11:43:37 +0200
Message-Id: <1400838223-30844-8-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This adds a new RENAME_WHITEOUT flag.  This flag makes rename() create a
whiteout of source.  The whiteout creation is atomic relative to the
rename.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ext4/namei.c         | 99 ++++++++++++++++++++++++++++++++++++++++---------
 fs/namei.c              |  8 +++-
 include/linux/fs.h      |  7 ++++
 include/uapi/linux/fs.h |  1 +
 4 files changed, 95 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1cb84f78909e..f782831b19dc 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3148,6 +3148,39 @@ static void ext4_update_dir_count(handle_t *handle, struct ext4_renament *ent)
 	}
 }
 
+static struct inode *ext4_whiteout_for_rename(struct ext4_renament *ent,
+					      int credits, handle_t **h)
+{
+	struct inode *wh;
+	handle_t *handle;
+	int retries = 0;
+
+	/*
+	 * for inode block, sb block, group summaries,
+	 * and inode bitmap
+	 */
+	credits += (EXT4_MAXQUOTAS_TRANS_BLOCKS(ent->dir->i_sb) +
+		    EXT4_XATTR_TRANS_BLOCKS + 4);
+retry:
+	wh = ext4_new_inode_start_handle(ent->dir, S_IFCHR | WHITEOUT_MODE,
+					 &ent->dentry->d_name, 0, NULL,
+					 EXT4_HT_DIR, credits);
+
+	handle = ext4_journal_current_handle();
+	if (IS_ERR(wh)) {
+		if (handle)
+			ext4_journal_stop(handle);
+		if (PTR_ERR(wh) == -ENOSPC &&
+		    ext4_should_retry_alloc(ent->dir->i_sb, &retries))
+			goto retry;
+	} else {
+		*h = handle;
+		init_special_inode(wh, wh->i_mode, WHITEOUT_DEV);
+		wh->i_op = &ext4_special_inode_operations;
+	}
+	return wh;
+}
+
 /*
  * Anybody can rename anything with this: the permission checks are left to the
  * higher-level routines.
@@ -3156,8 +3189,9 @@ static void ext4_update_dir_count(handle_t *handle, struct ext4_renament *ent)
  * while new_{dentry,inode) refers to the destination dentry/inode
  * This comes from rename(const char *oldpath, const char *newpath)
  */
-static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
-		       struct inode *new_dir, struct dentry *new_dentry)
+static int ext4_simple_rename(struct inode *old_dir, struct dentry *old_dentry,
+			      struct inode *new_dir, struct dentry *new_dentry,
+			      unsigned int flags)
 {
 	handle_t *handle = NULL;
 	struct ext4_renament old = {
@@ -3171,6 +3205,9 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		.inode = new_dentry->d_inode,
 	};
 	int retval;
+	struct inode *whiteout = NULL;
+	int credits;
+	u8 old_file_type;
 
 	dquot_initialize(old.dir);
 	dquot_initialize(new.dir);
@@ -3202,11 +3239,17 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (new.inode && !test_opt(new.dir->i_sb, NO_AUTO_DA_ALLOC))
 		ext4_alloc_da_blocks(old.inode);
 
-	handle = ext4_journal_start(old.dir, EXT4_HT_DIR,
-		(2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
-		 EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2));
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	credits = (2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
+		   EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
+	if (!(flags & RENAME_WHITEOUT)) {
+		handle = ext4_journal_start(old.dir, EXT4_HT_DIR, credits);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+	} else {
+		whiteout = ext4_whiteout_for_rename(&old, credits, &handle);
+		if (IS_ERR(whiteout))
+			return PTR_ERR(whiteout);
+	}
 
 	if (IS_DIRSYNC(old.dir) || IS_DIRSYNC(new.dir))
 		ext4_handle_sync(handle);
@@ -3225,13 +3268,21 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (retval)
 			goto end_rename;
 	}
+	old_file_type = old.de->file_type;
+	if (whiteout) {
+		retval = ext4_setent(handle, &old, whiteout->i_ino,
+				     EXT4_FT_CHRDEV);
+		if (retval)
+			goto end_rename;
+		ext4_mark_inode_dirty(handle, whiteout);
+	}
 	if (!new.bh) {
 		retval = ext4_add_entry(handle, new.dentry, old.inode);
 		if (retval)
 			goto end_rename;
 	} else {
 		retval = ext4_setent(handle, &new,
-				     old.inode->i_ino, old.de->file_type);
+				     old.inode->i_ino, old_file_type);
 		if (retval)
 			goto end_rename;
 	}
@@ -3243,10 +3294,12 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old.inode->i_ctime = ext4_current_time(old.inode);
 	ext4_mark_inode_dirty(handle, old.inode);
 
-	/*
-	 * ok, that's it
-	 */
-	ext4_rename_delete(handle, &old);
+	if (!whiteout) {
+		/*
+		 * ok, that's it
+		 */
+		ext4_rename_delete(handle, &old);
+	}
 
 	if (new.inode) {
 		ext4_dec_count(handle, new.inode);
@@ -3282,6 +3335,12 @@ end_rename:
 	brelse(old.dir_bh);
 	brelse(old.bh);
 	brelse(new.bh);
+	if (whiteout) {
+		if (retval)
+			drop_nlink(whiteout);
+		unlock_new_inode(whiteout);
+		iput(whiteout);
+	}
 	if (handle)
 		ext4_journal_stop(handle);
 	return retval;
@@ -3403,22 +3462,26 @@ end_rename:
 	return retval;
 }
 
+static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
+		       struct inode *new_dir, struct dentry *new_dentry)
+{
+	return ext4_simple_rename(old_dir, old_dentry, new_dir, new_dentry, 0);
+}
+
 static int ext4_rename2(struct inode *old_dir, struct dentry *old_dentry,
 			struct inode *new_dir, struct dentry *new_dentry,
 			unsigned int flags)
 {
-	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
 		return -EINVAL;
 
 	if (flags & RENAME_EXCHANGE) {
 		return ext4_cross_rename(old_dir, old_dentry,
 					 new_dir, new_dentry);
 	}
-	/*
-	 * Existence checking was done by the VFS, otherwise "RENAME_NOREPLACE"
-	 * is equivalent to regular rename.
-	 */
-	return ext4_rename(old_dir, old_dentry, new_dir, new_dentry);
+
+	return ext4_simple_rename(old_dir, old_dentry,
+				  new_dir, new_dentry, flags);
 }
 
 /*
diff --git a/fs/namei.c b/fs/namei.c
index 413d7c138e95..adaa73d91173 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4186,12 +4186,16 @@ SYSCALL_DEFINE5(renameat2, int, olddfd, const char __user *, oldname,
 	bool should_retry = false;
 	int error;
 
-	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
 		return -EINVAL;
 
-	if ((flags & RENAME_NOREPLACE) && (flags & RENAME_EXCHANGE))
+	if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
+	    (flags & RENAME_EXCHANGE))
 		return -EINVAL;
 
+	if ((flags & RENAME_WHITEOUT) && !capable(CAP_MKNOD))
+		return -EPERM;
+
 retry:
 	from = user_path_parent(olddfd, oldname, &oldnd, lookup_flags);
 	if (IS_ERR(from)) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 88ec7a2878bc..48d3bd908b5d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -228,6 +228,13 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define WHITEOUT_DEV 0
 
 /*
+ * Whiteout is represented by a char device.  The following constants define the
+ * mode and device number to use.
+ */
+#define WHITEOUT_MODE 0
+#define WHITEOUT_DEV 0
+
+/*
  * This is the Inode Attributes structure, used for notify_change().  It
  * uses the above definitions as flags, to know which values have changed.
  * Also, in this manner, a Filesystem can look at only the values it cares
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index ca1a11bb4443..3735fa0a6784 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -37,6 +37,7 @@
 
 #define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
 #define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
+#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
 
 struct fstrim_range {
 	__u64 start;
-- 
1.8.1.4

