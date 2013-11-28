Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab3K1UAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 15:00:40 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:36906 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759502Ab3K1TzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:17 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/34] sysfs, kernfs: revamp sysfs_dirent active_ref lockdep annotation
Date: Thu, 28 Nov 2013 14:54:29 -0500
Message-Id: <1385668487-10181-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, sysfs_dirent active_ref lockdep annotation uses
attribute->[s]key as the lockdep key, which forces
kernfs_create_file_ns() to assume that sysfs_dirent->priv is pointing
to a struct attribute which may not be true for non-sysfs users.  This
patch restructures the lockdep annotation such that

* kernfs_ops contains lockdep_key which is used by default for files
  created kernfs_create_file_ns().

* kernfs_create_file_ns_key() is introduced which takes an extra @key
  argument.  The created file will use the specified key for
  active_ref lockdep annotation.  If NULL is specified, lockdep for
  the file is disabled.

* sysfs_add_file_mode_ns() is updated to use
  kernfs_create_file_ns_key() with the appropriate key from the
  attribute or NULL if ignore_lockdep is set.

This makes the lockdep annotation properly contained in kernfs while
allowing sysfs to cleanly keep its current behavior.  This patch
doesn't introduce any behavior differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c         |  4 ++--
 fs/sysfs/file.c        | 35 ++++++++++++++++++++++++-----------
 fs/sysfs/sysfs.h       | 32 +-------------------------------
 include/linux/kernfs.h | 37 +++++++++++++++++++++++++++++--------
 4 files changed, 56 insertions(+), 52 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e88e9a9..8f2d577 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -150,7 +150,7 @@ struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
 	if (!atomic_inc_unless_negative(&sd->s_active))
 		return NULL;
 
-	if (likely(!sysfs_ignore_lockdep(sd)))
+	if (sd->s_flags & SYSFS_FLAG_LOCKDEP)
 		rwsem_acquire_read(&sd->dep_map, 0, 1, _RET_IP_);
 	return sd;
 }
@@ -169,7 +169,7 @@ void sysfs_put_active(struct sysfs_dirent *sd)
 	if (unlikely(!sd))
 		return;
 
-	if (likely(!sysfs_ignore_lockdep(sd)))
+	if (sd->s_flags & SYSFS_FLAG_LOCKDEP)
 		rwsem_release(&sd->dep_map, 1, _RET_IP_);
 	v = atomic_dec_return(&sd->s_active);
 	if (likely(v != SD_DEACTIVATED_BIAS))
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index a68cbef..e4eca28 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -58,7 +58,7 @@ static struct sysfs_open_file *sysfs_of(struct file *file)
  */
 static const struct kernfs_ops *kernfs_ops(struct sysfs_dirent *sd)
 {
-	if (!sysfs_ignore_lockdep(sd))
+	if (sd->s_flags & SYSFS_FLAG_LOCKDEP)
 		lockdep_assert_held(sd);
 	return sd->s_attr.ops;
 }
@@ -71,7 +71,7 @@ static const struct sysfs_ops *sysfs_file_ops(struct sysfs_dirent *sd)
 {
 	struct kobject *kobj = sd->s_parent->priv;
 
-	if (!sysfs_ignore_lockdep(sd))
+	if (sd->s_flags & SYSFS_FLAG_LOCKDEP)
 		lockdep_assert_held(sd);
 	return kobj->ktype ? kobj->ktype->sysfs_ops : NULL;
 }
@@ -942,6 +942,7 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 			   const struct attribute *attr, bool is_bin,
 			   umode_t mode, const void *ns)
 {
+	struct lock_class_key *key = NULL;
 	const struct kernfs_ops *ops;
 	struct sysfs_dirent *sd;
 	loff_t size;
@@ -981,8 +982,12 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 		size = battr->size;
 	}
 
-	sd = kernfs_create_file_ns(dir_sd, attr->name, mode, size,
-				   ops, (void *)attr, ns);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	if (!attr->ignore_lockdep)
+		key = attr->key ?: (struct lock_class_key *)&attr->skey;
+#endif
+	sd = kernfs_create_file_ns_key(dir_sd, attr->name, mode, size,
+				       ops, (void *)attr, ns, key);
 	if (IS_ERR(sd)) {
 		if (PTR_ERR(sd) == -EEXIST)
 			sysfs_warn_dup(dir_sd, attr->name);
@@ -992,7 +997,7 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 }
 
 /**
- * kernfs_create_file_ns - create a file
+ * kernfs_create_file_ns_key - create a file
  * @parent: directory to create the file in
  * @name: name of the file
  * @mode: mode of the file
@@ -1000,14 +1005,16 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
  * @ops: kernfs operations for the file
  * @priv: private data for the file
  * @ns: optional namespace tag of the file
+ * @key: lockdep key for the file's active_ref, %NULL to disable lockdep
  *
  * Returns the created node on success, ERR_PTR() value on error.
  */
-struct sysfs_dirent *kernfs_create_file_ns(struct sysfs_dirent *parent,
-					   const char *name,
-					   umode_t mode, loff_t size,
-					   const struct kernfs_ops *ops,
-					   void *priv, const void *ns)
+struct sysfs_dirent *kernfs_create_file_ns_key(struct sysfs_dirent *parent,
+					       const char *name,
+					       umode_t mode, loff_t size,
+					       const struct kernfs_ops *ops,
+					       void *priv, const void *ns,
+					       struct lock_class_key *key)
 {
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
@@ -1022,7 +1029,13 @@ struct sysfs_dirent *kernfs_create_file_ns(struct sysfs_dirent *parent,
 	sd->s_attr.size = size;
 	sd->s_ns = ns;
 	sd->priv = priv;
-	sysfs_dirent_init_lockdep(sd);
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	if (key) {
+		lockdep_init_map(&sd->dep_map, "s_active", key, 0);
+		sd->s_flags |= SYSFS_FLAG_LOCKDEP;
+	}
+#endif
 
 	/*
 	 * sd->s_attr.ops is accesible only while holding active ref.  We
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index c86456c..e93f8b8 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -92,43 +92,13 @@ struct sysfs_dirent {
 #define SYSFS_FLAG_NS			0x0020
 #define SYSFS_FLAG_HAS_SEQ_SHOW		0x0040
 #define SYSFS_FLAG_HAS_MMAP		0x0080
+#define SYSFS_FLAG_LOCKDEP		0x0100
 
 static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 {
 	return sd->s_flags & SYSFS_TYPE_MASK;
 }
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-
-#define sysfs_dirent_init_lockdep(sd)				\
-do {								\
-	struct attribute *attr = sd->priv;			\
-	struct lock_class_key *key = attr->key;			\
-	if (!key)						\
-		key = &attr->skey;				\
-								\
-	lockdep_init_map(&sd->dep_map, "s_active", key, 0);	\
-} while (0)
-
-/* Test for attributes that want to ignore lockdep for read-locking */
-static inline bool sysfs_ignore_lockdep(struct sysfs_dirent *sd)
-{
-	struct attribute *attr = sd->priv;
-
-	return sysfs_type(sd) == SYSFS_KOBJ_ATTR && attr->ignore_lockdep;
-}
-
-#else
-
-#define sysfs_dirent_init_lockdep(sd) do {} while (0)
-
-static inline bool sysfs_ignore_lockdep(struct sysfs_dirent *sd)
-{
-	return true;
-}
-
-#endif
-
 /*
  * Context structure to be used while adding/removing nodes.
  */
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index f20796e..105d09d 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -11,6 +11,7 @@
 #include <linux/err.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/lockdep.h>
 
 struct file;
 struct iattr;
@@ -62,6 +63,10 @@ struct kernfs_ops {
 			 loff_t off);
 
 	int (*mmap)(struct sysfs_open_file *of, struct vm_area_struct *vma);
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lock_class_key	lockdep_key;
+#endif
 };
 
 #ifdef CONFIG_SYSFS
@@ -69,11 +74,12 @@ struct kernfs_ops {
 struct sysfs_dirent *kernfs_create_dir_ns(struct sysfs_dirent *parent,
 					  const char *name, void *priv,
 					  const void *ns);
-struct sysfs_dirent *kernfs_create_file_ns(struct sysfs_dirent *parent,
-					   const char *name,
-					   umode_t mode, loff_t size,
-					   const struct kernfs_ops *ops,
-					   void *priv, const void *ns);
+struct sysfs_dirent *kernfs_create_file_ns_key(struct sysfs_dirent *parent,
+					       const char *name,
+					       umode_t mode, loff_t size,
+					       const struct kernfs_ops *ops,
+					       void *priv, const void *ns,
+					       struct lock_class_key *key);
 struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
 					const char *name,
 					struct sysfs_dirent *target);
@@ -94,9 +100,10 @@ kernfs_create_dir_ns(struct sysfs_dirent *parent, const char *name, void *priv,
 { return ERR_PTR(-ENOSYS); }
 
 static inline struct sysfs_dirent *
-kernfs_create_file_ns(struct sysfs_dirent *parent, const char *name,
-		      umode_t mode, loff_t size, const struct kernfs_ops *ops,
-		      void *priv, const void *ns)
+kernfs_create_file_ns_key(struct sysfs_dirent *parent, const char *name,
+			  umode_t mode, loff_t size,
+			  const struct kernfs_ops *ops, void *priv,
+			  const void *ns, struct lock_class_key *key)
 { return ERR_PTR(-ENOSYS); }
 
 static inline struct sysfs_dirent *
@@ -132,6 +139,20 @@ kernfs_create_dir(struct sysfs_dirent *parent, const char *name, void *priv)
 }
 
 static inline struct sysfs_dirent *
+kernfs_create_file_ns(struct sysfs_dirent *parent, const char *name,
+		      umode_t mode, loff_t size, const struct kernfs_ops *ops,
+		      void *priv, const void *ns)
+{
+	struct lock_class_key *key = NULL;
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	key = (struct lock_class_key *)&ops->lockdep_key;
+#endif
+	return kernfs_create_file_ns_key(parent, name, mode, size, ops, priv,
+					 ns, key);
+}
+
+static inline struct sysfs_dirent *
 kernfs_create_file(struct sysfs_dirent *parent, const char *name, umode_t mode,
 		   loff_t size, const struct kernfs_ops *ops, void *priv)
 {
-- 
1.8.4.2

