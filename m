Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaBCQzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:55:21 -0500
Received: from sh.osrg.net ([192.16.179.4]:59555 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbaBCQzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:55:16 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-nilfs <linux-nilfs@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Andreas Rohner <andreas.rohner@gmx.net>
Subject: [PATCH 4/4] nilfs2: implementation of NILFS_IOCTL_SET_SUINFO ioctl
Date: Tue,  4 Feb 2014 01:50:44 +0900
Message-Id: <1391446244-1435-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1391446244-1435-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1391446244-1435-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20100215(IM150)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (sh.osrg.net [192.16.179.4]); Tue, 04 Feb 2014 01:55:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Rohner <andreas.rohner@gmx.net>

With this ioctl the segment usage entries in the SUFILE can be
updated from userspace.

This is useful, because it allows the userspace GC to modify and update
segment usage entries for specific segments, which enables it to avoid
unnecessary write operations.

If a segment needs to be cleaned, but there is no or very little
reclaimable space in it, the cleaning operation basically degrades to
a useless moving operation. In the end the only thing that changes is
the location of the data and a timestamp in the segment usage
information. With this ioctl the GC can skip the cleaning and update
the segment usage entries directly instead.

This is basically a shortcut to cleaning the segment. It is still
necessary to read the segment summary information, but the writing of
the live blocks can be skipped if it's not worth it.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/ioctl.c         |   92 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/nilfs2_fs.h |    2 +
 2 files changed, 94 insertions(+)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 2b34021..c19a231 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1163,6 +1163,95 @@ static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
 	return ret;
 }
 
+/**
+ * nilfs_ioctl_set_suinfo - set segment usage info
+ * @inode: inode object
+ * @filp: file object
+ * @cmd: ioctl's request code
+ * @argp: pointer on argument from userspace
+ *
+ * Description: Expects an array of nilfs_suinfo_update structures
+ * encapsulated in nilfs_argv and updates the segment usage info
+ * according to the flags in nilfs_suinfo_update.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the
+ * following negative error codes is returned.
+ *
+ * %-EPERM - Not enough permissions
+ *
+ * %-EFAULT - Error copying input data
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-EINVAL - Invalid values in input (segment number, flags or nblocks)
+ */
+static int nilfs_ioctl_set_suinfo(struct inode *inode, struct file *filp,
+				unsigned int cmd, void __user *argp)
+{
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct nilfs_transaction_info ti;
+	struct nilfs_argv argv;
+	size_t len;
+	void __user *base;
+	void *kbuf;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = mnt_want_write_file(filp);
+	if (ret)
+		return ret;
+
+	ret = -EFAULT;
+	if (copy_from_user(&argv, argp, sizeof(argv)))
+		goto out;
+
+	ret = -EINVAL;
+	if (argv.v_size < sizeof(struct nilfs_suinfo_update))
+		goto out;
+
+	if (argv.v_nmembs > nilfs->ns_nsegments)
+		goto out;
+
+	if (argv.v_nmembs >= UINT_MAX / argv.v_size)
+		goto out;
+
+	len = argv.v_size * argv.v_nmembs;
+	if (!len) {
+		ret = 0;
+		goto out;
+	}
+
+	base = (void __user *)(unsigned long)argv.v_base;
+	kbuf = vmalloc(len);
+	if (!kbuf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (copy_from_user(kbuf, base, len)) {
+		ret = -EFAULT;
+		goto out_free;
+	}
+
+	nilfs_transaction_begin(inode->i_sb, &ti, 0);
+	ret = nilfs_sufile_set_suinfo(nilfs->ns_sufile, kbuf, argv.v_size,
+			argv.v_nmembs);
+	if (unlikely(ret < 0))
+		nilfs_transaction_abort(inode->i_sb);
+	else
+		nilfs_transaction_commit(inode->i_sb); /* never fails */
+
+out_free:
+	vfree(kbuf);
+out:
+	mnt_drop_write_file(filp);
+	return ret;
+}
+
 long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -1189,6 +1278,8 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return nilfs_ioctl_get_info(inode, filp, cmd, argp,
 					    sizeof(struct nilfs_suinfo),
 					    nilfs_ioctl_do_get_suinfo);
+	case NILFS_IOCTL_SET_SUINFO:
+		return nilfs_ioctl_set_suinfo(inode, filp, cmd, argp);
 	case NILFS_IOCTL_GET_SUSTAT:
 		return nilfs_ioctl_get_sustat(inode, filp, cmd, argp);
 	case NILFS_IOCTL_GET_VINFO:
@@ -1228,6 +1319,7 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case NILFS_IOCTL_GET_CPINFO:
 	case NILFS_IOCTL_GET_CPSTAT:
 	case NILFS_IOCTL_GET_SUINFO:
+	case NILFS_IOCTL_SET_SUINFO:
 	case NILFS_IOCTL_GET_SUSTAT:
 	case NILFS_IOCTL_GET_VINFO:
 	case NILFS_IOCTL_GET_BDESCS:
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 2526578..1fb465f 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -905,5 +905,7 @@ struct nilfs_bdesc {
 	_IOW(NILFS_IOCTL_IDENT, 0x8B, __u64)
 #define NILFS_IOCTL_SET_ALLOC_RANGE  \
 	_IOW(NILFS_IOCTL_IDENT, 0x8C, __u64[2])
+#define NILFS_IOCTL_SET_SUINFO  \
+	_IOW(NILFS_IOCTL_IDENT, 0x8D, struct nilfs_argv)
 
 #endif	/* _LINUX_NILFS_FS_H */
-- 
1.7.9.3

