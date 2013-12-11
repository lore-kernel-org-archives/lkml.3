Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3LKVDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:03:14 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:45810 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3LKVDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:03:07 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, kay@vrfy.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] kernfs: add @mode to kernfs_create_dir[_ns]()
Date: Wed, 11 Dec 2013 16:02:55 -0500
Message-Id: <1386795780-23324-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386795780-23324-1-git-send-email-tj@kernel.org>
References: <1386795780-23324-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs assumed 0755 for all newly created directories and kernfs
inherited it.  This assumption is unnecessarily restrictive and
inconsistent with kernfs_create_file[_ns]().  This patch adds @mode
parameter to kernfs_create_dir[_ns]() and update uses in sysfs
accordingly.  Among others, this will be useful for implementations of
the planned ->mkdir() method.

This patch doesn't introduce any behavior differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c        |  9 +++++----
 fs/sysfs/dir.c         |  3 ++-
 fs/sysfs/group.c       |  3 ++-
 include/linux/kernfs.h | 13 +++++++------
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 6520066..e55bb02 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -639,22 +639,23 @@ void kernfs_destroy_root(struct kernfs_root *root)
  * kernfs_create_dir_ns - create a directory
  * @parent: parent in which to create a new directory
  * @name: name of the new directory
+ * @mode: mode of the new directory
  * @priv: opaque data associated with the new directory
  * @ns: optional namespace tag of the directory
  *
  * Returns the created node on success, ERR_PTR() value on failure.
  */
 struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
-					 const char *name, void *priv,
-					 const void *ns)
+					 const char *name, umode_t mode,
+					 void *priv, const void *ns)
 {
-	umode_t mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
 	struct kernfs_addrm_cxt acxt;
 	struct kernfs_node *kn;
 	int rc;
 
 	/* allocate */
-	kn = kernfs_new_node(kernfs_root(parent), name, mode, KERNFS_DIR);
+	kn = kernfs_new_node(kernfs_root(parent), name, mode | S_IFDIR,
+			     KERNFS_DIR);
 	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index aa00740..ee0d761 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -73,7 +73,8 @@ int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
 	if (!parent)
 		return -ENOENT;
 
-	kn = kernfs_create_dir_ns(parent, kobject_name(kobj), kobj, ns);
+	kn = kernfs_create_dir_ns(parent, kobject_name(kobj),
+				  S_IRWXU | S_IRUGO | S_IXUGO, kobj, ns);
 	if (IS_ERR(kn)) {
 		if (PTR_ERR(kn) == -EEXIST)
 			sysfs_warn_dup(parent, kobject_name(kobj));
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 4d00d399..6b57938 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -100,7 +100,8 @@ static int internal_create_group(struct kobject *kobj, int update,
 		return -EINVAL;
 	}
 	if (grp->name) {
-		kn = kernfs_create_dir(kobj->sd, grp->name, kobj);
+		kn = kernfs_create_dir(kobj->sd, grp->name,
+				       S_IRWXU | S_IRUGO | S_IXUGO, kobj);
 		if (IS_ERR(kn)) {
 			if (PTR_ERR(kn) == -EEXIST)
 				sysfs_warn_dup(kobj->sd, grp->name);
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index e9c4e3a..0ca2aed 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -210,8 +210,8 @@ struct kernfs_root *kernfs_create_root(void *priv);
 void kernfs_destroy_root(struct kernfs_root *root);
 
 struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
-					 const char *name, void *priv,
-					 const void *ns);
+					 const char *name, umode_t mode,
+					 void *priv, const void *ns);
 struct kernfs_node *kernfs_create_file_ns_key(struct kernfs_node *parent,
 					      const char *name,
 					      umode_t mode, loff_t size,
@@ -260,8 +260,8 @@ static inline struct kernfs_root *kernfs_create_root(void *priv)
 static inline void kernfs_destroy_root(struct kernfs_root *root) { }
 
 static inline struct kernfs_node *
-kernfs_create_dir_ns(struct kernfs_node *parent, const char *name, void *priv,
-		     const void *ns)
+kernfs_create_dir_ns(struct kernfs_node *parent, const char *name,
+		     umode_t mode, void *priv, const void *ns)
 { return ERR_PTR(-ENOSYS); }
 
 static inline struct kernfs_node *
@@ -314,9 +314,10 @@ kernfs_find_and_get(struct kernfs_node *kn, const char *name)
 }
 
 static inline struct kernfs_node *
-kernfs_create_dir(struct kernfs_node *parent, const char *name, void *priv)
+kernfs_create_dir(struct kernfs_node *parent, const char *name, umode_t mode,
+		  void *priv)
 {
-	return kernfs_create_dir_ns(parent, name, priv, NULL);
+	return kernfs_create_dir_ns(parent, name, mode, priv, NULL);
 }
 
 static inline struct kernfs_node *
-- 
1.8.4.2

