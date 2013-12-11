Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab3LKVAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:00:07 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39986 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab3LKVAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:00:03 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        B08248@freescale.com, kim.phillips@linaro.org,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 4/9] VFIO_PLATFORM: Return info for device and its memory mapped IO regions
Date: Wed, 11 Dec 2013 21:58:28 +0100
Message-Id: <1386795513-32426-5-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A VFIO userspace driver will start by opening the VFIO device
that corresponds to an IOMMU group, and will use the ioctl interface
to get the basic device info, such as number of memory regions and
interrupts, and their properties.

This patch enables the IOCTLs:
 - VFIO_DEVICE_GET_INFO
 - VFIO_DEVICE_GET_REGION_INFO

 IRQ info is provided by one of the latter patches.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform.c         | 74 ++++++++++++++++++++++++---
 drivers/vfio/platform/vfio_platform_private.h |  8 +++
 2 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index 95dceac..4b402ea 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -34,15 +34,62 @@
 #define DRIVER_AUTHOR   "Antonios Motakis <a.motakis@virtualopensystems.com>"
 #define DRIVER_DESC     "VFIO for platform devices - User Level meta-driver"
 
+static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
+{
+	int cnt = 0, i;
+
+	while (platform_get_resource(vdev->pdev, IORESOURCE_MEM, cnt))
+		cnt++;
+
+	vdev->num_regions = cnt;
+
+	vdev->region = kzalloc(sizeof(struct vfio_platform_region) * cnt,
+				GFP_KERNEL);
+	if (!vdev->region)
+		return -ENOMEM;
+
+	for (i = 0; i < cnt;  i++) {
+		struct vfio_platform_region region;
+		struct resource *res =
+			platform_get_resource(vdev->pdev, IORESOURCE_MEM, i);
+
+		region.addr = res->start;
+		region.size = resource_size(res);
+		region.flags = 0;
+
+		vdev->region[i] = region;
+	}
+
+	return 0;
+}
+
+static void vfio_platform_regions_cleanup(struct vfio_platform_device *vdev)
+{
+	kfree(vdev->region);
+}
+
 static void vfio_platform_release(void *device_data)
 {
+	struct vfio_platform_device *vdev = device_data;
+
+	vfio_platform_regions_cleanup(vdev);
+
 	module_put(THIS_MODULE);
 }
 
 static int vfio_platform_open(void *device_data)
 {
-	if (!try_module_get(THIS_MODULE))
+	struct vfio_platform_device *vdev = device_data;
+	int ret;
+
+	ret = vfio_platform_regions_init(vdev);
+	if (ret)
+		return ret;
+
+	if (!try_module_get(THIS_MODULE)) {
+		vfio_platform_regions_cleanup(vdev);
 		return -ENODEV;
+	}
 
 	return 0;
 }
@@ -65,18 +112,33 @@ static long vfio_platform_ioctl(void *device_data,
 			return -EINVAL;
 
 		info.flags = VFIO_DEVICE_FLAGS_PLATFORM;
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
+		/* map offset to the physical address  */
+		info.offset = vdev->region[info.index].addr;
+		info.size = vdev->region[info.index].size;
+		info.flags = vdev->region[info.index].flags;
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
index 6df8084..4705aa5 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -15,8 +15,16 @@
 #ifndef VFIO_PLATFORM_PRIVATE_H
 #define VFIO_PLATFORM_PRIVATE_H
 
+struct vfio_platform_region {
+	u64			addr;
+	resource_size_t		size;
+	u32			flags;
+};
+
 struct vfio_platform_device {
 	struct platform_device		*pdev;
+	struct vfio_platform_region	*region;
+	u32				num_regions;
 };
 
 #endif /* VFIO_PCI_PRIVATE_H */
-- 
1.8.3.2

