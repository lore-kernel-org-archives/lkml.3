Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab3LKVDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:03:19 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:55861 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3LKVDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:03:10 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, kay@vrfy.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] kernfs: mark static names with KERNFS_STATIC_NAME
Date: Wed, 11 Dec 2013 16:02:57 -0500
Message-Id: <1386795780-23324-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386795780-23324-1-git-send-email-tj@kernel.org>
References: <1386795780-23324-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because sysfs used struct attribute which are supposed to stay
constant, sysfs didn't copy names when creating regular files.  The
specified string for name was supposed to stay constant.  Such
distinction isn't inherent for kernfs.  kernfs_create_file[_ns]()
should be able to take the same @name as kernfs_create_dir[_ns]()

As there can be huge number of sysfs attributes, we still want to be
able to use static names for sysfs attributes.  This patch renames
kernfs_create_file_ns_key() to __kernfs_create_file() and adds
@name_is_static parameter so that the caller can explicitly indicate
that @name can be used without copying.  kernfs is updated to use
KERNFS_STATIC_NAME to distinguish static and copied names.

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c             |  8 ++++----
 fs/kernfs/file.c            | 23 +++++++++++++++--------
 fs/kernfs/kernfs-internal.h |  2 +-
 fs/sysfs/file.c             |  4 ++--
 include/linux/kernfs.h      | 27 ++++++++++++++-------------
 5 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index ba5f372..e168177 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -240,7 +240,7 @@ void kernfs_put(struct kernfs_node *kn)
 
 	if (kernfs_type(kn) == KERNFS_LINK)
 		kernfs_put(kn->symlink.target_kn);
-	if (kernfs_type(kn) & KERNFS_COPY_NAME)
+	if (!(kn->flags & KERNFS_STATIC_NAME))
 		kfree(kn->name);
 	if (kn->iattr) {
 		if (kn->iattr->ia_secdata)
@@ -336,13 +336,13 @@ const struct dentry_operations kernfs_dops = {
 };
 
 struct kernfs_node *kernfs_new_node(struct kernfs_root *root, const char *name,
-				    umode_t mode, int type)
+				    umode_t mode, unsigned flags)
 {
 	char *dup_name = NULL;
 	struct kernfs_node *kn;
 	int ret;
 
-	if (type & KERNFS_COPY_NAME) {
+	if (!(flags & KERNFS_STATIC_NAME)) {
 		name = dup_name = kstrdup(name, GFP_KERNEL);
 		if (!name)
 			return NULL;
@@ -362,7 +362,7 @@ struct kernfs_node *kernfs_new_node(struct kernfs_root *root, const char *name,
 
 	kn->name = name;
 	kn->mode = mode;
-	kn->flags = type | KERNFS_REMOVED;
+	kn->flags = flags | KERNFS_REMOVED;
 
 	return kn;
 
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 053cfd9..316604c 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -762,7 +762,7 @@ const struct file_operations kernfs_file_fops = {
 };
 
 /**
- * kernfs_create_file_ns_key - create a file
+ * __kernfs_create_file - kernfs internal function to create a file
  * @parent: directory to create the file in
  * @name: name of the file
  * @mode: mode of the file
@@ -770,23 +770,30 @@ const struct file_operations kernfs_file_fops = {
  * @ops: kernfs operations for the file
  * @priv: private data for the file
  * @ns: optional namespace tag of the file
+ * @static_name: don't copy file name
  * @key: lockdep key for the file's active_ref, %NULL to disable lockdep
  *
  * Returns the created node on success, ERR_PTR() value on error.
  */
-struct kernfs_node *kernfs_create_file_ns_key(struct kernfs_node *parent,
-					      const char *name,
-					      umode_t mode, loff_t size,
-					      const struct kernfs_ops *ops,
-					      void *priv, const void *ns,
-					      struct lock_class_key *key)
+struct kernfs_node *__kernfs_create_file(struct kernfs_node *parent,
+					 const char *name,
+					 umode_t mode, loff_t size,
+					 const struct kernfs_ops *ops,
+					 void *priv, const void *ns,
+					 bool name_is_static,
+					 struct lock_class_key *key)
 {
 	struct kernfs_addrm_cxt acxt;
 	struct kernfs_node *kn;
+	unsigned flags;
 	int rc;
 
+	flags = KERNFS_FILE;
+	if (name_is_static)
+		flags |= KERNFS_STATIC_NAME;
+
 	kn = kernfs_new_node(kernfs_root(parent), name,
-			     (mode & S_IALLUGO) | S_IFREG, KERNFS_FILE);
+			     (mode & S_IALLUGO) | S_IFREG, flags);
 	if (!kn)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index a4ff491..c6ba5bc 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -105,7 +105,7 @@ int kernfs_add_one(struct kernfs_addrm_cxt *acxt, struct kernfs_node *kn,
 		   struct kernfs_node *parent);
 void kernfs_addrm_finish(struct kernfs_addrm_cxt *acxt);
 struct kernfs_node *kernfs_new_node(struct kernfs_root *root, const char *name,
-				    umode_t mode, int type);
+				    umode_t mode, unsigned flags);
 
 /*
  * file.c
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index fe6388f..810cf6e 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -252,8 +252,8 @@ int sysfs_add_file_mode_ns(struct kernfs_node *parent,
 	if (!attr->ignore_lockdep)
 		key = attr->key ?: (struct lock_class_key *)&attr->skey;
 #endif
-	kn = kernfs_create_file_ns_key(parent, attr->name, mode, size,
-				       ops, (void *)attr, ns, key);
+	kn = __kernfs_create_file(parent, attr->name, mode, size, ops,
+				  (void *)attr, ns, true, key);
 	if (IS_ERR(kn)) {
 		if (PTR_ERR(kn) == -EEXIST)
 			sysfs_warn_dup(parent, attr->name);
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 0ca2aed..321ed84 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -34,7 +34,6 @@ enum kernfs_node_type {
 };
 
 #define KERNFS_TYPE_MASK	0x000f
-#define KERNFS_COPY_NAME	(KERNFS_DIR | KERNFS_LINK)
 #define KERNFS_ACTIVE_REF	KERNFS_FILE
 #define KERNFS_FLAG_MASK	~KERNFS_TYPE_MASK
 
@@ -44,6 +43,7 @@ enum kernfs_node_flag {
 	KERNFS_HAS_SEQ_SHOW	= 0x0040,
 	KERNFS_HAS_MMAP		= 0x0080,
 	KERNFS_LOCKDEP		= 0x0100,
+	KERNFS_STATIC_NAME	= 0x0200,
 };
 
 /* type-specific structures for kernfs_node union members */
@@ -212,12 +212,13 @@ void kernfs_destroy_root(struct kernfs_root *root);
 struct kernfs_node *kernfs_create_dir_ns(struct kernfs_node *parent,
 					 const char *name, umode_t mode,
 					 void *priv, const void *ns);
-struct kernfs_node *kernfs_create_file_ns_key(struct kernfs_node *parent,
-					      const char *name,
-					      umode_t mode, loff_t size,
-					      const struct kernfs_ops *ops,
-					      void *priv, const void *ns,
-					      struct lock_class_key *key);
+struct kernfs_node *__kernfs_create_file(struct kernfs_node *parent,
+					 const char *name,
+					 umode_t mode, loff_t size,
+					 const struct kernfs_ops *ops,
+					 void *priv, const void *ns,
+					 bool name_is_static,
+					 struct lock_class_key *key);
 struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 				       const char *name,
 				       struct kernfs_node *target);
@@ -265,10 +266,10 @@ kernfs_create_dir_ns(struct kernfs_node *parent, const char *name,
 { return ERR_PTR(-ENOSYS); }
 
 static inline struct kernfs_node *
-kernfs_create_file_ns_key(struct kernfs_node *parent, const char *name,
-			  umode_t mode, loff_t size,
-			  const struct kernfs_ops *ops, void *priv,
-			  const void *ns, struct lock_class_key *key)
+__kernfs_create_file(struct kernfs_node *parent, const char *name,
+		     umode_t mode, loff_t size, const struct kernfs_ops *ops,
+		     void *priv, const void *ns, bool name_is_static,
+		     struct lock_class_key *key)
 { return ERR_PTR(-ENOSYS); }
 
 static inline struct kernfs_node *
@@ -330,8 +331,8 @@ kernfs_create_file_ns(struct kernfs_node *parent, const char *name,
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	key = (struct lock_class_key *)&ops->lockdep_key;
 #endif
-	return kernfs_create_file_ns_key(parent, name, mode, size, ops, priv,
-					 ns, key);
+	return __kernfs_create_file(parent, name, mode, size, ops, priv, ns,
+				    false, key);
 }
 
 static inline struct kernfs_node *
-- 
1.8.4.2

