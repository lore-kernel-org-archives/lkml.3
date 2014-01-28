Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaA1Xdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:33:43 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:65392 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958AbaA1XdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:33:10 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 9/9] kernfs: implement kernfs_get_parent(), kernfs_name/path() and friends
Date: Tue, 28 Jan 2014 18:32:51 -0500
Message-Id: <1390951971-15671-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951971-15671-1-git-send-email-tj@kernel.org>
References: <1390951971-15671-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs_node->parent and ->name are currently marked as "published"
indicating that kernfs users may access them directly; however, those
fields may get updated by kernfs_rename[_ns]() and unrestricted access
may lead to erroneous values or oops.

Protect ->parent and ->name updates with a irq-safe spinlock
kernfs_rename_lock and implement the following accessors for these
fields.

* kernfs_name()		- format the node's name into the specified buffer
* kernfs_path()		- format the node's path into the specified buffer
* pr_cont_kernfs_name()	- pr_cont a node's name (doesn't need buffer)
* pr_cont_kernfs_path()	- pr_cont a node's path (doesn't need buffer)
* kernfs_get_parent()	- pin and return a node's parent

All can be called under any context.  The recursive sysfs_pathname()
in fs/sysfs/dir.c is replaced with kernfs_path() and
sysfs_rename_dir_ns() is updated to use kernfs_get_parent() instead of
dereferencing parent directly.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c        | 175 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/sysfs/dir.c         |  44 ++++---------
 include/linux/kernfs.h |  16 ++++-
 3 files changed, 193 insertions(+), 42 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 42a250f..a347792 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -19,6 +19,8 @@
 #include "kernfs-internal.h"
 
 DEFINE_MUTEX(kernfs_mutex);
+static DEFINE_SPINLOCK(kernfs_rename_lock);	/* kn->parent and ->name */
+static char kernfs_pr_cont_buf[PATH_MAX];	/* protected by rename_lock */
 
 #define rb_to_kn(X) rb_entry((X), struct kernfs_node, rb)
 
@@ -37,6 +39,141 @@ static bool kernfs_lockdep(struct kernfs_node *kn)
 #endif
 }
 
+static int kernfs_name_locked(struct kernfs_node *kn, char *buf, size_t buflen)
+{
+	return strlcpy(buf, kn->parent ? kn->name : "/", buflen);
+}
+
+static char * __must_check kernfs_path_locked(struct kernfs_node *kn, char *buf,
+					      size_t buflen)
+{
+	char *p = buf + buflen;
+	int len;
+
+	*--p = '\0';
+
+	do {
+		len = strlen(kn->name);
+		if (p - buf < len + 1) {
+			buf[0] = '\0';
+			p = NULL;
+			break;
+		}
+		p -= len;
+		memcpy(p, kn->name, len);
+		*--p = '/';
+		kn = kn->parent;
+	} while (kn && kn->parent);
+
+	return p;
+}
+
+/**
+ * kernfs_name - obtain the name of a given node
+ * @kn: kernfs_node of interest
+ * @buf: buffer to copy @kn's name into
+ * @buflen: size of @buf
+ *
+ * Copies the name of @kn into @buf of @buflen bytes.  The behavior is
+ * similar to strlcpy().  It returns the length of @kn's name and if @buf
+ * isn't long enough, it's filled upto @buflen-1 and nul terminated.
+ *
+ * This function can be called from any context.
+ */
+int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&kernfs_rename_lock, flags);
+	ret = kernfs_name_locked(kn, buf, buflen);
+	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
+	return ret;
+}
+
+/**
+ * kernfs_path - build full path of a given node
+ * @kn: kernfs_node of interest
+ * @buf: buffer to copy @kn's name into
+ * @buflen: size of @buf
+ *
+ * Builds and returns the full path of @kn in @buf of @buflen bytes.  The
+ * path is built from the end of @buf so the returned pointer usually
+ * doesn't match @buf.  If @buf isn't long enough, @buf is nul terminated
+ * and %NULL is returned.
+ */
+char *kernfs_path(struct kernfs_node *kn, char *buf, size_t buflen)
+{
+	unsigned long flags;
+	char *p;
+
+	spin_lock_irqsave(&kernfs_rename_lock, flags);
+	p = kernfs_path_locked(kn, buf, buflen);
+	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
+	return p;
+}
+
+/**
+ * pr_cont_kernfs_name - pr_cont name of a kernfs_node
+ * @kn: kernfs_node of interest
+ *
+ * This function can be called from any context.
+ */
+void pr_cont_kernfs_name(struct kernfs_node *kn)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&kernfs_rename_lock, flags);
+
+	kernfs_name_locked(kn, kernfs_pr_cont_buf, sizeof(kernfs_pr_cont_buf));
+	pr_cont("%s", kernfs_pr_cont_buf);
+
+	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
+}
+
+/**
+ * pr_cont_kernfs_path - pr_cont path of a kernfs_node
+ * @kn: kernfs_node of interest
+ *
+ * This function can be called from any context.
+ */
+void pr_cont_kernfs_path(struct kernfs_node *kn)
+{
+	unsigned long flags;
+	char *p;
+
+	spin_lock_irqsave(&kernfs_rename_lock, flags);
+
+	p = kernfs_path_locked(kn, kernfs_pr_cont_buf,
+			       sizeof(kernfs_pr_cont_buf));
+	if (p)
+		pr_cont("%s", p);
+	else
+		pr_cont("<name too long>");
+
+	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
+}
+
+/**
+ * kernfs_get_parent - determine the parent node and pin it
+ * @kn: kernfs_node of interest
+ *
+ * Determines @kn's parent, pins and returns it.  This function can be
+ * called from any context.
+ */
+struct kernfs_node *kernfs_get_parent(struct kernfs_node *kn)
+{
+	struct kernfs_node *parent;
+	unsigned long flags;
+
+	spin_lock_irqsave(&kernfs_rename_lock, flags);
+	parent = kn->parent;
+	kernfs_get(parent);
+	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
+
+	return parent;
+}
+
 /**
  *	kernfs_name_hash
  *	@name: Null terminated string to hash
@@ -1103,8 +1240,14 @@ int kernfs_remove_by_name_ns(struct kernfs_node *parent, const char *name,
 int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 		     const char *new_name, const void *new_ns)
 {
+	struct kernfs_node *old_parent;
+	const char *old_name = NULL;
 	int error;
 
+	/* can't move or rename root */
+	if (!kn->parent)
+		return -EINVAL;
+
 	mutex_lock(&kernfs_mutex);
 
 	error = -ENOENT;
@@ -1126,13 +1269,8 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 		new_name = kstrdup(new_name, GFP_KERNEL);
 		if (!new_name)
 			goto out;
-
-		if (kn->flags & KERNFS_STATIC_NAME)
-			kn->flags &= ~KERNFS_STATIC_NAME;
-		else
-			kfree(kn->name);
-
-		kn->name = new_name;
+	} else {
+		new_name = NULL;
 	}
 
 	/*
@@ -1140,12 +1278,29 @@ int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	 */
 	kernfs_unlink_sibling(kn);
 	kernfs_get(new_parent);
-	kernfs_put(kn->parent);
-	kn->ns = new_ns;
-	kn->hash = kernfs_name_hash(kn->name, kn->ns);
+
+	/* rename_lock protects ->parent and ->name accessors */
+	spin_lock_irq(&kernfs_rename_lock);
+
+	old_parent = kn->parent;
 	kn->parent = new_parent;
+
+	kn->ns = new_ns;
+	if (new_name) {
+		if (!(kn->flags & KERNFS_STATIC_NAME))
+			old_name = kn->name;
+		kn->flags &= ~KERNFS_STATIC_NAME;
+		kn->name = new_name;
+	}
+
+	spin_unlock_irq(&kernfs_rename_lock);
+
+	kn->hash = kernfs_name_hash(new_name, new_ns);
 	kernfs_link_sibling(kn);
 
+	kernfs_put(old_parent);
+	kfree(old_name);
+
 	error = 0;
  out:
 	mutex_unlock(&kernfs_mutex);
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index ee0d761..0b45ff4 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -19,39 +19,18 @@
 
 DEFINE_SPINLOCK(sysfs_symlink_target_lock);
 
-/**
- *	sysfs_pathname - return full path to sysfs dirent
- *	@kn: kernfs_node whose path we want
- *	@path: caller allocated buffer of size PATH_MAX
- *
- *	Gives the name "/" to the sysfs_root entry; any path returned
- *	is relative to wherever sysfs is mounted.
- */
-static char *sysfs_pathname(struct kernfs_node *kn, char *path)
-{
-	if (kn->parent) {
-		sysfs_pathname(kn->parent, path);
-		strlcat(path, "/", PATH_MAX);
-	}
-	strlcat(path, kn->name, PATH_MAX);
-	return path;
-}
-
 void sysfs_warn_dup(struct kernfs_node *parent, const char *name)
 {
-	char *path;
+	char *buf, *path = NULL;
 
-	path = kzalloc(PATH_MAX, GFP_KERNEL);
-	if (path) {
-		sysfs_pathname(parent, path);
-		strlcat(path, "/", PATH_MAX);
-		strlcat(path, name, PATH_MAX);
-	}
+	buf = kzalloc(PATH_MAX, GFP_KERNEL);
+	if (buf)
+		path = kernfs_path(parent, buf, PATH_MAX);
 
-	WARN(1, KERN_WARNING "sysfs: cannot create duplicate filename '%s'\n",
-	     path ? path : name);
+	WARN(1, KERN_WARNING "sysfs: cannot create duplicate filename '%s/%s'\n",
+	     path, name);
 
-	kfree(path);
+	kfree(buf);
 }
 
 /**
@@ -122,9 +101,13 @@ void sysfs_remove_dir(struct kobject *kobj)
 int sysfs_rename_dir_ns(struct kobject *kobj, const char *new_name,
 			const void *new_ns)
 {
-	struct kernfs_node *parent = kobj->sd->parent;
+	struct kernfs_node *parent;
+	int ret;
 
-	return kernfs_rename_ns(kobj->sd, parent, new_name, new_ns);
+	parent = kernfs_get_parent(kobj->sd);
+	ret = kernfs_rename_ns(kobj->sd, parent, new_name, new_ns);
+	kernfs_put(parent);
+	return ret;
 }
 
 int sysfs_move_dir_ns(struct kobject *kobj, struct kobject *new_parent_kobj,
@@ -133,7 +116,6 @@ int sysfs_move_dir_ns(struct kobject *kobj, struct kobject *new_parent_kobj,
 	struct kernfs_node *kn = kobj->sd;
 	struct kernfs_node *new_parent;
 
-	BUG_ON(!kn->parent);
 	new_parent = new_parent_kobj && new_parent_kobj->sd ?
 		new_parent_kobj->sd : sysfs_root_kn;
 
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 9c89904..deb05976 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -91,7 +91,12 @@ struct kernfs_node {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
-	/* the following two fields are published */
+	/*
+	 * Use kernfs_get_parent() and kernfs_name/path() instead of
+	 * accessing the following two fields directly.  If the node is
+	 * never moved to a different parent, it is safe to access the
+	 * parent directly.
+	 */
 	struct kernfs_node	*parent;
 	const char		*name;
 
@@ -229,6 +234,12 @@ static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
 	return kn->flags & KERNFS_NS;
 }
 
+int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen);
+char * __must_check kernfs_path(struct kernfs_node *kn, char *buf,
+				size_t buflen);
+void pr_cont_kernfs_name(struct kernfs_node *kn);
+void pr_cont_kernfs_path(struct kernfs_node *kn);
+struct kernfs_node *kernfs_get_parent(struct kernfs_node *kn);
 struct kernfs_node *kernfs_find_and_get_ns(struct kernfs_node *parent,
 					   const char *name, const void *ns);
 void kernfs_get(struct kernfs_node *kn);
@@ -283,6 +294,9 @@ static inline void kernfs_enable_ns(struct kernfs_node *kn) { }
 static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
 { return false; }
 
+static inline int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen)
+{ return -ENOSYS; }
+
 static inline struct kernfs_node *
 kernfs_find_and_get_ns(struct kernfs_node *parent, const char *name,
 		       const void *ns)
-- 
1.8.5.3

