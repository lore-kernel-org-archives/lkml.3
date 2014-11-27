Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaK0ReV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:34:21 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34525 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaK0ReQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:34:16 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v10 06/20] vfio/platform: return info for bound device
Date: Thu, 27 Nov 2014 18:32:46 +0100
Message-Id: <1417109580-10505-7-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
2.1.3

