Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3L0WQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:16:20 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62937 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755053Ab3L0WQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:16:13 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 2/2] ACPI / hotplug / driver core: Handle containers in a special way
Date: Fri, 27 Dec 2013 23:28:34 +0100
Message-ID: <1991202.gilW172FBV@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <63118574.0bgUpLnDbK@vostro.rjw.lan>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan> <2686210.6vSP0yehxh@vostro.rjw.lan> <63118574.0bgUpLnDbK@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

ACPI container devices require special hotplug handling, at least
on some systems, since generally user space needs to carry out
system-specific cleanup before it makes sense to offline devices in
the container.  However, the current ACPI hotplug code for containers
first attempts to offline devices in the container and only then it
notifies user space of the container offline.

Moreover, after commit 202317a573b2 (ACPI / scan: Add acpi_device
objects for all device nodes in the namespace), ACPI device objects
representing containers are present as long as the ACPI namespace
nodes corresponding to them are present, which may be forever, even
if the container devices are physically detached from the system (the
return values of the corresponding _STA methods change in those
cases, but generally the namespace nodes themselves are still there).
Thus it is useful to introduce entities representing containers that
will go away during container hot-unplug.

The goal of this change is to address both the above issues.

The idea is to create a "companion" container system device for each
of the ACPI container device objects during the initial namespace
scan or on a hotplug event making the container present.  That system
device will be unregistered on container removal.  A new bus type
for container devices is added for this purpose, because device
offline and online operations need to be defined for them.  The
online operation is a trivial function that is always successful
and the offline uses a callback pointed to by the container device's
offline member.

For ACPI containers that callback simply walks the list of ACPI
device objects right below the container object (its children) and
checks if all of their physical companion devices are offline.  If
that's not the case, it returns -EBUSY and the container system
device cannot be put offline.  Consequently, to put the container
system device offline, it is necessary to put all of the physical
devices depending on its ACPI companion object offline beforehand.

Container system devices created for ACPI container objects are
initially online.  They are created by the container ACPI scan
handler whose hotplug.demand_offline flag is set.  That causes
acpi_scan_hot_remove() to check if the companion container system
device is offline before attempting to remove an ACPI container or
any devices below it.  If the check fails, a KOBJ_CHANGE uevent is
emitted for the container system device in question and user space
is expected to offline all devices below the container and the
container itself in response to it.  Then, user space can finalize
the removal of the container with the help of its ACPI device
object's eject attribute in sysfs.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 drivers/acpi/container.c  |   48 ++++++++++++++++++++++++++++++++++++++++++----
 drivers/acpi/internal.h   |    1 
 drivers/acpi/scan.c       |    8 ++++---
 drivers/base/Makefile     |    2 -
 drivers/base/base.h       |    1 
 drivers/base/container.c  |   44 ++++++++++++++++++++++++++++++++++++++++++
 drivers/base/init.c       |    1 
 include/linux/container.h |   25 +++++++++++++++++++++++
 8 files changed, 122 insertions(+), 8 deletions(-)

Index: linux-pm/include/linux/container.h
===================================================================
--- /dev/null
+++ linux-pm/include/linux/container.h
@@ -0,0 +1,25 @@
+/*
+ * Definitions for container bus type.
+ *
+ * Copyright (C) 2013, Intel Corporation
+ * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/device.h>
+
+/* drivers/base/power/container.c */
+extern struct bus_type container_subsys;
+
+struct container_dev {
+	struct device dev;
+	int (*offline)(struct container_dev *cdev);
+};
+
+static inline struct container_dev *to_container_dev(struct device *dev)
+{
+	return container_of(dev, struct container_dev, dev);
+}
Index: linux-pm/drivers/base/container.c
===================================================================
--- /dev/null
+++ linux-pm/drivers/base/container.c
@@ -0,0 +1,44 @@
+/*
+ * System bus type for containers.
+ *
+ * Copyright (C) 2013, Intel Corporation
+ * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/container.h>
+
+#include "base.h"
+
+#define CONTAINER_BUS_NAME	"container"
+
+static int trivial_online(struct device *dev)
+{
+	return 0;
+}
+
+static int container_offline(struct device *dev)
+{
+	struct container_dev *cdev = to_container_dev(dev);
+
+	return cdev->offline ? cdev->offline(cdev) : 0;
+}
+
+struct bus_type container_subsys = {
+	.name = CONTAINER_BUS_NAME,
+	.dev_name = CONTAINER_BUS_NAME,
+	.online = trivial_online,
+	.offline = container_offline,
+};
+
+void __init container_dev_init(void)
+{
+	int ret;
+
+	ret = subsys_system_register(&container_subsys, NULL);
+	if (ret)
+		pr_err("%s() failed: %d\n", __func__, ret);
+}
Index: linux-pm/drivers/base/base.h
===================================================================
--- linux-pm.orig/drivers/base/base.h
+++ linux-pm/drivers/base/base.h
@@ -100,6 +100,7 @@ static inline int hypervisor_init(void)
 #endif
 extern int platform_bus_init(void);
 extern void cpu_dev_init(void);
+extern void container_dev_init(void);
 
 struct kobject *virtual_device_parent(struct device *dev);
 
Index: linux-pm/drivers/base/init.c
===================================================================
--- linux-pm.orig/drivers/base/init.c
+++ linux-pm/drivers/base/init.c
@@ -33,4 +33,5 @@ void __init driver_init(void)
 	platform_bus_init();
 	cpu_dev_init();
 	memory_dev_init();
+	container_dev_init();
 }
Index: linux-pm/drivers/base/Makefile
===================================================================
--- linux-pm.orig/drivers/base/Makefile
+++ linux-pm/drivers/base/Makefile
@@ -4,7 +4,7 @@ obj-y			:= core.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o \
-			   topology.o
+			   topology.o container.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
 obj-y			+= power/
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -73,6 +73,7 @@ static inline void acpi_lpss_init(void)
 #endif
 
 bool acpi_queue_hotplug_work(struct work_struct *work);
+bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent);
 
 /* --------------------------------------------------------------------------
                      Device Node Initialization / Removal
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -126,7 +126,7 @@ acpi_device_modalias_show(struct device
 }
 static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
 
-static bool acpi_scan_is_offline(struct acpi_device *adev)
+bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent)
 {
 	struct acpi_device_physical_node *pn;
 	bool offline = true;
@@ -135,7 +135,9 @@ static bool acpi_scan_is_offline(struct
 
 	list_for_each_entry(pn, &adev->physical_node_list, node)
 		if (device_supports_offline(pn->dev) && !pn->dev->offline) {
-			kobject_uevent(&pn->dev->kobj, KOBJ_CHANGE);
+			if (uevent)
+				kobject_uevent(&pn->dev->kobj, KOBJ_CHANGE);
+
 			offline = false;
 			break;
 		}
@@ -267,7 +269,7 @@ static int acpi_scan_hot_remove(struct a
 	acpi_status status;
 
 	if (device->handler->hotplug.demand_offline && !acpi_force_hot_remove) {
-		if (!acpi_scan_is_offline(device))
+		if (!acpi_scan_is_offline(device, true))
 			return -EBUSY;
 	} else {
 		int error = acpi_scan_try_to_offline(device);
Index: linux-pm/drivers/acpi/container.c
===================================================================
--- linux-pm.orig/drivers/acpi/container.c
+++ linux-pm/drivers/acpi/container.c
@@ -27,8 +27,7 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 #include <linux/acpi.h>
-
-#include "internal.h"
+#include <linux/container.h>
 
 #include "internal.h"
 
@@ -44,16 +43,56 @@ static const struct acpi_device_id conta
 	{"", 0},
 };
 
+static int acpi_container_offline(struct container_dev *cdev)
+{
+	struct acpi_device *adev = ACPI_COMPANION(&cdev->dev);
+	struct acpi_device *child;
+
+	/* Check all of the dependent devices' physical companions. */
+	list_for_each_entry(child, &adev->children, node)
+		if (!acpi_scan_is_offline(child, false))
+			return -EBUSY;
+
+	return 0;
+}
+
+static void acpi_container_release(struct device *dev)
+{
+	kfree(to_container_dev(dev));
+}
+
 static int container_device_attach(struct acpi_device *adev,
 				   const struct acpi_device_id *not_used)
 {
-	kobject_uevent(&adev->dev.kobj, KOBJ_ONLINE);
+	struct container_dev *cdev;
+	struct device *dev;
+	int ret;
+
+	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
+	if (!cdev)
+		return -ENOMEM;
+
+	cdev->offline = acpi_container_offline;
+	dev = &cdev->dev;
+	dev->bus = &container_subsys;
+	dev_set_name(dev, "%s", dev_name(&adev->dev));
+	ACPI_COMPANION_SET(dev, adev);
+	dev->release = acpi_container_release;
+	ret = device_register(dev);
+	if (ret)
+		return ret;
+
+	adev->driver_data = dev;
 	return 1;
 }
 
 static void container_device_detach(struct acpi_device *adev)
 {
-	kobject_uevent(&adev->dev.kobj, KOBJ_OFFLINE);
+	struct device *dev = acpi_driver_data(adev);
+
+	adev->driver_data = NULL;
+	if (dev)
+		device_unregister(dev);
 }
 
 static struct acpi_scan_handler container_handler = {
@@ -62,6 +101,7 @@ static struct acpi_scan_handler containe
 	.detach = container_device_detach,
 	.hotplug = {
 		.enabled = true,
+		.demand_offline = true,
 	},
 };
 

