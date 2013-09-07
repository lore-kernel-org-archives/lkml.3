Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab3IGIkK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 04:40:10 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:63176 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3IGIkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 04:40:08 -0400
Message-ID: <522AE4C2.8050004@gmail.com>
Date: Sat, 07 Sep 2013 10:33:06 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Vladimir Davydov <vdavydov@parallels.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 17/19] pramfs: write protection
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add write protection.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/pramfs/wprotect.c |   39 ++++++++++++++
 fs/pramfs/wprotect.h |  144 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 183 insertions(+), 0 deletions(-)
 create mode 100644 fs/pramfs/wprotect.c
 create mode 100644 fs/pramfs/wprotect.h

diff --git a/fs/pramfs/wprotect.c b/fs/pramfs/wprotect.c
new file mode 100644
index 0000000..ba1e488
--- /dev/null
+++ b/fs/pramfs/wprotect.c
@@ -0,0 +1,39 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Write protection for the filesystem pages.
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
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/io.h>
+#include "pram.h"
+
+void pram_writeable(void *vaddr, unsigned long size, int rw)
+{
+	int ret = 0;
+	unsigned long nrpages = size >> PAGE_SHIFT;
+	unsigned long addr = (unsigned long)vaddr;
+
+	/* Page aligned */
+	addr &= PAGE_MASK;
+
+	if (size & (PAGE_SIZE - 1))
+		nrpages++;
+
+	if (rw)
+		ret = set_memory_rw(addr, nrpages);
+	else
+		ret = set_memory_ro(addr, nrpages);
+
+	BUG_ON(ret);
+}
diff --git a/fs/pramfs/wprotect.h b/fs/pramfs/wprotect.h
new file mode 100644
index 0000000..f5ee08d
--- /dev/null
+++ b/fs/pramfs/wprotect.h
@@ -0,0 +1,144 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Memory protection definitions for the PRAMFS filesystem.
+ *
+ * Copyright 2010-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __WPROTECT_H
+#define __WPROTECT_H
+
+#include <linux/pram_fs.h>
+
+/* pram_memunlock_super() before calling! */
+static inline void pram_sync_super(struct pram_super_block *ps)
+{
+	u32 crc = 0;
+	ps->s_wtime = cpu_to_be32(get_seconds());
+	ps->s_sum = 0;
+	crc = crc32(~0, (__u8 *)ps + sizeof(__be32), PRAM_SB_SIZE -
+								sizeof(__be32));
+	ps->s_sum = cpu_to_be32(crc);
+	/* Keep sync redundant super block */
+	memcpy((void *)ps + PRAM_SB_SIZE, (void *)ps, PRAM_SB_SIZE);
+}
+
+/* pram_memunlock_inode() before calling! */
+static inline void pram_sync_inode(struct pram_inode *pi)
+{
+	u32 crc = 0;
+	pi->i_sum = 0;
+	crc = crc32(~0, (__u8 *)pi + sizeof(__be32), PRAM_INODE_SIZE -
+								sizeof(__be32));
+	pi->i_sum = cpu_to_be32(crc);
+}
+
+#ifdef CONFIG_PRAMFS_WRITE_PROTECT
+extern void pram_writeable(void *vaddr, unsigned long size, int rw);
+
+static inline int pram_is_protected(struct super_block *sb)
+{
+	struct pram_sb_info *sbi = (struct pram_sb_info *)sb->s_fs_info;
+	return sbi->s_mount_opt & PRAM_MOUNT_PROTECT;
+}
+
+static inline void __pram_memunlock_range(void *p, unsigned long len)
+{
+	pram_writeable(p, len, 1);
+}
+
+static inline void __pram_memlock_range(void *p, unsigned long len)
+{
+	pram_writeable(p, len, 0);
+}
+
+static inline void pram_memunlock_range(struct super_block *sb, void *p,
+					unsigned long len)
+{
+	if (pram_is_protected(sb))
+		__pram_memunlock_range(p, len);
+}
+
+static inline void pram_memlock_range(struct super_block *sb, void *p,
+					unsigned long len)
+{
+	if (pram_is_protected(sb))
+		__pram_memlock_range(p, len);
+}
+
+static inline void pram_memunlock_super(struct super_block *sb,
+					struct pram_super_block *ps)
+{
+	if (pram_is_protected(sb))
+		__pram_memunlock_range(ps, PRAM_SB_SIZE);
+}
+
+static inline void pram_memlock_super(struct super_block *sb,
+					struct pram_super_block *ps)
+{
+	pram_sync_super(ps);
+	if (pram_is_protected(sb))
+		__pram_memlock_range(ps, PRAM_SB_SIZE);
+}
+
+static inline void pram_memunlock_inode(struct super_block *sb,
+					struct pram_inode *pi)
+{
+	if (pram_is_protected(sb))
+		__pram_memunlock_range(pi, PRAM_SB_SIZE);
+}
+
+static inline void pram_memlock_inode(struct super_block *sb,
+					struct pram_inode *pi)
+{
+	pram_sync_inode(pi);
+	if (pram_is_protected(sb))
+		__pram_memlock_range(pi, PRAM_SB_SIZE);
+}
+
+static inline void pram_memunlock_block(struct super_block *sb,
+					void *bp)
+{
+	if (pram_is_protected(sb))
+		__pram_memunlock_range(bp, sb->s_blocksize);
+}
+
+static inline void pram_memlock_block(struct super_block *sb,
+					void *bp)
+{
+	if (pram_is_protected(sb))
+		__pram_memlock_range(bp, sb->s_blocksize);
+}
+
+#else
+#define pram_is_protected(sb)	0
+#define pram_writeable(vaddr, size, rw) do {} while (0)
+static inline void pram_memunlock_range(struct super_block *sb, void *p,
+					unsigned long len) {}
+static inline void pram_memlock_range(struct super_block *sb, void *p,
+					unsigned long len) {}
+static inline void pram_memunlock_super(struct super_block *sb,
+					struct pram_super_block *ps) {}
+static inline void pram_memlock_super(struct super_block *sb,
+					struct pram_super_block *ps)
+{
+	pram_sync_super(ps);
+}
+static inline void pram_memunlock_inode(struct super_block *sb,
+					struct pram_inode *pi) {}
+static inline void pram_memlock_inode(struct super_block *sb,
+					struct pram_inode *pi)
+{
+	pram_sync_inode(pi);
+}
+static inline void pram_memunlock_block(struct super_block *sb,
+					void *bp) {}
+static inline void pram_memlock_block(struct super_block *sb,
+					void *bp) {}
+
+#endif /* CONFIG PRAMFS_WRITE_PROTECT */
+#endif
-- 
1.7.3.4
