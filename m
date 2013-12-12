Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3LLSrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:47:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab3LLSrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:47:25 -0500
Subject: [PATCH 2/2] vfio: Convert control interface to misc driver
To: alex.williamson@redhat.com, kvm@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 12 Dec 2013 11:47:23 -0700
Message-ID: <20131212184723.966.63869.stgit@bling.home>
In-Reply-To: <20131212184402.966.34502.stgit@bling.home>
References: <20131212184402.966.34502.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change allows us to support module auto loading using devname
support in userspace tools.  With this, /dev/vfio/vfio will always
be present and opening it will cause the vfio module to load.  This
should avoid needing to configure the system to statically load
vfio in order to get libvirt to correctly detect support for it.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c |   70 ++++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 37 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 1eab4ac..21271d8 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -22,6 +22,7 @@
 #include <linux/idr.h>
 #include <linux/iommu.h>
 #include <linux/list.h>
+#include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
@@ -45,9 +46,7 @@ static struct vfio {
 	struct idr			group_idr;
 	struct mutex			group_lock;
 	struct cdev			group_cdev;
-	struct device			*dev;
-	dev_t				devt;
-	struct cdev			cdev;
+	dev_t				group_devt;
 	wait_queue_head_t		release_q;
 } vfio;
 
@@ -142,8 +141,7 @@ EXPORT_SYMBOL_GPL(vfio_unregister_iommu_driver);
  */
 static int vfio_alloc_group_minor(struct vfio_group *group)
 {
-	/* index 0 is used by /dev/vfio/vfio */
-	return idr_alloc(&vfio.group_idr, group, 1, MINORMASK + 1, GFP_KERNEL);
+	return idr_alloc(&vfio.group_idr, group, 0, MINORMASK + 1, GFP_KERNEL);
 }
 
 static void vfio_free_group_minor(int minor)
@@ -243,7 +241,8 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)
 		}
 	}
 
-	dev = device_create(vfio.class, NULL, MKDEV(MAJOR(vfio.devt), minor),
+	dev = device_create(vfio.class, NULL,
+			    MKDEV(MAJOR(vfio.group_devt), minor),
 			    group, "%d", iommu_group_id(iommu_group));
 	if (IS_ERR(dev)) {
 		vfio_free_group_minor(minor);
@@ -268,7 +267,7 @@ static void vfio_group_release(struct kref *kref)
 
 	WARN_ON(!list_empty(&group->device_list));
 
-	device_destroy(vfio.class, MKDEV(MAJOR(vfio.devt), group->minor));
+	device_destroy(vfio.class, MKDEV(MAJOR(vfio.group_devt), group->minor));
 	list_del(&group->vfio_next);
 	vfio_free_group_minor(group->minor);
 	vfio_group_unlock_and_free(group);
@@ -1419,12 +1418,17 @@ EXPORT_SYMBOL_GPL(vfio_external_user_iommu_id);
  */
 static char *vfio_devnode(struct device *dev, umode_t *mode)
 {
-	if (mode && (MINOR(dev->devt) == 0))
-		*mode = S_IRUGO | S_IWUGO;
-
 	return kasprintf(GFP_KERNEL, "vfio/%s", dev_name(dev));
 }
 
+static struct miscdevice vfio_dev = {
+	.minor = VFIO_MINOR,
+	.name = "vfio",
+	.fops = &vfio_fops,
+	.nodename = "vfio/vfio",
+	.mode = S_IRUGO | S_IWUGO,
+};
+
 static int __init vfio_init(void)
 {
 	int ret;
@@ -1436,6 +1440,13 @@ static int __init vfio_init(void)
 	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
 	init_waitqueue_head(&vfio.release_q);
 
+	ret = misc_register(&vfio_dev);
+	if (ret) {
+		pr_err("vfio: misc device register failed\n");
+		return ret;
+	}
+
+	/* /dev/vfio/$GROUP */
 	vfio.class = class_create(THIS_MODULE, "vfio");
 	if (IS_ERR(vfio.class)) {
 		ret = PTR_ERR(vfio.class);
@@ -1444,27 +1455,14 @@ static int __init vfio_init(void)
 
 	vfio.class->devnode = vfio_devnode;
 
-	ret = alloc_chrdev_region(&vfio.devt, 0, MINORMASK, "vfio");
-	if (ret)
-		goto err_base_chrdev;
-
-	cdev_init(&vfio.cdev, &vfio_fops);
-	ret = cdev_add(&vfio.cdev, vfio.devt, 1);
+	ret = alloc_chrdev_region(&vfio.group_devt, 0, MINORMASK, "vfio");
 	if (ret)
-		goto err_base_cdev;
+		goto err_alloc_chrdev;
 
-	vfio.dev = device_create(vfio.class, NULL, vfio.devt, NULL, "vfio");
-	if (IS_ERR(vfio.dev)) {
-		ret = PTR_ERR(vfio.dev);
-		goto err_base_dev;
-	}
-
-	/* /dev/vfio/$GROUP */
 	cdev_init(&vfio.group_cdev, &vfio_group_fops);
-	ret = cdev_add(&vfio.group_cdev,
-		       MKDEV(MAJOR(vfio.devt), 1), MINORMASK - 1);
+	ret = cdev_add(&vfio.group_cdev, vfio.group_devt, MINORMASK);
 	if (ret)
-		goto err_groups_cdev;
+		goto err_cdev_add;
 
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
@@ -1478,16 +1476,13 @@ static int __init vfio_init(void)
 
 	return 0;
 
-err_groups_cdev:
-	device_destroy(vfio.class, vfio.devt);
-err_base_dev:
-	cdev_del(&vfio.cdev);
-err_base_cdev:
-	unregister_chrdev_region(vfio.devt, MINORMASK);
-err_base_chrdev:
+err_cdev_add:
+	unregister_chrdev_region(vfio.group_devt, MINORMASK);
+err_alloc_chrdev:
 	class_destroy(vfio.class);
 	vfio.class = NULL;
 err_class:
+	misc_deregister(&vfio_dev);
 	return ret;
 }
 
@@ -1497,11 +1492,10 @@ static void __exit vfio_cleanup(void)
 
 	idr_destroy(&vfio.group_idr);
 	cdev_del(&vfio.group_cdev);
-	device_destroy(vfio.class, vfio.devt);
-	cdev_del(&vfio.cdev);
-	unregister_chrdev_region(vfio.devt, MINORMASK);
+	unregister_chrdev_region(vfio.group_devt, MINORMASK);
 	class_destroy(vfio.class);
 	vfio.class = NULL;
+	misc_deregister(&vfio_dev);
 }
 
 module_init(vfio_init);
@@ -1511,3 +1505,5 @@ MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_ALIAS_MISCDEV(VFIO_MINOR);
+MODULE_ALIAS("devname:vfio/vfio");

