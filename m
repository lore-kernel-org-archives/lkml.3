Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3C0Pg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:36:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:24787 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab3C0PbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:31:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,920,1355126400"; 
   d="scan'208";a="308169925"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 01/11 V5] mei: bus: Initial MEI Client bus type implementation
Date: Wed, 27 Mar 2013 17:29:53 +0200
Message-Id: <1364398203-11159-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364398203-11159-1-git-send-email-tomas.winkler@intel.com>
References: <1364398203-11159-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

mei client bus will present some of the mei clients
as devices for other standard subsystems

Implement the probe, remove, match, device addtion routines, along with
the sysfs and uevent ones. mei_cl_device_id is also added to
mod_devicetable.h
A mei-cleint-bus.txt document describing the rationale and the API usage
is also added while ABI/testing/sysfs-bus-mei describeis the modalias ABI.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-mei           |   7 +
 Documentation/misc-devices/mei/mei-client-bus.txt | 135 +++++++++++++++++
 drivers/misc/mei/Makefile                         |   1 +
 drivers/misc/mei/bus.c                            | 172 ++++++++++++++++++++++
 drivers/misc/mei/mei_dev.h                        |  26 ++++
 include/linux/mei_cl_bus.h                        |  20 +++
 include/linux/mod_devicetable.h                   |   9 ++
 scripts/mod/devicetable-offsets.c                 |   3 +
 scripts/mod/file2alias.c                          |  12 ++
 9 files changed, 385 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-mei
 create mode 100644 Documentation/misc-devices/mei/mei-client-bus.txt
 create mode 100644 drivers/misc/mei/bus.c
 create mode 100644 include/linux/mei_cl_bus.h

diff --git a/Documentation/ABI/testing/sysfs-bus-mei b/Documentation/ABI/testing/sysfs-bus-mei
new file mode 100644
index 0000000..2066f0b
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-mei
@@ -0,0 +1,7 @@
+What:		/sys/bus/mei/devices/.../modalias
+Date:		March 2013
+KernelVersion:	3.10
+Contact:	Samuel Ortiz <sameo@linux.intel.com>
+		linux-mei@linux.intel.com
+Description:	Stores the same MODALIAS value emitted by uevent
+		Format: mei:<mei device name>
diff --git a/Documentation/misc-devices/mei/mei-client-bus.txt b/Documentation/misc-devices/mei/mei-client-bus.txt
new file mode 100644
index 0000000..9dc5ebf
--- /dev/null
+++ b/Documentation/misc-devices/mei/mei-client-bus.txt
@@ -0,0 +1,135 @@
+Intel(R) Management Engine (ME) Client bus API
+===============================================
+
+
+Rationale
+=========
+MEI misc character device is useful for dedicated applications to send and receive
+data to the many FW appliance found in Intel's ME from the user space.
+However for some of the ME functionalities it make sense to leverage existing software
+stack and expose them through existing kernel subsystems.
+
+In order to plug seamlessly into the kernel device driver model we add kernel virtual
+bus abstraction on top of the MEI driver. This allows implementing linux kernel drivers
+for the various MEI features as a stand alone entities found in their respective subsystem.
+Existing device drivers can even potentially be re-used by adding an MEI CL bus layer to
+the existing code.
+
+
+MEI CL bus API
+===========
+A driver implementation for an MEI Client is very similar to existing bus
+based device drivers. The driver registers itself as an MEI CL bus driver through
+the mei_cl_driver structure:
+
+struct mei_cl_driver {
+	struct device_driver driver;
+	const char *name;
+
+	const struct mei_cl_device_id *id_table;
+
+	int (*probe)(struct mei_cl_device *dev, const struct mei_cl_id *id);
+	int (*remove)(struct mei_cl_device *dev);
+};
+
+struct mei_cl_id {
+	char name[MEI_NAME_SIZE];
+	kernel_ulong_t driver_info;
+};
+
+The mei_cl_id structure allows the driver to bind itself against a device name.
+
+To actually register a driver on the ME Client bus one must call the mei_cl_add_driver()
+API. This is typically called at module init time.
+
+Once registered on the ME Client bus, a driver will typically try to do some I/O on
+this bus and this should be done through the mei_cl_send() and mei_cl_recv()
+routines. The latter is synchronous (blocks and sleeps until data shows up).
+In order for drivers to be notified of pending events waiting for them (e.g.
+an Rx event) they can register an event handler through the
+mei_cl_register_event_cb() routine. Currently only the MEI_EVENT_RX event
+will trigger an event handler call and the driver implementation is supposed
+to call mei_recv() from the event handler in order to fetch the pending
+received buffers.
+
+
+Example
+=======
+As a theoretical example let's pretend the ME comes with a "contact" NFC IP.
+The driver init and exit routines for this device would look like:
+
+#define CONTACT_DRIVER_NAME "contact"
+
+static struct mei_cl_device_id contact_mei_cl_tbl[] = {
+	{ CONTACT_DRIVER_NAME, },
+
+	/* required last entry */
+	{ }
+};
+MODULE_DEVICE_TABLE(mei_cl, contact_mei_cl_tbl);
+
+static struct mei_cl_driver contact_driver = {
+       .id_table = contact_mei_tbl,
+       .name = CONTACT_DRIVER_NAME,
+
+       .probe = contact_probe,
+       .remove = contact_remove,
+};
+
+static int contact_init(void)
+{
+	int r;
+
+	r = mei_cl_driver_register(&contact_driver);
+	if (r) {
+		pr_err(CONTACT_DRIVER_NAME ": driver registration failed\n");
+		return r;
+	}
+
+	return 0;
+}
+
+static void __exit contact_exit(void)
+{
+	mei_cl_driver_unregister(&contact_driver);
+}
+
+module_init(contact_init);
+module_exit(contact_exit);
+
+And the driver's simplified probe routine would look like that:
+
+int contact_probe(struct mei_cl_device *dev, struct mei_cl_device_id *id)
+{
+	struct contact_driver *contact;
+
+	[...]
+	mei_cl_register_event_cb(dev, contact_event_cb, contact);
+
+	return 0;
+ }
+
+In the probe routine the driver basically registers an ME bus event handler
+which is as close as it can get to registering a threaded IRQ handler.
+The handler implementation will typically call some I/O routine depending on
+the pending events:
+
+#define MAX_NFC_PAYLOAD 128
+
+static void contact_event_cb(struct mei_cl_device *dev, u32 events,
+			     void *context)
+{
+	struct contact_driver *contact = context;
+
+	if (events & BIT(MEI_EVENT_RX)) {
+		u8 payload[MAX_NFC_PAYLOAD];
+		int payload_size;
+
+		payload_size = mei_recv(dev, payload, MAX_NFC_PAYLOAD);
+		if (payload_size <= 0)
+			return;
+
+		/* Hook to the NFC subsystem */
+		nfc_hci_recv_frame(contact->hdev, payload, payload_size);
+	}
+}
diff --git a/drivers/misc/mei/Makefile b/drivers/misc/mei/Makefile
index 2c336d0..1b29f7c 100644
--- a/drivers/misc/mei/Makefile
+++ b/drivers/misc/mei/Makefile
@@ -10,6 +10,7 @@ mei-objs += client.o
 mei-objs += main.o
 mei-objs += amthif.o
 mei-objs += wd.o
+mei-objs += bus.o
 
 obj-$(CONFIG_INTEL_MEI_ME) += mei-me.o
 mei-me-objs := pci-me.o
diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
new file mode 100644
index 0000000..78c876a
--- /dev/null
+++ b/drivers/misc/mei/bus.c
@@ -0,0 +1,172 @@
+/*
+ * Intel Management Engine Interface (Intel MEI) Linux driver
+ * Copyright (c) 2012-2013, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/mei_cl_bus.h>
+
+#include "mei_dev.h"
+
+#define to_mei_cl_driver(d) container_of(d, struct mei_cl_driver, driver)
+#define to_mei_cl_device(d) container_of(d, struct mei_cl_device, dev)
+
+static int mei_cl_device_match(struct device *dev, struct device_driver *drv)
+{
+	struct mei_cl_device *device = to_mei_cl_device(dev);
+	struct mei_cl_driver *driver = to_mei_cl_driver(drv);
+	const struct mei_cl_device_id *id;
+
+	if (!device)
+		return 0;
+
+	if (!driver || !driver->id_table)
+		return 0;
+
+	id = driver->id_table;
+
+	while (id->name[0]) {
+		if (!strcmp(dev_name(dev), id->name))
+			return 1;
+
+		id++;
+	}
+
+	return 0;
+}
+
+static int mei_cl_device_probe(struct device *dev)
+{
+	struct mei_cl_device *device = to_mei_cl_device(dev);
+	struct mei_cl_driver *driver;
+	struct mei_cl_device_id id;
+
+	if (!device)
+		return 0;
+
+	driver = to_mei_cl_driver(dev->driver);
+	if (!driver || !driver->probe)
+		return -ENODEV;
+
+	dev_dbg(dev, "Device probe\n");
+
+	strncpy(id.name, dev_name(dev), MEI_CL_NAME_SIZE);
+
+	return driver->probe(device, &id);
+}
+
+static int mei_cl_device_remove(struct device *dev)
+{
+	struct mei_cl_device *device = to_mei_cl_device(dev);
+	struct mei_cl_driver *driver;
+
+	if (!device || !dev->driver)
+		return 0;
+
+	driver = to_mei_cl_driver(dev->driver);
+	if (!driver->remove) {
+		dev->driver = NULL;
+
+		return 0;
+	}
+
+	return driver->remove(device);
+}
+
+static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
+			     char *buf)
+{
+	int len;
+
+	len = snprintf(buf, PAGE_SIZE, "mei:%s\n", dev_name(dev));
+
+	return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
+}
+
+static struct device_attribute mei_cl_dev_attrs[] = {
+	__ATTR_RO(modalias),
+	__ATTR_NULL,
+};
+
+static int mei_cl_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	if (add_uevent_var(env, "MODALIAS=mei:%s", dev_name(dev)))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static struct bus_type mei_cl_bus_type = {
+	.name		= "mei",
+	.dev_attrs	= mei_cl_dev_attrs,
+	.match		= mei_cl_device_match,
+	.probe		= mei_cl_device_probe,
+	.remove		= mei_cl_device_remove,
+	.uevent		= mei_cl_uevent,
+};
+
+static void mei_cl_dev_release(struct device *dev)
+{
+	kfree(to_mei_cl_device(dev));
+}
+
+static struct device_type mei_cl_device_type = {
+	.release	= mei_cl_dev_release,
+};
+
+struct mei_cl_device *mei_cl_add_device(struct mei_device *mei_device,
+				  uuid_le uuid, char *name)
+{
+	struct mei_cl_device *device;
+	int status;
+
+	device = kzalloc(sizeof(struct mei_cl_device), GFP_KERNEL);
+	if (!device)
+		return NULL;
+
+	device->dev.parent = &mei_device->pdev->dev;
+	device->dev.bus = &mei_cl_bus_type;
+	device->dev.type = &mei_cl_device_type;
+
+	dev_set_name(&device->dev, "%s", name);
+
+	status = device_register(&device->dev);
+	if (status)
+		goto out_err;
+
+	dev_dbg(&device->dev, "client %s registered\n", name);
+
+	return device;
+
+out_err:
+	dev_err(device->dev.parent, "Failed to register MEI client\n");
+
+	kfree(device);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(mei_cl_add_device);
+
+void mei_cl_remove_device(struct mei_cl_device *device)
+{
+	device_unregister(&device->dev);
+}
+EXPORT_SYMBOL_GPL(mei_cl_remove_device);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index b5d6607..7abb705d 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -21,6 +21,7 @@
 #include <linux/watchdog.h>
 #include <linux/poll.h>
 #include <linux/mei.h>
+#include <linux/mei_cl_bus.h>
 
 #include "hw.h"
 #include "hw-me-regs.h"
@@ -262,6 +263,31 @@ struct mei_hw_ops {
 		     unsigned char *buf, unsigned long len);
 };
 
+/* MEI bus API*/
+struct mei_cl_device *mei_cl_add_device(struct mei_device *dev,
+				  uuid_le uuid, char *name);
+void mei_cl_remove_device(struct mei_cl_device *device);
+
+/**
+ * struct mei_cl_device - MEI device handle
+ * An mei_cl_device pointer is returned from mei_add_device()
+ * and links MEI bus clients to their actual ME host client pointer.
+ * Drivers for MEI devices will get an mei_cl_device pointer
+ * when being probed and shall use it for doing ME bus I/O.
+ *
+ * @dev: linux driver model device pointer
+ * @uuid: me client uuid
+ * @cl: mei client
+ * @priv_data: client private data
+ */
+struct mei_cl_device {
+	struct device dev;
+
+	struct mei_cl *cl;
+
+	void *priv_data;
+};
+
 /**
  * struct mei_device -  MEI private device struct
 
diff --git a/include/linux/mei_cl_bus.h b/include/linux/mei_cl_bus.h
new file mode 100644
index 0000000..4e7351d
--- /dev/null
+++ b/include/linux/mei_cl_bus.h
@@ -0,0 +1,20 @@
+#ifndef _LINUX_MEI_CL_BUS_H
+#define _LINUX_MEI_CL_BUS_H
+
+#include <linux/device.h>
+#include <linux/uuid.h>
+
+struct mei_cl_device;
+
+struct mei_cl_driver {
+	struct device_driver driver;
+	const char *name;
+
+	const struct mei_cl_device_id *id_table;
+
+	int (*probe)(struct mei_cl_device *dev,
+		     const struct mei_cl_device_id *id);
+	int (*remove)(struct mei_cl_device *dev);
+};
+
+#endif /* _LINUX_MEI_CL_BUS_H */
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 779cf7c..b508016 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -9,6 +9,7 @@
 
 #ifdef __KERNEL__
 #include <linux/types.h>
+#include <linux/uuid.h>
 typedef unsigned long kernel_ulong_t;
 #endif
 
@@ -568,4 +569,12 @@ struct ipack_device_id {
 	__u32 device;			/* Device ID or IPACK_ANY_ID */
 };
 
+#define MEI_CL_MODULE_PREFIX "mei:"
+#define MEI_CL_NAME_SIZE 32
+
+struct mei_cl_device_id {
+	char name[MEI_CL_NAME_SIZE];
+	kernel_ulong_t driver_info;
+};
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index b45260b..e66d4d2 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -174,5 +174,8 @@ int main(void)
 	DEVID_FIELD(x86_cpu_id, model);
 	DEVID_FIELD(x86_cpu_id, vendor);
 
+	DEVID(mei_cl_device_id);
+	DEVID_FIELD(mei_cl_device_id, name);
+
 	return 0;
 }
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 771ac17..45f9a33 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1133,6 +1133,18 @@ static int do_x86cpu_entry(const char *filename, void *symval,
 }
 ADD_TO_DEVTABLE("x86cpu", x86_cpu_id, do_x86cpu_entry);
 
+/* Looks like: mei:S */
+static int do_mei_entry(const char *filename, void *symval,
+			char *alias)
+{
+	DEF_FIELD_ADDR(symval, mei_cl_device_id, name);
+
+	sprintf(alias, MEI_CL_MODULE_PREFIX "%s", *name);
+
+	return 1;
+}
+ADD_TO_DEVTABLE("mei", mei_cl_device_id, do_mei_entry);
+
 /* Does namelen bytes of name exactly match the symbol? */
 static bool sym_is(const char *name, unsigned namelen, const char *symbol)
 {
-- 
1.7.11.7

