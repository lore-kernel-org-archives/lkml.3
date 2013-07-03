Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab3GCSsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:48:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2474 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261Ab3GCSlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:02 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=h1sxUQKVMqwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Gssdxyt86KkA:10 a=iox4zFpeAAAA:8 a=pQFG53Joc4AfjvbZiugA:9 a=n9GBPR9yFnkA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184052.331343910@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.cz>
Subject: [047/141] reiserfs: fix problems with chowning setuid file w/ xattrs
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0047-reiserfs-fix-problems-with-chowning-setuid-file-w-xa.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

[ Upstream commit 4a8570112b76a63ad21cfcbe2783f98f7fd5ba1b ]

reiserfs_chown_xattrs() takes the iattr struct passed into ->setattr
and uses it to iterate over all the attrs associated with a file to change
ownership of xattrs (and transfer quota associated with the xattr files).

When the setuid bit is cleared during chown, ATTR_MODE and iattr->ia_mode
are passed to all the xattrs as well. This means that the xattr directory
will have S_IFREG added to its mode bits.

This has been prevented in practice by a missing IS_PRIVATE check
in reiserfs_acl_chmod, which caused a double-lock to occur while holding
the write lock. Since the file system was completely locked up, the
writeout of the corrupted mode never happened.

This patch temporarily clears everything but ATTR_UID|ATTR_GID for the
calls to reiserfs_setattr and adds the missing IS_PRIVATE check.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/reiserfs/xattr.c     |   14 +++++++++++++-
 fs/reiserfs/xattr_acl.c |    3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index d319963..78f823d 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -318,7 +318,19 @@ static int delete_one_xattr(struct dentry *dentry, void *data)
 static int chown_one_xattr(struct dentry *dentry, void *data)
 {
 	struct iattr *attrs = data;
-	return reiserfs_setattr(dentry, attrs);
+	int ia_valid = attrs->ia_valid;
+	int err;
+
+	/*
+	 * We only want the ownership bits. Otherwise, we'll do
+	 * things like change a directory to a regular file if
+	 * ATTR_MODE is set.
+	 */
+	attrs->ia_valid &= (ATTR_UID|ATTR_GID);
+	err = reiserfs_setattr(dentry, attrs);
+	attrs->ia_valid = ia_valid;
+
+	return err;
 }
 
 /* No i_mutex, but the inode is unconnected. */
diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index 44474f9..84fe30c 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -429,6 +429,9 @@ int reiserfs_acl_chmod(struct inode *inode)
 	int depth;
 	int error;
 
+	if (IS_PRIVATE(inode))
+		return 0;
+
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
 
-- 
1.7.10.4


