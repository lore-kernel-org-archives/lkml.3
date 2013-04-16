Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965331Ab3DPS1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:27:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965003Ab3DPS1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:27:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 28/28] proc: Move non-public stuff from linux/proc_fs.h to
 fs/proc/internal.h [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Date: Tue, 16 Apr 2013 19:27:42 +0100
Message-ID: <20130416182741.27773.66337.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move non-public declarations and definitions from linux/proc_fs.h to
fs/proc/internal.h.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/proc/internal.h      |  307 ++++++++++++++++++++++++++++++-----------------
 fs/proc/kcore.c         |    1 
 include/linux/proc_fs.h |  151 ++++++-----------------
 3 files changed, 236 insertions(+), 223 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 86a2406..04255b6 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -1,4 +1,4 @@
-/* internal.h: internal procfs definitions
+/* Internal procfs definitions
  *
  * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -9,81 +9,66 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <linux/sched.h>
 #include <linux/proc_fs.h>
+#include <linux/proc_ns.h>
+#include <linux/spinlock.h>
+#include <linux/atomic.h>
 #include <linux/binfmts.h>
-struct  ctl_table_header;
-struct  mempolicy;
 
-extern struct proc_dir_entry proc_root;
-extern void proc_self_init(void);
-#ifdef CONFIG_PROC_SYSCTL
-extern int proc_sys_init(void);
-extern void sysctl_head_put(struct ctl_table_header *head);
-#else
-static inline void proc_sys_init(void) { }
-static inline void sysctl_head_put(struct ctl_table_header *head) { }
-#endif
-#ifdef CONFIG_NET
-extern int proc_net_init(void);
-#else
-static inline int proc_net_init(void) { return 0; }
-#endif
+struct ctl_table_header;
+struct mempolicy;
 
-struct vmalloc_info {
-	unsigned long	used;
-	unsigned long	largest_chunk;
+/*
+ * This is not completely implemented yet. The idea is to
+ * create an in-memory tree (like the actual /proc filesystem
+ * tree) of these proc_dir_entries, so that we can dynamically
+ * add new files to /proc.
+ *
+ * The "next" pointer creates a linked list of one /proc directory,
+ * while parent/subdir create the directory structure (every
+ * /proc file has a parent, but "subdir" is NULL for all
+ * non-directory entries).
+ */
+struct proc_dir_entry {
+	unsigned int low_ino;
+	umode_t mode;
+	nlink_t nlink;
+	kuid_t uid;
+	kgid_t gid;
+	loff_t size;
+	const struct inode_operations *proc_iops;
+	const struct file_operations *proc_fops;
+	struct proc_dir_entry *next, *parent, *subdir;
+	void *data;
+	atomic_t count;		/* use count */
+	atomic_t in_use;	/* number of callers into module in progress; */
+			/* negative -> it's going away RSN */
+	struct completion *pde_unload_completion;
+	struct list_head pde_openers;	/* who did ->open, but not ->release */
+	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
+	u8 namelen;
+	char name[];
 };
 
-#ifdef CONFIG_MMU
-#define VMALLOC_TOTAL (VMALLOC_END - VMALLOC_START)
-extern void get_vmalloc_info(struct vmalloc_info *vmi);
-#else
-
-#define VMALLOC_TOTAL 0UL
-#define get_vmalloc_info(vmi)			\
-do {						\
-	(vmi)->used = 0;			\
-	(vmi)->largest_chunk = 0;		\
-} while(0)
-#endif
-
-extern int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns,
-				struct pid *pid, struct task_struct *task);
-extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
-				struct pid *pid, struct task_struct *task);
-extern int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
-				struct pid *pid, struct task_struct *task);
-extern int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
-				struct pid *pid, struct task_struct *task);
-extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
-
-extern const struct file_operations proc_tid_children_operations;
-extern const struct file_operations proc_pid_maps_operations;
-extern const struct file_operations proc_tid_maps_operations;
-extern const struct file_operations proc_pid_numa_maps_operations;
-extern const struct file_operations proc_tid_numa_maps_operations;
-extern const struct file_operations proc_pid_smaps_operations;
-extern const struct file_operations proc_tid_smaps_operations;
-extern const struct file_operations proc_clear_refs_operations;
-extern const struct file_operations proc_pagemap_operations;
-extern const struct file_operations proc_net_operations;
-extern const struct inode_operations proc_net_inode_operations;
-extern const struct inode_operations proc_pid_link_inode_operations;
+union proc_op {
+	int (*proc_get_link)(struct dentry *, struct path *);
+	int (*proc_read)(struct task_struct *task, char *page);
+	int (*proc_show)(struct seq_file *m,
+		struct pid_namespace *ns, struct pid *pid,
+		struct task_struct *task);
+};
 
-struct proc_maps_private {
+struct proc_inode {
 	struct pid *pid;
-	struct task_struct *task;
-#ifdef CONFIG_MMU
-	struct vm_area_struct *tail_vma;
-#endif
-#ifdef CONFIG_NUMA
-	struct mempolicy *task_mempolicy;
-#endif
+	int fd;
+	union proc_op op;
+	struct proc_dir_entry *pde;
+	struct ctl_table_header *sysctl;
+	struct ctl_table *sysctl_entry;
+	struct proc_ns ns;
+	struct inode vfs_inode;
 };
 
-void proc_init_inodecache(void);
-
 /*
  * General functions
  */
@@ -150,79 +135,142 @@ out:
 }
 
 /*
- * base.c
+ * Offset of the first process in the /proc root directory..
  */
-extern int pid_delete_dentry(const struct dentry *);
+#define FIRST_PROCESS_ENTRY 256
 
-struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *ino,
-		struct dentry *dentry);
-int proc_readdir_de(struct proc_dir_entry *de, struct file *filp, void *dirent,
-		filldir_t filldir);
+/* Worst case buffer size needed for holding an integer. */
+#define PROC_NUMBUF 13
 
-struct pde_opener {
-	struct file *file;
-	struct list_head lh;
-	int closing;
-	struct completion *c;
-};
+/*
+ * array.c
+ */
+extern const struct file_operations proc_tid_children_operations;
+
+extern int proc_tid_stat(struct seq_file *, struct pid_namespace *,
+			 struct pid *, struct task_struct *);
+extern int proc_tgid_stat(struct seq_file *, struct pid_namespace *,
+			  struct pid *, struct task_struct *);
+extern int proc_pid_status(struct seq_file *, struct pid_namespace *,
+			   struct pid *, struct task_struct *);
+extern int proc_pid_statm(struct seq_file *, struct pid_namespace *,
+			  struct pid *, struct task_struct *);
+
+/*
+ * base.c
+ */
+extern const struct dentry_operations pid_dentry_operations;
+extern int pid_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+extern int proc_setattr(struct dentry *, struct iattr *);
+extern struct inode *proc_pid_make_inode(struct super_block *, struct task_struct *);
+extern int pid_revalidate(struct dentry *, unsigned int);
+extern int pid_delete_dentry(const struct dentry *);
+extern int proc_pid_readdir(struct file *, void *, filldir_t);
+extern struct dentry *proc_pid_lookup(struct inode *, struct dentry *, unsigned int);
+extern loff_t mem_lseek(struct file *, loff_t, int);
 
-void proc_entry_rundown(struct proc_dir_entry *);
+/* Lookups */
+typedef struct dentry *instantiate_t(struct inode *, struct dentry *,
+				     struct task_struct *, const void *);
+extern int proc_fill_cache(struct file *, void *, filldir_t, const char *, int,
+			   instantiate_t, struct task_struct *, const void *);
 
+/*
+ * generic.c
+ */
 extern spinlock_t proc_subdir_lock;
 
-struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsigned int);
-int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);
-unsigned long task_vsize(struct mm_struct *);
-unsigned long task_statm(struct mm_struct *,
-	unsigned long *, unsigned long *, unsigned long *, unsigned long *);
-void task_mem(struct seq_file *, struct mm_struct *);
+extern struct dentry *proc_lookup(struct inode *, struct dentry *, unsigned int);
+extern struct dentry *proc_lookup_de(struct proc_dir_entry *, struct inode *,
+				     struct dentry *);
+extern int proc_readdir(struct file *, void *, filldir_t);
+extern int proc_readdir_de(struct proc_dir_entry *, struct file *, void *, filldir_t);
 
 static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
 {
 	atomic_inc(&pde->count);
 	return pde;
 }
-void pde_put(struct proc_dir_entry *pde);
+extern void pde_put(struct proc_dir_entry *);
+
+/*
+ * inode.c
+ */
+struct pde_opener {
+	struct file *file;
+	struct list_head lh;
+	int closing;
+	struct completion *c;
+};
 
-int proc_fill_super(struct super_block *);
-struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
-int proc_remount(struct super_block *sb, int *flags, char *data);
+extern const struct inode_operations proc_pid_link_inode_operations;
+
+extern void proc_init_inodecache(void);
+extern struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
+extern int proc_fill_super(struct super_block *);
+extern void proc_entry_rundown(struct proc_dir_entry *);
 
 /*
- * These are generic /proc routines that use the internal
- * "struct proc_dir_entry" tree to traverse the filesystem.
- *
- * The /proc root directory has extended versions to take care
- * of the /proc/<pid> subdirectories.
+ * mmu.c
  */
-int proc_readdir(struct file *, void *, filldir_t);
-struct dentry *proc_lookup(struct inode *, struct dentry *, unsigned int);
+struct vmalloc_info {
+	unsigned long	used;
+	unsigned long	largest_chunk;
+};
 
+#ifdef CONFIG_MMU
+#define VMALLOC_TOTAL (VMALLOC_END - VMALLOC_START)
+extern void get_vmalloc_info(struct vmalloc_info *);
 
+#else
+#define VMALLOC_TOTAL 0UL
+static inline void get_vmalloc_info(struct vmalloc_info *vmi)
+{
+	vmi->used = 0;
+	vmi->largest_chunk = 0;
+}
+#endif
 
-/* Lookups */
-typedef struct dentry *instantiate_t(struct inode *, struct dentry *,
-				struct task_struct *, const void *);
-int proc_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
-	const char *name, int len,
-	instantiate_t instantiate, struct task_struct *task, const void *ptr);
-int pid_revalidate(struct dentry *dentry, unsigned int flags);
-struct inode *proc_pid_make_inode(struct super_block * sb, struct task_struct *task);
-extern const struct dentry_operations pid_dentry_operations;
-int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat);
-int proc_setattr(struct dentry *dentry, struct iattr *attr);
+/*
+ * proc_devtree.c
+ */
+#ifdef CONFIG_PROC_DEVICETREE
+extern void proc_device_tree_init(void);
+#endif
 
+/*
+ * proc_namespaces.c
+ */
 extern const struct inode_operations proc_ns_dir_inode_operations;
 extern const struct file_operations proc_ns_dir_operations;
 
+/*
+ * proc_net.c
+ */
+extern const struct file_operations proc_net_operations;
+extern const struct inode_operations proc_net_inode_operations;
+
+#ifdef CONFIG_NET
+extern int proc_net_init(void);
+#else
+static inline int proc_net_init(void) { return 0; }
+#endif
+
+/*
+ * proc_self.c
+ */
 extern int proc_setup_self(struct super_block *);
 
 /*
- * proc_devtree.c
+ * proc_sysctl.c
  */
-#ifdef CONFIG_PROC_DEVICETREE
-extern void proc_device_tree_init(void);
-#endif /* CONFIG_PROC_DEVICETREE */
+#ifdef CONFIG_PROC_SYSCTL
+extern int proc_sys_init(void);
+extern void sysctl_head_put(struct ctl_table_header *);
+#else
+static inline void proc_sys_init(void) { }
+static inline void sysctl_head_put(struct ctl_table_header *head) { }
+#endif
 
 /*
  * proc_tty.c
@@ -232,3 +280,40 @@ extern void proc_tty_init(void);
 #else
 static inline void proc_tty_init(void) {}
 #endif
+
+/*
+ * root.c
+ */
+extern struct proc_dir_entry proc_root;
+
+extern void proc_self_init(void);
+extern int proc_remount(struct super_block *, int *, char *);
+
+/*
+ * task_[no]mmu.c
+ */
+struct proc_maps_private {
+	struct pid *pid;
+	struct task_struct *task;
+#ifdef CONFIG_MMU
+	struct vm_area_struct *tail_vma;
+#endif
+#ifdef CONFIG_NUMA
+	struct mempolicy *task_mempolicy;
+#endif
+};
+
+extern const struct file_operations proc_pid_maps_operations;
+extern const struct file_operations proc_tid_maps_operations;
+extern const struct file_operations proc_pid_numa_maps_operations;
+extern const struct file_operations proc_tid_numa_maps_operations;
+extern const struct file_operations proc_pid_smaps_operations;
+extern const struct file_operations proc_tid_smaps_operations;
+extern const struct file_operations proc_clear_refs_operations;
+extern const struct file_operations proc_pagemap_operations;
+
+extern unsigned long task_vsize(struct mm_struct *);
+extern unsigned long task_statm(struct mm_struct *,
+				unsigned long *, unsigned long *,
+				unsigned long *, unsigned long *);
+extern void task_mem(struct seq_file *, struct mm_struct *);
diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 8e6ce83..13cf87c 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -28,6 +28,7 @@
 #include <linux/ioport.h>
 #include <linux/memory.h>
 #include <asm/sections.h>
+#include "internal.h"
 
 #define CORE_STR "CORE"
 
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 96ede28..05740da 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -1,149 +1,69 @@
-#ifndef _LINUX_PROC_FS_H
-#define _LINUX_PROC_FS_H
-
-#include <linux/slab.h>
-#include <linux/fs.h>
-#include <linux/spinlock.h>
-#include <linux/magic.h>
-#include <linux/atomic.h>
-#include <linux/proc_ns.h>
-
-struct net;
-struct completion;
-struct mm_struct;
-
 /*
  * The proc filesystem constants/structures
  */
+#ifndef _LINUX_PROC_FS_H
+#define _LINUX_PROC_FS_H
 
-/*
- * Offset of the first process in the /proc root directory..
- */
-#define FIRST_PROCESS_ENTRY 256
-
-/* Worst case buffer size needed for holding an integer. */
-#define PROC_NUMBUF 13
-
-/*
- * This is not completely implemented yet. The idea is to
- * create an in-memory tree (like the actual /proc filesystem
- * tree) of these proc_dir_entries, so that we can dynamically
- * add new files to /proc.
- *
- * The "next" pointer creates a linked list of one /proc directory,
- * while parent/subdir create the directory structure (every
- * /proc file has a parent, but "subdir" is NULL for all
- * non-directory entries).
- */
+#include <linux/types.h>
+#include <linux/fs.h>
 
-struct proc_dir_entry {
-	unsigned int low_ino;
-	umode_t mode;
-	nlink_t nlink;
-	kuid_t uid;
-	kgid_t gid;
-	loff_t size;
-	const struct inode_operations *proc_iops;
-	const struct file_operations *proc_fops;
-	struct proc_dir_entry *next, *parent, *subdir;
-	void *data;
-	atomic_t count;		/* use count */
-	atomic_t in_use;	/* number of callers into module in progress; */
-			/* negative -> it's going away RSN */
-	struct completion *pde_unload_completion;
-	struct list_head pde_openers;	/* who did ->open, but not ->release */
-	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
-	u8 namelen;
-	char name[];
-};
+struct proc_dir_entry;
 
 #ifdef CONFIG_PROC_FS
 
 extern void proc_root_init(void);
-
-void proc_flush_task(struct task_struct *task);
-
-struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
-				struct proc_dir_entry *parent,
-				const struct file_operations *proc_fops,
-				void *data);
-extern void proc_remove(struct proc_dir_entry *);
-extern void remove_proc_entry(const char *name, struct proc_dir_entry *parent);
-extern int remove_proc_subtree(const char *name, struct proc_dir_entry *parent);
+extern void proc_flush_task(struct task_struct *);
 
 extern struct proc_dir_entry *proc_symlink(const char *,
 		struct proc_dir_entry *, const char *);
-extern struct proc_dir_entry *proc_mkdir(const char *,struct proc_dir_entry *);
+extern struct proc_dir_entry *proc_mkdir(const char *, struct proc_dir_entry *);
 extern struct proc_dir_entry *proc_mkdir_data(const char *, umode_t,
 					      struct proc_dir_entry *, void *);
-extern struct proc_dir_entry *proc_mkdir_mode(const char *name, umode_t mode,
-			struct proc_dir_entry *parent);
-
-static inline struct proc_dir_entry *proc_create(const char *name, umode_t mode,
-	struct proc_dir_entry *parent, const struct file_operations *proc_fops)
-{
-	return proc_create_data(name, mode, parent, proc_fops, NULL);
-}
+extern struct proc_dir_entry *proc_mkdir_mode(const char *, umode_t,
+					      struct proc_dir_entry *);
  
+extern struct proc_dir_entry *proc_create_data(const char *, umode_t,
+					       struct proc_dir_entry *,
+					       const struct file_operations *,
+					       void *);
+
 extern void proc_set_size(struct proc_dir_entry *, loff_t);
 extern void proc_set_user(struct proc_dir_entry *, kuid_t, kgid_t);
 extern void *PDE_DATA(const struct inode *);
-extern void *proc_get_parent_data(const struct inode *);
-extern const char *get_proc_name(const struct proc_dir_entry *);
 extern struct pid *get_proc_pid(const struct inode *);
-#else
-
-static inline void proc_flush_task(struct task_struct *task)
-{
-}
+extern const char *get_proc_name(const struct proc_dir_entry *);
+extern void *proc_get_parent_data(const struct inode *);
 
-#define proc_create(name, mode, parent, fops)  ({ (void)(mode), NULL; })
+extern void proc_remove(struct proc_dir_entry *);
+extern void remove_proc_entry(const char *, struct proc_dir_entry *);
+extern int remove_proc_subtree(const char *, struct proc_dir_entry *);
 
-static inline struct proc_dir_entry *proc_create_data(const char *name,
-	umode_t mode, struct proc_dir_entry *parent,
-	const struct file_operations *proc_fops, void *data)
-{
-	return NULL;
-}
-static inline void proc_remove(struct proc_dir_entry *de) {}
-#define remove_proc_entry(name, parent) do {} while (0)
-#define remove_proc_subtree(name, parent) do {} while (0)
+#else /* CONFIG_PROC_FS */
 
 static inline struct proc_dir_entry *proc_symlink(const char *name,
-		struct proc_dir_entry *parent,const char *dest) {return NULL;}
+		struct proc_dir_entry *parent,const char *dest) { return NULL;}
 static inline struct proc_dir_entry *proc_mkdir(const char *name,
 	struct proc_dir_entry *parent) {return NULL;}
 static inline struct proc_dir_entry *proc_mkdir_mode(const char *name,
 	umode_t mode, struct proc_dir_entry *parent) { return NULL; }
+
 static inline void proc_set_size(struct proc_dir_entry *de, loff_t size) {}
 static inline void proc_set_user(struct proc_dir_entry *de, kuid_t uid, kgid_t gid) {}
 static inline void *PDE_DATA(const struct inode *inode) { return NULL; }
 static inline struct pid *get_proc_pid(const struct inode *inode) { return NULL; }
+extern const char *get_proc_name(const struct proc_dir_entry *de) { return ""; }
+extern void *proc_get_parent_data(const struct inode *) { return NULL; }
 
-#endif /* CONFIG_PROC_FS */
+static inline struct proc_dir_entry *proc_create_data(const char *name,
+	umode_t mode, struct proc_dir_entry *parent,
+	const struct file_operations *proc_fops, void *data) { return NULL; }
+static inline void proc_set_size(struct proc_dir_entry *de, loff_t size) {}
 
+static inline void proc_remove(struct proc_dir_entry *de) {}
+static inline void remove_proc_entry(const char *name, struct proc_dir_entry *parent) {}
+static inline int remove_proc_subtree(const char *name, struct proc_dir_entry *parent) { return 0; }
 
-union proc_op {
-	int (*proc_get_link)(struct dentry *, struct path *);
-	int (*proc_read)(struct task_struct *task, char *page);
-	int (*proc_show)(struct seq_file *m,
-		struct pid_namespace *ns, struct pid *pid,
-		struct task_struct *task);
-};
-
-struct ctl_table_header;
-struct ctl_table;
-
-struct proc_inode {
-	struct pid *pid;
-	int fd;
-	union proc_op op;
-	struct proc_dir_entry *pde;
-	struct ctl_table_header *sysctl;
-	struct ctl_table *sysctl_entry;
-	struct proc_ns ns;
-	struct inode vfs_inode;
-};
+#endif /* CONFIG_PROC_FS */
 
 static inline struct proc_dir_entry *proc_net_mkdir(
 	struct net *net, const char *name, struct proc_dir_entry *parent)
@@ -151,4 +71,11 @@ static inline struct proc_dir_entry *proc_net_mkdir(
 	return proc_mkdir_data(name, 0, parent, net);
 }
 
+static inline struct proc_dir_entry *proc_create(
+	const char *name, umode_t mode, struct proc_dir_entry *parent,
+	const struct file_operations *proc_fops)
+{
+	return proc_create_data(name, mode, parent, proc_fops, NULL);
+}
+
 #endif /* _LINUX_PROC_FS_H */

