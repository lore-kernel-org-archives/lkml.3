Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaK0Rdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:33:49 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:54781 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaK0Rdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:33:46 -0500
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
Subject: [PATCH v10 02/20] vfio: platform: probe to devices on the platform bus
Date: Thu, 27 Nov 2014 18:32:42 +0100
Message-Id: <1417109580-10505-3-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver to bind to Linux platform devices, and callbacks to discover their
resources to be used by the main VFIO PLATFORM code.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform.c | 103 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h             |   1 +
 2 files changed, 104 insertions(+)
 create mode 100644 drivers/vfio/platform/vfio_platform.c

diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
new file mode 100644
index 0000000..cef645c
--- /dev/null
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -0,0 +1,103 @@
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
+#include <linux/platform_device.h>
+
+#include "vfio_platform_private.h"
+
+#define DRIVER_VERSION  "0.10"
+#define DRIVER_AUTHOR   "Antonios Motakis <a.motakis@virtualopensystems.com>"
+#define DRIVER_DESC     "VFIO for platform devices - User Level meta-driver"
+
+/* probing devices from the linux platform bus */
+
+static struct resource *get_platform_resource(struct vfio_platform_device *vdev,
+					      int num)
+{
+	struct platform_device *dev = (struct platform_device *) vdev->opaque;
+	int i;
+
+	for (i = 0; i < dev->num_resources; i++) {
+		struct resource *r = &dev->resource[i];
+
+		if (resource_type(r) & (IORESOURCE_MEM|IORESOURCE_IO)) {
+			if (!num)
+				return r;
+
+			num--;
+		}
+	}
+	return NULL;
+}
+
+static int get_platform_irq(struct vfio_platform_device *vdev, int i)
+{
+	struct platform_device *pdev = (struct platform_device *) vdev->opaque;
+
+	return platform_get_irq(pdev, i);
+}
+
+static int vfio_platform_probe(struct platform_device *pdev)
+{
+	struct vfio_platform_device *vdev;
+	int ret;
+
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+
+	vdev->opaque = (void *) pdev;
+	vdev->name = pdev->name;
+	vdev->flags = VFIO_DEVICE_FLAGS_PLATFORM;
+	vdev->get_resource = get_platform_resource;
+	vdev->get_irq = get_platform_irq;
+
+	ret = vfio_platform_probe_common(vdev, &pdev->dev);
+	if (ret)
+		kfree(vdev);
+
+	return ret;
+}
+
+static int vfio_platform_remove(struct platform_device *pdev)
+{
+	struct vfio_platform_device *vdev;
+
+	vdev = vfio_platform_remove_common(&pdev->dev);
+	if (vdev) {
+		kfree(vdev);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static struct platform_driver vfio_platform_driver = {
+	.probe		= vfio_platform_probe,
+	.remove		= vfio_platform_remove,
+	.driver	= {
+		.name	= "vfio-platform",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(vfio_platform_driver);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9ade02b..4e93a97 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -159,6 +159,7 @@ struct vfio_device_info {
 	__u32	flags;
 #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
+#define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform device */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
-- 
2.1.3

