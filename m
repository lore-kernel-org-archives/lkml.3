Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233Ab3IGIfZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 04:35:25 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:64522 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3IGIfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 04:35:22 -0400
Message-ID: <522AE3A5.7030807@gmail.com>
Date: Sat, 07 Sep 2013 10:28:21 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Vladimir Davydov <vdavydov@parallels.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/19] pramfs: ioctl operations
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ioctl operations.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/pramfs/ioctl.c |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 127 insertions(+), 0 deletions(-)
 create mode 100644 fs/pramfs/ioctl.c

diff --git a/fs/pramfs/ioctl.c b/fs/pramfs/ioctl.c
new file mode 100644
index 0000000..565cc46
--- /dev/null
+++ b/fs/pramfs/ioctl.c
@@ -0,0 +1,127 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Ioctl operations.
+ *
+ * Copyright 2010-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/capability.h>
+#include <linux/time.h>
+#include <linux/sched.h>
+#include <linux/compat.h>
+#include <linux/mount.h>
+#include "pram.h"
+
+long pram_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = file_inode(filp);
+	struct pram_inode *pi;
+	unsigned int flags;
+	int ret;
+
+	pi = pram_get_inode(inode->i_sb, inode->i_ino);
+	if (!pi)
+		return -EACCES;
+
+	switch (cmd) {
+	case FS_IOC_GETFLAGS:
+		flags = be32_to_cpu(pi->i_flags) & PRAM_FL_USER_VISIBLE;
+		return put_user(flags, (int __user *) arg);
+	case FS_IOC_SETFLAGS: {
+		unsigned int oldflags;
+
+		ret = mnt_want_write_file(filp);
+		if (ret)
+			return ret;
+
+		if (!inode_owner_or_capable(inode)) {
+			ret = -EPERM;
+			goto flags_out;
+		}
+
+		if (get_user(flags, (int __user *) arg)) {
+			ret = -EFAULT;
+			goto flags_out;
+		}
+
+		mutex_lock(&inode->i_mutex);
+		oldflags = be32_to_cpu(pi->i_flags);
+
+		if ((flags ^ oldflags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
+			if (!capable(CAP_LINUX_IMMUTABLE)) {
+				mutex_unlock(&inode->i_mutex);
+				ret = -EPERM;
+				goto flags_out;
+			}
+		}
+
+		if (!S_ISDIR(inode->i_mode))
+			flags &= ~FS_DIRSYNC_FL;
+
+		flags = flags & FS_FL_USER_MODIFIABLE;
+		flags |= oldflags & ~FS_FL_USER_MODIFIABLE;
+		pram_memunlock_inode(inode->i_sb, pi);
+		pi->i_flags = cpu_to_be32(flags);
+		inode->i_ctime = CURRENT_TIME_SEC;
+		pi->i_ctime = cpu_to_be32(inode->i_ctime.tv_sec);
+		pram_set_inode_flags(inode, pi);
+		pram_memlock_inode(inode->i_sb, pi);
+		mutex_unlock(&inode->i_mutex);
+flags_out:
+		mnt_drop_write_file(filp);
+		return ret;
+	}
+	case FS_IOC_GETVERSION:
+		return put_user(inode->i_generation, (int __user *) arg);
+	case FS_IOC_SETVERSION: {
+		__u32 generation;
+		if (!inode_owner_or_capable(inode))
+			return -EPERM;
+		ret = mnt_want_write_file(filp);
+		if (ret)
+			return ret;
+		if (get_user(generation, (int __user *) arg)) {
+			ret = -EFAULT;
+			goto setversion_out;
+		}
+		mutex_lock(&inode->i_mutex);
+		inode->i_ctime = CURRENT_TIME_SEC;
+		inode->i_generation = generation;
+		pram_update_inode(inode);
+		mutex_unlock(&inode->i_mutex);
+setversion_out:
+		mnt_drop_write_file(filp);
+		return ret;
+	}
+	default:
+		return -ENOTTY;
+	}
+}
+
+#ifdef CONFIG_COMPAT
+long pram_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case FS_IOC32_GETFLAGS:
+		cmd = FS_IOC_GETFLAGS;
+		break;
+	case FS_IOC32_SETFLAGS:
+		cmd = FS_IOC_SETFLAGS;
+		break;
+	case FS_IOC32_GETVERSION:
+		cmd = FS_IOC_GETVERSION;
+		break;
+	case FS_IOC32_SETVERSION:
+		cmd = FS_IOC_SETVERSION;
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+	return pram_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
+}
+#endif
-- 
1.7.3.4
