Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbaG3CBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:01:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbaG3Btw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Philippe Troin <phil@fifi.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.14 05/29] nfs: only show Posix ACLs in listxattr if actually present
Date: Tue, 29 Jul 2014 18:48:40 -0700
Message-Id: <20140730014809.532250356@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014809.316066303@linuxfoundation.org>
References: <20140730014809.316066303@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 74adf83f5d7720925499b4938f930591f947b660 upstream.

The big ACL switched nfs to use generic_listxattr, which calls all existing
->list handlers.  Add a custom .listxattr implementation that only lists
the ACLs if they actually are present on the given inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Philippe Troin <phil@fifi.org>
Tested-by: Philippe Troin <phil@fifi.org>
Fixes: 013cdf1088d7 (nfs: use generic posix ACL infrastructure ...)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs3acl.c  |   43 +++++++++++++++++++++++++++++++++++++++++++
 fs/nfs/nfs3proc.c |    4 ++--
 2 files changed, 45 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -247,3 +247,46 @@ const struct xattr_handler *nfs3_xattr_h
 	&posix_acl_default_xattr_handler,
 	NULL,
 };
+
+static int
+nfs3_list_one_acl(struct inode *inode, int type, const char *name, void *data,
+		size_t size, ssize_t *result)
+{
+	struct posix_acl *acl;
+	char *p = data + *result;
+
+	acl = get_acl(inode, type);
+	if (!acl)
+		return 0;
+
+	posix_acl_release(acl);
+
+	*result += strlen(name);
+	*result += 1;
+	if (!size)
+		return 0;
+	if (*result > size)
+		return -ERANGE;
+
+	strcpy(p, name);
+	return 0;
+}
+
+ssize_t
+nfs3_listxattr(struct dentry *dentry, char *data, size_t size)
+{
+	struct inode *inode = dentry->d_inode;
+	ssize_t result = 0;
+	int error;
+
+	error = nfs3_list_one_acl(inode, ACL_TYPE_ACCESS,
+			POSIX_ACL_XATTR_ACCESS, data, size, &result);
+	if (error)
+		return error;
+
+	error = nfs3_list_one_acl(inode, ACL_TYPE_DEFAULT,
+			POSIX_ACL_XATTR_DEFAULT, data, size, &result);
+	if (error)
+		return error;
+	return result;
+}
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -926,7 +926,7 @@ static const struct inode_operations nfs
 	.getattr	= nfs_getattr,
 	.setattr	= nfs_setattr,
 #ifdef CONFIG_NFS_V3_ACL
-	.listxattr	= generic_listxattr,
+	.listxattr	= nfs3_listxattr,
 	.getxattr	= generic_getxattr,
 	.setxattr	= generic_setxattr,
 	.removexattr	= generic_removexattr,
@@ -940,7 +940,7 @@ static const struct inode_operations nfs
 	.getattr	= nfs_getattr,
 	.setattr	= nfs_setattr,
 #ifdef CONFIG_NFS_V3_ACL
-	.listxattr	= generic_listxattr,
+	.listxattr	= nfs3_listxattr,
 	.getxattr	= generic_getxattr,
 	.setxattr	= generic_setxattr,
 	.removexattr	= generic_removexattr,


