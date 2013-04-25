Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab3DYWYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:24:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130Ab3DYWYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:24:21 -0400
Subject: [PATCH 2/2] vfio: Use down_reads to protect iommu disconnects
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com
Date: Thu, 25 Apr 2013 16:24:20 -0600
Message-ID: <20130425222420.14023.76573.stgit@bling.home>
In-Reply-To: <20130425221546.14023.37372.stgit@bling.home>
References: <20130425221546.14023.37372.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a group or device is released or a container is unset from a group
it can race against file ops on the container.  Protect these with
down_reads to allow concurrent users.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Reported-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vfio/vfio.c |   62 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 073788e..ac7423b 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -704,9 +704,13 @@ EXPORT_SYMBOL_GPL(vfio_del_group_dev);
 static long vfio_ioctl_check_extension(struct vfio_container *container,
 				       unsigned long arg)
 {
-	struct vfio_iommu_driver *driver = container->iommu_driver;
+	struct vfio_iommu_driver *driver;
 	long ret = 0;
 
+	down_read(&container->group_lock);
+
+	driver = container->iommu_driver;
+
 	switch (arg) {
 		/* No base extensions yet */
 	default:
@@ -736,6 +740,8 @@ static long vfio_ioctl_check_extension(struct vfio_container *container,
 						 VFIO_CHECK_EXTENSION, arg);
 	}
 
+	up_read(&container->group_lock);
+
 	return ret;
 }
 
@@ -844,9 +850,6 @@ static long vfio_fops_unl_ioctl(struct file *filep,
 	if (!container)
 		return ret;
 
-	driver = container->iommu_driver;
-	data = container->iommu_data;
-
 	switch (cmd) {
 	case VFIO_GET_API_VERSION:
 		ret = VFIO_API_VERSION;
@@ -858,8 +861,15 @@ static long vfio_fops_unl_ioctl(struct file *filep,
 		ret = vfio_ioctl_set_iommu(container, arg);
 		break;
 	default:
+		down_read(&container->group_lock);
+
+		driver = container->iommu_driver;
+		data = container->iommu_data;
+
 		if (driver) /* passthrough all unrecognized ioctls */
 			ret = driver->ops->ioctl(data, cmd, arg);
+
+		up_read(&container->group_lock);
 	}
 
 	return ret;
@@ -910,35 +920,55 @@ static ssize_t vfio_fops_read(struct file *filep, char __user *buf,
 			      size_t count, loff_t *ppos)
 {
 	struct vfio_container *container = filep->private_data;
-	struct vfio_iommu_driver *driver = container->iommu_driver;
+	struct vfio_iommu_driver *driver;
+	ssize_t ret = -EINVAL;
 
-	if (unlikely(!driver || !driver->ops->read))
-		return -EINVAL;
+	down_read(&container->group_lock);
+
+	driver = container->iommu_driver;
+	if (likely(driver && driver->ops->read))
+		ret = driver->ops->read(container->iommu_data,
+					buf, count, ppos);
 
-	return driver->ops->read(container->iommu_data, buf, count, ppos);
+	up_read(&container->group_lock);
+
+	return ret;
 }
 
 static ssize_t vfio_fops_write(struct file *filep, const char __user *buf,
 			       size_t count, loff_t *ppos)
 {
 	struct vfio_container *container = filep->private_data;
-	struct vfio_iommu_driver *driver = container->iommu_driver;
+	struct vfio_iommu_driver *driver;
+	ssize_t ret = -EINVAL;
 
-	if (unlikely(!driver || !driver->ops->write))
-		return -EINVAL;
+	down_read(&container->group_lock);
+
+	driver = container->iommu_driver;
+	if (likely(driver && driver->ops->write))
+		ret = driver->ops->write(container->iommu_data,
+					 buf, count, ppos);
+
+	up_read(&container->group_lock);
 
-	return driver->ops->write(container->iommu_data, buf, count, ppos);
+	return ret;
 }
 
 static int vfio_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 {
 	struct vfio_container *container = filep->private_data;
-	struct vfio_iommu_driver *driver = container->iommu_driver;
+	struct vfio_iommu_driver *driver;
+	int ret = -EINVAL;
 
-	if (unlikely(!driver || !driver->ops->mmap))
-		return -EINVAL;
+	down_read(&container->group_lock);
 
-	return driver->ops->mmap(container->iommu_data, vma);
+	driver = container->iommu_driver;
+	if (likely(driver && driver->ops->mmap))
+		ret = driver->ops->mmap(container->iommu_data, vma);
+
+	up_read(&container->group_lock);
+
+	return ret;
 }
 
 static const struct file_operations vfio_fops = {

