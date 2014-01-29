Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaA2Qiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 11:38:51 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:65527 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaA2Qit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 11:38:49 -0500
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: Sage Weil <sage@inktank.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Subject: [PATCH v2] ceph: fix posix ACL hooks
Date: Wed, 29 Jan 2014 18:37:47 +0200
Message-Id: <1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sage Weil <sage@inktank.com>

The merge of 7221fe4c2 raced with upstream changes in the generic POSIX
ACL code (2aeccbe95).  Update Ceph to use the new helpers as well by
dropping the now-generic functions and setting the set_acl inode op.

Signed-off-by: Sage Weil <sage@inktank.com>
---
v2: fixed the !CONFIG_CEPH_FS_POSIX_ACL case

 fs/ceph/acl.c   |  112 +++----------------------------------------------------
 fs/ceph/dir.c   |    1 +
 fs/ceph/inode.c |    5 ++-
 fs/ceph/super.h |    6 +--
 fs/ceph/xattr.c |    5 ++-
 5 files changed, 16 insertions(+), 113 deletions(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index 64fddbc1d17b..66d377a12f7c 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -107,14 +107,14 @@ struct posix_acl *ceph_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
-static int ceph_set_acl(struct dentry *dentry, struct inode *inode,
-				struct posix_acl *acl, int type)
+int ceph_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	int ret = 0, size = 0;
 	const char *name = NULL;
 	char *value = NULL;
 	struct iattr newattrs;
 	umode_t new_mode = inode->i_mode, old_mode = inode->i_mode;
+	struct dentry *dentry = d_find_alias(inode);
 
 	if (acl) {
 		ret = posix_acl_valid(acl);
@@ -208,16 +208,15 @@ int ceph_init_acl(struct dentry *dentry, struct inode *inode, struct inode *dir)
 
 	if (IS_POSIXACL(dir) && acl) {
 		if (S_ISDIR(inode->i_mode)) {
-			ret = ceph_set_acl(dentry, inode, acl,
-						ACL_TYPE_DEFAULT);
+			ret = ceph_set_acl(inode, acl, ACL_TYPE_DEFAULT);
 			if (ret)
 				goto out_release;
 		}
-		ret = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
+		ret = __posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
 		if (ret < 0)
 			goto out;
 		else if (ret > 0)
-			ret = ceph_set_acl(dentry, inode, acl, ACL_TYPE_ACCESS);
+			ret = ceph_set_acl(inode, acl, ACL_TYPE_ACCESS);
 		else
 			cache_no_acl(inode);
 	} else {
@@ -229,104 +228,3 @@ out_release:
 out:
 	return ret;
 }
-
-int ceph_acl_chmod(struct dentry *dentry, struct inode *inode)
-{
-	struct posix_acl *acl;
-	int ret = 0;
-
-	if (S_ISLNK(inode->i_mode)) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
-	if (!IS_POSIXACL(inode))
-		goto out;
-
-	acl = ceph_get_acl(inode, ACL_TYPE_ACCESS);
-	if (IS_ERR_OR_NULL(acl)) {
-		ret = PTR_ERR(acl);
-		goto out;
-	}
-
-	ret = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
-	if (ret)
-		goto out;
-	ret = ceph_set_acl(dentry, inode, acl, ACL_TYPE_ACCESS);
-	posix_acl_release(acl);
-out:
-	return ret;
-}
-
-static int ceph_xattr_acl_get(struct dentry *dentry, const char *name,
-				void *value, size_t size, int type)
-{
-	struct posix_acl *acl;
-	int ret = 0;
-
-	if (!IS_POSIXACL(dentry->d_inode))
-		return -EOPNOTSUPP;
-
-	acl = ceph_get_acl(dentry->d_inode, type);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-	if (acl == NULL)
-		return -ENODATA;
-
-	ret = posix_acl_to_xattr(&init_user_ns, acl, value, size);
-	posix_acl_release(acl);
-
-	return ret;
-}
-
-static int ceph_xattr_acl_set(struct dentry *dentry, const char *name,
-			const void *value, size_t size, int flags, int type)
-{
-	int ret = 0;
-	struct posix_acl *acl = NULL;
-
-	if (!inode_owner_or_capable(dentry->d_inode)) {
-		ret = -EPERM;
-		goto out;
-	}
-
-	if (!IS_POSIXACL(dentry->d_inode)) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
-	if (value) {
-		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-		if (IS_ERR(acl)) {
-			ret = PTR_ERR(acl);
-			goto out;
-		}
-
-		if (acl) {
-			ret = posix_acl_valid(acl);
-			if (ret)
-				goto out_release;
-		}
-	}
-
-	ret = ceph_set_acl(dentry, dentry->d_inode, acl, type);
-
-out_release:
-	posix_acl_release(acl);
-out:
-	return ret;
-}
-
-const struct xattr_handler ceph_xattr_acl_default_handler = {
-	.prefix = POSIX_ACL_XATTR_DEFAULT,
-	.flags  = ACL_TYPE_DEFAULT,
-	.get    = ceph_xattr_acl_get,
-	.set    = ceph_xattr_acl_set,
-};
-
-const struct xattr_handler ceph_xattr_acl_access_handler = {
-	.prefix = POSIX_ACL_XATTR_ACCESS,
-	.flags  = ACL_TYPE_ACCESS,
-	.get    = ceph_xattr_acl_get,
-	.set    = ceph_xattr_acl_set,
-};
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 619616d585b0..6da4df84ba30 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1303,6 +1303,7 @@ const struct inode_operations ceph_dir_iops = {
 	.listxattr = ceph_listxattr,
 	.removexattr = ceph_removexattr,
 	.get_acl = ceph_get_acl,
+	.set_acl = ceph_set_acl,
 	.mknod = ceph_mknod,
 	.symlink = ceph_symlink,
 	.mkdir = ceph_mkdir,
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 6fc10a7d7c59..32d519d8a2e2 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -9,6 +9,7 @@
 #include <linux/namei.h>
 #include <linux/writeback.h>
 #include <linux/vmalloc.h>
+#include <linux/posix_acl.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -96,6 +97,7 @@ const struct inode_operations ceph_file_iops = {
 	.listxattr = ceph_listxattr,
 	.removexattr = ceph_removexattr,
 	.get_acl = ceph_get_acl,
+	.set_acl = ceph_set_acl,
 };
 
 
@@ -1615,6 +1617,7 @@ static const struct inode_operations ceph_symlink_iops = {
 	.listxattr = ceph_listxattr,
 	.removexattr = ceph_removexattr,
 	.get_acl = ceph_get_acl,
+	.set_acl = ceph_set_acl,
 };
 
 /*
@@ -1805,7 +1808,7 @@ int ceph_setattr(struct dentry *dentry, struct iattr *attr)
 		__mark_inode_dirty(inode, inode_dirty_flags);
 
 	if (ia_valid & ATTR_MODE) {
-		err = ceph_acl_chmod(dentry, inode);
+		err = posix_acl_chmod(inode, attr->ia_mode);
 		if (err)
 			goto out_put;
 	}
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index c299f7d19bf3..aa260590f615 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -718,6 +718,7 @@ extern void ceph_queue_writeback(struct inode *inode);
 extern int ceph_do_getattr(struct inode *inode, int mask);
 extern int ceph_permission(struct inode *inode, int mask);
 extern int ceph_setattr(struct dentry *dentry, struct iattr *attr);
+extern int ceph_setattr(struct dentry *dentry, struct iattr *attr);
 extern int ceph_getattr(struct vfsmount *mnt, struct dentry *dentry,
 			struct kstat *stat);
 
@@ -736,20 +737,19 @@ extern void __init ceph_xattr_init(void);
 extern void ceph_xattr_exit(void);
 
 /* acl.c */
-extern const struct xattr_handler ceph_xattr_acl_access_handler;
-extern const struct xattr_handler ceph_xattr_acl_default_handler;
 extern const struct xattr_handler *ceph_xattr_handlers[];
 
 #ifdef CONFIG_CEPH_FS_POSIX_ACL
 
 struct posix_acl *ceph_get_acl(struct inode *, int);
+int ceph_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 int ceph_init_acl(struct dentry *, struct inode *, struct inode *);
-int ceph_acl_chmod(struct dentry *, struct inode *);
 void ceph_forget_all_cached_acls(struct inode *inode);
 
 #else
 
 #define ceph_get_acl NULL
+#define ceph_set_acl NULL
 
 static inline int ceph_init_acl(struct dentry *dentry, struct inode *inode,
 				struct inode *dir)
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index c7581f3733c1..898b6565ad3e 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -6,6 +6,7 @@
 #include <linux/ceph/decode.h>
 
 #include <linux/xattr.h>
+#include <linux/posix_acl_xattr.h>
 #include <linux/slab.h>
 
 #define XATTR_CEPH_PREFIX "ceph."
@@ -17,8 +18,8 @@
  */
 const struct xattr_handler *ceph_xattr_handlers[] = {
 #ifdef CONFIG_CEPH_FS_POSIX_ACL
-	&ceph_xattr_acl_access_handler,
-	&ceph_xattr_acl_default_handler,
+	&posix_acl_access_xattr_handler,
+	&posix_acl_default_xattr_handler,
 #endif
 	NULL,
 };
-- 
1.7.10.4

