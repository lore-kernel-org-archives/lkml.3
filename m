Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaIWOsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:48:16 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:49659 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaIWOsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:48:13 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, kvm@vger.kernel.org,
        christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, eric.auger@linaro.org,
        marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv7 15/26] vfio/platform: return info for device memory mapped IO regions
Date: Tue, 23 Sep 2014 16:46:14 +0200
Message-Id: <1411483586-29304-16-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the IOCTLs VFIO_DEVICE_GET_REGION_INFO ioctl call,
which allows the user to learn about the available MMIO resources of
a device.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_common.c  | 84 +++++++++++++++++++++++++--
 drivers/vfio/platform/vfio_platform_private.h | 19 ++++++
 2 files changed, 98 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index ba5edfd..469bdcb 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -27,17 +27,73 @@
 
 #include "vfio_platform_private.h"
 
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
+	if (atomic_dec_and_test(&vdev->refcnt))
+		vfio_platform_regions_cleanup(vdev);
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
 
+	if (atomic_inc_return(&vdev->refcnt) == 1) {
+		ret = vfio_platform_regions_init(vdev);
+		if (ret)
+			goto err_reg;
+	}
+
 	return 0;
+
+err_reg:
+	module_put(THIS_MODULE);
+	return ret;
 }
 
 static long vfio_platform_ioctl(void *device_data,
@@ -58,18 +114,36 @@ static long vfio_platform_ioctl(void *device_data,
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
+	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
 		return -EINVAL;
 
-	else if (cmd == VFIO_DEVICE_SET_IRQS)
+	} else if (cmd == VFIO_DEVICE_SET_IRQS)
 		return -EINVAL;
 
 	else if (cmd == VFIO_DEVICE_RESET)
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index ef76737..383164a 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -15,7 +15,26 @@
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
+};
+
 struct vfio_platform_device {
+	struct vfio_platform_region	*regions;
+	u32				num_regions;
+	atomic_t			refcnt;
+
 	/*
 	 * These fields should be filled by the bus driver at binding time
 	 */
-- 
1.8.3.2

