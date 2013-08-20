Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab3HTJWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:22:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:44963 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab3HTJWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:22:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,918,1367996400"; 
   d="scan'208";a="348827440"
Date: Tue, 20 Aug 2013 12:28:13 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Wolfram Sang <wsa@the-dreams.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jerry Snitselaar <jerry.snitselaar@oracle.com>
Subject: Re: [PATCH] i2c: move of helpers into the core
Message-ID: <20130820092813.GW4898@intel.com>
References: <1376918361-7014-1-git-send-email-wsa@the-dreams.de>
 <3792014.HtzPVmLjnf@vostro.rjw.lan>
 <5212A293.2030903@wwwdotorg.org>
 <3721030.UJAkTdQrEC@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3721030.UJAkTdQrEC@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Jerry as he found out a problem when acpi_i2c is being build as a
module, this should solve it as well.]

On Tue, Aug 20, 2013 at 01:25:27AM +0200, Rafael J. Wysocki wrote:
> On Monday, August 19, 2013 04:56:19 PM Stephen Warren wrote:
> > On 08/19/2013 05:04 PM, Rafael J. Wysocki wrote:
> > > On Monday, August 19, 2013 03:19:18 PM Wolfram Sang wrote:
> > >> I2C of helpers used to live in of_i2c.c but experience (from SPI) shows
> > >> that it is much cleaner to have this in the core. This also removes a
> > >> circular dependency between the helpers and the core, and so we can
> > >> finally register child nodes in the core instead of doing this manually
> > >> in each driver. So, fix the drivers and documentation, too.
> > > 
> > > Perhaps we should do the analogous for ACPI then?

Here is the ACPI version based on the current patch from Wolfram (there is
a compile error because of missing dummy implementation of
of_i2c_register_devices())

From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] i2c: move ACPI helpers into the core

This follows what has already been done for the DeviceTree helpers. Move
the ACPI helpers from drivers/acpi/acpi_i2c.c to the I2C core and update
documentation accordingly.

This also solves a problem reported by Jerry Snitselaar that we can't build
the ACPI I2C helpers as a module.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 Documentation/acpi/enumeration.txt          |  15 +---
 drivers/acpi/Kconfig                        |   6 --
 drivers/acpi/Makefile                       |   1 -
 drivers/acpi/acpi_i2c.c                     | 103 ----------------------------
 drivers/i2c/busses/i2c-designware-platdrv.c |   1 -
 drivers/i2c/i2c-core.c                      |  91 ++++++++++++++++++++++++
 include/linux/i2c.h                         |   6 --
 7 files changed, 94 insertions(+), 129 deletions(-)
 delete mode 100644 drivers/acpi/acpi_i2c.c

diff --git a/Documentation/acpi/enumeration.txt b/Documentation/acpi/enumeration.txt
index 958266e..d977778 100644
--- a/Documentation/acpi/enumeration.txt
+++ b/Documentation/acpi/enumeration.txt
@@ -228,18 +228,9 @@ ACPI handle like:
 I2C serial bus support
 ~~~~~~~~~~~~~~~~~~~~~~
 The slaves behind I2C bus controller only need to add the ACPI IDs like
-with the platform and SPI drivers. However the I2C bus controller driver
-needs to call acpi_i2c_register_devices() after it has added the adapter.
-
-An I2C bus (controller) driver does:
-
-	...
-	ret = i2c_add_numbered_adapter(adapter);
-	if (ret)
-		/* handle error */
-
-	/* Enumerate the slave devices behind this bus via ACPI */
-	acpi_i2c_register_devices(adapter);
+with the platform and SPI drivers. The I2C core automatically enumerates
+any slave devices behind the controller device once the adapter is
+registered.
 
 Below is an example of how to add ACPI support to the existing mpu3050
 input driver:
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 100bd72..4e0162f 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -180,12 +180,6 @@ config ACPI_DOCK
 	  This driver supports ACPI-controlled docking stations and removable
 	  drive bays such as the IBM Ultrabay and the Dell Module Bay.
 
-config ACPI_I2C
-	def_tristate I2C
-	depends on I2C
-	help
-	  ACPI I2C enumeration support.
-
 config ACPI_PROCESSOR
 	tristate "Processor"
 	select THERMAL
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 81dbeb8..cdaf68b 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -73,7 +73,6 @@ obj-$(CONFIG_ACPI_HED)		+= hed.o
 obj-$(CONFIG_ACPI_EC_DEBUGFS)	+= ec_sys.o
 obj-$(CONFIG_ACPI_CUSTOM_METHOD)+= custom_method.o
 obj-$(CONFIG_ACPI_BGRT)		+= bgrt.o
-obj-$(CONFIG_ACPI_I2C)		+= acpi_i2c.o
 
 # processor has its own "processor." module_param namespace
 processor-y			:= processor_driver.o processor_throttling.o
diff --git a/drivers/acpi/acpi_i2c.c b/drivers/acpi/acpi_i2c.c
deleted file mode 100644
index a82c762..0000000
--- a/drivers/acpi/acpi_i2c.c
+++ /dev/null
@@ -1,103 +0,0 @@
-/*
- * ACPI I2C enumeration support
- *
- * Copyright (C) 2012, Intel Corporation
- * Author: Mika Westerberg <mika.westerberg@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/acpi.h>
-#include <linux/device.h>
-#include <linux/export.h>
-#include <linux/i2c.h>
-#include <linux/ioport.h>
-
-ACPI_MODULE_NAME("i2c");
-
-static int acpi_i2c_add_resource(struct acpi_resource *ares, void *data)
-{
-	struct i2c_board_info *info = data;
-
-	if (ares->type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
-		struct acpi_resource_i2c_serialbus *sb;
-
-		sb = &ares->data.i2c_serial_bus;
-		if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_I2C) {
-			info->addr = sb->slave_address;
-			if (sb->access_mode == ACPI_I2C_10BIT_MODE)
-				info->flags |= I2C_CLIENT_TEN;
-		}
-	} else if (info->irq < 0) {
-		struct resource r;
-
-		if (acpi_dev_resource_interrupt(ares, 0, &r))
-			info->irq = r.start;
-	}
-
-	/* Tell the ACPI core to skip this resource */
-	return 1;
-}
-
-static acpi_status acpi_i2c_add_device(acpi_handle handle, u32 level,
-				       void *data, void **return_value)
-{
-	struct i2c_adapter *adapter = data;
-	struct list_head resource_list;
-	struct i2c_board_info info;
-	struct acpi_device *adev;
-	int ret;
-
-	if (acpi_bus_get_device(handle, &adev))
-		return AE_OK;
-	if (acpi_bus_get_status(adev) || !adev->status.present)
-		return AE_OK;
-
-	memset(&info, 0, sizeof(info));
-	info.acpi_node.handle = handle;
-	info.irq = -1;
-
-	INIT_LIST_HEAD(&resource_list);
-	ret = acpi_dev_get_resources(adev, &resource_list,
-				     acpi_i2c_add_resource, &info);
-	acpi_dev_free_resource_list(&resource_list);
-
-	if (ret < 0 || !info.addr)
-		return AE_OK;
-
-	strlcpy(info.type, dev_name(&adev->dev), sizeof(info.type));
-	if (!i2c_new_device(adapter, &info)) {
-		dev_err(&adapter->dev,
-			"failed to add I2C device %s from ACPI\n",
-			dev_name(&adev->dev));
-	}
-
-	return AE_OK;
-}
-
-/**
- * acpi_i2c_register_devices - enumerate I2C slave devices behind adapter
- * @adapter: pointer to adapter
- *
- * Enumerate all I2C slave devices behind this adapter by walking the ACPI
- * namespace. When a device is found it will be added to the Linux device
- * model and bound to the corresponding ACPI handle.
- */
-void acpi_i2c_register_devices(struct i2c_adapter *adapter)
-{
-	acpi_handle handle;
-	acpi_status status;
-
-	handle = ACPI_HANDLE(adapter->dev.parent);
-	if (!handle)
-		return;
-
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
-				     acpi_i2c_add_device, NULL,
-				     adapter, NULL);
-	if (ACPI_FAILURE(status))
-		dev_warn(&adapter->dev, "failed to enumerate I2C slaves\n");
-}
-EXPORT_SYMBOL_GPL(acpi_i2c_register_devices);
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 27ea436..1240fd6 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -171,7 +171,6 @@ static int dw_i2c_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failure adding adapter\n");
 		return r;
 	}
-	acpi_i2c_register_devices(adap);
 
 	pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
 	pm_runtime_use_autosuspend(&pdev->dev);
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 321b7ca..cc80432 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1056,6 +1056,96 @@ struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
 EXPORT_SYMBOL(of_find_i2c_device_by_node);
 #endif /* CONFIG_OF */
 
+/* ACPI support code */
+
+#ifdef CONFIG_ACPI
+static int acpi_i2c_add_resource(struct acpi_resource *ares, void *data)
+{
+	struct i2c_board_info *info = data;
+
+	if (ares->type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
+		struct acpi_resource_i2c_serialbus *sb;
+
+		sb = &ares->data.i2c_serial_bus;
+		if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_I2C) {
+			info->addr = sb->slave_address;
+			if (sb->access_mode == ACPI_I2C_10BIT_MODE)
+				info->flags |= I2C_CLIENT_TEN;
+		}
+	} else if (info->irq < 0) {
+		struct resource r;
+
+		if (acpi_dev_resource_interrupt(ares, 0, &r))
+			info->irq = r.start;
+	}
+
+	/* Tell the ACPI core to skip this resource */
+	return 1;
+}
+
+static acpi_status acpi_i2c_add_device(acpi_handle handle, u32 level,
+				       void *data, void **return_value)
+{
+	struct i2c_adapter *adapter = data;
+	struct list_head resource_list;
+	struct i2c_board_info info;
+	struct acpi_device *adev;
+	int ret;
+
+	if (acpi_bus_get_device(handle, &adev))
+		return AE_OK;
+	if (acpi_bus_get_status(adev) || !adev->status.present)
+		return AE_OK;
+
+	memset(&info, 0, sizeof(info));
+	info.acpi_node.handle = handle;
+	info.irq = -1;
+
+	INIT_LIST_HEAD(&resource_list);
+	ret = acpi_dev_get_resources(adev, &resource_list,
+				     acpi_i2c_add_resource, &info);
+	acpi_dev_free_resource_list(&resource_list);
+
+	if (ret < 0 || !info.addr)
+		return AE_OK;
+
+	strlcpy(info.type, dev_name(&adev->dev), sizeof(info.type));
+	if (!i2c_new_device(adapter, &info)) {
+		dev_err(&adapter->dev,
+			"failed to add I2C device %s from ACPI\n",
+			dev_name(&adev->dev));
+	}
+
+	return AE_OK;
+}
+
+/**
+ * acpi_i2c_register_devices - enumerate I2C slave devices behind adapter
+ * @adapter: pointer to adapter
+ *
+ * Enumerate all I2C slave devices behind this adapter by walking the ACPI
+ * namespace. When a device is found it will be added to the Linux device
+ * model and bound to the corresponding ACPI handle.
+ */
+static void acpi_i2c_register_devices(struct i2c_adapter *adapter)
+{
+	acpi_handle handle;
+	acpi_status status;
+
+	handle = ACPI_HANDLE(adapter->dev.parent);
+	if (!handle)
+		return;
+
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
+				     acpi_i2c_add_device, NULL,
+				     adapter, NULL);
+	if (ACPI_FAILURE(status))
+		dev_warn(&adapter->dev, "failed to enumerate I2C slaves\n");
+}
+#else
+static inline void acpi_i2c_register_devices(struct i2c_adapter *adapter) {}
+#endif /* CONFIG_ACPI */
+
 static int i2c_do_add_adapter(struct i2c_driver *driver,
 			      struct i2c_adapter *adap)
 {
@@ -1161,6 +1251,7 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
 exit_recovery:
 	/* create pre-declared device nodes */
 	of_i2c_register_devices(adap);
+	acpi_i2c_register_devices(adap);
 
 	if (adap->nr < __i2c_first_dynamic_bus_num)
 		i2c_scan_static_board_info(adap);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 2189189..7670d99 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -562,10 +562,4 @@ static inline struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node
 }
 #endif /* CONFIG_OF */
 
-#if IS_ENABLED(CONFIG_ACPI_I2C)
-extern void acpi_i2c_register_devices(struct i2c_adapter *adap);
-#else
-static inline void acpi_i2c_register_devices(struct i2c_adapter *adap) {}
-#endif
-
 #endif /* _LINUX_I2C_H */
-- 
1.8.4.rc2

