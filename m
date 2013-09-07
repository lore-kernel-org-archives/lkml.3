Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab3IGI0c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 04:26:32 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:41158 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab3IGI03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 04:26:29 -0400
Message-ID: <522AE18F.3070204@gmail.com>
Date: Sat, 07 Sep 2013 10:19:27 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: linux-kernel@vger.kernel.org, Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH 04/19] pramfs: add include files
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added include files.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/pramfs/pram.h             |  283 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/pram_fs.h      |   48 +++++++
 include/uapi/linux/Kbuild    |    1 +
 include/uapi/linux/magic.h   |    1 +
 include/uapi/linux/pram_fs.h |  192 ++++++++++++++++++++++++++++
 5 files changed, 525 insertions(+), 0 deletions(-)
 create mode 100644 fs/pramfs/pram.h
 create mode 100644 include/linux/pram_fs.h
 create mode 100644 include/uapi/linux/pram_fs.h

diff --git a/fs/pramfs/pram.h b/fs/pramfs/pram.h
new file mode 100644
index 0000000..08d724b
--- /dev/null
+++ b/fs/pramfs/pram.h
@@ -0,0 +1,283 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Definitions for the PRAMFS filesystem.
+ *
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#ifndef __PRAM_H
+#define __PRAM_H
+
+#include <linux/buffer_head.h>
+#include <linux/pram_fs.h>
+#include <linux/crc32.h>
+#include <linux/mutex.h>
+#include <linux/rcupdate.h>
+#include <linux/types.h>
+#include "wprotect.h"
+
+/*
+ * Debug code
+ */
+#ifdef pr_fmt
+#undef pr_fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#endif
+
+#define pram_dbg(s, args...)		pr_debug(s, ## args)
+#define pram_warn(s, args...)		pr_warning(s, ## args)
+#define pram_info(s, args...)		pr_info(s, ## args)
+
+#ifdef CONFIG_PRINTK
+#define pram_err(sb, s, args...)        pram_error_mng(sb, s, ## args)
+#else
+#define pram_err(sb, s, args...)                                       \
+do {                                                                   \
+       no_printk(s, ## args);                                          \
+       pram_error_mng(sb, " ");                                        \
+} while (0)
+#endif
+
+#define pram_set_bit			__test_and_set_bit_le
+#define pram_clear_bit			__test_and_clear_bit_le
+#define pram_find_next_zero_bit		find_next_zero_bit_le
+
+#define clear_opt(o, opt)	(o &= ~PRAM_MOUNT_##opt)
+#define set_opt(o, opt)		(o |= PRAM_MOUNT_##opt)
+#define test_opt(sb, opt)	(PRAM_SB(sb)->s_mount_opt & PRAM_MOUNT_##opt)
+
+/* Function Prototypes */
+extern void pram_error_mng(struct super_block *sb, const char *fmt, ...);
+
+/* file.c */
+extern ssize_t pram_direct_IO(int rw, struct kiocb *iocb,
+			  const struct iovec *iov,
+			  loff_t offset, unsigned long nr_segs);
+extern int pram_mmap(struct file *file, struct vm_area_struct *vma);
+
+/* balloc.c */
+extern void pram_init_bitmap(struct super_block *sb);
+extern void pram_free_block(struct super_block *sb, unsigned long blocknr);
+extern int pram_new_block(struct super_block *sb, unsigned long *blocknr,
+			  int zero);
+extern unsigned long pram_count_free_blocks(struct super_block *sb);
+
+/* dir.c */
+extern int pram_add_link(struct dentry *dentry, struct inode *inode);
+extern int pram_remove_link(struct inode *inode);
+
+/* namei.c */
+extern struct dentry *pram_get_parent(struct dentry *child);
+
+/* inode.c */
+extern int pram_alloc_blocks(struct inode *inode, int file_blocknr,
+			     unsigned int num);
+extern u64 pram_find_data_block(struct inode *inode,
+				unsigned long file_blocknr);
+
+extern struct inode *pram_iget(struct super_block *sb, unsigned long ino);
+extern void pram_put_inode(struct inode *inode);
+extern void pram_evict_inode(struct inode *inode);
+extern struct inode *pram_new_inode(struct inode *dir, umode_t mode,
+					const struct qstr *qstr);
+extern int pram_update_inode(struct inode *inode);
+extern int pram_write_inode(struct inode *inode, struct writeback_control *wbc);
+extern void pram_dirty_inode(struct inode *inode, int flags);
+extern int pram_notify_change(struct dentry *dentry, struct iattr *attr);
+extern void pram_set_inode_flags(struct inode *inode, struct pram_inode *pi);
+extern void pram_get_inode_flags(struct inode *inode, struct pram_inode *pi);
+extern int pram_find_region(struct inode *inode, loff_t *offset, int hole);
+
+/* ioctl.c */
+extern long pram_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+#ifdef CONFIG_COMPAT
+extern long pram_compat_ioctl(struct file *file, unsigned int cmd,
+			      unsigned long arg);
+#endif
+
+/* super.c */
+#ifdef CONFIG_PRAMFS_TEST
+extern struct pram_super_block *get_pram_super(void);
+#endif
+extern struct super_block *pram_read_super(struct super_block *sb,
+					      void *data,
+					      int silent);
+extern int pram_statfs(struct dentry *d, struct kstatfs *buf);
+extern int pram_remount(struct super_block *sb, int *flags, char *data);
+
+/* symlink.c */
+extern int pram_block_symlink(struct inode *inode,
+			       const char *symname, int len);
+
+/* Inline functions start here */
+static inline int pram_freeze_fs(struct super_block *sb)
+{
+	return 0;
+}
+
+static inline int pram_unfreeze_fs(struct super_block *sb)
+{
+	return 0;
+}
+
+/* Mask out flags that are inappropriate for the given type of inode. */
+static inline __be32 pram_mask_flags(umode_t mode, __be32 flags)
+{
+	flags &= cpu_to_be32(PRAM_FL_INHERITED);
+	if (S_ISDIR(mode))
+		return flags;
+	else if (S_ISREG(mode))
+		return flags & cpu_to_be32(PRAM_REG_FLMASK);
+	else
+		return flags & cpu_to_be32(PRAM_OTHER_FLMASK);
+}
+
+static inline int pram_calc_checksum(u8 *data, int n)
+{
+	u32 crc = 0;
+	crc = crc32(~0, (__u8 *)data + sizeof(__be32), n - sizeof(__be32));
+	if (*((__be32 *)data) == cpu_to_be32(crc))
+		return 0;
+	else
+		return 1;
+}
+
+struct pram_inode_vfs {
+#ifdef CONFIG_PRAMFS_XATTR
+	/*
+	 * Extended attributes can be read independently of the main file
+	 * data. Taking i_mutex even when reading would cause contention
+	 * between readers of EAs and writers of regular file data, so
+	 * instead we synchronize on xattr_sem when reading or changing
+	 * EAs.
+	 */
+	struct rw_semaphore xattr_sem;
+#endif
+	struct mutex i_meta_mutex;
+	struct mutex i_link_mutex;
+	struct inode vfs_inode;
+};
+
+static inline struct pram_sb_info *PRAM_SB(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+static inline struct pram_inode_vfs *PRAM_I(struct inode *inode)
+{
+	return container_of(inode, struct pram_inode_vfs, vfs_inode);
+}
+
+/* If this is part of a read-modify-write of the super block,
+   pram_memunlock_super() before calling! */
+static inline struct pram_super_block *
+pram_get_super(struct super_block *sb)
+{
+	struct pram_sb_info *sbi = PRAM_SB(sb);
+	return (struct pram_super_block *)sbi->virt_addr;
+}
+
+static inline struct pram_super_block *
+pram_get_redund_super(struct super_block *sb)
+{
+	struct pram_sb_info *sbi = PRAM_SB(sb);
+	return (struct pram_super_block *)(sbi->virt_addr + PRAM_SB_SIZE);
+}
+
+static inline void *
+pram_get_bitmap(struct super_block *sb)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	return (void *)ps + be64_to_cpu(ps->s_bitmap_start);
+}
+
+/* If this is part of a read-modify-write of the inode metadata,
+   pram_memunlock_inode() before calling! */
+static inline struct pram_inode *
+pram_get_inode(struct super_block *sb, u64 ino)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	return ino ? (struct pram_inode *)((void *)ps + ino) : NULL;
+}
+
+static inline ino_t
+pram_get_inodenr(struct super_block *sb, struct pram_inode *pi)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	return (ino_t)((unsigned long)pi - (unsigned long)ps);
+}
+
+static inline u64
+pram_get_block_off(struct super_block *sb, unsigned long blocknr)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	return (u64)(be64_to_cpu(ps->s_bitmap_start) +
+			     (blocknr << sb->s_blocksize_bits));
+}
+
+static inline unsigned long
+pram_get_blocknr(struct super_block *sb, u64 block)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	return (block - be64_to_cpu(ps->s_bitmap_start)) >>
+							   sb->s_blocksize_bits;
+}
+
+/* If this is part of a read-modify-write of the block,
+   pram_memunlock_block() before calling! */
+static inline void *
+pram_get_block(struct super_block *sb, u64 block)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	return block ? ((void *)ps + block) : NULL;
+}
+
+static inline unsigned long
+pram_get_pfn(struct super_block *sb, u64 block)
+{
+	return (PRAM_SB(sb)->phys_addr + block) >> PAGE_SHIFT;
+}
+
+static inline void check_eof_blocks(struct inode *inode, loff_t size)
+{
+	struct pram_inode *pi = pram_get_inode(inode->i_sb, inode->i_ino);
+	if (unlikely(!pi))
+		return;
+	if ((pi->i_flags & cpu_to_be32(PRAM_EOFBLOCKS_FL)) &&
+		size + inode->i_sb->s_blocksize >=
+		(inode->i_blocks << inode->i_sb->s_blocksize_bits))
+		pi->i_flags &= cpu_to_be32(~PRAM_EOFBLOCKS_FL);
+}
+
+/*
+ * Inodes and files operations
+ */
+
+/* dir.c */
+extern const struct file_operations pram_dir_operations;
+
+/* file.c */
+extern const struct inode_operations pram_file_inode_operations;
+extern const struct file_operations pram_file_operations;
+extern const struct file_operations pram_xip_file_operations;
+
+/* inode.c */
+extern const struct address_space_operations pram_aops;
+extern const struct address_space_operations pram_aops_xip;
+
+/* namei.c */
+extern const struct inode_operations pram_dir_inode_operations;
+extern const struct inode_operations pram_special_inode_operations;
+
+/* symlink.c */
+extern const struct inode_operations pram_symlink_inode_operations;
+
+extern struct backing_dev_info pram_backing_dev_info;
+
+#endif	/* __PRAM_H */
diff --git a/include/linux/pram_fs.h b/include/linux/pram_fs.h
new file mode 100644
index 0000000..1224861
--- /dev/null
+++ b/include/linux/pram_fs.h
@@ -0,0 +1,48 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Definitions for the PRAM filesystem.
+ *
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef _LINUX_PRAM_FS_H
+#define _LINUX_PRAM_FS_H
+
+#include <uapi/linux/pram_fs.h>
+
+/*
+ * PRAM filesystem super-block data in memory
+ */
+struct pram_sb_info {
+	/*
+	 * base physical and virtual address of PRAMFS (which is also
+	 * the pointer to the super block)
+	 */
+	phys_addr_t phys_addr;
+	void *virt_addr;
+
+	/* Mount options */
+	unsigned long bpi;
+	unsigned long num_inodes;
+	unsigned long blocksize;
+	unsigned long initsize;
+	unsigned long s_mount_opt;
+	kuid_t uid;		    /* Mount uid for root directory */
+	kgid_t gid;		    /* Mount gid for root directory */
+	umode_t mode;		    /* Mount mode for root directory */
+	atomic_t next_generation;
+#ifdef CONFIG_PRAMFS_XATTR
+	struct rb_root desc_tree;
+	spinlock_t desc_tree_lock;
+#endif
+	struct mutex s_lock;
+};
+
+#endif	/* _LINUX_PRAM_FS_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index e7c94ee..2e55ff1 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -423,3 +423,4 @@ header-y += x25.h
 header-y += xattr.h
 header-y += xfrm.h
 header-y += hw_breakpoint.h
+header-y += pram_fs.h
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 2944278..cae5b49 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -42,6 +42,7 @@
 #define NCP_SUPER_MAGIC		0x564c		/* Guess, what 0x564c is :-) */
 #define NFS_SUPER_MAGIC		0x6969
 #define OPENPROM_SUPER_MAGIC	0x9fa1
+#define PRAM_SUPER_MAGIC	0xEFFA
 #define QNX4_SUPER_MAGIC	0x002f		/* qnx4 fs detection */
 #define QNX6_SUPER_MAGIC	0x68191122	/* qnx6 fs detection */
 
diff --git a/include/uapi/linux/pram_fs.h b/include/uapi/linux/pram_fs.h
new file mode 100644
index 0000000..b488674
--- /dev/null
+++ b/include/uapi/linux/pram_fs.h
@@ -0,0 +1,192 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Definitions for the PRAMFS filesystem.
+ *
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#ifndef _UAPI_LINUX_PRAM_FS_H
+#define _UAPI_LINUX_PRAM_FS_H
+
+#include <linux/types.h>
+#include <linux/magic.h>
+#include <linux/fs.h>
+
+/*
+ * The PRAM filesystem constants/structures
+ */
+
+/*
+ * Mount flags
+ */
+#define PRAM_MOUNT_PROTECT		0x000001  /* Use memory protection */
+#define PRAM_MOUNT_XATTR_USER		0x000002  /* Extended user attributes */
+#define PRAM_MOUNT_POSIX_ACL		0x000004  /* POSIX ACL */
+#define PRAM_MOUNT_XIP			0x000008  /* Execute in place */
+#define PRAM_MOUNT_ERRORS_CONT		0x000010  /* Continue on errors */
+#define PRAM_MOUNT_ERRORS_RO		0x000020  /* Remount fs ro on errors */
+#define PRAM_MOUNT_ERRORS_PANIC		0x000040  /* Panic on errors */
+
+/*
+ * Pram inode flags
+ *
+ * PRAM_EOFBLOCKS_FL	There are blocks allocated beyond eof
+ */
+#define PRAM_EOFBLOCKS_FL	0x20000000
+/* Flags that should be inherited by new inodes from their parent. */
+#define PRAM_FL_INHERITED (FS_SECRM_FL | FS_UNRM_FL | FS_COMPR_FL |\
+			   FS_SYNC_FL | FS_NODUMP_FL | FS_NOATIME_FL | \
+			   FS_COMPRBLK_FL | FS_NOCOMP_FL | FS_JOURNAL_DATA_FL |\
+			   FS_NOTAIL_FL | FS_DIRSYNC_FL)
+/* Flags that are appropriate for regular files (all but dir-specific ones). */
+#define PRAM_REG_FLMASK (~(FS_DIRSYNC_FL | FS_TOPDIR_FL))
+/* Flags that are appropriate for non-directories/regular files. */
+#define PRAM_OTHER_FLMASK (FS_NODUMP_FL | FS_NOATIME_FL)
+#define PRAM_FL_USER_VISIBLE (FS_FL_USER_VISIBLE | PRAM_EOFBLOCKS_FL)
+
+/*
+ * Maximal count of links to a file
+ */
+#define PRAM_LINK_MAX		32000
+
+#define PRAM_MIN_BLOCK_SIZE 512
+#define PRAM_MAX_BLOCK_SIZE 4096
+#define PRAM_DEF_BLOCK_SIZE 2048
+
+#define PRAM_INODE_SIZE 128 /* must be power of two */
+#define PRAM_INODE_BITS   7
+
+/*
+ * Structure of a directory entry in PRAMFS.
+ * Offsets are to the inode that holds the referenced dentry.
+ */
+struct pram_dentry {
+	__be64	d_next;     /* next dentry in this directory */
+	__be64	d_prev;     /* previous dentry in this directory */
+	__be64	d_parent;   /* parent directory */
+	char	d_name[0];
+};
+
+
+/*
+ * Structure of an inode in PRAMFS
+ */
+struct pram_inode {
+	__be32	i_sum;          /* checksum of this inode */
+	__be32	i_uid;		/* Owner Uid */
+	__be32	i_gid;		/* Group Id */
+	__be16	i_mode;		/* File mode */
+	__be16	i_links_count;	/* Links count */
+	__be32	i_blocks;	/* Blocks count */
+	__be32	i_size;		/* Size of data in bytes */
+	__be32	i_atime;	/* Access time */
+	__be32	i_ctime;	/* Creation time */
+	__be32	i_mtime;	/* Modification time */
+	__be32	i_dtime;	/* Deletion Time */
+	__be64	i_xattr;	/* Extended attribute block */
+	__be32	i_generation;	/* File version (for NFS) */
+	__be32	i_flags;	/* Inode flags */
+
+	union {
+		struct {
+			/*
+			 * ptr to row block of 2D block pointer array,
+			 * file block #'s 0 to (blocksize/8)^2 - 1.
+			 */
+			__be64 row_block;
+		} reg;   /* regular file or symlink inode */
+		struct {
+			__be64 head; /* first entry in this directory */
+			__be64 tail; /* last entry in this directory */
+		} dir;
+		struct {
+			__be32 rdev; /* major/minor # */
+		} dev;   /* device inode */
+	} i_type;
+
+	struct pram_dentry i_d;
+};
+
+#define PRAM_NAME_LEN \
+	(PRAM_INODE_SIZE - offsetof(struct pram_inode, i_d.d_name) - 1)
+
+
+#define PRAM_SB_SIZE 128 /* must be power of two */
+
+/*
+ * Structure of the super block in PRAMFS
+ */
+struct pram_super_block {
+	__be32	s_sum;          /* checksum of this sb, including padding */
+	__be64	s_size;         /* total size of fs in bytes */
+	__be32	s_blocksize;    /* blocksize in bytes */
+	__be32	s_inodes_count;	/* total inodes count (used or free) */
+	__be32	s_free_inodes_count;/* free inodes count */
+	__be32	s_free_inode_hint;  /* start hint for locating free inodes */
+	__be32	s_blocks_count;	/* total data blocks count (used or free) */
+	__be32	s_free_blocks_count;/* free data blocks count */
+	__be32	s_free_blocknr_hint;/* free data blocks count */
+	__be64	s_bitmap_start; /* data block in-use bitmap location */
+	__be32	s_bitmap_blocks;/* size of bitmap in number of blocks */
+	__be32	s_mtime;	/* Mount time */
+	__be32	s_wtime;	/* Write time */
+	__be16	s_magic;	/* Magic signature */
+	char	s_volume_name[16]; /* volume name */
+};
+
+/* The root inode follows immediately after the redundant super block */
+#define PRAM_ROOT_INO (PRAM_SB_SIZE*2)
+
+/*
+ * XATTR related
+ */
+
+/* Magic value in attribute blocks */
+#define PRAM_XATTR_MAGIC		0x6d617270
+
+/* Maximum number of references to one attribute block */
+#define PRAM_XATTR_REFCOUNT_MAX		1024
+
+/* Name indexes */
+#define PRAM_XATTR_INDEX_USER			1
+#define PRAM_XATTR_INDEX_POSIX_ACL_ACCESS	2
+#define PRAM_XATTR_INDEX_POSIX_ACL_DEFAULT	3
+#define PRAM_XATTR_INDEX_TRUSTED		4
+#define PRAM_XATTR_INDEX_SECURITY	        5
+
+struct pram_xattr_header {
+	__be32	h_magic;	/* magic number for identification */
+	__be32	h_refcount;	/* reference count */
+	__be32	h_hash;		/* hash value of all attributes */
+	__u32	h_reserved[4];	/* zero right now */
+};
+
+struct pram_xattr_entry {
+	__u8	e_name_len;	/* length of name */
+	__u8	e_name_index;	/* attribute name index */
+	__be16	e_value_offs;	/* offset in disk block of value */
+	__be32	e_value_block;	/* disk block attribute is stored on (n/i) */
+	__be32	e_value_size;	/* size of attribute value */
+	__be32	e_hash;		/* hash value of name and value */
+	char	e_name[0];	/* attribute name */
+};
+
+#define PRAM_XATTR_PAD_BITS		2
+#define PRAM_XATTR_PAD		(1<<PRAM_XATTR_PAD_BITS)
+#define PRAM_XATTR_ROUND		(PRAM_XATTR_PAD-1)
+#define PRAM_XATTR_LEN(name_len) \
+	(((name_len) + PRAM_XATTR_ROUND + \
+	sizeof(struct pram_xattr_entry)) & ~PRAM_XATTR_ROUND)
+#define PRAM_XATTR_NEXT(entry) \
+	((struct pram_xattr_entry *)( \
+	  (char *)(entry) + PRAM_XATTR_LEN((entry)->e_name_len)))
+#define PRAM_XATTR_SIZE(size) \
+	(((size) + PRAM_XATTR_ROUND) & ~PRAM_XATTR_ROUND)
+
+#endif	/* _UAPI_LINUX_PRAM_FS_H */
-- 
1.7.3.4
