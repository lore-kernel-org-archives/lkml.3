Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaJCVea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:34:30 -0400
Received: from mout.gmx.net ([212.227.15.19]:61336 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbaJCVe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:34:26 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, Jan Kara <jack@suse.cz>,
        Eric Paris <eparis@parisplace.org>,
        John McCutchon <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] truncate: generate fanotify and inotify events
Date: Fri,  3 Oct 2014 23:33:16 +0200
Message-Id: <1412371996-1265-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.1.0
X-Provags-ID: V03:K0:jO8fuOSP+6eyFbriIdo4sL6RwBoKDE+bsyfY8INzXKK+w8z8j3p
 IUZrTL3dCcyHd1bOoiwuKiP8DaVWBXPZ20IbEVUyNoaOH0bUzuRQDSqzZp1dpU2U1vJmdL2
 1ymu/T5HqSSEbZrl28NmqXpdHp9RO1E4up9oy6IhsqA/tDrgeiQP7enlxxlO0QnPGcnAOwo
 ZklsTtTeQ0un6+Pwv2Q5A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fanotify and the inotify API can be used to monitor changes of the file
system.

System call truncate modifies files. Hence it should trigger the corresponding
fanotify and inotify events.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 fs/open.c                |  5 +++
 include/linux/fsnotify.h | 87 ++++++++++++++++++++++++++++++++----------------
 security/security.c      |  7 +++-
 3 files changed, 70 insertions(+), 29 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index d6fd3ac..be45e58 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -104,12 +104,17 @@ long vfs_truncate(struct path *path, loff_t length)
 	if (!error)
 		error = security_path_truncate(path);
 	if (!error)
+		fsnotify_open_path(path);
 		error = do_truncate(path->dentry, length, 0, NULL);
+	if (!error)
+		fsnotify_modify_path(path);
 
 put_write_and_out:
 	put_write_access(inode);
 mnt_drop_write_and_out:
 	mnt_drop_write(path->mnt);
+	if (!error)
+		fsnotify_close_path(path, FMODE_WRITE);
 out:
 	return error;
 }
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 1c804b0..24f55b3 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -34,16 +34,15 @@ static inline int fsnotify_parent(struct path *path, struct dentry *dentry, __u3
 	return __fsnotify_parent(path, dentry, mask);
 }
 
-/* simple call site for access decisions */
-static inline int fsnotify_perm(struct file *file, int mask)
+/*
+ * fsnotify_perm_path - make access decision for path
+ */
+static inline int fsnotify_perm_path(struct path *path, int mask)
 {
-	struct path *path = &file->f_path;
-	struct inode *inode = file_inode(file);
+	struct inode *inode = path->dentry->d_inode;
 	__u32 fsnotify_mask = 0;
 	int ret;
 
-	if (file->f_mode & FMODE_NONOTIFY)
-		return 0;
 	if (!(mask & (MAY_READ | MAY_OPEN)))
 		return 0;
 	if (mask & MAY_OPEN)
@@ -57,7 +56,17 @@ static inline int fsnotify_perm(struct file *file, int mask)
 	if (ret)
 		return ret;
 
-	return fsnotify(inode, fsnotify_mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
+	return fsnotify(inode, fsnotify_mask, path,
+		FSNOTIFY_EVENT_PATH, NULL, 0);
+}
+
+/* simple call site for access decisions */
+static inline int fsnotify_perm(struct file *file, int mask)
+{
+	if (file->f_mode & FMODE_NONOTIFY)
+		return 0;
+
+	return fsnotify_perm_path(&file->f_path, mask);
 }
 
 /*
@@ -205,30 +214,37 @@ static inline void fsnotify_access(struct file *file)
 }
 
 /*
- * fsnotify_modify - file was modified
+ * fsnotify_modify_path - file was modified
  */
-static inline void fsnotify_modify(struct file *file)
+static inline void fsnotify_modify_path(struct path *path)
 {
-	struct path *path = &file->f_path;
-	struct inode *inode = file_inode(file);
+	struct inode *inode = path->dentry->d_inode;
 	__u32 mask = FS_MODIFY;
 
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_ISDIR;
 
-	if (!(file->f_mode & FMODE_NONOTIFY)) {
-		fsnotify_parent(path, NULL, mask);
-		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
-	}
+	fsnotify_parent(path, NULL, mask);
+	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
 }
 
 /*
- * fsnotify_open - file was opened
+ * fsnotify_modify - file was modified
  */
-static inline void fsnotify_open(struct file *file)
+static inline void fsnotify_modify(struct file *file)
 {
-	struct path *path = &file->f_path;
-	struct inode *inode = file_inode(file);
+	if (file->f_mode & FMODE_NONOTIFY)
+		return;
+
+	fsnotify_modify_path(&file->f_path);
+}
+
+/*
+ * fsnotify_open_path - file was opened
+ */
+static inline void fsnotify_open_path(struct path *path)
+{
+	struct inode *inode = path->dentry->d_inode;
 	__u32 mask = FS_OPEN;
 
 	if (S_ISDIR(inode->i_mode))
@@ -239,22 +255,37 @@ static inline void fsnotify_open(struct file *file)
 }
 
 /*
- * fsnotify_close - file was closed
+ * fsnotify_open - file was opened
  */
-static inline void fsnotify_close(struct file *file)
+static inline void fsnotify_open(struct file *file)
 {
-	struct path *path = &file->f_path;
-	struct inode *inode = file_inode(file);
-	fmode_t mode = file->f_mode;
+	fsnotify_open_path(&file->f_path);
+}
+
+/*
+ * fsnotify_close_path - file was closed
+ */
+static inline void fsnotify_close_path(struct path *path, fmode_t mode)
+{
+	struct inode *inode = path->dentry->d_inode;
 	__u32 mask = (mode & FMODE_WRITE) ? FS_CLOSE_WRITE : FS_CLOSE_NOWRITE;
 
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_ISDIR;
 
-	if (!(file->f_mode & FMODE_NONOTIFY)) {
-		fsnotify_parent(path, NULL, mask);
-		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
-	}
+	fsnotify_parent(path, NULL, mask);
+	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
+}
+
+/*
+ * fsnotify_close - file was closed
+ */
+static inline void fsnotify_close(struct file *file)
+{
+	if (file->f_mode & FMODE_NONOTIFY)
+		return;
+
+	fsnotify_close_path(&file->f_path, file->f_mode);
 }
 
 /*
diff --git a/security/security.c b/security/security.c
index e41b1a8..45ded0c 100644
--- a/security/security.c
+++ b/security/security.c
@@ -454,9 +454,14 @@ EXPORT_SYMBOL(security_path_rename);
 
 int security_path_truncate(struct path *path)
 {
+	int ret;
+
 	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->path_truncate(path);
+	ret = security_ops->path_truncate(path);
+	if (ret)
+		return ret;
+	return fsnotify_perm_path(path, MAY_OPEN);
 }
 
 int security_path_chmod(struct path *path, umode_t mode)
-- 
2.1.0

