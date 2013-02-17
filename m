Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3BQSAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 13:00:07 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:56452 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3BQSAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 13:00:00 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 6/9] drm: new sysfb DRM bus module
Date: Sun, 17 Feb 2013 18:59:08 +0100
Message-Id: <1361123951-587-7-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
References: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a new DRM bus helper for the system framebuffer bus. It is
very similar in its functionality to the DRM_USB helper. It allows to
write DRM drivers that register as SYSFB drivers to the system.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/Kconfig     |   5 ++
 drivers/gpu/drm/Makefile    |   1 +
 drivers/gpu/drm/drm_sysfb.c | 145 ++++++++++++++++++++++++++++++++++++++++++++
 include/drm/drmP.h          |   4 ++
 include/drm/drm_sysfb.h     |  35 +++++++++++
 5 files changed, 190 insertions(+)
 create mode 100644 drivers/gpu/drm/drm_sysfb.c
 create mode 100644 include/drm/drm_sysfb.h

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 18321b68b..2df448e 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -25,6 +25,11 @@ config DRM_USB
 	depends on USB_SUPPORT && USB_ARCH_HAS_HCD
 	select USB
 
+config DRM_SYSFB
+	tristate
+	depends on DRM
+	select SYSFB
+
 config DRM_KMS_HELPER
 	tristate
 	depends on DRM
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 2ff5cef..9249b66 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -29,6 +29,7 @@ CFLAGS_drm_trace_points.o := -I$(src)
 
 obj-$(CONFIG_DRM)	+= drm.o
 obj-$(CONFIG_DRM_USB)   += drm_usb.o
+obj-$(CONFIG_DRM_SYSFB) += drm_sysfb.o
 obj-$(CONFIG_DRM_TTM)	+= ttm/
 obj-$(CONFIG_DRM_TDFX)	+= tdfx/
 obj-$(CONFIG_DRM_R128)	+= r128/
diff --git a/drivers/gpu/drm/drm_sysfb.c b/drivers/gpu/drm/drm_sysfb.c
new file mode 100644
index 0000000..4e8a823
--- /dev/null
+++ b/drivers/gpu/drm/drm_sysfb.c
@@ -0,0 +1,145 @@
+/*
+ * DRM Bus for sysfb drivers
+ *
+ * Copyright 2013 David Herrmann <dh.herrmann@gmail.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
+ * AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
+ * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/sysfb.h>
+#include <drm/drmP.h>
+
+int drm_get_sysfb_dev(struct sysfb_device *sdev,
+		      struct drm_driver *driver)
+{
+	struct drm_device *dev;
+	int ret;
+
+	DRM_DEBUG("\n");
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	dev_set_drvdata(&sdev->dev, dev);
+	dev->sysfbdev = sdev;
+	dev->dev = &sdev->dev;
+
+	mutex_lock(&drm_global_mutex);
+
+	ret = drm_fill_in_dev(dev, NULL, driver);
+	if (ret) {
+		DRM_ERROR("drm_fill_in_dev failed\n");
+		goto err_unlock;
+	}
+
+	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
+		ret = drm_get_minor(dev, &dev->control, DRM_MINOR_CONTROL);
+		if (ret)
+			goto err_unlock;
+	}
+
+	ret = drm_get_minor(dev, &dev->primary, DRM_MINOR_LEGACY);
+	if (ret)
+		goto err_ctrl;
+
+	if (dev->driver->load) {
+		ret = dev->driver->load(dev, 0);
+		if (ret)
+			goto err_primary;
+	}
+
+	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
+		ret = drm_mode_group_init_legacy_group(dev,
+				&dev->primary->mode_group);
+		if (ret)
+			goto err_primary;
+	}
+
+	list_add_tail(&dev->driver_item, &driver->device_list);
+
+	mutex_unlock(&drm_global_mutex);
+
+	DRM_INFO("initialized %s %d.%d.%d %s on minor %d\n",
+		 driver->name, driver->major, driver->minor, driver->patchlevel,
+		 driver->date, dev->primary->index);
+
+	return 0;
+
+err_primary:
+	drm_put_minor(&dev->primary);
+err_ctrl:
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
+		drm_put_minor(&dev->control);
+err_unlock:
+	mutex_unlock(&drm_global_mutex);
+	kfree(dev);
+	return ret;
+}
+EXPORT_SYMBOL(drm_get_sysfb_dev);
+
+static int drm_sysfb_get_irq(struct drm_device *dev)
+{
+	return 0;
+}
+
+static const char *drm_sysfb_get_name(struct drm_device *dev)
+{
+	return dev_name(&dev->sysfbdev->dev);
+}
+
+static int drm_sysfb_set_busid(struct drm_device *dev,
+			       struct drm_master *master)
+{
+	return 0;
+}
+
+static struct drm_bus drm_sysfb_bus = {
+	.bus_type = DRIVER_BUS_SYSFB,
+	.get_irq = drm_sysfb_get_irq,
+	.get_name = drm_sysfb_get_name,
+	.set_busid = drm_sysfb_set_busid,
+};
+
+int drm_sysfb_init(struct drm_driver *driver, struct sysfb_driver *sdrv)
+{
+	DRM_DEBUG("\n");
+
+	INIT_LIST_HEAD(&driver->device_list);
+	driver->kdriver.sysfb = sdrv;
+	driver->bus = &drm_sysfb_bus;
+
+	return sysfb_register_driver(sdrv);
+}
+EXPORT_SYMBOL(drm_sysfb_init);
+
+void drm_sysfb_exit(struct drm_driver *driver, struct sysfb_driver *sdrv)
+{
+	DRM_DEBUG("\n");
+
+	sysfb_unregister_driver(sdrv);
+	DRM_INFO("module unloaded\n");
+}
+EXPORT_SYMBOL(drm_sysfb_exit);
+
+MODULE_AUTHOR("David Herrmann <dh.herrmann@gmail.com>");
+MODULE_DESCRIPTION("DRM sysfb support");
+MODULE_LICENSE("GPL and additional rights");
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 3fd8280..e5d73fe 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -71,6 +71,7 @@
 #endif
 #include <linux/workqueue.h>
 #include <linux/poll.h>
+#include <linux/sysfb.h>
 #include <asm/pgalloc.h>
 #include <drm/drm.h>
 #include <drm/drm_sarea.h>
@@ -157,6 +158,7 @@ int drm_err(const char *func, const char *format, ...);
 #define DRIVER_BUS_PCI 0x1
 #define DRIVER_BUS_PLATFORM 0x2
 #define DRIVER_BUS_USB 0x3
+#define DRIVER_BUS_SYSFB 0x4
 
 /***********************************************************************/
 /** \name Begin the DRM... */
@@ -953,6 +955,7 @@ struct drm_driver {
 		struct pci_driver *pci;
 		struct platform_device *platform_device;
 		struct usb_driver *usb;
+		struct sysfb_driver *sysfb;
 	} kdriver;
 	struct drm_bus *bus;
 
@@ -1173,6 +1176,7 @@ struct drm_device {
 
 	struct platform_device *platformdev; /**< Platform device struture */
 	struct usb_device *usbdev;
+	struct sysfb_device *sysfbdev;
 
 	struct drm_sg_mem *sg;	/**< Scatter gather memory */
 	unsigned int num_crtcs;                  /**< Number of CRTCs on this device */
diff --git a/include/drm/drm_sysfb.h b/include/drm/drm_sysfb.h
new file mode 100644
index 0000000..ced54d7
--- /dev/null
+++ b/include/drm/drm_sysfb.h
@@ -0,0 +1,35 @@
+#ifndef __DRM_SYSFB_H
+#define __DRM_SYSFB_H
+/*
+ * DRM Bus for sysfb drivers
+ *
+ * Copyright 2013 David Herrmann <dh.herrmann@gmail.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
+ * AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
+ * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include <drmP.h>
+#include <linux/sysfb.h>
+
+int drm_sysfb_init(struct drm_driver *driver, struct sysfb_driver *sdrv);
+void drm_sysfb_exit(struct drm_driver *driver, struct sysfb_driver *sdrv);
+int drm_get_sysfb_dev(struct sysfb_device *sdev,
+		      struct drm_driver *driver);
+
+#endif /* __DRM_SYSFB_H */
-- 
1.8.1.3

