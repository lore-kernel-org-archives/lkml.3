Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbbAZPKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:10:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:58362 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752730AbbAZPKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:10:02 -0500
Message-Id: <20150126150959.523459056@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 26 Jan 2015 10:09:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 05/16 v3] debugfs_mknod(): get rid useless arguments
References: <20150126150913.653681560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-debugfs_mknod-get-rid-useless-arguments.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

dev is always zero, dir was only used to get its ->i_sb, which is
equal to ->d_sb of dentry...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index c69e00d69ff1..bc02e2096977 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -70,23 +70,18 @@ static struct inode *debugfs_get_inode(struct super_block *sb, umode_t mode, dev
 }
 
 /* SMP-safe */
-static int debugfs_mknod(struct inode *dir, struct dentry *dentry,
-			 umode_t mode, dev_t dev, void *data,
+static int debugfs_mknod(struct dentry *dentry,
+			 umode_t mode, void *data,
 			 const struct file_operations *fops)
 {
 	struct inode *inode;
-	int error = -EPERM;
 
-	if (dentry->d_inode)
-		return -EEXIST;
-
-	inode = debugfs_get_inode(dir->i_sb, mode, dev, data, fops);
-	if (inode) {
-		d_instantiate(dentry, inode);
-		dget(dentry);
-		error = 0;
-	}
-	return error;
+	inode = debugfs_get_inode(dentry->d_sb, mode, 0, data, fops);
+	if (unlikely(!inode))
+		return -EPERM;
+	d_instantiate(dentry, inode);
+	dget(dentry);
+	return 0;
 }
 
 static int debugfs_mkdir(struct dentry *dentry, umode_t mode)
@@ -95,7 +90,7 @@ static int debugfs_mkdir(struct dentry *dentry, umode_t mode)
 	int res;
 
 	mode = (mode & (S_IRWXUGO | S_ISVTX)) | S_IFDIR;
-	res = debugfs_mknod(dir, dentry, mode, 0, NULL, NULL);
+	res = debugfs_mknod(dentry, mode, NULL, NULL);
 	if (!res) {
 		inc_nlink(dir);
 		fsnotify_mkdir(dir, dentry);
@@ -110,7 +105,7 @@ static int debugfs_create(struct dentry *dentry, umode_t mode,
 	int res;
 
 	mode = (mode & S_IALLUGO) | S_IFREG;
-	res = debugfs_mknod(dir, dentry, mode, 0, data, fops);
+	res = debugfs_mknod(dentry, mode, data, fops);
 	if (!res)
 		fsnotify_create(dir, dentry);
 	return res;
@@ -458,8 +453,7 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 		return NULL;
 	}
 
-	error = debugfs_mknod(dentry->d_parent->d_inode, dentry,
-			      S_IFLNK | S_IRWXUGO, 0, link, NULL);
+	error = debugfs_mknod(dentry, S_IFLNK | S_IRWXUGO, link, NULL);
 	if (error)
 		kfree(link);
 
-- 
2.1.4


