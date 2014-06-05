Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaFERFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:05:15 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:62798 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaFERFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:05:10 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        eric.auger@linaro.org,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v6 11/20] vfio/platform: read and write support for the device fd
Date: Thu,  5 Jun 2014 19:03:19 +0200
Message-Id: <1401987808-23596-12-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO returns a file descriptor which we can use to manipulate the memory
regions of the device. Usually, the user will mmap memory regions that are
addressable on page boundaries, however for memory regions where this is
not the case we cannot provide mmap functionality due to security concerns.
For this reason we also need allow to read and write to the memory regions
via the file descriptor.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform.c         | 116 +++++++++++++++++++++++++-
 drivers/vfio/platform/vfio_platform_private.h |   1 +
 2 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index eeaebc4..c66afbc 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -55,7 +55,8 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
 
 		vdev->region[i].addr = res->start;
 		vdev->region[i].size = resource_size(res);
-		vdev->region[i].flags = 0;
+		vdev->region[i].flags = VFIO_REGION_INFO_FLAG_READ
+					| VFIO_REGION_INFO_FLAG_WRITE;
 	}
 
 	vdev->num_regions = cnt;
@@ -155,13 +156,122 @@ static long vfio_platform_ioctl(void *device_data,
 static ssize_t vfio_platform_read(void *device_data, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
-	return -EINVAL;
+	struct vfio_platform_device *vdev = device_data;
+	unsigned int index = VFIO_PLATFORM_OFFSET_TO_INDEX(*ppos);
+	loff_t off = *ppos & VFIO_PLATFORM_OFFSET_MASK;
+	unsigned int done = 0;
+
+	if (index >= vdev->num_regions)
+		return -EINVAL;
+
+	if (!vdev->region[index].ioaddr) {
+		vdev->region[index].ioaddr =
+			ioremap_nocache(vdev->region[index].addr,
+					vdev->region[index].size);
+
+		if (!vdev->region[index].ioaddr)
+			return -ENOMEM;
+	}
+
+	while (count) {
+		size_t filled;
+
+		if (count >= 4 && !(off % 4)) {
+			u32 val;
+
+			val = ioread32(vdev->region[index].ioaddr + off);
+			if (copy_to_user(buf, &val, 4))
+				goto err;
+
+			filled = 4;
+		} else if (count >= 2 && !(off % 2)) {
+			u16 val;
+
+			val = ioread16(vdev->region[index].ioaddr + off);
+			if (copy_to_user(buf, &val, 2))
+				goto err;
+
+			filled = 2;
+		} else {
+			u8 val;
+
+			val = ioread8(vdev->region[index].ioaddr + off);
+			if (copy_to_user(buf, &val, 1))
+				goto err;
+
+			filled = 1;
+		}
+
+
+		count -= filled;
+		done += filled;
+		off += filled;
+		buf += filled;
+	}
+
+	return done;
+err:
+	return -EFAULT;
 }
 
 static ssize_t vfio_platform_write(void *device_data, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	return -EINVAL;
+	struct vfio_platform_device *vdev = device_data;
+	unsigned int index = VFIO_PLATFORM_OFFSET_TO_INDEX(*ppos);
+	loff_t off = *ppos & VFIO_PLATFORM_OFFSET_MASK;
+	unsigned int done = 0;
+
+	if (index >= vdev->num_regions)
+		return -EINVAL;
+
+	if (!vdev->region[index].ioaddr) {
+		vdev->region[index].ioaddr =
+			ioremap_nocache(vdev->region[index].addr,
+					vdev->region[index].size);
+
+		if (!vdev->region[index].ioaddr)
+			return -ENOMEM;
+	}
+
+	while (count) {
+		size_t filled;
+
+		if (count >= 4 && !(off % 4)) {
+			u32 val;
+
+			if (copy_from_user(&val, buf, 4))
+				goto err;
+			iowrite32(val, vdev->region[index].ioaddr + off);
+
+			filled = 4;
+		} else if (count >= 2 && !(off % 2)) {
+			u16 val;
+
+			if (copy_from_user(&val, buf, 2))
+				goto err;
+			iowrite16(val, vdev->region[index].ioaddr + off);
+
+			filled = 2;
+		} else {
+			u8 val;
+
+			if (copy_from_user(&val, buf, 1))
+				goto err;
+			iowrite8(val, vdev->region[index].ioaddr + off);
+
+			filled = 1;
+		}
+
+		count -= filled;
+		done += filled;
+		off += filled;
+		buf += filled;
+	}
+
+	return done;
+err:
+	return -EFAULT;
 }
 
 static int vfio_platform_mmap(void *device_data, struct vm_area_struct *vma)
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 3448f918..c56f4b6 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -28,6 +28,7 @@ struct vfio_platform_region {
 	u64			addr;
 	resource_size_t		size;
 	u32			flags;
+	void __iomem		*ioaddr;
 };
 
 struct vfio_platform_device {
-- 
1.8.3.2

