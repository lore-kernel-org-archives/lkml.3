Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3GADO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 23:14:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37121 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194Ab3GADOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 23:14:52 -0400
X-Sasl-enc: 57B8pzqHWXCav0Uqya/XUzVn6BE/p7NmVAHEoY5UVwNM 1372648487
Subject: [RFC PATCH 6/7] autofs - rename module autofs4 to autofs
To: linux-next@vger.kernel.org
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 01 Jul 2013 11:14:43 +0800
Message-ID: <20130701031442.4423.68822.stgit@perseus.fritz.box>
In-Reply-To: <20130701031335.4423.6154.stgit@perseus.fritz.box>
References: <20130701031335.4423.6154.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename autofs4 to autofs since is now the only module that provides the autofs
file system and the module is not version 4 specific.

Changes that will need to be made should be limited to:
- source include statments should be changed from autofs_fs4.h to autofs_fs.h
  since these two header file have been merged.
- user space scripts that manually load autofs4.ko should be changed to load
  autofs.ko. Since the module directory name and the module name itself are
  the same now there is no need to manually load module.
- any "alias autofs autofs4" will need to be removed.
- configure AUTOFS_FS instead of AUTOFS4_FS from now on.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 MAINTAINERS            |    4 
 fs/Kconfig             |    1 
 fs/Makefile            |    1 
 fs/autofs/Kconfig      |   19 +
 fs/autofs/Makefile     |    7 
 fs/autofs/autofs_i.h   |  341 ++++++++++++++++++
 fs/autofs/dev-ioctl.c  |  759 +++++++++++++++++++++++++++++++++++++++++
 fs/autofs/expire.c     |  561 ++++++++++++++++++++++++++++++
 fs/autofs/init.c       |   49 +++
 fs/autofs/inode.c      |  368 ++++++++++++++++++++
 fs/autofs/root.c       |  898 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/autofs/symlink.c    |   21 +
 fs/autofs/waitq.c      |  570 ++++++++++++++++++++++++++++++
 fs/autofs4/Kconfig     |   31 +-
 fs/autofs4/Makefile    |   10 -
 fs/autofs4/autofs_i.h  |  341 ------------------
 fs/autofs4/dev-ioctl.c |  760 -----------------------------------------
 fs/autofs4/expire.c    |  562 ------------------------------
 fs/autofs4/init.c      |   49 ---
 fs/autofs4/inode.c     |  368 --------------------
 fs/autofs4/root.c      |  898 ------------------------------------------------
 fs/autofs4/symlink.c   |   21 -
 fs/autofs4/waitq.c     |  571 -------------------------------
 23 files changed, 3627 insertions(+), 3583 deletions(-)
 create mode 100644 fs/autofs/Kconfig
 create mode 100644 fs/autofs/Makefile
 create mode 100644 fs/autofs/autofs_i.h
 create mode 100644 fs/autofs/dev-ioctl.c
 create mode 100644 fs/autofs/expire.c
 create mode 100644 fs/autofs/init.c
 create mode 100644 fs/autofs/inode.c
 create mode 100644 fs/autofs/root.c
 create mode 100644 fs/autofs/symlink.c
 create mode 100644 fs/autofs/waitq.c
 delete mode 100644 fs/autofs4/autofs_i.h
 delete mode 100644 fs/autofs4/dev-ioctl.c
 delete mode 100644 fs/autofs4/expire.c
 delete mode 100644 fs/autofs4/init.c
 delete mode 100644 fs/autofs4/inode.c
 delete mode 100644 fs/autofs4/root.c
 delete mode 100644 fs/autofs4/symlink.c
 delete mode 100644 fs/autofs4/waitq.c

diff --git a/MAINTAINERS b/MAINTAINERS
index bd30092..d83b551 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4679,11 +4679,11 @@ W:	http://linuxtv.org
 S:	Maintained
 F:	drivers/media/radio/radio-keene*
 
-KERNEL AUTOMOUNTER v4 (AUTOFS4)
+KERNEL AUTOMOUNTER v4 (AUTOFS)
 M:	Ian Kent <raven@themaw.net>
 L:	autofs@vger.kernel.org
 S:	Maintained
-F:	fs/autofs4/
+F:	fs/autofs/
 
 KERNEL BUILD + files below scripts/ (unless maintained elsewhere)
 M:	Michal Marek <mmarek@suse.cz>
diff --git a/fs/Kconfig b/fs/Kconfig
index c229f82..5c071f3 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -65,6 +65,7 @@ source "fs/notify/Kconfig"
 
 source "fs/quota/Kconfig"
 
+source "fs/autofs/Kconfig"
 source "fs/autofs4/Kconfig"
 source "fs/fuse/Kconfig"
 
diff --git a/fs/Makefile b/fs/Makefile
index 4fe6df3..d433f30 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -102,6 +102,7 @@ obj-$(CONFIG_AFFS_FS)		+= affs/
 obj-$(CONFIG_ROMFS_FS)		+= romfs/
 obj-$(CONFIG_QNX4FS_FS)		+= qnx4/
 obj-$(CONFIG_QNX6FS_FS)		+= qnx6/
+obj-$(CONFIG_AUTOFS_FS)		+= autofs/
 obj-$(CONFIG_AUTOFS4_FS)	+= autofs4/
 obj-$(CONFIG_ADFS_FS)		+= adfs/
 obj-$(CONFIG_FUSE_FS)		+= fuse/
diff --git a/fs/autofs/Kconfig b/fs/autofs/Kconfig
new file mode 100644
index 0000000..99f5a05
--- /dev/null
+++ b/fs/autofs/Kconfig
@@ -0,0 +1,19 @@
+config AUTOFS_FS
+	tristate "Kernel automounter support (supports v3, v4 and v5)"
+	help
+	  The automounter is a tool to automatically mount remote file systems
+	  on demand. This implementation is partially kernel-based to reduce
+	  overhead in the already-mounted case; this is unlike the BSD
+	  automounter (amd), which is a pure user space daemon.
+
+	  To use the automounter you need the user-space tools from
+	  <ftp://ftp.kernel.org/pub/linux/daemons/autofs/>; you also want
+	  to answer Y to "NFS file system support", below.
+
+	  To compile this support as a module, choose M here: the module will be
+	  called autofs.
+
+	  If you are not a part of a fairly large, distributed network or
+	  don't have a laptop which needs to dynamically reconfigure to the
+	  local network, you probably do not need an automounter, and can say
+	  N here.
diff --git a/fs/autofs/Makefile b/fs/autofs/Makefile
new file mode 100644
index 0000000..43fedde
--- /dev/null
+++ b/fs/autofs/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the linux autofs-filesystem routines.
+#
+
+obj-$(CONFIG_AUTOFS_FS) += autofs.o
+
+autofs-objs := init.o inode.o root.o symlink.o waitq.o expire.o dev-ioctl.o
diff --git a/fs/autofs/autofs_i.h b/fs/autofs/autofs_i.h
new file mode 100644
index 0000000..dcdd1d7
--- /dev/null
+++ b/fs/autofs/autofs_i.h
@@ -0,0 +1,341 @@
+/*
+ *   Copyright 1997-1998 Transmeta Corporation - All Rights Reserved
+ *   Copyright 2005-2006 Ian Kent <raven@themaw.net>
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ *
+ * ----------------------------------------------------------------------- */
+
+/* Internal header file for autofs */
+
+#include <linux/auto_fs.h>
+#include <linux/auto_dev-ioctl.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+
+/* This is the range of ioctl() numbers we claim as ours */
+#define AUTOFS_IOC_FIRST     AUTOFS_IOC_READY
+#define AUTOFS_IOC_COUNT     32
+
+#define AUTOFS_DEV_IOCTL_IOC_FIRST	(AUTOFS_DEV_IOCTL_VERSION)
+#define AUTOFS_DEV_IOCTL_IOC_COUNT	(AUTOFS_IOC_COUNT - 11)
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+#include <linux/string.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <asm/current.h>
+#include <asm/uaccess.h>
+
+/* #define DEBUG */
+
+#define DPRINTK(fmt, ...)				\
+	pr_debug("pid %d: %s: " fmt "\n",		\
+		current->pid, __func__, ##__VA_ARGS__)
+
+#define AUTOFS_WARN(fmt, ...)				\
+	printk(KERN_WARNING "pid %d: %s: " fmt "\n",	\
+		current->pid, __func__, ##__VA_ARGS__)
+
+#define AUTOFS_ERROR(fmt, ...)				\
+	printk(KERN_ERR "pid %d: %s: " fmt "\n",	\
+		current->pid, __func__, ##__VA_ARGS__)
+
+/*
+ * Unified info structure.  This is pointed to by both the dentry and
+ * inode structures.  Each file in the filesystem has an instance of this
+ * structure.  It holds a reference to the dentry, so dentries are never
+ * flushed while the file exists.  All name lookups are dealt with at the
+ * dentry level, although the filesystem can interfere in the validation
+ * process.  Readdir is implemented by traversing the dentry lists.
+ */
+struct autofs_info {
+	struct dentry	*dentry;
+	struct inode	*inode;
+
+	int		flags;
+
+	struct completion expire_complete;
+
+	struct list_head active;
+	int active_count;
+
+	struct list_head expiring;
+
+	struct autofs_sb_info *sbi;
+	unsigned long last_used;
+	atomic_t count;
+
+	kuid_t uid;
+	kgid_t gid;
+};
+
+#define AUTOFS_INF_EXPIRING	(1<<0) /* dentry in the process of expiring */
+#define AUTOFS_INF_PENDING	(1<<2) /* dentry pending mount */
+
+struct autofs_wait_queue {
+	wait_queue_head_t queue;
+	struct autofs_wait_queue *next;
+	autofs_wqt_t wait_queue_token;
+	/* We use the following to see what we are waiting for */
+	struct qstr name;
+	u32 dev;
+	u64 ino;
+	kuid_t uid;
+	kgid_t gid;
+	pid_t pid;
+	pid_t tgid;
+	/* This is for status reporting upon return */
+	int status;
+	unsigned int wait_ctr;
+};
+
+#define AUTOFS_SBI_MAGIC 0x6d4a556d
+
+struct autofs_sb_info {
+	u32 magic;
+	int pipefd;
+	struct file *pipe;
+	struct pid *oz_pgrp;
+	int catatonic;
+	int version;
+	int sub_version;
+	int min_proto;
+	int max_proto;
+	unsigned long exp_timeout;
+	unsigned int type;
+	int reghost_enabled;
+	int needs_reghost;
+	struct super_block *sb;
+	struct mutex wq_mutex;
+	struct mutex pipe_mutex;
+	spinlock_t fs_lock;
+	struct autofs_wait_queue *queues; /* Wait queue pointer */
+	spinlock_t lookup_lock;
+	struct list_head active_list;
+	struct list_head expiring_list;
+};
+
+static inline struct autofs_sb_info *autofs_sbi(struct super_block *sb)
+{
+	return (struct autofs_sb_info *)(sb->s_fs_info);
+}
+
+static inline struct autofs_info *autofs_dentry_ino(struct dentry *dentry)
+{
+	return (struct autofs_info *)(dentry->d_fsdata);
+}
+
+/* autofs_oz_mode(): do we see the man behind the curtain?  (The
+   processes which do manipulations for us in user space sees the raw
+   filesystem without "magic".) */
+
+static inline int autofs_oz_mode(struct autofs_sb_info *sbi)
+{
+	return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
+}
+
+/* Does a dentry have some pending activity? */
+static inline int autofs_ispending(struct dentry *dentry)
+{
+	struct autofs_info *inf = autofs_dentry_ino(dentry);
+
+	if (inf->flags & AUTOFS_INF_PENDING)
+		return 1;
+
+	if (inf->flags & AUTOFS_INF_EXPIRING)
+		return 1;
+
+	return 0;
+}
+
+struct inode *autofs_get_inode(struct super_block *, umode_t);
+void autofs_free_ino(struct autofs_info *);
+
+/* Expiration */
+int is_autofs_dentry(struct dentry *);
+int autofs_expire_wait(struct dentry *dentry);
+int autofs_expire_run(struct super_block *, struct vfsmount *,
+		      struct autofs_sb_info *,
+		      struct autofs_packet_expire __user *);
+int autofs_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+			   struct autofs_sb_info *sbi, int when);
+int autofs_expire_multi(struct super_block *, struct vfsmount *,
+			struct autofs_sb_info *, int __user *);
+struct dentry *autofs_expire_direct(struct super_block *sb,
+				    struct vfsmount *mnt,
+				    struct autofs_sb_info *sbi, int how);
+struct dentry *autofs_expire_indirect(struct super_block *sb,
+				      struct vfsmount *mnt,
+				      struct autofs_sb_info *sbi, int how);
+
+/* Device node initialization */
+
+int autofs_dev_ioctl_init(void);
+void autofs_dev_ioctl_exit(void);
+
+/* Operations structures */
+
+extern const struct inode_operations autofs_symlink_inode_operations;
+extern const struct inode_operations autofs_dir_inode_operations;
+extern const struct file_operations autofs_dir_operations;
+extern const struct file_operations autofs_root_operations;
+extern const struct dentry_operations autofs_dentry_operations;
+
+/* VFS automount flags management functions */
+
+static inline void __managed_dentry_set_automount(struct dentry *dentry)
+{
+	dentry->d_flags |= DCACHE_NEED_AUTOMOUNT;
+}
+
+static inline void managed_dentry_set_automount(struct dentry *dentry)
+{
+	spin_lock(&dentry->d_lock);
+	__managed_dentry_set_automount(dentry);
+	spin_unlock(&dentry->d_lock);
+}
+
+static inline void __managed_dentry_clear_automount(struct dentry *dentry)
+{
+	dentry->d_flags &= ~DCACHE_NEED_AUTOMOUNT;
+}
+
+static inline void managed_dentry_clear_automount(struct dentry *dentry)
+{
+	spin_lock(&dentry->d_lock);
+	__managed_dentry_clear_automount(dentry);
+	spin_unlock(&dentry->d_lock);
+}
+
+static inline void __managed_dentry_set_transit(struct dentry *dentry)
+{
+	dentry->d_flags |= DCACHE_MANAGE_TRANSIT;
+}
+
+static inline void managed_dentry_set_transit(struct dentry *dentry)
+{
+	spin_lock(&dentry->d_lock);
+	__managed_dentry_set_transit(dentry);
+	spin_unlock(&dentry->d_lock);
+}
+
+static inline void __managed_dentry_clear_transit(struct dentry *dentry)
+{
+	dentry->d_flags &= ~DCACHE_MANAGE_TRANSIT;
+}
+
+static inline void managed_dentry_clear_transit(struct dentry *dentry)
+{
+	spin_lock(&dentry->d_lock);
+	__managed_dentry_clear_transit(dentry);
+	spin_unlock(&dentry->d_lock);
+}
+
+static inline void __managed_dentry_set_managed(struct dentry *dentry)
+{
+	dentry->d_flags |= (DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT);
+}
+
+static inline void managed_dentry_set_managed(struct dentry *dentry)
+{
+	spin_lock(&dentry->d_lock);
+	__managed_dentry_set_managed(dentry);
+	spin_unlock(&dentry->d_lock);
+}
+
+static inline void __managed_dentry_clear_managed(struct dentry *dentry)
+{
+	dentry->d_flags &= ~(DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT);
+}
+
+static inline void managed_dentry_clear_managed(struct dentry *dentry)
+{
+	spin_lock(&dentry->d_lock);
+	__managed_dentry_clear_managed(dentry);
+	spin_unlock(&dentry->d_lock);
+}
+
+/* Initializing function */
+
+int autofs_fill_super(struct super_block *, void *, int);
+struct autofs_info *autofs_new_ino(struct autofs_sb_info *);
+void autofs_clean_ino(struct autofs_info *);
+
+static inline int autofs_prepare_pipe(struct file *pipe)
+{
+	if (!pipe->f_op || !pipe->f_op->write)
+		return -EINVAL;
+	if (!S_ISFIFO(file_inode(pipe)->i_mode))
+		return -EINVAL;
+	/* We want a packet pipe */
+	pipe->f_flags |= O_DIRECT;
+	return 0;
+}
+
+/* Queue management functions */
+
+int autofs_wait(struct autofs_sb_info *,struct dentry *, enum autofs_notify);
+int autofs_wait_release(struct autofs_sb_info *,autofs_wqt_t,int);
+void autofs_catatonic_mode(struct autofs_sb_info *);
+
+static inline u32 autofs_get_dev(struct autofs_sb_info *sbi)
+{
+	return new_encode_dev(sbi->sb->s_dev);
+}
+
+static inline u64 autofs_get_ino(struct autofs_sb_info *sbi)
+{
+	return sbi->sb->s_root->d_inode->i_ino;
+}
+
+static inline int simple_positive(struct dentry *dentry)
+{
+	return dentry->d_inode && !d_unhashed(dentry);
+}
+
+static inline void __autofs_add_expiring(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
+	if (ino) {
+		if (list_empty(&ino->expiring))
+			list_add(&ino->expiring, &sbi->expiring_list);
+	}
+	return;
+}
+
+static inline void autofs_add_expiring(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		if (list_empty(&ino->expiring))
+			list_add(&ino->expiring, &sbi->expiring_list);
+		spin_unlock(&sbi->lookup_lock);
+	}
+	return;
+}
+
+static inline void autofs_del_expiring(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		if (!list_empty(&ino->expiring))
+			list_del_init(&ino->expiring);
+		spin_unlock(&sbi->lookup_lock);
+	}
+	return;
+}
+
+extern void autofs_kill_sb(struct super_block *);
diff --git a/fs/autofs/dev-ioctl.c b/fs/autofs/dev-ioctl.c
new file mode 100644
index 0000000..de475cc
--- /dev/null
+++ b/fs/autofs/dev-ioctl.c
@@ -0,0 +1,759 @@
+/*
+ * Copyright 2008 Red Hat, Inc. All rights reserved.
+ * Copyright 2008 Ian Kent <raven@themaw.net>
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ */
+
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/miscdevice.h>
+#include <linux/init.h>
+#include <linux/wait.h>
+#include <linux/namei.h>
+#include <linux/fcntl.h>
+#include <linux/file.h>
+#include <linux/fdtable.h>
+#include <linux/sched.h>
+#include <linux/compat.h>
+#include <linux/syscalls.h>
+#include <linux/magic.h>
+#include <linux/dcache.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+
+#include "autofs_i.h"
+
+/*
+ * This module implements an interface for routing autofs ioctl control
+ * commands via a miscellaneous device file.
+ *
+ * The alternate interface is needed because we need to be able open
+ * an ioctl file descriptor on an autofs mount that may be covered by
+ * another mount. This situation arises when starting automount(8)
+ * or other user space daemon which uses direct mounts or offset
+ * mounts (used for autofs lazy mount/umount of nested mount trees),
+ * which have been left busy at at service shutdown.
+ */
+
+#define AUTOFS_DEV_IOCTL_SIZE	sizeof(struct autofs_dev_ioctl)
+
+typedef int (*ioctl_fn)(struct file *, struct autofs_sb_info *,
+			struct autofs_dev_ioctl *);
+
+static int check_name(const char *name)
+{
+	if (!strchr(name, '/'))
+		return -EINVAL;
+	return 0;
+}
+
+/*
+ * Check a string doesn't overrun the chunk of
+ * memory we copied from user land.
+ */
+static int invalid_str(char *str, size_t size)
+{
+	if (memchr(str, 0, size))
+		return 0;
+	return -EINVAL;
+}
+
+/*
+ * Check that the user compiled against correct version of autofs
+ * misc device code.
+ *
+ * As well as checking the version compatibility this always copies
+ * the kernel interface version out.
+ */
+static int check_dev_ioctl_version(int cmd, struct autofs_dev_ioctl *param)
+{
+	int err = 0;
+
+	if ((AUTOFS_DEV_IOCTL_VERSION_MAJOR != param->ver_major) ||
+	    (AUTOFS_DEV_IOCTL_VERSION_MINOR < param->ver_minor)) {
+		AUTOFS_WARN("ioctl control interface version mismatch: "
+		     "kernel(%u.%u), user(%u.%u), cmd(%d)",
+		     AUTOFS_DEV_IOCTL_VERSION_MAJOR,
+		     AUTOFS_DEV_IOCTL_VERSION_MINOR,
+		     param->ver_major, param->ver_minor, cmd);
+		err = -EINVAL;
+	}
+
+	/* Fill in the kernel version. */
+	param->ver_major = AUTOFS_DEV_IOCTL_VERSION_MAJOR;
+	param->ver_minor = AUTOFS_DEV_IOCTL_VERSION_MINOR;
+
+	return err;
+}
+
+/*
+ * Copy parameter control struct, including a possible path allocated
+ * at the end of the struct.
+ */
+static struct autofs_dev_ioctl *copy_dev_ioctl(struct autofs_dev_ioctl __user *in)
+{
+	struct autofs_dev_ioctl tmp;
+
+	if (copy_from_user(&tmp, in, sizeof(tmp)))
+		return ERR_PTR(-EFAULT);
+
+	if (tmp.size < sizeof(tmp))
+		return ERR_PTR(-EINVAL);
+
+	return memdup_user(in, tmp.size);
+}
+
+static inline void free_dev_ioctl(struct autofs_dev_ioctl *param)
+{
+	kfree(param);
+	return;
+}
+
+/*
+ * Check sanity of parameter control fields and if a path is present
+ * check that it is terminated and contains at least one "/".
+ */
+static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
+{
+	int err;
+
+	err = check_dev_ioctl_version(cmd, param);
+	if (err) {
+		AUTOFS_WARN("invalid device control module version "
+		     "supplied for cmd(0x%08x)", cmd);
+		goto out;
+	}
+
+	if (param->size > sizeof(*param)) {
+		err = invalid_str(param->path, param->size - sizeof(*param));
+		if (err) {
+			AUTOFS_WARN(
+			  "path string terminator missing for cmd(0x%08x)",
+			  cmd);
+			goto out;
+		}
+
+		err = check_name(param->path);
+		if (err) {
+			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
+				    cmd);
+			goto out;
+		}
+	}
+
+	err = 0;
+out:
+	return err;
+}
+
+/*
+ * Get the autofs super block info struct from the file opened on
+ * the autofs mount point.
+ */
+static struct autofs_sb_info *autofs_dev_ioctl_sbi(struct file *f)
+{
+	struct autofs_sb_info *sbi = NULL;
+	struct inode *inode;
+
+	if (f) {
+		inode = file_inode(f);
+		sbi = autofs_sbi(inode->i_sb);
+	}
+	return sbi;
+}
+
+/* Return autofs module protocol version */
+static int autofs_dev_ioctl_protover(struct file *fp,
+				     struct autofs_sb_info *sbi,
+				     struct autofs_dev_ioctl *param)
+{
+	param->protover.version = sbi->version;
+	return 0;
+}
+
+/* Return autofs module protocol sub version */
+static int autofs_dev_ioctl_protosubver(struct file *fp,
+					struct autofs_sb_info *sbi,
+					struct autofs_dev_ioctl *param)
+{
+	param->protosubver.sub_version = sbi->sub_version;
+	return 0;
+}
+
+static int find_autofs_mount(const char *pathname,
+			     struct path *res,
+			     int test(struct path *path, void *data),
+			     void *data)
+{
+	struct path path;
+	int err = kern_path(pathname, 0, &path);
+	if (err)
+		return err;
+	err = -ENOENT;
+	while (path.dentry == path.mnt->mnt_root) {
+		if (path.dentry->d_sb->s_magic == AUTOFS_SUPER_MAGIC) {
+			if (test(&path, data)) {
+				path_get(&path);
+				if (!err) /* already found some */
+					path_put(res);
+				*res = path;
+				err = 0;
+			}
+		}
+		if (!follow_up(&path))
+			break;
+	}
+	path_put(&path);
+	return err;
+}
+
+static int test_by_dev(struct path *path, void *p)
+{
+	return path->dentry->d_sb->s_dev == *(dev_t *)p;
+}
+
+static int test_by_type(struct path *path, void *p)
+{
+	struct autofs_info *ino = autofs_dentry_ino(path->dentry);
+	return ino && ino->sbi->type & *(unsigned *)p;
+}
+
+/*
+ * Open a file descriptor on the autofs mount point corresponding
+ * to the given path and device number (aka. new_encode_dev(sb->s_dev)).
+ */
+static int autofs_dev_ioctl_open_mountpoint(const char *name, dev_t devid)
+{
+	int err, fd;
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (likely(fd >= 0)) {
+		struct file *filp;
+		struct path path;
+
+		err = find_autofs_mount(name, &path, test_by_dev, &devid);
+		if (err)
+			goto out;
+
+		/*
+		 * Find autofs super block that has the device number
+		 * corresponding to the autofs fs we want to open.
+		 */
+
+		filp = dentry_open(&path, O_RDONLY, current_cred());
+		path_put(&path);
+		if (IS_ERR(filp)) {
+			err = PTR_ERR(filp);
+			goto out;
+		}
+
+		fd_install(fd, filp);
+	}
+
+	return fd;
+
+out:
+	put_unused_fd(fd);
+	return err;
+}
+
+/* Open a file descriptor on an autofs mount point */
+static int autofs_dev_ioctl_openmount(struct file *fp,
+				      struct autofs_sb_info *sbi,
+				      struct autofs_dev_ioctl *param)
+{
+	const char *path;
+	dev_t devid;
+	int err, fd;
+
+	/* param->path has already been checked */
+	if (!param->openmount.devid)
+		return -EINVAL;
+
+	param->ioctlfd = -1;
+
+	path = param->path;
+	devid = new_decode_dev(param->openmount.devid);
+
+	err = 0;
+	fd = autofs_dev_ioctl_open_mountpoint(path, devid);
+	if (unlikely(fd < 0)) {
+		err = fd;
+		goto out;
+	}
+
+	param->ioctlfd = fd;
+out:
+	return err;
+}
+
+/* Close file descriptor allocated above (user can also use close(2)). */
+static int autofs_dev_ioctl_closemount(struct file *fp,
+				       struct autofs_sb_info *sbi,
+				       struct autofs_dev_ioctl *param)
+{
+	return sys_close(param->ioctlfd);
+}
+
+/*
+ * Send "ready" status for an existing wait (either a mount or an expire
+ * request).
+ */
+static int autofs_dev_ioctl_ready(struct file *fp,
+				  struct autofs_sb_info *sbi,
+				  struct autofs_dev_ioctl *param)
+{
+	autofs_wqt_t token;
+
+	token = (autofs_wqt_t) param->ready.token;
+	return autofs_wait_release(sbi, token, 0);
+}
+
+/*
+ * Send "fail" status for an existing wait (either a mount or an expire
+ * request).
+ */
+static int autofs_dev_ioctl_fail(struct file *fp,
+				 struct autofs_sb_info *sbi,
+				 struct autofs_dev_ioctl *param)
+{
+	autofs_wqt_t token;
+	int status;
+
+	token = (autofs_wqt_t) param->fail.token;
+	status = param->fail.status ? param->fail.status : -ENOENT;
+	return autofs_wait_release(sbi, token, status);
+}
+
+/*
+ * Set the pipe fd for kernel communication to the daemon.
+ *
+ * Normally this is set at mount using an option but if we
+ * are reconnecting to a busy mount then we need to use this
+ * to tell the autofs mount about the new kernel pipe fd. In
+ * order to protect mounts against incorrectly setting the
+ * pipefd we also require that the autofs mount be catatonic.
+ *
+ * This also sets the process group id used to identify the
+ * controlling process (eg. the owning automount(8) daemon).
+ */
+static int autofs_dev_ioctl_setpipefd(struct file *fp,
+				      struct autofs_sb_info *sbi,
+				      struct autofs_dev_ioctl *param)
+{
+	int pipefd;
+	int err = 0;
+	struct pid *new_pid = NULL;
+
+	if (param->setpipefd.pipefd == -1)
+		return -EINVAL;
+
+	pipefd = param->setpipefd.pipefd;
+
+	mutex_lock(&sbi->wq_mutex);
+	if (!sbi->catatonic) {
+		mutex_unlock(&sbi->wq_mutex);
+		return -EBUSY;
+	} else {
+		struct file *pipe;
+
+		new_pid = get_task_pid(current, PIDTYPE_PGID);
+
+		if (ns_of_pid(new_pid) != ns_of_pid(sbi->oz_pgrp)) {
+			AUTOFS_WARN("Not allowed to change PID namespace");
+			err = -EINVAL;
+			goto out;
+		}
+
+		pipe = fget(pipefd);
+		if (!pipe) {
+			err = -EBADF;
+			goto out;
+		}
+		if (autofs_prepare_pipe(pipe) < 0) {
+			err = -EPIPE;
+			fput(pipe);
+			goto out;
+		}
+		swap(sbi->oz_pgrp, new_pid);
+		sbi->pipefd = pipefd;
+		sbi->pipe = pipe;
+		sbi->catatonic = 0;
+	}
+out:
+	put_pid(new_pid);
+	mutex_unlock(&sbi->wq_mutex);
+	return err;
+}
+
+/*
+ * Make the autofs mount point catatonic, no longer responsive to
+ * mount requests. Also closes the kernel pipe file descriptor.
+ */
+static int autofs_dev_ioctl_catatonic(struct file *fp,
+				      struct autofs_sb_info *sbi,
+				      struct autofs_dev_ioctl *param)
+{
+	autofs_catatonic_mode(sbi);
+	return 0;
+}
+
+/* Set the autofs mount timeout */
+static int autofs_dev_ioctl_timeout(struct file *fp,
+				    struct autofs_sb_info *sbi,
+				    struct autofs_dev_ioctl *param)
+{
+	unsigned long timeout;
+
+	timeout = param->timeout.timeout;
+	param->timeout.timeout = sbi->exp_timeout / HZ;
+	sbi->exp_timeout = timeout * HZ;
+	return 0;
+}
+
+/*
+ * Return the uid and gid of the last request for the mount
+ *
+ * When reconstructing an autofs mount tree with active mounts
+ * we need to re-connect to mounts that may have used the original
+ * process uid and gid (or string variations of them) for mount
+ * lookups within the map entry.
+ */
+static int autofs_dev_ioctl_requester(struct file *fp,
+				      struct autofs_sb_info *sbi,
+				      struct autofs_dev_ioctl *param)
+{
+	struct autofs_info *ino;
+	struct path path;
+	dev_t devid;
+	int err = -ENOENT;
+
+	if (param->size <= sizeof(*param)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	devid = sbi->sb->s_dev;
+
+	param->requester.uid = param->requester.gid = -1;
+
+	err = find_autofs_mount(param->path, &path, test_by_dev, &devid);
+	if (err)
+		goto out;
+
+	ino = autofs_dentry_ino(path.dentry);
+	if (ino) {
+		err = 0;
+		autofs_expire_wait(path.dentry);
+		spin_lock(&sbi->fs_lock);
+		param->requester.uid = from_kuid_munged(current_user_ns(), ino->uid);
+		param->requester.gid = from_kgid_munged(current_user_ns(), ino->gid);
+		spin_unlock(&sbi->fs_lock);
+	}
+	path_put(&path);
+out:
+	return err;
+}
+
+/*
+ * Call repeatedly until it returns -EAGAIN, meaning there's nothing
+ * more that can be done.
+ */
+static int autofs_dev_ioctl_expire(struct file *fp,
+				   struct autofs_sb_info *sbi,
+				   struct autofs_dev_ioctl *param)
+{
+	struct vfsmount *mnt;
+	int how;
+
+	how = param->expire.how;
+	mnt = fp->f_path.mnt;
+
+	return autofs_do_expire_multi(sbi->sb, mnt, sbi, how);
+}
+
+/* Check if autofs mount point is in use */
+static int autofs_dev_ioctl_askumount(struct file *fp,
+				      struct autofs_sb_info *sbi,
+				      struct autofs_dev_ioctl *param)
+{
+	param->askumount.may_umount = 0;
+	if (may_umount(fp->f_path.mnt))
+		param->askumount.may_umount = 1;
+	return 0;
+}
+
+/*
+ * Check if the given path is a mountpoint.
+ *
+ * If we are supplied with the file descriptor of an autofs
+ * mount we're looking for a specific mount. In this case
+ * the path is considered a mountpoint if it is itself a
+ * mountpoint or contains a mount, such as a multi-mount
+ * without a root mount. In this case we return 1 if the
+ * path is a mount point and the super magic of the covering
+ * mount if there is one or 0 if it isn't a mountpoint.
+ *
+ * If we aren't supplied with a file descriptor then we
+ * lookup the nameidata of the path and check if it is the
+ * root of a mount. If a type is given we are looking for
+ * a particular autofs mount and if we don't find a match
+ * we return fail. If the located nameidata path is the
+ * root of a mount we return 1 along with the super magic
+ * of the mount or 0 otherwise.
+ *
+ * In both cases the the device number (as returned by
+ * new_encode_dev()) is also returned.
+ */
+static int autofs_dev_ioctl_ismountpoint(struct file *fp,
+					 struct autofs_sb_info *sbi,
+					 struct autofs_dev_ioctl *param)
+{
+	struct path path;
+	const char *name;
+	unsigned int type;
+	unsigned int devid, magic;
+	int err = -ENOENT;
+
+	if (param->size <= sizeof(*param)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	name = param->path;
+	type = param->ismountpoint.in.type;
+
+	param->ismountpoint.out.devid = devid = 0;
+	param->ismountpoint.out.magic = magic = 0;
+
+	if (!fp || param->ioctlfd == -1) {
+		if (autofs_type_any(type))
+			err = kern_path(name, LOOKUP_FOLLOW, &path);
+		else
+			err = find_autofs_mount(name, &path, test_by_type, &type);
+		if (err)
+			goto out;
+		devid = new_encode_dev(path.dentry->d_sb->s_dev);
+		err = 0;
+		if (path.mnt->mnt_root == path.dentry) {
+			err = 1;
+			magic = path.dentry->d_sb->s_magic;
+		}
+	} else {
+		dev_t dev = sbi->sb->s_dev;
+
+		err = find_autofs_mount(name, &path, test_by_dev, &dev);
+		if (err)
+			goto out;
+
+		devid = new_encode_dev(dev);
+
+		err = have_submounts(path.dentry);
+
+		if (follow_down_one(&path))
+			magic = path.dentry->d_sb->s_magic;
+	}
+
+	param->ismountpoint.out.devid = devid;
+	param->ismountpoint.out.magic = magic;
+	path_put(&path);
+out:
+	return err;
+}
+
+/*
+ * Our range of ioctl numbers isn't 0 based so we need to shift
+ * the array index by _IOC_NR(AUTOFS_CTL_IOC_FIRST) for the table
+ * lookup.
+ */
+#define cmd_idx(cmd)	(cmd - _IOC_NR(AUTOFS_DEV_IOCTL_IOC_FIRST))
+
+static ioctl_fn lookup_dev_ioctl(unsigned int cmd)
+{
+	static struct {
+		int cmd;
+		ioctl_fn fn;
+	} _ioctls[] = {
+		{cmd_idx(AUTOFS_DEV_IOCTL_VERSION_CMD), NULL},
+		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOVER_CMD),
+			 autofs_dev_ioctl_protover},
+		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOSUBVER_CMD),
+			 autofs_dev_ioctl_protosubver},
+		{cmd_idx(AUTOFS_DEV_IOCTL_OPENMOUNT_CMD),
+			 autofs_dev_ioctl_openmount},
+		{cmd_idx(AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD),
+			 autofs_dev_ioctl_closemount},
+		{cmd_idx(AUTOFS_DEV_IOCTL_READY_CMD),
+			 autofs_dev_ioctl_ready},
+		{cmd_idx(AUTOFS_DEV_IOCTL_FAIL_CMD),
+			 autofs_dev_ioctl_fail},
+		{cmd_idx(AUTOFS_DEV_IOCTL_SETPIPEFD_CMD),
+			 autofs_dev_ioctl_setpipefd},
+		{cmd_idx(AUTOFS_DEV_IOCTL_CATATONIC_CMD),
+			 autofs_dev_ioctl_catatonic},
+		{cmd_idx(AUTOFS_DEV_IOCTL_TIMEOUT_CMD),
+			 autofs_dev_ioctl_timeout},
+		{cmd_idx(AUTOFS_DEV_IOCTL_REQUESTER_CMD),
+			 autofs_dev_ioctl_requester},
+		{cmd_idx(AUTOFS_DEV_IOCTL_EXPIRE_CMD),
+			 autofs_dev_ioctl_expire},
+		{cmd_idx(AUTOFS_DEV_IOCTL_ASKUMOUNT_CMD),
+			 autofs_dev_ioctl_askumount},
+		{cmd_idx(AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD),
+			 autofs_dev_ioctl_ismountpoint}
+	};
+	unsigned int idx = cmd_idx(cmd);
+
+	return (idx >= ARRAY_SIZE(_ioctls)) ? NULL : _ioctls[idx].fn;
+}
+
+/* ioctl dispatcher */
+static int _autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __user *user)
+{
+	struct autofs_dev_ioctl *param;
+	struct file *fp;
+	struct autofs_sb_info *sbi;
+	unsigned int cmd_first, cmd;
+	ioctl_fn fn = NULL;
+	int err = 0;
+
+	/* only root can play with this */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	cmd_first = _IOC_NR(AUTOFS_DEV_IOCTL_IOC_FIRST);
+	cmd = _IOC_NR(command);
+
+	if (_IOC_TYPE(command) != _IOC_TYPE(AUTOFS_DEV_IOCTL_IOC_FIRST) ||
+	    cmd - cmd_first >= AUTOFS_DEV_IOCTL_IOC_COUNT) {
+		return -ENOTTY;
+	}
+
+	/* Copy the parameters into kernel space. */
+	param = copy_dev_ioctl(user);
+	if (IS_ERR(param))
+		return PTR_ERR(param);
+
+	err = validate_dev_ioctl(command, param);
+	if (err)
+		goto out;
+
+	/* The validate routine above always sets the version */
+	if (cmd == AUTOFS_DEV_IOCTL_VERSION_CMD)
+		goto done;
+
+	fn = lookup_dev_ioctl(cmd);
+	if (!fn) {
+		AUTOFS_WARN("unknown command 0x%08x", command);
+		return -ENOTTY;
+	}
+
+	fp = NULL;
+	sbi = NULL;
+
+	/*
+	 * For obvious reasons the openmount can't have a file
+	 * descriptor yet. We don't take a reference to the
+	 * file during close to allow for immediate release.
+	 */
+	if (cmd != AUTOFS_DEV_IOCTL_OPENMOUNT_CMD &&
+	    cmd != AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD) {
+		fp = fget(param->ioctlfd);
+		if (!fp) {
+			if (cmd == AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD)
+				goto cont;
+			err = -EBADF;
+			goto out;
+		}
+
+		if (!fp->f_op) {
+			err = -ENOTTY;
+			fput(fp);
+			goto out;
+		}
+
+		sbi = autofs_dev_ioctl_sbi(fp);
+		if (!sbi || sbi->magic != AUTOFS_SBI_MAGIC) {
+			err = -EINVAL;
+			fput(fp);
+			goto out;
+		}
+
+		/*
+		 * Admin needs to be able to set the mount catatonic in
+		 * order to be able to perform the re-open.
+		 */
+		if (!autofs_oz_mode(sbi) &&
+		    cmd != AUTOFS_DEV_IOCTL_CATATONIC_CMD) {
+			err = -EACCES;
+			fput(fp);
+			goto out;
+		}
+	}
+cont:
+	err = fn(fp, sbi, param);
+
+	if (fp)
+		fput(fp);
+done:
+	if (err >= 0 && copy_to_user(user, param, AUTOFS_DEV_IOCTL_SIZE))
+		err = -EFAULT;
+out:
+	free_dev_ioctl(param);
+	return err;
+}
+
+static long autofs_dev_ioctl(struct file *file, uint command, ulong u)
+{
+	int err;
+	err = _autofs_dev_ioctl(command, (struct autofs_dev_ioctl __user *) u);
+	return (long) err;
+}
+
+#ifdef CONFIG_COMPAT
+static long autofs_dev_ioctl_compat(struct file *file, uint command, ulong u)
+{
+	return (long) autofs_dev_ioctl(file, command, (ulong) compat_ptr(u));
+}
+#else
+#define autofs_dev_ioctl_compat NULL
+#endif
+
+static const struct file_operations _dev_ioctl_fops = {
+	.unlocked_ioctl	 = autofs_dev_ioctl,
+	.compat_ioctl = autofs_dev_ioctl_compat,
+	.owner	 = THIS_MODULE,
+	.llseek = noop_llseek,
+};
+
+static struct miscdevice _autofs_dev_ioctl_misc = {
+	.minor		= AUTOFS_MINOR,
+	.name  		= AUTOFS_DEVICE_NAME,
+	.fops  		= &_dev_ioctl_fops
+};
+
+MODULE_ALIAS_MISCDEV(AUTOFS_MINOR);
+MODULE_ALIAS("devname:autofs");
+
+/* Register/deregister misc character device */
+int autofs_dev_ioctl_init(void)
+{
+	int r;
+
+	r = misc_register(&_autofs_dev_ioctl_misc);
+	if (r) {
+		AUTOFS_ERROR("misc_register failed for control device");
+		return r;
+	}
+
+	return 0;
+}
+
+void autofs_dev_ioctl_exit(void)
+{
+	misc_deregister(&_autofs_dev_ioctl_misc);
+	return;
+}
diff --git a/fs/autofs/expire.c b/fs/autofs/expire.c
new file mode 100644
index 0000000..4b78c86
--- /dev/null
+++ b/fs/autofs/expire.c
@@ -0,0 +1,561 @@
+/*
+ *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+ *  Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
+ *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ *
+ * ------------------------------------------------------------------------- */
+
+#include "autofs_i.h"
+
+static unsigned long now;
+
+/* Check if a dentry can be expired */
+static inline int autofs_can_expire(struct dentry *dentry,
+				    unsigned long timeout, int do_now)
+{
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
+
+	/* dentry in the process of being deleted */
+	if (ino == NULL)
+		return 0;
+
+	if (!do_now) {
+		/* Too young to die */
+		if (!timeout || time_after(ino->last_used + timeout, now))
+			return 0;
+
+		/* update last_used here :-
+		   - obviously makes sense if it is in use now
+		   - less obviously, prevents rapid-fire expire
+		     attempts if expire fails the first time */
+		ino->last_used = now;
+	}
+	return 1;
+}
+
+/* Check a mount point for busyness */
+static int autofs_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
+{
+	struct dentry *top = dentry;
+	struct path path = {.mnt = mnt, .dentry = dentry};
+	int status = 1;
+
+	DPRINTK("dentry %p %.*s",
+		dentry, (int)dentry->d_name.len, dentry->d_name.name);
+
+	path_get(&path);
+
+	if (!follow_down_one(&path))
+		goto done;
+
+	if (is_autofs_dentry(path.dentry)) {
+		struct autofs_sb_info *sbi = autofs_sbi(path.dentry->d_sb);
+
+		/* This is an autofs submount, we can't expire it */
+		if (autofs_type_indirect(sbi->type))
+			goto done;
+	}
+
+	/* Update the expiry counter if fs is busy */
+	if (!may_umount_tree(path.mnt)) {
+		struct autofs_info *ino = autofs_dentry_ino(top);
+		ino->last_used = jiffies;
+		goto done;
+	}
+
+	status = 0;
+done:
+	DPRINTK("returning = %d", status);
+	path_put(&path);
+	return status;
+}
+
+/*
+ * Calculate and dget next entry in the subdirs list under root.
+ */
+static struct dentry *get_next_positive_subdir(struct dentry *prev,
+					       struct dentry *root)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(root->d_sb);
+	struct list_head *next;
+	struct dentry *q;
+
+	spin_lock(&sbi->lookup_lock);
+	spin_lock(&root->d_lock);
+
+	if (prev)
+		next = prev->d_u.d_child.next;
+	else {
+		prev = dget_dlock(root);
+		next = prev->d_subdirs.next;
+	}
+
+cont:
+	if (next == &root->d_subdirs) {
+		spin_unlock(&root->d_lock);
+		spin_unlock(&sbi->lookup_lock);
+		dput(prev);
+		return NULL;
+	}
+
+	q = list_entry(next, struct dentry, d_u.d_child);
+
+	spin_lock_nested(&q->d_lock, DENTRY_D_LOCK_NESTED);
+	/* Already gone or negative dentry (under construction) - try next */
+	if (q->d_count == 0 || !simple_positive(q)) {
+		spin_unlock(&q->d_lock);
+		next = q->d_u.d_child.next;
+		goto cont;
+	}
+	dget_dlock(q);
+	spin_unlock(&q->d_lock);
+	spin_unlock(&root->d_lock);
+	spin_unlock(&sbi->lookup_lock);
+
+	dput(prev);
+
+	return q;
+}
+
+/*
+ * Calculate and dget next entry in top down tree traversal.
+ */
+static struct dentry *get_next_positive_dentry(struct dentry *prev,
+					       struct dentry *root)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(root->d_sb);
+	struct list_head *next;
+	struct dentry *p, *ret;
+
+	if (prev == NULL)
+		return dget(root);
+
+	spin_lock(&sbi->lookup_lock);
+relock:
+	p = prev;
+	spin_lock(&p->d_lock);
+again:
+	next = p->d_subdirs.next;
+	if (next == &p->d_subdirs) {
+		while (1) {
+			struct dentry *parent;
+
+			if (p == root) {
+				spin_unlock(&p->d_lock);
+				spin_unlock(&sbi->lookup_lock);
+				dput(prev);
+				return NULL;
+			}
+
+			parent = p->d_parent;
+			if (!spin_trylock(&parent->d_lock)) {
+				spin_unlock(&p->d_lock);
+				cpu_relax();
+				goto relock;
+			}
+			spin_unlock(&p->d_lock);
+			next = p->d_u.d_child.next;
+			p = parent;
+			if (next != &parent->d_subdirs)
+				break;
+		}
+	}
+	ret = list_entry(next, struct dentry, d_u.d_child);
+
+	spin_lock_nested(&ret->d_lock, DENTRY_D_LOCK_NESTED);
+	/* Negative dentry - try next */
+	if (!simple_positive(ret)) {
+		spin_unlock(&p->d_lock);
+		lock_set_subclass(&ret->d_lock.dep_map, 0, _RET_IP_);
+		p = ret;
+		goto again;
+	}
+	dget_dlock(ret);
+	spin_unlock(&ret->d_lock);
+	spin_unlock(&p->d_lock);
+	spin_unlock(&sbi->lookup_lock);
+
+	dput(prev);
+
+	return ret;
+}
+
+/*
+ * Check a direct mount point for busyness.
+ * Direct mounts have similar expiry semantics to tree mounts.
+ * The tree is not busy iff no mountpoints are busy and there are no
+ * autofs submounts.
+ */
+static int autofs_direct_busy(struct vfsmount *mnt,
+			      struct dentry *top,
+			      unsigned long timeout,
+			      int do_now)
+{
+	DPRINTK("top %p %.*s",
+		top, (int) top->d_name.len, top->d_name.name);
+
+	/* If it's busy update the expiry counters */
+	if (!may_umount_tree(mnt)) {
+		struct autofs_info *ino = autofs_dentry_ino(top);
+		if (ino)
+			ino->last_used = jiffies;
+		return 1;
+	}
+
+	/* Timeout of a direct mount is determined by its top dentry */
+	if (!autofs_can_expire(top, timeout, do_now))
+		return 1;
+
+	return 0;
+}
+
+/*
+ * Check a directory tree of mount points for busyness
+ * The tree is not busy iff no mountpoints are busy
+ */
+static int autofs_tree_busy(struct vfsmount *mnt,
+			    struct dentry *top,
+			    unsigned long timeout,
+			    int do_now)
+{
+	struct autofs_info *top_ino = autofs_dentry_ino(top);
+	struct dentry *p;
+
+	DPRINTK("top %p %.*s",
+		top, (int)top->d_name.len, top->d_name.name);
+
+	/* Negative dentry - give up */
+	if (!simple_positive(top))
+		return 1;
+
+	p = NULL;
+	while ((p = get_next_positive_dentry(p, top))) {
+		DPRINTK("dentry %p %.*s",
+			p, (int) p->d_name.len, p->d_name.name);
+
+		/*
+		 * Is someone visiting anywhere in the subtree ?
+		 * If there's no mount we need to check the usage
+		 * count for the autofs dentry.
+		 * If the fs is busy update the expiry counter.
+		 */
+		if (d_mountpoint(p)) {
+			if (autofs_mount_busy(mnt, p)) {
+				top_ino->last_used = jiffies;
+				dput(p);
+				return 1;
+			}
+		} else {
+			struct autofs_info *ino = autofs_dentry_ino(p);
+			unsigned int ino_count = atomic_read(&ino->count);
+
+			/*
+			 * Clean stale dentries below that have not been
+			 * invalidated after a mount fail during lookup
+			 */
+			d_invalidate(p);
+
+			/* allow for dget above and top is already dgot */
+			if (p == top)
+				ino_count += 2;
+			else
+				ino_count++;
+
+			if (p->d_count > ino_count) {
+				top_ino->last_used = jiffies;
+				dput(p);
+				return 1;
+			}
+		}
+	}
+
+	/* Timeout of a tree mount is ultimately determined by its top dentry */
+	if (!autofs_can_expire(top, timeout, do_now))
+		return 1;
+
+	return 0;
+}
+
+static struct dentry *autofs_check_leaves(struct vfsmount *mnt,
+					  struct dentry *parent,
+					  unsigned long timeout,
+					  int do_now)
+{
+	struct dentry *p;
+
+	DPRINTK("parent %p %.*s",
+		parent, (int)parent->d_name.len, parent->d_name.name);
+
+	p = NULL;
+	while ((p = get_next_positive_dentry(p, parent))) {
+		DPRINTK("dentry %p %.*s",
+			p, (int) p->d_name.len, p->d_name.name);
+
+		if (d_mountpoint(p)) {
+			/* Can we umount this guy */
+			if (autofs_mount_busy(mnt, p))
+				continue;
+
+			/* Can we expire this guy */
+			if (autofs_can_expire(p, timeout, do_now))
+				return p;
+		}
+	}
+	return NULL;
+}
+
+/* Check if we can expire a direct mount (possibly a tree) */
+struct dentry *autofs_expire_direct(struct super_block *sb,
+				    struct vfsmount *mnt,
+				    struct autofs_sb_info *sbi,
+				    int how)
+{
+	unsigned long timeout;
+	struct dentry *root = dget(sb->s_root);
+	int do_now = how & AUTOFS_EXP_IMMEDIATE;
+	struct autofs_info *ino;
+
+	if (!root)
+		return NULL;
+
+	now = jiffies;
+	timeout = sbi->exp_timeout;
+
+	spin_lock(&sbi->fs_lock);
+	ino = autofs_dentry_ino(root);
+	/* No point expiring a pending mount */
+	if (ino->flags & AUTOFS_INF_PENDING)
+		goto out;
+	if (!autofs_direct_busy(mnt, root, timeout, do_now)) {
+		struct autofs_info *ino = autofs_dentry_ino(root);
+		ino->flags |= AUTOFS_INF_EXPIRING;
+		init_completion(&ino->expire_complete);
+		spin_unlock(&sbi->fs_lock);
+		return root;
+	}
+out:
+	spin_unlock(&sbi->fs_lock);
+	dput(root);
+
+	return NULL;
+}
+
+/*
+ * Find an eligible tree to time-out
+ * A tree is eligible if :-
+ *  - it is unused by any user process
+ *  - it has been unused for exp_timeout time
+ */
+struct dentry *autofs_expire_indirect(struct super_block *sb,
+				      struct vfsmount *mnt,
+				      struct autofs_sb_info *sbi,
+				      int how)
+{
+	unsigned long timeout;
+	struct dentry *root = sb->s_root;
+	struct dentry *dentry;
+	struct dentry *expired = NULL;
+	int do_now = how & AUTOFS_EXP_IMMEDIATE;
+	int exp_leaves = how & AUTOFS_EXP_LEAVES;
+	struct autofs_info *ino;
+	unsigned int ino_count;
+
+	if (!root)
+		return NULL;
+
+	now = jiffies;
+	timeout = sbi->exp_timeout;
+
+	dentry = NULL;
+	while ((dentry = get_next_positive_subdir(dentry, root))) {
+		spin_lock(&sbi->fs_lock);
+		ino = autofs_dentry_ino(dentry);
+		/* No point expiring a pending mount */
+		if (ino->flags & AUTOFS_INF_PENDING)
+			goto next;
+
+		/*
+		 * Case 1: (i) indirect mount or top level pseudo direct mount
+		 *	   (autofs-4.1).
+		 *	   (ii) indirect mount with offset mount, check the "/"
+		 *	   offset (autofs-5.0+).
+		 */
+		if (d_mountpoint(dentry)) {
+			DPRINTK("checking mountpoint %p %.*s", dentry,
+				(int)dentry->d_name.len, dentry->d_name.name);
+
+			/* Can we umount this guy */
+			if (autofs_mount_busy(mnt, dentry))
+				goto next;
+
+			/* Can we expire this guy */
+			if (autofs_can_expire(dentry, timeout, do_now)) {
+				expired = dentry;
+				goto found;
+			}
+			goto next;
+		}
+
+		if (simple_empty(dentry))
+			goto next;
+
+		/* Case 2: tree mount, expire iff entire tree is not busy */
+		if (!exp_leaves) {
+			/* Path walk currently on this dentry? */
+			ino_count = atomic_read(&ino->count) + 1;
+			if (dentry->d_count > ino_count)
+				goto next;
+
+			if (!autofs_tree_busy(mnt, dentry, timeout, do_now)) {
+				expired = dentry;
+				goto found;
+			}
+		/*
+		 * Case 3: pseudo direct mount, expire individual leaves
+		 *	   (autofs-4.1).
+		 */
+		} else {
+			/* Path walk currently on this dentry? */
+			ino_count = atomic_read(&ino->count) + 1;
+			if (dentry->d_count > ino_count)
+				goto next;
+
+			expired = autofs_check_leaves(mnt, dentry, timeout, do_now);
+			if (expired) {
+				dput(dentry);
+				goto found;
+			}
+		}
+next:
+		spin_unlock(&sbi->fs_lock);
+	}
+	return NULL;
+
+found:
+	DPRINTK("returning %p %.*s",
+		expired, (int)expired->d_name.len, expired->d_name.name);
+	ino = autofs_dentry_ino(expired);
+	ino->flags |= AUTOFS_INF_EXPIRING;
+	init_completion(&ino->expire_complete);
+	spin_unlock(&sbi->fs_lock);
+	spin_lock(&sbi->lookup_lock);
+	spin_lock(&expired->d_parent->d_lock);
+	spin_lock_nested(&expired->d_lock, DENTRY_D_LOCK_NESTED);
+	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
+	spin_unlock(&expired->d_lock);
+	spin_unlock(&expired->d_parent->d_lock);
+	spin_unlock(&sbi->lookup_lock);
+	return expired;
+}
+
+int autofs_expire_wait(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
+	int status;
+
+	/* Block on any pending expire */
+	spin_lock(&sbi->fs_lock);
+	if (ino->flags & AUTOFS_INF_EXPIRING) {
+		spin_unlock(&sbi->fs_lock);
+
+		DPRINTK("waiting for expire %p name=%.*s",
+			 dentry, dentry->d_name.len, dentry->d_name.name);
+
+		status = autofs_wait(sbi, dentry, NFY_NONE);
+		wait_for_completion(&ino->expire_complete);
+
+		DPRINTK("expire done status=%d", status);
+
+		if (d_unhashed(dentry))
+			return -EAGAIN;
+
+		return status;
+	}
+	spin_unlock(&sbi->fs_lock);
+
+	return 0;
+}
+
+/* Perform an expiry operation */
+int autofs_expire_run(struct super_block *sb,
+		      struct vfsmount *mnt,
+		      struct autofs_sb_info *sbi,
+		      struct autofs_packet_expire __user *pkt_p)
+{
+	struct autofs_packet_expire pkt;
+	struct autofs_info *ino;
+	struct dentry *dentry;
+	int ret = 0;
+
+	memset(&pkt,0,sizeof pkt);
+
+	pkt.hdr.proto_version = sbi->version;
+	pkt.hdr.type = autofs_ptype_expire;
+
+	if ((dentry = autofs_expire_indirect(sb, mnt, sbi, 0)) == NULL)
+		return -EAGAIN;
+
+	pkt.len = dentry->d_name.len;
+	memcpy(pkt.name, dentry->d_name.name, pkt.len);
+	pkt.name[pkt.len] = '\0';
+	dput(dentry);
+
+	if (copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)))
+		ret = -EFAULT;
+
+	spin_lock(&sbi->fs_lock);
+	ino = autofs_dentry_ino(dentry);
+	ino->flags &= ~AUTOFS_INF_EXPIRING;
+	complete_all(&ino->expire_complete);
+	spin_unlock(&sbi->fs_lock);
+
+	return ret;
+}
+
+int autofs_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+			   struct autofs_sb_info *sbi, int when)
+{
+	struct dentry *dentry;
+	int ret = -EAGAIN;
+
+	if (autofs_type_trigger(sbi->type))
+		dentry = autofs_expire_direct(sb, mnt, sbi, when);
+	else
+		dentry = autofs_expire_indirect(sb, mnt, sbi, when);
+
+	if (dentry) {
+		struct autofs_info *ino = autofs_dentry_ino(dentry);
+
+		/* This is synchronous because it makes the daemon a
+                   little easier */
+		ret = autofs_wait(sbi, dentry, NFY_EXPIRE);
+
+		spin_lock(&sbi->fs_lock);
+		ino->flags &= ~AUTOFS_INF_EXPIRING;
+		complete_all(&ino->expire_complete);
+		spin_unlock(&sbi->fs_lock);
+		dput(dentry);
+	}
+
+	return ret;
+}
+
+/*
+ * Call repeatedly until it returns -EAGAIN, meaning there's nothing
+ * more to be done.
+ */
+int autofs_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+			struct autofs_sb_info *sbi, int __user *arg)
+{
+	int do_now = 0;
+
+	if (arg && get_user(do_now, arg))
+		return -EFAULT;
+
+	return autofs_do_expire_multi(sb, mnt, sbi, do_now);
+}
diff --git a/fs/autofs/init.c b/fs/autofs/init.c
new file mode 100644
index 0000000..51232a9
--- /dev/null
+++ b/fs/autofs/init.c
@@ -0,0 +1,49 @@
+/*
+ *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ *
+ * ------------------------------------------------------------------------- */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include "autofs_i.h"
+
+static struct dentry *autofs_mount(struct file_system_type *fs_type,
+	int flags, const char *dev_name, void *data)
+{
+	return mount_nodev(fs_type, flags, data, autofs_fill_super);
+}
+
+static struct file_system_type autofs_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "autofs",
+	.mount		= autofs_mount,
+	.kill_sb	= autofs_kill_sb,
+};
+MODULE_ALIAS_FS("autofs");
+
+static int __init init_autofs_fs(void)
+{
+	int err;
+
+	autofs_dev_ioctl_init();
+
+	err = register_filesystem(&autofs_fs_type);
+	if (err)
+		autofs_dev_ioctl_exit();
+
+	return err;
+}
+
+static void __exit exit_autofs_fs(void)
+{
+	autofs_dev_ioctl_exit();
+	unregister_filesystem(&autofs_fs_type);
+}
+
+module_init(init_autofs_fs)
+module_exit(exit_autofs_fs)
+MODULE_LICENSE("GPL");
diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
new file mode 100644
index 0000000..5f941ff
--- /dev/null
+++ b/fs/autofs/inode.c
@@ -0,0 +1,368 @@
+/*
+ *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+ *  Copyright 2005-2006 Ian Kent <raven@themaw.net>
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ *
+ * ------------------------------------------------------------------------- */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/file.h>
+#include <linux/seq_file.h>
+#include <linux/pagemap.h>
+#include <linux/parser.h>
+#include <linux/bitops.h>
+#include <linux/magic.h>
+#include "autofs_i.h"
+#include <linux/module.h>
+
+struct autofs_info *autofs_new_ino(struct autofs_sb_info *sbi)
+{
+	struct autofs_info *ino = kzalloc(sizeof(*ino), GFP_KERNEL);
+	if (ino) {
+		INIT_LIST_HEAD(&ino->active);
+		INIT_LIST_HEAD(&ino->expiring);
+		ino->last_used = jiffies;
+		ino->sbi = sbi;
+	}
+	return ino;
+}
+
+void autofs_clean_ino(struct autofs_info *ino)
+{
+	ino->uid = GLOBAL_ROOT_UID;
+	ino->gid = GLOBAL_ROOT_GID;
+	ino->last_used = jiffies;
+}
+
+void autofs_free_ino(struct autofs_info *ino)
+{
+	kfree(ino);
+}
+
+void autofs_kill_sb(struct super_block *sb)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(sb);
+
+	/*
+	 * In the event of a failure in get_sb_nodev the superblock
+	 * info is not present so nothing else has been setup, so
+	 * just call kill_anon_super when we are called from
+	 * deactivate_super.
+	 */
+	if (!sbi)
+		goto out_kill_sb;
+
+	/* Free wait queues, close pipe */
+	autofs_catatonic_mode(sbi);
+
+	put_pid(sbi->oz_pgrp);
+
+	sb->s_fs_info = NULL;
+	kfree(sbi);
+
+out_kill_sb:
+	DPRINTK("shutting down");
+	kill_litter_super(sb);
+}
+
+static int autofs_show_options(struct seq_file *m, struct dentry *root)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(root->d_sb);
+	struct inode *root_inode = root->d_sb->s_root->d_inode;
+
+	if (!sbi)
+		return 0;
+
+	seq_printf(m, ",fd=%d", sbi->pipefd);
+	if (!uid_eq(root_inode->i_uid, GLOBAL_ROOT_UID))
+		seq_printf(m, ",uid=%u",
+			from_kuid_munged(&init_user_ns, root_inode->i_uid));
+	if (!gid_eq(root_inode->i_gid, GLOBAL_ROOT_GID))
+		seq_printf(m, ",gid=%u",
+			from_kgid_munged(&init_user_ns, root_inode->i_gid));
+	seq_printf(m, ",pgrp=%d", pid_vnr(sbi->oz_pgrp));
+	seq_printf(m, ",timeout=%lu", sbi->exp_timeout/HZ);
+	seq_printf(m, ",minproto=%d", sbi->min_proto);
+	seq_printf(m, ",maxproto=%d", sbi->max_proto);
+
+	if (autofs_type_offset(sbi->type))
+		seq_printf(m, ",offset");
+	else if (autofs_type_direct(sbi->type))
+		seq_printf(m, ",direct");
+	else
+		seq_printf(m, ",indirect");
+
+	return 0;
+}
+
+static void autofs_evict_inode(struct inode *inode)
+{
+	clear_inode(inode);
+	kfree(inode->i_private);
+}
+
+static const struct super_operations autofs_sops = {
+	.statfs		= simple_statfs,
+	.show_options	= autofs_show_options,
+	.evict_inode	= autofs_evict_inode,
+};
+
+enum {Opt_err, Opt_fd, Opt_uid, Opt_gid, Opt_pgrp, Opt_minproto, Opt_maxproto,
+	Opt_indirect, Opt_direct, Opt_offset};
+
+static const match_table_t tokens = {
+	{Opt_fd, "fd=%u"},
+	{Opt_uid, "uid=%u"},
+	{Opt_gid, "gid=%u"},
+	{Opt_pgrp, "pgrp=%u"},
+	{Opt_minproto, "minproto=%u"},
+	{Opt_maxproto, "maxproto=%u"},
+	{Opt_indirect, "indirect"},
+	{Opt_direct, "direct"},
+	{Opt_offset, "offset"},
+	{Opt_err, NULL}
+};
+
+static int parse_options(char *options, int *pipefd, kuid_t *uid, kgid_t *gid,
+			 int *pgrp, bool *pgrp_set, unsigned int *type,
+			 int *minproto, int *maxproto)
+{
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+	int option;
+
+	*uid = current_uid();
+	*gid = current_gid();
+
+	*minproto = AUTOFS_MIN_PROTO_VERSION;
+	*maxproto = AUTOFS_MAX_PROTO_VERSION;
+
+	*pipefd = -1;
+
+	if (!options)
+		return 1;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_fd:
+			if (match_int(args, pipefd))
+				return 1;
+			break;
+		case Opt_uid:
+			if (match_int(args, &option))
+				return 1;
+			*uid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(*uid))
+				return 1;
+			break;
+		case Opt_gid:
+			if (match_int(args, &option))
+				return 1;
+			*gid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(*gid))
+				return 1;
+			break;
+		case Opt_pgrp:
+			if (match_int(args, &option))
+				return 1;
+			*pgrp = option;
+			*pgrp_set = true;
+			break;
+		case Opt_minproto:
+			if (match_int(args, &option))
+				return 1;
+			*minproto = option;
+			break;
+		case Opt_maxproto:
+			if (match_int(args, &option))
+				return 1;
+			*maxproto = option;
+			break;
+		case Opt_indirect:
+			set_autofs_type_indirect(type);
+			break;
+		case Opt_direct:
+			set_autofs_type_direct(type);
+			break;
+		case Opt_offset:
+			set_autofs_type_offset(type);
+			break;
+		default:
+			return 1;
+		}
+	}
+	return (*pipefd < 0);
+}
+
+int autofs_fill_super(struct super_block *s, void *data, int silent)
+{
+	struct inode * root_inode;
+	struct dentry * root;
+	struct file * pipe;
+	int pipefd;
+	struct autofs_sb_info *sbi;
+	struct autofs_info *ino;
+	int pgrp;
+	bool pgrp_set = false;
+
+	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
+	if (!sbi)
+		goto fail_unlock;
+	DPRINTK("starting up, sbi = %p",sbi);
+
+	s->s_fs_info = sbi;
+	sbi->magic = AUTOFS_SBI_MAGIC;
+	sbi->pipefd = -1;
+	sbi->pipe = NULL;
+	sbi->catatonic = 1;
+	sbi->exp_timeout = 0;
+	sbi->oz_pgrp = NULL;
+	sbi->sb = s;
+	sbi->version = 0;
+	sbi->sub_version = 0;
+	set_autofs_type_indirect(&sbi->type);
+	sbi->min_proto = 0;
+	sbi->max_proto = 0;
+	mutex_init(&sbi->wq_mutex);
+	mutex_init(&sbi->pipe_mutex);
+	spin_lock_init(&sbi->fs_lock);
+	sbi->queues = NULL;
+	spin_lock_init(&sbi->lookup_lock);
+	INIT_LIST_HEAD(&sbi->active_list);
+	INIT_LIST_HEAD(&sbi->expiring_list);
+	s->s_blocksize = 1024;
+	s->s_blocksize_bits = 10;
+	s->s_magic = AUTOFS_SUPER_MAGIC;
+	s->s_op = &autofs_sops;
+	s->s_d_op = &autofs_dentry_operations;
+	s->s_time_gran = 1;
+
+	/*
+	 * Get the root inode and dentry, but defer checking for errors.
+	 */
+	ino = autofs_new_ino(sbi);
+	if (!ino)
+		goto fail_free;
+	root_inode = autofs_get_inode(s, S_IFDIR | 0755);
+	root = d_make_root(root_inode);
+	if (!root)
+		goto fail_ino;
+	pipe = NULL;
+
+	root->d_fsdata = ino;
+
+	/* Can this call block? */
+	if (parse_options(data, &pipefd, &root_inode->i_uid, &root_inode->i_gid,
+			  &pgrp, &pgrp_set, &sbi->type, &sbi->min_proto,
+			  &sbi->max_proto)) {
+		printk("autofs: called with bogus options\n");
+		goto fail_dput;
+	}
+
+	if (pgrp_set) {
+		sbi->oz_pgrp = find_get_pid(pgrp);
+		if (!sbi->oz_pgrp) {
+			pr_warn("autofs: could not find process group %d\n",
+				pgrp);
+			goto fail_dput;
+		}
+	} else {
+		sbi->oz_pgrp = get_task_pid(current, PIDTYPE_PGID);
+	}
+
+	if (autofs_type_trigger(sbi->type))
+		__managed_dentry_set_managed(root);
+
+	root_inode->i_fop = &autofs_root_operations;
+	root_inode->i_op = &autofs_dir_inode_operations;
+
+	/* Couldn't this be tested earlier? */
+	if (sbi->max_proto < AUTOFS_MIN_PROTO_VERSION ||
+	    sbi->min_proto > AUTOFS_MAX_PROTO_VERSION) {
+		printk("autofs: kernel does not match daemon version "
+		       "daemon (%d, %d) kernel (%d, %d)\n",
+			sbi->min_proto, sbi->max_proto,
+			AUTOFS_MIN_PROTO_VERSION, AUTOFS_MAX_PROTO_VERSION);
+		goto fail_dput;
+	}
+
+	/* Establish highest kernel protocol version */
+	if (sbi->max_proto > AUTOFS_MAX_PROTO_VERSION)
+		sbi->version = AUTOFS_MAX_PROTO_VERSION;
+	else
+		sbi->version = sbi->max_proto;
+	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;
+
+	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, pid_nr(sbi->oz_pgrp));
+	pipe = fget(pipefd);
+
+	if (!pipe) {
+		printk("autofs: could not open pipe file descriptor\n");
+		goto fail_dput;
+	}
+	if (autofs_prepare_pipe(pipe) < 0)
+		goto fail_fput;
+	sbi->pipe = pipe;
+	sbi->pipefd = pipefd;
+	sbi->catatonic = 0;
+
+	/*
+	 * Success! Install the root dentry now to indicate completion.
+	 */
+	s->s_root = root;
+	return 0;
+
+	/*
+	 * Failure ... clean up.
+	 */
+fail_fput:
+	printk("autofs: pipe file descriptor does not contain proper ops\n");
+	fput(pipe);
+	/* fall through */
+fail_dput:
+	dput(root);
+	goto fail_free;
+fail_ino:
+	kfree(ino);
+fail_free:
+	put_pid(sbi->oz_pgrp);
+	kfree(sbi);
+	s->s_fs_info = NULL;
+fail_unlock:
+	return -EINVAL;
+}
+
+struct inode *autofs_get_inode(struct super_block *sb, umode_t mode)
+{
+	struct inode *inode = new_inode(sb);
+
+	if (inode == NULL)
+		return NULL;
+
+	inode->i_mode = mode;
+	if (sb->s_root) {
+		inode->i_uid = sb->s_root->d_inode->i_uid;
+		inode->i_gid = sb->s_root->d_inode->i_gid;
+	}
+	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_ino = get_next_ino();
+
+	if (S_ISDIR(mode)) {
+		set_nlink(inode, 2);
+		inode->i_op = &autofs_dir_inode_operations;
+		inode->i_fop = &autofs_dir_operations;
+	} else if (S_ISLNK(mode)) {
+		inode->i_op = &autofs_symlink_inode_operations;
+	}
+
+	return inode;
+}
diff --git a/fs/autofs/root.c b/fs/autofs/root.c
new file mode 100644
index 0000000..0f1644d
--- /dev/null
+++ b/fs/autofs/root.c
@@ -0,0 +1,898 @@
+/*
+ *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+ *  Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
+ *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ *
+ * ------------------------------------------------------------------------- */
+
+#include <linux/capability.h>
+#include <linux/errno.h>
+#include <linux/stat.h>
+#include <linux/slab.h>
+#include <linux/param.h>
+#include <linux/time.h>
+#include <linux/compat.h>
+#include <linux/mutex.h>
+
+#include "autofs_i.h"
+
+static int autofs_dir_symlink(struct inode *,struct dentry *,const char *);
+static int autofs_dir_unlink(struct inode *,struct dentry *);
+static int autofs_dir_rmdir(struct inode *,struct dentry *);
+static int autofs_dir_mkdir(struct inode *,struct dentry *,umode_t);
+static long autofs_root_ioctl(struct file *,unsigned int,unsigned long);
+#ifdef CONFIG_COMPAT
+static long autofs_root_compat_ioctl(struct file *,unsigned int,unsigned long);
+#endif
+static int autofs_dir_open(struct inode *inode, struct file *file);
+static struct dentry *autofs_lookup(struct inode *,struct dentry *, unsigned int);
+static struct vfsmount *autofs_d_automount(struct path *);
+static int autofs_d_manage(struct dentry *, bool);
+static void autofs_dentry_release(struct dentry *);
+
+const struct file_operations autofs_root_operations = {
+	.open		= dcache_dir_open,
+	.release	= dcache_dir_close,
+	.read		= generic_read_dir,
+	.iterate	= dcache_readdir,
+	.llseek		= dcache_dir_lseek,
+	.unlocked_ioctl	= autofs_root_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= autofs_root_compat_ioctl,
+#endif
+};
+
+const struct file_operations autofs_dir_operations = {
+	.open		= autofs_dir_open,
+	.release	= dcache_dir_close,
+	.read		= generic_read_dir,
+	.iterate	= dcache_readdir,
+	.llseek		= dcache_dir_lseek,
+};
+
+const struct inode_operations autofs_dir_inode_operations = {
+	.lookup		= autofs_lookup,
+	.unlink		= autofs_dir_unlink,
+	.symlink	= autofs_dir_symlink,
+	.mkdir		= autofs_dir_mkdir,
+	.rmdir		= autofs_dir_rmdir,
+};
+
+const struct dentry_operations autofs_dentry_operations = {
+	.d_automount	= autofs_d_automount,
+	.d_manage	= autofs_d_manage,
+	.d_release	= autofs_dentry_release,
+};
+
+static void autofs_add_active(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		if (!ino->active_count) {
+			if (list_empty(&ino->active))
+				list_add(&ino->active, &sbi->active_list);
+		}
+		ino->active_count++;
+		spin_unlock(&sbi->lookup_lock);
+	}
+	return;
+}
+
+static void autofs_del_active(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		ino->active_count--;
+		if (!ino->active_count) {
+			if (!list_empty(&ino->active))
+				list_del_init(&ino->active);
+		}
+		spin_unlock(&sbi->lookup_lock);
+	}
+	return;
+}
+
+static int autofs_dir_open(struct inode *inode, struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+
+	DPRINTK("file=%p dentry=%p %.*s",
+		file, dentry, dentry->d_name.len, dentry->d_name.name);
+
+	if (autofs_oz_mode(sbi))
+		goto out;
+
+	/*
+	 * An empty directory in an autofs file system is always a
+	 * mount point. The daemon must have failed to mount this
+	 * during lookup so it doesn't exist. This can happen, for
+	 * example, if user space returns an incorrect status for a
+	 * mount request. Otherwise we're doing a readdir on the
+	 * autofs file system so just let the libfs routines handle
+	 * it.
+	 */
+	spin_lock(&sbi->lookup_lock);
+	if (!d_mountpoint(dentry) && simple_empty(dentry)) {
+		spin_unlock(&sbi->lookup_lock);
+		return -ENOENT;
+	}
+	spin_unlock(&sbi->lookup_lock);
+
+out:
+	return dcache_dir_open(inode, file);
+}
+
+static void autofs_dentry_release(struct dentry *de)
+{
+	struct autofs_info *ino = autofs_dentry_ino(de);
+	struct autofs_sb_info *sbi = autofs_sbi(de->d_sb);
+
+	DPRINTK("releasing %p", de);
+
+	if (!ino)
+		return;
+
+	if (sbi) {
+		spin_lock(&sbi->lookup_lock);
+		if (!list_empty(&ino->active))
+			list_del(&ino->active);
+		if (!list_empty(&ino->expiring))
+			list_del(&ino->expiring);
+		spin_unlock(&sbi->lookup_lock);
+	}
+
+	autofs_free_ino(ino);
+}
+
+static struct dentry *autofs_lookup_active(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct dentry *parent = dentry->d_parent;
+	struct qstr *name = &dentry->d_name;
+	unsigned int len = name->len;
+	unsigned int hash = name->hash;
+	const unsigned char *str = name->name;
+	struct list_head *p, *head;
+
+	spin_lock(&sbi->lookup_lock);
+	head = &sbi->active_list;
+	list_for_each(p, head) {
+		struct autofs_info *ino;
+		struct dentry *active;
+		struct qstr *qstr;
+
+		ino = list_entry(p, struct autofs_info, active);
+		active = ino->dentry;
+
+		spin_lock(&active->d_lock);
+
+		/* Already gone? */
+		if (active->d_count == 0)
+			goto next;
+
+		qstr = &active->d_name;
+
+		if (active->d_name.hash != hash)
+			goto next;
+		if (active->d_parent != parent)
+			goto next;
+
+		if (qstr->len != len)
+			goto next;
+		if (memcmp(qstr->name, str, len))
+			goto next;
+
+		if (d_unhashed(active)) {
+			dget_dlock(active);
+			spin_unlock(&active->d_lock);
+			spin_unlock(&sbi->lookup_lock);
+			return active;
+		}
+next:
+		spin_unlock(&active->d_lock);
+	}
+	spin_unlock(&sbi->lookup_lock);
+
+	return NULL;
+}
+
+static struct dentry *autofs_lookup_expiring(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct dentry *parent = dentry->d_parent;
+	struct qstr *name = &dentry->d_name;
+	unsigned int len = name->len;
+	unsigned int hash = name->hash;
+	const unsigned char *str = name->name;
+	struct list_head *p, *head;
+
+	spin_lock(&sbi->lookup_lock);
+	head = &sbi->expiring_list;
+	list_for_each(p, head) {
+		struct autofs_info *ino;
+		struct dentry *expiring;
+		struct qstr *qstr;
+
+		ino = list_entry(p, struct autofs_info, expiring);
+		expiring = ino->dentry;
+
+		spin_lock(&expiring->d_lock);
+
+		/* Bad luck, we've already been dentry_iput */
+		if (!expiring->d_inode)
+			goto next;
+
+		qstr = &expiring->d_name;
+
+		if (expiring->d_name.hash != hash)
+			goto next;
+		if (expiring->d_parent != parent)
+			goto next;
+
+		if (qstr->len != len)
+			goto next;
+		if (memcmp(qstr->name, str, len))
+			goto next;
+
+		if (d_unhashed(expiring)) {
+			dget_dlock(expiring);
+			spin_unlock(&expiring->d_lock);
+			spin_unlock(&sbi->lookup_lock);
+			return expiring;
+		}
+next:
+		spin_unlock(&expiring->d_lock);
+	}
+	spin_unlock(&sbi->lookup_lock);
+
+	return NULL;
+}
+
+static int autofs_mount_wait(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
+	int status = 0;
+
+	if (ino->flags & AUTOFS_INF_PENDING) {
+		DPRINTK("waiting for mount name=%.*s",
+			dentry->d_name.len, dentry->d_name.name);
+		status = autofs_wait(sbi, dentry, NFY_MOUNT);
+		DPRINTK("mount wait done status=%d", status);
+	}
+	ino->last_used = jiffies;
+	return status;
+}
+
+static int do_expire_wait(struct dentry *dentry)
+{
+	struct dentry *expiring;
+
+	expiring = autofs_lookup_expiring(dentry);
+	if (!expiring)
+		return autofs_expire_wait(dentry);
+	else {
+		/*
+		 * If we are racing with expire the request might not
+		 * be quite complete, but the directory has been removed
+		 * so it must have been successful, just wait for it.
+		 */
+		autofs_expire_wait(expiring);
+		autofs_del_expiring(expiring);
+		dput(expiring);
+	}
+	return 0;
+}
+
+static struct dentry *autofs_mountpoint_changed(struct path *path)
+{
+	struct dentry *dentry = path->dentry;
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+
+	/*
+	 * If this is an indirect mount the dentry could have gone away
+	 * as a result of an expire and a new one created.
+	 */
+	if (autofs_type_indirect(sbi->type) && d_unhashed(dentry)) {
+		struct dentry *parent = dentry->d_parent;
+		struct autofs_info *ino;
+		struct dentry *new = d_lookup(parent, &dentry->d_name);
+		if (!new)
+			return NULL;
+		ino = autofs_dentry_ino(new);
+		ino->last_used = jiffies;
+		dput(path->dentry);
+		path->dentry = new;
+	}
+	return path->dentry;
+}
+
+static struct vfsmount *autofs_d_automount(struct path *path)
+{
+	struct dentry *dentry = path->dentry;
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
+	int status;
+
+	DPRINTK("dentry=%p %.*s",
+		dentry, dentry->d_name.len, dentry->d_name.name);
+
+	/* The daemon never triggers a mount. */
+	if (autofs_oz_mode(sbi))
+		return NULL;
+
+	/*
+	 * If an expire request is pending everyone must wait.
+	 * If the expire fails we're still mounted so continue
+	 * the follow and return. A return of -EAGAIN (which only
+	 * happens with indirect mounts) means the expire completed
+	 * and the directory was removed, so just go ahead and try
+	 * the mount.
+	 */
+	status = do_expire_wait(dentry);
+	if (status && status != -EAGAIN)
+		return NULL;
+
+	/* Callback to the daemon to perform the mount or wait */
+	spin_lock(&sbi->fs_lock);
+	if (ino->flags & AUTOFS_INF_PENDING) {
+		spin_unlock(&sbi->fs_lock);
+		status = autofs_mount_wait(dentry);
+		if (status)
+			return ERR_PTR(status);
+		goto done;
+	}
+
+	/*
+	 * If the dentry is a symlink it's equivalent to a directory
+	 * having d_mountpoint() true, so there's no need to call back
+	 * to the daemon.
+	 */
+	if (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)) {
+		spin_unlock(&sbi->fs_lock);
+		goto done;
+	}
+
+	if (!d_mountpoint(dentry)) {
+		/*
+		 * It's possible that user space hasn't removed directories
+		 * after umounting a rootless multi-mount, although it
+		 * should. For v5 have_submounts() is sufficient to handle
+		 * this because the leaves of the directory tree under the
+		 * mount never trigger mounts themselves (they have an autofs
+		 * trigger mount mounted on them). But v4 pseudo direct mounts
+		 * do need the leaves to to trigger mounts. In this case we
+		 * have no choice but to use the list_empty() check and
+		 * require user space behave.
+		 */
+		if (sbi->version > 4) {
+			if (have_submounts(dentry)) {
+				spin_unlock(&sbi->fs_lock);
+				goto done;
+			}
+		} else {
+			if (!simple_empty(dentry)) {
+				spin_unlock(&sbi->fs_lock);
+				goto done;
+			}
+		}
+		ino->flags |= AUTOFS_INF_PENDING;
+		spin_unlock(&sbi->fs_lock);
+		status = autofs_mount_wait(dentry);
+		spin_lock(&sbi->fs_lock);
+		ino->flags &= ~AUTOFS_INF_PENDING;
+		if (status) {
+			spin_unlock(&sbi->fs_lock);
+			return ERR_PTR(status);
+		}
+	}
+	spin_unlock(&sbi->fs_lock);
+done:
+	/* Mount succeeded, check if we ended up with a new dentry */
+	dentry = autofs_mountpoint_changed(path);
+	if (!dentry)
+		return ERR_PTR(-ENOENT);
+
+	return NULL;
+}
+
+static int autofs_d_manage(struct dentry *dentry, bool rcu_walk)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
+	int status;
+
+	DPRINTK("dentry=%p %.*s",
+		dentry, dentry->d_name.len, dentry->d_name.name);
+
+	/* The daemon never waits. */
+	if (autofs_oz_mode(sbi)) {
+		if (rcu_walk)
+			return 0;
+		if (!d_mountpoint(dentry))
+			return -EISDIR;
+		return 0;
+	}
+
+	/* We need to sleep, so we need pathwalk to be in ref-mode */
+	if (rcu_walk)
+		return -ECHILD;
+
+	/* Wait for pending expires */
+	do_expire_wait(dentry);
+
+	/*
+	 * This dentry may be under construction so wait on mount
+	 * completion.
+	 */
+	status = autofs_mount_wait(dentry);
+	if (status)
+		return status;
+
+	spin_lock(&sbi->fs_lock);
+	/*
+	 * If the dentry has been selected for expire while we slept
+	 * on the lock then it might go away. We'll deal with that in
+	 * ->d_automount() and wait on a new mount if the expire
+	 * succeeds or return here if it doesn't (since there's no
+	 * mount to follow with a rootless multi-mount).
+	 */
+	if (!(ino->flags & AUTOFS_INF_EXPIRING)) {
+		/*
+		 * Any needed mounting has been completed and the path
+		 * updated so check if this is a rootless multi-mount so
+		 * we can avoid needless calls ->d_automount() and avoid
+		 * an incorrect ELOOP error return.
+		 */
+		if ((!d_mountpoint(dentry) && !simple_empty(dentry)) ||
+		    (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)))
+			status = -EISDIR;
+	}
+	spin_unlock(&sbi->fs_lock);
+
+	return status;
+}
+
+/* Lookups in the root directory */
+static struct dentry *autofs_lookup(struct inode *dir,
+				     struct dentry *dentry, unsigned int flags)
+{
+	struct autofs_sb_info *sbi;
+	struct autofs_info *ino;
+	struct dentry *active;
+
+	DPRINTK("name = %.*s", dentry->d_name.len, dentry->d_name.name);
+
+	/* File name too long to exist */
+	if (dentry->d_name.len > NAME_MAX)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	sbi = autofs_sbi(dir->i_sb);
+
+	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
+		current->pid, task_pgrp_nr(current), sbi->catatonic,
+		autofs_oz_mode(sbi));
+
+	active = autofs_lookup_active(dentry);
+	if (active) {
+		return active;
+	} else {
+		/*
+		 * A dentry that is not within the root can never trigger a
+		 * mount operation, unless the directory already exists, so we
+		 * can return fail immediately.  The daemon however does need
+		 * to create directories within the file system.
+		 */
+		if (!autofs_oz_mode(sbi) && !IS_ROOT(dentry->d_parent))
+			return ERR_PTR(-ENOENT);
+
+		/* Mark entries in the root as mount triggers */
+		if (autofs_type_indirect(sbi->type) && IS_ROOT(dentry->d_parent))
+			__managed_dentry_set_managed(dentry);
+
+		ino = autofs_new_ino(sbi);
+		if (!ino)
+			return ERR_PTR(-ENOMEM);
+
+		dentry->d_fsdata = ino;
+		ino->dentry = dentry;
+
+		autofs_add_active(dentry);
+
+		d_instantiate(dentry, NULL);
+	}
+	return NULL;
+}
+
+static int autofs_dir_symlink(struct inode *dir,
+			       struct dentry *dentry,
+			       const char *symname)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
+	struct autofs_info *p_ino;
+	struct inode *inode;
+	size_t size = strlen(symname);
+	char *cp;
+
+	DPRINTK("%s <- %.*s", symname,
+		dentry->d_name.len, dentry->d_name.name);
+
+	if (!autofs_oz_mode(sbi))
+		return -EACCES;
+
+	BUG_ON(!ino);
+
+	autofs_clean_ino(ino);
+
+	autofs_del_active(dentry);
+
+	cp = kmalloc(size + 1, GFP_KERNEL);
+	if (!cp)
+		return -ENOMEM;
+
+	strcpy(cp, symname);
+
+	inode = autofs_get_inode(dir->i_sb, S_IFLNK | 0555);
+	if (!inode) {
+		kfree(cp);
+		if (!dentry->d_fsdata)
+			kfree(ino);
+		return -ENOMEM;
+	}
+	inode->i_private = cp;
+	inode->i_size = size;
+	d_add(dentry, inode);
+
+	dget(dentry);
+	atomic_inc(&ino->count);
+	p_ino = autofs_dentry_ino(dentry->d_parent);
+	if (p_ino && dentry->d_parent != dentry)
+		atomic_inc(&p_ino->count);
+
+	dir->i_mtime = CURRENT_TIME;
+
+	return 0;
+}
+
+/*
+ * NOTE!
+ *
+ * Normal filesystems would do a "d_delete()" to tell the VFS dcache
+ * that the file no longer exists. However, doing that means that the
+ * VFS layer can turn the dentry into a negative dentry.  We don't want
+ * this, because the unlink is probably the result of an expire.
+ * We simply d_drop it and add it to a expiring list in the super block,
+ * which allows the dentry lookup to check for an incomplete expire.
+ *
+ * If a process is blocked on the dentry waiting for the expire to finish,
+ * it will invalidate the dentry and try to mount with a new one.
+ *
+ * Also see autofs_dir_rmdir()..
+ */
+static int autofs_dir_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
+	struct autofs_info *p_ino;
+
+	/* This allows root to remove symlinks */
+	if (!autofs_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (atomic_dec_and_test(&ino->count)) {
+		p_ino = autofs_dentry_ino(dentry->d_parent);
+		if (p_ino && dentry->d_parent != dentry)
+			atomic_dec(&p_ino->count);
+	}
+	dput(ino->dentry);
+
+	dentry->d_inode->i_size = 0;
+	clear_nlink(dentry->d_inode);
+
+	dir->i_mtime = CURRENT_TIME;
+
+	spin_lock(&sbi->lookup_lock);
+	__autofs_add_expiring(dentry);
+	d_drop(dentry);
+	spin_unlock(&sbi->lookup_lock);
+
+	return 0;
+}
+
+/*
+ * Version 4 of autofs provides a pseudo direct mount implementation
+ * that relies on directories at the leaves of a directory tree under
+ * an indirect mount to trigger mounts. To allow for this we need to
+ * set the DMANAGED_AUTOMOUNT and DMANAGED_TRANSIT flags on the leaves
+ * of the directory tree. There is no need to clear the automount flag
+ * following a mount or restore it after an expire because these mounts
+ * are always covered. However, it is necessary to ensure that these
+ * flags are clear on non-empty directories to avoid unnecessary calls
+ * during path walks.
+ */
+static void autofs_set_leaf_automount_flags(struct dentry *dentry)
+{
+	struct dentry *parent;
+
+	/* root and dentrys in the root are already handled */
+	if (IS_ROOT(dentry->d_parent))
+		return;
+
+	managed_dentry_set_managed(dentry);
+
+	parent = dentry->d_parent;
+	/* only consider parents below dentrys in the root */
+	if (IS_ROOT(parent->d_parent))
+		return;
+	managed_dentry_clear_managed(parent);
+	return;
+}
+
+static void autofs_clear_leaf_automount_flags(struct dentry *dentry)
+{
+	struct list_head *d_child;
+	struct dentry *parent;
+
+	/* flags for dentrys in the root are handled elsewhere */
+	if (IS_ROOT(dentry->d_parent))
+		return;
+
+	managed_dentry_clear_managed(dentry);
+
+	parent = dentry->d_parent;
+	/* only consider parents below dentrys in the root */
+	if (IS_ROOT(parent->d_parent))
+		return;
+	d_child = &dentry->d_u.d_child;
+	/* Set parent managed if it's becoming empty */
+	if (d_child->next == &parent->d_subdirs &&
+	    d_child->prev == &parent->d_subdirs)
+		managed_dentry_set_managed(parent);
+	return;
+}
+
+static int autofs_dir_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
+	struct autofs_info *p_ino;
+
+	DPRINTK("dentry %p, removing %.*s",
+		dentry, dentry->d_name.len, dentry->d_name.name);
+
+	if (!autofs_oz_mode(sbi))
+		return -EACCES;
+
+	spin_lock(&sbi->lookup_lock);
+	if (!simple_empty(dentry)) {
+		spin_unlock(&sbi->lookup_lock);
+		return -ENOTEMPTY;
+	}
+	__autofs_add_expiring(dentry);
+	d_drop(dentry);
+	spin_unlock(&sbi->lookup_lock);
+
+	if (sbi->version < 5)
+		autofs_clear_leaf_automount_flags(dentry);
+
+	if (atomic_dec_and_test(&ino->count)) {
+		p_ino = autofs_dentry_ino(dentry->d_parent);
+		if (p_ino && dentry->d_parent != dentry)
+			atomic_dec(&p_ino->count);
+	}
+	dput(ino->dentry);
+	dentry->d_inode->i_size = 0;
+	clear_nlink(dentry->d_inode);
+
+	if (dir->i_nlink)
+		drop_nlink(dir);
+
+	return 0;
+}
+
+static int autofs_dir_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
+	struct autofs_info *p_ino;
+	struct inode *inode;
+
+	if (!autofs_oz_mode(sbi))
+		return -EACCES;
+
+	DPRINTK("dentry %p, creating %.*s",
+		dentry, dentry->d_name.len, dentry->d_name.name);
+
+	BUG_ON(!ino);
+
+	autofs_clean_ino(ino);
+
+	autofs_del_active(dentry);
+
+	inode = autofs_get_inode(dir->i_sb, S_IFDIR | 0555);
+	if (!inode)
+		return -ENOMEM;
+	d_add(dentry, inode);
+
+	if (sbi->version < 5)
+		autofs_set_leaf_automount_flags(dentry);
+
+	dget(dentry);
+	atomic_inc(&ino->count);
+	p_ino = autofs_dentry_ino(dentry->d_parent);
+	if (p_ino && dentry->d_parent != dentry)
+		atomic_inc(&p_ino->count);
+	inc_nlink(dir);
+	dir->i_mtime = CURRENT_TIME;
+
+	return 0;
+}
+
+/* Get/set timeout ioctl() operation */
+#ifdef CONFIG_COMPAT
+static inline int autofs_compat_get_set_timeout(struct autofs_sb_info *sbi,
+						 compat_ulong_t __user *p)
+{
+	int rv;
+	unsigned long ntimeout;
+
+	if ((rv = get_user(ntimeout, p)) ||
+	     (rv = put_user(sbi->exp_timeout/HZ, p)))
+		return rv;
+
+	if (ntimeout > UINT_MAX/HZ)
+		sbi->exp_timeout = 0;
+	else
+		sbi->exp_timeout = ntimeout * HZ;
+
+	return 0;
+}
+#endif
+
+static inline int autofs_get_set_timeout(struct autofs_sb_info *sbi,
+					  unsigned long __user *p)
+{
+	int rv;
+	unsigned long ntimeout;
+
+	if ((rv = get_user(ntimeout, p)) ||
+	     (rv = put_user(sbi->exp_timeout/HZ, p)))
+		return rv;
+
+	if (ntimeout > ULONG_MAX/HZ)
+		sbi->exp_timeout = 0;
+	else
+		sbi->exp_timeout = ntimeout * HZ;
+
+	return 0;
+}
+
+/* Return protocol version */
+static inline int autofs_get_protover(struct autofs_sb_info *sbi,
+				       int __user *p)
+{
+	return put_user(sbi->version, p);
+}
+
+/* Return protocol sub version */
+static inline int autofs_get_protosubver(struct autofs_sb_info *sbi,
+					  int __user *p)
+{
+	return put_user(sbi->sub_version, p);
+}
+
+/*
+* Tells the daemon whether it can umount the autofs mount.
+*/
+static inline int autofs_ask_umount(struct vfsmount *mnt, int __user *p)
+{
+	int status = 0;
+
+	if (may_umount(mnt))
+		status = 1;
+
+	DPRINTK("returning %d", status);
+
+	status = put_user(status, p);
+
+	return status;
+}
+
+/* Identify autofs_dentries - this is so we can tell if there's
+   an extra dentry refcount or not.  We only hold a refcount on the
+   dentry if its non-negative (ie, d_inode != NULL)
+*/
+int is_autofs_dentry(struct dentry *dentry)
+{
+	return dentry && dentry->d_inode &&
+		dentry->d_op == &autofs_dentry_operations &&
+		dentry->d_fsdata != NULL;
+}
+
+/*
+ * ioctl()'s on the root directory is the chief method for the daemon to
+ * generate kernel reactions
+ */
+static int autofs_root_ioctl_unlocked(struct inode *inode, struct file *filp,
+				       unsigned int cmd, unsigned long arg)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
+	void __user *p = (void __user *)arg;
+
+	DPRINTK("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u",
+		cmd,arg,sbi,task_pgrp_nr(current));
+
+	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
+	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)
+		return -ENOTTY;
+
+	if (!autofs_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	switch(cmd) {
+	case AUTOFS_IOC_READY:	/* Wait queue: go ahead and retry */
+		return autofs_wait_release(sbi,(autofs_wqt_t)arg,0);
+	case AUTOFS_IOC_FAIL:	/* Wait queue: fail with ENOENT */
+		return autofs_wait_release(sbi,(autofs_wqt_t)arg,-ENOENT);
+	case AUTOFS_IOC_CATATONIC: /* Enter catatonic mode (daemon shutdown) */
+		autofs_catatonic_mode(sbi);
+		return 0;
+	case AUTOFS_IOC_PROTOVER: /* Get protocol version */
+		return autofs_get_protover(sbi, p);
+	case AUTOFS_IOC_PROTOSUBVER: /* Get protocol sub version */
+		return autofs_get_protosubver(sbi, p);
+	case AUTOFS_IOC_SETTIMEOUT:
+		return autofs_get_set_timeout(sbi, p);
+#ifdef CONFIG_COMPAT
+	case AUTOFS_IOC_SETTIMEOUT32:
+		return autofs_compat_get_set_timeout(sbi, p);
+#endif
+
+	case AUTOFS_IOC_ASKUMOUNT:
+		return autofs_ask_umount(filp->f_path.mnt, p);
+
+	/* return a single thing to expire */
+	case AUTOFS_IOC_EXPIRE:
+		return autofs_expire_run(inode->i_sb,filp->f_path.mnt,sbi, p);
+	/* same as above, but can send multiple expires through pipe */
+	case AUTOFS_IOC_EXPIRE_MULTI:
+		return autofs_expire_multi(inode->i_sb,filp->f_path.mnt,sbi, p);
+
+	default:
+		return -ENOSYS;
+	}
+}
+
+static long autofs_root_ioctl(struct file *filp,
+			       unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = file_inode(filp);
+	return autofs_root_ioctl_unlocked(inode, filp, cmd, arg);
+}
+
+#ifdef CONFIG_COMPAT
+static long autofs_root_compat_ioctl(struct file *filp,
+				      unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = file_inode(filp);
+	int ret;
+
+	if (cmd == AUTOFS_IOC_READY || cmd == AUTOFS_IOC_FAIL)
+		ret = autofs_root_ioctl_unlocked(inode, filp, cmd, arg);
+	else
+		ret = autofs_root_ioctl_unlocked(inode, filp, cmd,
+					      (unsigned long) compat_ptr(arg));
+
+	return ret;
+}
+#endif
diff --git a/fs/autofs/symlink.c b/fs/autofs/symlink.c
new file mode 100644
index 0000000..9d728bf
--- /dev/null
+++ b/fs/autofs/symlink.c
@@ -0,0 +1,21 @@
+/*
+ *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ *
+ * ------------------------------------------------------------------------- */
+
+#include "autofs_i.h"
+
+static void *autofs_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	nd_set_link(nd, dentry->d_inode->i_private);
+	return NULL;
+}
+
+const struct inode_operations autofs_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= autofs_follow_link
+};
diff --git a/fs/autofs/waitq.c b/fs/autofs/waitq.c
new file mode 100644
index 0000000..8b83761
--- /dev/null
+++ b/fs/autofs/waitq.c
@@ -0,0 +1,570 @@
+/*
+ *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
+ *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ *
+ * ------------------------------------------------------------------------- */
+
+#include <linux/slab.h>
+#include <linux/time.h>
+#include <linux/signal.h>
+#include <linux/file.h>
+#include "autofs_i.h"
+
+/* We make this a static variable rather than a part of the superblock; it
+   is better if we don't reassign numbers easily even across filesystems */
+static autofs_wqt_t autofs_next_wait_queue = 1;
+
+/* These are the signals we allow interrupting a pending mount */
+#define SHUTDOWN_SIGS	(sigmask(SIGKILL) | sigmask(SIGINT) | sigmask(SIGQUIT))
+
+void autofs_catatonic_mode(struct autofs_sb_info *sbi)
+{
+	struct autofs_wait_queue *wq, *nwq;
+
+	mutex_lock(&sbi->wq_mutex);
+	if (sbi->catatonic) {
+		mutex_unlock(&sbi->wq_mutex);
+		return;
+	}
+
+	DPRINTK("entering catatonic mode");
+
+	sbi->catatonic = 1;
+	wq = sbi->queues;
+	sbi->queues = NULL;	/* Erase all wait queues */
+	while (wq) {
+		nwq = wq->next;
+		wq->status = -ENOENT; /* Magic is gone - report failure */
+		kfree(wq->name.name);
+		wq->name.name = NULL;
+		wq->wait_ctr--;
+		wake_up_interruptible(&wq->queue);
+		wq = nwq;
+	}
+	fput(sbi->pipe);	/* Close the pipe */
+	sbi->pipe = NULL;
+	sbi->pipefd = -1;
+	mutex_unlock(&sbi->wq_mutex);
+}
+
+static int autofs_write(struct autofs_sb_info *sbi,
+			struct file *file, const void *addr, int bytes)
+{
+	unsigned long sigpipe, flags;
+	mm_segment_t fs;
+	const char *data = (const char *)addr;
+	ssize_t wr = 0;
+
+	sigpipe = sigismember(&current->pending.signal, SIGPIPE);
+
+	/* Save pointer to user space and point back to kernel space */
+	fs = get_fs();
+	set_fs(KERNEL_DS);
+
+	mutex_lock(&sbi->pipe_mutex);
+	while (bytes &&
+	       (wr = file->f_op->write(file,data,bytes,&file->f_pos)) > 0) {
+		data += wr;
+		bytes -= wr;
+	}
+	mutex_unlock(&sbi->pipe_mutex);
+
+	set_fs(fs);
+
+	/* Keep the currently executing process from receiving a
+	   SIGPIPE unless it was already supposed to get one */
+	if (wr == -EPIPE && !sigpipe) {
+		spin_lock_irqsave(&current->sighand->siglock, flags);
+		sigdelset(&current->pending.signal, SIGPIPE);
+		recalc_sigpending();
+		spin_unlock_irqrestore(&current->sighand->siglock, flags);
+	}
+
+	return (bytes > 0);
+}
+
+static void autofs_notify_daemon(struct autofs_sb_info *sbi,
+				 struct autofs_wait_queue *wq,
+				 int type)
+{
+	union {
+		struct autofs_packet_hdr hdr;
+		union autofs_packet_union v4_pkt;
+		union autofs_v5_packet_union v5_pkt;
+	} pkt;
+	struct file *pipe = NULL;
+	size_t pktsz;
+
+	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
+		(unsigned long) wq->wait_queue_token,
+		wq->name.len, wq->name.name, type);
+
+	memset(&pkt,0,sizeof pkt); /* For security reasons */
+
+	pkt.hdr.proto_version = sbi->version;
+	pkt.hdr.type = type;
+	mutex_lock(&sbi->wq_mutex);
+
+	/* Check if we have become catatonic */
+	if (sbi->catatonic) {
+		mutex_unlock(&sbi->wq_mutex);
+		return;
+	}
+	switch (type) {
+	/* Kernel protocol v4 missing and expire packets */
+	case autofs_ptype_missing:
+	{
+		struct autofs_packet_missing *mp = &pkt.v4_pkt.missing;
+
+		pktsz = sizeof(*mp);
+
+		mp->wait_queue_token = wq->wait_queue_token;
+		mp->len = wq->name.len;
+		memcpy(mp->name, wq->name.name, wq->name.len);
+		mp->name[wq->name.len] = '\0';
+		break;
+	}
+	case autofs_ptype_expire_multi:
+	{
+		struct autofs_packet_expire_multi *ep = &pkt.v4_pkt.expire_multi;
+
+		pktsz = sizeof(*ep);
+
+		ep->wait_queue_token = wq->wait_queue_token;
+		ep->len = wq->name.len;
+		memcpy(ep->name, wq->name.name, wq->name.len);
+		ep->name[wq->name.len] = '\0';
+		break;
+	}
+	/*
+	 * Kernel protocol v5 packet for handling indirect and direct
+	 * mount missing and expire requests
+	 */
+	case autofs_ptype_missing_indirect:
+	case autofs_ptype_expire_indirect:
+	case autofs_ptype_missing_direct:
+	case autofs_ptype_expire_direct:
+	{
+		struct autofs_v5_packet *packet = &pkt.v5_pkt.v5_packet;
+		struct user_namespace *user_ns = sbi->pipe->f_cred->user_ns;
+
+		pktsz = sizeof(*packet);
+
+		packet->wait_queue_token = wq->wait_queue_token;
+		packet->len = wq->name.len;
+		memcpy(packet->name, wq->name.name, wq->name.len);
+		packet->name[wq->name.len] = '\0';
+		packet->dev = wq->dev;
+		packet->ino = wq->ino;
+		packet->uid = from_kuid_munged(user_ns, wq->uid);
+		packet->gid = from_kgid_munged(user_ns, wq->gid);
+		packet->pid = wq->pid;
+		packet->tgid = wq->tgid;
+		break;
+	}
+	default:
+		printk("autofs_notify_daemon: bad type %d!\n", type);
+		mutex_unlock(&sbi->wq_mutex);
+		return;
+	}
+
+	pipe = get_file(sbi->pipe);
+
+	mutex_unlock(&sbi->wq_mutex);
+
+	if (autofs_write(sbi, pipe, &pkt, pktsz))
+		autofs_catatonic_mode(sbi);
+	fput(pipe);
+}
+
+static int autofs_getpath(struct autofs_sb_info *sbi,
+			  struct dentry *dentry, char **name)
+{
+	struct dentry *root = sbi->sb->s_root;
+	struct dentry *tmp;
+	char *buf;
+	char *p;
+	int len;
+	unsigned seq;
+
+rename_retry:
+	buf = *name;
+	len = 0;
+
+	seq = read_seqbegin(&rename_lock);
+	rcu_read_lock();
+	spin_lock(&sbi->fs_lock);
+	for (tmp = dentry ; tmp != root ; tmp = tmp->d_parent)
+		len += tmp->d_name.len + 1;
+
+	if (!len || --len > NAME_MAX) {
+		spin_unlock(&sbi->fs_lock);
+		rcu_read_unlock();
+		if (read_seqretry(&rename_lock, seq))
+			goto rename_retry;
+		return 0;
+	}
+
+	*(buf + len) = '\0';
+	p = buf + len - dentry->d_name.len;
+	strncpy(p, dentry->d_name.name, dentry->d_name.len);
+
+	for (tmp = dentry->d_parent; tmp != root ; tmp = tmp->d_parent) {
+		*(--p) = '/';
+		p -= tmp->d_name.len;
+		strncpy(p, tmp->d_name.name, tmp->d_name.len);
+	}
+	spin_unlock(&sbi->fs_lock);
+	rcu_read_unlock();
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
+
+	return len;
+}
+
+static struct autofs_wait_queue *
+autofs_find_wait(struct autofs_sb_info *sbi, struct qstr *qstr)
+{
+	struct autofs_wait_queue *wq;
+
+	for (wq = sbi->queues; wq; wq = wq->next) {
+		if (wq->name.hash == qstr->hash &&
+		    wq->name.len == qstr->len &&
+		    wq->name.name &&
+		    !memcmp(wq->name.name, qstr->name, qstr->len))
+			break;
+	}
+	return wq;
+}
+
+/*
+ * Check if we have a valid request.
+ * Returns
+ * 1 if the request should continue.
+ *   In this case we can return an autofs_wait_queue entry if one is
+ *   found or NULL to idicate a new wait needs to be created.
+ * 0 or a negative errno if the request shouldn't continue.
+ */
+static int validate_request(struct autofs_wait_queue **wait,
+			    struct autofs_sb_info *sbi,
+			    struct qstr *qstr,
+			    struct dentry*dentry, enum autofs_notify notify)
+{
+	struct autofs_wait_queue *wq;
+	struct autofs_info *ino;
+
+	if (sbi->catatonic)
+		return -ENOENT;
+
+	/* Wait in progress, continue; */
+	wq = autofs_find_wait(sbi, qstr);
+	if (wq) {
+		*wait = wq;
+		return 1;
+	}
+
+	*wait = NULL;
+
+	/* If we don't yet have any info this is a new request */
+	ino = autofs_dentry_ino(dentry);
+	if (!ino)
+		return 1;
+
+	/*
+	 * If we've been asked to wait on an existing expire (NFY_NONE)
+	 * but there is no wait in the queue ...
+	 */
+	if (notify == NFY_NONE) {
+		/*
+		 * Either we've betean the pending expire to post it's
+		 * wait or it finished while we waited on the mutex.
+		 * So we need to wait till either, the wait appears
+		 * or the expire finishes.
+		 */
+
+		while (ino->flags & AUTOFS_INF_EXPIRING) {
+			mutex_unlock(&sbi->wq_mutex);
+			schedule_timeout_interruptible(HZ/10);
+			if (mutex_lock_interruptible(&sbi->wq_mutex))
+				return -EINTR;
+
+			if (sbi->catatonic)
+				return -ENOENT;
+
+			wq = autofs_find_wait(sbi, qstr);
+			if (wq) {
+				*wait = wq;
+				return 1;
+			}
+		}
+
+		/*
+		 * Not ideal but the status has already gone. Of the two
+		 * cases where we wait on NFY_NONE neither depend on the
+		 * return status of the wait.
+		 */
+		return 0;
+	}
+
+	/*
+	 * If we've been asked to trigger a mount and the request
+	 * completed while we waited on the mutex ...
+	 */
+	if (notify == NFY_MOUNT) {
+		struct dentry *new = NULL;
+		int valid = 1;
+
+		/*
+		 * If the dentry was successfully mounted while we slept
+		 * on the wait queue mutex we can return success. If it
+		 * isn't mounted (doesn't have submounts for the case of
+		 * a multi-mount with no mount at it's base) we can
+		 * continue on and create a new request.
+		 */
+		if (!IS_ROOT(dentry)) {
+			if (dentry->d_inode && d_unhashed(dentry)) {
+				struct dentry *parent = dentry->d_parent;
+				new = d_lookup(parent, &dentry->d_name);
+				if (new)
+					dentry = new;
+			}
+		}
+		if (have_submounts(dentry))
+			valid = 0;
+
+		if (new)
+			dput(new);
+		return valid;
+	}
+
+	return 1;
+}
+
+int autofs_wait(struct autofs_sb_info *sbi,
+		struct dentry *dentry, enum autofs_notify notify)
+{
+	struct autofs_wait_queue *wq;
+	struct qstr qstr;
+	char *name;
+	int status, ret, type;
+	pid_t pid;
+	pid_t tgid;
+
+	/* In catatonic mode, we don't wait for nobody */
+	if (sbi->catatonic)
+		return -ENOENT;
+
+	/*
+	 * Try translating pids to the namespace of the daemon.
+	 *
+	 * Zero means failure: we are in an unrelated pid namespace.
+	 */
+	pid = task_pid_nr_ns(current, ns_of_pid(sbi->oz_pgrp));
+	tgid = task_tgid_nr_ns(current, ns_of_pid(sbi->oz_pgrp));
+	if (pid == 0 || tgid == 0)
+		return -ENOENT;
+
+	if (!dentry->d_inode) {
+		/*
+		 * A wait for a negative dentry is invalid for certain
+		 * cases. A direct or offset mount "always" has its mount
+		 * point directory created and so the request dentry must
+		 * be positive or the map key doesn't exist. The situation
+		 * is very similar for indirect mounts except only dentrys
+		 * in the root of the autofs file system may be negative.
+		 */
+		if (autofs_type_trigger(sbi->type))
+			return -ENOENT;
+		else if (!IS_ROOT(dentry->d_parent))
+			return -ENOENT;
+	}
+
+	name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+
+	/* If this is a direct mount request create a dummy name */
+	if (IS_ROOT(dentry) && autofs_type_trigger(sbi->type))
+		qstr.len = sprintf(name, "%p", dentry);
+	else {
+		qstr.len = autofs_getpath(sbi, dentry, &name);
+		if (!qstr.len) {
+			kfree(name);
+			return -ENOENT;
+		}
+	}
+	qstr.name = name;
+	qstr.hash = full_name_hash(name, qstr.len);
+
+	if (mutex_lock_interruptible(&sbi->wq_mutex)) {
+		kfree(qstr.name);
+		return -EINTR;
+	}
+
+	ret = validate_request(&wq, sbi, &qstr, dentry, notify);
+	if (ret <= 0) {
+		if (ret != -EINTR)
+			mutex_unlock(&sbi->wq_mutex);
+		kfree(qstr.name);
+		return ret;
+	}
+
+	if (!wq) {
+		/* Create a new wait queue */
+		wq = kmalloc(sizeof(struct autofs_wait_queue),GFP_KERNEL);
+		if (!wq) {
+			kfree(qstr.name);
+			mutex_unlock(&sbi->wq_mutex);
+			return -ENOMEM;
+		}
+
+		wq->wait_queue_token = autofs_next_wait_queue;
+		if (++autofs_next_wait_queue == 0)
+			autofs_next_wait_queue = 1;
+		wq->next = sbi->queues;
+		sbi->queues = wq;
+		init_waitqueue_head(&wq->queue);
+		memcpy(&wq->name, &qstr, sizeof(struct qstr));
+		wq->dev = autofs_get_dev(sbi);
+		wq->ino = autofs_get_ino(sbi);
+		wq->uid = current_uid();
+		wq->gid = current_gid();
+		wq->pid = pid;
+		wq->tgid = tgid;
+		wq->status = -EINTR; /* Status return if interrupted */
+		wq->wait_ctr = 2;
+		mutex_unlock(&sbi->wq_mutex);
+
+		if (sbi->version < 5) {
+			if (notify == NFY_MOUNT)
+				type = autofs_ptype_missing;
+			else
+				type = autofs_ptype_expire_multi;
+		} else {
+			if (notify == NFY_MOUNT)
+				type = autofs_type_trigger(sbi->type) ?
+					autofs_ptype_missing_direct :
+					 autofs_ptype_missing_indirect;
+			else
+				type = autofs_type_trigger(sbi->type) ?
+					autofs_ptype_expire_direct :
+					autofs_ptype_expire_indirect;
+		}
+
+		DPRINTK("new wait id = 0x%08lx, name = %.*s, nfy=%d\n",
+			(unsigned long) wq->wait_queue_token, wq->name.len,
+			wq->name.name, notify);
+
+		/* autofs_notify_daemon() may block */
+		autofs_notify_daemon(sbi, wq, type);
+	} else {
+		wq->wait_ctr++;
+		mutex_unlock(&sbi->wq_mutex);
+		kfree(qstr.name);
+		DPRINTK("existing wait id = 0x%08lx, name = %.*s, nfy=%d",
+			(unsigned long) wq->wait_queue_token, wq->name.len,
+			wq->name.name, notify);
+	}
+
+	/*
+	 * wq->name.name is NULL iff the lock is already released
+	 * or the mount has been made catatonic.
+	 */
+	if (wq->name.name) {
+		/* Block all but "shutdown" signals while waiting */
+		sigset_t oldset;
+		unsigned long irqflags;
+
+		spin_lock_irqsave(&current->sighand->siglock, irqflags);
+		oldset = current->blocked;
+		siginitsetinv(&current->blocked, SHUTDOWN_SIGS & ~oldset.sig[0]);
+		recalc_sigpending();
+		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
+
+		wait_event_interruptible(wq->queue, wq->name.name == NULL);
+
+		spin_lock_irqsave(&current->sighand->siglock, irqflags);
+		current->blocked = oldset;
+		recalc_sigpending();
+		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
+	} else {
+		DPRINTK("skipped sleeping");
+	}
+
+	status = wq->status;
+
+	/*
+	 * For direct and offset mounts we need to track the requester's
+	 * uid and gid in the dentry info struct. This is so it can be
+	 * supplied, on request, by the misc device ioctl interface.
+	 * This is needed during daemon resatart when reconnecting
+	 * to existing, active, autofs mounts. The uid and gid (and
+	 * related string values) may be used for macro substitution
+	 * in autofs mount maps.
+	 */
+	if (!status) {
+		struct autofs_info *ino;
+		struct dentry *de = NULL;
+
+		/* direct mount or browsable map */
+		ino = autofs_dentry_ino(dentry);
+		if (!ino) {
+			/* If not lookup actual dentry used */
+			de = d_lookup(dentry->d_parent, &dentry->d_name);
+			if (de)
+				ino = autofs_dentry_ino(de);
+		}
+
+		/* Set mount requester */
+		if (ino) {
+			spin_lock(&sbi->fs_lock);
+			ino->uid = wq->uid;
+			ino->gid = wq->gid;
+			spin_unlock(&sbi->fs_lock);
+		}
+
+		if (de)
+			dput(de);
+	}
+
+	/* Are we the last process to need status? */
+	mutex_lock(&sbi->wq_mutex);
+	if (!--wq->wait_ctr)
+		kfree(wq);
+	mutex_unlock(&sbi->wq_mutex);
+
+	return status;
+}
+
+
+int autofs_wait_release(struct autofs_sb_info *sbi,
+			autofs_wqt_t wait_queue_token, int status)
+{
+	struct autofs_wait_queue *wq, **wql;
+
+	mutex_lock(&sbi->wq_mutex);
+	for (wql = &sbi->queues; (wq = *wql) != NULL; wql = &wq->next) {
+		if (wq->wait_queue_token == wait_queue_token)
+			break;
+	}
+
+	if (!wq) {
+		mutex_unlock(&sbi->wq_mutex);
+		return -EINVAL;
+	}
+
+	*wql = wq->next;	/* Unlink from chain */
+	kfree(wq->name.name);
+	wq->name.name = NULL;	/* Do not wait on this queue */
+	wq->status = status;
+	wake_up_interruptible(&wq->queue);
+	if (!--wq->wait_ctr)
+		kfree(wq);
+	mutex_unlock(&sbi->wq_mutex);
+
+	return 0;
+}
diff --git a/fs/autofs4/Kconfig b/fs/autofs4/Kconfig
index 1204d63..0e1167a 100644
--- a/fs/autofs4/Kconfig
+++ b/fs/autofs4/Kconfig
@@ -1,5 +1,5 @@
 config AUTOFS4_FS
-	tristate "Kernel automounter version 4 support (also supports v3)"
+	tristate "Kernel automounter support (supports v3, v4 and v5)"
 	help
 	  The automounter is a tool to automatically mount remote file systems
 	  on demand. This implementation is partially kernel-based to reduce
@@ -7,14 +7,25 @@ config AUTOFS4_FS
 	  automounter (amd), which is a pure user space daemon.
 
 	  To use the automounter you need the user-space tools from
-	  <ftp://ftp.kernel.org/pub/linux/daemons/autofs/v4/>; you also
-	  want to answer Y to "NFS file system support", below.
+	  <ftp://ftp.kernel.org/pub/linux/daemons/autofs/>; you also want
+	  to answer Y to "NFS file system support", below.
 
-	  To compile this support as a module, choose M here: the module will be
-	  called autofs4.  You will need to add "alias autofs autofs4" to your
-	  modules configuration file.
+	  This module is in the process of being renamed from autofs4 to autofs
+	  since is now the only module that provides the autofs file system and
+	  the module is not version 4 specific.
+
+	  It is now built from the source located in fs/autofs and this directory
+          and the configuration entry will be removed two kernel version from the
+	  inclusion of this change.
+
+	  Changes that will need to be made should be limited to:
+	  - source include statments should be changed from autofs_fs4.h to
+	    autofs_fs.h since these two header file have been merged.
+	  - user space scripts that manually load autofs4.ko should be changed
+	    to load autofs.ko. Since the module directory name and the module
+	    name itself are the same now there is no need to manually load
+	    module.
+	  - any "alias autofs autofs4" will need to be removed.
+
+	  Please configure AUTOFS_FS instead of AUTOFS4_FS from now on.
 
-	  If you are not a part of a fairly large, distributed network or
-	  don't have a laptop which needs to dynamically reconfigure to the
-	  local network, you probably do not need an automounter, and can say
-	  N here.
diff --git a/fs/autofs4/Makefile b/fs/autofs4/Makefile
index a811c1f..bd4a535 100644
--- a/fs/autofs4/Makefile
+++ b/fs/autofs4/Makefile
@@ -4,4 +4,12 @@
 
 obj-$(CONFIG_AUTOFS4_FS) += autofs4.o
 
-autofs4-objs := init.o inode.o root.o symlink.o waitq.o expire.o dev-ioctl.o
+autofs4-y := ../autofs/init.o
+autofs4-y += ../autofs/inode.o
+autofs4-y += ../autofs/root.o
+autofs4-y += ../autofs/symlink.o
+autofs4-y += ../autofs/waitq.o
+autofs4-y += ../autofs/expire.o
+autofs4-y += ../autofs/dev-ioctl.o
+
+EXTRA_CFLAGS := -I$(src)/../autofs
diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
deleted file mode 100644
index dcdd1d7..0000000
--- a/fs/autofs4/autofs_i.h
+++ /dev/null
@@ -1,341 +0,0 @@
-/*
- *   Copyright 1997-1998 Transmeta Corporation - All Rights Reserved
- *   Copyright 2005-2006 Ian Kent <raven@themaw.net>
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- *
- * ----------------------------------------------------------------------- */
-
-/* Internal header file for autofs */
-
-#include <linux/auto_fs.h>
-#include <linux/auto_dev-ioctl.h>
-#include <linux/mutex.h>
-#include <linux/spinlock.h>
-#include <linux/list.h>
-
-/* This is the range of ioctl() numbers we claim as ours */
-#define AUTOFS_IOC_FIRST     AUTOFS_IOC_READY
-#define AUTOFS_IOC_COUNT     32
-
-#define AUTOFS_DEV_IOCTL_IOC_FIRST	(AUTOFS_DEV_IOCTL_VERSION)
-#define AUTOFS_DEV_IOCTL_IOC_COUNT	(AUTOFS_IOC_COUNT - 11)
-
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/time.h>
-#include <linux/string.h>
-#include <linux/wait.h>
-#include <linux/sched.h>
-#include <linux/mount.h>
-#include <linux/namei.h>
-#include <asm/current.h>
-#include <asm/uaccess.h>
-
-/* #define DEBUG */
-
-#define DPRINTK(fmt, ...)				\
-	pr_debug("pid %d: %s: " fmt "\n",		\
-		current->pid, __func__, ##__VA_ARGS__)
-
-#define AUTOFS_WARN(fmt, ...)				\
-	printk(KERN_WARNING "pid %d: %s: " fmt "\n",	\
-		current->pid, __func__, ##__VA_ARGS__)
-
-#define AUTOFS_ERROR(fmt, ...)				\
-	printk(KERN_ERR "pid %d: %s: " fmt "\n",	\
-		current->pid, __func__, ##__VA_ARGS__)
-
-/*
- * Unified info structure.  This is pointed to by both the dentry and
- * inode structures.  Each file in the filesystem has an instance of this
- * structure.  It holds a reference to the dentry, so dentries are never
- * flushed while the file exists.  All name lookups are dealt with at the
- * dentry level, although the filesystem can interfere in the validation
- * process.  Readdir is implemented by traversing the dentry lists.
- */
-struct autofs_info {
-	struct dentry	*dentry;
-	struct inode	*inode;
-
-	int		flags;
-
-	struct completion expire_complete;
-
-	struct list_head active;
-	int active_count;
-
-	struct list_head expiring;
-
-	struct autofs_sb_info *sbi;
-	unsigned long last_used;
-	atomic_t count;
-
-	kuid_t uid;
-	kgid_t gid;
-};
-
-#define AUTOFS_INF_EXPIRING	(1<<0) /* dentry in the process of expiring */
-#define AUTOFS_INF_PENDING	(1<<2) /* dentry pending mount */
-
-struct autofs_wait_queue {
-	wait_queue_head_t queue;
-	struct autofs_wait_queue *next;
-	autofs_wqt_t wait_queue_token;
-	/* We use the following to see what we are waiting for */
-	struct qstr name;
-	u32 dev;
-	u64 ino;
-	kuid_t uid;
-	kgid_t gid;
-	pid_t pid;
-	pid_t tgid;
-	/* This is for status reporting upon return */
-	int status;
-	unsigned int wait_ctr;
-};
-
-#define AUTOFS_SBI_MAGIC 0x6d4a556d
-
-struct autofs_sb_info {
-	u32 magic;
-	int pipefd;
-	struct file *pipe;
-	struct pid *oz_pgrp;
-	int catatonic;
-	int version;
-	int sub_version;
-	int min_proto;
-	int max_proto;
-	unsigned long exp_timeout;
-	unsigned int type;
-	int reghost_enabled;
-	int needs_reghost;
-	struct super_block *sb;
-	struct mutex wq_mutex;
-	struct mutex pipe_mutex;
-	spinlock_t fs_lock;
-	struct autofs_wait_queue *queues; /* Wait queue pointer */
-	spinlock_t lookup_lock;
-	struct list_head active_list;
-	struct list_head expiring_list;
-};
-
-static inline struct autofs_sb_info *autofs_sbi(struct super_block *sb)
-{
-	return (struct autofs_sb_info *)(sb->s_fs_info);
-}
-
-static inline struct autofs_info *autofs_dentry_ino(struct dentry *dentry)
-{
-	return (struct autofs_info *)(dentry->d_fsdata);
-}
-
-/* autofs_oz_mode(): do we see the man behind the curtain?  (The
-   processes which do manipulations for us in user space sees the raw
-   filesystem without "magic".) */
-
-static inline int autofs_oz_mode(struct autofs_sb_info *sbi)
-{
-	return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
-}
-
-/* Does a dentry have some pending activity? */
-static inline int autofs_ispending(struct dentry *dentry)
-{
-	struct autofs_info *inf = autofs_dentry_ino(dentry);
-
-	if (inf->flags & AUTOFS_INF_PENDING)
-		return 1;
-
-	if (inf->flags & AUTOFS_INF_EXPIRING)
-		return 1;
-
-	return 0;
-}
-
-struct inode *autofs_get_inode(struct super_block *, umode_t);
-void autofs_free_ino(struct autofs_info *);
-
-/* Expiration */
-int is_autofs_dentry(struct dentry *);
-int autofs_expire_wait(struct dentry *dentry);
-int autofs_expire_run(struct super_block *, struct vfsmount *,
-		      struct autofs_sb_info *,
-		      struct autofs_packet_expire __user *);
-int autofs_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
-			   struct autofs_sb_info *sbi, int when);
-int autofs_expire_multi(struct super_block *, struct vfsmount *,
-			struct autofs_sb_info *, int __user *);
-struct dentry *autofs_expire_direct(struct super_block *sb,
-				    struct vfsmount *mnt,
-				    struct autofs_sb_info *sbi, int how);
-struct dentry *autofs_expire_indirect(struct super_block *sb,
-				      struct vfsmount *mnt,
-				      struct autofs_sb_info *sbi, int how);
-
-/* Device node initialization */
-
-int autofs_dev_ioctl_init(void);
-void autofs_dev_ioctl_exit(void);
-
-/* Operations structures */
-
-extern const struct inode_operations autofs_symlink_inode_operations;
-extern const struct inode_operations autofs_dir_inode_operations;
-extern const struct file_operations autofs_dir_operations;
-extern const struct file_operations autofs_root_operations;
-extern const struct dentry_operations autofs_dentry_operations;
-
-/* VFS automount flags management functions */
-
-static inline void __managed_dentry_set_automount(struct dentry *dentry)
-{
-	dentry->d_flags |= DCACHE_NEED_AUTOMOUNT;
-}
-
-static inline void managed_dentry_set_automount(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_set_automount(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
-static inline void __managed_dentry_clear_automount(struct dentry *dentry)
-{
-	dentry->d_flags &= ~DCACHE_NEED_AUTOMOUNT;
-}
-
-static inline void managed_dentry_clear_automount(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_clear_automount(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
-static inline void __managed_dentry_set_transit(struct dentry *dentry)
-{
-	dentry->d_flags |= DCACHE_MANAGE_TRANSIT;
-}
-
-static inline void managed_dentry_set_transit(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_set_transit(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
-static inline void __managed_dentry_clear_transit(struct dentry *dentry)
-{
-	dentry->d_flags &= ~DCACHE_MANAGE_TRANSIT;
-}
-
-static inline void managed_dentry_clear_transit(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_clear_transit(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
-static inline void __managed_dentry_set_managed(struct dentry *dentry)
-{
-	dentry->d_flags |= (DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT);
-}
-
-static inline void managed_dentry_set_managed(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_set_managed(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
-static inline void __managed_dentry_clear_managed(struct dentry *dentry)
-{
-	dentry->d_flags &= ~(DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT);
-}
-
-static inline void managed_dentry_clear_managed(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_clear_managed(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
-/* Initializing function */
-
-int autofs_fill_super(struct super_block *, void *, int);
-struct autofs_info *autofs_new_ino(struct autofs_sb_info *);
-void autofs_clean_ino(struct autofs_info *);
-
-static inline int autofs_prepare_pipe(struct file *pipe)
-{
-	if (!pipe->f_op || !pipe->f_op->write)
-		return -EINVAL;
-	if (!S_ISFIFO(file_inode(pipe)->i_mode))
-		return -EINVAL;
-	/* We want a packet pipe */
-	pipe->f_flags |= O_DIRECT;
-	return 0;
-}
-
-/* Queue management functions */
-
-int autofs_wait(struct autofs_sb_info *,struct dentry *, enum autofs_notify);
-int autofs_wait_release(struct autofs_sb_info *,autofs_wqt_t,int);
-void autofs_catatonic_mode(struct autofs_sb_info *);
-
-static inline u32 autofs_get_dev(struct autofs_sb_info *sbi)
-{
-	return new_encode_dev(sbi->sb->s_dev);
-}
-
-static inline u64 autofs_get_ino(struct autofs_sb_info *sbi)
-{
-	return sbi->sb->s_root->d_inode->i_ino;
-}
-
-static inline int simple_positive(struct dentry *dentry)
-{
-	return dentry->d_inode && !d_unhashed(dentry);
-}
-
-static inline void __autofs_add_expiring(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
-	if (ino) {
-		if (list_empty(&ino->expiring))
-			list_add(&ino->expiring, &sbi->expiring_list);
-	}
-	return;
-}
-
-static inline void autofs_add_expiring(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
-	if (ino) {
-		spin_lock(&sbi->lookup_lock);
-		if (list_empty(&ino->expiring))
-			list_add(&ino->expiring, &sbi->expiring_list);
-		spin_unlock(&sbi->lookup_lock);
-	}
-	return;
-}
-
-static inline void autofs_del_expiring(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
-	if (ino) {
-		spin_lock(&sbi->lookup_lock);
-		if (!list_empty(&ino->expiring))
-			list_del_init(&ino->expiring);
-		spin_unlock(&sbi->lookup_lock);
-	}
-	return;
-}
-
-extern void autofs_kill_sb(struct super_block *);
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
deleted file mode 100644
index 024389a..0000000
--- a/fs/autofs4/dev-ioctl.c
+++ /dev/null
@@ -1,760 +0,0 @@
-/*
- * Copyright 2008 Red Hat, Inc. All rights reserved.
- * Copyright 2008 Ian Kent <raven@themaw.net>
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- */
-
-#include <linux/module.h>
-#include <linux/vmalloc.h>
-#include <linux/miscdevice.h>
-#include <linux/init.h>
-#include <linux/wait.h>
-#include <linux/namei.h>
-#include <linux/fcntl.h>
-#include <linux/file.h>
-#include <linux/fdtable.h>
-#include <linux/sched.h>
-#include <linux/compat.h>
-#include <linux/syscalls.h>
-#include <linux/magic.h>
-#include <linux/dcache.h>
-#include <linux/uaccess.h>
-#include <linux/slab.h>
-
-#include "autofs_i.h"
-
-/*
- * This module implements an interface for routing autofs ioctl control
- * commands via a miscellaneous device file.
- *
- * The alternate interface is needed because we need to be able open
- * an ioctl file descriptor on an autofs mount that may be covered by
- * another mount. This situation arises when starting automount(8)
- * or other user space daemon which uses direct mounts or offset
- * mounts (used for autofs lazy mount/umount of nested mount trees),
- * which have been left busy at at service shutdown.
- */
-
-#define AUTOFS_DEV_IOCTL_SIZE	sizeof(struct autofs_dev_ioctl)
-
-typedef int (*ioctl_fn)(struct file *, struct autofs_sb_info *,
-			struct autofs_dev_ioctl *);
-
-static int check_name(const char *name)
-{
-	if (!strchr(name, '/'))
-		return -EINVAL;
-	return 0;
-}
-
-/*
- * Check a string doesn't overrun the chunk of
- * memory we copied from user land.
- */
-static int invalid_str(char *str, size_t size)
-{
-	if (memchr(str, 0, size))
-		return 0;
-	return -EINVAL;
-}
-
-/*
- * Check that the user compiled against correct version of autofs
- * misc device code.
- *
- * As well as checking the version compatibility this always copies
- * the kernel interface version out.
- */
-static int check_dev_ioctl_version(int cmd, struct autofs_dev_ioctl *param)
-{
-	int err = 0;
-
-	if ((AUTOFS_DEV_IOCTL_VERSION_MAJOR != param->ver_major) ||
-	    (AUTOFS_DEV_IOCTL_VERSION_MINOR < param->ver_minor)) {
-		AUTOFS_WARN("ioctl control interface version mismatch: "
-		     "kernel(%u.%u), user(%u.%u), cmd(%d)",
-		     AUTOFS_DEV_IOCTL_VERSION_MAJOR,
-		     AUTOFS_DEV_IOCTL_VERSION_MINOR,
-		     param->ver_major, param->ver_minor, cmd);
-		err = -EINVAL;
-	}
-
-	/* Fill in the kernel version. */
-	param->ver_major = AUTOFS_DEV_IOCTL_VERSION_MAJOR;
-	param->ver_minor = AUTOFS_DEV_IOCTL_VERSION_MINOR;
-
-	return err;
-}
-
-/*
- * Copy parameter control struct, including a possible path allocated
- * at the end of the struct.
- */
-static struct autofs_dev_ioctl *copy_dev_ioctl(struct autofs_dev_ioctl __user *in)
-{
-	struct autofs_dev_ioctl tmp;
-
-	if (copy_from_user(&tmp, in, sizeof(tmp)))
-		return ERR_PTR(-EFAULT);
-
-	if (tmp.size < sizeof(tmp))
-		return ERR_PTR(-EINVAL);
-
-	return memdup_user(in, tmp.size);
-}
-
-static inline void free_dev_ioctl(struct autofs_dev_ioctl *param)
-{
-	kfree(param);
-	return;
-}
-
-/*
- * Check sanity of parameter control fields and if a path is present
- * check that it is terminated and contains at least one "/".
- */
-static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
-{
-	int err;
-
-	err = check_dev_ioctl_version(cmd, param);
-	if (err) {
-		AUTOFS_WARN("invalid device control module version "
-		     "supplied for cmd(0x%08x)", cmd);
-		goto out;
-	}
-
-	if (param->size > sizeof(*param)) {
-		err = invalid_str(param->path, param->size - sizeof(*param));
-		if (err) {
-			AUTOFS_WARN(
-			  "path string terminator missing for cmd(0x%08x)",
-			  cmd);
-			goto out;
-		}
-
-		err = check_name(param->path);
-		if (err) {
-			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
-				    cmd);
-			goto out;
-		}
-	}
-
-	err = 0;
-out:
-	return err;
-}
-
-/*
- * Get the autofs super block info struct from the file opened on
- * the autofs mount point.
- */
-static struct autofs_sb_info *autofs_dev_ioctl_sbi(struct file *f)
-{
-	struct autofs_sb_info *sbi = NULL;
-	struct inode *inode;
-
-	if (f) {
-		inode = file_inode(f);
-		sbi = autofs_sbi(inode->i_sb);
-	}
-	return sbi;
-}
-
-/* Return autofs module protocol version */
-static int autofs_dev_ioctl_protover(struct file *fp,
-				     struct autofs_sb_info *sbi,
-				     struct autofs_dev_ioctl *param)
-{
-	param->protover.version = sbi->version;
-	return 0;
-}
-
-/* Return autofs module protocol sub version */
-static int autofs_dev_ioctl_protosubver(struct file *fp,
-					struct autofs_sb_info *sbi,
-					struct autofs_dev_ioctl *param)
-{
-	param->protosubver.sub_version = sbi->sub_version;
-	return 0;
-}
-
-static int find_autofs_mount(const char *pathname,
-			     struct path *res,
-			     int test(struct path *path, void *data),
-			     void *data)
-{
-	struct path path;
-	int err = kern_path(pathname, 0, &path);
-	if (err)
-		return err;
-	err = -ENOENT;
-	while (path.dentry == path.mnt->mnt_root) {
-		if (path.dentry->d_sb->s_magic == AUTOFS_SUPER_MAGIC) {
-			if (test(&path, data)) {
-				path_get(&path);
-				if (!err) /* already found some */
-					path_put(res);
-				*res = path;
-				err = 0;
-			}
-		}
-		if (!follow_up(&path))
-			break;
-	}
-	path_put(&path);
-	return err;
-}
-
-static int test_by_dev(struct path *path, void *p)
-{
-	return path->dentry->d_sb->s_dev == *(dev_t *)p;
-}
-
-static int test_by_type(struct path *path, void *p)
-{
-	struct autofs_info *ino = autofs_dentry_ino(path->dentry);
-	return ino && ino->sbi->type & *(unsigned *)p;
-}
-
-/*
- * Open a file descriptor on the autofs mount point corresponding
- * to the given path and device number (aka. new_encode_dev(sb->s_dev)).
- */
-static int autofs_dev_ioctl_open_mountpoint(const char *name, dev_t devid)
-{
-	int err, fd;
-
-	fd = get_unused_fd_flags(O_CLOEXEC);
-	if (likely(fd >= 0)) {
-		struct file *filp;
-		struct path path;
-
-		err = find_autofs_mount(name, &path, test_by_dev, &devid);
-		if (err)
-			goto out;
-
-		/*
-		 * Find autofs super block that has the device number
-		 * corresponding to the autofs fs we want to open.
-		 */
-
-		filp = dentry_open(&path, O_RDONLY, current_cred());
-		path_put(&path);
-		if (IS_ERR(filp)) {
-			err = PTR_ERR(filp);
-			goto out;
-		}
-
-		fd_install(fd, filp);
-	}
-
-	return fd;
-
-out:
-	put_unused_fd(fd);
-	return err;
-}
-
-/* Open a file descriptor on an autofs mount point */
-static int autofs_dev_ioctl_openmount(struct file *fp,
-				      struct autofs_sb_info *sbi,
-				      struct autofs_dev_ioctl *param)
-{
-	const char *path;
-	dev_t devid;
-	int err, fd;
-
-	/* param->path has already been checked */
-	if (!param->openmount.devid)
-		return -EINVAL;
-
-	param->ioctlfd = -1;
-
-	path = param->path;
-	devid = new_decode_dev(param->openmount.devid);
-
-	err = 0;
-	fd = autofs_dev_ioctl_open_mountpoint(path, devid);
-	if (unlikely(fd < 0)) {
-		err = fd;
-		goto out;
-	}
-
-	param->ioctlfd = fd;
-out:
-	return err;
-}
-
-/* Close file descriptor allocated above (user can also use close(2)). */
-static int autofs_dev_ioctl_closemount(struct file *fp,
-				       struct autofs_sb_info *sbi,
-				       struct autofs_dev_ioctl *param)
-{
-	return sys_close(param->ioctlfd);
-}
-
-/*
- * Send "ready" status for an existing wait (either a mount or an expire
- * request).
- */
-static int autofs_dev_ioctl_ready(struct file *fp,
-				  struct autofs_sb_info *sbi,
-				  struct autofs_dev_ioctl *param)
-{
-	autofs_wqt_t token;
-
-	token = (autofs_wqt_t) param->ready.token;
-	return autofs_wait_release(sbi, token, 0);
-}
-
-/*
- * Send "fail" status for an existing wait (either a mount or an expire
- * request).
- */
-static int autofs_dev_ioctl_fail(struct file *fp,
-				 struct autofs_sb_info *sbi,
-				 struct autofs_dev_ioctl *param)
-{
-	autofs_wqt_t token;
-	int status;
-
-	token = (autofs_wqt_t) param->fail.token;
-	status = param->fail.status ? param->fail.status : -ENOENT;
-	return autofs_wait_release(sbi, token, status);
-}
-
-/*
- * Set the pipe fd for kernel communication to the daemon.
- *
- * Normally this is set at mount using an option but if we
- * are reconnecting to a busy mount then we need to use this
- * to tell the autofs mount about the new kernel pipe fd. In
- * order to protect mounts against incorrectly setting the
- * pipefd we also require that the autofs mount be catatonic.
- *
- * This also sets the process group id used to identify the
- * controlling process (eg. the owning automount(8) daemon).
- */
-static int autofs_dev_ioctl_setpipefd(struct file *fp,
-				      struct autofs_sb_info *sbi,
-				      struct autofs_dev_ioctl *param)
-{
-	int pipefd;
-	int err = 0;
-	struct pid *new_pid = NULL;
-
-	if (param->setpipefd.pipefd == -1)
-		return -EINVAL;
-
-	pipefd = param->setpipefd.pipefd;
-
-	mutex_lock(&sbi->wq_mutex);
-	if (!sbi->catatonic) {
-		mutex_unlock(&sbi->wq_mutex);
-		return -EBUSY;
-	} else {
-		struct file *pipe;
-
-		new_pid = get_task_pid(current, PIDTYPE_PGID);
-
-		if (ns_of_pid(new_pid) != ns_of_pid(sbi->oz_pgrp)) {
-			AUTOFS_WARN("Not allowed to change PID namespace");
-			err = -EINVAL;
-			goto out;
-		}
-
-		pipe = fget(pipefd);
-		if (!pipe) {
-			err = -EBADF;
-			goto out;
-		}
-		if (autofs_prepare_pipe(pipe) < 0) {
-			err = -EPIPE;
-			fput(pipe);
-			goto out;
-		}
-		swap(sbi->oz_pgrp, new_pid);
-		sbi->pipefd = pipefd;
-		sbi->pipe = pipe;
-		sbi->catatonic = 0;
-	}
-out:
-	put_pid(new_pid);
-	mutex_unlock(&sbi->wq_mutex);
-	return err;
-}
-
-/*
- * Make the autofs mount point catatonic, no longer responsive to
- * mount requests. Also closes the kernel pipe file descriptor.
- */
-static int autofs_dev_ioctl_catatonic(struct file *fp,
-				      struct autofs_sb_info *sbi,
-				      struct autofs_dev_ioctl *param)
-{
-	autofs_catatonic_mode(sbi);
-	return 0;
-}
-
-/* Set the autofs mount timeout */
-static int autofs_dev_ioctl_timeout(struct file *fp,
-				    struct autofs_sb_info *sbi,
-				    struct autofs_dev_ioctl *param)
-{
-	unsigned long timeout;
-
-	timeout = param->timeout.timeout;
-	param->timeout.timeout = sbi->exp_timeout / HZ;
-	sbi->exp_timeout = timeout * HZ;
-	return 0;
-}
-
-/*
- * Return the uid and gid of the last request for the mount
- *
- * When reconstructing an autofs mount tree with active mounts
- * we need to re-connect to mounts that may have used the original
- * process uid and gid (or string variations of them) for mount
- * lookups within the map entry.
- */
-static int autofs_dev_ioctl_requester(struct file *fp,
-				      struct autofs_sb_info *sbi,
-				      struct autofs_dev_ioctl *param)
-{
-	struct autofs_info *ino;
-	struct path path;
-	dev_t devid;
-	int err = -ENOENT;
-
-	if (param->size <= sizeof(*param)) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	devid = sbi->sb->s_dev;
-
-	param->requester.uid = param->requester.gid = -1;
-
-	err = find_autofs_mount(param->path, &path, test_by_dev, &devid);
-	if (err)
-		goto out;
-
-	ino = autofs_dentry_ino(path.dentry);
-	if (ino) {
-		err = 0;
-		autofs_expire_wait(path.dentry);
-		spin_lock(&sbi->fs_lock);
-		param->requester.uid = from_kuid_munged(current_user_ns(), ino->uid);
-		param->requester.gid = from_kgid_munged(current_user_ns(), ino->gid);
-		spin_unlock(&sbi->fs_lock);
-	}
-	path_put(&path);
-out:
-	return err;
-}
-
-/*
- * Call repeatedly until it returns -EAGAIN, meaning there's nothing
- * more that can be done.
- */
-static int autofs_dev_ioctl_expire(struct file *fp,
-				   struct autofs_sb_info *sbi,
-				   struct autofs_dev_ioctl *param)
-{
-	struct vfsmount *mnt;
-	int how;
-
-	how = param->expire.how;
-	mnt = fp->f_path.mnt;
-
-	return autofs_do_expire_multi(sbi->sb, mnt, sbi, how);
-}
-
-/* Check if autofs mount point is in use */
-static int autofs_dev_ioctl_askumount(struct file *fp,
-				      struct autofs_sb_info *sbi,
-				      struct autofs_dev_ioctl *param)
-{
-	param->askumount.may_umount = 0;
-	if (may_umount(fp->f_path.mnt))
-		param->askumount.may_umount = 1;
-	return 0;
-}
-
-/*
- * Check if the given path is a mountpoint.
- *
- * If we are supplied with the file descriptor of an autofs
- * mount we're looking for a specific mount. In this case
- * the path is considered a mountpoint if it is itself a
- * mountpoint or contains a mount, such as a multi-mount
- * without a root mount. In this case we return 1 if the
- * path is a mount point and the super magic of the covering
- * mount if there is one or 0 if it isn't a mountpoint.
- *
- * If we aren't supplied with a file descriptor then we
- * lookup the nameidata of the path and check if it is the
- * root of a mount. If a type is given we are looking for
- * a particular autofs mount and if we don't find a match
- * we return fail. If the located nameidata path is the
- * root of a mount we return 1 along with the super magic
- * of the mount or 0 otherwise.
- *
- * In both cases the the device number (as returned by
- * new_encode_dev()) is also returned.
- */
-static int autofs_dev_ioctl_ismountpoint(struct file *fp,
-					 struct autofs_sb_info *sbi,
-					 struct autofs_dev_ioctl *param)
-{
-	struct path path;
-	const char *name;
-	unsigned int type;
-	unsigned int devid, magic;
-	int err = -ENOENT;
-
-	if (param->size <= sizeof(*param)) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	name = param->path;
-	type = param->ismountpoint.in.type;
-
-	param->ismountpoint.out.devid = devid = 0;
-	param->ismountpoint.out.magic = magic = 0;
-
-	if (!fp || param->ioctlfd == -1) {
-		if (autofs_type_any(type))
-			err = kern_path(name, LOOKUP_FOLLOW, &path);
-		else
-			err = find_autofs_mount(name, &path, test_by_type, &type);
-		if (err)
-			goto out;
-		devid = new_encode_dev(path.dentry->d_sb->s_dev);
-		err = 0;
-		if (path.mnt->mnt_root == path.dentry) {
-			err = 1;
-			magic = path.dentry->d_sb->s_magic;
-		}
-	} else {
-		dev_t dev = sbi->sb->s_dev;
-
-		err = find_autofs_mount(name, &path, test_by_dev, &dev);
-		if (err)
-			goto out;
-
-		devid = new_encode_dev(dev);
-
-		err = have_submounts(path.dentry);
-
-		if (follow_down_one(&path))
-			magic = path.dentry->d_sb->s_magic;
-	}
-
-	param->ismountpoint.out.devid = devid;
-	param->ismountpoint.out.magic = magic;
-	path_put(&path);
-out:
-	return err;
-}
-
-/*
- * Our range of ioctl numbers isn't 0 based so we need to shift
- * the array index by _IOC_NR(AUTOFS_CTL_IOC_FIRST) for the table
- * lookup.
- */
-#define cmd_idx(cmd)	(cmd - _IOC_NR(AUTOFS_DEV_IOCTL_IOC_FIRST))
-
-static ioctl_fn lookup_dev_ioctl(unsigned int cmd)
-{
-	static struct {
-		int cmd;
-		ioctl_fn fn;
-	} _ioctls[] = {
-		{cmd_idx(AUTOFS_DEV_IOCTL_VERSION_CMD), NULL},
-		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOVER_CMD),
-			 autofs_dev_ioctl_protover},
-		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOSUBVER_CMD),
-			 autofs_dev_ioctl_protosubver},
-		{cmd_idx(AUTOFS_DEV_IOCTL_OPENMOUNT_CMD),
-			 autofs_dev_ioctl_openmount},
-		{cmd_idx(AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD),
-			 autofs_dev_ioctl_closemount},
-		{cmd_idx(AUTOFS_DEV_IOCTL_READY_CMD),
-			 autofs_dev_ioctl_ready},
-		{cmd_idx(AUTOFS_DEV_IOCTL_FAIL_CMD),
-			 autofs_dev_ioctl_fail},
-		{cmd_idx(AUTOFS_DEV_IOCTL_SETPIPEFD_CMD),
-			 autofs_dev_ioctl_setpipefd},
-		{cmd_idx(AUTOFS_DEV_IOCTL_CATATONIC_CMD),
-			 autofs_dev_ioctl_catatonic},
-		{cmd_idx(AUTOFS_DEV_IOCTL_TIMEOUT_CMD),
-			 autofs_dev_ioctl_timeout},
-		{cmd_idx(AUTOFS_DEV_IOCTL_REQUESTER_CMD),
-			 autofs_dev_ioctl_requester},
-		{cmd_idx(AUTOFS_DEV_IOCTL_EXPIRE_CMD),
-			 autofs_dev_ioctl_expire},
-		{cmd_idx(AUTOFS_DEV_IOCTL_ASKUMOUNT_CMD),
-			 autofs_dev_ioctl_askumount},
-		{cmd_idx(AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD),
-			 autofs_dev_ioctl_ismountpoint}
-	};
-	unsigned int idx = cmd_idx(cmd);
-
-	return (idx >= ARRAY_SIZE(_ioctls)) ? NULL : _ioctls[idx].fn;
-}
-
-/* ioctl dispatcher */
-static int _autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __user *user)
-{
-	struct autofs_dev_ioctl *param;
-	struct file *fp;
-	struct autofs_sb_info *sbi;
-	unsigned int cmd_first, cmd;
-	ioctl_fn fn = NULL;
-	int err = 0;
-
-	/* only root can play with this */
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	cmd_first = _IOC_NR(AUTOFS_DEV_IOCTL_IOC_FIRST);
-	cmd = _IOC_NR(command);
-
-	if (_IOC_TYPE(command) != _IOC_TYPE(AUTOFS_DEV_IOCTL_IOC_FIRST) ||
-	    cmd - cmd_first >= AUTOFS_DEV_IOCTL_IOC_COUNT) {
-		return -ENOTTY;
-	}
-
-	/* Copy the parameters into kernel space. */
-	param = copy_dev_ioctl(user);
-	if (IS_ERR(param))
-		return PTR_ERR(param);
-
-	err = validate_dev_ioctl(command, param);
-	if (err)
-		goto out;
-
-	/* The validate routine above always sets the version */
-	if (cmd == AUTOFS_DEV_IOCTL_VERSION_CMD)
-		goto done;
-
-	fn = lookup_dev_ioctl(cmd);
-	if (!fn) {
-		AUTOFS_WARN("unknown command 0x%08x", command);
-		return -ENOTTY;
-	}
-
-	fp = NULL;
-	sbi = NULL;
-
-	/*
-	 * For obvious reasons the openmount can't have a file
-	 * descriptor yet. We don't take a reference to the
-	 * file during close to allow for immediate release.
-	 */
-	if (cmd != AUTOFS_DEV_IOCTL_OPENMOUNT_CMD &&
-	    cmd != AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD) {
-		fp = fget(param->ioctlfd);
-		if (!fp) {
-			if (cmd == AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD)
-				goto cont;
-			err = -EBADF;
-			goto out;
-		}
-
-		if (!fp->f_op) {
-			err = -ENOTTY;
-			fput(fp);
-			goto out;
-		}
-
-		sbi = autofs_dev_ioctl_sbi(fp);
-		if (!sbi || sbi->magic != AUTOFS_SBI_MAGIC) {
-			err = -EINVAL;
-			fput(fp);
-			goto out;
-		}
-
-		/*
-		 * Admin needs to be able to set the mount catatonic in
-		 * order to be able to perform the re-open.
-		 */
-		if (!autofs_oz_mode(sbi) &&
-		    cmd != AUTOFS_DEV_IOCTL_CATATONIC_CMD) {
-			err = -EACCES;
-			fput(fp);
-			goto out;
-		}
-	}
-cont:
-	err = fn(fp, sbi, param);
-
-	if (fp)
-		fput(fp);
-done:
-	if (err >= 0 && copy_to_user(user, param, AUTOFS_DEV_IOCTL_SIZE))
-		err = -EFAULT;
-out:
-	free_dev_ioctl(param);
-	return err;
-}
-
-static long autofs_dev_ioctl(struct file *file, uint command, ulong u)
-{
-	int err;
-	err = _autofs_dev_ioctl(command, (struct autofs_dev_ioctl __user *) u);
-	return (long) err;
-}
-
-#ifdef CONFIG_COMPAT
-static long autofs_dev_ioctl_compat(struct file *file, uint command, ulong u)
-{
-	return (long) autofs_dev_ioctl(file, command, (ulong) compat_ptr(u));
-}
-#else
-#define autofs_dev_ioctl_compat NULL
-#endif
-
-static const struct file_operations _dev_ioctl_fops = {
-	.unlocked_ioctl	 = autofs_dev_ioctl,
-	.compat_ioctl = autofs_dev_ioctl_compat,
-	.owner	 = THIS_MODULE,
-	.llseek = noop_llseek,
-};
-
-static struct miscdevice _autofs_dev_ioctl_misc = {
-	.minor		= AUTOFS_MINOR,
-	.name  		= AUTOFS_DEVICE_NAME,
-	.fops  		= &_dev_ioctl_fops
-};
-
-MODULE_ALIAS_MISCDEV(AUTOFS_MINOR);
-MODULE_ALIAS("devname:autofs");
-
-/* Register/deregister misc character device */
-int autofs_dev_ioctl_init(void)
-{
-	int r;
-
-	r = misc_register(&_autofs_dev_ioctl_misc);
-	if (r) {
-		AUTOFS_ERROR("misc_register failed for control device");
-		return r;
-	}
-
-	return 0;
-}
-
-void autofs_dev_ioctl_exit(void)
-{
-	misc_deregister(&_autofs_dev_ioctl_misc);
-	return;
-}
-
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
deleted file mode 100644
index 58fba1b..0000000
--- a/fs/autofs4/expire.c
+++ /dev/null
@@ -1,562 +0,0 @@
-/*
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *  Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
- *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
-
-#include "autofs_i.h"
-
-static unsigned long now;
-
-/* Check if a dentry can be expired */
-static inline int autofs_can_expire(struct dentry *dentry,
-				    unsigned long timeout, int do_now)
-{
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
-
-	/* dentry in the process of being deleted */
-	if (ino == NULL)
-		return 0;
-
-	if (!do_now) {
-		/* Too young to die */
-		if (!timeout || time_after(ino->last_used + timeout, now))
-			return 0;
-
-		/* update last_used here :-
-		   - obviously makes sense if it is in use now
-		   - less obviously, prevents rapid-fire expire
-		     attempts if expire fails the first time */
-		ino->last_used = now;
-	}
-	return 1;
-}
-
-/* Check a mount point for busyness */
-static int autofs_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
-{
-	struct dentry *top = dentry;
-	struct path path = {.mnt = mnt, .dentry = dentry};
-	int status = 1;
-
-	DPRINTK("dentry %p %.*s",
-		dentry, (int)dentry->d_name.len, dentry->d_name.name);
-
-	path_get(&path);
-
-	if (!follow_down_one(&path))
-		goto done;
-
-	if (is_autofs_dentry(path.dentry)) {
-		struct autofs_sb_info *sbi = autofs_sbi(path.dentry->d_sb);
-
-		/* This is an autofs submount, we can't expire it */
-		if (autofs_type_indirect(sbi->type))
-			goto done;
-	}
-
-	/* Update the expiry counter if fs is busy */
-	if (!may_umount_tree(path.mnt)) {
-		struct autofs_info *ino = autofs_dentry_ino(top);
-		ino->last_used = jiffies;
-		goto done;
-	}
-
-	status = 0;
-done:
-	DPRINTK("returning = %d", status);
-	path_put(&path);
-	return status;
-}
-
-/*
- * Calculate and dget next entry in the subdirs list under root.
- */
-static struct dentry *get_next_positive_subdir(struct dentry *prev,
-					       struct dentry *root)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(root->d_sb);
-	struct list_head *next;
-	struct dentry *q;
-
-	spin_lock(&sbi->lookup_lock);
-	spin_lock(&root->d_lock);
-
-	if (prev)
-		next = prev->d_u.d_child.next;
-	else {
-		prev = dget_dlock(root);
-		next = prev->d_subdirs.next;
-	}
-
-cont:
-	if (next == &root->d_subdirs) {
-		spin_unlock(&root->d_lock);
-		spin_unlock(&sbi->lookup_lock);
-		dput(prev);
-		return NULL;
-	}
-
-	q = list_entry(next, struct dentry, d_u.d_child);
-
-	spin_lock_nested(&q->d_lock, DENTRY_D_LOCK_NESTED);
-	/* Already gone or negative dentry (under construction) - try next */
-	if (q->d_count == 0 || !simple_positive(q)) {
-		spin_unlock(&q->d_lock);
-		next = q->d_u.d_child.next;
-		goto cont;
-	}
-	dget_dlock(q);
-	spin_unlock(&q->d_lock);
-	spin_unlock(&root->d_lock);
-	spin_unlock(&sbi->lookup_lock);
-
-	dput(prev);
-
-	return q;
-}
-
-/*
- * Calculate and dget next entry in top down tree traversal.
- */
-static struct dentry *get_next_positive_dentry(struct dentry *prev,
-					       struct dentry *root)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(root->d_sb);
-	struct list_head *next;
-	struct dentry *p, *ret;
-
-	if (prev == NULL)
-		return dget(root);
-
-	spin_lock(&sbi->lookup_lock);
-relock:
-	p = prev;
-	spin_lock(&p->d_lock);
-again:
-	next = p->d_subdirs.next;
-	if (next == &p->d_subdirs) {
-		while (1) {
-			struct dentry *parent;
-
-			if (p == root) {
-				spin_unlock(&p->d_lock);
-				spin_unlock(&sbi->lookup_lock);
-				dput(prev);
-				return NULL;
-			}
-
-			parent = p->d_parent;
-			if (!spin_trylock(&parent->d_lock)) {
-				spin_unlock(&p->d_lock);
-				cpu_relax();
-				goto relock;
-			}
-			spin_unlock(&p->d_lock);
-			next = p->d_u.d_child.next;
-			p = parent;
-			if (next != &parent->d_subdirs)
-				break;
-		}
-	}
-	ret = list_entry(next, struct dentry, d_u.d_child);
-
-	spin_lock_nested(&ret->d_lock, DENTRY_D_LOCK_NESTED);
-	/* Negative dentry - try next */
-	if (!simple_positive(ret)) {
-		spin_unlock(&p->d_lock);
-		lock_set_subclass(&ret->d_lock.dep_map, 0, _RET_IP_);
-		p = ret;
-		goto again;
-	}
-	dget_dlock(ret);
-	spin_unlock(&ret->d_lock);
-	spin_unlock(&p->d_lock);
-	spin_unlock(&sbi->lookup_lock);
-
-	dput(prev);
-
-	return ret;
-}
-
-/*
- * Check a direct mount point for busyness.
- * Direct mounts have similar expiry semantics to tree mounts.
- * The tree is not busy iff no mountpoints are busy and there are no
- * autofs submounts.
- */
-static int autofs_direct_busy(struct vfsmount *mnt,
-			      struct dentry *top,
-			      unsigned long timeout,
-			      int do_now)
-{
-	DPRINTK("top %p %.*s",
-		top, (int) top->d_name.len, top->d_name.name);
-
-	/* If it's busy update the expiry counters */
-	if (!may_umount_tree(mnt)) {
-		struct autofs_info *ino = autofs_dentry_ino(top);
-		if (ino)
-			ino->last_used = jiffies;
-		return 1;
-	}
-
-	/* Timeout of a direct mount is determined by its top dentry */
-	if (!autofs_can_expire(top, timeout, do_now))
-		return 1;
-
-	return 0;
-}
-
-/*
- * Check a directory tree of mount points for busyness
- * The tree is not busy iff no mountpoints are busy
- */
-static int autofs_tree_busy(struct vfsmount *mnt,
-			    struct dentry *top,
-			    unsigned long timeout,
-			    int do_now)
-{
-	struct autofs_info *top_ino = autofs_dentry_ino(top);
-	struct dentry *p;
-
-	DPRINTK("top %p %.*s",
-		top, (int)top->d_name.len, top->d_name.name);
-
-	/* Negative dentry - give up */
-	if (!simple_positive(top))
-		return 1;
-
-	p = NULL;
-	while ((p = get_next_positive_dentry(p, top))) {
-		DPRINTK("dentry %p %.*s",
-			p, (int) p->d_name.len, p->d_name.name);
-
-		/*
-		 * Is someone visiting anywhere in the subtree ?
-		 * If there's no mount we need to check the usage
-		 * count for the autofs dentry.
-		 * If the fs is busy update the expiry counter.
-		 */
-		if (d_mountpoint(p)) {
-			if (autofs_mount_busy(mnt, p)) {
-				top_ino->last_used = jiffies;
-				dput(p);
-				return 1;
-			}
-		} else {
-			struct autofs_info *ino = autofs_dentry_ino(p);
-			unsigned int ino_count = atomic_read(&ino->count);
-
-			/*
-			 * Clean stale dentries below that have not been
-			 * invalidated after a mount fail during lookup
-			 */
-			d_invalidate(p);
-
-			/* allow for dget above and top is already dgot */
-			if (p == top)
-				ino_count += 2;
-			else
-				ino_count++;
-
-			if (p->d_count > ino_count) {
-				top_ino->last_used = jiffies;
-				dput(p);
-				return 1;
-			}
-		}
-	}
-
-	/* Timeout of a tree mount is ultimately determined by its top dentry */
-	if (!autofs_can_expire(top, timeout, do_now))
-		return 1;
-
-	return 0;
-}
-
-static struct dentry *autofs_check_leaves(struct vfsmount *mnt,
-					  struct dentry *parent,
-					  unsigned long timeout,
-					  int do_now)
-{
-	struct dentry *p;
-
-	DPRINTK("parent %p %.*s",
-		parent, (int)parent->d_name.len, parent->d_name.name);
-
-	p = NULL;
-	while ((p = get_next_positive_dentry(p, parent))) {
-		DPRINTK("dentry %p %.*s",
-			p, (int) p->d_name.len, p->d_name.name);
-
-		if (d_mountpoint(p)) {
-			/* Can we umount this guy */
-			if (autofs_mount_busy(mnt, p))
-				continue;
-
-			/* Can we expire this guy */
-			if (autofs_can_expire(p, timeout, do_now))
-				return p;
-		}
-	}
-	return NULL;
-}
-
-/* Check if we can expire a direct mount (possibly a tree) */
-struct dentry *autofs_expire_direct(struct super_block *sb,
-				    struct vfsmount *mnt,
-				    struct autofs_sb_info *sbi,
-				    int how)
-{
-	unsigned long timeout;
-	struct dentry *root = dget(sb->s_root);
-	int do_now = how & AUTOFS_EXP_IMMEDIATE;
-	struct autofs_info *ino;
-
-	if (!root)
-		return NULL;
-
-	now = jiffies;
-	timeout = sbi->exp_timeout;
-
-	spin_lock(&sbi->fs_lock);
-	ino = autofs_dentry_ino(root);
-	/* No point expiring a pending mount */
-	if (ino->flags & AUTOFS_INF_PENDING)
-		goto out;
-	if (!autofs_direct_busy(mnt, root, timeout, do_now)) {
-		struct autofs_info *ino = autofs_dentry_ino(root);
-		ino->flags |= AUTOFS_INF_EXPIRING;
-		init_completion(&ino->expire_complete);
-		spin_unlock(&sbi->fs_lock);
-		return root;
-	}
-out:
-	spin_unlock(&sbi->fs_lock);
-	dput(root);
-
-	return NULL;
-}
-
-/*
- * Find an eligible tree to time-out
- * A tree is eligible if :-
- *  - it is unused by any user process
- *  - it has been unused for exp_timeout time
- */
-struct dentry *autofs_expire_indirect(struct super_block *sb,
-				      struct vfsmount *mnt,
-				      struct autofs_sb_info *sbi,
-				      int how)
-{
-	unsigned long timeout;
-	struct dentry *root = sb->s_root;
-	struct dentry *dentry;
-	struct dentry *expired = NULL;
-	int do_now = how & AUTOFS_EXP_IMMEDIATE;
-	int exp_leaves = how & AUTOFS_EXP_LEAVES;
-	struct autofs_info *ino;
-	unsigned int ino_count;
-
-	if (!root)
-		return NULL;
-
-	now = jiffies;
-	timeout = sbi->exp_timeout;
-
-	dentry = NULL;
-	while ((dentry = get_next_positive_subdir(dentry, root))) {
-		spin_lock(&sbi->fs_lock);
-		ino = autofs_dentry_ino(dentry);
-		/* No point expiring a pending mount */
-		if (ino->flags & AUTOFS_INF_PENDING)
-			goto next;
-
-		/*
-		 * Case 1: (i) indirect mount or top level pseudo direct mount
-		 *	   (autofs-4.1).
-		 *	   (ii) indirect mount with offset mount, check the "/"
-		 *	   offset (autofs-5.0+).
-		 */
-		if (d_mountpoint(dentry)) {
-			DPRINTK("checking mountpoint %p %.*s", dentry,
-				(int)dentry->d_name.len, dentry->d_name.name);
-
-			/* Can we umount this guy */
-			if (autofs_mount_busy(mnt, dentry))
-				goto next;
-
-			/* Can we expire this guy */
-			if (autofs_can_expire(dentry, timeout, do_now)) {
-				expired = dentry;
-				goto found;
-			}
-			goto next;
-		}
-
-		if (simple_empty(dentry))
-			goto next;
-
-		/* Case 2: tree mount, expire iff entire tree is not busy */
-		if (!exp_leaves) {
-			/* Path walk currently on this dentry? */
-			ino_count = atomic_read(&ino->count) + 1;
-			if (dentry->d_count > ino_count)
-				goto next;
-
-			if (!autofs_tree_busy(mnt, dentry, timeout, do_now)) {
-				expired = dentry;
-				goto found;
-			}
-		/*
-		 * Case 3: pseudo direct mount, expire individual leaves
-		 *	   (autofs-4.1).
-		 */
-		} else {
-			/* Path walk currently on this dentry? */
-			ino_count = atomic_read(&ino->count) + 1;
-			if (dentry->d_count > ino_count)
-				goto next;
-
-			expired = autofs_check_leaves(mnt, dentry, timeout, do_now);
-			if (expired) {
-				dput(dentry);
-				goto found;
-			}
-		}
-next:
-		spin_unlock(&sbi->fs_lock);
-	}
-	return NULL;
-
-found:
-	DPRINTK("returning %p %.*s",
-		expired, (int)expired->d_name.len, expired->d_name.name);
-	ino = autofs_dentry_ino(expired);
-	ino->flags |= AUTOFS_INF_EXPIRING;
-	init_completion(&ino->expire_complete);
-	spin_unlock(&sbi->fs_lock);
-	spin_lock(&sbi->lookup_lock);
-	spin_lock(&expired->d_parent->d_lock);
-	spin_lock_nested(&expired->d_lock, DENTRY_D_LOCK_NESTED);
-	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
-	spin_unlock(&expired->d_lock);
-	spin_unlock(&expired->d_parent->d_lock);
-	spin_unlock(&sbi->lookup_lock);
-	return expired;
-}
-
-int autofs_expire_wait(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
-	int status;
-
-	/* Block on any pending expire */
-	spin_lock(&sbi->fs_lock);
-	if (ino->flags & AUTOFS_INF_EXPIRING) {
-		spin_unlock(&sbi->fs_lock);
-
-		DPRINTK("waiting for expire %p name=%.*s",
-			 dentry, dentry->d_name.len, dentry->d_name.name);
-
-		status = autofs_wait(sbi, dentry, NFY_NONE);
-		wait_for_completion(&ino->expire_complete);
-
-		DPRINTK("expire done status=%d", status);
-
-		if (d_unhashed(dentry))
-			return -EAGAIN;
-
-		return status;
-	}
-	spin_unlock(&sbi->fs_lock);
-
-	return 0;
-}
-
-/* Perform an expiry operation */
-int autofs_expire_run(struct super_block *sb,
-		      struct vfsmount *mnt,
-		      struct autofs_sb_info *sbi,
-		      struct autofs_packet_expire __user *pkt_p)
-{
-	struct autofs_packet_expire pkt;
-	struct autofs_info *ino;
-	struct dentry *dentry;
-	int ret = 0;
-
-	memset(&pkt,0,sizeof pkt);
-
-	pkt.hdr.proto_version = sbi->version;
-	pkt.hdr.type = autofs_ptype_expire;
-
-	if ((dentry = autofs_expire_indirect(sb, mnt, sbi, 0)) == NULL)
-		return -EAGAIN;
-
-	pkt.len = dentry->d_name.len;
-	memcpy(pkt.name, dentry->d_name.name, pkt.len);
-	pkt.name[pkt.len] = '\0';
-	dput(dentry);
-
-	if (copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)))
-		ret = -EFAULT;
-
-	spin_lock(&sbi->fs_lock);
-	ino = autofs_dentry_ino(dentry);
-	ino->flags &= ~AUTOFS_INF_EXPIRING;
-	complete_all(&ino->expire_complete);
-	spin_unlock(&sbi->fs_lock);
-
-	return ret;
-}
-
-int autofs_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
-			   struct autofs_sb_info *sbi, int when)
-{
-	struct dentry *dentry;
-	int ret = -EAGAIN;
-
-	if (autofs_type_trigger(sbi->type))
-		dentry = autofs_expire_direct(sb, mnt, sbi, when);
-	else
-		dentry = autofs_expire_indirect(sb, mnt, sbi, when);
-
-	if (dentry) {
-		struct autofs_info *ino = autofs_dentry_ino(dentry);
-
-		/* This is synchronous because it makes the daemon a
-                   little easier */
-		ret = autofs_wait(sbi, dentry, NFY_EXPIRE);
-
-		spin_lock(&sbi->fs_lock);
-		ino->flags &= ~AUTOFS_INF_EXPIRING;
-		complete_all(&ino->expire_complete);
-		spin_unlock(&sbi->fs_lock);
-		dput(dentry);
-	}
-
-	return ret;
-}
-
-/*
- * Call repeatedly until it returns -EAGAIN, meaning there's nothing
- * more to be done.
- */
-int autofs_expire_multi(struct super_block *sb, struct vfsmount *mnt,
-			struct autofs_sb_info *sbi, int __user *arg)
-{
-	int do_now = 0;
-
-	if (arg && get_user(do_now, arg))
-		return -EFAULT;
-
-	return autofs_do_expire_multi(sb, mnt, sbi, do_now);
-}
-
diff --git a/fs/autofs4/init.c b/fs/autofs4/init.c
deleted file mode 100644
index 51232a9..0000000
--- a/fs/autofs4/init.c
+++ /dev/null
@@ -1,49 +0,0 @@
-/*
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include "autofs_i.h"
-
-static struct dentry *autofs_mount(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data)
-{
-	return mount_nodev(fs_type, flags, data, autofs_fill_super);
-}
-
-static struct file_system_type autofs_fs_type = {
-	.owner		= THIS_MODULE,
-	.name		= "autofs",
-	.mount		= autofs_mount,
-	.kill_sb	= autofs_kill_sb,
-};
-MODULE_ALIAS_FS("autofs");
-
-static int __init init_autofs_fs(void)
-{
-	int err;
-
-	autofs_dev_ioctl_init();
-
-	err = register_filesystem(&autofs_fs_type);
-	if (err)
-		autofs_dev_ioctl_exit();
-
-	return err;
-}
-
-static void __exit exit_autofs_fs(void)
-{
-	autofs_dev_ioctl_exit();
-	unregister_filesystem(&autofs_fs_type);
-}
-
-module_init(init_autofs_fs)
-module_exit(exit_autofs_fs)
-MODULE_LICENSE("GPL");
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
deleted file mode 100644
index 543389c..0000000
--- a/fs/autofs4/inode.c
+++ /dev/null
@@ -1,368 +0,0 @@
-/*
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *  Copyright 2005-2006 Ian Kent <raven@themaw.net>
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
-
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/file.h>
-#include <linux/seq_file.h>
-#include <linux/pagemap.h>
-#include <linux/parser.h>
-#include <linux/bitops.h>
-#include <linux/magic.h>
-#include "autofs_i.h"
-#include <linux/module.h>
-
-struct autofs_info *autofs_new_ino(struct autofs_sb_info *sbi)
-{
-	struct autofs_info *ino = kzalloc(sizeof(*ino), GFP_KERNEL);
-	if (ino) {
-		INIT_LIST_HEAD(&ino->active);
-		INIT_LIST_HEAD(&ino->expiring);
-		ino->last_used = jiffies;
-		ino->sbi = sbi;
-	}
-	return ino;
-}
-
-void autofs_clean_ino(struct autofs_info *ino)
-{
-	ino->uid = GLOBAL_ROOT_UID;
-	ino->gid = GLOBAL_ROOT_GID;
-	ino->last_used = jiffies;
-}
-
-void autofs_free_ino(struct autofs_info *ino)
-{
-	kfree(ino);
-}
-
-void autofs_kill_sb(struct super_block *sb)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(sb);
-
-	/*
-	 * In the event of a failure in get_sb_nodev the superblock
-	 * info is not present so nothing else has been setup, so
-	 * just call kill_anon_super when we are called from
-	 * deactivate_super.
-	 */
-	if (!sbi)
-		goto out_kill_sb;
-
-	/* Free wait queues, close pipe */
-	autofs_catatonic_mode(sbi);
-
-	put_pid(sbi->oz_pgrp);
-
-	sb->s_fs_info = NULL;
-	kfree(sbi);
-
-out_kill_sb:
-	DPRINTK("shutting down");
-	kill_litter_super(sb);
-}
-
-static int autofs_show_options(struct seq_file *m, struct dentry *root)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(root->d_sb);
-	struct inode *root_inode = root->d_sb->s_root->d_inode;
-
-	if (!sbi)
-		return 0;
-
-	seq_printf(m, ",fd=%d", sbi->pipefd);
-	if (!uid_eq(root_inode->i_uid, GLOBAL_ROOT_UID))
-		seq_printf(m, ",uid=%u",
-			from_kuid_munged(&init_user_ns, root_inode->i_uid));
-	if (!gid_eq(root_inode->i_gid, GLOBAL_ROOT_GID))
-		seq_printf(m, ",gid=%u",
-			from_kgid_munged(&init_user_ns, root_inode->i_gid));
-	seq_printf(m, ",pgrp=%d", pid_vnr(sbi->oz_pgrp));
-	seq_printf(m, ",timeout=%lu", sbi->exp_timeout/HZ);
-	seq_printf(m, ",minproto=%d", sbi->min_proto);
-	seq_printf(m, ",maxproto=%d", sbi->max_proto);
-
-	if (autofs_type_offset(sbi->type))
-		seq_printf(m, ",offset");
-	else if (autofs_type_direct(sbi->type))
-		seq_printf(m, ",direct");
-	else
-		seq_printf(m, ",indirect");
-
-	return 0;
-}
-
-static void autofs_evict_inode(struct inode *inode)
-{
-	clear_inode(inode);
-	kfree(inode->i_private);
-}
-
-static const struct super_operations autofs_sops = {
-	.statfs		= simple_statfs,
-	.show_options	= autofs_show_options,
-	.evict_inode	= autofs_evict_inode,
-};
-
-enum {Opt_err, Opt_fd, Opt_uid, Opt_gid, Opt_pgrp, Opt_minproto, Opt_maxproto,
-	Opt_indirect, Opt_direct, Opt_offset};
-
-static const match_table_t tokens = {
-	{Opt_fd, "fd=%u"},
-	{Opt_uid, "uid=%u"},
-	{Opt_gid, "gid=%u"},
-	{Opt_pgrp, "pgrp=%u"},
-	{Opt_minproto, "minproto=%u"},
-	{Opt_maxproto, "maxproto=%u"},
-	{Opt_indirect, "indirect"},
-	{Opt_direct, "direct"},
-	{Opt_offset, "offset"},
-	{Opt_err, NULL}
-};
-
-static int parse_options(char *options, int *pipefd, kuid_t *uid, kgid_t *gid,
-			 int *pgrp, bool *pgrp_set, unsigned int *type,
-			 int *minproto, int *maxproto)
-{
-	char *p;
-	substring_t args[MAX_OPT_ARGS];
-	int option;
-
-	*uid = current_uid();
-	*gid = current_gid();
-
-	*minproto = AUTOFS_MIN_PROTO_VERSION;
-	*maxproto = AUTOFS_MAX_PROTO_VERSION;
-
-	*pipefd = -1;
-
-	if (!options)
-		return 1;
-
-	while ((p = strsep(&options, ",")) != NULL) {
-		int token;
-		if (!*p)
-			continue;
-
-		token = match_token(p, tokens, args);
-		switch (token) {
-		case Opt_fd:
-			if (match_int(args, pipefd))
-				return 1;
-			break;
-		case Opt_uid:
-			if (match_int(args, &option))
-				return 1;
-			*uid = make_kuid(current_user_ns(), option);
-			if (!uid_valid(*uid))
-				return 1;
-			break;
-		case Opt_gid:
-			if (match_int(args, &option))
-				return 1;
-			*gid = make_kgid(current_user_ns(), option);
-			if (!gid_valid(*gid))
-				return 1;
-			break;
-		case Opt_pgrp:
-			if (match_int(args, &option))
-				return 1;
-			*pgrp = option;
-			*pgrp_set = true;
-			break;
-		case Opt_minproto:
-			if (match_int(args, &option))
-				return 1;
-			*minproto = option;
-			break;
-		case Opt_maxproto:
-			if (match_int(args, &option))
-				return 1;
-			*maxproto = option;
-			break;
-		case Opt_indirect:
-			set_autofs_type_indirect(type);
-			break;
-		case Opt_direct:
-			set_autofs_type_direct(type);
-			break;
-		case Opt_offset:
-			set_autofs_type_offset(type);
-			break;
-		default:
-			return 1;
-		}
-	}
-	return (*pipefd < 0);
-}
-
-int autofs_fill_super(struct super_block *s, void *data, int silent)
-{
-	struct inode * root_inode;
-	struct dentry * root;
-	struct file * pipe;
-	int pipefd;
-	struct autofs_sb_info *sbi;
-	struct autofs_info *ino;
-	int pgrp;
-	bool pgrp_set = false;
-
-	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi)
-		goto fail_unlock;
-	DPRINTK("starting up, sbi = %p",sbi);
-
-	s->s_fs_info = sbi;
-	sbi->magic = AUTOFS_SBI_MAGIC;
-	sbi->pipefd = -1;
-	sbi->pipe = NULL;
-	sbi->catatonic = 1;
-	sbi->exp_timeout = 0;
-	sbi->oz_pgrp = NULL;
-	sbi->sb = s;
-	sbi->version = 0;
-	sbi->sub_version = 0;
-	set_autofs_type_indirect(&sbi->type);
-	sbi->min_proto = 0;
-	sbi->max_proto = 0;
-	mutex_init(&sbi->wq_mutex);
-	mutex_init(&sbi->pipe_mutex);
-	spin_lock_init(&sbi->fs_lock);
-	sbi->queues = NULL;
-	spin_lock_init(&sbi->lookup_lock);
-	INIT_LIST_HEAD(&sbi->active_list);
-	INIT_LIST_HEAD(&sbi->expiring_list);
-	s->s_blocksize = 1024;
-	s->s_blocksize_bits = 10;
-	s->s_magic = AUTOFS_SUPER_MAGIC;
-	s->s_op = &autofs_sops;
-	s->s_d_op = &autofs_dentry_operations;
-	s->s_time_gran = 1;
-
-	/*
-	 * Get the root inode and dentry, but defer checking for errors.
-	 */
-	ino = autofs_new_ino(sbi);
-	if (!ino)
-		goto fail_free;
-	root_inode = autofs_get_inode(s, S_IFDIR | 0755);
-	root = d_make_root(root_inode);
-	if (!root)
-		goto fail_ino;
-	pipe = NULL;
-
-	root->d_fsdata = ino;
-
-	/* Can this call block? */
-	if (parse_options(data, &pipefd, &root_inode->i_uid, &root_inode->i_gid,
-			  &pgrp, &pgrp_set, &sbi->type, &sbi->min_proto,
-			  &sbi->max_proto)) {
-		printk("autofs: called with bogus options\n");
-		goto fail_dput;
-	}
-
-	if (pgrp_set) {
-		sbi->oz_pgrp = find_get_pid(pgrp);
-		if (!sbi->oz_pgrp) {
-			pr_warn("autofs: could not find process group %d\n",
-				pgrp);
-			goto fail_dput;
-		}
-	} else {
-		sbi->oz_pgrp = get_task_pid(current, PIDTYPE_PGID);
-	}
-
-	if (autofs_type_trigger(sbi->type))
-		__managed_dentry_set_managed(root);
-
-	root_inode->i_fop = &autofs_root_operations;
-	root_inode->i_op = &autofs_dir_inode_operations;
-
-	/* Couldn't this be tested earlier? */
-	if (sbi->max_proto < AUTOFS_MIN_PROTO_VERSION ||
-	    sbi->min_proto > AUTOFS_MAX_PROTO_VERSION) {
-		printk("autofs: kernel does not match daemon version "
-		       "daemon (%d, %d) kernel (%d, %d)\n",
-			sbi->min_proto, sbi->max_proto,
-			AUTOFS_MIN_PROTO_VERSION, AUTOFS_MAX_PROTO_VERSION);
-		goto fail_dput;
-	}
-
-	/* Establish highest kernel protocol version */
-	if (sbi->max_proto > AUTOFS_MAX_PROTO_VERSION)
-		sbi->version = AUTOFS_MAX_PROTO_VERSION;
-	else
-		sbi->version = sbi->max_proto;
-	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;
-
-	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, pid_nr(sbi->oz_pgrp));
-	pipe = fget(pipefd);
-
-	if (!pipe) {
-		printk("autofs: could not open pipe file descriptor\n");
-		goto fail_dput;
-	}
-	if (autofs_prepare_pipe(pipe) < 0)
-		goto fail_fput;
-	sbi->pipe = pipe;
-	sbi->pipefd = pipefd;
-	sbi->catatonic = 0;
-
-	/*
-	 * Success! Install the root dentry now to indicate completion.
-	 */
-	s->s_root = root;
-	return 0;
-	
-	/*
-	 * Failure ... clean up.
-	 */
-fail_fput:
-	printk("autofs: pipe file descriptor does not contain proper ops\n");
-	fput(pipe);
-	/* fall through */
-fail_dput:
-	dput(root);
-	goto fail_free;
-fail_ino:
-	kfree(ino);
-fail_free:
-	put_pid(sbi->oz_pgrp);
-	kfree(sbi);
-	s->s_fs_info = NULL;
-fail_unlock:
-	return -EINVAL;
-}
-
-struct inode *autofs_get_inode(struct super_block *sb, umode_t mode)
-{
-	struct inode *inode = new_inode(sb);
-
-	if (inode == NULL)
-		return NULL;
-
-	inode->i_mode = mode;
-	if (sb->s_root) {
-		inode->i_uid = sb->s_root->d_inode->i_uid;
-		inode->i_gid = sb->s_root->d_inode->i_gid;
-	}
-	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-	inode->i_ino = get_next_ino();
-
-	if (S_ISDIR(mode)) {
-		set_nlink(inode, 2);
-		inode->i_op = &autofs_dir_inode_operations;
-		inode->i_fop = &autofs_dir_operations;
-	} else if (S_ISLNK(mode)) {
-		inode->i_op = &autofs_symlink_inode_operations;
-	}
-
-	return inode;
-}
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
deleted file mode 100644
index 4b64d07..0000000
--- a/fs/autofs4/root.c
+++ /dev/null
@@ -1,898 +0,0 @@
-/*
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *  Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
- *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
-
-#include <linux/capability.h>
-#include <linux/errno.h>
-#include <linux/stat.h>
-#include <linux/slab.h>
-#include <linux/param.h>
-#include <linux/time.h>
-#include <linux/compat.h>
-#include <linux/mutex.h>
-
-#include "autofs_i.h"
-
-static int autofs_dir_symlink(struct inode *,struct dentry *,const char *);
-static int autofs_dir_unlink(struct inode *,struct dentry *);
-static int autofs_dir_rmdir(struct inode *,struct dentry *);
-static int autofs_dir_mkdir(struct inode *,struct dentry *,umode_t);
-static long autofs_root_ioctl(struct file *,unsigned int,unsigned long);
-#ifdef CONFIG_COMPAT
-static long autofs_root_compat_ioctl(struct file *,unsigned int,unsigned long);
-#endif
-static int autofs_dir_open(struct inode *inode, struct file *file);
-static struct dentry *autofs_lookup(struct inode *,struct dentry *, unsigned int);
-static struct vfsmount *autofs_d_automount(struct path *);
-static int autofs_d_manage(struct dentry *, bool);
-static void autofs_dentry_release(struct dentry *);
-
-const struct file_operations autofs_root_operations = {
-	.open		= dcache_dir_open,
-	.release	= dcache_dir_close,
-	.read		= generic_read_dir,
-	.iterate	= dcache_readdir,
-	.llseek		= dcache_dir_lseek,
-	.unlocked_ioctl	= autofs_root_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= autofs_root_compat_ioctl,
-#endif
-};
-
-const struct file_operations autofs_dir_operations = {
-	.open		= autofs_dir_open,
-	.release	= dcache_dir_close,
-	.read		= generic_read_dir,
-	.iterate	= dcache_readdir,
-	.llseek		= dcache_dir_lseek,
-};
-
-const struct inode_operations autofs_dir_inode_operations = {
-	.lookup		= autofs_lookup,
-	.unlink		= autofs_dir_unlink,
-	.symlink	= autofs_dir_symlink,
-	.mkdir		= autofs_dir_mkdir,
-	.rmdir		= autofs_dir_rmdir,
-};
-
-const struct dentry_operations autofs_dentry_operations = {
-	.d_automount	= autofs_d_automount,
-	.d_manage	= autofs_d_manage,
-	.d_release	= autofs_dentry_release,
-};
-
-static void autofs_add_active(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
-	if (ino) {
-		spin_lock(&sbi->lookup_lock);
-		if (!ino->active_count) {
-			if (list_empty(&ino->active))
-				list_add(&ino->active, &sbi->active_list);
-		}
-		ino->active_count++;
-		spin_unlock(&sbi->lookup_lock);
-	}
-	return;
-}
-
-static void autofs_del_active(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
-	if (ino) {
-		spin_lock(&sbi->lookup_lock);
-		ino->active_count--;
-		if (!ino->active_count) {
-			if (!list_empty(&ino->active))
-				list_del_init(&ino->active);
-		}
-		spin_unlock(&sbi->lookup_lock);
-	}
-	return;
-}
-
-static int autofs_dir_open(struct inode *inode, struct file *file)
-{
-	struct dentry *dentry = file->f_path.dentry;
-	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
-
-	DPRINTK("file=%p dentry=%p %.*s",
-		file, dentry, dentry->d_name.len, dentry->d_name.name);
-
-	if (autofs_oz_mode(sbi))
-		goto out;
-
-	/*
-	 * An empty directory in an autofs file system is always a
-	 * mount point. The daemon must have failed to mount this
-	 * during lookup so it doesn't exist. This can happen, for
-	 * example, if user space returns an incorrect status for a
-	 * mount request. Otherwise we're doing a readdir on the
-	 * autofs file system so just let the libfs routines handle
-	 * it.
-	 */
-	spin_lock(&sbi->lookup_lock);
-	if (!d_mountpoint(dentry) && simple_empty(dentry)) {
-		spin_unlock(&sbi->lookup_lock);
-		return -ENOENT;
-	}
-	spin_unlock(&sbi->lookup_lock);
-
-out:
-	return dcache_dir_open(inode, file);
-}
-
-static void autofs_dentry_release(struct dentry *de)
-{
-	struct autofs_info *ino = autofs_dentry_ino(de);
-	struct autofs_sb_info *sbi = autofs_sbi(de->d_sb);
-
-	DPRINTK("releasing %p", de);
-
-	if (!ino)
-		return;
-
-	if (sbi) {
-		spin_lock(&sbi->lookup_lock);
-		if (!list_empty(&ino->active))
-			list_del(&ino->active);
-		if (!list_empty(&ino->expiring))
-			list_del(&ino->expiring);
-		spin_unlock(&sbi->lookup_lock);
-	}
-
-	autofs_free_ino(ino);
-}
-
-static struct dentry *autofs_lookup_active(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
-	struct dentry *parent = dentry->d_parent;
-	struct qstr *name = &dentry->d_name;
-	unsigned int len = name->len;
-	unsigned int hash = name->hash;
-	const unsigned char *str = name->name;
-	struct list_head *p, *head;
-
-	spin_lock(&sbi->lookup_lock);
-	head = &sbi->active_list;
-	list_for_each(p, head) {
-		struct autofs_info *ino;
-		struct dentry *active;
-		struct qstr *qstr;
-
-		ino = list_entry(p, struct autofs_info, active);
-		active = ino->dentry;
-
-		spin_lock(&active->d_lock);
-
-		/* Already gone? */
-		if (active->d_count == 0)
-			goto next;
-
-		qstr = &active->d_name;
-
-		if (active->d_name.hash != hash)
-			goto next;
-		if (active->d_parent != parent)
-			goto next;
-
-		if (qstr->len != len)
-			goto next;
-		if (memcmp(qstr->name, str, len))
-			goto next;
-
-		if (d_unhashed(active)) {
-			dget_dlock(active);
-			spin_unlock(&active->d_lock);
-			spin_unlock(&sbi->lookup_lock);
-			return active;
-		}
-next:
-		spin_unlock(&active->d_lock);
-	}
-	spin_unlock(&sbi->lookup_lock);
-
-	return NULL;
-}
-
-static struct dentry *autofs_lookup_expiring(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
-	struct dentry *parent = dentry->d_parent;
-	struct qstr *name = &dentry->d_name;
-	unsigned int len = name->len;
-	unsigned int hash = name->hash;
-	const unsigned char *str = name->name;
-	struct list_head *p, *head;
-
-	spin_lock(&sbi->lookup_lock);
-	head = &sbi->expiring_list;
-	list_for_each(p, head) {
-		struct autofs_info *ino;
-		struct dentry *expiring;
-		struct qstr *qstr;
-
-		ino = list_entry(p, struct autofs_info, expiring);
-		expiring = ino->dentry;
-
-		spin_lock(&expiring->d_lock);
-
-		/* Bad luck, we've already been dentry_iput */
-		if (!expiring->d_inode)
-			goto next;
-
-		qstr = &expiring->d_name;
-
-		if (expiring->d_name.hash != hash)
-			goto next;
-		if (expiring->d_parent != parent)
-			goto next;
-
-		if (qstr->len != len)
-			goto next;
-		if (memcmp(qstr->name, str, len))
-			goto next;
-
-		if (d_unhashed(expiring)) {
-			dget_dlock(expiring);
-			spin_unlock(&expiring->d_lock);
-			spin_unlock(&sbi->lookup_lock);
-			return expiring;
-		}
-next:
-		spin_unlock(&expiring->d_lock);
-	}
-	spin_unlock(&sbi->lookup_lock);
-
-	return NULL;
-}
-
-static int autofs_mount_wait(struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
-	int status = 0;
-
-	if (ino->flags & AUTOFS_INF_PENDING) {
-		DPRINTK("waiting for mount name=%.*s",
-			dentry->d_name.len, dentry->d_name.name);
-		status = autofs_wait(sbi, dentry, NFY_MOUNT);
-		DPRINTK("mount wait done status=%d", status);
-	}
-	ino->last_used = jiffies;
-	return status;
-}
-
-static int do_expire_wait(struct dentry *dentry)
-{
-	struct dentry *expiring;
-
-	expiring = autofs_lookup_expiring(dentry);
-	if (!expiring)
-		return autofs_expire_wait(dentry);
-	else {
-		/*
-		 * If we are racing with expire the request might not
-		 * be quite complete, but the directory has been removed
-		 * so it must have been successful, just wait for it.
-		 */
-		autofs_expire_wait(expiring);
-		autofs_del_expiring(expiring);
-		dput(expiring);
-	}
-	return 0;
-}
-
-static struct dentry *autofs_mountpoint_changed(struct path *path)
-{
-	struct dentry *dentry = path->dentry;
-	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
-
-	/*
-	 * If this is an indirect mount the dentry could have gone away
-	 * as a result of an expire and a new one created.
-	 */
-	if (autofs_type_indirect(sbi->type) && d_unhashed(dentry)) {
-		struct dentry *parent = dentry->d_parent;
-		struct autofs_info *ino;
-		struct dentry *new = d_lookup(parent, &dentry->d_name);
-		if (!new)
-			return NULL;
-		ino = autofs_dentry_ino(new);
-		ino->last_used = jiffies;
-		dput(path->dentry);
-		path->dentry = new;
-	}
-	return path->dentry;
-}
-
-static struct vfsmount *autofs_d_automount(struct path *path)
-{
-	struct dentry *dentry = path->dentry;
-	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
-	int status;
-
-	DPRINTK("dentry=%p %.*s",
-		dentry, dentry->d_name.len, dentry->d_name.name);
-
-	/* The daemon never triggers a mount. */
-	if (autofs_oz_mode(sbi))
-		return NULL;
-
-	/*
-	 * If an expire request is pending everyone must wait.
-	 * If the expire fails we're still mounted so continue
-	 * the follow and return. A return of -EAGAIN (which only
-	 * happens with indirect mounts) means the expire completed
-	 * and the directory was removed, so just go ahead and try
-	 * the mount.
-	 */
-	status = do_expire_wait(dentry);
-	if (status && status != -EAGAIN)
-		return NULL;
-
-	/* Callback to the daemon to perform the mount or wait */
-	spin_lock(&sbi->fs_lock);
-	if (ino->flags & AUTOFS_INF_PENDING) {
-		spin_unlock(&sbi->fs_lock);
-		status = autofs_mount_wait(dentry);
-		if (status)
-			return ERR_PTR(status);
-		goto done;
-	}
-
-	/*
-	 * If the dentry is a symlink it's equivalent to a directory
-	 * having d_mountpoint() true, so there's no need to call back
-	 * to the daemon.
-	 */
-	if (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)) {
-		spin_unlock(&sbi->fs_lock);
-		goto done;
-	}
-
-	if (!d_mountpoint(dentry)) {
-		/*
-		 * It's possible that user space hasn't removed directories
-		 * after umounting a rootless multi-mount, although it
-		 * should. For v5 have_submounts() is sufficient to handle
-		 * this because the leaves of the directory tree under the
-		 * mount never trigger mounts themselves (they have an autofs
-		 * trigger mount mounted on them). But v4 pseudo direct mounts
-		 * do need the leaves to to trigger mounts. In this case we
-		 * have no choice but to use the list_empty() check and
-		 * require user space behave.
-		 */
-		if (sbi->version > 4) {
-			if (have_submounts(dentry)) {
-				spin_unlock(&sbi->fs_lock);
-				goto done;
-			}
-		} else {
-			if (!simple_empty(dentry)) {
-				spin_unlock(&sbi->fs_lock);
-				goto done;
-			}
-		}
-		ino->flags |= AUTOFS_INF_PENDING;
-		spin_unlock(&sbi->fs_lock);
-		status = autofs_mount_wait(dentry);
-		spin_lock(&sbi->fs_lock);
-		ino->flags &= ~AUTOFS_INF_PENDING;
-		if (status) {
-			spin_unlock(&sbi->fs_lock);
-			return ERR_PTR(status);
-		}
-	}
-	spin_unlock(&sbi->fs_lock);
-done:
-	/* Mount succeeded, check if we ended up with a new dentry */
-	dentry = autofs_mountpoint_changed(path);
-	if (!dentry)
-		return ERR_PTR(-ENOENT);
-
-	return NULL;
-}
-
-static int autofs_d_manage(struct dentry *dentry, bool rcu_walk)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
-	int status;
-
-	DPRINTK("dentry=%p %.*s",
-		dentry, dentry->d_name.len, dentry->d_name.name);
-
-	/* The daemon never waits. */
-	if (autofs_oz_mode(sbi)) {
-		if (rcu_walk)
-			return 0;
-		if (!d_mountpoint(dentry))
-			return -EISDIR;
-		return 0;
-	}
-
-	/* We need to sleep, so we need pathwalk to be in ref-mode */
-	if (rcu_walk)
-		return -ECHILD;
-
-	/* Wait for pending expires */
-	do_expire_wait(dentry);
-
-	/*
-	 * This dentry may be under construction so wait on mount
-	 * completion.
-	 */
-	status = autofs_mount_wait(dentry);
-	if (status)
-		return status;
-
-	spin_lock(&sbi->fs_lock);
-	/*
-	 * If the dentry has been selected for expire while we slept
-	 * on the lock then it might go away. We'll deal with that in
-	 * ->d_automount() and wait on a new mount if the expire
-	 * succeeds or return here if it doesn't (since there's no
-	 * mount to follow with a rootless multi-mount).
-	 */
-	if (!(ino->flags & AUTOFS_INF_EXPIRING)) {
-		/*
-		 * Any needed mounting has been completed and the path
-		 * updated so check if this is a rootless multi-mount so
-		 * we can avoid needless calls ->d_automount() and avoid
-		 * an incorrect ELOOP error return.
-		 */
-		if ((!d_mountpoint(dentry) && !simple_empty(dentry)) ||
-		    (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)))
-			status = -EISDIR;
-	}
-	spin_unlock(&sbi->fs_lock);
-
-	return status;
-}
-
-/* Lookups in the root directory */
-static struct dentry *autofs_lookup(struct inode *dir,
-				     struct dentry *dentry, unsigned int flags)
-{
-	struct autofs_sb_info *sbi;
-	struct autofs_info *ino;
-	struct dentry *active;
-
-	DPRINTK("name = %.*s", dentry->d_name.len, dentry->d_name.name);
-
-	/* File name too long to exist */
-	if (dentry->d_name.len > NAME_MAX)
-		return ERR_PTR(-ENAMETOOLONG);
-
-	sbi = autofs_sbi(dir->i_sb);
-
-	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
-		current->pid, task_pgrp_nr(current), sbi->catatonic,
-		autofs_oz_mode(sbi));
-
-	active = autofs_lookup_active(dentry);
-	if (active) {
-		return active;
-	} else {
-		/*
-		 * A dentry that is not within the root can never trigger a
-		 * mount operation, unless the directory already exists, so we
-		 * can return fail immediately.  The daemon however does need
-		 * to create directories within the file system.
-		 */
-		if (!autofs_oz_mode(sbi) && !IS_ROOT(dentry->d_parent))
-			return ERR_PTR(-ENOENT);
-
-		/* Mark entries in the root as mount triggers */
-		if (autofs_type_indirect(sbi->type) && IS_ROOT(dentry->d_parent))
-			__managed_dentry_set_managed(dentry);
-
-		ino = autofs_new_ino(sbi);
-		if (!ino)
-			return ERR_PTR(-ENOMEM);
-
-		dentry->d_fsdata = ino;
-		ino->dentry = dentry;
-
-		autofs_add_active(dentry);
-
-		d_instantiate(dentry, NULL);
-	}
-	return NULL;
-}
-
-static int autofs_dir_symlink(struct inode *dir,
-			       struct dentry *dentry,
-			       const char *symname)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
-	struct autofs_info *p_ino;
-	struct inode *inode;
-	size_t size = strlen(symname);
-	char *cp;
-
-	DPRINTK("%s <- %.*s", symname,
-		dentry->d_name.len, dentry->d_name.name);
-
-	if (!autofs_oz_mode(sbi))
-		return -EACCES;
-
-	BUG_ON(!ino);
-
-	autofs_clean_ino(ino);
-
-	autofs_del_active(dentry);
-
-	cp = kmalloc(size + 1, GFP_KERNEL);
-	if (!cp)
-		return -ENOMEM;
-
-	strcpy(cp, symname);
-
-	inode = autofs_get_inode(dir->i_sb, S_IFLNK | 0555);
-	if (!inode) {
-		kfree(cp);
-		if (!dentry->d_fsdata)
-			kfree(ino);
-		return -ENOMEM;
-	}
-	inode->i_private = cp;
-	inode->i_size = size;
-	d_add(dentry, inode);
-
-	dget(dentry);
-	atomic_inc(&ino->count);
-	p_ino = autofs_dentry_ino(dentry->d_parent);
-	if (p_ino && dentry->d_parent != dentry)
-		atomic_inc(&p_ino->count);
-
-	dir->i_mtime = CURRENT_TIME;
-
-	return 0;
-}
-
-/*
- * NOTE!
- *
- * Normal filesystems would do a "d_delete()" to tell the VFS dcache
- * that the file no longer exists. However, doing that means that the
- * VFS layer can turn the dentry into a negative dentry.  We don't want
- * this, because the unlink is probably the result of an expire.
- * We simply d_drop it and add it to a expiring list in the super block,
- * which allows the dentry lookup to check for an incomplete expire.
- *
- * If a process is blocked on the dentry waiting for the expire to finish,
- * it will invalidate the dentry and try to mount with a new one.
- *
- * Also see autofs_dir_rmdir()..
- */
-static int autofs_dir_unlink(struct inode *dir, struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
-	struct autofs_info *p_ino;
-	
-	/* This allows root to remove symlinks */
-	if (!autofs_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	if (atomic_dec_and_test(&ino->count)) {
-		p_ino = autofs_dentry_ino(dentry->d_parent);
-		if (p_ino && dentry->d_parent != dentry)
-			atomic_dec(&p_ino->count);
-	}
-	dput(ino->dentry);
-
-	dentry->d_inode->i_size = 0;
-	clear_nlink(dentry->d_inode);
-
-	dir->i_mtime = CURRENT_TIME;
-
-	spin_lock(&sbi->lookup_lock);
-	__autofs_add_expiring(dentry);
-	d_drop(dentry);
-	spin_unlock(&sbi->lookup_lock);
-
-	return 0;
-}
-
-/*
- * Version 4 of autofs provides a pseudo direct mount implementation
- * that relies on directories at the leaves of a directory tree under
- * an indirect mount to trigger mounts. To allow for this we need to
- * set the DMANAGED_AUTOMOUNT and DMANAGED_TRANSIT flags on the leaves
- * of the directory tree. There is no need to clear the automount flag
- * following a mount or restore it after an expire because these mounts
- * are always covered. However, it is necessary to ensure that these
- * flags are clear on non-empty directories to avoid unnecessary calls
- * during path walks.
- */
-static void autofs_set_leaf_automount_flags(struct dentry *dentry)
-{
-	struct dentry *parent;
-
-	/* root and dentrys in the root are already handled */
-	if (IS_ROOT(dentry->d_parent))
-		return;
-
-	managed_dentry_set_managed(dentry);
-
-	parent = dentry->d_parent;
-	/* only consider parents below dentrys in the root */
-	if (IS_ROOT(parent->d_parent))
-		return;
-	managed_dentry_clear_managed(parent);
-	return;
-}
-
-static void autofs_clear_leaf_automount_flags(struct dentry *dentry)
-{
-	struct list_head *d_child;
-	struct dentry *parent;
-
-	/* flags for dentrys in the root are handled elsewhere */
-	if (IS_ROOT(dentry->d_parent))
-		return;
-
-	managed_dentry_clear_managed(dentry);
-
-	parent = dentry->d_parent;
-	/* only consider parents below dentrys in the root */
-	if (IS_ROOT(parent->d_parent))
-		return;
-	d_child = &dentry->d_u.d_child;
-	/* Set parent managed if it's becoming empty */
-	if (d_child->next == &parent->d_subdirs &&
-	    d_child->prev == &parent->d_subdirs)
-		managed_dentry_set_managed(parent);
-	return;
-}
-
-static int autofs_dir_rmdir(struct inode *dir, struct dentry *dentry)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
-	struct autofs_info *p_ino;
-	
-	DPRINTK("dentry %p, removing %.*s",
-		dentry, dentry->d_name.len, dentry->d_name.name);
-
-	if (!autofs_oz_mode(sbi))
-		return -EACCES;
-
-	spin_lock(&sbi->lookup_lock);
-	if (!simple_empty(dentry)) {
-		spin_unlock(&sbi->lookup_lock);
-		return -ENOTEMPTY;
-	}
-	__autofs_add_expiring(dentry);
-	d_drop(dentry);
-	spin_unlock(&sbi->lookup_lock);
-
-	if (sbi->version < 5)
-		autofs_clear_leaf_automount_flags(dentry);
-
-	if (atomic_dec_and_test(&ino->count)) {
-		p_ino = autofs_dentry_ino(dentry->d_parent);
-		if (p_ino && dentry->d_parent != dentry)
-			atomic_dec(&p_ino->count);
-	}
-	dput(ino->dentry);
-	dentry->d_inode->i_size = 0;
-	clear_nlink(dentry->d_inode);
-
-	if (dir->i_nlink)
-		drop_nlink(dir);
-
-	return 0;
-}
-
-static int autofs_dir_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
-	struct autofs_info *p_ino;
-	struct inode *inode;
-
-	if (!autofs_oz_mode(sbi))
-		return -EACCES;
-
-	DPRINTK("dentry %p, creating %.*s",
-		dentry, dentry->d_name.len, dentry->d_name.name);
-
-	BUG_ON(!ino);
-
-	autofs_clean_ino(ino);
-
-	autofs_del_active(dentry);
-
-	inode = autofs_get_inode(dir->i_sb, S_IFDIR | 0555);
-	if (!inode)
-		return -ENOMEM;
-	d_add(dentry, inode);
-
-	if (sbi->version < 5)
-		autofs_set_leaf_automount_flags(dentry);
-
-	dget(dentry);
-	atomic_inc(&ino->count);
-	p_ino = autofs_dentry_ino(dentry->d_parent);
-	if (p_ino && dentry->d_parent != dentry)
-		atomic_inc(&p_ino->count);
-	inc_nlink(dir);
-	dir->i_mtime = CURRENT_TIME;
-
-	return 0;
-}
-
-/* Get/set timeout ioctl() operation */
-#ifdef CONFIG_COMPAT
-static inline int autofs_compat_get_set_timeout(struct autofs_sb_info *sbi,
-						 compat_ulong_t __user *p)
-{
-	int rv;
-	unsigned long ntimeout;
-
-	if ((rv = get_user(ntimeout, p)) ||
-	     (rv = put_user(sbi->exp_timeout/HZ, p)))
-		return rv;
-
-	if (ntimeout > UINT_MAX/HZ)
-		sbi->exp_timeout = 0;
-	else
-		sbi->exp_timeout = ntimeout * HZ;
-
-	return 0;
-}
-#endif
-
-static inline int autofs_get_set_timeout(struct autofs_sb_info *sbi,
-					  unsigned long __user *p)
-{
-	int rv;
-	unsigned long ntimeout;
-
-	if ((rv = get_user(ntimeout, p)) ||
-	     (rv = put_user(sbi->exp_timeout/HZ, p)))
-		return rv;
-
-	if (ntimeout > ULONG_MAX/HZ)
-		sbi->exp_timeout = 0;
-	else
-		sbi->exp_timeout = ntimeout * HZ;
-
-	return 0;
-}
-
-/* Return protocol version */
-static inline int autofs_get_protover(struct autofs_sb_info *sbi,
-				       int __user *p)
-{
-	return put_user(sbi->version, p);
-}
-
-/* Return protocol sub version */
-static inline int autofs_get_protosubver(struct autofs_sb_info *sbi,
-					  int __user *p)
-{
-	return put_user(sbi->sub_version, p);
-}
-
-/*
-* Tells the daemon whether it can umount the autofs mount.
-*/
-static inline int autofs_ask_umount(struct vfsmount *mnt, int __user *p)
-{
-	int status = 0;
-
-	if (may_umount(mnt))
-		status = 1;
-
-	DPRINTK("returning %d", status);
-
-	status = put_user(status, p);
-
-	return status;
-}
-
-/* Identify autofs_dentries - this is so we can tell if there's
-   an extra dentry refcount or not.  We only hold a refcount on the
-   dentry if its non-negative (ie, d_inode != NULL)
-*/
-int is_autofs_dentry(struct dentry *dentry)
-{
-	return dentry && dentry->d_inode &&
-		dentry->d_op == &autofs_dentry_operations &&
-		dentry->d_fsdata != NULL;
-}
-
-/*
- * ioctl()'s on the root directory is the chief method for the daemon to
- * generate kernel reactions
- */
-static int autofs_root_ioctl_unlocked(struct inode *inode, struct file *filp,
-				       unsigned int cmd, unsigned long arg)
-{
-	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
-	void __user *p = (void __user *)arg;
-
-	DPRINTK("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u",
-		cmd,arg,sbi,task_pgrp_nr(current));
-
-	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
-	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)
-		return -ENOTTY;
-	
-	if (!autofs_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-	
-	switch(cmd) {
-	case AUTOFS_IOC_READY:	/* Wait queue: go ahead and retry */
-		return autofs_wait_release(sbi,(autofs_wqt_t)arg,0);
-	case AUTOFS_IOC_FAIL:	/* Wait queue: fail with ENOENT */
-		return autofs_wait_release(sbi,(autofs_wqt_t)arg,-ENOENT);
-	case AUTOFS_IOC_CATATONIC: /* Enter catatonic mode (daemon shutdown) */
-		autofs_catatonic_mode(sbi);
-		return 0;
-	case AUTOFS_IOC_PROTOVER: /* Get protocol version */
-		return autofs_get_protover(sbi, p);
-	case AUTOFS_IOC_PROTOSUBVER: /* Get protocol sub version */
-		return autofs_get_protosubver(sbi, p);
-	case AUTOFS_IOC_SETTIMEOUT:
-		return autofs_get_set_timeout(sbi, p);
-#ifdef CONFIG_COMPAT
-	case AUTOFS_IOC_SETTIMEOUT32:
-		return autofs_compat_get_set_timeout(sbi, p);
-#endif
-
-	case AUTOFS_IOC_ASKUMOUNT:
-		return autofs_ask_umount(filp->f_path.mnt, p);
-
-	/* return a single thing to expire */
-	case AUTOFS_IOC_EXPIRE:
-		return autofs_expire_run(inode->i_sb,filp->f_path.mnt,sbi, p);
-	/* same as above, but can send multiple expires through pipe */
-	case AUTOFS_IOC_EXPIRE_MULTI:
-		return autofs_expire_multi(inode->i_sb,filp->f_path.mnt,sbi, p);
-
-	default:
-		return -ENOSYS;
-	}
-}
-
-static long autofs_root_ioctl(struct file *filp,
-			       unsigned int cmd, unsigned long arg)
-{
-	struct inode *inode = file_inode(filp);
-	return autofs_root_ioctl_unlocked(inode, filp, cmd, arg);
-}
-
-#ifdef CONFIG_COMPAT
-static long autofs_root_compat_ioctl(struct file *filp,
-				      unsigned int cmd, unsigned long arg)
-{
-	struct inode *inode = file_inode(filp);
-	int ret;
-
-	if (cmd == AUTOFS_IOC_READY || cmd == AUTOFS_IOC_FAIL)
-		ret = autofs_root_ioctl_unlocked(inode, filp, cmd, arg);
-	else
-		ret = autofs_root_ioctl_unlocked(inode, filp, cmd,
-					      (unsigned long) compat_ptr(arg));
-
-	return ret;
-}
-#endif
diff --git a/fs/autofs4/symlink.c b/fs/autofs4/symlink.c
deleted file mode 100644
index 9d728bf..0000000
--- a/fs/autofs4/symlink.c
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
-
-#include "autofs_i.h"
-
-static void *autofs_follow_link(struct dentry *dentry, struct nameidata *nd)
-{
-	nd_set_link(nd, dentry->d_inode->i_private);
-	return NULL;
-}
-
-const struct inode_operations autofs_symlink_inode_operations = {
-	.readlink	= generic_readlink,
-	.follow_link	= autofs_follow_link
-};
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
deleted file mode 100644
index 1725e3f..0000000
--- a/fs/autofs4/waitq.c
+++ /dev/null
@@ -1,571 +0,0 @@
-/*
- *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
- *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
- *
- * This file is part of the Linux kernel and is made available under
- * the terms of the GNU General Public License, version 2, or at your
- * option, any later version, incorporated herein by reference.
- *
- * ------------------------------------------------------------------------- */
-
-#include <linux/slab.h>
-#include <linux/time.h>
-#include <linux/signal.h>
-#include <linux/file.h>
-#include "autofs_i.h"
-
-/* We make this a static variable rather than a part of the superblock; it
-   is better if we don't reassign numbers easily even across filesystems */
-static autofs_wqt_t autofs_next_wait_queue = 1;
-
-/* These are the signals we allow interrupting a pending mount */
-#define SHUTDOWN_SIGS	(sigmask(SIGKILL) | sigmask(SIGINT) | sigmask(SIGQUIT))
-
-void autofs_catatonic_mode(struct autofs_sb_info *sbi)
-{
-	struct autofs_wait_queue *wq, *nwq;
-
-	mutex_lock(&sbi->wq_mutex);
-	if (sbi->catatonic) {
-		mutex_unlock(&sbi->wq_mutex);
-		return;
-	}
-
-	DPRINTK("entering catatonic mode");
-
-	sbi->catatonic = 1;
-	wq = sbi->queues;
-	sbi->queues = NULL;	/* Erase all wait queues */
-	while (wq) {
-		nwq = wq->next;
-		wq->status = -ENOENT; /* Magic is gone - report failure */
-		kfree(wq->name.name);
-		wq->name.name = NULL;
-		wq->wait_ctr--;
-		wake_up_interruptible(&wq->queue);
-		wq = nwq;
-	}
-	fput(sbi->pipe);	/* Close the pipe */
-	sbi->pipe = NULL;
-	sbi->pipefd = -1;
-	mutex_unlock(&sbi->wq_mutex);
-}
-
-static int autofs_write(struct autofs_sb_info *sbi,
-			struct file *file, const void *addr, int bytes)
-{
-	unsigned long sigpipe, flags;
-	mm_segment_t fs;
-	const char *data = (const char *)addr;
-	ssize_t wr = 0;
-
-	sigpipe = sigismember(&current->pending.signal, SIGPIPE);
-
-	/* Save pointer to user space and point back to kernel space */
-	fs = get_fs();
-	set_fs(KERNEL_DS);
-
-	mutex_lock(&sbi->pipe_mutex);
-	while (bytes &&
-	       (wr = file->f_op->write(file,data,bytes,&file->f_pos)) > 0) {
-		data += wr;
-		bytes -= wr;
-	}
-	mutex_unlock(&sbi->pipe_mutex);
-
-	set_fs(fs);
-
-	/* Keep the currently executing process from receiving a
-	   SIGPIPE unless it was already supposed to get one */
-	if (wr == -EPIPE && !sigpipe) {
-		spin_lock_irqsave(&current->sighand->siglock, flags);
-		sigdelset(&current->pending.signal, SIGPIPE);
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
-	}
-
-	return (bytes > 0);
-}
-	
-static void autofs_notify_daemon(struct autofs_sb_info *sbi,
-				 struct autofs_wait_queue *wq,
-				 int type)
-{
-	union {
-		struct autofs_packet_hdr hdr;
-		union autofs_packet_union v4_pkt;
-		union autofs_v5_packet_union v5_pkt;
-	} pkt;
-	struct file *pipe = NULL;
-	size_t pktsz;
-
-	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
-		(unsigned long) wq->wait_queue_token,
-		wq->name.len, wq->name.name, type);
-
-	memset(&pkt,0,sizeof pkt); /* For security reasons */
-
-	pkt.hdr.proto_version = sbi->version;
-	pkt.hdr.type = type;
-	mutex_lock(&sbi->wq_mutex);
-
-	/* Check if we have become catatonic */
-	if (sbi->catatonic) {
-		mutex_unlock(&sbi->wq_mutex);
-		return;
-	}
-	switch (type) {
-	/* Kernel protocol v4 missing and expire packets */
-	case autofs_ptype_missing:
-	{
-		struct autofs_packet_missing *mp = &pkt.v4_pkt.missing;
-
-		pktsz = sizeof(*mp);
-
-		mp->wait_queue_token = wq->wait_queue_token;
-		mp->len = wq->name.len;
-		memcpy(mp->name, wq->name.name, wq->name.len);
-		mp->name[wq->name.len] = '\0';
-		break;
-	}
-	case autofs_ptype_expire_multi:
-	{
-		struct autofs_packet_expire_multi *ep = &pkt.v4_pkt.expire_multi;
-
-		pktsz = sizeof(*ep);
-
-		ep->wait_queue_token = wq->wait_queue_token;
-		ep->len = wq->name.len;
-		memcpy(ep->name, wq->name.name, wq->name.len);
-		ep->name[wq->name.len] = '\0';
-		break;
-	}
-	/*
-	 * Kernel protocol v5 packet for handling indirect and direct
-	 * mount missing and expire requests
-	 */
-	case autofs_ptype_missing_indirect:
-	case autofs_ptype_expire_indirect:
-	case autofs_ptype_missing_direct:
-	case autofs_ptype_expire_direct:
-	{
-		struct autofs_v5_packet *packet = &pkt.v5_pkt.v5_packet;
-		struct user_namespace *user_ns = sbi->pipe->f_cred->user_ns;
-
-		pktsz = sizeof(*packet);
-
-		packet->wait_queue_token = wq->wait_queue_token;
-		packet->len = wq->name.len;
-		memcpy(packet->name, wq->name.name, wq->name.len);
-		packet->name[wq->name.len] = '\0';
-		packet->dev = wq->dev;
-		packet->ino = wq->ino;
-		packet->uid = from_kuid_munged(user_ns, wq->uid);
-		packet->gid = from_kgid_munged(user_ns, wq->gid);
-		packet->pid = wq->pid;
-		packet->tgid = wq->tgid;
-		break;
-	}
-	default:
-		printk("autofs_notify_daemon: bad type %d!\n", type);
-		mutex_unlock(&sbi->wq_mutex);
-		return;
-	}
-
-	pipe = get_file(sbi->pipe);
-
-	mutex_unlock(&sbi->wq_mutex);
-
-	if (autofs_write(sbi, pipe, &pkt, pktsz))
-		autofs_catatonic_mode(sbi);
-	fput(pipe);
-}
-
-static int autofs_getpath(struct autofs_sb_info *sbi,
-			  struct dentry *dentry, char **name)
-{
-	struct dentry *root = sbi->sb->s_root;
-	struct dentry *tmp;
-	char *buf;
-	char *p;
-	int len;
-	unsigned seq;
-
-rename_retry:
-	buf = *name;
-	len = 0;
-
-	seq = read_seqbegin(&rename_lock);
-	rcu_read_lock();
-	spin_lock(&sbi->fs_lock);
-	for (tmp = dentry ; tmp != root ; tmp = tmp->d_parent)
-		len += tmp->d_name.len + 1;
-
-	if (!len || --len > NAME_MAX) {
-		spin_unlock(&sbi->fs_lock);
-		rcu_read_unlock();
-		if (read_seqretry(&rename_lock, seq))
-			goto rename_retry;
-		return 0;
-	}
-
-	*(buf + len) = '\0';
-	p = buf + len - dentry->d_name.len;
-	strncpy(p, dentry->d_name.name, dentry->d_name.len);
-
-	for (tmp = dentry->d_parent; tmp != root ; tmp = tmp->d_parent) {
-		*(--p) = '/';
-		p -= tmp->d_name.len;
-		strncpy(p, tmp->d_name.name, tmp->d_name.len);
-	}
-	spin_unlock(&sbi->fs_lock);
-	rcu_read_unlock();
-	if (read_seqretry(&rename_lock, seq))
-		goto rename_retry;
-
-	return len;
-}
-
-static struct autofs_wait_queue *
-autofs_find_wait(struct autofs_sb_info *sbi, struct qstr *qstr)
-{
-	struct autofs_wait_queue *wq;
-
-	for (wq = sbi->queues; wq; wq = wq->next) {
-		if (wq->name.hash == qstr->hash &&
-		    wq->name.len == qstr->len &&
-		    wq->name.name &&
-		    !memcmp(wq->name.name, qstr->name, qstr->len))
-			break;
-	}
-	return wq;
-}
-
-/*
- * Check if we have a valid request.
- * Returns
- * 1 if the request should continue.
- *   In this case we can return an autofs_wait_queue entry if one is
- *   found or NULL to idicate a new wait needs to be created.
- * 0 or a negative errno if the request shouldn't continue.
- */
-static int validate_request(struct autofs_wait_queue **wait,
-			    struct autofs_sb_info *sbi,
-			    struct qstr *qstr,
-			    struct dentry*dentry, enum autofs_notify notify)
-{
-	struct autofs_wait_queue *wq;
-	struct autofs_info *ino;
-
-	if (sbi->catatonic)
-		return -ENOENT;
-
-	/* Wait in progress, continue; */
-	wq = autofs_find_wait(sbi, qstr);
-	if (wq) {
-		*wait = wq;
-		return 1;
-	}
-
-	*wait = NULL;
-
-	/* If we don't yet have any info this is a new request */
-	ino = autofs_dentry_ino(dentry);
-	if (!ino)
-		return 1;
-
-	/*
-	 * If we've been asked to wait on an existing expire (NFY_NONE)
-	 * but there is no wait in the queue ...
-	 */
-	if (notify == NFY_NONE) {
-		/*
-		 * Either we've betean the pending expire to post it's
-		 * wait or it finished while we waited on the mutex.
-		 * So we need to wait till either, the wait appears
-		 * or the expire finishes.
-		 */
-
-		while (ino->flags & AUTOFS_INF_EXPIRING) {
-			mutex_unlock(&sbi->wq_mutex);
-			schedule_timeout_interruptible(HZ/10);
-			if (mutex_lock_interruptible(&sbi->wq_mutex))
-				return -EINTR;
-
-			if (sbi->catatonic)
-				return -ENOENT;
-
-			wq = autofs_find_wait(sbi, qstr);
-			if (wq) {
-				*wait = wq;
-				return 1;
-			}
-		}
-
-		/*
-		 * Not ideal but the status has already gone. Of the two
-		 * cases where we wait on NFY_NONE neither depend on the
-		 * return status of the wait.
-		 */
-		return 0;
-	}
-
-	/*
-	 * If we've been asked to trigger a mount and the request
-	 * completed while we waited on the mutex ...
-	 */
-	if (notify == NFY_MOUNT) {
-		struct dentry *new = NULL;
-		int valid = 1;
-
-		/*
-		 * If the dentry was successfully mounted while we slept
-		 * on the wait queue mutex we can return success. If it
-		 * isn't mounted (doesn't have submounts for the case of
-		 * a multi-mount with no mount at it's base) we can
-		 * continue on and create a new request.
-		 */
-		if (!IS_ROOT(dentry)) {
-			if (dentry->d_inode && d_unhashed(dentry)) {
-				struct dentry *parent = dentry->d_parent;
-				new = d_lookup(parent, &dentry->d_name);
-				if (new)
-					dentry = new;
-			}
-		}
-		if (have_submounts(dentry))
-			valid = 0;
-
-		if (new)
-			dput(new);
-		return valid;
-	}
-
-	return 1;
-}
-
-int autofs_wait(struct autofs_sb_info *sbi,
-		struct dentry *dentry, enum autofs_notify notify)
-{
-	struct autofs_wait_queue *wq;
-	struct qstr qstr;
-	char *name;
-	int status, ret, type;
-	pid_t pid;
-	pid_t tgid;
-
-	/* In catatonic mode, we don't wait for nobody */
-	if (sbi->catatonic)
-		return -ENOENT;
-
-	/*
-	 * Try translating pids to the namespace of the daemon.
-	 *
-	 * Zero means failure: we are in an unrelated pid namespace.
-	 */
-	pid = task_pid_nr_ns(current, ns_of_pid(sbi->oz_pgrp));
-	tgid = task_tgid_nr_ns(current, ns_of_pid(sbi->oz_pgrp));
-	if (pid == 0 || tgid == 0)
-		return -ENOENT;
-
-	if (!dentry->d_inode) {
-		/*
-		 * A wait for a negative dentry is invalid for certain
-		 * cases. A direct or offset mount "always" has its mount
-		 * point directory created and so the request dentry must
-		 * be positive or the map key doesn't exist. The situation
-		 * is very similar for indirect mounts except only dentrys
-		 * in the root of the autofs file system may be negative.
-		 */
-		if (autofs_type_trigger(sbi->type))
-			return -ENOENT;
-		else if (!IS_ROOT(dentry->d_parent))
-			return -ENOENT;
-	}
-
-	name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
-	if (!name)
-		return -ENOMEM;
-
-	/* If this is a direct mount request create a dummy name */
-	if (IS_ROOT(dentry) && autofs_type_trigger(sbi->type))
-		qstr.len = sprintf(name, "%p", dentry);
-	else {
-		qstr.len = autofs_getpath(sbi, dentry, &name);
-		if (!qstr.len) {
-			kfree(name);
-			return -ENOENT;
-		}
-	}
-	qstr.name = name;
-	qstr.hash = full_name_hash(name, qstr.len);
-
-	if (mutex_lock_interruptible(&sbi->wq_mutex)) {
-		kfree(qstr.name);
-		return -EINTR;
-	}
-
-	ret = validate_request(&wq, sbi, &qstr, dentry, notify);
-	if (ret <= 0) {
-		if (ret != -EINTR)
-			mutex_unlock(&sbi->wq_mutex);
-		kfree(qstr.name);
-		return ret;
-	}
-
-	if (!wq) {
-		/* Create a new wait queue */
-		wq = kmalloc(sizeof(struct autofs_wait_queue),GFP_KERNEL);
-		if (!wq) {
-			kfree(qstr.name);
-			mutex_unlock(&sbi->wq_mutex);
-			return -ENOMEM;
-		}
-
-		wq->wait_queue_token = autofs_next_wait_queue;
-		if (++autofs_next_wait_queue == 0)
-			autofs_next_wait_queue = 1;
-		wq->next = sbi->queues;
-		sbi->queues = wq;
-		init_waitqueue_head(&wq->queue);
-		memcpy(&wq->name, &qstr, sizeof(struct qstr));
-		wq->dev = autofs_get_dev(sbi);
-		wq->ino = autofs_get_ino(sbi);
-		wq->uid = current_uid();
-		wq->gid = current_gid();
-		wq->pid = pid;
-		wq->tgid = tgid;
-		wq->status = -EINTR; /* Status return if interrupted */
-		wq->wait_ctr = 2;
-		mutex_unlock(&sbi->wq_mutex);
-
-		if (sbi->version < 5) {
-			if (notify == NFY_MOUNT)
-				type = autofs_ptype_missing;
-			else
-				type = autofs_ptype_expire_multi;
-		} else {
-			if (notify == NFY_MOUNT)
-				type = autofs_type_trigger(sbi->type) ?
-					autofs_ptype_missing_direct :
-					 autofs_ptype_missing_indirect;
-			else
-				type = autofs_type_trigger(sbi->type) ?
-					autofs_ptype_expire_direct :
-					autofs_ptype_expire_indirect;
-		}
-
-		DPRINTK("new wait id = 0x%08lx, name = %.*s, nfy=%d\n",
-			(unsigned long) wq->wait_queue_token, wq->name.len,
-			wq->name.name, notify);
-
-		/* autofs_notify_daemon() may block */
-		autofs_notify_daemon(sbi, wq, type);
-	} else {
-		wq->wait_ctr++;
-		mutex_unlock(&sbi->wq_mutex);
-		kfree(qstr.name);
-		DPRINTK("existing wait id = 0x%08lx, name = %.*s, nfy=%d",
-			(unsigned long) wq->wait_queue_token, wq->name.len,
-			wq->name.name, notify);
-	}
-
-	/*
-	 * wq->name.name is NULL iff the lock is already released
-	 * or the mount has been made catatonic.
-	 */
-	if (wq->name.name) {
-		/* Block all but "shutdown" signals while waiting */
-		sigset_t oldset;
-		unsigned long irqflags;
-
-		spin_lock_irqsave(&current->sighand->siglock, irqflags);
-		oldset = current->blocked;
-		siginitsetinv(&current->blocked, SHUTDOWN_SIGS & ~oldset.sig[0]);
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
-
-		wait_event_interruptible(wq->queue, wq->name.name == NULL);
-
-		spin_lock_irqsave(&current->sighand->siglock, irqflags);
-		current->blocked = oldset;
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
-	} else {
-		DPRINTK("skipped sleeping");
-	}
-
-	status = wq->status;
-
-	/*
-	 * For direct and offset mounts we need to track the requester's
-	 * uid and gid in the dentry info struct. This is so it can be
-	 * supplied, on request, by the misc device ioctl interface.
-	 * This is needed during daemon resatart when reconnecting
-	 * to existing, active, autofs mounts. The uid and gid (and
-	 * related string values) may be used for macro substitution
-	 * in autofs mount maps.
-	 */
-	if (!status) {
-		struct autofs_info *ino;
-		struct dentry *de = NULL;
-
-		/* direct mount or browsable map */
-		ino = autofs_dentry_ino(dentry);
-		if (!ino) {
-			/* If not lookup actual dentry used */
-			de = d_lookup(dentry->d_parent, &dentry->d_name);
-			if (de)
-				ino = autofs_dentry_ino(de);
-		}
-
-		/* Set mount requester */
-		if (ino) {
-			spin_lock(&sbi->fs_lock);
-			ino->uid = wq->uid;
-			ino->gid = wq->gid;
-			spin_unlock(&sbi->fs_lock);
-		}
-
-		if (de)
-			dput(de);
-	}
-
-	/* Are we the last process to need status? */
-	mutex_lock(&sbi->wq_mutex);
-	if (!--wq->wait_ctr)
-		kfree(wq);
-	mutex_unlock(&sbi->wq_mutex);
-
-	return status;
-}
-
-
-int autofs_wait_release(struct autofs_sb_info *sbi,
-			autofs_wqt_t wait_queue_token, int status)
-{
-	struct autofs_wait_queue *wq, **wql;
-
-	mutex_lock(&sbi->wq_mutex);
-	for (wql = &sbi->queues; (wq = *wql) != NULL; wql = &wq->next) {
-		if (wq->wait_queue_token == wait_queue_token)
-			break;
-	}
-
-	if (!wq) {
-		mutex_unlock(&sbi->wq_mutex);
-		return -EINVAL;
-	}
-
-	*wql = wq->next;	/* Unlink from chain */
-	kfree(wq->name.name);
-	wq->name.name = NULL;	/* Do not wait on this queue */
-	wq->status = status;
-	wake_up_interruptible(&wq->queue);
-	if (!--wq->wait_ctr)
-		kfree(wq);
-	mutex_unlock(&sbi->wq_mutex);
-
-	return 0;
-}
-

