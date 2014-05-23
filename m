Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaEWJoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:44:21 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:53314 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaEWJoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:44:12 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@gmail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 09/13] overlayfs: add statfs support
Date: Fri, 23 May 2014 11:43:39 +0200
Message-Id: <1400838223-30844-10-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
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
 fs/overlayfs/super.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7c6b216ad6ca..8b77f3f45579 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -16,16 +16,20 @@
 #include <linux/parser.h>
 #include <linux/module.h>
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
 	struct dentry *workdir;
+	long lower_namelen;
 };
 
 struct ovl_entry {
@@ -391,9 +395,36 @@ static int ovl_remount_fs(struct super_block *sb, int *flagsp, char *data)
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
@@ -528,6 +559,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	struct ovl_entry *oe;
 	struct ovl_fs *ufs;
 	struct ovl_config config;
+	struct kstatfs statfs;
 	int err;
 
 	err = ovl_parse_opt((char *) data, &config);
@@ -579,6 +611,13 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_put_workpath;
 	}
 
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
@@ -639,6 +678,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	root_dentry->d_fsdata = oe;
 	root_dentry->d_op = &ovl_dentry_operations;
 
+	sb->s_magic = OVERLAYFS_SUPER_MAGIC;
 	sb->s_op = &ovl_super_operations;
 	sb->s_root = root_dentry;
 	sb->s_fs_info = ufs;
-- 
1.8.1.4

