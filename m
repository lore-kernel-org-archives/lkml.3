Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbbAZPMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:12:49 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:58376 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752967AbbAZPKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:10:02 -0500
Message-Id: <20150126150959.888133233@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 26 Jan 2015 10:09:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 07/16 v3] fold debugfs_create() into caller
References: <20150126150913.653681560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0007-fold-debugfs_create-into-caller.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 8d12935c87f1..778c0e32eb51 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -84,19 +84,6 @@ static int debugfs_mknod(struct dentry *dentry,
 	return 0;
 }
 
-static int debugfs_create(struct dentry *dentry, umode_t mode,
-			  void *data, const struct file_operations *fops)
-{
-	struct inode *dir = dentry->d_parent->d_inode;
-	int res;
-
-	mode = (mode & S_IALLUGO) | S_IFREG;
-	res = debugfs_mknod(dentry, mode, data, fops);
-	if (!res)
-		fsnotify_create(dir, dentry);
-	return res;
-}
-
 static inline int debugfs_positive(struct dentry *dentry)
 {
 	return dentry->d_inode && !d_unhashed(dentry);
@@ -362,7 +349,9 @@ struct dentry *debugfs_create_file(const char *name, umode_t mode,
 	if (IS_ERR(dentry))
 		return NULL;
 
-	error = debugfs_create(dentry, mode, data, fops);
+	error = debugfs_mknod(dentry, mode, data, fops);
+	if (!error)
+		fsnotify_create(dentry->d_parent->d_inode, dentry);
 	return end_creating(dentry, error);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_file);
-- 
2.1.4


