Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbaLIOTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:19:50 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58750 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386AbaLIOTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:19:48 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        linux-kernel@vger.kernel.org (open list),
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-api@vger.kernel.org (open list:ABI/API)
Subject: [PATCH v10 04/20] vfio: amba: VFIO support for AMBA devices
Date: Tue,  9 Dec 2014 15:18:57 +0100
Message-Id: <1418134742-16259-1-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417109580-10505-5-git-send-email-a.motakis@virtualopensystems.com>
References: <1417109580-10505-5-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for discovering AMBA devices with VFIO and handle them
similarly to Linux platform devices.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_amba.c | 115 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h         |   1 +
 2 files changed, 116 insertions(+)
 create mode 100644 drivers/vfio/platform/vfio_amba.c

diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
new file mode 100644
index 0000000..ff0331f
--- /dev/null
+++ b/drivers/vfio/platform/vfio_amba.c
@@ -0,0 +1,115 @@
+/*
+ * Copyright (C) 2013 - Virtual Open Systems
+ * Author: Antonios Motakis <a.motakis@virtualopensystems.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/vfio.h>
+#include <linux/amba/bus.h>
+
+#include "vfio_platform_private.h"
+
+#define DRIVER_VERSION  "0.10"
+#define DRIVER_AUTHOR   "Antonios Motakis <a.motakis@virtualopensystems.com>"
+#define DRIVER_DESC     "VFIO for AMBA devices - User Level meta-driver"
+
+/* probing devices from the AMBA bus */
+
+static struct resource *get_amba_resource(struct vfio_platform_device *vdev,
+					  int i)
+{
+	struct amba_device *adev = (struct amba_device *) vdev->opaque;
+
+	if (i == 0)
+		return &adev->res;
+
+	return NULL;
+}
+
+static int get_amba_irq(struct vfio_platform_device *vdev, int i)
+{
+	struct amba_device *adev = (struct amba_device *) vdev->opaque;
+	int ret = 0;
+
+	if (i < AMBA_NR_IRQS)
+		ret = adev->irq[i];
+
+	/* zero is an unset IRQ for AMBA devices */
+	return ret ? ret : -ENXIO;
+}
+
+static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
+{
+	struct vfio_platform_device *vdev;
+	int ret;
+
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+
+	vdev->name = kasprintf(GFP_KERNEL, "vfio-amba-%08x", adev->periphid);
+	if (!vdev->name) {
+		kfree(vdev);
+		return -ENOMEM;
+	}
+
+	vdev->opaque = (void *) adev;
+	vdev->flags = VFIO_DEVICE_FLAGS_AMBA;
+	vdev->get_resource = get_amba_resource;
+	vdev->get_irq = get_amba_irq;
+
+	ret = vfio_platform_probe_common(vdev, &adev->dev);
+	if (ret) {
+		kfree(vdev->name);
+		kfree(vdev);
+	}
+
+	return ret;
+}
+
+static int vfio_amba_remove(struct amba_device *adev)
+{
+	struct vfio_platform_device *vdev;
+
+	vdev = vfio_platform_remove_common(&adev->dev);
+	if (vdev) {
+		kfree(vdev->name);
+		kfree(vdev);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static struct amba_id pl330_ids[] = {
+	{ 0, 0 },
+};
+
+MODULE_DEVICE_TABLE(amba, pl330_ids);
+
+static struct amba_driver vfio_amba_driver = {
+	.probe = vfio_amba_probe,
+	.remove = vfio_amba_remove,
+	.id_table = pl330_ids,
+	.drv = {
+		.name = "vfio-amba",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_amba_driver(vfio_amba_driver);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 4e93a97..544d3d8 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -160,6 +160,7 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
 #define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform device */
+#define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
-- 
2.1.3

