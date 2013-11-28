Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719Ab3K1UDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 15:03:14 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:53471 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733Ab3K1TzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:03 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/34] sysfs, kernfs: prepare open, release, poll paths for kernfs
Date: Thu, 28 Nov 2013 14:54:19 -0500
Message-Id: <1385668487-10181-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're in the process of separating out core sysfs functionality into
kernfs which will deal with sysfs_dirents directly.  This patch
prepares the rest - open, release and poll.  There isn't much to do.
Just renaming is enough.  As sysfs_file_operations and
sysfs_bin_operations are identical now, use the same file_operations
for both - kernfs_file_operations.

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c  | 24 +++++++-----------------
 fs/sysfs/inode.c |  4 ++--
 fs/sysfs/sysfs.h |  3 +--
 3 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 2e24e89..a43df04 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -668,7 +668,7 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 	kfree(od);
 }
 
-static int sysfs_open_file(struct inode *inode, struct file *file)
+static int kernfs_file_open(struct inode *inode, struct file *file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->priv;
@@ -771,7 +771,7 @@ err_out:
 	return error;
 }
 
-static int sysfs_release(struct inode *inode, struct file *filp)
+static int kernfs_file_release(struct inode *inode, struct file *filp)
 {
 	struct sysfs_dirent *sd = filp->f_path.dentry->d_fsdata;
 	struct sysfs_open_file *of = sysfs_of(filp);
@@ -822,7 +822,7 @@ void sysfs_unmap_bin_file(struct sysfs_dirent *sd)
  * to see if it supports poll (Neither 'poll' nor 'select' return
  * an appropriate error code).  When in doubt, set a suitable timeout value.
  */
-static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
+static unsigned int kernfs_file_poll(struct file *filp, poll_table *wait)
 {
 	struct sysfs_open_file *of = sysfs_of(filp);
 	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
@@ -881,24 +881,14 @@ void sysfs_notify(struct kobject *k, const char *dir, const char *attr)
 }
 EXPORT_SYMBOL_GPL(sysfs_notify);
 
-const struct file_operations sysfs_file_operations = {
+const struct file_operations kernfs_file_operations = {
 	.read		= kernfs_file_read,
 	.write		= kernfs_file_write,
 	.llseek		= generic_file_llseek,
 	.mmap		= kernfs_file_mmap,
-	.open		= sysfs_open_file,
-	.release	= sysfs_release,
-	.poll		= sysfs_poll,
-};
-
-const struct file_operations sysfs_bin_operations = {
-	.read		= kernfs_file_read,
-	.write		= kernfs_file_write,
-	.llseek		= generic_file_llseek,
-	.mmap		= kernfs_file_mmap,
-	.open		= sysfs_open_file,
-	.release	= sysfs_release,
-	.poll		= sysfs_poll,
+	.open		= kernfs_file_open,
+	.release	= kernfs_file_release,
+	.poll		= kernfs_file_poll,
 };
 
 int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 81cc858..4c463da 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -272,12 +272,12 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 		break;
 	case SYSFS_KOBJ_ATTR:
 		inode->i_size = PAGE_SIZE;
-		inode->i_fop = &sysfs_file_operations;
+		inode->i_fop = &kernfs_file_operations;
 		break;
 	case SYSFS_KOBJ_BIN_ATTR:
 		bin_attr = sd->priv;
 		inode->i_size = bin_attr->size;
-		inode->i_fop = &sysfs_bin_operations;
+		inode->i_fop = &kernfs_file_operations;
 		break;
 	case SYSFS_KOBJ_LINK:
 		inode->i_op = &sysfs_symlink_inode_operations;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 9ac234e..619250d 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -212,8 +212,7 @@ int sysfs_inode_init(void);
 /*
  * file.c
  */
-extern const struct file_operations sysfs_file_operations;
-extern const struct file_operations sysfs_bin_operations;
+extern const struct file_operations kernfs_file_operations;
 
 int sysfs_add_file(struct sysfs_dirent *dir_sd,
 		   const struct attribute *attr, int type);
-- 
1.8.4.2

