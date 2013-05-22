Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab3EVQ6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:58:15 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:25620 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195Ab3EVQ6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:58:13 -0400
From: phdm@macq.eu
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Philippe De Muyter <phdm@macqel.be>
Subject: [PATCH v2] fs: add jfsv3 (AIX powerpc native JFS file system) read-only support
Date: Wed, 22 May 2013 18:57:29 +0200
Message-Id: <1369241849-18327-1-git-send-email-phdm@macq.eu>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe De Muyter <phdm@macqel.be>

This is a file system driver for the file system called JFS on AIX, but
different from what's called jfs on linux.  In AIX header files this
file system seems to be called "Version 3" or "Version 3p", hence its
name here.  This driver supports only read-only access to such file systems,
and has been tested successfully on AIX 3.5, AIX 4.1 and AIX 4.2 filesystems.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Tested-by: Jori Mantysalo <Jori.Mantysalo@uta.fi>
---
 fs/Kconfig        |    1 +
 fs/Makefile       |    1 +
 fs/jfsv3/Kconfig  |   10 +
 fs/jfsv3/Makefile |    7 +
 fs/jfsv3/inode.c  |  707 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 726 insertions(+), 0 deletions(-)
 create mode 100644 fs/jfsv3/Kconfig
 create mode 100644 fs/jfsv3/Makefile
 create mode 100644 fs/jfsv3/inode.c

diff --git a/fs/Kconfig b/fs/Kconfig
index c229f82..807823a 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -212,6 +212,7 @@ source "fs/ufs/Kconfig"
 source "fs/exofs/Kconfig"
 source "fs/f2fs/Kconfig"
 source "fs/efivarfs/Kconfig"
+source "fs/jfsv3/Kconfig"
 
 endif # MISC_FILESYSTEMS
 
diff --git a/fs/Makefile b/fs/Makefile
index 4fe6df3..99cd8e6 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -122,6 +122,7 @@ obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
 obj-$(CONFIG_F2FS_FS)		+= f2fs/
+obj-$(CONFIG_JFSV3_FS)		+= jfsv3/
 obj-y				+= exofs/ # Multiple modules
 obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
diff --git a/fs/jfsv3/Kconfig b/fs/jfsv3/Kconfig
new file mode 100644
index 0000000..4ba73c5
--- /dev/null
+++ b/fs/jfsv3/Kconfig
@@ -0,0 +1,10 @@
+config JFSV3_FS
+	tristate "AIX jfsv3 file system support"
+	---help---
+	  Read-only support for AIX jfs file systems (not to be confused
+	  with linux jfs).  You should normally also select support for
+	  AIX LVM partitions, but if you manage to get a AIX file system
+	  image by another way (dd, e.g.), selecting this is enough.  You'll
+	  be able to mount your disk image using the loop driver.
+	  To compile this file system support as a module, choose M here: the
+	  module will be called jfsv3.
diff --git a/fs/jfsv3/Makefile b/fs/jfsv3/Makefile
new file mode 100644
index 0000000..d6ecd66
--- /dev/null
+++ b/fs/jfsv3/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the AIX jfsv3 filesystem routines.
+#
+
+obj-$(CONFIG_JFSV3_FS) += jfsv3.o
+
+jfsv3-objs := inode.o
diff --git a/fs/jfsv3/inode.c b/fs/jfsv3/inode.c
new file mode 100644
index 0000000..bd40103
--- /dev/null
+++ b/fs/jfsv3/inode.c
@@ -0,0 +1,707 @@
+/*
+ * AIX JFS Version 3/3p file system, Linux read-only implementation
+ *
+ * Copyright (C) 2012-2013  Philippe De Muyter <phdm@macqel.be>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/namei.h>
+#include <linux/statfs.h>
+#include <linux/buffer_head.h>
+#include <linux/mpage.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+
+struct  jfsv3_superblock {
+	__be32 s_magic;        /* magic number */
+	char   s_cpu;          /* Target cpu type code */
+	char   s_flag1;        /* reserved */
+	char   s_flag2;        /* reserved */
+	char   s_type;         /* File system type code */
+	__be32 s_agsize;       /* fragments per allocation group */
+	__be32 s_logserial;    /* serial number of log when fs mounted */
+	__be32 s_fsize;        /* size (in 512 bytes) of entire fs */
+	__be16 s_bsize;        /* block size in bytes */
+	__be16 s_spare;        /* unused. */
+	char   s_fname[6];     /* name of this file system */
+	char   s_fpack[6];     /* name of this volume */
+	__be32 s_logdev;       /* device address of log */
+
+	/* current file system state information, values change over time */
+	char   s_fmod;         /* flag: set when file system is mounted */
+	char   s_ronly;        /* flag: file system is read only */
+	__be32 s_time;         /* time of last superblock update */
+
+	/* more persistent information */
+	__be32 s_version;      /* version number */
+	__be32 s_fragsize;     /* fragment size in bytes (fsv3p only) */
+	__be32 s_iagsize;      /* disk inode per alloc grp (fsv3p only) */
+	__be32 s_compress;     /* > 0 if data compression */
+};
+
+#define JFSV3_SUPER_MAGIC 0x43218765	/* Version 3 fs magic number */
+#define JFSV3P_SUPER_MAGIC 0x65872143	/* Version 3p fs magic number */
+
+#define D_PRIVATE 48			/* max len of in-inode symlink */
+
+struct jfsv3_dinode {
+	__be32 di_gen;
+	__be32 di_mode;
+	__be16 di_nlink;
+	__be16 di_acct;
+	__be32 di_uid;
+	__be32 di_gid;
+	__be32 di_size;
+	__be32 di_nblocks;
+	__be32 di_mtime;
+	char   res32[4];
+	__be32 di_atime;
+	char   res40[4];
+	__be32 di_ctime;
+	char   res48[4];
+	char   res52[28];
+	__be32 di_rdaddr[8];
+	char   res112[4];
+	__be32 di_rindirect;
+	char   res120[8];
+};
+
+struct jfsv3_direct {
+	__be32  d_ino;
+	__be16  d_reclen;
+	__be16  d_namlen;
+	char    d_name[0];    /* NULL terminated      */
+};
+
+struct jfsv3_fs_info {
+	unsigned long  s_iagsize;	/* disk inodes per alloc grp */
+	unsigned long  s_fsize;		/* size of fs in 512 bytes-blocks */
+	unsigned long  s_fragsize;	/* basic block size */
+	unsigned long  s_agsize;	/* blocks per allocation group */
+};
+
+static loff_t dinode_offset(struct super_block *sb, unsigned long ino)
+{
+	struct jfsv3_fs_info *fsi = sb->s_fs_info;
+	unsigned long iagsize = fsi->s_iagsize;
+
+	/* The first i-nodes are at block 256 (32 x 4096 bytes) */
+	/* Next i-nodes are at block fsi->s_agsize * fsi->s_fragsize * n */
+	if (ino < iagsize)
+		return (256 * 512) + ino * 128;
+	else
+		return (loff_t)((ino / iagsize) * fsi->s_agsize *
+			(fsi->s_fragsize / 128) + (ino % iagsize)) * 128;
+}
+
+struct jfsv3_dirpage {
+	char *p_data;
+	struct buffer_head *p_bh;
+};
+
+void jfsv3_readdirpage(struct jfsv3_dirpage *p, struct super_block *sb,
+			u32 addr)
+{
+	struct buffer_head *bh;
+
+	if (sb->s_blocksize == 4096) {
+		bh = __bread(sb->s_bdev, addr, 4096);
+		p->p_bh = bh;
+		if (bh)
+			p->p_data = bh->b_data;
+		else
+			p->p_data = NULL;
+	} else {
+		u32 nfrags;
+		char *data;
+
+		nfrags = addr >> 28;
+		nfrags = 8 - nfrags;
+		if (nfrags * 512 == sb->s_blocksize) {
+			addr &= 0xfffffff;
+			bh = __bread(sb->s_bdev, addr, sb->s_blocksize);
+			p->p_bh = bh;
+			if (bh)
+				p->p_data = bh->b_data;
+			else
+				p->p_data = NULL;
+			return;
+		}
+		data = kmalloc(nfrags * 512, GFP_KERNEL);
+		p->p_data = data;
+		p->p_bh = NULL;
+		if (!data)
+			return;
+		addr &= 0xfffffff;
+		pr_debug("addr = %u, nfrags = %u\n", addr, nfrags);
+		do {
+			struct buffer_head *bh;
+
+			bh = __bread(sb->s_bdev, addr, 512);
+			if (bh) {
+				memcpy(data, bh->b_data, 512);
+				brelse(bh);
+			}
+			addr += 1;
+			data += 512;
+		} while (--nfrags);
+	}
+}
+
+void jfsv3_freedirpage(struct jfsv3_dirpage *p)
+{
+	if (p->p_data) {
+		if (p->p_bh)
+			brelse(p->p_bh);
+		else
+			kfree(p->p_data);
+	}
+}
+
+static int jfsv3_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	int stored = 0;
+	struct inode *i = file_inode(filp);
+
+	pr_debug("jfsv3_readdir(i_ino = %lu, f_pos = %llu)\n", i->i_ino,
+								filp->f_pos);
+	if (filp->f_pos < 8 * 4096) {
+		struct super_block *sb = i->i_sb;
+		struct buffer_head *ibh;
+		loff_t fs_offset;
+		unsigned long blk_offset;
+
+		fs_offset = dinode_offset(sb, i->i_ino);
+		blk_offset = fs_offset & (sb->s_blocksize - 1);
+		ibh = __bread(sb->s_bdev, fs_offset >> sb->s_blocksize_bits,
+							sb->s_blocksize);
+		if (ibh) {
+			struct jfsv3_dinode *aji;
+			u32 curpage = filp->f_pos / 4096;
+			u32 addr;
+			struct jfsv3_dirpage page;
+
+			aji = (struct jfsv3_dinode *)(ibh->b_data + blk_offset);
+			pr_debug("inode %lu : nlink = %u\n", i->i_ino,
+						be32_to_cpu(aji->di_nlink));
+			pr_debug("mode = 0%o, size = %u, nblocks = %u, rdaddr[0] = %u\n",
+				be32_to_cpu(aji->di_mode),
+				be32_to_cpu(aji->di_size),
+				be32_to_cpu(aji->di_nblocks),
+				be32_to_cpu(aji->di_rdaddr[0]));
+			addr = be32_to_cpu(aji->di_rdaddr[curpage]);
+			jfsv3_readdirpage(&page, sb, addr);
+			if (page.p_data) {
+				struct jfsv3_direct *ajd;
+
+				ajd = (struct jfsv3_direct *)
+					(page.p_data + filp->f_pos % 4096);
+				while (filp->f_pos < be32_to_cpu(aji->di_size)
+				&& filp->f_pos / 4096 == curpage) {
+					pr_debug("%u %s\n",
+						be32_to_cpu(ajd->d_ino),
+						ajd->d_name);
+					if (filldir(dirent, ajd->d_name,
+						    strlen(ajd->d_name),
+						    filp->f_pos,
+						    be32_to_cpu(ajd->d_ino),
+						    DT_UNKNOWN) < 0) {
+						pr_debug("jfsv3_readdir: filldir(%s, %u) failed\n",
+						       ajd->d_name,
+						       be32_to_cpu(ajd->d_ino));
+						break;
+					}
+					stored++;
+					ajd = (struct jfsv3_direct *)
+						((char *)ajd +
+						be16_to_cpu(ajd->d_reclen));
+					filp->f_pos = (char *)ajd - page.p_data
+							+ (filp->f_pos & -4096);
+				}
+				jfsv3_freedirpage(&page);
+			}
+			brelse(ibh);
+		}
+	} else {
+		/* FIXME : put jfsv3_get_block's indirect block handling
+		 * in a separate function and use it here also.
+		 */
+		pr_info("jfsv3_readdir: huge dir support not implemented\n");
+		return -EFBIG;
+	}
+	pr_debug("exiting with f_pos = %llu, stored = %u\n", filp->f_pos,
+									stored);
+	return stored;
+}
+
+static const struct file_operations jfsv3_dir_operations = {
+	.read		= generic_read_dir,
+	.readdir	= jfsv3_readdir,
+};
+
+void jfsv3_map_bh(struct buffer_head *bh_result, struct super_block *sb,
+		u32 addr, sector_t lblock)
+{
+	pr_debug("jfsv3_map_bh(%08x, %llu)\n", addr,
+						(unsigned long long)lblock);
+	if (sb->s_blocksize != 4096) {
+		addr &= 0xfffffff;
+		addr += lblock & (0xfff >> sb->s_blocksize_bits);
+	}
+	pr_debug("map_bh(%08x)\n", addr);
+	map_bh(bh_result, sb, addr);
+}
+
+int jfsv3_get_block(struct inode *i, sector_t lblock,
+		  struct buffer_head *bh_result, int create)
+{
+	int ret = -EIO;
+	struct super_block *sb = i->i_sb;
+	struct buffer_head *ibh;
+	loff_t fs_offset;
+	unsigned long blk_offset;
+	struct jfsv3_dinode *aji;
+	u32 curpage = lblock >> (12 - sb->s_blocksize_bits);
+
+	pr_debug("jfsv3_get_block(block %08llx)\n", (unsigned long long)lblock);
+	if (!i->i_ino)
+		return ret;
+
+	fs_offset = dinode_offset(sb, i->i_ino);
+	blk_offset = fs_offset & (sb->s_blocksize - 1);
+	ibh = __bread(sb->s_bdev, fs_offset >> sb->s_blocksize_bits,
+							sb->s_blocksize);
+	if (!ibh)
+		return ret;
+
+	aji = (struct jfsv3_dinode *)(ibh->b_data + blk_offset);
+	pr_debug("inode %lu : nlink = %u\n", i->i_ino,
+						be32_to_cpu(aji->di_nlink));
+	pr_debug("mode = 0%o, size = %u, nblocks = %u, rdaddr[0] = %u\n",
+		be32_to_cpu(aji->di_mode), be32_to_cpu(aji->di_size),
+		be32_to_cpu(aji->di_nblocks), be32_to_cpu(aji->di_rdaddr[0]));
+	if (curpage < 8) {
+		jfsv3_map_bh(bh_result, sb,
+				be32_to_cpu(aji->di_rdaddr[curpage]), lblock);
+		ret = 0;
+	} else {
+		u32 addr = be32_to_cpu(aji->di_rindirect);
+		u32 frags_per_page = 4096 / sb->s_blocksize;
+		u32 addrs_per_block = 1024 / frags_per_page;
+
+		pr_debug("r_indirect = %08x, curpage = %u\n", addr, curpage);
+		if (be32_to_cpu(aji->di_size) <= 1024 * 4096) {
+			struct buffer_head *sibh;
+
+			addr += curpage / addrs_per_block;
+			sibh = __bread(sb->s_bdev, addr, sb->s_blocksize);
+			if (sibh) {
+				__be32 *b = (__be32 *)sibh->b_data;
+
+				pr_debug("mapping block %08x\n",
+				     be32_to_cpu(b[curpage % addrs_per_block]));
+				jfsv3_map_bh(bh_result, sb,
+				      be32_to_cpu(b[curpage % addrs_per_block]),
+				      lblock);
+				ret = 0;
+				brelse(sibh);
+			}
+		} else {
+			/*
+			 * 4k double-indirect block contains
+			 * 512 addresses of indirect blocks,
+			 * each containing 1024 block addresses.
+			 */
+			struct buffer_head *sibh;
+			unsigned long diblock = curpage / 1024;
+			unsigned long iblock = curpage % 1024;
+
+			if (sb->s_blocksize == 512) {
+				/* 64 = 512 / 8 */
+				addr += diblock / 64;
+				diblock &= 63;
+			}
+			sibh = __bread(sb->s_bdev, addr, sb->s_blocksize);
+			if (sibh) {
+				__be32 *ib = (__be32 *)sibh->b_data;
+				struct buffer_head *dibh;
+
+				addr = be32_to_cpu(ib[diblock * 2 + 1]);
+				pr_debug("reading addresses block %08x\n",
+									addr);
+				addr += iblock / addrs_per_block;
+				dibh = __bread(sb->s_bdev, addr,
+							sb->s_blocksize);
+				if (dibh) {
+					__be32 *b = (__be32 *)dibh->b_data;
+
+					pr_debug("mapping block %08x\n",
+						be32_to_cpu(b[iblock %
+							addrs_per_block]));
+					jfsv3_map_bh(bh_result, sb,
+						be32_to_cpu(b[iblock %
+						addrs_per_block]), lblock);
+					ret = 0;
+					brelse(dibh);
+				}
+				brelse(sibh);
+			}
+		}
+	}
+	brelse(ibh);
+	return ret;
+}
+
+static int jfsv3_readpage(struct file *file, struct page *page)
+{
+	return mpage_readpage(page, jfsv3_get_block);
+}
+
+static const struct address_space_operations jfsv3_aops = {
+	.readpage = jfsv3_readpage
+};
+
+static struct inode *jfsv3_iget(struct super_block *sb, ino_t ino);
+
+static struct dentry *jfsv3_lookup(struct inode *i, struct dentry *dentry,
+					unsigned int flags)
+{
+	int res = -EACCES;
+	const char *name = dentry->d_name.name;
+	int len = dentry->d_name.len;
+	struct inode *inode = NULL;
+	struct super_block *sb = i->i_sb;
+	struct buffer_head *ibh;
+	loff_t fs_offset;
+	unsigned long blk_offset;
+
+	pr_debug("jfsv3_lookup(i_ino = %lu, %.*s)\n", i->i_ino, len, name);
+	fs_offset = dinode_offset(sb, i->i_ino);
+	blk_offset = fs_offset & (sb->s_blocksize - 1);
+	ibh = __bread(sb->s_bdev, fs_offset >> sb->s_blocksize_bits,
+							sb->s_blocksize);
+	if (ibh) {
+		struct jfsv3_dinode *aji;
+		int curpage = 0;
+		u32 addr;
+		struct jfsv3_dirpage page;
+
+		aji = (struct jfsv3_dinode *)(ibh->b_data + blk_offset);
+		pr_debug("inode %lu : nlink = %u\n", i->i_ino,
+						be32_to_cpu(aji->di_nlink));
+		pr_debug("mode = 0%o, size = %u, nblocks = %u, rdaddr[0] = %u\n",
+			be32_to_cpu(aji->di_mode),
+			be32_to_cpu(aji->di_size),
+			be32_to_cpu(aji->di_nblocks),
+			be32_to_cpu(aji->di_rdaddr[0]));
+nextpage:
+		addr = be32_to_cpu(aji->di_rdaddr[curpage]);
+		jfsv3_readdirpage(&page, sb, addr);
+		if (page.p_data) {
+			struct jfsv3_direct *ajd;
+
+			ajd = (struct jfsv3_direct *)page.p_data;
+			while ((char *)ajd - page.p_data < 4096
+			&& (char *)ajd - page.p_data + curpage * 4096 <
+						be32_to_cpu(aji->di_size)) {
+				pr_debug("%u %s\n", be32_to_cpu(ajd->d_ino),
+								ajd->d_name);
+				if (len == strlen(ajd->d_name)
+				&& memcmp(ajd->d_name, name, len) == 0) {
+					inode = jfsv3_iget(i->i_sb,
+						be32_to_cpu(ajd->d_ino));
+					res = 0;
+					break;
+				}
+				ajd = (struct jfsv3_direct *)((char *)ajd +
+						be16_to_cpu(ajd->d_reclen));
+			}
+			jfsv3_freedirpage(&page);
+		}
+		curpage += 1;
+		if (res && curpage * 4096 < be32_to_cpu(aji->di_size)
+		&& curpage < 8)
+			goto nextpage;
+		brelse(ibh);
+	}
+	d_add(dentry, inode);
+	if (res)
+		pr_debug("jfsv3_lookup(i_ino = %lu, %.*s) failed\n", i->i_ino,
+								len, name);
+	return ERR_PTR(res);
+}
+
+static const struct inode_operations jfsv3_dir_inode_operations = {
+	.lookup		= jfsv3_lookup,
+};
+
+static void *jfsv3_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	struct inode *i = dentry->d_inode;
+	char *target_path = NULL;
+	struct super_block *sb = i->i_sb;
+	struct buffer_head *ibh;
+	loff_t fs_offset;
+	unsigned long blk_offset;
+
+	fs_offset = dinode_offset(sb, i->i_ino);
+	blk_offset = fs_offset & (sb->s_blocksize - 1);
+	ibh = __bread(sb->s_bdev, fs_offset >> sb->s_blocksize_bits,
+							sb->s_blocksize);
+	if (ibh) {
+		struct jfsv3_dinode *aji;
+
+		aji = (struct jfsv3_dinode *)(ibh->b_data + blk_offset);
+		target_path = kmalloc(D_PRIVATE + 1, GFP_KERNEL);
+		if (target_path) {
+			memcpy(target_path, (char *)aji->di_rdaddr, D_PRIVATE);
+			target_path[D_PRIVATE] = '\0';
+		}
+		nd_set_link(nd, target_path);
+		brelse(ibh);
+	}
+	return target_path;
+}
+
+static void jfsv3_put_link(struct dentry *dentry, struct nameidata *nd,
+				void *target_path)
+{
+	kfree(target_path);
+}
+
+const struct inode_operations jfsv3_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= jfsv3_follow_link,
+	.put_link	= jfsv3_put_link,
+};
+
+static void jfsv3_read_inode(struct inode *i)
+{
+	struct super_block *sb = i->i_sb;
+	struct buffer_head *ibh;
+	loff_t fs_offset;
+	unsigned long blk_offset;
+	struct jfsv3_dinode *aji;
+
+	pr_debug("jfsv3_read_inode(%lu)\n", i->i_ino);
+	if (!i->i_ino)
+		return;
+	fs_offset = dinode_offset(sb, i->i_ino);
+	blk_offset = fs_offset & (sb->s_blocksize - 1);
+	ibh = __bread(sb->s_bdev, fs_offset >> sb->s_blocksize_bits,
+							sb->s_blocksize);
+	if (!ibh) {
+		pr_info("__bread(%llu, %lu) = NULL\n",
+			fs_offset >> sb->s_blocksize_bits, sb->s_blocksize);
+		return;
+	}
+
+	aji = (struct jfsv3_dinode *)(ibh->b_data + blk_offset);
+	pr_debug("inode %lu : nlink = %u\n", i->i_ino,
+						be32_to_cpu(aji->di_nlink));
+	pr_debug("mode = 0%o, size = %u, nblocks = %u, rdaddr[0] = %u\n",
+		be32_to_cpu(aji->di_mode), be32_to_cpu(aji->di_size),
+		be32_to_cpu(aji->di_nblocks), be32_to_cpu(aji->di_rdaddr[0]));
+	set_nlink(i, be32_to_cpu(aji->di_nlink));
+	i->i_mode = be32_to_cpu(aji->di_mode);
+	i->i_size = be32_to_cpu(aji->di_size);
+	i->i_blocks = ((i->i_size + sb->s_blocksize - 1) >>
+			sb->s_blocksize_bits) << (sb->s_blocksize_bits - 9);
+	i->i_uid = be32_to_cpu(aji->di_uid);
+	i->i_gid = be32_to_cpu(aji->di_gid);
+	i->i_mtime.tv_sec = be32_to_cpu(aji->di_mtime);
+	i->i_atime.tv_sec = be32_to_cpu(aji->di_atime);
+	i->i_ctime.tv_sec = be32_to_cpu(aji->di_ctime);
+	i->i_mtime.tv_nsec = i->i_atime.tv_nsec = i->i_ctime.tv_nsec = 0;
+	if (S_ISREG(i->i_mode)) {
+		i->i_fop = &generic_ro_fops;
+		i->i_data.a_ops = &jfsv3_aops;
+	} else if (S_ISDIR(i->i_mode)) {
+		i->i_op = &jfsv3_dir_inode_operations;
+		i->i_fop = &jfsv3_dir_operations;
+	} else if (S_ISLNK(i->i_mode)) {
+		if (i->i_size > D_PRIVATE) {
+			i->i_op = &page_symlink_inode_operations;
+			i->i_data.a_ops = &jfsv3_aops;
+		} else
+			i->i_op = &jfsv3_symlink_inode_operations;
+	} else {
+		if (!S_ISCHR(i->i_mode)
+		&& !S_ISBLK(i->i_mode)
+		&& !S_ISFIFO(i->i_mode)
+		&& !S_ISSOCK(i->i_mode)) {
+			pr_info("inode %lu : fs_offset = %lld, blk_offset = %lu\n",
+				i->i_ino, fs_offset, blk_offset);
+			pr_info("nlink = %u, mode = 0%o, size = %u, nblocks = %u, rdaddr[0] = %u\n",
+				be32_to_cpu(aji->di_nlink),
+				be32_to_cpu(aji->di_mode),
+				be32_to_cpu(aji->di_size),
+				be32_to_cpu(aji->di_nblocks),
+				be32_to_cpu(aji->di_rdaddr[0]));
+		}
+		i->i_rdev = be32_to_cpu(aji->di_rdaddr[0]);
+		init_special_inode(i, i->i_mode, i->i_rdev);
+	}
+	brelse(ibh);
+}
+
+static struct inode *jfsv3_iget(struct super_block *sb, ino_t ino)
+{
+	struct inode *inode;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (inode->i_state & I_NEW) {
+		jfsv3_read_inode(inode);
+		unlock_new_inode(inode);
+	}
+	return inode;
+}
+
+static void jfsv3_put_super(struct super_block *sb)
+{
+	kfree(sb->s_fs_info);
+	sb->s_fs_info = NULL;
+}
+
+static int jfsv3_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct super_block *sb = dentry->d_sb;
+	struct jfsv3_fs_info *fsi = sb->s_fs_info;
+
+	buf->f_type = sb->s_magic;
+	buf->f_bsize = 4096;
+	buf->f_bfree = buf->f_bavail = buf->f_ffree;
+	buf->f_blocks = fsi->s_fsize;
+	buf->f_namelen = 256;
+	return 0;
+}
+
+static int jfsv3_remount(struct super_block *sb, int *flags, char *data)
+{
+	*flags |= MS_RDONLY;
+	return 0;
+}
+
+static const struct super_operations jfsv3_ops = {
+	.put_super	= jfsv3_put_super,
+	.statfs		= jfsv3_statfs,
+	.remount_fs	= jfsv3_remount,
+};
+
+static int jfsv3_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct buffer_head *bh;
+	struct jfsv3_superblock *aj_sb;
+	struct inode *root;
+	enum jfsv3type { NOTJFSV3, JFSV3, JFSV3P1, JFSV3P2 };
+	enum jfsv3type fstype = NOTJFSV3;
+	struct jfsv3_fs_info *fsi;
+
+	sb_set_blocksize(sb, 4096);
+
+	bh = __bread(sb->s_bdev, 0x1000 >> sb->s_blocksize_bits,
+							sb->s_blocksize);
+	if (!bh)
+		return -EINVAL;
+
+	aj_sb = (struct jfsv3_superblock *)bh->b_data;
+	if (aj_sb->s_magic == cpu_to_be32(JFSV3_SUPER_MAGIC))
+		fstype = JFSV3;
+	else if (aj_sb->s_magic == cpu_to_be32(JFSV3P_SUPER_MAGIC)) {
+		if (aj_sb->s_version == cpu_to_be32(1))
+			fstype = JFSV3P1;
+		else if (aj_sb->s_version == cpu_to_be32(2))
+			fstype = JFSV3P2;
+	}
+	if (fstype == NOTJFSV3) {
+		pr_info("jfsv3: unsupported magic/version : %x/%x\n",
+			be32_to_cpu(aj_sb->s_magic),
+			be32_to_cpu(aj_sb->s_version));
+		brelse(bh);
+		goto out;
+	}
+
+	sb->s_magic = be32_to_cpu(aj_sb->s_magic);
+	fsi = kmalloc(sizeof(struct jfsv3_fs_info), GFP_KERNEL);
+	fsi->s_iagsize = fstype == JFSV3 ? 2048 : be32_to_cpu(aj_sb->s_iagsize);
+	fsi->s_fsize = be32_to_cpu(aj_sb->s_fsize);
+	sb->s_fs_info = fsi;
+	pr_info("AIX jfs file system, lv %.6s, name %.6s, %s version %u\n",
+		aj_sb->s_fpack, aj_sb->s_fname,
+		fstype == JFSV3 ? "jfsv3" : "jfsv3p",
+		be32_to_cpu(aj_sb->s_version));
+	pr_info("target cpu type %x, file system type %x\n", aj_sb->s_cpu,
+								aj_sb->s_type);
+	pr_info("fs size : %lu 512 bytes blocks, block size : %u bytes\n",
+				fsi->s_fsize, be16_to_cpu(aj_sb->s_bsize));
+	pr_info("state : %u\n", aj_sb->s_fmod);
+	fsi->s_agsize = be32_to_cpu(aj_sb->s_agsize);
+	pr_info("fragments per allocation group : %lu\n", fsi->s_agsize);
+	pr_info("disk i-nodes per allocation group : %lu\n", fsi->s_iagsize);
+	fsi->s_fragsize = be32_to_cpu(aj_sb->s_fragsize);
+	brelse(bh);
+	pr_info("fragments size (default 4096) : %lu bytes\n", fsi->s_fragsize);
+	if (!fsi->s_fragsize)
+		fsi->s_fragsize = 4096;
+	else if (sb_set_blocksize(sb, fsi->s_fragsize) != fsi->s_fragsize)
+		goto out;
+
+	sb->s_maxbytes = 0x80000000;
+
+	sb->s_flags |= MS_RDONLY;
+
+	sb->s_op = &jfsv3_ops;
+	root = jfsv3_iget(sb, 2);
+	if (!root)
+		goto out;
+
+	sb->s_root = d_make_root(root);
+	if (!sb->s_root)
+		goto out;
+
+	return 0;
+
+out:
+	return -EINVAL;
+}
+
+static struct dentry *jfsv3_mount(struct file_system_type *fs_type, int flags,
+					const char *dev_name, void *data)
+{
+	return mount_bdev(fs_type, flags, dev_name, data, jfsv3_fill_super);
+}
+
+static struct file_system_type jfsv3_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "jfsv3",
+	.mount		= jfsv3_mount,
+	.kill_sb	= kill_block_super,
+	.fs_flags	= FS_REQUIRES_DEV,
+};
+MODULE_ALIAS_FS("jfsv3");
+
+static int __init init_jfsv3_fs(void)
+{
+	return register_filesystem(&jfsv3_fs_type);
+}
+
+static void __exit exit_jfsv3_fs(void)
+{
+	unregister_filesystem(&jfsv3_fs_type);
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
+}
+
+module_init(init_jfsv3_fs)
+module_exit(exit_jfsv3_fs)
+MODULE_LICENSE("GPL");
-- 
1.7.1

