Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbbAZPKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:10:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:49475 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752460AbbAZPKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:10:01 -0500
Message-Id: <20150126150959.036353160@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 26 Jan 2015 10:09:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 02/16 v3] debugfs: split the beginning and the end of __create_file() off
References: <20150126150913.653681560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-debugfs-split-the-beginning-and-the-end-of-__create_.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 61 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index adaaa04448b3..100186c2bf0a 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -305,11 +305,9 @@ static struct file_system_type debug_fs_type = {
 };
 MODULE_ALIAS_FS("debugfs");
 
-static struct dentry *__create_file(const char *name, umode_t mode,
-				    struct dentry *parent, void *data,
-				    const struct file_operations *fops)
+static struct dentry *start_creating(const char *name, struct dentry *parent)
 {
-	struct dentry *dentry = NULL;
+	struct dentry *dentry;
 	int error;
 
 	pr_debug("debugfs: creating file '%s'\n",name);
@@ -317,7 +315,7 @@ static struct dentry *__create_file(const char *name, umode_t mode,
 	error = simple_pin_fs(&debug_fs_type, &debugfs_mount,
 			      &debugfs_mount_count);
 	if (error)
-		goto exit;
+		return ERR_PTR(error);
 
 	/* If the parent is not specified, we create it in the root.
 	 * We need the root dentry to do this, which is in the super
@@ -329,32 +327,51 @@ static struct dentry *__create_file(const char *name, umode_t mode,
 
 	mutex_lock(&parent->d_inode->i_mutex);
 	dentry = lookup_one_len(name, parent, strlen(name));
-	if (!IS_ERR(dentry)) {
-		switch (mode & S_IFMT) {
-		case S_IFDIR:
-			error = debugfs_mkdir(dentry, mode);
-
-			break;
-		case S_IFLNK:
-			error = debugfs_link(dentry, mode, data);
-			break;
-		default:
-			error = debugfs_create(dentry, mode, data, fops);
-			break;
-		}
+	if (!IS_ERR(dentry) && dentry->d_inode) {
 		dput(dentry);
-	} else
-		error = PTR_ERR(dentry);
-	mutex_unlock(&parent->d_inode->i_mutex);
+		dentry = ERR_PTR(-EEXIST);
+	}
+	if (IS_ERR(dentry))
+		mutex_unlock(&parent->d_inode->i_mutex);
+	return dentry;
+}
+
+static struct dentry *end_creating(struct dentry *dentry, int error)
+{
+	mutex_unlock(&dentry->d_parent->d_inode->i_mutex);
+	dput(dentry);
 
 	if (error) {
 		dentry = NULL;
 		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	}
-exit:
 	return dentry;
 }
 
+static struct dentry *__create_file(const char *name, umode_t mode,
+				    struct dentry *parent, void *data,
+				    const struct file_operations *fops)
+{
+	struct dentry *dentry = start_creating(name, parent);
+	int error;
+
+	if (IS_ERR(dentry))
+		return NULL;
+
+	switch (mode & S_IFMT) {
+	case S_IFDIR:
+		error = debugfs_mkdir(dentry, mode);
+		break;
+	case S_IFLNK:
+		error = debugfs_link(dentry, mode, data);
+		break;
+	default:
+		error = debugfs_create(dentry, mode, data, fops);
+		break;
+	}
+	return end_creating(dentry, error);
+}
+
 /**
  * debugfs_create_file - create a file in the debugfs filesystem
  * @name: a pointer to a string containing the name of the file to create.
-- 
2.1.4


