Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3A1JzC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:55:02 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:20357 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab3A1Jyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:54:55 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Blue Swirl <blauwirbel@gmail.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/3] VFIO: Wrappers for getting/putting reference to
 vfio_device
Thread-Topic: [PATCH v2 1/3] VFIO: Wrappers for getting/putting reference to
 vfio_device
Thread-Index: AQHN/T15+xIQxThFMk2st/x5WGLB8g==
Date: Mon, 28 Jan 2013 09:54:34 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C9014A7BD5@G9W0717.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	- Added vfio_device_get_from_vdev(), vfio_device_put_vdev()
          as wrappers to get/put reference to vfio_device from struct device.

	- Added vfio_device_data() as a wrapper to get device_data from
          vfio_device.

Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
---
 drivers/vfio/vfio.c  | 47 +++++++++++++++++++++++++++++++++++++++++------
 include/linux/vfio.h |  3 +++
 2 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 12c264d..c2ff1b2 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -642,8 +642,13 @@ int vfio_add_group_dev(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(vfio_add_group_dev);
 
-/* Test whether a struct device is present in our tracking */
-static bool vfio_dev_present(struct device *dev)
+/**
+ * This does a get on the corresponding iommu_group,
+ * vfio_group and the vfio_device. Callers of this
+ * function will hae to call vfio_put_vdev() to
+ * remove the reference to all objects.
+ */
+void *vfio_device_get_from_dev(struct device *dev)
 {
 	struct iommu_group *iommu_group;
 	struct vfio_group *group;
@@ -651,25 +656,55 @@ static bool vfio_dev_present(struct device *dev)
 
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
 	if (!device) {
 		vfio_group_put(group);
 		iommu_group_put(iommu_group);
-		return false;
+		return NULL;
 	}
+	return device;
+}
+EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
+
+void *vfio_device_data(void *data)
+{
+	struct vfio_device *device = data;
+	return device->device_data;
+}
+EXPORT_SYMBOL_GPL(vfio_device_data);
+
+void vfio_device_put_vdev(void *data)
+{
+	struct vfio_device *device = data;
+	struct vfio_group *group = device->group;
+	struct iommu_group *iommu_group = group->iommu_group;
 
 	vfio_device_put(device);
 	vfio_group_put(group);
 	iommu_group_put(iommu_group);
-	return true;
+	return;
+}
+EXPORT_SYMBOL_GPL(vfio_device_put_vdev);
+
+/* Test whether a struct device is present in our tracking */
+static bool vfio_dev_present(struct device *dev)
+{
+	struct vfio_device *device;
+
+	device = vfio_device_get_from_dev(dev);
+	if (device) {
+		vfio_device_put_vdev(device);
+		return true;
+	} else
+		return false;
 }
 
 /*
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ab9e862..e550c09 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -45,6 +45,9 @@ extern int vfio_add_group_dev(struct device *dev,
 			      void *device_data);
 
 extern void *vfio_del_group_dev(struct device *dev);
+extern void *vfio_device_get_from_dev(struct device *dev);
+extern void vfio_device_put_vdev(void *device);
+extern void *vfio_device_data(void *device);
 
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
-- 
1.7.11.3

