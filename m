Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab3IGI3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 04:29:40 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:56617 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3IGI3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 04:29:37 -0400
Message-ID: <522AE24C.6060903@gmail.com>
Date: Sat, 07 Sep 2013 10:22:36 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: linux-kernel@vger.kernel.org, Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH 08/19] pramfs: file operations for dirs
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add file operations for dirs.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/pramfs/dir.c |  226 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 226 insertions(+), 0 deletions(-)
 create mode 100644 fs/pramfs/dir.c

diff --git a/fs/pramfs/dir.c b/fs/pramfs/dir.c
new file mode 100644
index 0000000..137a592
--- /dev/null
+++ b/fs/pramfs/dir.c
@@ -0,0 +1,226 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * File operations for directories.
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
+#include <linux/fs.h>
+#include <linux/pagemap.h>
+#include "pram.h"
+
+/*
+ *	Parent is locked.
+ */
+int pram_add_link(struct dentry *dentry, struct inode *inode)
+{
+	struct inode *dir = dentry->d_parent->d_inode;
+	struct pram_inode *pidir, *pi, *pitail = NULL;
+	u64 tail_ino, prev_ino;
+
+	const char *name = dentry->d_name.name;
+
+	int namelen = min_t(unsigned int, dentry->d_name.len, PRAM_NAME_LEN);
+
+	pidir = pram_get_inode(dir->i_sb, dir->i_ino);
+
+	mutex_lock(&PRAM_I(dir)->i_link_mutex);
+
+	pi = pram_get_inode(dir->i_sb, inode->i_ino);
+
+	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+
+	tail_ino = be64_to_cpu(pidir->i_type.dir.tail);
+	if (tail_ino != 0) {
+		pitail = pram_get_inode(dir->i_sb, tail_ino);
+		pram_memunlock_inode(dir->i_sb, pitail);
+		pitail->i_d.d_next = cpu_to_be64(inode->i_ino);
+		pram_memlock_inode(dir->i_sb, pitail);
+
+		prev_ino = tail_ino;
+
+		pram_memunlock_inode(dir->i_sb, pidir);
+		pidir->i_type.dir.tail = cpu_to_be64(inode->i_ino);
+		pidir->i_mtime = cpu_to_be32(dir->i_mtime.tv_sec);
+		pidir->i_ctime = cpu_to_be32(dir->i_ctime.tv_sec);
+		pram_memlock_inode(dir->i_sb, pidir);
+	} else {
+		/* the directory is empty */
+		prev_ino = 0;
+
+		pram_memunlock_inode(dir->i_sb, pidir);
+		pidir->i_type.dir.tail = cpu_to_be64(inode->i_ino);
+		pidir->i_type.dir.head = cpu_to_be64(inode->i_ino);
+		pidir->i_mtime = cpu_to_be32(dir->i_mtime.tv_sec);
+		pidir->i_ctime = cpu_to_be32(dir->i_ctime.tv_sec);
+		pram_memlock_inode(dir->i_sb, pidir);
+	}
+
+
+	pram_memunlock_inode(dir->i_sb, pi);
+	pi->i_d.d_prev = cpu_to_be64(prev_ino);
+	pi->i_d.d_parent = cpu_to_be64(dir->i_ino);
+	memcpy(pi->i_d.d_name, name, namelen);
+	pi->i_d.d_name[namelen] = '\0';
+	pram_memlock_inode(dir->i_sb, pi);
+	mutex_unlock(&PRAM_I(dir)->i_link_mutex);
+	return 0;
+}
+
+int pram_remove_link(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct pram_inode *prev = NULL;
+	struct pram_inode *next = NULL;
+	struct pram_inode *pidir, *pi;
+	struct inode *dir = NULL;
+
+	pi = pram_get_inode(sb, inode->i_ino);
+	pidir = pram_get_inode(sb, be64_to_cpu(pi->i_d.d_parent));
+	if (!pidir)
+		return -EACCES;
+
+	dir = pram_iget(inode->i_sb, be64_to_cpu(pi->i_d.d_parent));
+	if (IS_ERR(dir))
+		return -EACCES;
+	mutex_lock(&PRAM_I(dir)->i_link_mutex);
+
+	if (inode->i_ino == be64_to_cpu(pidir->i_type.dir.head)) {
+		/* first inode in directory */
+		next = pram_get_inode(sb, be64_to_cpu(pi->i_d.d_next));
+
+		if (next) {
+			pram_memunlock_inode(sb, next);
+			next->i_d.d_prev = 0;
+			pram_memlock_inode(sb, next);
+
+			pram_memunlock_inode(sb, pidir);
+			pidir->i_type.dir.head = pi->i_d.d_next;
+		} else {
+			pram_memunlock_inode(sb, pidir);
+			pidir->i_type.dir.head = 0;
+			pidir->i_type.dir.tail = 0;
+		}
+		pram_memlock_inode(sb, pidir);
+	} else if (inode->i_ino == be64_to_cpu(pidir->i_type.dir.tail)) {
+		/* last inode in directory */
+		prev = pram_get_inode(sb, be64_to_cpu(pi->i_d.d_prev));
+
+		pram_memunlock_inode(sb, prev);
+		prev->i_d.d_next = 0;
+		pram_memlock_inode(sb, prev);
+
+		pram_memunlock_inode(sb, pidir);
+		pidir->i_type.dir.tail = pi->i_d.d_prev;
+		pram_memlock_inode(sb, pidir);
+	} else {
+		/* somewhere in the middle */
+		prev = pram_get_inode(sb, be64_to_cpu(pi->i_d.d_prev));
+		next = pram_get_inode(sb, be64_to_cpu(pi->i_d.d_next));
+
+		if (prev && next) {
+			pram_memunlock_inode(sb, prev);
+			prev->i_d.d_next = pi->i_d.d_next;
+			pram_memlock_inode(sb, prev);
+
+			pram_memunlock_inode(sb, next);
+			next->i_d.d_prev = pi->i_d.d_prev;
+			pram_memlock_inode(sb, next);
+		}
+	}
+
+	pram_memunlock_inode(sb, pi);
+	pi->i_d.d_next = 0;
+	pi->i_d.d_prev = 0;
+	pi->i_d.d_parent = 0;
+	pram_memlock_inode(sb, pi);
+	mutex_unlock(&PRAM_I(dir)->i_link_mutex);
+	iput(dir);
+
+	return 0;
+}
+
+#define DT2IF(dt) (((dt) << 12) & S_IFMT)
+#define IF2DT(sif) (((sif) & S_IFMT) >> 12)
+
+static int pram_readdir(struct file *file, struct dir_context *ctx)
+{
+	struct inode *inode = file_inode(file);
+	struct super_block *sb = inode->i_sb;
+	struct pram_inode *pi;
+	int namelen, ret = 0;
+	char *name;
+	ino_t ino;
+
+	pi = pram_get_inode(sb, inode->i_ino);
+
+	switch ((u32)file->f_pos) {
+	case 0:
+		ret = dir_emit_dot(file, ctx);
+		ctx->pos = 1;
+		return ret;
+	case 1:
+		ret = dir_emit(ctx, "..", 2, be64_to_cpu(pi->i_d.d_parent),
+			      DT_DIR);
+		mutex_lock(&PRAM_I(inode)->i_link_mutex);
+		ino = be64_to_cpu(pi->i_type.dir.head);
+		mutex_unlock(&PRAM_I(inode)->i_link_mutex);
+		ctx->pos = ino ? ino : 2;
+		return ret;
+	case 2:
+		mutex_lock(&PRAM_I(inode)->i_link_mutex);
+		ino = be64_to_cpu(pi->i_type.dir.head);
+		if (ino) {
+			ctx->pos = ino;
+			pi = pram_get_inode(sb, ino);
+			break;
+		} else {
+			/* the directory is empty */
+			ctx->pos = 2;
+			mutex_unlock(&PRAM_I(inode)->i_link_mutex);
+			return 0;
+		}
+	case 3:
+		return 0;
+	default:
+		mutex_lock(&PRAM_I(inode)->i_link_mutex);
+		ino = file->f_pos;
+		pi = pram_get_inode(sb, ino);
+		break;
+	}
+
+	while (pi && !be16_to_cpu(pi->i_links_count)) {
+		ino = ctx->pos = be64_to_cpu(pi->i_d.d_next);
+		pi = pram_get_inode(sb, ino);
+	}
+
+	if (pi) {
+		name = pi->i_d.d_name;
+		namelen = strlen(name);
+
+		ret = dir_emit(ctx, name, namelen,
+			      ino, IF2DT(be16_to_cpu(pi->i_mode)));
+		ctx->pos = pi->i_d.d_next ? be64_to_cpu(pi->i_d.d_next) : 3;
+	} else
+		ctx->pos = 3;
+
+	mutex_unlock(&PRAM_I(inode)->i_link_mutex);
+	return ret;
+}
+
+const struct file_operations pram_dir_operations = {
+	.read		= generic_read_dir,
+	.iterate	= pram_readdir,
+	.fsync		= noop_fsync,
+	.unlocked_ioctl	= pram_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= pram_compat_ioctl,
+#endif
+};
-- 
1.7.3.4
