Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab3JXP7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:59:35 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:64594 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab3JXPtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:49:49 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/34] sysfs: move sysfs_hash_and_remove() to fs/sysfs/dir.c
Date: Thu, 24 Oct 2013 11:49:10 -0400
Message-Id: <1382629780-10006-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382629780-10006-1-git-send-email-tj@kernel.org>
References: <1382629780-10006-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most removal related logic is implemented in fs/sysfs/dir.c.  Move
sysfs_hash_and_remove() to fs/sysfs/dir.c so that __sysfs_remove()
doesn't have to be public.

This is pure relocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c   | 38 +++++++++++++++++++++++++++++++++++++-
 fs/sysfs/inode.c | 26 --------------------------
 fs/sysfs/sysfs.h |  5 ++---
 3 files changed, 39 insertions(+), 30 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index eab59de..486238d 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -813,7 +813,8 @@ static struct sysfs_dirent *sysfs_next_descendant_post(struct sysfs_dirent *pos,
 	return pos->s_parent;
 }
 
-void __sysfs_remove(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
+static void __sysfs_remove(struct sysfs_addrm_cxt *acxt,
+			   struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent *pos, *next;
 
@@ -847,6 +848,41 @@ void sysfs_remove(struct sysfs_dirent *sd)
 }
 
 /**
+ * sysfs_hash_and_remove - find a sysfs_dirent by name and remove it
+ * @dir_sd: parent of the target
+ * @name: name of the sysfs_dirent to remove
+ * @ns: namespace tag of the sysfs_dirent to remove
+ *
+ * Look for the sysfs_dirent with @name and @ns under @dir_sd and remove
+ * it.  Returns 0 on success, -ENOENT if such entry doesn't exist.
+ */
+int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name,
+			  const void *ns)
+{
+	struct sysfs_addrm_cxt acxt;
+	struct sysfs_dirent *sd;
+
+	if (!dir_sd) {
+		WARN(1, KERN_WARNING "sysfs: can not remove '%s', no directory\n",
+			name);
+		return -ENOENT;
+	}
+
+	sysfs_addrm_start(&acxt);
+
+	sd = sysfs_find_dirent(dir_sd, name, ns);
+	if (sd)
+		__sysfs_remove(&acxt, sd);
+
+	sysfs_addrm_finish(&acxt);
+
+	if (sd)
+		return 0;
+	else
+		return -ENOENT;
+}
+
+/**
  *	sysfs_remove_dir - remove an object's directory.
  *	@kobj:	object.
  *
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 825c556..1750f79 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -314,32 +314,6 @@ void sysfs_evict_inode(struct inode *inode)
 	sysfs_put(sd);
 }
 
-int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name,
-			  const void *ns)
-{
-	struct sysfs_addrm_cxt acxt;
-	struct sysfs_dirent *sd;
-
-	if (!dir_sd) {
-		WARN(1, KERN_WARNING "sysfs: can not remove '%s', no directory\n",
-			name);
-		return -ENOENT;
-	}
-
-	sysfs_addrm_start(&acxt);
-
-	sd = sysfs_find_dirent(dir_sd, name, ns);
-	if (sd)
-		__sysfs_remove(&acxt, sd);
-
-	sysfs_addrm_finish(&acxt);
-
-	if (sd)
-		return 0;
-	else
-		return -ENOENT;
-}
-
 int sysfs_permission(struct inode *inode, int mask)
 {
 	struct sysfs_dirent *sd;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index e0753e5..8d3dc1d 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -172,8 +172,9 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 		    struct sysfs_dirent *parent_sd);
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 		  struct sysfs_dirent *parent_sd);
-void __sysfs_remove(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
 void sysfs_remove(struct sysfs_dirent *sd);
+int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name,
+			  const void *ns);
 void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
 
 struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
@@ -218,8 +219,6 @@ int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat);
 int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		   size_t size, int flags);
-int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name,
-			  const void *ns);
 int sysfs_inode_init(void);
 
 /*
-- 
1.8.3.1

