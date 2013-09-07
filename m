Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab3IGIgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 04:36:19 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:36955 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3IGIgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 04:36:17 -0400
Message-ID: <522AE3DB.7000209@gmail.com>
Date: Sat, 07 Sep 2013 10:29:15 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>
CC: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 12/19] pramfs: symlink operations
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add symlink operations.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/pramfs/symlink.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)
 create mode 100644 fs/pramfs/symlink.c

diff --git a/fs/pramfs/symlink.c b/fs/pramfs/symlink.c
new file mode 100644
index 0000000..0d5213f
--- /dev/null
+++ b/fs/pramfs/symlink.c
@@ -0,0 +1,76 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Symlink operations
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
+#include "pram.h"
+#include "xattr.h"
+
+int pram_block_symlink(struct inode *inode, const char *symname, int len)
+{
+	struct super_block *sb = inode->i_sb;
+	u64 block;
+	char *blockp;
+	int err;
+
+	err = pram_alloc_blocks(inode, 0, 1);
+	if (err)
+		return err;
+
+	block = pram_find_data_block(inode, 0);
+	blockp = pram_get_block(sb, block);
+
+	pram_memunlock_block(sb, blockp);
+	memcpy(blockp, symname, len);
+	blockp[len] = '\0';
+	pram_memlock_block(sb, blockp);
+	return 0;
+}
+
+static int pram_readlink(struct dentry *dentry, char __user *buffer, int buflen)
+{
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	u64 block;
+	char *blockp;
+
+	block = pram_find_data_block(inode, 0);
+	blockp = pram_get_block(sb, block);
+	return vfs_readlink(dentry, buffer, buflen, blockp);
+}
+
+static void *pram_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	off_t block;
+	int status;
+	char *blockp;
+
+	block = pram_find_data_block(inode, 0);
+	blockp = pram_get_block(sb, block);
+	status = vfs_follow_link(nd, blockp);
+	return ERR_PTR(status);
+}
+
+const struct inode_operations pram_symlink_inode_operations = {
+	.readlink	= pram_readlink,
+	.follow_link	= pram_follow_link,
+	.setattr	= pram_notify_change,
+#ifdef CONFIG_PRAMFS_XATTR
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
+	.listxattr	= pram_listxattr,
+	.removexattr	= generic_removexattr,
+#endif
+};
-- 
1.7.3.4
