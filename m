Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaJRPVo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 11:21:44 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:25396 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbaJRPVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 11:21:42 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
        Dmitry Monakhov <dmonakhov@openvz.org>, tyhicks@canonical.com,
        ecryptfs@vger.kernel.org
Subject: [PATCH 3/4] ecryptfs: add fadvise/set_flags calbacks
Date: Sat, 18 Oct 2014 19:21:27 +0400
Message-Id: <1413645688-13524-4-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413645688-13524-1-git-send-email-dmonakhov@openvz.org>
References: <1413645688-13524-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: tyhicks@canonical.com
CC: ecryptfs@vger.kernel.org
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ecryptfs/file.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 4ffa35e..c84df35 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -31,6 +31,7 @@
 #include <linux/security.h>
 #include <linux/compat.h>
 #include <linux/fs_stack.h>
+#include <linux/fadvise.h>
 #include <linux/aio.h>
 #include "ecryptfs_kernel.h"
 
@@ -333,6 +334,63 @@ ecryptfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 }
 #endif
 
+static int
+ecryptfs_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
+{
+	struct file *lower_file = NULL;
+	long rc = 0;
+
+	if (ecryptfs_file_to_private(file))
+		lower_file = ecryptfs_file_to_lower(file);
+
+	if (!lower_file || !lower_file->f_op)
+		return rc;
+
+	if (lower_file->f_op && lower_file->f_op->fadvise)
+		rc = lower_file->f_op->fadvise(lower_file, offset, len, advice);
+	else
+		rc = generic_fadvise(lower_file, offset, len, advice);
+	if (!rc)
+		generic_fadvise(file, offset, len, advice);
+
+	return rc;
+}
+
+#define ECRYPTFS_FL_MASK (O_NONBLOCK | O_NDELAY | O_NOATIME)
+static int ecryptfs_set_flags(struct file *file, unsigned flags)
+{
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
+	struct dentry *ecryptfs_dentry = file->f_path.dentry;
+	struct file *lower_file = NULL;
+	int rc = 0;
+
+	mount_crypt_stat = &ecryptfs_superblock_to_private(
+		ecryptfs_dentry->d_sb)->mount_crypt_stat;
+	if ((mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED)
+	    && (flags & O_APPEND)) {
+		printk(KERN_WARNING "Mount has encrypted view enabled; "
+		       "files may only be read\n");
+		rc = -EPERM;
+		goto out;
+	}
+
+	if (ecryptfs_file_to_private(file))
+		lower_file = ecryptfs_file_to_lower(file);
+	if (!lower_file)
+		goto out;
+
+	if (lower_file->f_op && lower_file->f_op->set_flags) {
+		rc = lower_file->f_op->set_flags(lower_file,
+						 flags & ECRYPTFS_FL_MASK);
+		if (rc)
+			return rc;
+	} else
+		generic_file_set_flags(file, flags & ECRYPTFS_FL_MASK);
+
+	generic_file_set_flags(file, flags & ECRYPTFS_FL_MASK);
+out:
+	return rc;
+}
 const struct file_operations ecryptfs_dir_fops = {
 	.iterate = ecryptfs_readdir,
 	.read = generic_read_dir,
@@ -347,6 +405,8 @@ const struct file_operations ecryptfs_dir_fops = {
 	.fasync = ecryptfs_fasync,
 	.splice_read = generic_file_splice_read,
 	.llseek = default_llseek,
+	.set_flags = ecryptfs_set_flags,
+	.fadvise = ecryptfs_fadvise,
 };
 
 const struct file_operations ecryptfs_main_fops = {
@@ -367,4 +427,6 @@ const struct file_operations ecryptfs_main_fops = {
 	.fsync = ecryptfs_fsync,
 	.fasync = ecryptfs_fasync,
 	.splice_read = generic_file_splice_read,
+	.set_flags = ecryptfs_set_flags,
+	.fadvise = ecryptfs_fadvise,
 };
-- 
1.7.1

