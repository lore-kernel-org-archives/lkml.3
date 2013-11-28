Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab3K1T6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:58:07 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:41352 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab3K1Tze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:34 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 28/34] sysfs, kernfs: make inode number ida per kernfs_root
Date: Thu, 28 Nov 2013 14:54:41 -0500
Message-Id: <1385668487-10181-29-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs is being updated to allow multiple sysfs_dirent hierarchies so
that it can also be used by other users.  Currently, inode number is
allocated using a global ida, sysfs_ino_ida; however, inos for
different hierarchies should be handled separately.

This patch makes ino allocation per kernfs_root.  sysfs_ino_ida is
replaced by kernfs_root->ino_ida and sysfs_new_dirent() is updated to
take @root and allocate ino from it.  ida_simple_get/remove() are used
instead of sysfs_ino_lock and sysfs_alloc/free_ino().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c             | 47 +++++++++++++--------------------------------
 fs/kernfs/file.c            |  4 ++--
 fs/kernfs/kernfs-internal.h |  3 ++-
 fs/kernfs/symlink.c         |  3 ++-
 include/linux/kernfs.h      |  4 ++++
 5 files changed, 23 insertions(+), 38 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 246740a..eaffa83 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -21,9 +21,6 @@ DEFINE_MUTEX(sysfs_mutex);
 
 #define to_sysfs_dirent(X) rb_entry((X), struct sysfs_dirent, s_rb)
 
-static DEFINE_SPINLOCK(sysfs_ino_lock);
-static DEFINE_IDA(sysfs_ino_ida);
-
 /**
  *	sysfs_name_hash
  *	@name: Null terminated string to hash
@@ -205,32 +202,6 @@ static void sysfs_deactivate(struct sysfs_dirent *sd)
 	rwsem_release(&sd->dep_map, 1, _RET_IP_);
 }
 
-static int sysfs_alloc_ino(unsigned int *pino)
-{
-	int ino, rc;
-
- retry:
-	spin_lock(&sysfs_ino_lock);
-	rc = ida_get_new_above(&sysfs_ino_ida, 1, &ino);
-	spin_unlock(&sysfs_ino_lock);
-
-	if (rc == -EAGAIN) {
-		if (ida_pre_get(&sysfs_ino_ida, GFP_KERNEL))
-			goto retry;
-		rc = -ENOMEM;
-	}
-
-	*pino = ino;
-	return rc;
-}
-
-static void sysfs_free_ino(unsigned int ino)
-{
-	spin_lock(&sysfs_ino_lock);
-	ida_remove(&sysfs_ino_ida, ino);
-	spin_unlock(&sysfs_ino_lock);
-}
-
 /**
  * kernfs_get - get a reference count on a sysfs_dirent
  * @sd: the target sysfs_dirent
@@ -276,7 +247,7 @@ void kernfs_put(struct sysfs_dirent *sd)
 		security_release_secctx(sd->s_iattr->ia_secdata,
 					sd->s_iattr->ia_secdata_len);
 	kfree(sd->s_iattr);
-	sysfs_free_ino(sd->s_ino);
+	ida_simple_remove(&root->ino_ida, sd->s_ino);
 	kmem_cache_free(sysfs_dir_cachep, sd);
 
 	sd = parent_sd;
@@ -285,6 +256,7 @@ void kernfs_put(struct sysfs_dirent *sd)
 			goto repeat;
 	} else {
 		/* just released the root sd, free @root too */
+		ida_destroy(&root->ino_ida);
 		kfree(root);
 	}
 }
@@ -360,10 +332,12 @@ const struct dentry_operations sysfs_dentry_ops = {
 	.d_release	= sysfs_dentry_release,
 };
 
-struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
+struct sysfs_dirent *sysfs_new_dirent(struct kernfs_root *root,
+				      const char *name, umode_t mode, int type)
 {
 	char *dup_name = NULL;
 	struct sysfs_dirent *sd;
+	int ret;
 
 	if (type & SYSFS_COPY_NAME) {
 		name = dup_name = kstrdup(name, GFP_KERNEL);
@@ -375,8 +349,10 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 	if (!sd)
 		goto err_out1;
 
-	if (sysfs_alloc_ino(&sd->s_ino))
+	ret = ida_simple_get(&root->ino_ida, 1, 0, GFP_KERNEL);
+	if (ret < 0)
 		goto err_out2;
+	sd->s_ino = ret;
 
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_active, 0);
@@ -628,8 +604,11 @@ struct kernfs_root *kernfs_create_root(void *priv)
 	if (!root)
 		return ERR_PTR(-ENOMEM);
 
-	sd = sysfs_new_dirent("", S_IFDIR | S_IRUGO | S_IXUGO, SYSFS_DIR);
+	ida_init(&root->ino_ida);
+
+	sd = sysfs_new_dirent(root, "", S_IFDIR | S_IRUGO | S_IXUGO, SYSFS_DIR);
 	if (!sd) {
+		ida_destroy(&root->ino_ida);
 		kfree(root);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -674,7 +653,7 @@ struct sysfs_dirent *kernfs_create_dir_ns(struct sysfs_dirent *parent,
 	int rc;
 
 	/* allocate */
-	sd = sysfs_new_dirent(name, mode, SYSFS_DIR);
+	sd = sysfs_new_dirent(kernfs_root(parent), name, mode, SYSFS_DIR);
 	if (!sd)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index fa172e8..990c97f 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -775,8 +775,8 @@ struct sysfs_dirent *kernfs_create_file_ns_key(struct sysfs_dirent *parent,
 	struct sysfs_dirent *sd;
 	int rc;
 
-	sd = sysfs_new_dirent(name, (mode & S_IALLUGO) | S_IFREG,
-			      SYSFS_KOBJ_ATTR);
+	sd = sysfs_new_dirent(kernfs_root(parent), name,
+			      (mode & S_IALLUGO) | S_IFREG, SYSFS_KOBJ_ATTR);
 	if (!sd)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 7dfe062..466943d 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -160,7 +160,8 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt);
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 		  struct sysfs_dirent *parent_sd);
 void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
-struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type);
+struct sysfs_dirent *sysfs_new_dirent(struct kernfs_root *root,
+				      const char *name, umode_t mode, int type);
 
 /*
  * file.c
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index af3570b..004c164 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -30,7 +30,8 @@ struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
 	struct sysfs_addrm_cxt acxt;
 	int error;
 
-	sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
+	sd = sysfs_new_dirent(kernfs_root(parent), name, S_IFLNK|S_IRWXUGO,
+			      SYSFS_KOBJ_LINK);
 	if (!sd)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index f75548b..fad8b98 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -11,6 +11,7 @@
 #include <linux/err.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/idr.h>
 #include <linux/lockdep.h>
 
 struct file;
@@ -23,6 +24,9 @@ struct sysfs_dirent;
 struct kernfs_root {
 	/* published fields */
 	struct sysfs_dirent	*sd;
+
+	/* private fields, do not use outside kernfs proper */
+	struct ida		ino_ida;
 };
 
 struct sysfs_open_file {
-- 
1.8.4.2

