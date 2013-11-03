Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3KCJyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 04:54:18 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:58724 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3KCJyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:54:12 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 38/39] sysfs, kernfs: make sysfs_dirent definition public
Date: Sun,  3 Nov 2013 04:53:17 -0500
Message-Id: <1383472398-17812-39-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383472398-17812-1-git-send-email-tj@kernel.org>
References: <1383472398-17812-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_dirent includes some information which should be available to
kernfs users - the type, name and parent pointer.  This patch moves
sysfs_dirent definition from kernfs/kernfs-internal.h to
include/linux/kernfs.h so that kernfs users can access them.

The type part of flags is exported as enum kernfs_node_type and
sysfs_type() is moved to include/linux/kernfs.h and updated to return
the enum type.  sysfs_dirent->s_parent and ->s_name are marked
explicitly as public.

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/kernfs-internal.h | 76 +---------------------------------------
 include/linux/kernfs.h      | 84 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 84 insertions(+), 76 deletions(-)

diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 933b7f8..ace0b81 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -13,88 +13,19 @@
 
 #include <linux/lockdep.h>
 #include <linux/fs.h>
-#include <linux/rbtree.h>
 #include <linux/mutex.h>
 
 #include <linux/kernfs.h>
 
-struct sysfs_open_dirent;
-
-/* type-specific structures for sysfs_dirent->s_* union members */
-struct sysfs_elem_dir {
-	unsigned long		subdirs;
-	/* children rbtree starts here and goes through sd->s_rb */
-	struct rb_root		children;
-
-	/*
-	 * The kernfs hierarchy this directory belongs to.  This fits
-	 * better directly in sysfs_dirent but is here to save space.
-	 */
-	struct kernfs_root	*root;
-};
-
-struct sysfs_elem_symlink {
-	struct sysfs_dirent	*target_sd;
-};
-
-struct sysfs_elem_attr {
-	const struct kernfs_ops	*ops;
-	struct sysfs_open_dirent *open;
-	loff_t			size;
-};
-
 struct sysfs_inode_attrs {
 	struct iattr	ia_iattr;
 	void		*ia_secdata;
 	u32		ia_secdata_len;
 };
 
-/*
- * sysfs_dirent - the building block of sysfs hierarchy.  Each and
- * every sysfs node is represented by single sysfs_dirent.
- *
- * As long as s_count reference is held, the sysfs_dirent itself is
- * accessible.  Dereferencing s_elem or any other outer entity
- * requires s_active reference.
- */
-struct sysfs_dirent {
-	atomic_t		s_count;
-	atomic_t		s_active;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map	dep_map;
-#endif
-	struct sysfs_dirent	*s_parent;
-	const char		*s_name;
-
-	struct rb_node		s_rb;
-
-	union {
-		struct completion	*completion;
-		struct sysfs_dirent	*removed_list;
-	} u;
-
-	const void		*s_ns; /* namespace tag */
-	unsigned int		s_hash; /* ns + name hash */
-	union {
-		struct sysfs_elem_dir		s_dir;
-		struct sysfs_elem_symlink	s_symlink;
-		struct sysfs_elem_attr		s_attr;
-	};
-
-	void			*priv;
-
-	unsigned short		s_flags;
-	umode_t			s_mode;
-	unsigned int		s_ino;
-	struct sysfs_inode_attrs *s_iattr;
-};
-
 #define SD_DEACTIVATED_BIAS		INT_MIN
 
-#define SYSFS_TYPE_MASK			0x000f
-#define SYSFS_DIR			0x0001
-#define SYSFS_KOBJ_ATTR			0x0002
-#define SYSFS_KOBJ_LINK			0x0004
+/* SYSFS_TYPE_MASK and types are defined in include/linux/kernfs.h */
 #define SYSFS_COPY_NAME			(SYSFS_DIR | SYSFS_KOBJ_LINK)
 #define SYSFS_ACTIVE_REF		SYSFS_KOBJ_ATTR
 
@@ -105,11 +36,6 @@ struct sysfs_dirent {
 #define SYSFS_FLAG_HAS_MMAP		0x0080
 #define SYSFS_FLAG_LOCKDEP		0x0100
 
-static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
-{
-	return sd->s_flags & SYSFS_TYPE_MASK;
-}
-
 /**
  * kernfs_root - find out the kernfs_root a sysfs_dirent belongs to
  * @sd: sysfs_dirent of interest
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 403cbc5..3084977 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -13,6 +13,9 @@
 #include <linux/mutex.h>
 #include <linux/idr.h>
 #include <linux/lockdep.h>
+#include <linux/rbtree.h>
+#include <linux/atomic.h>
+#include <linux/completion.h>
 
 struct file;
 struct iattr;
@@ -21,7 +24,81 @@ struct vm_area_struct;
 struct super_block;
 struct file_system_type;
 
-struct sysfs_dirent;
+struct sysfs_open_dirent;
+struct sysfs_inode_attrs;
+
+#define SYSFS_TYPE_MASK		0x000f
+
+enum kernfs_node_type {
+	SYSFS_DIR		= 0x0001,
+	SYSFS_KOBJ_ATTR		= 0x0002,
+	SYSFS_KOBJ_LINK		= 0x0004,
+};
+
+/* type-specific structures for sysfs_dirent->s_* union members */
+struct sysfs_elem_dir {
+	unsigned long		subdirs;
+	/* children rbtree starts here and goes through sd->s_rb */
+	struct rb_root		children;
+
+	/*
+	 * The kernfs hierarchy this directory belongs to.  This fits
+	 * better directly in sysfs_dirent but is here to save space.
+	 */
+	struct kernfs_root	*root;
+};
+
+struct sysfs_elem_symlink {
+	struct sysfs_dirent	*target_sd;
+};
+
+struct sysfs_elem_attr {
+	const struct kernfs_ops	*ops;
+	struct sysfs_open_dirent *open;
+	loff_t			size;
+};
+
+/*
+ * sysfs_dirent - the building block of sysfs hierarchy.  Each and every
+ * sysfs node is represented by single sysfs_dirent.  Most fields are
+ * private to kernfs and shouldn't be accessed directly by kernfs users.
+ *
+ * As long as s_count reference is held, the sysfs_dirent itself is
+ * accessible.  Dereferencing s_elem or any other outer entity
+ * requires s_active reference.
+ */
+struct sysfs_dirent {
+	atomic_t		s_count;
+	atomic_t		s_active;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+#endif
+	/* the following two fields are published */
+	struct sysfs_dirent	*s_parent;
+	const char		*s_name;
+
+	struct rb_node		s_rb;
+
+	union {
+		struct completion	*completion;
+		struct sysfs_dirent	*removed_list;
+	} u;
+
+	const void		*s_ns; /* namespace tag */
+	unsigned int		s_hash; /* ns + name hash */
+	union {
+		struct sysfs_elem_dir		s_dir;
+		struct sysfs_elem_symlink	s_symlink;
+		struct sysfs_elem_attr		s_attr;
+	};
+
+	void			*priv;
+
+	unsigned short		s_flags;
+	umode_t			s_mode;
+	unsigned int		s_ino;
+	struct sysfs_inode_attrs *s_iattr;
+};
 
 struct kernfs_root {
 	/* published fields */
@@ -80,6 +157,11 @@ struct kernfs_ops {
 #endif
 };
 
+static inline enum kernfs_node_type sysfs_type(struct sysfs_dirent *sd)
+{
+	return sd->s_flags & SYSFS_TYPE_MASK;
+}
+
 #ifdef CONFIG_SYSFS
 
 struct sysfs_dirent *kernfs_find_and_get_ns(struct sysfs_dirent *parent,
-- 
1.8.3.1

