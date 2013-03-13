Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666Ab3CMORN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:17:13 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:41210 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933210Ab3CMORE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:17:04 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 6/9] overlayfs: add statfs support
Date: Wed, 13 Mar 2013 15:16:30 +0100
Message-Id: <1363184193-1796-7-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

Add support for statfs to the overlayfs filesystem.  As the upper layer
is the target of all write operations assume that the space in that
filesystem is the space in the overlayfs.  There will be some inaccuracy as
overwriting a file will copy it up and consume space we were not expecting,
but it is better than nothing.

Use the upper layer dentry and mount from the overlayfs root inode,
passing the statfs call to that filesystem.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/dir.c       |    2 ++
 fs/overlayfs/inode.c     |    2 ++
 fs/overlayfs/overlayfs.h |    6 ++++++
 fs/overlayfs/super.c     |   41 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 51 insertions(+)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 5da5be3..f4969c1 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -304,6 +304,7 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 		}
 	}
 	ovl_dentry_update(dentry, newdentry);
+	ovl_copyattr(newdentry->d_inode, inode);
 	d_instantiate(dentry, inode);
 	inode = NULL;
 	newdentry = NULL;
@@ -448,6 +449,7 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 			err = -ENOMEM;
 			goto link_fail;
 		}
+		ovl_copyattr(upperdir->d_inode, newinode);
 
 		ovl_dentry_version_inc(new->d_parent);
 		ovl_dentry_update(new, newdentry);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 3218a38..ee37e92 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -31,6 +31,8 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 
 	mutex_lock(&upperdentry->d_inode->i_mutex);
 	err = notify_change(upperdentry, attr);
+	if (!err)
+		ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
 	mutex_unlock(&upperdentry->d_inode->i_mutex);
 
 	return err;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index fe1241d..1cba38f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -56,6 +56,12 @@ int ovl_removexattr(struct dentry *dentry, const char *name);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
 			    struct ovl_entry *oe);
+static inline void ovl_copyattr(struct inode *from, struct inode *to)
+{
+	to->i_uid = from->i_uid;
+	to->i_gid = from->i_gid;
+}
+
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4bcb98f..bc22c2d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -17,15 +17,19 @@
 #include <linux/module.h>
 #include <linux/cred.h>
 #include <linux/sched.h>
+#include <linux/statfs.h>
 #include "overlayfs.h"
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Overlay filesystem");
 MODULE_LICENSE("GPL");
 
+#define OVERLAYFS_SUPER_MAGIC 0x794c764f
+
 struct ovl_fs {
 	struct vfsmount *upper_mnt;
 	struct vfsmount *lower_mnt;
+	long lower_namelen;
 };
 
 struct ovl_entry {
@@ -333,6 +337,7 @@ static int ovl_do_lookup(struct dentry *dentry)
 				      oe);
 		if (!inode)
 			goto out_dput;
+		ovl_copyattr(realdentry->d_inode, inode);
 	}
 
 	if (upperdentry)
@@ -406,9 +411,36 @@ static int ovl_remount_fs(struct super_block *sb, int *flagsp, char *data)
 		return mnt_want_write(ufs->upper_mnt);
 }
 
+/**
+ * ovl_statfs
+ * @sb: The overlayfs super block
+ * @buf: The struct kstatfs to fill in with stats
+ *
+ * Get the filesystem statistics.  As writes always target the upper layer
+ * filesystem pass the statfs to the same filesystem.
+ */
+static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	struct dentry *root_dentry = dentry->d_sb->s_root;
+	struct path path;
+	int err;
+
+	ovl_path_upper(root_dentry, &path);
+
+	err = vfs_statfs(&path, buf);
+	if (!err) {
+		buf->f_namelen = max(buf->f_namelen, ofs->lower_namelen);
+		buf->f_type = OVERLAYFS_SUPER_MAGIC;
+	}
+
+	return err;
+}
+
 static const struct super_operations ovl_super_operations = {
 	.put_super	= ovl_put_super,
 	.remount_fs	= ovl_remount_fs,
+	.statfs		= ovl_statfs,
 };
 
 struct ovl_config {
@@ -474,6 +506,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	struct ovl_entry *oe;
 	struct ovl_fs *ufs;
 	struct ovl_config config;
+	struct kstatfs statfs;
 	int err;
 
 	err = ovl_parse_opt((char *) data, &config);
@@ -508,6 +541,13 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	    !S_ISDIR(lowerpath.dentry->d_inode->i_mode))
 		goto out_put_lowerpath;
 
+	err = vfs_statfs(&lowerpath, &statfs);
+	if (err) {
+		pr_err("overlayfs: statfs failed on lowerpath\n");
+		goto out_put_lowerpath;
+	}
+	ufs->lower_namelen = statfs.f_namelen;
+
 	ufs->upper_mnt = clone_private_mount(&upperpath);
 	err = PTR_ERR(ufs->upper_mnt);
 	if (IS_ERR(ufs->upper_mnt)) {
@@ -556,6 +596,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	root_dentry->d_fsdata = oe;
 	root_dentry->d_op = &ovl_dentry_operations;
 
+	sb->s_magic = OVERLAYFS_SUPER_MAGIC;
 	sb->s_op = &ovl_super_operations;
 	sb->s_root = root_dentry;
 	sb->s_fs_info = ufs;
-- 
1.7.10.4

