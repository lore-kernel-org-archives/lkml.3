Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab3JXPts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:49:48 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:58432 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab3JXPtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:49:46 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/34] sysfs: merge sysfs_elem_bin_attr into sysfs_elem_attr
Date: Thu, 24 Oct 2013 11:49:07 -0400
Message-Id: <1382629780-10006-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382629780-10006-1-git-send-email-tj@kernel.org>
References: <1382629780-10006-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3124eb1679 ("sysfs: merge regular and bin file handling") folded bin
file handling into regular file handling.  Among other things, bin
file now shares the same open path including sysfs_open_dirent
association using sysfs_dirent->s_attr.open.  This is buggy because
->s_bin_attr lives in the same union and doesn't have the field.  This
bug doesn't trigger because sysfs_elem_bin_attr doesn't have an active
field at the conflicting position.  It does have a field "buffers" but
it isn't used anymore.

This patch collapses sysfs_elem_bin_attr into sysfs_elem_attr so that
the bin_attr is accessed through ->s_attr.bin_attr which lives with
->s_attr.attr in an anonymous union.  The code paths already assume
bin_attr contains attr as the first element, so this doesn't add any
more assumptions while making it explicit that the two types are
handled together.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c  |  8 ++++----
 fs/sysfs/inode.c |  2 +-
 fs/sysfs/sysfs.h | 11 ++++-------
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index c379597..0d7368d4 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -154,7 +154,7 @@ static ssize_t sysfs_bin_read(struct file *file, char __user *userbuf,
 			      size_t bytes, loff_t *off)
 {
 	struct sysfs_open_file *of = sysfs_of(file);
-	struct bin_attribute *battr = of->sd->s_bin_attr.bin_attr;
+	struct bin_attribute *battr = of->sd->s_attr.bin_attr;
 	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
 	loff_t size = file_inode(file)->i_size;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
@@ -236,7 +236,7 @@ static int flush_write_buffer(struct sysfs_open_file *of, char *buf, loff_t off,
 	}
 
 	if (sysfs_is_bin(of->sd)) {
-		struct bin_attribute *battr = of->sd->s_bin_attr.bin_attr;
+		struct bin_attribute *battr = of->sd->s_attr.bin_attr;
 
 		rc = -EIO;
 		if (battr->write)
@@ -466,7 +466,7 @@ static const struct vm_operations_struct sysfs_bin_vm_ops = {
 static int sysfs_bin_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct sysfs_open_file *of = sysfs_of(file);
-	struct bin_attribute *battr = of->sd->s_bin_attr.bin_attr;
+	struct bin_attribute *battr = of->sd->s_attr.bin_attr;
 	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
 	int rc;
 
@@ -618,7 +618,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 		return -ENODEV;
 
 	if (sysfs_is_bin(attr_sd)) {
-		struct bin_attribute *battr = attr_sd->s_bin_attr.bin_attr;
+		struct bin_attribute *battr = attr_sd->s_attr.bin_attr;
 
 		has_read = battr->read || battr->mmap;
 		has_write = battr->write || battr->mmap;
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 2cb1b6b..825c556 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -258,7 +258,7 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 		inode->i_fop = &sysfs_file_operations;
 		break;
 	case SYSFS_KOBJ_BIN_ATTR:
-		bin_attr = sd->s_bin_attr.bin_attr;
+		bin_attr = sd->s_attr.bin_attr;
 		inode->i_size = bin_attr->size;
 		inode->i_fop = &sysfs_bin_operations;
 		break;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 94ac8fa..c095d952 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -29,15 +29,13 @@ struct sysfs_elem_symlink {
 };
 
 struct sysfs_elem_attr {
-	struct attribute	*attr;
+	union {
+		struct attribute	*attr;
+		struct bin_attribute	*bin_attr;
+	};
 	struct sysfs_open_dirent *open;
 };
 
-struct sysfs_elem_bin_attr {
-	struct bin_attribute	*bin_attr;
-	struct hlist_head	buffers;
-};
-
 struct sysfs_inode_attrs {
 	struct iattr	ia_iattr;
 	void		*ia_secdata;
@@ -74,7 +72,6 @@ struct sysfs_dirent {
 		struct sysfs_elem_dir		s_dir;
 		struct sysfs_elem_symlink	s_symlink;
 		struct sysfs_elem_attr		s_attr;
-		struct sysfs_elem_bin_attr	s_bin_attr;
 	};
 
 	unsigned short		s_flags;
-- 
1.8.3.1

