Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbbAZPLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:11:53 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:41745 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753448AbbAZPKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:10:03 -0500
Message-Id: <20150126151000.193295757@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 26 Jan 2015 10:09:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 09/16 v3] debugfs: take mode-dependent parts of debugfs_get_inode() into
 callers
References: <20150126150913.653681560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0009-debugfs-take-mode-dependent-parts-of-debugfs_get_ino.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

... and trim the arguments list

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 48 ++++++++++++++++--------------------------------
 1 file changed, 16 insertions(+), 32 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index b765c04eba20..61e9a6815a19 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -34,37 +34,12 @@ static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
 static bool debugfs_registered;
 
-static struct inode *debugfs_get_inode(struct super_block *sb, umode_t mode, dev_t dev,
-				       void *data, const struct file_operations *fops)
-
+static struct inode *debugfs_get_inode(struct super_block *sb)
 {
 	struct inode *inode = new_inode(sb);
-
 	if (inode) {
 		inode->i_ino = get_next_ino();
-		inode->i_mode = mode;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-		switch (mode & S_IFMT) {
-		default:
-			init_special_inode(inode, mode, dev);
-			break;
-		case S_IFREG:
-			inode->i_fop = fops ? fops : &debugfs_file_operations;
-			inode->i_private = data;
-			break;
-		case S_IFLNK:
-			inode->i_op = &debugfs_link_operations;
-			inode->i_private = data;
-			break;
-		case S_IFDIR:
-			inode->i_op = &simple_dir_inode_operations;
-			inode->i_fop = &simple_dir_operations;
-
-			/* directory inodes start off with i_nlink == 2
-			 * (for "." entry) */
-			inc_nlink(inode);
-			break;
-		}
 	}
 	return inode;
 }
@@ -334,10 +309,13 @@ struct dentry *debugfs_create_file(const char *name, umode_t mode,
 	if (IS_ERR(dentry))
 		return NULL;
 
-	inode = debugfs_get_inode(dentry->d_sb, mode, 0, data, fops);
+	inode = debugfs_get_inode(dentry->d_sb);
 	if (unlikely(!inode))
 		return end_creating(dentry, -ENOMEM);
 
+	inode->i_mode = mode;
+	inode->i_fop = fops ? fops : &debugfs_file_operations;
+	inode->i_private = data;
 	d_instantiate(dentry, inode);
 	dget(dentry);
 	fsnotify_create(dentry->d_parent->d_inode, dentry);
@@ -371,12 +349,16 @@ struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 	if (IS_ERR(dentry))
 		return NULL;
 
-	inode = debugfs_get_inode(dentry->d_sb,
-				  S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
-				  0, NULL, NULL);
+	inode = debugfs_get_inode(dentry->d_sb);
 	if (unlikely(!inode))
 		return end_creating(dentry, -ENOMEM);
 
+	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
+	inode->i_op = &simple_dir_inode_operations;
+	inode->i_fop = &simple_dir_operations;
+
+	/* directory inodes start off with i_nlink == 2 (for "." entry) */
+	inc_nlink(inode);
 	d_instantiate(dentry, inode);
 	dget(dentry);
 	inc_nlink(dentry->d_parent->d_inode);
@@ -423,12 +405,14 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 		return NULL;
 	}
 
-	inode = debugfs_get_inode(dentry->d_sb, S_IFLNK | S_IRWXUGO, 0,
-				  link, NULL);
+	inode = debugfs_get_inode(dentry->d_sb);
 	if (unlikely(!inode)) {
 		kfree(link);
 		return end_creating(dentry, -ENOMEM);
 	}
+	inode->i_mode = S_IFLNK | S_IRWXUGO;
+	inode->i_op = &debugfs_link_operations;
+	inode->i_private = link;
 	d_instantiate(dentry, inode);
 	dget(dentry);
 	return end_creating(dentry, 0);
-- 
2.1.4


