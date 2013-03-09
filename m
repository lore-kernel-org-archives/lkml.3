Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab3CIHwc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 02:52:32 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:41649 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab3CIHw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 02:52:29 -0500
From: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
To: alex.williamson@redhat.com, gleb@redhat.com, bhelgaas@google.com,
        blauwirbel@gmail.com, lance.oritz@hp.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
Subject: [PATCH v7 1/3] VFIO: Wrapper for getting reference to vfio_device from device
Date: Sat,  9 Mar 2013 01:52:15 -0600
Message-Id: <1362815537-27303-2-git-send-email-vijaymohan.pandarathil@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1362815537-27303-1-git-send-email-vijaymohan.pandarathil@hp.com>
References: <1362815537-27303-1-git-send-email-vijaymohan.pandarathil@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	- Added vfio_device_get_from_dev() as wrapper to get
          reference to vfio_device from struct device.

	- Added vfio_device_data() as a wrapper to get device_data from
          vfio_device.

Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
---
 drivers/vfio/vfio.c  | 30 +++++++++++++++++++++++++++++-
 include/linux/vfio.h |  3 +++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index fcc12f3..21eddd9 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -392,12 +392,13 @@ static void vfio_device_release(struct kref *kref)
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
@@ -627,6 +628,33 @@ int vfio_add_group_dev(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(vfio_add_group_dev);
 
+/**
+ * Get a reference to the vfio_device for a device that is known to
+ * be bound to a vfio driver.  The driver implicitly holds a
+ * vfio_device reference between vfio_add_group_dev and
+ * vfio_del_group_dev.  We can therefore use drvdata to increment
+ * that reference from the struct device.  This additional
+ * reference must be released by calling vfio_device_put.
+ */
+struct vfio_device *vfio_device_get_from_dev(struct device *dev)
+{
+	struct vfio_device *device = dev_get_drvdata(dev);
+
+	vfio_device_get(device);
+
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
 /* Given a referenced group, check if it contains the device */
 static bool vfio_dev_present(struct vfio_group *group, struct device *dev)
 {
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

