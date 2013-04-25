Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab3DYWYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:24:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955Ab3DYWYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:24:15 -0400
Subject: [PATCH 1/2] vfio: Convert container->group_lock to rwsem
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com
Date: Thu, 25 Apr 2013 16:24:14 -0600
Message-ID: <20130425222414.14023.76000.stgit@bling.home>
In-Reply-To: <20130425221546.14023.37372.stgit@bling.home>
References: <20130425221546.14023.37372.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All current users are writers, maintaining current mutual exclusion.
This lets us add read users next.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 21eddd9..073788e 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -57,7 +58,7 @@ struct vfio_iommu_driver {
 struct vfio_container {
 	struct kref			kref;
 	struct list_head		group_list;
-	struct mutex			group_lock;
+	struct rw_semaphore		group_lock;
 	struct vfio_iommu_driver	*iommu_driver;
 	void				*iommu_data;
 };
@@ -738,7 +739,7 @@ static long vfio_ioctl_check_extension(struct vfio_container *container,
 	return ret;
 }
 
-/* hold container->group_lock */
+/* hold write lock on container->group_lock */
 static int __vfio_container_attach_groups(struct vfio_container *container,
 					  struct vfio_iommu_driver *driver,
 					  void *data)
@@ -769,7 +770,7 @@ static long vfio_ioctl_set_iommu(struct vfio_container *container,
 	struct vfio_iommu_driver *driver;
 	long ret = -ENODEV;
 
-	mutex_lock(&container->group_lock);
+	down_write(&container->group_lock);
 
 	/*
 	 * The container is designed to be an unprivileged interface while
@@ -780,7 +781,7 @@ static long vfio_ioctl_set_iommu(struct vfio_container *container,
 	 * the container is deprivileged and returns to an unset state.
 	 */
 	if (list_empty(&container->group_list) || container->iommu_driver) {
-		mutex_unlock(&container->group_lock);
+		up_write(&container->group_lock);
 		return -EINVAL;
 	}
 
@@ -827,7 +828,7 @@ static long vfio_ioctl_set_iommu(struct vfio_container *container,
 
 	mutex_unlock(&vfio.iommu_drivers_lock);
 skip_drivers_unlock:
-	mutex_unlock(&container->group_lock);
+	up_write(&container->group_lock);
 
 	return ret;
 }
@@ -882,7 +883,7 @@ static int vfio_fops_open(struct inode *inode, struct file *filep)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&container->group_list);
-	mutex_init(&container->group_lock);
+	init_rwsem(&container->group_lock);
 	kref_init(&container->kref);
 
 	filep->private_data = container;
@@ -961,7 +962,7 @@ static void __vfio_group_unset_container(struct vfio_group *group)
 	struct vfio_container *container = group->container;
 	struct vfio_iommu_driver *driver;
 
-	mutex_lock(&container->group_lock);
+	down_write(&container->group_lock);
 
 	driver = container->iommu_driver;
 	if (driver)
@@ -979,7 +980,7 @@ static void __vfio_group_unset_container(struct vfio_group *group)
 		container->iommu_data = NULL;
 	}
 
-	mutex_unlock(&container->group_lock);
+	up_write(&container->group_lock);
 
 	vfio_container_put(container);
 }
@@ -1039,7 +1040,7 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 	container = f.file->private_data;
 	WARN_ON(!container); /* fget ensures we don't race vfio_release */
 
-	mutex_lock(&container->group_lock);
+	down_write(&container->group_lock);
 
 	driver = container->iommu_driver;
 	if (driver) {
@@ -1057,7 +1058,7 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 	atomic_inc(&group->container_users);
 
 unlock_out:
-	mutex_unlock(&container->group_lock);
+	up_write(&container->group_lock);
 	fdput(f);
 	return ret;
 }

