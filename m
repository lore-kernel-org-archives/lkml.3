Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab3K1TzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:55:14 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:40853 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284Ab3K1TzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:01 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/34] sysfs, kernfs: prepare mmap path for kernfs
Date: Thu, 28 Nov 2013 14:54:18 -0500
Message-Id: <1385668487-10181-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're in the process of separating out core sysfs functionality into
kernfs which will deal with sysfs_dirents directly.  This patch
rearranges mmap path so that the kernfs and sysfs parts are separate.

sysfs_kf_bin_mmap() which handles the interaction with bin_attribute
mmap method is factored out of sysfs_bin_mmap(), which is renamed to
kernfs_file_mmap().  All vma ops are renamed accordingly.

sysfs_bin_mmap() is updated such that it can be used for both file
types.  This will eventually allow using the same file_operations for
both file types, which is necessary to separate out kernfs.

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c | 69 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 39 insertions(+), 30 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 2f849e8..2e24e89 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -361,7 +361,19 @@ out_free:
 	return len;
 }
 
-static void sysfs_bin_vma_open(struct vm_area_struct *vma)
+static int sysfs_kf_bin_mmap(struct sysfs_open_file *of,
+			     struct vm_area_struct *vma)
+{
+	struct bin_attribute *battr = of->sd->priv;
+	struct kobject *kobj = of->sd->s_parent->priv;
+
+	if (!battr->mmap)
+		return -ENODEV;
+
+	return battr->mmap(of->file, kobj, battr, vma);
+}
+
+static void kernfs_vma_open(struct vm_area_struct *vma)
 {
 	struct file *file = vma->vm_file;
 	struct sysfs_open_file *of = sysfs_of(file);
@@ -378,7 +390,7 @@ static void sysfs_bin_vma_open(struct vm_area_struct *vma)
 	sysfs_put_active(of->sd);
 }
 
-static int sysfs_bin_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int kernfs_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
 	struct sysfs_open_file *of = sysfs_of(file);
@@ -398,8 +410,8 @@ static int sysfs_bin_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	return ret;
 }
 
-static int sysfs_bin_page_mkwrite(struct vm_area_struct *vma,
-				  struct vm_fault *vmf)
+static int kernfs_vma_page_mkwrite(struct vm_area_struct *vma,
+				   struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
 	struct sysfs_open_file *of = sysfs_of(file);
@@ -421,8 +433,8 @@ static int sysfs_bin_page_mkwrite(struct vm_area_struct *vma,
 	return ret;
 }
 
-static int sysfs_bin_access(struct vm_area_struct *vma, unsigned long addr,
-			    void *buf, int len, int write)
+static int kernfs_vma_access(struct vm_area_struct *vma, unsigned long addr,
+			     void *buf, int len, int write)
 {
 	struct file *file = vma->vm_file;
 	struct sysfs_open_file *of = sysfs_of(file);
@@ -443,8 +455,8 @@ static int sysfs_bin_access(struct vm_area_struct *vma, unsigned long addr,
 }
 
 #ifdef CONFIG_NUMA
-static int sysfs_bin_set_policy(struct vm_area_struct *vma,
-				struct mempolicy *new)
+static int kernfs_vma_set_policy(struct vm_area_struct *vma,
+				 struct mempolicy *new)
 {
 	struct file *file = vma->vm_file;
 	struct sysfs_open_file *of = sysfs_of(file);
@@ -464,8 +476,8 @@ static int sysfs_bin_set_policy(struct vm_area_struct *vma,
 	return ret;
 }
 
-static struct mempolicy *sysfs_bin_get_policy(struct vm_area_struct *vma,
-					      unsigned long addr)
+static struct mempolicy *kernfs_vma_get_policy(struct vm_area_struct *vma,
+					       unsigned long addr)
 {
 	struct file *file = vma->vm_file;
 	struct sysfs_open_file *of = sysfs_of(file);
@@ -485,8 +497,9 @@ static struct mempolicy *sysfs_bin_get_policy(struct vm_area_struct *vma,
 	return pol;
 }
 
-static int sysfs_bin_migrate(struct vm_area_struct *vma, const nodemask_t *from,
-			     const nodemask_t *to, unsigned long flags)
+static int kernfs_vma_migrate(struct vm_area_struct *vma,
+			      const nodemask_t *from, const nodemask_t *to,
+			      unsigned long flags)
 {
 	struct file *file = vma->vm_file;
 	struct sysfs_open_file *of = sysfs_of(file);
@@ -507,36 +520,31 @@ static int sysfs_bin_migrate(struct vm_area_struct *vma, const nodemask_t *from,
 }
 #endif
 
-static const struct vm_operations_struct sysfs_bin_vm_ops = {
-	.open		= sysfs_bin_vma_open,
-	.fault		= sysfs_bin_fault,
-	.page_mkwrite	= sysfs_bin_page_mkwrite,
-	.access		= sysfs_bin_access,
+static const struct vm_operations_struct kernfs_vm_ops = {
+	.open		= kernfs_vma_open,
+	.fault		= kernfs_vma_fault,
+	.page_mkwrite	= kernfs_vma_page_mkwrite,
+	.access		= kernfs_vma_access,
 #ifdef CONFIG_NUMA
-	.set_policy	= sysfs_bin_set_policy,
-	.get_policy	= sysfs_bin_get_policy,
-	.migrate	= sysfs_bin_migrate,
+	.set_policy	= kernfs_vma_set_policy,
+	.get_policy	= kernfs_vma_get_policy,
+	.migrate	= kernfs_vma_migrate,
 #endif
 };
 
-static int sysfs_bin_mmap(struct file *file, struct vm_area_struct *vma)
+static int kernfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct sysfs_open_file *of = sysfs_of(file);
-	struct bin_attribute *battr = of->sd->priv;
-	struct kobject *kobj = of->sd->s_parent->priv;
 	int rc;
 
 	mutex_lock(&of->mutex);
 
-	/* need of->sd for battr, its parent for kobj */
 	rc = -ENODEV;
 	if (!sysfs_get_active(of->sd))
 		goto out_unlock;
 
-	if (!battr->mmap)
-		goto out_put;
-
-	rc = battr->mmap(file, kobj, battr, vma);
+	if (sysfs_is_bin(of->sd))
+		rc = sysfs_kf_bin_mmap(of, vma);
 	if (rc)
 		goto out_put;
 
@@ -563,7 +571,7 @@ static int sysfs_bin_mmap(struct file *file, struct vm_area_struct *vma)
 	rc = 0;
 	of->mmapped = 1;
 	of->vm_ops = vma->vm_ops;
-	vma->vm_ops = &sysfs_bin_vm_ops;
+	vma->vm_ops = &kernfs_vm_ops;
 out_put:
 	sysfs_put_active(of->sd);
 out_unlock:
@@ -877,6 +885,7 @@ const struct file_operations sysfs_file_operations = {
 	.read		= kernfs_file_read,
 	.write		= kernfs_file_write,
 	.llseek		= generic_file_llseek,
+	.mmap		= kernfs_file_mmap,
 	.open		= sysfs_open_file,
 	.release	= sysfs_release,
 	.poll		= sysfs_poll,
@@ -886,7 +895,7 @@ const struct file_operations sysfs_bin_operations = {
 	.read		= kernfs_file_read,
 	.write		= kernfs_file_write,
 	.llseek		= generic_file_llseek,
-	.mmap		= sysfs_bin_mmap,
+	.mmap		= kernfs_file_mmap,
 	.open		= sysfs_open_file,
 	.release	= sysfs_release,
 	.poll		= sysfs_poll,
-- 
1.8.4.2

