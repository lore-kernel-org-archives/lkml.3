Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012Ab3BNKnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:43:15 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:9392 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606Ab3BNKnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:43:12 -0500
From: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
To: alex.williamson@redhat.com, gleb@redhat.com, bhelgaas@google.com,
        blauwirbel@gmail.com, lance.oritz@hp.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
Subject: [PATCH v4 1/3] VFIO: Wrapper for getting reference to vfio_device from device
Date: Thu, 14 Feb 2013 04:41:53 -0600
Message-Id: <1360838515-17558-2-git-send-email-vijaymohan.pandarathil@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1360838515-17558-1-git-send-email-vijaymohan.pandarathil@hp.com>
References: <1360838515-17558-1-git-send-email-vijaymohan.pandarathil@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	- Added vfio_device_get_from_dev() as wrapper to get
          reference to vfio_device from struct device.

	- Added vfio_device_data() as a wrapper to get device_data from
          vfio_device.

Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
---
 drivers/vfio/vfio.c  | 47 ++++++++++++++++++++++++++++++++++-------------
 include/linux/vfio.h |  3 +++
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 12c264d..863d1d3 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -407,12 +407,13 @@ static void vfio_device_release(struct kref *kref)
 }
 
 /* Device reference always implies a group reference */
-static void vfio_device_put(struct vfio_device *device)
+void vfio_device_put(struct vfio_device *device)
 {
 	struct vfio_group *group = device->group;
 	kref_put_mutex(&device->kref, vfio_device_release, &group->device_lock);
 	vfio_group_put(group);
 }
+EXPORT_SYMBOL_GPL(vfio_device_put);
 
 static void vfio_device_get(struct vfio_device *device)
 {
@@ -642,8 +643,12 @@ int vfio_add_group_dev(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(vfio_add_group_dev);
 
-/* Test whether a struct device is present in our tracking */
-static bool vfio_dev_present(struct device *dev)
+/**
+ * This does a get on the vfio_device from device.
+ * Callers of this function will have to call vfio_put_device() to
+ * remove the reference.
+ */
+struct vfio_device *vfio_device_get_from_dev(struct device *dev)
 {
 	struct iommu_group *iommu_group;
 	struct vfio_group *group;
@@ -651,25 +656,41 @@ static bool vfio_dev_present(struct device *dev)
 
 	iommu_group = iommu_group_get(dev);
 	if (!iommu_group)
-		return false;
+		return NULL;
 
 	group = vfio_group_get_from_iommu(iommu_group);
 	if (!group) {
 		iommu_group_put(iommu_group);
-		return false;
+		return NULL;
 	}
 
 	device = vfio_group_get_device(group, dev);
-	if (!device) {
-		vfio_group_put(group);
-		iommu_group_put(iommu_group);
-		return false;
-	}
-
-	vfio_device_put(device);
 	vfio_group_put(group);
 	iommu_group_put(iommu_group);
-	return true;
+	return device;
+}
+EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
+
+/*
+ * Caller must hold a reference to the vfio_device
+ */
+void *vfio_device_data(struct vfio_device *device)
+{
+	return device->device_data;
+}
+EXPORT_SYMBOL_GPL(vfio_device_data);
+
+/* Test whether a struct device is present in our tracking */
+static bool vfio_dev_present(struct device *dev)
+{
+	struct vfio_device *device;
+
+	device = vfio_device_get_from_dev(dev);
+	if (device) {
+		vfio_device_put(device);
+		return true;
+	} else
+		return false;
 }
 
 /*
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ab9e862..ac8d488 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -45,6 +45,9 @@ extern int vfio_add_group_dev(struct device *dev,
 			      void *device_data);
 
 extern void *vfio_del_group_dev(struct device *dev);
+extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
+extern void vfio_device_put(struct vfio_device *device);
+extern void *vfio_device_data(struct vfio_device *device);
 
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
-- 
1.7.11.3

