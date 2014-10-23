Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaJWVf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:35:57 -0400
Received: from mout.gmx.net ([212.227.15.18]:53917 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaJWVfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:35:55 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@parisplace.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH v2 1/1] ftruncate, truncate: create fanotify events
Date: Thu, 23 Oct 2014 23:35:07 +0200
Message-Id: <1414100107-3750-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <20141007192330.GE30038@quack.suse.cz>
References: <20141007192330.GE30038@quack.suse.cz>
X-Provags-ID: V03:K0:XvpgYeFc0jO5/p+znxulxJuU7acut1bXoJSxuKeXWl7RE9mtShu
 xjN42yBBrtXZT06s+mffzPtO7qfC4wUMm6hGQ3de8hBLmbpRj8u28KDWdWMXMwVlM0ea2n2
 ul48tEIOfNFaV5hCYmemEG9EYyddRsB/fnY7jz7seZLhfrRAB3qSFClCcW7pRi5cca0/QKS
 aYvwd5NmQMjjdDFxxhBCg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

:: On Tue, 7 Oct 2014 21:23:30 Jan Kara wrote:
::
::   Yeah, so the reason why we don't generate FSNOTIFY_EVENT_PATH in
:: notify_change() is because we have only dentry available there. OTOH from a
:: quick look it doesn't look impossible to pass path there from the callers.
:: So I'd rather propagate path to notify_change() and generate also fanotify
:: events there than generating truncate events for fanotify separately
:: somewhere else...

The attached second version of the patch follows this idea of Jan.

The fanotify and fanotify API can be used to monitor changes of the file
system.

System calls ftruncate and truncate  modify files. Hence they should trigger
the corresponding fanotify (FAN_MODIFY) event.

Prior to the patch only a inotify (IN_MODIFY) event is triggered because
the path information is not passed to the notification framework.

The patch changes the interface of fsnotify_change to allow path information
to be passed. Fsnotify_change is only called by notify_change and by
fat_ioctl_set_attributes.

notify_change is called by a larger number of callers. Not all of these
have access to path object. To limit the number of changes the patch renames
notify_change to do_notify_change and adds a path parameter. The patch further
adds two wrappers: notify_change for callers that cannot provide a path
and notify_change_path for callers that can provide a path.

The patch changes do_truncate to accept a path parameter passed to
notify_change_path and adjusts all callers of do_truncate.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 fs/attr.c                | 35 ++++++++++++++++++++++++++++++++---
 fs/fat/file.c            |  2 +-
 fs/namei.c               |  2 +-
 fs/open.c                | 10 ++++++----
 include/linux/fs.h       |  3 ++-
 include/linux/fsnotify.h | 12 +++++++++---
 6 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 6530ced..894967e 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -168,13 +168,17 @@ void setattr_copy(struct inode *inode, const struct iattr *attr)
 EXPORT_SYMBOL(setattr_copy);
 
 /**
- * notify_change - modify attributes of a filesytem object
+ * do_notify_change - modify attributes of a filesytem object
+ * @path:	path of object affected
  * @dentry:	object affected
  * @iattr:	new attributes
  * @delegated_inode: returns inode, if the inode is delegated
  *
  * The caller must hold the i_mutex on the affected object.
  *
+ * If NULL is passed in attribute path, fanotify events cannot be
+ * created.
+ *
  * If notify_change discovers a delegation in need of breaking,
  * it will return -EWOULDBLOCK and return a reference to the inode in
  * delegated_inode.  The caller should then break the delegation and
@@ -187,7 +191,8 @@ EXPORT_SYMBOL(setattr_copy);
  * the file open for write, as there can be no conflicting delegation in
  * that case.
  */
-int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **delegated_inode)
+int do_notify_change(struct path *path, struct dentry *dentry,
+	struct iattr *attr, struct inode **delegated_inode)
 {
 	struct inode *inode = dentry->d_inode;
 	umode_t mode = inode->i_mode;
@@ -268,11 +273,35 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
 		error = simple_setattr(dentry, attr);
 
 	if (!error) {
-		fsnotify_change(dentry, ia_valid);
+		fsnotify_change(path, dentry, ia_valid);
 		ima_inode_post_setattr(dentry);
 		evm_inode_post_setattr(dentry, ia_valid);
 	}
 
 	return error;
 }
+
+/*
+ * notify_change - modify attributes of a filesytem object
+ *
+ * This call will not create fanotify events. It should be replaced by
+ * notify_change_path where possible.
+ */
+int notify_change(struct dentry *dentry, struct iattr *attr,
+	struct inode **delegated_inode)
+{
+	return do_notify_change(NULL, dentry, attr, delegated_inode);
+}
 EXPORT_SYMBOL(notify_change);
+
+/*
+ * notify_change_path - modify attributes of a filesytem object
+ *
+ * This call is a replacement for notify_change. It creates fanotify events.
+ */
+int notify_change_path(struct path *path, struct iattr *attr,
+	struct inode **delegated_inode)
+{
+	return do_notify_change(path, path->dentry, attr, delegated_inode);
+}
+EXPORT_SYMBOL(notify_change_path);
diff --git a/fs/fat/file.c b/fs/fat/file.c
index f2c73ae..d293a0b 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -101,7 +101,7 @@ static int fat_ioctl_set_attributes(struct file *file, u32 __user *user_attr)
 	if (err)
 		goto out_unlock_inode;
 
-	fsnotify_change(file->f_path.dentry, ia.ia_valid);
+	fsnotify_change(&file->f_path, file->f_path.dentry, ia.ia_valid);
 	if (sbi->options.sys_immutable) {
 		if (attr & ATTR_SYS)
 			inode->i_flags |= S_IMMUTABLE;
diff --git a/fs/namei.c b/fs/namei.c
index 43927d1..0a1f3b7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2603,7 +2603,7 @@ static int handle_truncate(struct file *filp)
 	if (!error)
 		error = security_path_truncate(path);
 	if (!error) {
-		error = do_truncate(path->dentry, 0,
+		error = do_truncate(path, 0,
 				    ATTR_MTIME|ATTR_CTIME|ATTR_OPEN,
 				    filp);
 	}
diff --git a/fs/open.c b/fs/open.c
index d6fd3ac..390e322 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -34,11 +34,12 @@
 
 #include "internal.h"
 
-int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
+int do_truncate(struct path *path, loff_t length, unsigned int time_attrs,
 	struct file *filp)
 {
 	int ret;
 	struct iattr newattrs;
+	struct dentry *dentry = path->dentry;
 
 	/* Not pretty: "inode->i_size" shouldn't really be signed. But it is. */
 	if (length < 0)
@@ -58,7 +59,7 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 
 	mutex_lock(&dentry->d_inode->i_mutex);
 	/* Note any delegations or leases have already been broken: */
-	ret = notify_change(dentry, &newattrs, NULL);
+	ret = notify_change_path(path, &newattrs, NULL);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	return ret;
 }
@@ -104,7 +105,7 @@ long vfs_truncate(struct path *path, loff_t length)
 	if (!error)
 		error = security_path_truncate(path);
 	if (!error)
-		error = do_truncate(path->dentry, length, 0, NULL);
+		error = do_truncate(path, length, 0, NULL);
 
 put_write_and_out:
 	put_write_access(inode);
@@ -188,7 +189,8 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 	if (!error)
 		error = security_path_truncate(&f.file->f_path);
 	if (!error)
-		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, f.file);
+		error = do_truncate(&f.file->f_path, length,
+				ATTR_MTIME|ATTR_CTIME, f.file);
 	sb_end_write(inode->i_sb);
 out_putf:
 	fdput(f);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4111ee0..e5b0b05 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2031,7 +2031,7 @@ struct filename {
 };
 
 extern long vfs_truncate(struct path *, loff_t);
-extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
+extern int do_truncate(struct path *, loff_t start, unsigned int time_attrs,
 		       struct file *filp);
 extern int do_fallocate(struct file *file, int mode, loff_t offset,
 			loff_t len);
@@ -2253,6 +2253,7 @@ extern void emergency_remount(void);
 extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *, struct inode **);
+extern int notify_change_path(struct path *, struct iattr *, struct inode **);
 extern int inode_permission(struct inode *, int);
 extern int generic_permission(struct inode *, int);
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 1c804b0..0fd594b 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -276,7 +276,8 @@ static inline void fsnotify_xattr(struct dentry *dentry)
  * fsnotify_change - notify_change event.  file was modified and/or metadata
  * was changed.
  */
-static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
+static inline void fsnotify_change(struct path *path, struct dentry *dentry,
+	unsigned int ia_valid)
 {
 	struct inode *inode = dentry->d_inode;
 	__u32 mask = 0;
@@ -303,8 +304,13 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 		if (S_ISDIR(inode->i_mode))
 			mask |= FS_ISDIR;
 
-		fsnotify_parent(NULL, dentry, mask);
-		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+		fsnotify_parent(path, dentry, mask);
+		if (path == NULL)
+			fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE,
+				NULL, 0);
+		else
+			fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH,
+				NULL, 0);
 	}
 }
 
-- 
2.1.1

