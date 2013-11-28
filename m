Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637Ab3K1UCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 15:02:17 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:42484 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab3K1TzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:07 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/34] sysfs, kernfs: add sysfs_dirent->s_attr.size
Date: Thu, 28 Nov 2013 14:54:22 -0500
Message-Id: <1385668487-10181-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs sets the size of regular files unconditionally at PAGE_SIZE and
takes the size of bin files from bin_attribute.  The latter is a
pretty bad interface which forces bin_attribute users to create a
separate copy of bin_attribute for each instance of the file -
e.g. pci resource files.

Add sysfs_dirent->s_attr.size so that the size can be specified
separately.  This unifies inode init paths of ATTR and BIN_ATTR
identical and allows for generic size handling for kernfs.

Unfortunately, this grows the size of sysfs_dirent by sizeof(loff_t).

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c  | 6 ++++++
 fs/sysfs/inode.c | 8 +-------
 fs/sysfs/sysfs.h | 1 +
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index cbebc33..0b0cec8 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -923,6 +923,7 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 	const struct kernfs_ops *ops;
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
+	loff_t size;
 	int rc;
 
 	if (type == SYSFS_KOBJ_ATTR) {
@@ -943,6 +944,8 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 			ops = &sysfs_file_kfops_wo;
 		else
 			ops = &sysfs_file_kfops_empty;
+
+		size = PAGE_SIZE;
 	} else {
 		struct bin_attribute *battr = (void *)attr;
 
@@ -954,6 +957,8 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 			ops = &sysfs_bin_kfops_wo;
 		else
 			ops = &sysfs_file_kfops_empty;
+
+		size = battr->size;
 	}
 
 	sd = sysfs_new_dirent(attr->name, mode, type);
@@ -961,6 +966,7 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 		return -ENOMEM;
 
 	sd->s_attr.ops = ops;
+	sd->s_attr.size = size;
 	sd->s_ns = ns;
 	sd->priv = (void *)attr;
 	sysfs_dirent_init_lockdep(sd);
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 4c463da..037a892 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -254,8 +254,6 @@ int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 
 static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 {
-	struct bin_attribute *bin_attr;
-
 	inode->i_private = sysfs_get(sd);
 	inode->i_mapping->a_ops = &sysfs_aops;
 	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
@@ -271,12 +269,8 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 		inode->i_fop = &sysfs_dir_operations;
 		break;
 	case SYSFS_KOBJ_ATTR:
-		inode->i_size = PAGE_SIZE;
-		inode->i_fop = &kernfs_file_operations;
-		break;
 	case SYSFS_KOBJ_BIN_ATTR:
-		bin_attr = sd->priv;
-		inode->i_size = bin_attr->size;
+		inode->i_size = sd->s_attr.size;
 		inode->i_fop = &kernfs_file_operations;
 		break;
 	case SYSFS_KOBJ_LINK:
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index c05e0dd..d40e85e 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -29,6 +29,7 @@ struct sysfs_elem_symlink {
 struct sysfs_elem_attr {
 	const struct kernfs_ops	*ops;
 	struct sysfs_open_dirent *open;
+	loff_t			size;
 };
 
 struct sysfs_inode_attrs {
-- 
1.8.4.2

