Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbbAZPMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:12:44 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:58362 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753392AbbAZPKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:10:02 -0500
Message-Id: <20150126150959.195810272@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 26 Jan 2015 10:09:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 03/16 v3] debugfs: kill __create_file()
References: <20150126150913.653681560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-debugfs-kill-__create_file.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 71 +++++++++++++++++++++++++-----------------------------
 1 file changed, 33 insertions(+), 38 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 100186c2bf0a..18564b08884c 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -348,30 +348,6 @@ static struct dentry *end_creating(struct dentry *dentry, int error)
 	return dentry;
 }
 
-static struct dentry *__create_file(const char *name, umode_t mode,
-				    struct dentry *parent, void *data,
-				    const struct file_operations *fops)
-{
-	struct dentry *dentry = start_creating(name, parent);
-	int error;
-
-	if (IS_ERR(dentry))
-		return NULL;
-
-	switch (mode & S_IFMT) {
-	case S_IFDIR:
-		error = debugfs_mkdir(dentry, mode);
-		break;
-	case S_IFLNK:
-		error = debugfs_link(dentry, mode, data);
-		break;
-	default:
-		error = debugfs_create(dentry, mode, data, fops);
-		break;
-	}
-	return end_creating(dentry, error);
-}
-
 /**
  * debugfs_create_file - create a file in the debugfs filesystem
  * @name: a pointer to a string containing the name of the file to create.
@@ -402,15 +378,19 @@ struct dentry *debugfs_create_file(const char *name, umode_t mode,
 				   struct dentry *parent, void *data,
 				   const struct file_operations *fops)
 {
-	switch (mode & S_IFMT) {
-	case S_IFREG:
-	case 0:
-		break;
-	default:
-		BUG();
-	}
+	struct dentry *dentry;
+	int error;
+
+	if (!(mode & S_IFMT))
+		mode |= S_IFREG;
+	BUG_ON(!S_ISREG(mode));
+	dentry = start_creating(name, parent);
+
+	if (IS_ERR(dentry))
+		return NULL;
 
-	return __create_file(name, mode, parent, data, fops);
+	error = debugfs_create(dentry, mode, data, fops);
+	return end_creating(dentry, error);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_file);
 
@@ -434,8 +414,14 @@ EXPORT_SYMBOL_GPL(debugfs_create_file);
  */
 struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 {
-	return __create_file(name, S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
-				   parent, NULL, NULL);
+	struct dentry *dentry = start_creating(name, parent);
+	int error;
+
+	if (IS_ERR(dentry))
+		return NULL;
+
+	error = debugfs_mkdir(dentry, S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO);
+	return end_creating(dentry, error);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_dir);
 
@@ -465,17 +451,26 @@ EXPORT_SYMBOL_GPL(debugfs_create_dir);
 struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 				      const char *target)
 {
-	struct dentry *result;
+	struct dentry *dentry;
 	char *link;
+	int error;
 
 	link = kstrdup(target, GFP_KERNEL);
 	if (!link)
 		return NULL;
 
-	result = __create_file(name, S_IFLNK | S_IRWXUGO, parent, link, NULL);
-	if (!result)
+	dentry = start_creating(name, parent);
+
+	if (IS_ERR(dentry)) {
 		kfree(link);
-	return result;
+		return NULL;
+	}
+
+	error = debugfs_link(dentry, S_IFLNK | S_IRWXUGO, link);
+	if (error)
+		kfree(link);
+
+	return end_creating(dentry, error);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_symlink);
 
-- 
2.1.4


