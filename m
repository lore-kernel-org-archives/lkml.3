Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbbAZPNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:13:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:24103 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753127AbbAZPKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:10:02 -0500
Message-Id: <20150126150959.710684302@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 26 Jan 2015 10:09:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 06/16 v3] fold debugfs_mkdir() into caller
References: <20150126150913.653681560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0006-fold-debugfs_mkdir-into-caller.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index bc02e2096977..8d12935c87f1 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -84,20 +84,6 @@ static int debugfs_mknod(struct dentry *dentry,
 	return 0;
 }
 
-static int debugfs_mkdir(struct dentry *dentry, umode_t mode)
-{
-	struct inode *dir = dentry->d_parent->d_inode;
-	int res;
-
-	mode = (mode & (S_IRWXUGO | S_ISVTX)) | S_IFDIR;
-	res = debugfs_mknod(dentry, mode, NULL, NULL);
-	if (!res) {
-		inc_nlink(dir);
-		fsnotify_mkdir(dir, dentry);
-	}
-	return res;
-}
-
 static int debugfs_create(struct dentry *dentry, umode_t mode,
 			  void *data, const struct file_operations *fops)
 {
@@ -407,7 +393,12 @@ struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 	if (IS_ERR(dentry))
 		return NULL;
 
-	error = debugfs_mkdir(dentry, S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO);
+	error = debugfs_mknod(dentry, S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
+			      NULL, NULL);
+	if (!error) {
+		inc_nlink(dentry->d_parent->d_inode);
+		fsnotify_mkdir(dentry->d_parent->d_inode, dentry);
+	}
 	return end_creating(dentry, error);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_dir);
-- 
2.1.4


