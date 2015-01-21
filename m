Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbbAUMwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:52:22 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37647 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbbAUMvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:51:55 -0500
From: Baptiste Reynal <b.reynal@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-fundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Baptiste Reynal <b.reynal@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v12 06/18] vfio/platform: read and write support for the device fd
Date: Wed, 21 Jan 2015 13:49:54 +0100
Message-Id: <1421844606-24751-7-git-send-email-b.reynal@virtualopensystems.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
References: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antonios Motakis <a.motakis@virtualopensystems.com>

VFIO returns a file descriptor which we can use to manipulate the memory
regions of the device. Usually, the user will mmap memory regions that are
addressable on page boundaries, however for memory regions where this is
not the case we cannot provide mmap functionality due to security concerns.
For this reason we also allow to use read and write functions to the file
descriptor pointing to the memory regions.

We implement this functionality only for MMIO regions of platform devices;
PIO regions are not being handled at this point.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_common.c  | 150 ++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h |   1 +
 2 files changed, 151 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 2a4613c..fda4c30 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -50,6 +50,10 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
 		switch (resource_type(res)) {
 		case IORESOURCE_MEM:
 			vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_MMIO;
+			vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_READ;
+			if (!(res->flags & IORESOURCE_READONLY))
+				vdev->regions[i].flags |=
+					VFIO_REGION_INFO_FLAG_WRITE;
 			break;
 		case IORESOURCE_IO:
 			vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_PIO;
@@ -69,6 +73,11 @@ err:
 
 static void vfio_platform_regions_cleanup(struct vfio_platform_device *vdev)
 {
+	int i;
+
+	for (i = 0; i < vdev->num_regions; i++)
+		iounmap(vdev->regions[i].ioaddr);
+
 	vdev->num_regions = 0;
 	kfree(vdev->regions);
 }
@@ -171,15 +180,156 @@ static long vfio_platform_ioctl(void *device_data,
 	return -ENOTTY;
 }
 
+static ssize_t vfio_platform_read_mmio(struct vfio_platform_region reg,
+				       char __user *buf, size_t count,
+				       loff_t off)
+{
+	unsigned int done = 0;
+
+	if (!reg.ioaddr) {
+		reg.ioaddr =
+			ioremap_nocache(reg.addr, reg.size);
+
+		if (!reg.ioaddr)
+			return -ENOMEM;
+	}
+
+	while (count) {
+		size_t filled;
+
+		if (count >= 4 && !(off % 4)) {
+			u32 val;
+
+			val = ioread32(reg.ioaddr + off);
+			if (copy_to_user(buf, &val, 4))
+				goto err;
+
+			filled = 4;
+		} else if (count >= 2 && !(off % 2)) {
+			u16 val;
+
+			val = ioread16(reg.ioaddr + off);
+			if (copy_to_user(buf, &val, 2))
+				goto err;
+
+			filled = 2;
+		} else {
+			u8 val;
+
+			val = ioread8(reg.ioaddr + off);
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
+}
+
 static ssize_t vfio_platform_read(void *device_data, char __user *buf,
 				  size_t count, loff_t *ppos)
 {
+	struct vfio_platform_device *vdev = device_data;
+	unsigned int index = VFIO_PLATFORM_OFFSET_TO_INDEX(*ppos);
+	loff_t off = *ppos & VFIO_PLATFORM_OFFSET_MASK;
+
+	if (index >= vdev->num_regions)
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_READ))
+		return -EINVAL;
+
+	if (vdev->regions[index].type & VFIO_PLATFORM_REGION_TYPE_MMIO)
+		return vfio_platform_read_mmio(vdev->regions[index],
+							buf, count, off);
+	else if (vdev->regions[index].type & VFIO_PLATFORM_REGION_TYPE_PIO)
+		return -EINVAL; /* not implemented */
+
 	return -EINVAL;
 }
 
+static ssize_t vfio_platform_write_mmio(struct vfio_platform_region reg,
+					const char __user *buf, size_t count,
+					loff_t off)
+{
+	unsigned int done = 0;
+
+	if (!reg.ioaddr) {
+		reg.ioaddr =
+			ioremap_nocache(reg.addr, reg.size);
+
+		if (!reg.ioaddr)
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
+			iowrite32(val, reg.ioaddr + off);
+
+			filled = 4;
+		} else if (count >= 2 && !(off % 2)) {
+			u16 val;
+
+			if (copy_from_user(&val, buf, 2))
+				goto err;
+			iowrite16(val, reg.ioaddr + off);
+
+			filled = 2;
+		} else {
+			u8 val;
+
+			if (copy_from_user(&val, buf, 1))
+				goto err;
+			iowrite8(val, reg.ioaddr + off);
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
+}
+
 static ssize_t vfio_platform_write(void *device_data, const char __user *buf,
 				   size_t count, loff_t *ppos)
 {
+	struct vfio_platform_device *vdev = device_data;
+	unsigned int index = VFIO_PLATFORM_OFFSET_TO_INDEX(*ppos);
+	loff_t off = *ppos & VFIO_PLATFORM_OFFSET_MASK;
+
+	if (index >= vdev->num_regions)
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE))
+		return -EINVAL;
+
+	if (vdev->regions[index].type & VFIO_PLATFORM_REGION_TYPE_MMIO)
+		return vfio_platform_write_mmio(vdev->regions[index],
+							buf, count, off);
+	else if (vdev->regions[index].type & VFIO_PLATFORM_REGION_TYPE_PIO)
+		return -EINVAL; /* not implemented */
+
 	return -EINVAL;
 }
 
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 3551f6d..97c78f9 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -34,6 +34,7 @@ struct vfio_platform_region {
 	u32			type;
 #define VFIO_PLATFORM_REGION_TYPE_MMIO	1
 #define VFIO_PLATFORM_REGION_TYPE_PIO	2
+	void __iomem		*ioaddr;
 };
 
 struct vfio_platform_device {
-- 
2.2.2

