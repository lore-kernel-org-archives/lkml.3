Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbaD1Pyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:54:32 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:55307 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430AbaD1PyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:54:21 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v5 06/11] VFIO_PLATFORM: Return info for device and its memory mapped IO regions
Date: Mon, 28 Apr 2014 17:52:46 +0200
Message-Id: <1398700371-20096-7-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
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
 drivers/vfio/platform/vfio_platform.c         | 77 ++++++++++++++++++++++++---
 drivers/vfio/platform/vfio_platform_private.h | 17 ++++++
 2 files changed, 88 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index 1661746..5430cbe 100644
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
@@ -65,18 +112,36 @@ static long vfio_platform_ioctl(void *device_data,
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
+		if (info.index >= vdev->num_regions)
+			return -EINVAL;
+
+		/* map offset to the physical address  */
+		info.offset = VFIO_PLATFORM_INDEX_TO_OFFSET(info.index);
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
index 4ae88f8..3448f918 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -15,8 +15,25 @@
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
 	struct platform_device		*pdev;
+	struct vfio_platform_region	*region;
+	u32				num_regions;
 };
 
 #endif /* VFIO_PLATFORM_PRIVATE_H */
-- 
1.8.3.2

