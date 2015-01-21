Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbbAUMvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:51:49 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:50933 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbbAUMvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:51:35 -0500
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
Subject: [PATCH v12 04/18] vfio/platform: return info for bound device
Date: Wed, 21 Jan 2015 13:49:52 +0100
Message-Id: <1421844606-24751-5-git-send-email-b.reynal@virtualopensystems.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
References: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antonios Motakis <a.motakis@virtualopensystems.com>

A VFIO userspace driver will start by opening the VFIO device
that corresponds to an IOMMU group, and will use the ioctl interface
to get the basic device info, such as number of memory regions and
interrupts, and their properties. This patch enables the
VFIO_DEVICE_GET_INFO ioctl call.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_common.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 34d023b..862b43b 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -38,10 +38,27 @@ static int vfio_platform_open(void *device_data)
 static long vfio_platform_ioctl(void *device_data,
 				unsigned int cmd, unsigned long arg)
 {
-	if (cmd == VFIO_DEVICE_GET_INFO)
-		return -EINVAL;
+	struct vfio_platform_device *vdev = device_data;
+	unsigned long minsz;
+
+	if (cmd == VFIO_DEVICE_GET_INFO) {
+		struct vfio_device_info info;
+
+		minsz = offsetofend(struct vfio_device_info, num_irqs);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		info.flags = vdev->flags;
+		info.num_regions = 0;
+		info.num_irqs = 0;
+
+		return copy_to_user((void __user *)arg, &info, minsz);
 
-	else if (cmd == VFIO_DEVICE_GET_REGION_INFO)
+	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO)
 		return -EINVAL;
 
 	else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
-- 
2.2.2

