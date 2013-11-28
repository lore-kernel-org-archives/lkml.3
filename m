Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab3K1Tzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:55:37 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:39507 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab3K1TzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:20 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/34] sysfs, kernfs: move internal decls to fs/kernfs/kernfs-internal.h
Date: Thu, 28 Nov 2013 14:54:31 -0500
Message-Id: <1385668487-10181-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move data structure, constant and basic accessor declarations from
fs/sysfs/sysfs.h to fs/kernfs/kernfs-internal.h.  The two files
currently include each other.  Once kernfs / sysfs separation is
complete, the cross inclusions will be removed.  Inclusion protectors
are added to fs/sysfs/sysfs.h to allow cross-inclusion.

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/kernfs-internal.h | 115 ++++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/sysfs.h            | 102 +++------------------------------------
 2 files changed, 121 insertions(+), 96 deletions(-)
 create mode 100644 fs/kernfs/kernfs-internal.h

diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
new file mode 100644
index 0000000..5a2c3a1
--- /dev/null
+++ b/fs/kernfs/kernfs-internal.h
@@ -0,0 +1,115 @@
+/*
+ * fs/kernfs/kernfs-internal.h - kernfs internal header file
+ *
+ * Copyright (c) 2001-3 Patrick Mochel
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007, 2013 Tejun Heo <teheo@suse.de>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#ifndef __KERNFS_INTERNAL_H
+#define __KERNFS_INTERNAL_H
+
+#include <linux/lockdep.h>
+#include <linux/fs.h>
+#include <linux/rbtree.h>
+
+#include <linux/kernfs.h>
+
+struct sysfs_open_dirent;
+
+/* type-specific structures for sysfs_dirent->s_* union members */
+struct sysfs_elem_dir {
+	unsigned long		subdirs;
+	/* children rbtree starts here and goes through sd->s_rb */
+	struct rb_root		children;
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
+struct sysfs_inode_attrs {
+	struct iattr	ia_iattr;
+	void		*ia_secdata;
+	u32		ia_secdata_len;
+};
+
+/*
+ * sysfs_dirent - the building block of sysfs hierarchy.  Each and
+ * every sysfs node is represented by single sysfs_dirent.
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
+
+#define SD_DEACTIVATED_BIAS		INT_MIN
+
+#define SYSFS_TYPE_MASK			0x000f
+#define SYSFS_DIR			0x0001
+#define SYSFS_KOBJ_ATTR			0x0002
+#define SYSFS_KOBJ_LINK			0x0004
+#define SYSFS_COPY_NAME			(SYSFS_DIR | SYSFS_KOBJ_LINK)
+#define SYSFS_ACTIVE_REF		SYSFS_KOBJ_ATTR
+
+#define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
+#define SYSFS_FLAG_REMOVED		0x0010
+#define SYSFS_FLAG_NS			0x0020
+#define SYSFS_FLAG_HAS_SEQ_SHOW		0x0040
+#define SYSFS_FLAG_HAS_MMAP		0x0080
+#define SYSFS_FLAG_LOCKDEP		0x0100
+
+static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
+{
+	return sd->s_flags & SYSFS_TYPE_MASK;
+}
+
+/*
+ * Context structure to be used while adding/removing nodes.
+ */
+struct sysfs_addrm_cxt {
+	struct sysfs_dirent	*removed;
+};
+
+#include "../sysfs/sysfs.h"
+
+#endif	/* __KERNFS_INTERNAL_H */
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 85315e2..f8c936f 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -8,103 +8,11 @@
  * This file is released under the GPLv2.
  */
 
-#include <linux/lockdep.h>
-#include <linux/kobject_ns.h>
-#include <linux/fs.h>
-#include <linux/rbtree.h>
+#ifndef __SYSFS_INTERNAL_H
+#define __SYSFS_INTERNAL_H
 
-struct sysfs_open_dirent;
-
-/* type-specific structures for sysfs_dirent->s_* union members */
-struct sysfs_elem_dir {
-	unsigned long		subdirs;
-	/* children rbtree starts here and goes through sd->s_rb */
-	struct rb_root		children;
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
-struct sysfs_inode_attrs {
-	struct iattr	ia_iattr;
-	void		*ia_secdata;
-	u32		ia_secdata_len;
-};
-
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
-#define SD_DEACTIVATED_BIAS		INT_MIN
-
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
-
-/*
- * Context structure to be used while adding/removing nodes.
- */
-struct sysfs_addrm_cxt {
-	struct sysfs_dirent	*removed;
-};
+#include "../kernfs/kernfs-internal.h"
+#include <linux/sysfs.h>
 
 /*
  * mount.c
@@ -175,3 +83,5 @@ void sysfs_unmap_bin_file(struct sysfs_dirent *sd);
 extern const struct inode_operations sysfs_symlink_inode_operations;
 int sysfs_create_link_sd(struct sysfs_dirent *sd, struct kobject *target,
 			 const char *name);
+
+#endif	/* __SYSFS_INTERNAL_H */
-- 
1.8.4.2

