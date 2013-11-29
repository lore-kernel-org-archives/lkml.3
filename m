Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab3K2WSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 17:18:43 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:44524 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3K2WSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 17:18:39 -0500
Date: Fri, 29 Nov 2013 17:18:32 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 32/34] sysfs, kernfs: make sysfs_dirent definition public
Message-ID: <20131129221832.GF21755@mtj.dyndns.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
 <1385668487-10181-33-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385668487-10181-33-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_dirent includes some information which should be available to
kernfs users - the type, flags, name and parent pointer.  This patch
moves sysfs_dirent definition from kernfs/kernfs-internal.h to
include/linux/kernfs.h so that kernfs users can access them.

The type part of flags is exported as enum kernfs_node_type, the flags
kernfs_node_flag, sysfs_type() and kernfs_enable_ns() are moved to
include/linux/kernfs.h and the former is updated to return the enum
type.  sysfs_dirent->s_parent and ->s_name are marked explicitly as
public.

This patch doesn't introduce any functional changes.

v2: Flags exported too and kernfs_enable_ns() definition moved.

v3: While moving kernfs_enable_ns() to include/linux/kernfs.h, v1 and
    v2 put the definition outside CONFIG_SYSFS replacing the dummy
    implementation with the actual implementation too.  Unfortunately,
    this can lead to oops when !CONFIG_SYSFS because
    kernfs_enable_ns() may be called on a NULL @sd and now tries to
    dereference @sd instead of not doing anything.  This issue was
    reported by Yuanhan Liu.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 fs/kernfs/dir.c             |  15 ------
 fs/kernfs/kernfs-internal.h |  85 +------------------------------
 include/linux/kernfs.h      | 118 ++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 115 insertions(+), 103 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index eaffa83..7c5b517 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -895,21 +895,6 @@ int kernfs_rename_ns(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
 	return error;
 }
 
-/**
- * kernfs_enable_ns - enable namespace under a directory
- * @sd: directory of interest, should be empty
- *
- * This is to be called right after @sd is created to enable namespace
- * under it.  All children of @sd must have non-NULL namespace tags and
- * only the ones which match the super_block's tag will be visible.
- */
-void kernfs_enable_ns(struct sysfs_dirent *sd)
-{
-	WARN_ON_ONCE(sysfs_type(sd) != SYSFS_DIR);
-	WARN_ON_ONCE(!RB_EMPTY_ROOT(&sd->s_dir.children));
-	sd->s_flags |= SYSFS_FLAG_NS;
-}
-
 /* Relationship between s_mode and the DT_xxx types */
 static inline unsigned char dt_type(struct sysfs_dirent *sd)
 {
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index ced0d6d..f33a784 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -13,102 +13,19 @@
 
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
-#define SYSFS_COPY_NAME			(SYSFS_DIR | SYSFS_KOBJ_LINK)
-#define SYSFS_ACTIVE_REF		SYSFS_KOBJ_ATTR
-
-#define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
-#define SYSFS_FLAG_REMOVED		0x0010
-#define SYSFS_FLAG_NS			0x0020
-#define SYSFS_FLAG_HAS_SEQ_SHOW		0x0040
-#define SYSFS_FLAG_HAS_MMAP		0x0080
-#define SYSFS_FLAG_LOCKDEP		0x0100
-
-static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
-{
-	return sd->s_flags & SYSFS_TYPE_MASK;
-}
+/* SYSFS_TYPE_MASK and types are defined in include/linux/kernfs.h */
 
 /**
  * kernfs_root - find out the kernfs_root a sysfs_dirent belongs to
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 75fcbe5..faaf4f2 100644
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
@@ -21,7 +24,92 @@ struct vm_area_struct;
 struct super_block;
 struct file_system_type;
 
-struct sysfs_dirent;
+struct sysfs_open_dirent;
+struct sysfs_inode_attrs;
+
+enum kernfs_node_type {
+	SYSFS_DIR		= 0x0001,
+	SYSFS_KOBJ_ATTR		= 0x0002,
+	SYSFS_KOBJ_LINK		= 0x0004,
+};
+
+#define SYSFS_TYPE_MASK		0x000f
+#define SYSFS_COPY_NAME		(SYSFS_DIR | SYSFS_KOBJ_LINK)
+#define SYSFS_ACTIVE_REF	SYSFS_KOBJ_ATTR
+#define SYSFS_FLAG_MASK		~SYSFS_TYPE_MASK
+
+enum kernfs_node_flag {
+	SYSFS_FLAG_REMOVED	= 0x0010,
+	SYSFS_FLAG_NS		= 0x0020,
+	SYSFS_FLAG_HAS_SEQ_SHOW	= 0x0040,
+	SYSFS_FLAG_HAS_MMAP	= 0x0080,
+	SYSFS_FLAG_LOCKDEP	= 0x0100,
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
@@ -82,6 +170,26 @@ struct kernfs_ops {
 
 #ifdef CONFIG_SYSFS
 
+static inline enum kernfs_node_type sysfs_type(struct sysfs_dirent *sd)
+{
+	return sd->s_flags & SYSFS_TYPE_MASK;
+}
+
+/**
+ * kernfs_enable_ns - enable namespace under a directory
+ * @sd: directory of interest, should be empty
+ *
+ * This is to be called right after @sd is created to enable namespace
+ * under it.  All children of @sd must have non-NULL namespace tags and
+ * only the ones which match the super_block's tag will be visible.
+ */
+static inline void kernfs_enable_ns(struct sysfs_dirent *sd)
+{
+	WARN_ON_ONCE(sysfs_type(sd) != SYSFS_DIR);
+	WARN_ON_ONCE(!RB_EMPTY_ROOT(&sd->s_dir.children));
+	sd->s_flags |= SYSFS_FLAG_NS;
+}
+
 struct sysfs_dirent *kernfs_find_and_get_ns(struct sysfs_dirent *parent,
 					    const char *name, const void *ns);
 void kernfs_get(struct sysfs_dirent *sd);
@@ -107,7 +215,6 @@ int kernfs_remove_by_name_ns(struct sysfs_dirent *parent, const char *name,
 			     const void *ns);
 int kernfs_rename_ns(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
 		     const char *new_name, const void *new_ns);
-void kernfs_enable_ns(struct sysfs_dirent *sd);
 int kernfs_setattr(struct sysfs_dirent *sd, const struct iattr *iattr);
 void kernfs_notify(struct sysfs_dirent *sd);
 
@@ -120,6 +227,11 @@ void kernfs_init(void);
 
 #else	/* CONFIG_SYSFS */
 
+static inline enum kernfs_node_type sysfs_type(struct sysfs_dirent *sd)
+{ return 0; }	/* whatever */
+
+static inline void kernfs_enable_ns(struct sysfs_dirent *sd) { }
+
 static inline struct sysfs_dirent *
 kernfs_find_and_get_ns(struct sysfs_dirent *parent, const char *name,
 		       const void *ns)
@@ -161,8 +273,6 @@ static inline int kernfs_rename_ns(struct sysfs_dirent *sd,
 				   const char *new_name, const void *new_ns)
 { return -ENOSYS; }
 
-static inline void kernfs_enable_ns(struct sysfs_dirent *sd) { }
-
 static inline int kernfs_setattr(struct sysfs_dirent *sd,
 				 const struct iattr *iattr)
 { return -ENOSYS; }
-- 
1.8.4.2

