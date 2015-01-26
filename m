Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbbAZPMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:12:40 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:9851 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753420AbbAZPKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:10:02 -0500
Message-Id: <20150126151000.382230852@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 26 Jan 2015 10:09:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 10/16 v3] debugfs: split end_creating() into success and failure cases
References: <20150126150913.653681560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0010-debugfs-split-end_creating-into-success-and-failure-.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

... and don't bother with dput(dentry) in the former and with
dget(dentry) preceding all its calls.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 61e9a6815a19..1219dff8e18f 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -256,15 +256,17 @@ static struct dentry *start_creating(const char *name, struct dentry *parent)
 	return dentry;
 }
 
-static struct dentry *end_creating(struct dentry *dentry, int error)
+static struct dentry *failed_creating(struct dentry *dentry)
 {
 	mutex_unlock(&dentry->d_parent->d_inode->i_mutex);
 	dput(dentry);
+	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
+	return NULL;
+}
 
-	if (error) {
-		dentry = NULL;
-		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
-	}
+static struct dentry *end_creating(struct dentry *dentry)
+{
+	mutex_unlock(&dentry->d_parent->d_inode->i_mutex);
 	return dentry;
 }
 
@@ -311,15 +313,14 @@ struct dentry *debugfs_create_file(const char *name, umode_t mode,
 
 	inode = debugfs_get_inode(dentry->d_sb);
 	if (unlikely(!inode))
-		return end_creating(dentry, -ENOMEM);
+		return failed_creating(dentry);
 
 	inode->i_mode = mode;
 	inode->i_fop = fops ? fops : &debugfs_file_operations;
 	inode->i_private = data;
 	d_instantiate(dentry, inode);
-	dget(dentry);
 	fsnotify_create(dentry->d_parent->d_inode, dentry);
-	return end_creating(dentry, 0);
+	return end_creating(dentry);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_file);
 
@@ -351,7 +352,7 @@ struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 
 	inode = debugfs_get_inode(dentry->d_sb);
 	if (unlikely(!inode))
-		return end_creating(dentry, -ENOMEM);
+		return failed_creating(dentry);
 
 	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
 	inode->i_op = &simple_dir_inode_operations;
@@ -360,10 +361,9 @@ struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
 	d_instantiate(dentry, inode);
-	dget(dentry);
 	inc_nlink(dentry->d_parent->d_inode);
 	fsnotify_mkdir(dentry->d_parent->d_inode, dentry);
-	return end_creating(dentry, 0);
+	return end_creating(dentry);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_dir);
 
@@ -408,14 +408,13 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 	inode = debugfs_get_inode(dentry->d_sb);
 	if (unlikely(!inode)) {
 		kfree(link);
-		return end_creating(dentry, -ENOMEM);
+		return failed_creating(dentry);
 	}
 	inode->i_mode = S_IFLNK | S_IRWXUGO;
 	inode->i_op = &debugfs_link_operations;
 	inode->i_private = link;
 	d_instantiate(dentry, inode);
-	dget(dentry);
-	return end_creating(dentry, 0);
+	return end_creating(dentry);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_symlink);
 
-- 
2.1.4


