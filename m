Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745Ab3BLShp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:37:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:17481 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933688Ab3BLShi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:37:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="290196028"
From: Samuel Ortiz <sameo@linux.intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 02/12 v3] mei: bus: Initial MEI bus type implementation
Date: Tue, 12 Feb 2013 19:36:52 +0100
Message-Id: <1360694222-27632-3-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei bus will present some of the me clients
as devices for other standard subsystems

Implement the probe, remove, match and the device addtion routines.
A mei-bus.txt document describing the rationale and the API usage
is also added.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 Documentation/misc-devices/mei/mei-bus.txt |  138 +++++++++++++++++++++++++
 drivers/misc/mei/Makefile                  |    1 +
 drivers/misc/mei/bus.c                     |  151 ++++++++++++++++++++++++++++
 drivers/misc/mei/mei_dev.h                 |   27 +++++
 include/linux/mei_bus.h                    |   92 +++++++++++++++++
 5 files changed, 409 insertions(+)
 create mode 100644 Documentation/misc-devices/mei/mei-bus.txt
 create mode 100644 drivers/misc/mei/bus.c
 create mode 100644 include/linux/mei_bus.h

diff --git a/Documentation/misc-devices/mei/mei-bus.txt b/Documentation/misc-devices/mei/mei-bus.txt
new file mode 100644
index 0000000..1558343
--- /dev/null
+++ b/Documentation/misc-devices/mei/mei-bus.txt
@@ -0,0 +1,138 @@
+Intel(R) Management Engine (ME) bus API
+=======================================
+
+
+Rationale
+=========
+While a misc character device is useful for applications to send and receive
+data to the many IP blocks found in Intel's ME, kernel drivers rely on the
+device model to be probed.
+By adding a kernel virtual bus abstraction on top of the MEI driver we can
+implement drivers for the various MEI features as standalone ones, found in
+their respective subsystem. Existing drivers can even potentially be re-used
+by adding an MEI bus layer to the existing code.
+
+
+MEI bus API
+===========
+A driver implementation for an MEI IP block is very similar to existing bus
+based device drivers. The driver registers itself as an MEI bus driver through
+the mei_driver structure:
+
+struct mei_driver {
+	struct device_driver driver;
+	const char *name;
+
+	const struct mei_id *id_table;
+
+	int (*probe)(struct mei_device *dev, const struct mei_id *id);
+	int (*remove)(struct mei_device *dev);
+};
+
+struct mei_id {
+	char name[MEI_NAME_SIZE];
+	uuid_le uuid;
+};
+
+The mei_id structure allows the driver to bind itself against an ME UUID and a
+device name. There typically is one ME UUID per technology and the mei_id name
+field matches a specific device name within that technology. As an example,
+the ME supports several NFC devices: All of them have the same ME UUID but the
+ME bus code will assign each of them a different name.
+
+To actually register a driver on the ME bus one must call the mei_add_driver()
+API. This is typically called at module init time.
+
+Once registered on the ME bus, a driver will typically try to do some I/O on
+this bus and this should be done through the mei_send() and mei_recv()
+routines. The latter is synchronous (blocks and sleeps until data shows up).
+In order for drivers to be notified of pending events waiting for them (e.g.
+an Rx event) they can register an event handler through the
+mei_register_event_cb() routine. Currently only the MEI_EVENT_RX event
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
+#define NFC_UUID UUID_LE(0x0bb17a78, 0x2a8e, 0x4c50, 0x94, \
+			       0xd4, 0x50, 0x26, 0x67, 0x23, 0x77, 0x5c)
+
+static struct mei_id contact_mei_tbl[] = {
+	{ CONTACT_DRIVER_NAME, NFC_UUID },
+
+	/* required last entry */
+	{ }
+};
+
+static struct mei_driver contact_driver = {
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
+	r = mei_driver_register(&contact_driver);
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
+	mei_driver_unregister(&contact_driver);
+}
+
+module_init(contact_init);
+module_exit(contact_exit);
+
+And the driver's simplified probe routine would look like that:
+
+int contact_probe(struct mei_device *dev, struct mei_id *id)
+{
+	struct contact_driver *contact;
+
+	[...]
+	mei_register_event_cb(dev, contact_event_cb, contact);
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
+static void contact_event_cb(struct mei_device *dev, u32 events,
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
index 040af6c..5948621 100644
--- a/drivers/misc/mei/Makefile
+++ b/drivers/misc/mei/Makefile
@@ -10,5 +10,6 @@ mei-objs += client.o
 mei-objs += main.o
 mei-objs += amthif.o
 mei-objs += wd.o
+mei-objs += bus.o
 mei-$(CONFIG_INTEL_MEI_ME) += pci-me.o
 mei-$(CONFIG_INTEL_MEI_ME) += hw-me.o
diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
new file mode 100644
index 0000000..485fcf3c
--- /dev/null
+++ b/drivers/misc/mei/bus.c
@@ -0,0 +1,151 @@
+/*
+ * Intel Management Engine Interface (Intel MEI) Linux driver
+ * Copyright (c) 2012, Intel Corporation.
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
+#include <linux/mei_bus.h>
+
+#include "mei_dev.h"
+
+#define to_mei_driver(d) container_of(d, struct mei_driver, driver)
+#define to_mei_device(d) container_of(d, struct mei_device, dev)
+
+static int mei_device_match(struct device *dev, struct device_driver *drv)
+{
+	struct mei_device *device = to_mei_device(dev);
+	struct mei_driver *driver = to_mei_driver(drv);
+	const struct mei_id *id;
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
+		if (!uuid_le_cmp(device->uuid, id->uuid) &&
+		    !strcmp(dev_name(dev), id->name))
+			return 1;
+
+		id++;
+	}
+
+	return 0;
+}
+
+static int mei_device_probe(struct device *dev)
+{
+	struct mei_device *device = to_mei_device(dev);
+	struct mei_driver *driver;
+	struct mei_id id;
+
+	if (!device)
+		return 0;
+
+	driver = to_mei_driver(dev->driver);
+	if (!driver || !driver->probe)
+		return -ENODEV;
+
+	dev_dbg(dev, "Device probe\n");
+
+	id.uuid = device->uuid;
+	strncpy(id.name, dev_name(dev), MEI_NAME_SIZE);
+
+	return driver->probe(device, &id);
+}
+
+static int mei_device_remove(struct device *dev)
+{
+	struct mei_device *device = to_mei_device(dev);
+	struct mei_driver *driver;
+
+	if (!device || !dev->driver)
+		return 0;
+
+	driver = to_mei_driver(dev->driver);
+	if (!driver->remove) {
+		dev->driver = NULL;
+
+		return 0;
+	}
+
+	return driver->remove(device);
+}
+
+static struct bus_type mei_bus_type = {
+	.name		= "mei",
+	.match		= mei_device_match,
+	.probe		= mei_device_probe,
+	.remove		= mei_device_remove,
+};
+
+static void mei_client_dev_release(struct device *dev)
+{
+	kfree(to_mei_device(dev));
+}
+
+static struct device_type mei_client_type = {
+	.release	= mei_client_dev_release,
+};
+
+struct mei_device *mei_add_device(struct mei_host *mei_host,
+				  uuid_le uuid, char *name)
+{
+	struct mei_device *device;
+	int status;
+
+	device = kzalloc(sizeof(struct mei_device), GFP_KERNEL);
+	if (!device)
+		return NULL;
+
+	device->uuid = uuid;
+
+	device->dev.parent = &mei_host->pdev->dev;
+	device->dev.bus = &mei_bus_type;
+	device->dev.type = &mei_client_type;
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
+EXPORT_SYMBOL_GPL(mei_add_device);
+
+void mei_remove_device(struct mei_device *device)
+{
+	device_unregister(&device->dev);
+}
+EXPORT_SYMBOL_GPL(mei_remove_device);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index b521313..5f65617 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -21,6 +21,7 @@
 #include <linux/watchdog.h>
 #include <linux/poll.h>
 #include <linux/mei.h>
+#include <linux/mei_bus.h>
 
 #include "hw.h"
 #include "hw-me-regs.h"
@@ -263,6 +264,32 @@ struct mei_hw_ops {
 		     unsigned char *buf, unsigned long len);
 };
 
+/* MEI bus API*/
+struct mei_device *mei_add_device(struct mei_host *mei_host,
+				  uuid_le uuid, char *name);
+void mei_remove_device(struct mei_device *device);
+
+/**
+ * struct mei_device - MEI device handle
+ * An mei_device pointer is returned from mei_add_device()
+ * and links MEI bus clients to their actual ME host client pointer.
+ * Drivers for MEI devices will get an mei_device pointer
+ * when being probed and shall use it for doing ME bus I/O.
+ *
+ * @dev: linux driver model device pointer
+ * @uuid: me client uuid
+ * @cl: mei client
+ * @priv_data: client private data
+ */
+struct mei_device {
+	struct device dev;
+
+	uuid_le uuid;
+	struct mei_cl *cl;
+
+	void *priv_data;
+};
+
 /**
  * struct mei_host -  MEI private host struct
 
diff --git a/include/linux/mei_bus.h b/include/linux/mei_bus.h
new file mode 100644
index 0000000..6506cb7
--- /dev/null
+++ b/include/linux/mei_bus.h
@@ -0,0 +1,92 @@
+/******************************************************************************
+ * Intel Management Engine Interface (Intel MEI) Linux driver
+ * Intel MEI Interface Header
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *	Intel Corporation.
+ *	linux-mei@linux.intel.com
+ *	http://www.intel.com
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+
+#ifndef _LINUX_MEI_BUS_H
+#define _LINUX_MEI_BUS_H
+
+#include <linux/device.h>
+#include <linux/uuid.h>
+
+struct mei_device;
+
+#define MEI_NAME_SIZE 32
+
+struct mei_id {
+	char name[MEI_NAME_SIZE];
+	uuid_le uuid;
+};
+
+struct mei_driver {
+	struct device_driver driver;
+	const char *name;
+
+	const struct mei_id *id_table;
+
+	int (*probe)(struct mei_device *dev, const struct mei_id *id);
+	int (*remove)(struct mei_device *dev);
+};
+
+#endif /* _LINUX_MEI_BUS_H */
-- 
1.7.10.4

