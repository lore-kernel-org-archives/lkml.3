Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaEWJp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:45:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58959 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaEWJoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:44:15 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@gmail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz,
        Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 10/13] overlayfs: implement show_options
Date: Fri, 23 May 2014 11:43:40 +0200
Message-Id: <1400838223-30844-11-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@fsl.cs.sunysb.edu>

This is useful because of the stacking nature of overlayfs.  Users like to
find out (via /proc/mounts) which lower/upper directory were used at mount
time.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/super.c | 76 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 25 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 8b77f3f45579..fcbd92a14e69 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/statfs.h>
+#include <linux/seq_file.h>
 #include "overlayfs.h"
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
@@ -25,13 +26,23 @@ MODULE_LICENSE("GPL");
 
 #define OVERLAYFS_SUPER_MAGIC 0x794c764f
 
+struct ovl_config {
+	char *lowerdir;
+	char *upperdir;
+	char *workdir;
+};
+
+/* private information held for overlayfs's superblock */
 struct ovl_fs {
 	struct vfsmount *upper_mnt;
 	struct vfsmount *lower_mnt;
 	struct dentry *workdir;
 	long lower_namelen;
+	/* pathnames of lower and upper dirs, for show_options */
+	struct ovl_config config;
 };
 
+/* private information held for every overlayfs dentry */
 struct ovl_entry {
 	/*
 	 * Keep "double reference" on upper dentries, so that
@@ -373,6 +384,9 @@ static void ovl_put_super(struct super_block *sb)
 	mntput(ufs->upper_mnt);
 	mntput(ufs->lower_mnt);
 
+	kfree(ufs->config.lowerdir);
+	kfree(ufs->config.upperdir);
+	kfree(ufs->config.workdir);
 	kfree(ufs);
 }
 
@@ -421,16 +435,28 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return err;
 }
 
+/**
+ * ovl_show_options
+ *
+ * Prints the mount options for a given superblock.
+ * Returns zero; does not fail.
+ */
+static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
+{
+	struct super_block *sb = dentry->d_sb;
+	struct ovl_fs *ufs = sb->s_fs_info;
+
+	seq_printf(m, ",lowerdir=%s", ufs->config.lowerdir);
+	seq_printf(m, ",upperdir=%s", ufs->config.upperdir);
+	seq_printf(m, ",workdir=%s", ufs->config.workdir);
+	return 0;
+}
+
 static const struct super_operations ovl_super_operations = {
 	.put_super	= ovl_put_super,
 	.remount_fs	= ovl_remount_fs,
 	.statfs		= ovl_statfs,
-};
-
-struct ovl_config {
-	char *lowerdir;
-	char *upperdir;
-	char *workdir;
+	.show_options	= ovl_show_options,
 };
 
 enum {
@@ -558,38 +584,38 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	struct dentry *root_dentry;
 	struct ovl_entry *oe;
 	struct ovl_fs *ufs;
-	struct ovl_config config;
 	struct kstatfs statfs;
 	int err;
 
-	err = ovl_parse_opt((char *) data, &config);
-	if (err)
+	err = -ENOMEM;
+	ufs = kmalloc(sizeof(struct ovl_fs), GFP_KERNEL);
+	if (!ufs)
 		goto out;
 
+	err = ovl_parse_opt((char *) data, &ufs->config);
+	if (err)
+		goto out_free_ufs;
+
 	err = -EINVAL;
-	if (!config.upperdir || !config.lowerdir || !config.workdir) {
+	if (!ufs->config.upperdir || !ufs->config.lowerdir ||
+	    !ufs->config.workdir) {
 		pr_err("overlayfs: missing upperdir or lowerdir or workdir\n");
 		goto out_free_config;
 	}
 
-	err = -ENOMEM;
-	ufs = kmalloc(sizeof(struct ovl_fs), GFP_KERNEL);
-	if (!ufs)
-		goto out_free_config;
-
 	oe = ovl_alloc_entry();
 	if (oe == NULL)
-		goto out_free_ufs;
+		goto out_free_config;
 
-	err = ovl_mount_dir(config.upperdir, &upperpath);
+	err = ovl_mount_dir(ufs->config.upperdir, &upperpath);
 	if (err)
 		goto out_free_oe;
 
-	err = ovl_mount_dir(config.lowerdir, &lowerpath);
+	err = ovl_mount_dir(ufs->config.lowerdir, &lowerpath);
 	if (err)
 		goto out_put_upperpath;
 
-	err = ovl_mount_dir(config.workdir, &workpath);
+	err = ovl_mount_dir(ufs->config.workdir, &workpath);
 	if (err)
 		goto out_put_lowerpath;
 
@@ -614,7 +640,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	err = vfs_statfs(&lowerpath, &statfs);
 	if (err) {
 		pr_err("overlayfs: statfs failed on lowerpath\n");
-		goto out_put_lowerpath;
+		goto out_put_workpath;
 	}
 	ufs->lower_namelen = statfs.f_namelen;
 
@@ -636,7 +662,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	err = PTR_ERR(ufs->workdir);
 	if (IS_ERR(ufs->workdir)) {
 		pr_err("overlayfs: failed to create directory %s/%s\n",
-		       config.workdir, OVL_WORKDIR_NAME);
+		       ufs->config.workdir, OVL_WORKDIR_NAME);
 		goto out_put_lower_mnt;
 	}
 
@@ -702,12 +728,12 @@ out_put_upperpath:
 	path_put(&upperpath);
 out_free_oe:
 	kfree(oe);
+out_free_config:
+	kfree(ufs->config.lowerdir);
+	kfree(ufs->config.upperdir);
+	kfree(ufs->config.workdir);
 out_free_ufs:
 	kfree(ufs);
-out_free_config:
-	kfree(config.lowerdir);
-	kfree(config.upperdir);
-	kfree(config.workdir);
 out:
 	return err;
 }
-- 
1.8.1.4

