Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaK0Re2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:34:28 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:40264 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaK0ReZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:34:25 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v10 07/20] vfio/platform: return info for device memory mapped IO regions
Date: Thu, 27 Nov 2014 18:32:47 +0100
Message-Id: <1417109580-10505-8-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the IOCTLs VFIO_DEVICE_GET_REGION_INFO ioctl call,
which allows the user to learn about the available MMIO resources of
a device.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_common.c  | 106 +++++++++++++++++++++++++-
 drivers/vfio/platform/vfio_platform_private.h |  22 ++++++
 2 files changed, 124 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 862b43b..2a4613c 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -22,17 +22,97 @@
 
 #include "vfio_platform_private.h"
 
+static DEFINE_MUTEX(driver_lock);
+
+static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
+{
+	int cnt = 0, i;
+
+	while (vdev->get_resource(vdev, cnt))
+		cnt++;
+
+	vdev->regions = kcalloc(cnt, sizeof(struct vfio_platform_region),
+				GFP_KERNEL);
+	if (!vdev->regions)
+		return -ENOMEM;
+
+	for (i = 0; i < cnt;  i++) {
+		struct resource *res =
+			vdev->get_resource(vdev, i);
+
+		if (!res)
+			goto err;
+
+		vdev->regions[i].addr = res->start;
+		vdev->regions[i].size = resource_size(res);
+		vdev->regions[i].flags = 0;
+
+		switch (resource_type(res)) {
+		case IORESOURCE_MEM:
+			vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_MMIO;
+			break;
+		case IORESOURCE_IO:
+			vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_PIO;
+			break;
+		default:
+			goto err;
+		}
+	}
+
+	vdev->num_regions = cnt;
+
+	return 0;
+err:
+	kfree(vdev->regions);
+	return -EINVAL;
+}
+
+static void vfio_platform_regions_cleanup(struct vfio_platform_device *vdev)
+{
+	vdev->num_regions = 0;
+	kfree(vdev->regions);
+}
+
 static void vfio_platform_release(void *device_data)
 {
+	struct vfio_platform_device *vdev = device_data;
+
+	mutex_lock(&driver_lock);
+
+	if (!(--vdev->refcnt)) {
+		vfio_platform_regions_cleanup(vdev);
+	}
+
+	mutex_unlock(&driver_lock);
+
 	module_put(THIS_MODULE);
 }
 
 static int vfio_platform_open(void *device_data)
 {
+	struct vfio_platform_device *vdev = device_data;
+	int ret;
+
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
+	mutex_lock(&driver_lock);
+
+	if (!vdev->refcnt) {
+		ret = vfio_platform_regions_init(vdev);
+		if (ret)
+			goto err_reg;
+	}
+
+	vdev->refcnt++;
+
+	mutex_unlock(&driver_lock);
 	return 0;
+
+err_reg:
+	mutex_unlock(&driver_lock);
+	module_put(THIS_MODULE);
+	return ret;
 }
 
 static long vfio_platform_ioctl(void *device_data,
@@ -53,15 +133,33 @@ static long vfio_platform_ioctl(void *device_data,
 			return -EINVAL;
 
 		info.flags = vdev->flags;
-		info.num_regions = 0;
+		info.num_regions = vdev->num_regions;
 		info.num_irqs = 0;
 
 		return copy_to_user((void __user *)arg, &info, minsz);
 
-	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO)
-		return -EINVAL;
+	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
+		struct vfio_region_info info;
+
+		minsz = offsetofend(struct vfio_region_info, offset);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		if (info.index >= vdev->num_regions)
+			return -EINVAL;
+
+		/* map offset to the physical address  */
+		info.offset = VFIO_PLATFORM_INDEX_TO_OFFSET(info.index);
+		info.size = vdev->regions[info.index].size;
+		info.flags = vdev->regions[info.index].flags;
+
+		return copy_to_user((void __user *)arg, &info, minsz);
 
-	else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
+	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
 		return -EINVAL;
 
 	else if (cmd == VFIO_DEVICE_SET_IRQS)
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 062b92d..b24729f 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -15,7 +15,29 @@
 #ifndef VFIO_PLATFORM_PRIVATE_H
 #define VFIO_PLATFORM_PRIVATE_H
 
+#define VFIO_PLATFORM_OFFSET_SHIFT   40
+#define VFIO_PLATFORM_OFFSET_MASK (((u64)(1) << VFIO_PLATFORM_OFFSET_SHIFT) - 1)
+
+#define VFIO_PLATFORM_OFFSET_TO_INDEX(off)	\
+	(off >> VFIO_PLATFORM_OFFSET_SHIFT)
+
+#define VFIO_PLATFORM_INDEX_TO_OFFSET(index)	\
+	((u64)(index) << VFIO_PLATFORM_OFFSET_SHIFT)
+
+struct vfio_platform_region {
+	u64			addr;
+	resource_size_t		size;
+	u32			flags;
+	u32			type;
+#define VFIO_PLATFORM_REGION_TYPE_MMIO	1
+#define VFIO_PLATFORM_REGION_TYPE_PIO	2
+};
+
 struct vfio_platform_device {
+	struct vfio_platform_region	*regions;
+	u32				num_regions;
+	int				refcnt;
+
 	/*
 	 * These fields should be filled by the bus specific binder
 	 */
-- 
2.1.3

