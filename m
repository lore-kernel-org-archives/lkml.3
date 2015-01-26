Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbbAZPKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:10:03 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:24103 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751885AbbAZPKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:10:00 -0500
Message-Id: <20150126150958.873234750@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 26 Jan 2015 10:09:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 01/16 v3] debugfs_{mkdir,create,link}(): get rid of redundant argument
References: <20150126150913.653681560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-debugfs_-mkdir-create-link-get-rid-of-redundant-argu.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 05f2960ed7c3..adaaa04448b3 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -89,8 +89,9 @@ static int debugfs_mknod(struct inode *dir, struct dentry *dentry,
 	return error;
 }
 
-static int debugfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
+static int debugfs_mkdir(struct dentry *dentry, umode_t mode)
 {
+	struct inode *dir = dentry->d_parent->d_inode;
 	int res;
 
 	mode = (mode & (S_IRWXUGO | S_ISVTX)) | S_IFDIR;
@@ -102,16 +103,18 @@ static int debugfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	return res;
 }
 
-static int debugfs_link(struct inode *dir, struct dentry *dentry, umode_t mode,
+static int debugfs_link(struct dentry *dentry, umode_t mode,
 			void *data)
 {
+	struct inode *dir = dentry->d_parent->d_inode;
 	mode = (mode & S_IALLUGO) | S_IFLNK;
 	return debugfs_mknod(dir, dentry, mode, 0, data, NULL);
 }
 
-static int debugfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
+static int debugfs_create(struct dentry *dentry, umode_t mode,
 			  void *data, const struct file_operations *fops)
 {
+	struct inode *dir = dentry->d_parent->d_inode;
 	int res;
 
 	mode = (mode & S_IALLUGO) | S_IFREG;
@@ -329,16 +332,14 @@ static struct dentry *__create_file(const char *name, umode_t mode,
 	if (!IS_ERR(dentry)) {
 		switch (mode & S_IFMT) {
 		case S_IFDIR:
-			error = debugfs_mkdir(parent->d_inode, dentry, mode);
+			error = debugfs_mkdir(dentry, mode);
 
 			break;
 		case S_IFLNK:
-			error = debugfs_link(parent->d_inode, dentry, mode,
-					     data);
+			error = debugfs_link(dentry, mode, data);
 			break;
 		default:
-			error = debugfs_create(parent->d_inode, dentry, mode,
-					       data, fops);
+			error = debugfs_create(dentry, mode, data, fops);
 			break;
 		}
 		dput(dentry);
-- 
2.1.4


