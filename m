Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaIKRuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:50:39 -0400
Received: from mail-bl2on0130.outbound.protection.outlook.com ([65.55.169.130]:52062
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751053AbaIKRui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:50:38 -0400
X-Greylist: delayed 949 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2014 13:50:37 EDT
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>,
        <linuxppc-release@linux.freescale.net>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [PATCH 2/4] drivers/bus: Freescale Management Complex (fsl-mc) bus driver
Date: Thu, 11 Sep 2014 12:34:22 -0500
Message-ID: <1410456864-27890-3-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(95666004)(105606002)(229853001)(85852003)(80022001)(87936001)(62966002)(83322001)(19580395003)(81342001)(77156001)(88136002)(84676001)(106466001)(89996001)(83072002)(64706001)(36756003)(107046002)(6806004)(44976005)(68736004)(19580405001)(20776003)(47776003)(99396002)(76176999)(50986999)(97736003)(26826002)(92566001)(85306004)(81542001)(86362001)(2201001)(87286001)(74502001)(92726001)(4396001)(104166001)(93916002)(102836001)(31966008)(48376002)(50466002)(74662001)(76482001)(46102001)(21056001)(90102001)(50226001)(79102001)(104016003)(77982001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB329;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03319F6FEF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=German.Rivera@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. German Rivera" <German.Rivera@freescale.com>

Platform device driver that sets up the basic bus infrastructure
for the fsl-mc bus type, including support for adding/removing
fsl-mc devices, register/unregister of fsl-mc drivers, and bus
match support to bind devices to drivers.

Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
---
Changes in RFC v4:
- Added back the dma_mask field to struct fsl_mc_device as it is needed
  by some MC child device drivers. However, the default DMA mask now
  does not have the 32-bit limitation of the original patch series (v1).

Changes in RFC v3:
- Removed per-bus list of children, and instead use device_for_each_child()
- Use the same structure (struct fsl_mc_device) to represent both
  bus devices and their children.

Changes in RFC v2:
- Removed fsl_mc_bus structure and global variable
- Removed the 'magic' fields from all structs
- Removed NULL initializers
- Replaced all occurrences of EXPORT_SYMBOL() with EXPORT_SYMBOL_GPL()
- Removed function dprc_parse_dt_node(), and replaced its call by a
  direct call to of_address_to_resource()
- Removed struct fsl_mc_device_region and use standard 'struct resource'
  instead.
- Removed dma_mask field from 'struct fsl_mc_device' as it is not currently
  being used.
- Removed redundant 'driver' field from struct fsl_mc_device
- Removed the container field. We can get the parent DPRC of a given dev,
  from its dev.parent field.

 drivers/bus/Kconfig             |    3 +
 drivers/bus/Makefile            |    3 +
 drivers/bus/fsl-mc/Kconfig      |   13 +
 drivers/bus/fsl-mc/Makefile     |   14 +
 drivers/bus/fsl-mc/fsl_mc_bus.c |  602 +++++++++++++++++++++++++++++++++++++++
 include/linux/fsl_mc.h          |  137 +++++++++
 include/linux/fsl_mc_private.h  |   33 +++
 7 files changed, 805 insertions(+)
 create mode 100644 drivers/bus/fsl-mc/Kconfig
 create mode 100644 drivers/bus/fsl-mc/Makefile
 create mode 100644 drivers/bus/fsl-mc/fsl_mc_bus.c
 create mode 100644 include/linux/fsl_mc.h
 create mode 100644 include/linux/fsl_mc_private.h

diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 603eb1b..2fbb1fd 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -67,4 +67,7 @@ config VEXPRESS_CONFIG
 	help
 	  Platform configuration infrastructure for the ARM Ltd.
 	  Versatile Express.
+
+source "drivers/bus/fsl-mc/Kconfig"
+
 endmenu
diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index 2973c18..6abcab1 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -15,3 +15,6 @@ obj-$(CONFIG_ARM_CCI)		+= arm-cci.o
 obj-$(CONFIG_ARM_CCN)		+= arm-ccn.o

 obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o
+
+# Freescale Management Complex (MC) bus drivers
+obj-$(CONFIG_FSL_MC_BUS)	+= fsl-mc/
diff --git a/drivers/bus/fsl-mc/Kconfig b/drivers/bus/fsl-mc/Kconfig
new file mode 100644
index 0000000..e3226f9
--- /dev/null
+++ b/drivers/bus/fsl-mc/Kconfig
@@ -0,0 +1,13 @@
+#
+# Freescale Management Complex (MC) bus drivers
+#
+# Copyright (C) 2014 Freescale Semiconductor, Inc.
+#
+# This file is released under the GPLv2
+#
+
+config FSL_MC_BUS
+	tristate "Freescale Management Complex (MC) bus driver"
+	help
+	  Driver to enable the bus infrastructure for the Freescale
+          QorIQ Management Complex.
diff --git a/drivers/bus/fsl-mc/Makefile b/drivers/bus/fsl-mc/Makefile
new file mode 100644
index 0000000..2981d70
--- /dev/null
+++ b/drivers/bus/fsl-mc/Makefile
@@ -0,0 +1,14 @@
+#
+# Freescale Management Complex (MC) bus drivers
+#
+# Copyright (C) 2014 Freescale Semiconductor, Inc.
+#
+# This file is released under the GPLv2
+#
+obj-$(CONFIG_FSL_MC_BUS) += fsl_mc_bus_driver.o
+
+fsl_mc_bus_driver-objs := fsl_mc_bus.o \
+			      fsl_mc_sys.o \
+			      dprc.o \
+			      dpmng.o
+
diff --git a/drivers/bus/fsl-mc/fsl_mc_bus.c b/drivers/bus/fsl-mc/fsl_mc_bus.c
new file mode 100644
index 0000000..3f59c31
--- /dev/null
+++ b/drivers/bus/fsl-mc/fsl_mc_bus.c
@@ -0,0 +1,602 @@
+/*
+ * Freescale Management Complex (MC) bus driver
+ *
+ * Copyright (C) 2014 Freescale Semiconductor, Inc.
+ * Author: German Rivera <German.Rivera@freescale.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/fsl_mc_private.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
+#include <linux/ioport.h>
+#include <linux/slab.h>
+#include <linux/limits.h>
+#include <linux/fsl_dpmng.h>
+#include <linux/fsl_mc_sys.h>
+#include "fsl_dprc_cmd.h"
+
+static struct kmem_cache *mc_dev_cache;
+
+/**
+ * fsl_mc_bus_match - device to driver matching callback
+ * @dev: the MC object device structure to match against
+ * @drv: the device driver to search for matching MC object device id
+ * structures
+ *
+ * Returns 1 on success, 0 otherwise.
+ */
+static int fsl_mc_bus_match(struct device *dev, struct device_driver *drv)
+{
+	const struct fsl_mc_device_match_id *id;
+	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+	struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(drv);
+	bool found = false;
+
+	if (mc_drv->match_id_table == NULL)
+		goto out;
+
+	/*
+	 * If the object is not 'plugged' don't match.
+	 * Only exception is the root DPRC, which is a special case.
+	 */
+	if ((mc_dev->obj_desc.state & DPRC_OBJ_STATE_PLUGGED) == 0 &&
+	    &mc_dev->dev != fsl_mc_bus_type.dev_root)
+		goto out;
+
+	/*
+	 * Traverse the match_id table of the given driver, trying to find
+	 * a matching for the given MC object device.
+	 */
+	for (id = mc_drv->match_id_table; id->vendor != 0x0; id++) {
+		if (id->vendor == mc_dev->obj_desc.vendor &&
+		    strcmp(id->obj_type, mc_dev->obj_desc.type) == 0 &&
+		    id->ver_major == mc_dev->obj_desc.ver_major &&
+		    id->ver_minor == mc_dev->obj_desc.ver_minor) {
+			found = true;
+			break;
+		}
+	}
+
+out:
+	pr_debug("%s: %s %s\n", __func__, dev_name(dev),
+		 found ? "matched" : "not matched");
+
+	return found;
+}
+
+/**
+ * fsl_mc_bus_uevent - callback invoked when a device is added
+ */
+static int fsl_mc_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	pr_debug("%s invoked\n", __func__);
+	return 0;
+}
+
+struct bus_type fsl_mc_bus_type = {
+	.name = "fsl-mc",
+	.match = fsl_mc_bus_match,
+	.uevent = fsl_mc_bus_uevent,
+};
+EXPORT_SYMBOL_GPL(fsl_mc_bus_type);
+
+static int fsl_mc_driver_probe(struct device *dev)
+{
+	struct fsl_mc_driver *mc_drv;
+	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+	int error = -EINVAL;
+
+	if (WARN_ON(dev->driver == NULL))
+		goto error;
+
+	mc_drv = to_fsl_mc_driver(dev->driver);
+	if (WARN_ON(mc_drv->probe == NULL))
+		goto error;
+
+	error = mc_drv->probe(mc_dev);
+	if (error < 0) {
+		dev_err(dev, "MC object device probe callback failed: %d\n",
+			error);
+		goto error;
+	}
+
+	return 0;
+error:
+	return error;
+}
+
+static int fsl_mc_driver_remove(struct device *dev)
+{
+	struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
+	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+	int error = -EINVAL;
+
+	if (WARN_ON(dev->driver == NULL))
+		goto error;
+
+	error = mc_drv->remove(mc_dev);
+	if (error < 0) {
+		dev_err(dev,
+			"MC object device remove callback failed: %d\n",
+			error);
+		goto error;
+	}
+
+	return 0;
+error:
+	return error;
+}
+
+static void fsl_mc_driver_shutdown(struct device *dev)
+{
+	struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
+	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+
+	mc_drv->shutdown(mc_dev);
+}
+
+/**
+ * __fsl_mc_driver_register - registers a child device driver with the
+ * MC bus
+ *
+ * This function is implicitly invoked from the registration function of
+ * fsl_mc device drivers, which is generated by the
+ * module_fsl_mc_driver() macro.
+ */
+int __fsl_mc_driver_register(struct fsl_mc_driver *mc_driver,
+			     struct module *owner)
+{
+	int error = -EINVAL;
+
+	mc_driver->driver.owner = owner;
+	mc_driver->driver.bus = &fsl_mc_bus_type;
+
+	/*
+	 * Set default driver callbacks, if not set by the child driver:
+	 */
+	if (mc_driver->probe != NULL)
+		mc_driver->driver.probe = fsl_mc_driver_probe;
+
+	if (mc_driver->remove != NULL)
+		mc_driver->driver.remove = fsl_mc_driver_remove;
+
+	if (mc_driver->shutdown != NULL)
+		mc_driver->driver.shutdown = fsl_mc_driver_shutdown;
+
+	error = driver_register(&mc_driver->driver);
+	if (error < 0) {
+		pr_err("driver_register() failed for %s: %d\n",
+		       mc_driver->driver.name, error);
+		goto error;
+	}
+
+	pr_info("MC object device driver %s registered\n",
+		mc_driver->driver.name);
+	return 0;
+error:
+	return error;
+}
+EXPORT_SYMBOL_GPL(__fsl_mc_driver_register);
+
+/**
+ * fsl_mc_driver_unregister - unregisters a device driver from the
+ * MC bus
+ */
+void fsl_mc_driver_unregister(struct fsl_mc_driver *mc_driver)
+{
+	driver_unregister(&mc_driver->driver);
+}
+EXPORT_SYMBOL_GPL(fsl_mc_driver_unregister);
+
+static int get_dprc_icid(struct fsl_mc_io *mc_io,
+			 int container_id, uint16_t *icid)
+{
+	uint16_t dprc_handle;
+	struct dprc_attributes attr;
+	bool dprc_opened = false;
+	int error = -EINVAL;
+
+	error = dprc_open(mc_io, container_id, &dprc_handle);
+	if (error < 0) {
+		pr_err("dprc_open() failed: %d\n", error);
+		goto out;
+	}
+
+	dprc_opened = true;
+	memset(&attr, 0, sizeof(attr));
+	error = dprc_get_attributes(mc_io, dprc_handle, &attr);
+	if (error < 0) {
+		pr_err("dprc_get_attributes() failed: %d\n", error);
+		goto out;
+	}
+
+	*icid = attr.icid;
+	error = 0;
+out:
+	if (dprc_opened)
+		(void)dprc_close(mc_io, dprc_handle);
+
+	return error;
+}
+
+static int fsl_mc_device_get_mmio_regions(struct fsl_mc_device *mc_dev,
+					  struct fsl_mc_device *mc_bus_dev)
+{
+	int i;
+	int error;
+	struct resource *regions;
+	struct dprc_obj_desc *obj_desc = &mc_dev->obj_desc;
+	struct device *parent_dev = mc_dev->dev.parent;
+
+	regions = kmalloc_array(obj_desc->region_count,
+				sizeof(regions[0]), GFP_KERNEL);
+	if (regions == NULL) {
+		error = -ENOMEM;
+		dev_err(parent_dev, "No memory to allocate regions[]\n");
+		goto error;
+	}
+
+	for (i = 0; i < obj_desc->region_count; i++) {
+		struct dprc_region_desc region_desc;
+
+		error = dprc_get_obj_region(mc_bus_dev->mc_io,
+					    mc_bus_dev->mc_handle,
+					    obj_desc->type,
+					    obj_desc->id, i, &region_desc);
+		if (error < 0) {
+			dev_err(parent_dev,
+				"dprc_get_obj_region() failed: %d\n", error);
+			goto error;
+		}
+
+		WARN_ON(region_desc.base_paddr == 0x0);
+		WARN_ON(region_desc.size == 0);
+		regions[i].start = region_desc.base_paddr;
+		regions[i].end = region_desc.base_paddr + region_desc.size - 1;
+		regions[i].name = "fsl-mc object MMIO region";
+		regions[i].flags = IORESOURCE_IO;
+	}
+
+	mc_dev->regions = regions;
+	return 0;
+error:
+	kfree(regions);
+	return error;
+}
+
+/**
+ * Add a newly discovered MC object device to be visible in Linux
+ */
+int fsl_mc_device_add(struct dprc_obj_desc *obj_desc,
+		      struct fsl_mc_io *mc_io,
+		      struct device *parent_dev,
+		      struct fsl_mc_device **new_mc_dev)
+{
+	int error = -EINVAL;
+	struct fsl_mc_device *mc_dev = NULL;
+	bool device_added = false;
+	struct fsl_mc_device *parent_mc_dev;
+
+	if (parent_dev->bus == &fsl_mc_bus_type)
+		parent_mc_dev = to_fsl_mc_device(parent_dev);
+	else
+		parent_mc_dev = NULL;
+
+	/*
+	 * DPRC devices must have a dedicated MC portal
+	 */
+	if (WARN_ON(strcmp(obj_desc->type, "dprc") == 0 && mc_io == NULL))
+		goto error;
+
+	mc_dev = kmem_cache_zalloc(mc_dev_cache, GFP_KERNEL);
+	if (mc_dev == NULL) {
+		error = -ENOMEM;
+		dev_err(parent_dev,
+			"No memory to allocate fsl_mc_device\n");
+		goto error;
+	}
+
+	mc_dev->obj_desc = *obj_desc;
+	mc_dev->mc_io = mc_io;
+	device_initialize(&mc_dev->dev);
+	mc_dev->dev.parent = parent_dev;
+	mc_dev->dev.bus = &fsl_mc_bus_type;
+	dev_set_name(&mc_dev->dev, "%s.%x", obj_desc->type, obj_desc->id);
+
+	if (strcmp(obj_desc->type, "dprc") == 0) {
+		struct fsl_mc_io *mc_io2;
+
+		mc_dev->flags |= FSL_MC_IS_DPRC;
+
+		/*
+		 * To get the DPRC's ICID, we need to open the DPRC
+		 * in get_dprc_icid(). For child DPRCs, we do so using the
+		 * parent DPRC's MC portal instead of the child DPRC's MC
+		 * portal, in case the child DPRC is already opened with
+		 * its own portal (e.g., the DPRC used by AIOP).
+		 *
+		 * NOTE: There cannot be more than one active open for a
+		 * given MC object, using the same MC portal.
+		 */
+		if (parent_mc_dev != NULL) {
+			/*
+			 * device being added is a child DPRC device
+			 */
+			mc_io2 = parent_mc_dev->mc_io;
+		} else {
+			/*
+			 * device being added is the root DPRC device
+			 */
+			mc_io2 = mc_io;
+		}
+
+		error = get_dprc_icid(mc_io2, obj_desc->id, &mc_dev->icid);
+		if (error < 0)
+			goto error;
+	} else {
+		/*
+		 * A non-DPRC MC object device has to be a child of another
+		 * MC object (specifically a DPRC object)
+		 */
+		mc_dev->icid = parent_mc_dev->icid;
+		mc_dev->dma_mask = FSL_MC_DEFAULT_DMA_MASK;
+		mc_dev->dev.dma_mask = &mc_dev->dma_mask;
+		if (obj_desc->region_count != 0) {
+			error = fsl_mc_device_get_mmio_regions(mc_dev,
+							       parent_mc_dev);
+			if (error < 0)
+				goto error;
+		}
+	}
+
+	/*
+	 * The device-specific probe callback will get invoked by device_add()
+	 */
+	error = device_add(&mc_dev->dev);
+	if (error < 0) {
+		dev_err(parent_dev,
+			"device_add() failed for device %s: %d\n",
+			dev_name(&mc_dev->dev), error);
+		goto error;
+	}
+
+	get_device(&mc_dev->dev);
+	device_added = true;
+	dev_dbg(parent_dev, "Added MC object device %s\n",
+		dev_name(&mc_dev->dev));
+
+	*new_mc_dev = mc_dev;
+	return 0;
+error:
+	if (device_added) {
+		device_del(&mc_dev->dev);
+		put_device(&mc_dev->dev);
+	}
+
+	if (mc_dev != NULL) {
+		if (mc_dev->regions != NULL)
+			kfree(mc_dev->regions);
+
+		kmem_cache_free(mc_dev_cache, mc_dev);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(fsl_mc_device_add);
+
+/**
+ * fsl_mc_device_remove - Remove a MC object device from being visible to
+ * Linux
+ *
+ * @mc_dev: Pointer to a MC object device object
+ */
+void fsl_mc_device_remove(struct fsl_mc_device *mc_dev)
+{
+	struct fsl_mc_device *parent_mc_dev;
+
+	if (mc_dev->dev.parent->bus == &fsl_mc_bus_type)
+		parent_mc_dev = to_fsl_mc_device(mc_dev->dev.parent);
+	else
+		parent_mc_dev = NULL;
+
+	if (mc_dev->regions != NULL)
+		kfree(mc_dev->regions);
+
+	/*
+	 * The device-specific remove callback will get invoked by device_del()
+	 */
+	device_del(&mc_dev->dev);
+	put_device(&mc_dev->dev);
+
+	if (strcmp(mc_dev->obj_desc.type, "dprc") == 0)
+		fsl_destroy_mc_io(mc_dev->mc_io);
+
+	mc_dev->mc_io = NULL;
+	kmem_cache_free(mc_dev_cache, mc_dev);
+}
+EXPORT_SYMBOL_GPL(fsl_mc_device_remove);
+
+/**
+ * fsl_mc_bus_probe - callback invoked when the root MC bus is being
+ * added
+ */
+static int fsl_mc_bus_probe(struct platform_device *pdev)
+{
+	struct dprc_obj_desc obj_desc;
+	int error = -EINVAL;
+	struct fsl_mc_device *mc_bus_dev = NULL;
+	struct fsl_mc_io *mc_io = NULL;
+	int container_id;
+	phys_addr_t mc_portal_phys_addr;
+	uint32_t mc_portal_size;
+	struct mc_version mc_version;
+	struct resource res;
+
+	dev_info(&pdev->dev, "Root MC bus device probed");
+	error = of_address_to_resource(pdev->dev.of_node, 0, &res);
+	if (error < 0) {
+		dev_err(&pdev->dev,
+			"of_address_to_resource() failed for %s\n",
+			pdev->dev.of_node->full_name);
+		goto error;
+	}
+
+	mc_portal_phys_addr = res.start;
+	mc_portal_size = resource_size(&res);
+	error = fsl_create_mc_io(mc_portal_phys_addr,
+				 mc_portal_size, 0, &mc_io);
+	if (error < 0)
+		goto error;
+
+	error = mc_get_version(mc_io, &mc_version);
+	if (error != 0) {
+		dev_err(&pdev->dev,
+			"mc_get_version() failed with error %d\n", error);
+		goto error;
+	}
+
+	dev_info(&pdev->dev,
+		 "Freescale Management Complex Firmware version: %u.%u.%u\n",
+		 mc_version.major, mc_version.minor, mc_version.revision);
+
+	if (mc_version.major != MC_VER_MAJOR) {
+		dev_err(&pdev->dev,
+			"ERROR: Firmware major version mismatch (found: %d, expected: %d)\n",
+			mc_version.major, MC_VER_MAJOR);
+	}
+
+	if (mc_version.minor != MC_VER_MINOR) {
+		dev_err(&pdev->dev,
+			"WARNING: Firmware minor version mismatch (found: %d, expected: %d)\n",
+			mc_version.minor, MC_VER_MINOR);
+	}
+
+	error = dprc_get_container_id(mc_io, &container_id);
+	if (error < 0) {
+		dev_err(&pdev->dev,
+			"dprc_get_container_id() failed: %d\n", error);
+		goto error;
+	}
+
+	obj_desc.vendor = FSL_MC_VENDOR_FREESCALE;
+	strcpy(obj_desc.type, "dprc");
+	obj_desc.id = container_id;
+	obj_desc.ver_major = DPRC_VER_MAJOR;
+	obj_desc.ver_minor = DPRC_VER_MINOR;
+	obj_desc.region_count = 0;
+
+	error = fsl_mc_device_add(&obj_desc, mc_io, &pdev->dev, &mc_bus_dev);
+	if (error < 0)
+		goto error;
+
+	platform_set_drvdata(pdev, mc_bus_dev);
+	fsl_mc_bus_type.dev_root = &mc_bus_dev->dev;
+	return 0;
+error:
+	if (mc_io != NULL)
+		fsl_destroy_mc_io(mc_io);
+
+	return error;
+}
+
+/**
+ * fsl_mc_bus_remove - callback invoked when the root MC bus is being
+ * removed
+ */
+static int fsl_mc_bus_remove(struct platform_device *pdev)
+{
+	int error = -EINVAL;
+	struct fsl_mc_device *mc_bus_dev = platform_get_drvdata(pdev);
+
+	if (WARN_ON(&mc_bus_dev->dev != fsl_mc_bus_type.dev_root))
+		goto error;
+
+	fsl_mc_device_remove(mc_bus_dev);
+	fsl_mc_bus_type.dev_root = NULL;
+	dev_info(&pdev->dev, "Root MC bus device removed");
+	return 0;
+error:
+	return error;
+}
+
+static const struct of_device_id fsl_mc_bus_match_table[] = {
+	{.compatible = "fsl,qoriq-mc",},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, fsl_mc_bus_match_table);
+
+static struct platform_driver fsl_mc_bus_driver = {
+	.driver = {
+		   .name = "fsl_mc_bus",
+		   .owner = THIS_MODULE,
+		   .pm = NULL,
+		   .of_match_table = fsl_mc_bus_match_table,
+		   },
+	.probe = fsl_mc_bus_probe,
+	.remove = fsl_mc_bus_remove,
+};
+
+static int __init fsl_mc_bus_driver_init(void)
+{
+	int error = -EINVAL;
+	bool bus_registered = false;
+
+	mc_dev_cache = kmem_cache_create("fsl_mc_device",
+					 sizeof(struct fsl_mc_device), 0, 0,
+					 NULL);
+	if (mc_dev_cache == NULL) {
+		error = -ENOMEM;
+		pr_err("Could not create fsl_mc_device cache\n");
+		goto error;
+	}
+
+	error = bus_register(&fsl_mc_bus_type);
+	if (error < 0) {
+		pr_err("fsl-mc bus type registration failed: %d\n", error);
+		goto error;
+	}
+
+	bus_registered = true;
+	pr_info("fsl-mc bus type registered\n");
+
+	error = platform_driver_register(&fsl_mc_bus_driver);
+	if (error < 0) {
+		pr_err("platform_driver_register() failed: %d\n", error);
+		goto error;
+	}
+
+	return 0;
+error:
+	if (bus_registered)
+		bus_unregister(&fsl_mc_bus_type);
+
+	if (mc_dev_cache != NULL)
+		kmem_cache_destroy(mc_dev_cache);
+
+	return error;
+}
+
+postcore_initcall(fsl_mc_bus_driver_init);
+
+static void __exit fsl_mc_bus_driver_exit(void)
+{
+	if (WARN_ON(mc_dev_cache == NULL))
+		return;
+
+	platform_driver_unregister(&fsl_mc_bus_driver);
+	bus_unregister(&fsl_mc_bus_type);
+	kmem_cache_destroy(mc_dev_cache);
+	pr_info("MC bus unregistered\n");
+}
+
+module_exit(fsl_mc_bus_driver_exit);
+
+MODULE_AUTHOR("Freescale Semiconductor Inc.");
+MODULE_DESCRIPTION("Freescale Management Complex (MC) bus driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/fsl_mc.h b/include/linux/fsl_mc.h
new file mode 100644
index 0000000..b291eba
--- /dev/null
+++ b/include/linux/fsl_mc.h
@@ -0,0 +1,137 @@
+/*
+ * Freescale Management Complex (MC) bus public interface
+ *
+ * Copyright (C) 2014 Freescale Semiconductor, Inc.
+ * Author: German Rivera <German.Rivera@freescale.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#ifndef _FSL_MC_H_
+#define _FSL_MC_H_
+
+#include <linux/device.h>
+#include <linux/mod_devicetable.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/fsl_dprc.h>
+
+#define FSL_MC_VENDOR_FREESCALE	0x1957
+
+struct fsl_mc_device;
+struct fsl_mc_io;
+
+/**
+ * struct fsl_mc_driver - MC object device driver object
+ * @driver: Generic device driver
+ * @match_id_table: table of supported device matching Ids
+ * @probe: Function called when a device is added
+ * @remove: Function called when a device is removed
+ * @shutdown: Function called at shutdown time to quiesce the device
+ * @suspend: Function called when a device is stopped
+ * @resume: Function called when a device is resumed
+ *
+ * Generic DPAA device driver object for device drivers that are registered
+ * with a DPRC bus. This structure is to be embedded in each device-specific
+ * driver structure.
+ */
+struct fsl_mc_driver {
+	struct device_driver driver;
+	const struct fsl_mc_device_match_id *match_id_table;
+	int (*probe)(struct fsl_mc_device *dev);
+	int (*remove)(struct fsl_mc_device *dev);
+	void (*shutdown)(struct fsl_mc_device *dev);
+	int (*suspend)(struct fsl_mc_device *dev, pm_message_t state);
+	int (*resume)(struct fsl_mc_device *dev);
+};
+
+#define to_fsl_mc_driver(_drv) \
+	container_of(_drv, struct fsl_mc_driver, driver)
+
+/**
+ * struct fsl_mc_device_match_id - MC object device Id entry for driver matching
+ * @vendor: vendor ID
+ * @obj_type: MC object type
+ * @ver_major: MC object version major number
+ * @ver_minor: MC object version minor number
+ *
+ * Type of entries in the "device Id" table for MC object devices supported by
+ * a MC object device driver. The last entry of the table has vendor set to 0x0
+ */
+struct fsl_mc_device_match_id {
+	uint16_t vendor;
+	const char obj_type[16];
+	uint32_t ver_major;
+	uint32_t ver_minor;
+};
+
+/**
+ * Bit masks for a MC object device (struct fsl_mc_device) flags
+ */
+#define FSL_MC_IS_DPRC	0x0001
+
+/**
+ * Default DMA mask for devices on a fsl-mc bus
+ */
+#define FSL_MC_DEFAULT_DMA_MASK	(~0ULL)
+
+/**
+ * struct fsl_mc_device - MC object device object
+ * @dev: Linux driver model device object
+ * @dma_mask: Default DMA mask
+ * @flags: MC object device flags
+ * @icid: Isolation context ID for the device
+ * @mc_handle: MC handle for the corresponding MC object opened
+ * @mc_io: Pointer to MC IO object assigned to this device or
+ * NULL if none.
+ * @obj_desc: MC description of the DPAA device
+ * @regions: pointer to array of MMIO region entries
+ *
+ * Generic device object for MC object devices that are "attached" to a
+ * MC bus.
+ *
+ * NOTES:
+ * - For a non-DPRC object its icid is the same as its parent DPRC's icid.
+ * - The SMMU notifier callback gets invoked after device_add() has been
+ *   called for an MC object device, but before the device-specific probe
+ *   callback gets called.
+ */
+struct fsl_mc_device {
+	struct device dev;
+	uint64_t dma_mask;
+	uint16_t flags;
+	uint16_t icid;
+	uint16_t mc_handle;
+	struct fsl_mc_io *mc_io;
+	struct dprc_obj_desc obj_desc;
+	struct resource *regions;
+};
+
+#define to_fsl_mc_device(_dev) \
+	container_of(_dev, struct fsl_mc_device, dev)
+
+/*
+ * module_fsl_mc_driver() - Helper macro for drivers that don't do
+ * anything special in module init/exit.  This eliminates a lot of
+ * boilerplate.  Each module may only use this macro once, and
+ * calling it replaces module_init() and module_exit()
+ */
+#define module_fsl_mc_driver(__fsl_mc_driver) \
+	module_driver(__fsl_mc_driver, fsl_mc_driver_register, \
+		      fsl_mc_driver_unregister)
+
+/*
+ * Macro to avoid include chaining to get THIS_MODULE
+ */
+#define fsl_mc_driver_register(drv) \
+	__fsl_mc_driver_register(drv, THIS_MODULE)
+
+int __must_check __fsl_mc_driver_register(struct fsl_mc_driver *fsl_mc_driver,
+					  struct module *owner);
+
+void fsl_mc_driver_unregister(struct fsl_mc_driver *driver);
+
+extern struct bus_type fsl_mc_bus_type;
+
+#endif /* _FSL_MC_H_ */
diff --git a/include/linux/fsl_mc_private.h b/include/linux/fsl_mc_private.h
new file mode 100644
index 0000000..3ff3f2b
--- /dev/null
+++ b/include/linux/fsl_mc_private.h
@@ -0,0 +1,33 @@
+/*
+ * Freescale Management Complex (MC) bus private declarations
+ *
+ * Copyright (C) 2014 Freescale Semiconductor, Inc.
+ * Author: German Rivera <German.Rivera@freescale.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#ifndef _FSL_MC_PRIVATE_H_
+#define _FSL_MC_PRIVATE_H_
+
+#include <linux/fsl_mc.h>
+#include <linux/mutex.h>
+#include <linux/stringify.h>
+
+#define FSL_MC_DEVICE_MATCH(_mc_dev, _obj_desc) \
+	(strcmp((_mc_dev)->obj_desc.type, (_obj_desc)->type) == 0 && \
+	 (_mc_dev)->obj_desc.id == (_obj_desc)->id)
+
+#define FSL_MC_IS_ALLOCATABLE(_obj_type) \
+	(strcmp(_obj_type, "dpbp") == 0 || \
+	 strcmp(_obj_type, "dpcon") == 0)
+
+int __must_check fsl_mc_device_add(struct dprc_obj_desc *obj_desc,
+				   struct fsl_mc_io *mc_io,
+				   struct device *parent_dev,
+				   struct fsl_mc_device **new_mc_dev);
+
+void fsl_mc_device_remove(struct fsl_mc_device *mc_dev);
+
+#endif /* _FSL_MC_PRIVATE_H_ */
--
1.7.9.7

