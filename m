Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaHOWOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 18:14:06 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:58011
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751762AbaHOWNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 18:13:33 -0400
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <linuxppc-release@linux.freescale.net>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [RFC PATCH 2/4] drivers/bus: Freescale Management Complex (fsl-mc) bus driver
Date: Fri, 15 Aug 2014 17:13:12 -0500
Message-ID: <1408140794-25064-3-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1408140794-25064-1-git-send-email-German.Rivera@freescale.com>
References: <1408140794-25064-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(107046002)(21056001)(229853001)(102836001)(69596002)(19580405001)(83322001)(6806004)(44976005)(19580395003)(46102001)(26826002)(31966008)(74662001)(74502001)(68736004)(99396002)(87286001)(77156001)(50466002)(48376002)(62966002)(36756003)(97736001)(104166001)(84676001)(76176999)(50986999)(76482001)(575784001)(93916002)(64706001)(47776003)(81342001)(86362001)(2201001)(105606002)(104016003)(79102001)(87936001)(88136002)(89996001)(106466001)(95666004)(92726001)(77982001)(92566001)(81542001)(50226001)(85306004)(85852003)(83072002)(20776003)(80022001)(81156004)(4396001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB331;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0304E36CA3
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
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
---
 drivers/bus/Kconfig             |    3 +
 drivers/bus/Makefile            |    3 +
 drivers/bus/fsl-mc/Kconfig      |   13 +
 drivers/bus/fsl-mc/Makefile     |   14 +
 drivers/bus/fsl-mc/fsl_mc_bus.c |  734 +++++++++++++++++++++++++++++++++++++++
 include/linux/fsl_mc.h          |  177 ++++++++++
 include/linux/fsl_mc_private.h  |   85 +++++
 7 files changed, 1029 insertions(+)
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
index 0000000..f5f9033
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
+			      mc_sys.o \
+			      dprc.o \
+			      dpmng.o
+
diff --git a/drivers/bus/fsl-mc/fsl_mc_bus.c b/drivers/bus/fsl-mc/fsl_mc_bus.c
new file mode 100644
index 0000000..98f7add
--- /dev/null
+++ b/drivers/bus/fsl-mc/fsl_mc_bus.c
@@ -0,0 +1,734 @@
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
+#include <linux/slab.h>
+#include <linux/limits.h>
+#include <linux/fsl_dpmng.h>
+#include <linux/fsl_mc_sys.h>
+#include "fsl_dprc_cmd.h"
+
+struct fsl_mc_bus *fsl_mc_bus;
+EXPORT_SYMBOL(fsl_mc_bus);
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
+	if (WARN_ON(mc_dev->magic != FSL_MC_DEVICE_MAGIC))
+		goto out;
+	if (WARN_ON(mc_drv->magic != FSL_MC_DRIVER_MAGIC))
+		goto out;
+
+	if (mc_drv->match_id_table == NULL)
+		goto out;
+
+	/*
+	 * If the object is not 'plugged' don't match.
+	 * Only exception is the root DPRC, which is a special case.
+	 */
+	if ((mc_dev->obj_desc.state & DPRC_OBJ_STATE_PLUGGED) == 0 &&
+	    mc_dev->container != NULL)
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
+	.drv_groups = NULL,
+	.dev_groups = NULL,
+	.bus_groups = NULL,
+	.pm = NULL,
+};
+EXPORT_SYMBOL(fsl_mc_bus_type);
+
+static int dprc_parse_dt_node(struct platform_device *pdev,
+			      phys_addr_t *mc_portal_phys_addr,
+			      uint32_t *mc_portal_size)
+{
+	struct resource res;
+	struct device_node *pdev_of_node = pdev->dev.of_node;
+	int error = -EINVAL;
+
+	error = of_address_to_resource(pdev_of_node, 0, &res);
+	if (error < 0) {
+		FSL_MC_ERROR(&pdev->dev,
+			     "of_address_to_resource() failed for %s\n",
+			     pdev_of_node->full_name);
+		goto out;
+	}
+
+	*mc_portal_phys_addr = res.start;
+	*mc_portal_size = resource_size(&res);
+	error = 0;
+out:
+	return error;
+}
+
+static int fsl_mc_driver_probe(struct device *dev)
+{
+	struct fsl_mc_driver *mc_drv;
+	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+	int error = -EINVAL;
+
+	if (WARN_ON(mc_dev->magic != FSL_MC_DEVICE_MAGIC))
+		goto error;
+	if (WARN_ON(mc_dev->driver != NULL))
+		goto error;
+	if (WARN_ON(dev->driver == NULL))
+		goto error;
+
+	mc_drv = to_fsl_mc_driver(dev->driver);
+	if (WARN_ON(mc_drv->magic != FSL_MC_DRIVER_MAGIC))
+		goto error;
+	if (WARN_ON(mc_drv->probe == NULL))
+		goto error;
+
+	mc_dev->driver = mc_drv;
+	error = mc_drv->probe(mc_dev);
+	if (error < 0) {
+		FSL_MC_ERROR(dev,
+			     "MC object device probe callback failed: %d\n",
+			     error);
+		mc_dev->driver = NULL;
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
+	if (WARN_ON(mc_drv->magic != FSL_MC_DRIVER_MAGIC))
+		goto error;
+	if (WARN_ON(mc_dev->magic != FSL_MC_DEVICE_MAGIC))
+		goto error;
+	if (WARN_ON(mc_dev->driver == NULL))
+		goto error;
+	if (WARN_ON(mc_dev->driver != mc_drv))
+		goto error;
+
+	error = mc_drv->remove(mc_dev);
+	if (error < 0) {
+		FSL_MC_ERROR(dev,
+			     "MC object device remove callback failed: %d\n",
+			     error);
+		goto error;
+	}
+
+	mc_dev->driver = NULL;
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
+	struct fsl_mc_device *root_mc_dev;
+	int error = -EINVAL;
+
+	mc_driver->magic = FSL_MC_DRIVER_MAGIC;
+	mc_driver->driver.owner = owner;
+	mc_driver->driver.bus = &fsl_mc_bus_type;
+
+	if (fsl_mc_bus == NULL) {
+		error = -ENXIO;
+		FSL_MC_ERROR(NULL, "fsl-mc bus does not exist\n");
+		goto error;
+	}
+
+	if (WARN_ON(fsl_mc_bus->magic != FSL_MC_BUS_MAGIC))
+		goto error;
+
+	root_mc_dev = fsl_mc_bus->root_mc_dev;
+	if (root_mc_dev == NULL) {
+		error = -ENXIO;
+		FSL_MC_ERROR(NULL, "fsl-mc root DPRC device does not exist\n");
+		goto error;
+	}
+
+	if (WARN_ON(root_mc_dev->magic != FSL_MC_DEVICE_MAGIC))
+		goto error;
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
+		FSL_MC_ERROR(&root_mc_dev->dev,
+			     "driver_register() failed for %s: %d\n",
+			     mc_driver->driver.name, error);
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
+	if (WARN_ON(mc_driver->magic != FSL_MC_DRIVER_MAGIC))
+		return;
+
+	driver_unregister(&mc_driver->driver);
+	mc_driver->magic = 0x0;
+}
+EXPORT_SYMBOL_GPL(fsl_mc_driver_unregister);
+
+static int get_dprc_icid(struct fsl_mc_io *mc_io,
+			 int container_id, uint16_t *icid)
+{
+	struct device *dev = &fsl_mc_bus->pdev->dev;
+	uint16_t dprc_handle;
+	struct dprc_attributes attr;
+	bool dprc_opened = false;
+	int error = -EINVAL;
+
+	error = dprc_open(mc_io, container_id, &dprc_handle);
+	if (error < 0) {
+		FSL_MC_ERROR(dev, "dprc_open() failed: %d\n", error);
+		goto out;
+	}
+
+	dprc_opened = true;
+	memset(&attr, 0, sizeof(attr));
+	error = dprc_get_attributes(mc_io, dprc_handle, &attr);
+	if (error < 0) {
+		FSL_MC_ERROR(dev, "dprc_get_attributes() failed: %d\n", error);
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
+					  struct fsl_mc_device *container_dev)
+{
+	int i;
+	int error;
+	struct fsl_mc_device_region *regions;
+	struct dprc_obj_desc *obj_desc = &mc_dev->obj_desc;
+	struct device *parent_dev = mc_dev->dev.parent;
+
+	regions = kmalloc_array(obj_desc->region_count,
+				sizeof(regions[0]), GFP_KERNEL);
+	if (regions == NULL) {
+		error = -ENOMEM;
+		FSL_MC_ERROR(parent_dev, "No memory to allocate regions[]\n");
+		goto error;
+	}
+
+	for (i = 0; i < obj_desc->region_count; i++) {
+		struct dprc_region_desc region_desc;
+
+		error = dprc_get_obj_region(container_dev->mc_io,
+					    container_dev->mc_handle,
+					    obj_desc->type,
+					    obj_desc->id, i, &region_desc);
+		if (error < 0) {
+			FSL_MC_ERROR(parent_dev,
+				     "dprc_get_obj_region() failed: %d\n",
+				     error);
+			goto error;
+		}
+
+		WARN_ON(region_desc.base_paddr == 0x0);
+		WARN_ON(region_desc.size == 0);
+		regions[i].paddr = region_desc.base_paddr;
+		regions[i].size = region_desc.size;
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
+		      struct fsl_mc_dprc *container,
+		      struct fsl_mc_device **new_mc_dev)
+{
+	int error = -EINVAL;
+	struct fsl_mc_device *mc_dev = NULL;
+	bool device_added = false;
+
+	/*
+	 * DPRC devices must have a dedicated MC portal
+	 */
+	if (WARN_ON(strcmp(obj_desc->type, "dprc") == 0 && mc_io == NULL))
+		goto error;
+
+	if (container != NULL)
+		if (WARN_ON(container->magic != FSL_MC_DPRC_MAGIC))
+			goto error;
+
+	mc_dev = kmem_cache_zalloc(mc_dev_cache, GFP_KERNEL);
+	if (mc_dev == NULL) {
+		error = -ENOMEM;
+		FSL_MC_ERROR(parent_dev,
+			     "No memory to allocate fsl_mc_device\n");
+		goto error;
+	}
+
+	mc_dev->magic = FSL_MC_DEVICE_MAGIC;
+	mc_dev->container = container;
+	INIT_LIST_HEAD(&mc_dev->dev_node);
+	mc_dev->obj_desc = *obj_desc;
+	mc_dev->mc_io = mc_io;
+	device_initialize(&mc_dev->dev);
+	mc_dev->dev.parent = parent_dev;
+	mc_dev->dev.bus = &fsl_mc_bus_type;
+	dev_set_name(&mc_dev->dev, "%s.%x", obj_desc->type, obj_desc->id);
+
+	if (strcmp(obj_desc->type, "dprc") == 0) {
+		mc_dev->flags |= FSL_MC_IS_DPRC;
+		error = get_dprc_icid(mc_io, obj_desc->id, &mc_dev->icid);
+		if (error < 0)
+			goto error;
+	} else {
+		struct fsl_mc_device *container_dev = container->mc_dev;
+
+		if (WARN_ON(container_dev->magic != FSL_MC_DEVICE_MAGIC))
+			goto error;
+
+		mc_dev->icid = container_dev->icid;
+		mc_dev->dma_mask = 0xffffffff;	/* 32bit */
+		mc_dev->dev.dma_mask = &mc_dev->dma_mask;
+		if (obj_desc->region_count != 0) {
+			error = fsl_mc_device_get_mmio_regions(mc_dev,
+							       container_dev);
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
+		FSL_MC_ERROR(parent_dev,
+			     "device_add() failed for device %s: %d\n",
+			     dev_name(&mc_dev->dev), error);
+		goto error;
+	}
+
+	get_device(&mc_dev->dev);
+	device_added = true;
+	if (container != NULL) {
+		mutex_lock(&container->mutex);
+		list_add_tail(&mc_dev->dev_node, &container->child_list);
+		mutex_unlock(&container->mutex);
+	}
+
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
+		mc_dev->magic = 0x0;
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
+	struct fsl_mc_dprc *container;
+
+	if (WARN_ON(mc_dev->magic != FSL_MC_DEVICE_MAGIC))
+		return;
+
+	if (mc_dev->regions != NULL)
+		kfree(mc_dev->regions);
+
+	container = mc_dev->container;
+	if (container != NULL) {
+		if (WARN_ON(container->magic != FSL_MC_DPRC_MAGIC))
+			return;
+
+		mutex_lock(&container->mutex);
+		list_del(&mc_dev->dev_node);
+		mutex_unlock(&container->mutex);
+	}
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
+	mc_dev->magic = 0x0;
+	kmem_cache_free(mc_dev_cache, mc_dev);
+}
+EXPORT_SYMBOL_GPL(fsl_mc_device_remove);
+
+struct fsl_mc_device *fsl_mc_device_lookup(struct dprc_obj_desc *obj_desc,
+					   struct fsl_mc_dprc *container)
+{
+	struct fsl_mc_device *mc_dev;
+
+	list_for_each_entry(mc_dev, &container->child_list, dev_node) {
+		if (FSL_MC_DEVICE_MATCH(mc_dev, obj_desc))
+			return mc_dev;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(fsl_mc_device_lookup);
+
+/**
+ * fsl_mc_bus_probe - callback invoked when the MC bus is being
+ * added
+ */
+static int fsl_mc_bus_probe(struct platform_device *pdev)
+{
+	static DEFINE_SPINLOCK(lock);
+	struct dprc_obj_desc obj_desc;
+	int error = -EINVAL;
+	struct fsl_mc_bus *mc_bus = NULL;
+	struct fsl_mc_device *mc_dev = NULL;
+	struct fsl_mc_io *mc_io = NULL;
+	int container_id;
+	phys_addr_t mc_portal_phys_addr;
+	uint32_t mc_portal_size;
+	struct mc_version mc_version;
+
+	dev_info(&pdev->dev, "MC bus platform device probed");
+	mc_bus = devm_kzalloc(&pdev->dev, sizeof(*fsl_mc_bus), GFP_KERNEL);
+	if (mc_bus == NULL) {
+		error = -ENOMEM;
+		FSL_MC_ERROR(&pdev->dev,
+			     "Failed to allocate memory for MC bus\n");
+		goto error;
+	}
+
+	spin_lock(&lock);
+	if (fsl_mc_bus == NULL) {
+		fsl_mc_bus = mc_bus;
+	} else {
+		spin_unlock(&lock);
+
+		/*
+		 * Race between two concurrent invocations of
+		 * fsl_mc_bus_probe()
+		 */
+		error = -EEXIST;
+		FSL_MC_ERROR(&pdev->dev, "MC bus device already created\n");
+		goto error;
+	}
+	spin_unlock(&lock);
+
+	fsl_mc_bus->magic = FSL_MC_BUS_MAGIC;
+	platform_set_drvdata(pdev, fsl_mc_bus);
+	fsl_mc_bus->pdev = pdev;
+
+	error = dprc_parse_dt_node(pdev, &mc_portal_phys_addr, &mc_portal_size);
+	if (error < 0)
+		goto error;
+
+	error = fsl_create_mc_io(mc_portal_phys_addr,
+				 mc_portal_size, 0, &mc_io);
+	if (error < 0)
+		goto error;
+
+	error = mc_get_version(mc_io, &mc_version);
+	if (error != 0) {
+		FSL_MC_ERROR(&pdev->dev,
+			     "mc_get_version() failed with error %d\n", error);
+		goto error;
+	}
+
+	dev_info(&pdev->dev,
+		 "Freescale Management Complex Firmware version: %u.%u.%u\n",
+		 mc_version.major, mc_version.minor, mc_version.revision);
+
+	if (mc_version.major != MC_VER_MAJOR) {
+		FSL_MC_ERROR(&pdev->dev,
+			     "ERROR: Firmware major version mismatch (found: %d, expected: %d)\n",
+			     mc_version.major, MC_VER_MAJOR);
+	}
+
+	if (mc_version.minor != MC_VER_MINOR) {
+		FSL_MC_ERROR(&pdev->dev,
+			     "WARNING: Firmware minor version mismatch (found: %d, expected: %d)\n",
+			     mc_version.minor, MC_VER_MINOR);
+	}
+
+	error = dprc_get_container_id(mc_io, &container_id);
+	if (error < 0) {
+		FSL_MC_ERROR(&pdev->dev,
+			     "dprc_get_container_id() failed: %d\n", error);
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
+	error = fsl_mc_device_add(&obj_desc, mc_io, &pdev->dev, NULL, &mc_dev);
+	if (error < 0)
+		goto error;
+
+	fsl_mc_bus->root_mc_dev = mc_dev;
+	return 0;
+error:
+	if (mc_dev != NULL)
+		fsl_mc_device_remove(mc_dev);
+	else if (mc_io != NULL)
+		fsl_destroy_mc_io(mc_io);
+
+	if (mc_bus != NULL) {
+		fsl_mc_bus->magic = 0x0;
+		devm_kfree(&pdev->dev, mc_bus);
+		if (fsl_mc_bus == mc_bus)
+			fsl_mc_bus = NULL;
+	}
+
+	return error;
+}
+
+/**
+ * fsl_mc_bus_remove - callback invoked when the MC bus is being
+ * removed
+ */
+static int fsl_mc_bus_remove(struct platform_device *pdev)
+{
+	int error = -EINVAL;
+	struct fsl_mc_bus *mc_bus = platform_get_drvdata(pdev);
+	struct fsl_mc_device *root_mc_dev;
+	struct fsl_mc_dprc *root_container;
+
+	dev_info(&pdev->dev, "MC bus removed");
+	if (WARN_ON(mc_bus != fsl_mc_bus))
+		goto error;
+	if (WARN_ON(mc_bus->magic != FSL_MC_BUS_MAGIC))
+		goto error;
+
+	root_mc_dev = fsl_mc_bus->root_mc_dev;
+	if (WARN_ON(root_mc_dev->magic != FSL_MC_DEVICE_MAGIC))
+		goto error;
+
+	root_container = root_mc_dev->mc_dev_data;
+	if (WARN_ON(root_container->magic != FSL_MC_DPRC_MAGIC))
+		goto error;
+
+	fsl_mc_device_remove(root_mc_dev);
+	fsl_mc_bus->magic = 0x0;
+	devm_kfree(&pdev->dev, fsl_mc_bus);
+	fsl_mc_bus = NULL;
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
+		FSL_MC_ERROR(NULL, "Could not create fsl_mc_device cache\n");
+		goto error;
+	}
+
+	error = bus_register(&fsl_mc_bus_type);
+	if (error < 0) {
+		FSL_MC_ERROR(NULL, "MC bus registration failed: %d\n", error);
+		goto error;
+	}
+
+	bus_registered = true;
+	pr_info("MC bus (built " __DATE__ " " __TIME__ ") registered\n");
+
+	error = platform_driver_register(&fsl_mc_bus_driver);
+	if (error < 0) {
+		FSL_MC_ERROR(NULL,
+			     "platform_driver_register() failed: %d\n", error);
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
index 0000000..37eb0b6
--- /dev/null
+++ b/include/linux/fsl_mc.h
@@ -0,0 +1,177 @@
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
+#define FSL_MC_MAGIC(_a, _b, _c, _d) \
+	(((uint32_t)(_a) << 24) | \
+	((uint32_t)(_b) << 16) | \
+	((uint32_t)(_c) << 8)  | \
+	(uint32_t)(_d))
+
+#define FSL_MC_VENDOR_FREESCALE	0x1957
+
+struct fsl_mc_device;
+struct fsl_mc_io;
+
+/**
+ * struct fsl_mc_driver - MC object device driver object
+ * @magic: marker to verify identity of this structure
+ * @probe: Function called when a device is added
+ * @remove: Function called when a device is removed
+ * @shutdown: Function called at shutdown time to quiesce the device
+ * @suspend: Function called when a device is stopped
+ * @resume: Function called when a device is resumed
+ * @driver: Generic device driver
+ * @match_id_table: table of supported device matching Ids
+ *
+ * Generic DPAA device driver object for device drivers that are registered
+ * with a DPRC bus. This structure is to be embedded in each device-specific
+ * driver structure.
+ */
+struct fsl_mc_driver {
+#	define FSL_MC_DRIVER_MAGIC   FSL_MC_MAGIC('L', 'D', 'R', 'V')
+	uint32_t magic;
+
+	int (*probe)(struct fsl_mc_device *dev);
+	int (*remove)(struct fsl_mc_device *dev);
+	void (*shutdown)(struct fsl_mc_device *dev);
+	int (*suspend)(struct fsl_mc_device *dev, pm_message_t state);
+	int (*resume)(struct fsl_mc_device *dev);
+	struct device_driver driver;
+	const struct fsl_mc_device_match_id *match_id_table;
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
+ * struct fsl_mc_device_region - MC object device MMIO region
+ * @addr: base physical address
+ * @size: size of the region in bytes
+ */
+struct fsl_mc_device_region {
+	phys_addr_t paddr;
+	uint32_t size;
+};
+
+/**
+ * Bit masks for a MC object device (struct fsl_mc_device) flags
+ */
+#define FSL_MC_IS_DPRC	0x0001
+
+/**
+ * struct fsl_mc_device - MC object device object
+ * @magic: marker to verify identity of this structure
+ * @flags: MC object device flags
+ * @icid: Isolation context ID for the device
+ * @mc_handle: MC handle for the corresponding MC object opened
+ * @mc_io: Pointer to MC IO object assigned to this device or
+ * NULL if none.
+ * @driver: Pointer to the MC object device driver for this device
+ * @container: Pointer to the DPRC device that contains this MC object device
+ * @dev_node: Node in the container's child list
+ * @obj_desc: MC description of the DPAA device
+ * @num_regions: Number of MMIO regions for this MC object device
+ * @regions: pointer to array of MMIO region entries
+ * @dma_mask: DMA mask for non-DPRC devices
+ * @dev: Linux driver model device object
+ * @mc_dev_data: Pointer to MC object device-specific data
+ *
+ * Generic device object for MC object devices that are "attached" to a
+ * MC bus.
+ *
+ * NOTES:
+ * - For a non-DPRC object its icid is the same as its parent DPRC's icid.
+ *   We could have defined the icid field in the parent DPRC's fsl_mc_dprc
+ *   structure instead of here, since non-DPRC objects have a pointer to their
+ *   parent DPRC. However, we need to have it here, because the fsl_mc_dprc
+ *   structure is created too late for the SMMU driver notifier callback to use
+ *   it. The fsl_mc_dprc structure is created by the DPRC driver's
+ *   probe callback (dprc_probe()). The SMMU notifier callback gets invoked
+ *   after device_add() has been called for an MC object device, but before
+ *   the device-specific probe callback gets called.
+ * - DP_OBJ_DPRC objects are the only MC objects that have built-in MC
+ *   portals. For all other MC objects, their device drivers are responsible for
+ *   allocating MC portals for them by calling fsl_mc_portal_allocate().
+ * - dev.drvdata is used by driver for keeping its own local information
+ *   using that device and MC bus driver is not supposed to use
+ *   dev.drvdata. So we have defined mc_dev_data for keeping dprc device
+ *   information which will be used by MC bus and free dev.drvdata
+ *   for driver local usages.
+ */
+struct fsl_mc_device {
+#	define FSL_MC_DEVICE_MAGIC   FSL_MC_MAGIC('L', 'D', 'E', 'V')
+	uint32_t magic;
+	uint16_t flags;
+	uint16_t icid;
+	uint16_t mc_handle;
+	struct fsl_mc_io *mc_io;
+	struct fsl_mc_driver *driver;
+	struct fsl_mc_dprc *container;
+	struct list_head dev_node;
+	struct dprc_obj_desc obj_desc;
+	struct fsl_mc_device_region *regions;
+	uint64_t dma_mask;
+	struct device dev;
+	void *mc_dev_data;
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
index 0000000..dabd030
--- /dev/null
+++ b/include/linux/fsl_mc_private.h
@@ -0,0 +1,85 @@
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
+#define FSL_MC_ERROR(_dev, _fmt, ...) \
+	do {								\
+		if ((_dev) != NULL)					\
+			dev_err(_dev, "%s:" __stringify(__LINE__) " "   \
+				_fmt, __func__, ##__VA_ARGS__);		\
+		else							\
+			pr_err("%s:" __stringify(__LINE__) " " _fmt,	\
+			       __func__, ##__VA_ARGS__);		\
+	} while (0)
+
+#define FSL_MC_DEVICE_MATCH(_mc_dev, _obj_desc) \
+	(strcmp((_mc_dev)->obj_desc.type, (_obj_desc)->type) == 0 && \
+	 (_mc_dev)->obj_desc.id == (_obj_desc)->id)
+
+#define FSL_MC_IS_ALLOCATABLE(_obj_type) \
+	(strcmp(_obj_type, "dpbp") == 0 || \
+	 strcmp(_obj_type, "dpcon") == 0)
+
+/**
+ * struct fsl_mc_bus - Management Complex (MC) bus object
+ * @magic: marker to verify identity of this structure
+ * @pdev: platform device for this MC bus object
+ * @root_mc_dev: pointer to root MC object device for this MC bus.
+ */
+struct fsl_mc_bus {
+#	define FSL_MC_BUS_MAGIC   FSL_MC_MAGIC('L', 'B', 'U', 'S')
+	uint32_t magic;
+	struct platform_device *pdev;
+	struct fsl_mc_device *root_mc_dev;
+};
+
+/**
+ * struct fsl_mc_dprc - Data Path Resource Container (DPRC) object
+ * @magic: marker to verify identity of this structure
+ * @mc_dev: pointer to MC object device object for this DPRC
+ * @mutex: mutex to serialize access to the container.
+ * @child_device_count: have the count of devices in this DPRC
+ * @child_list:	anchor node of list of child devices on this DPRC
+ */
+struct fsl_mc_dprc {
+#	define FSL_MC_DPRC_MAGIC   FSL_MC_MAGIC('D', 'P', 'R', 'C')
+	uint32_t magic;
+	struct fsl_mc_device *mc_dev;
+	struct mutex mutex;	/* serializes access to fields below */
+	uint16_t child_device_count;	/* Count of devices in this DPRC */
+	struct list_head child_list;
+};
+
+int __must_check fsl_mc_device_add(struct dprc_obj_desc *obj_desc,
+				   struct fsl_mc_io *mc_io,
+				   struct device *parent_dev,
+				   struct fsl_mc_dprc *container,
+				   struct fsl_mc_device **new_mc_dev);
+
+void fsl_mc_device_remove(struct fsl_mc_device *mc_dev);
+
+struct fsl_mc_device *__must_check fsl_mc_device_lookup(struct dprc_obj_desc
+								*obj_desc,
+							struct fsl_mc_dprc
+								*container);
+
+int __must_check dprc_scan_container(struct fsl_mc_dprc *container);
+
+int __must_check dprc_discover_container_objects(struct fsl_mc_dprc *container);
+
+extern struct fsl_mc_bus *fsl_mc_bus;
+
+#endif /* _FSL_MC_PRIVATE_H_ */
--
1.7.9.7

