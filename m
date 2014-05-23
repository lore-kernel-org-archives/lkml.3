Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaEWJsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:48:30 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:49474 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaEWJn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:43:56 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@gmail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 01/13] vfs: add i_op->dentry_open()
Date: Fri, 23 May 2014 11:43:31 +0200
Message-Id: <1400838223-30844-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new inode operation i_op->dentry_open().  This is for stacked filesystems
that want to return a struct file from a different filesystem.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 Documentation/filesystems/Locking |  2 ++
 Documentation/filesystems/vfs.txt |  7 +++++++
 fs/namei.c                        |  9 ++++++---
 fs/open.c                         | 23 +++++++++++++++++++++--
 include/linux/fs.h                |  2 ++
 5 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index eba790134253..09a7b57d2f47 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -67,6 +67,7 @@ prototypes:
 				struct file *, unsigned open_flag,
 				umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
+	int (*dentry_open)(struct dentry *, struct file *, const struct cred *);
 
 locking rules:
 	all may block
@@ -96,6 +97,7 @@ fiemap:		no
 update_time:	no
 atomic_open:	yes
 tmpfile:	no
+dentry_open:	no
 
 	Additionally, ->rmdir(), ->unlink() and ->rename() have ->i_mutex on
 victim.
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 617f6d70c077..938aea64b2fa 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -364,6 +364,7 @@ struct inode_operations {
 	int (*atomic_open)(struct inode *, struct dentry *, struct file *,
 			unsigned open_flag, umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
+	int (*dentry_open)(struct dentry *, struct file *, const struct cred *);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -697,6 +698,12 @@ struct address_space_operations {
   	but instead uses bmap to find out where the blocks in the file
   	are and uses those addresses directly.
 
+  dentry_open: this is an alternative to f_op->open(), the difference is that
+	this method may open a file not necessarily originating from the same
+	filesystem as the one i_op->open() was called on.  It may be
+	useful for stacking filesystems which want to allow native I/O directly
+	on underlying files.
+
 
   invalidatepage: If a page has PagePrivate set, then invalidatepage
         will be called when part or all of the page is to be removed
diff --git a/fs/namei.c b/fs/namei.c
index 80168273396b..a7cf0fb1f638 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3046,9 +3046,12 @@ finish_open_created:
 	error = may_open(&nd->path, acc_mode, open_flag);
 	if (error)
 		goto out;
-	file->f_path.mnt = nd->path.mnt;
-	error = finish_open(file, nd->path.dentry, NULL, opened);
-	if (error) {
+
+	BUG_ON(*opened & FILE_OPENED); /* once it's opened, it's opened */
+	error = vfs_open(&nd->path, file, current_cred());
+	if (!error) {
+		*opened |= FILE_OPENED;
+	} else {
 		if (error == -EOPENSTALE)
 			goto stale_open;
 		goto out;
diff --git a/fs/open.c b/fs/open.c
index 9d64679cec73..3302cd25403f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -818,8 +818,7 @@ struct file *dentry_open(const struct path *path, int flags,
 	f = get_empty_filp();
 	if (!IS_ERR(f)) {
 		f->f_flags = flags;
-		f->f_path = *path;
-		error = do_dentry_open(f, NULL, cred);
+		error = vfs_open(path, f, cred);
 		if (!error) {
 			/* from now on we need fput() to dispose of f */
 			error = open_check_o_direct(f);
@@ -836,6 +835,26 @@ struct file *dentry_open(const struct path *path, int flags,
 }
 EXPORT_SYMBOL(dentry_open);
 
+/**
+ * vfs_open - open the file at the given path
+ * @path: path to open
+ * @filp: newly allocated file with f_flag initialized
+ * @cred: credentials to use
+ */
+int vfs_open(const struct path *path, struct file *filp,
+	     const struct cred *cred)
+{
+	struct inode *inode = path->dentry->d_inode;
+
+	if (inode->i_op->dentry_open)
+		return inode->i_op->dentry_open(path->dentry, filp, cred);
+	else {
+		filp->f_path = *path;
+		return do_dentry_open(filp, NULL, cred);
+	}
+}
+EXPORT_SYMBOL(vfs_open);
+
 static inline int build_open_flags(int flags, umode_t mode, struct open_flags *op)
 {
 	int lookup_flags = 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 878031227c57..d38875d70db2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1513,6 +1513,7 @@ struct inode_operations {
 			   umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
+	int (*dentry_open)(struct dentry *, struct file *, const struct cred *);
 } ____cacheline_aligned;
 
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
@@ -2018,6 +2019,7 @@ extern struct file *file_open_name(struct filename *, int, umode_t);
 extern struct file *filp_open(const char *, int, umode_t);
 extern struct file *file_open_root(struct dentry *, struct vfsmount *,
 				   const char *, int);
+extern int vfs_open(const struct path *, struct file *, const struct cred *);
 extern struct file * dentry_open(const struct path *, int, const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
 
-- 
1.8.1.4

