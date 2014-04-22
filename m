Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbaDVPLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:11:04 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:42444 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbaDVPK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:10:56 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [RFC 3/5] drivers/base: Add interface framework
Date: Tue, 22 Apr 2014 17:09:31 +0200
Message-Id: <1398179373-29966-4-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
References: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Some drivers, such as graphics drivers in the DRM subsystem, do not have
a real device that they can bind to. They are often composed of several
devices, each having their own driver. The master/component framework
can be used in these situations to collect the devices pertaining to one
logical device, wait until all of them have registered and then bind
them all at once.

For some situations this is only a partial solution. An implementation
of a master still needs to be registered with the system somehow. Many
drivers currently resort to creating a dummy device that a driver can
bind to and register the master against. This is problematic since it
requires (and presumes) knowledge about the system within drivers.

Furthermore there are setups where a suitable device already exists, but
is already bound to a driver. For example, on Tegra the following device
tree extract (simplified) represents the host1x device along with child
devices:

	host1x {
		display-controller {
			...
		};

		display-controller {
			...
		};

		hdmi {
			...
		};

		dsi {
			...
		};

		csi {
			...
		};

		video-input {
			...
		};
	};

Each of the child devices is in turn a client of host1x, in that it can
request resources (command stream DMA channels and syncpoints) from it.
To implement the DMA channel and syncpoint infrastructure, host1x comes
with its own driver. Children are implemented in separate drivers. In
Linux this set of devices would be exposed by DRM and V4L2 drivers.

However, neither the DRM nor the V4L2 drivers have a single device that
they can bind to. The DRM device is composed of the display controllers
and the various output devices, whereas the V4L2 device is composed of
one or more video input devices.

This patch introduces the concept of an interface and drivers that can
bind to a given interface. An interface can be exposed by any device,
and interface drivers can bind to these interfaces. Multiple drivers can
bind against a single interface. When a device is removed, interfaces
exposed by it will be removed as well, thereby removing the drivers that
were bound to those interfaces.

In the example above, the host1x device would expose the "tegra-host1x"
interface. DRM and V4L2 drivers can then bind to that interface and
instantiate the respective subsystem objects from there.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/base/Makefile     |   2 +-
 drivers/base/interface.c  | 186 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/interface.h |  40 ++++++++++
 3 files changed, 227 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/interface.c
 create mode 100644 include/linux/interface.h

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 04b314e0fa51..b5278904e443 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -4,7 +4,7 @@ obj-y			:= component.o core.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o \
-			   topology.o container.o
+			   topology.o container.o interface.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
 obj-y			+= power/
diff --git a/drivers/base/interface.c b/drivers/base/interface.c
new file mode 100644
index 000000000000..411f6cdf90e7
--- /dev/null
+++ b/drivers/base/interface.c
@@ -0,0 +1,186 @@
+/*
+ * Copyright (C) 2014 NVIDIA Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define pr_fmt(fmt) "interface: " fmt
+
+#include <linux/device.h>
+#include <linux/interface.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+
+static DEFINE_MUTEX(interfaces_lock);
+static LIST_HEAD(interfaces);
+static LIST_HEAD(drivers);
+
+struct interface_attachment {
+	struct interface_driver *driver;
+	struct list_head list;
+};
+
+static bool interface_match(struct interface *intf,
+			    struct interface_driver *driver)
+{
+	return strcmp(intf->name, driver->name) == 0;
+}
+
+static bool interface_attached(struct interface *intf,
+			       struct interface_driver *driver)
+{
+	struct interface_attachment *attach;
+
+	list_for_each_entry(attach, &intf->drivers, list)
+		if (attach->driver == driver)
+			return true;
+
+	return false;
+}
+
+static int interface_attach(struct interface *intf,
+			    struct interface_driver *driver)
+{
+	struct interface_attachment *attach;
+
+	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
+	if (!attach)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&attach->list);
+	attach->driver = driver;
+
+	list_add_tail(&attach->list, &intf->drivers);
+
+	return 0;
+}
+
+static void interface_detach(struct interface *intf,
+			     struct interface_driver *driver)
+{
+	struct interface_attachment *attach;
+
+	list_for_each_entry(attach, &intf->drivers, list) {
+		if (attach->driver == driver) {
+			list_del(&attach->list);
+			kfree(attach);
+			return;
+		}
+	}
+}
+
+static void interface_bind(struct interface *intf,
+			   struct interface_driver *driver)
+{
+	int err;
+
+	if (interface_attached(intf, driver))
+		return;
+
+	if (!interface_match(intf, driver))
+		return;
+
+	err = interface_attach(intf, driver);
+	if (err < 0) {
+		pr_err("failed to attach driver %ps to interface %s: %d\n",
+		       driver, intf->name, err);
+		return;
+	}
+
+	err = driver->bind(intf);
+	if (err < 0) {
+		pr_err("failed to bind driver %ps to interface %s: %d\n",
+		       driver, intf->name, err);
+		interface_detach(intf, driver);
+		return;
+	}
+
+	pr_debug("driver %ps bound to interface %s\n", driver, intf->name);
+}
+
+static void interface_unbind(struct interface *intf,
+			     struct interface_driver *driver)
+{
+	if (!interface_attached(intf, driver))
+		return;
+
+	interface_detach(intf, driver);
+	driver->unbind(intf);
+
+	pr_debug("driver %ps unbound from interface %s\n", driver, intf->name);
+}
+
+int interface_add(struct interface *intf)
+{
+	struct interface_driver *driver;
+
+	INIT_LIST_HEAD(&intf->drivers);
+	INIT_LIST_HEAD(&intf->list);
+
+	mutex_lock(&interfaces_lock);
+
+	list_add_tail(&intf->list, &interfaces);
+
+	pr_debug("interface %s added for device %s\n", intf->name,
+		 dev_name(intf->dev));
+
+	list_for_each_entry(driver, &drivers, list)
+		interface_bind(intf, driver);
+
+	mutex_unlock(&interfaces_lock);
+
+	return 0;
+}
+
+void interface_remove(struct interface *intf)
+{
+	struct interface_driver *driver;
+
+	mutex_lock(&interfaces_lock);
+
+	list_for_each_entry(driver, &drivers, list)
+		interface_unbind(intf, driver);
+
+	list_del_init(&intf->list);
+
+	pr_debug("interface %s removed for device %s\n", intf->name,
+		 dev_name(intf->dev));
+
+	mutex_unlock(&interfaces_lock);
+}
+
+int interface_register_driver(struct interface_driver *driver)
+{
+	struct interface *intf;
+
+	mutex_lock(&interfaces_lock);
+
+	list_add_tail(&driver->list, &drivers);
+
+	pr_debug("driver %ps added\n", driver);
+
+	list_for_each_entry(intf, &interfaces, list)
+		interface_bind(intf, driver);
+
+	mutex_unlock(&interfaces_lock);
+
+	return 0;
+}
+
+void interface_unregister_driver(struct interface_driver *driver)
+{
+	struct interface *intf;
+
+	mutex_lock(&interfaces_lock);
+
+	list_for_each_entry(intf, &interfaces, list)
+		interface_unbind(intf, driver);
+
+	list_del_init(&driver->list);
+
+	pr_debug("driver %ps removed\n", driver);
+
+	mutex_unlock(&interfaces_lock);
+}
diff --git a/include/linux/interface.h b/include/linux/interface.h
new file mode 100644
index 000000000000..2c49ad3912fe
--- /dev/null
+++ b/include/linux/interface.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) 2014 NVIDIA Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef INTERFACE_H
+#define INTERFACE_H
+
+#include <linux/list.h>
+
+struct device;
+struct interface;
+
+struct interface_driver {
+	const char *name;
+
+	int (*bind)(struct interface *intf);
+	void (*unbind)(struct interface *intf);
+
+	struct list_head list;
+};
+
+int interface_register_driver(struct interface_driver *driver);
+void interface_unregister_driver(struct interface_driver *driver);
+
+struct interface {
+	const char *name;
+	struct device *dev;
+
+	struct list_head drivers;
+	struct list_head list;
+};
+
+int interface_add(struct interface *intf);
+void interface_remove(struct interface *intf);
+
+#endif
-- 
1.9.2

