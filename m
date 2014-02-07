Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaBGU7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 15:59:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33663 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaBGU7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 15:59:32 -0500
Message-ID: <52F54928.9050601@oracle.com>
Date: Fri, 07 Feb 2014 14:59:20 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Michael L. Semon" <mlsemon35@gmail.com>
CC: Christoph Hellwig <hch@lst.de>,
        JFS Discussion <jfs-discussion@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] jfs: fix generic posix ACL regression
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I missed a couple errors in reviewing the patches converting jfs
to use the generic posix ACL function. Setting ACL's currently
fails with -EOPNOTSUPP.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 fs/jfs/xattr.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index 3bd5ee4..46325d5 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -854,9 +854,6 @@ int jfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 	int rc;
 	tid_t tid;
 
-	if ((rc = can_set_xattr(inode, name, value, value_len)))
-		return rc;
-
 	/*
 	 * If this is a request for a synthetic attribute in the system.*
 	 * namespace use the generic infrastructure to resolve a handler
@@ -865,6 +862,9 @@ int jfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
 		return generic_setxattr(dentry, name, value, value_len, flags);
 
+	if ((rc = can_set_xattr(inode, name, value, value_len)))
+		return rc;
+
 	if (value == NULL) {	/* empty EA, do not remove */
 		value = "";
 		value_len = 0;
@@ -1034,9 +1034,6 @@ int jfs_removexattr(struct dentry *dentry, const char *name)
 	int rc;
 	tid_t tid;
 
-	if ((rc = can_set_xattr(inode, name, NULL, 0)))
-		return rc;
-
 	/*
 	 * If this is a request for a synthetic attribute in the system.*
 	 * namespace use the generic infrastructure to resolve a handler
@@ -1045,6 +1042,9 @@ int jfs_removexattr(struct dentry *dentry, const char *name)
 	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
 		return generic_removexattr(dentry, name);
 
+	if ((rc = can_set_xattr(inode, name, NULL, 0)))
+		return rc;
+
 	tid = txBegin(inode->i_sb, 0);
 	mutex_lock(&ji->commit_mutex);
 	rc = __jfs_setxattr(tid, dentry->d_inode, name, NULL, 0, XATTR_REPLACE);
@@ -1061,7 +1061,7 @@ int jfs_removexattr(struct dentry *dentry, const char *name)
  * attributes are handled directly.
  */
 const struct xattr_handler *jfs_xattr_handlers[] = {
-#ifdef JFS_POSIX_ACL
+#ifdef CONFIG_JFS_POSIX_ACL
 	&posix_acl_access_xattr_handler,
 	&posix_acl_default_xattr_handler,
 #endif
-- 
1.8.5.3

