Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422925AbaKNXhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:37:34 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:38405 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935408AbaKNXgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:36:46 -0500
From: Dmitry Kalinkin <dmitry.kalinkin@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Igor Alekseev <igor.alekseev@itep.ru>,
        Dmitry Kalinkin <dmitry.kalinkin@gmail.com>
Subject: [PATCH 2/3] staging: vme: mmap() support for vme_user
Date: Sat, 15 Nov 2014 02:36:17 +0300
Message-Id: <1416008178-9393-3-git-send-email-dmitry.kalinkin@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1416008178-9393-1-git-send-email-dmitry.kalinkin@gmail.com>
References: <1416008178-9393-1-git-send-email-dmitry.kalinkin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We also make sure that user won't be able to reconfigure the window while it is
mmap'ed.

Signed-off-by: Dmitry Kalinkin <dmitry.kalinkin@gmail.com>
Cc: Igor Alekseev <igor.alekseev@itep.ru>
---
 drivers/staging/vme/devices/vme_user.c | 85 ++++++++++++++++++++++++++++++++++
 drivers/vme/vme.c                      | 26 +++++++++++
 include/linux/vme.h                    |  1 +
 3 files changed, 112 insertions(+)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 8731838..b7fe1f0 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -17,6 +17,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/atomic.h>
 #include <linux/cdev.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -99,6 +100,7 @@ struct image_desc {
 	struct device *device;	/* Sysfs device */
 	struct vme_resource *resource;	/* VME resource */
 	int users;		/* Number of current users */
+	int mmap_count;		/* Number of current mmap's */
 };
 static struct image_desc image[VME_DEVS];
 
@@ -134,6 +136,10 @@ static ssize_t vme_user_write(struct file *, const char __user *, size_t,
 	loff_t *);
 static loff_t vme_user_llseek(struct file *, loff_t, int);
 static long vme_user_unlocked_ioctl(struct file *, unsigned int, unsigned long);
+static int vme_user_mmap(struct file *file, struct vm_area_struct *vma);
+
+static void vme_user_vm_open(struct vm_area_struct *vma);
+static void vme_user_vm_close(struct vm_area_struct *vma);
 
 static int vme_user_match(struct vme_dev *);
 static int vme_user_probe(struct vme_dev *);
@@ -147,6 +153,17 @@ static const struct file_operations vme_user_fops = {
 	.llseek = vme_user_llseek,
 	.unlocked_ioctl = vme_user_unlocked_ioctl,
 	.compat_ioctl = vme_user_unlocked_ioctl,
+	.mmap = vme_user_mmap,
+};
+
+struct vme_user_vma_priv {
+	unsigned int minor;
+	atomic_t refcnt;
+};
+
+static const struct vm_operations_struct vme_user_vm_ops = {
+	.open = vme_user_vm_open,
+	.close = vme_user_vm_close,
 };
 
 
@@ -488,6 +505,11 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 
 		case VME_SET_MASTER:
 
+			if (image[minor].mmap_count != 0) {
+				pr_warn("Can't adjust mapped window\n");
+				return -EPERM;
+			}
+
 			copied = copy_from_user(&master, argp, sizeof(master));
 			if (copied != 0) {
 				pr_warn("Partial copy from userspace\n");
@@ -564,6 +586,69 @@ vme_user_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
+static void vme_user_vm_open(struct vm_area_struct *vma)
+{
+	struct vme_user_vma_priv *vma_priv = vma->vm_private_data;
+
+	atomic_inc(&vma_priv->refcnt);
+}
+
+static void vme_user_vm_close(struct vm_area_struct *vma)
+{
+	struct vme_user_vma_priv *vma_priv = vma->vm_private_data;
+	unsigned int minor = vma_priv->minor;
+
+	if (!atomic_dec_and_test(&vma_priv->refcnt))
+		return;
+
+	mutex_lock(&image[minor].mutex);
+	image[minor].mmap_count--;
+	mutex_unlock(&image[minor].mutex);
+
+	kfree(vma_priv);
+}
+
+static int vme_user_master_mmap(unsigned int minor, struct vm_area_struct *vma)
+{
+	int err;
+	struct vme_user_vma_priv *vma_priv;
+
+	mutex_lock(&image[minor].mutex);
+
+	err = vme_master_mmap(image[minor].resource, vma);
+	if (err) {
+		mutex_unlock(&image[minor].mutex);
+		return err;
+	}
+
+	vma_priv = kmalloc(sizeof(struct vme_user_vma_priv), GFP_KERNEL);
+	if (vma_priv == NULL) {
+		mutex_unlock(&image[minor].mutex);
+		return -ENOMEM;
+	}
+
+	vma_priv->minor = minor;
+	atomic_set(&vma_priv->refcnt, 1);
+	vma->vm_ops = &vme_user_vm_ops;
+	vma->vm_private_data = vma_priv;
+
+	image[minor].mmap_count++;
+
+	mutex_unlock(&image[minor].mutex);
+
+	return 0;
+}
+
+static int vme_user_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	unsigned int minor = MINOR(file->f_dentry->d_inode->i_rdev);
+
+	if (type[minor] == MASTER_MINOR)
+		return vme_user_master_mmap(minor, vma);
+
+	return -ENODEV;
+}
+
 
 /*
  * Unallocate a previously allocated buffer
diff --git a/drivers/vme/vme.c b/drivers/vme/vme.c
index 7516030..3dc62b4 100644
--- a/drivers/vme/vme.c
+++ b/drivers/vme/vme.c
@@ -609,6 +609,32 @@ unsigned int vme_master_rmw(struct vme_resource *resource, unsigned int mask,
 }
 EXPORT_SYMBOL(vme_master_rmw);
 
+int vme_master_mmap(struct vme_resource *resource, struct vm_area_struct *vma)
+{
+	struct vme_master_resource *image;
+	phys_addr_t phys_addr;
+	unsigned long vma_size;
+
+	if (resource->type != VME_MASTER) {
+		printk(KERN_ERR "Not a master resource\n");
+		return -EINVAL;
+	}
+
+	image = list_entry(resource->entry, struct vme_master_resource, list);
+	phys_addr = image->bus_resource.start + (vma->vm_pgoff << PAGE_SHIFT);
+	vma_size = vma->vm_end - vma->vm_start;
+
+	if (phys_addr + vma_size > image->bus_resource.end + 1) {
+		printk(KERN_ERR "Map size cannot exceed the window size\n");
+		return -EFAULT;
+	}
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	return vm_iomap_memory(vma, phys_addr, vma->vm_end - vma->vm_start);
+}
+EXPORT_SYMBOL(vme_master_mmap);
+
 void vme_master_free(struct vme_resource *resource)
 {
 	struct vme_master_resource *master_image;
diff --git a/include/linux/vme.h b/include/linux/vme.h
index 8cd6f19..79242e9 100644
--- a/include/linux/vme.h
+++ b/include/linux/vme.h
@@ -137,6 +137,7 @@ ssize_t vme_master_read(struct vme_resource *, void *, size_t, loff_t);
 ssize_t vme_master_write(struct vme_resource *, void *, size_t, loff_t);
 unsigned int vme_master_rmw(struct vme_resource *, unsigned int, unsigned int,
 	unsigned int, loff_t);
+int vme_master_mmap(struct vme_resource *resource, struct vm_area_struct *vma);
 void vme_master_free(struct vme_resource *);
 
 struct vme_resource *vme_dma_request(struct vme_dev *, u32);
-- 
1.9.1

