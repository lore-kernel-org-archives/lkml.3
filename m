Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab3BQR7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 12:59:55 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:52314 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3BQR7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 12:59:52 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 1/9] video: introduce system framebuffer bus
Date: Sun, 17 Feb 2013 18:59:03 +0100
Message-Id: <1361123951-587-2-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
References: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Herrmann <dh.herrmann@googlemail.com>

For a long time now we have the problem that there are multiple drivers
available that try to use system framebuffers (like EFI, VESA/VBE, ...).
There is no way to control which driver gets access to the devices, but
instead works on a first-come-first-serve basis.

Furthermore, hardware drivers (eg., gpu/drm/*) that get loaded on the
real hardware bus (eg., pci-bus) of the framebuffer devices have a hard
time unloading other drivers that currently use system framebuffers.

This introduces a new bus-type: sysfb (system framebuffer bus)

Any available system framebuffer gets registered as a device on this bus.
A bus-driver can then pick up the device and use it. Standard sysfs
bind/unbind interfaces can be used to change drivers on-the-fly.

There are actually two types of drivers: generic and real drivers

Generic drivers use the generic framebuffer interface exclusively. They
are often used as a fallback interface where no real driver for the
hardware is available. Generic drivers register as sysfb drivers to the
sysfb bus and will get loaded dynamically. User-space can bind/unbind them
via sysfs to control which driver should get access.
Only one driver can be active per device. During probe the driver can
retrieve additional information via a screen_info object of the device.
Generic drivers include: efifb, (u)vesafb, vgacon, ...

Real drivers work differently. Instead of being loaded via sysfb, they
register as drivers on the real bus (eg., pci-bus). During probe they
should verify whether their real device provides a system-framebuffer. If
it does, they call sysfb_claim() to claim exclusive access to the device.
This guarantees that any generic driver gets unloaded and the real
hardware driver can gain access. This also guarantees that a real hardware
driver always takes precedence over generic fallback drivers.
Real drivers include: i915, radeon, nouveau, ...

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/Kconfig  |  17 ++++
 drivers/video/Makefile |   1 +
 drivers/video/sysfb.c  | 230 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfb.h  | 134 ++++++++++++++++++++++++++++
 4 files changed, 382 insertions(+)
 create mode 100644 drivers/video/sysfb.c
 create mode 100644 include/linux/sysfb.h

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index d08d799..eac56ef 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -27,6 +27,23 @@ config VGASTATE
        tristate
        default n
 
+config SYSFB
+	tristate "System Framebuffer Bus"
+	help
+	  Framebuffers like VGA, VESA/VBE, EFI and others can be handled by many
+	  different drivers. This bus provides an infrastructure for drivers to
+	  register themselves and then get bound/unbound to these system-wide
+	  framebuffers.
+	  This bus prevents framebuffers from being used by multiple drivers
+	  simultaneously and also provides a sysfs API to bind/rebind different
+	  drivers to each device from userspace.
+
+	  Chipset-specific drivers (like real GPU drivers) will always take
+	  precedence over generic framebuffer drivers.
+
+	  A driver should normally select this bus-option automatically. Enable
+	  it only if you need out-of-tree builds.
+
 config VIDEO_OUTPUT_CONTROL
 	tristate "Lowlevel video output switch controls"
 	help
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 23e948e..f0eb006 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -5,6 +5,7 @@
 # Each configuration option enables a list of files.
 
 obj-$(CONFIG_VGASTATE)            += vgastate.o
+obj-$(CONFIG_SYSFB)		  += sysfb.o
 obj-y                             += fb_notify.o
 obj-$(CONFIG_FB)                  += fb.o
 fb-y                              := fbmem.o fbmon.o fbcmap.o fbsysfs.o \
diff --git a/drivers/video/sysfb.c b/drivers/video/sysfb.c
new file mode 100644
index 0000000..8249006
--- /dev/null
+++ b/drivers/video/sysfb.c
@@ -0,0 +1,230 @@
+/*
+ * System framebuffer bus
+ * Copyright (c) 2013 David Herrmann
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+/*
+ * The system framebuffer bus (sysfb) provides a way to register global system
+ * framebuffers and load different drivers for it. This includes VESA/VBE and
+ * EFI framebuffers.
+ * Platform code is responsible of adding the framebuffer devices to the system
+ * platform bus. The sysfb bus will pick up known devices and provide them via
+ * the sysfb bus to system drivers. This guarantees that only one driver uses
+ * a single system framebuffer at a time.
+ *
+ * Drivers that can make use of the generic interfaces of system framebuffers
+ * should register as a sysfb driver. They will get notified via probe/remove
+ * callbacks just like any other hotpluggable driver. Users can load/unload
+ * drivers via the sysfs bus interface so drivers must be hotplug capable.
+ *
+ * Drivers that cannot make use of the generic interfaces but instead control
+ * the real hardware should instead claim the device. These drivers normally
+ * register through PCI or platform devices and control the device via another
+ * interface.
+ * By claiming a device, all other generic drivers are unregistered and no more
+ * drivers will be probed unless the device is released again.
+ *
+ * Only _real_ hardware drivers should claim devices as there is always another
+ * mechanism to control which real hardware driver gets loaded (eg. pci-bus).
+ * Generic drivers which aren't controlled via another bus should use this
+ * generic sysfb driver interface instead of claiming a device.
+ *
+ * All drivers must make sure that after they get unloaded or release a device,
+ * the device is reset to a usable state. If the driver cannot guarantee that,
+ * it should taint the device so other drivers will notice it and can
+ * optionally recover the device.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/screen_info.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/sysfb.h>
+
+static DEFINE_SPINLOCK(sysfb_lock);
+static unsigned int claimed_types;
+
+static int sysfb_bus_match(struct device *dev, struct device_driver *drv)
+{
+	struct sysfb_device *sdev = to_sysfb_device(dev);
+	struct sysfb_driver *sdrv = to_sysfb_driver(drv);
+
+	return (sdrv->type_mask & sdev->type) &&
+	       (sdrv->allow_tainted || !sdev->tainted);
+}
+
+static int sysfb_bus_probe(struct device *dev)
+{
+	struct sysfb_device *sdev = to_sysfb_device(dev);
+	struct sysfb_driver *sdrv = to_sysfb_driver(dev->driver);
+	unsigned long flags;
+	int ret;
+
+	if (!(sdrv->type_mask & sdev->type))
+		return -ENODEV;
+	if (!sdrv->allow_tainted && sdev->tainted)
+		return -ENODEV;
+
+	spin_lock_irqsave(&sysfb_lock, flags);
+	if ((claimed_types & sdev->type)) {
+		spin_unlock_irqrestore(&sysfb_lock, flags);
+		return -ENODEV;
+	}
+	spin_unlock_irqrestore(&sysfb_lock, flags);
+
+	if (sdrv->probe) {
+		ret = sdrv->probe(sdev);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int sysfb_bus_remove(struct device *dev)
+{
+	struct sysfb_device *sdev = to_sysfb_device(dev);
+	struct sysfb_driver *sdrv = to_sysfb_driver(dev->driver);
+
+	if (sdrv->remove)
+		sdrv->remove(sdev);
+
+	return 0;
+}
+
+static struct bus_type sysfb_bus_type = {
+	.name = "sysfb",
+	.match = sysfb_bus_match,
+	.probe = sysfb_bus_probe,
+	.remove = sysfb_bus_remove,
+};
+
+int sysfb_register_driver(struct sysfb_driver *drv)
+{
+	int ret;
+
+	drv->driver.bus = &sysfb_bus_type;
+
+	ret = driver_register(&drv->driver);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL(sysfb_register_driver);
+
+void sysfb_unregister_driver(struct sysfb_driver *drv)
+{
+	driver_unregister(&drv->driver);
+}
+EXPORT_SYMBOL(sysfb_unregister_driver);
+
+static int __sysfb_rescan(struct device *dev, void *data)
+{
+	return device_attach(dev);
+}
+
+static void sysfb_rescan(void)
+{
+	bus_for_each_dev(&sysfb_bus_type, NULL, NULL, __sysfb_rescan);
+}
+
+static int __sysfb_claim(struct device *dev, void *data)
+{
+	struct sysfb_device *sdev = to_sysfb_device(dev);
+	unsigned int claim = (long)data;
+
+	if (!(sdev->type & claim))
+		return 0;
+
+	device_release_driver(dev);
+	return 0;
+}
+
+int sysfb_claim(unsigned int types)
+{
+	unsigned long flags;
+	int ret;
+
+	if (!(types & SYSFB_TYPES))
+		return -EINVAL;
+
+	spin_lock_irqsave(&sysfb_lock, flags);
+	if ((claimed_types & types)) {
+		spin_unlock_irqrestore(&sysfb_lock, flags);
+		return -EALREADY;
+	}
+	claimed_types |= types;
+	spin_unlock_irqrestore(&sysfb_lock, flags);
+
+	ret = bus_for_each_dev(&sysfb_bus_type, NULL, (void*)(long)types,
+			       __sysfb_claim);
+	if (ret)
+		goto err_restore;
+
+	return 0;
+
+err_restore:
+	spin_lock_irqsave(&sysfb_lock, flags);
+	claimed_types &= ~types;
+	spin_unlock_irqrestore(&sysfb_lock, flags);
+
+	sysfb_rescan();
+	return ret;
+}
+EXPORT_SYMBOL(sysfb_claim);
+
+void sysfb_release(unsigned int types)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sysfb_lock, flags);
+	claimed_types &= ~types;
+	spin_unlock_irqrestore(&sysfb_lock, flags);
+
+	sysfb_rescan();
+}
+EXPORT_SYMBOL(sysfb_release);
+
+void sysfb_taint(struct sysfb_device *sdev, bool set)
+{
+	sdev->tainted = set;
+}
+EXPORT_SYMBOL(sysfb_taint);
+
+static int __init sysfb_init(void)
+{
+	int ret;
+
+	ret = bus_register(&sysfb_bus_type);
+	if (ret) {
+		pr_err("cannot register sysfb bus\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit sysfb_exit(void)
+{
+	bus_unregister(&sysfb_bus_type);
+}
+
+module_init(sysfb_init);
+module_exit(sysfb_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David Herrmann <dh.herrmann@gmail.com>");
+MODULE_DESCRIPTION("System framebuffer bus");
diff --git a/include/linux/sysfb.h b/include/linux/sysfb.h
new file mode 100644
index 0000000..6cd3c24
--- /dev/null
+++ b/include/linux/sysfb.h
@@ -0,0 +1,134 @@
+#ifndef __LINUX_SYSFB_H_
+#define __LINUX_SYSFB_H_
+
+/*
+ * System framebuffer bus
+ * Copyright (c) 2013 David Herrmann
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/screen_info.h>
+#include <linux/types.h>
+
+/**
+ * sysfb_type
+ *
+ * Different types of available framebuffer devices. Only one device of each
+ * type can be available at a time. In most systems there even is only one
+ * device at all.
+ *
+ * Use the sysfb_device->screen pointer to get information about the framebuffer
+ * devices.
+ */
+enum sysfb_type {
+	SYSFB_TYPES = 0,
+};
+
+/**
+ * sysfb_device
+ * @tainted: whether the device was tainted or not
+ * @type: type of the fb device (@sysfb_type)
+ * @screen: pointer to supplemental screen-info object
+ * @dev: device object
+ *
+ * Each framebuffer device is represented by a sysfb_device object. The sysfb
+ * core manages them and they cannot be registered from the outside.
+ */
+struct sysfb_device {
+	bool tainted;
+	unsigned int type;
+	struct screen_info *screen;
+	struct device dev;
+};
+
+#define to_sysfb_device(_dev) container_of((_dev), struct sysfb_device, dev)
+
+/**
+ * sysfb_driver
+ * @type_mask: mask of device-types that are supported (@sysfb_type)
+ * @allow_tainted: whether the driver can be bound to tainted devices
+ * @driver: driver object
+ * @probe: probe callback
+ * @remove: remove callback
+ *
+ * Each generic framebuffer driver must provide this structure when registering
+ * to the sysfb core. The @driver field must also be provided by the caller
+ * except for the 'driver.bus' field which is initialized by the core.
+ */
+struct sysfb_driver {
+	unsigned int type_mask;
+	bool allow_tainted;
+	struct device_driver driver;
+
+	int (*probe) (struct sysfb_device *dev);
+	void (*remove) (struct sysfb_device *dev);
+};
+
+#define to_sysfb_driver(_drv) container_of((_drv), struct sysfb_driver, driver)
+
+/**
+ * sysfb_register_driver
+ * @drv: Driver object
+ *
+ * Register a new driver on the sysfb bus.
+ */
+int sysfb_register_driver(struct sysfb_driver *drv);
+
+/**
+ * sysfb_unregister_driver
+ * @drv: Driver object
+ *
+ * Remove a driver from the sysfb bus.
+ */
+void sysfb_unregister_driver(struct sysfb_driver *drv);
+
+/**
+ * sysfb_claim
+ * @types: Bitmask of sysfb_type flags
+ *
+ * Unbind all drivers from all devices matching the given types and prevent
+ * further drivers to get loaded on these types of devices. This allows real
+ * hardware drivers that are loaded by other bus-types (eg. pci-bus) to prevent
+ * any generic driver from using the given framebuffer types.
+ *
+ * Return 0 if the types could be claimed, otherwise a negative error code
+ * is returned.
+ */
+int sysfb_claim(unsigned int types);
+
+/**
+ * sysfb_release
+ * @types: Bitmask of sysfb_type flags
+ *
+ * Releases the given previously claimed types. See sysfb_claim(). This does
+ * not check whether the types are actually claimed or who claimed them. So make
+ * sure to call this only when you really claimed these types previously.
+ */
+void sysfb_release(unsigned int types);
+
+/**
+ * sysfb_taint
+ * @sdev: sysfb device
+ * @set: whether to taint or untaint
+ *
+ * This taints a given sysfb device. This should be done by all drivers if they
+ * change the framebuffer device in a way that other generic drivers might not
+ * be able to detect afterwards.
+ * This includes changing the resolution or properties of a framebuffer without
+ * adjusting the screen_info object.
+ * This can be reset to 'false' after all the changes have been undone.
+ *
+ * This is an unlocked function. You must call it from within your probe/remove
+ * callbacks in the driver.
+ */
+void sysfb_taint(struct sysfb_device *sdev, bool set);
+
+#endif /* __LINUX_SYSFB_H_ */
-- 
1.8.1.3

