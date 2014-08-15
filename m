Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaHOWOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 18:14:08 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:3374
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751755AbaHOWNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 18:13:33 -0400
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <linuxppc-release@linux.freescale.net>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [RFC PATCH 3/4] drivers/bus: Device driver for FSL-MC DPRC devices
Date: Fri, 15 Aug 2014 17:13:13 -0500
Message-ID: <1408140794-25064-4-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1408140794-25064-1-git-send-email-German.Rivera@freescale.com>
References: <1408140794-25064-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(77156001)(4396001)(81542001)(2201001)(80022001)(104016003)(86362001)(229853001)(107046002)(76176999)(93916002)(92726001)(69596002)(77982001)(106466001)(84676001)(64706001)(19580405001)(95666004)(81156004)(19580395003)(44976005)(20776003)(50226001)(6806004)(68736004)(50986999)(92566001)(88136002)(31966008)(21056001)(79102001)(102836001)(89996001)(83072002)(97736001)(48376002)(62966002)(50466002)(99396002)(36756003)(105606002)(47776003)(83322001)(74662001)(81342001)(26826002)(76482001)(46102001)(85306004)(87286001)(85852003)(104166001)(87936001)(74502001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB334;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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

A DPRC (Data Path Resource Container) is an isolation device
that contains a set of DPAA networking devices to be
assigned to an isolation domain (e.g., a virtual machine).

Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
---
 drivers/bus/fsl-mc/Makefile      |    3 +-
 drivers/bus/fsl-mc/fsl_mc_dprc.c |  422 ++++++++++++++++++++++++++++++++++++++
 include/linux/fsl_mc_private.h   |    4 +-
 3 files changed, 427 insertions(+), 2 deletions(-)
 create mode 100644 drivers/bus/fsl-mc/fsl_mc_dprc.c

diff --git a/drivers/bus/fsl-mc/Makefile b/drivers/bus/fsl-mc/Makefile
index f5f9033..4991999 100644
--- a/drivers/bus/fsl-mc/Makefile
+++ b/drivers/bus/fsl-mc/Makefile
@@ -5,7 +5,8 @@
 #
 # This file is released under the GPLv2
 #
-obj-$(CONFIG_FSL_MC_BUS) += fsl_mc_bus_driver.o
+obj-$(CONFIG_FSL_MC_BUS) += fsl_mc_bus_driver.o \
+			    fsl_mc_dprc.o

 fsl_mc_bus_driver-objs := fsl_mc_bus.o \
 			      mc_sys.o \
diff --git a/drivers/bus/fsl-mc/fsl_mc_dprc.c b/drivers/bus/fsl-mc/fsl_mc_dprc.c
new file mode 100644
index 0000000..648d41f
--- /dev/null
+++ b/drivers/bus/fsl-mc/fsl_mc_dprc.c
@@ -0,0 +1,422 @@
+/*
+ * Freescale daata path resource container (DPRC) driver
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
+#include <linux/fsl_mc_sys.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include "fsl_dprc_cmd.h"
+
+/**
+ * dprc_remove_all_devices - Does a bus remove for all objects of a DPRC
+ *
+ * @container: pointer to the DPRC object
+ *
+ * Removes all devices on the bus that represents the DPRC object.
+ */
+static void dprc_remove_all_devices(struct fsl_mc_dprc *container)
+{
+	struct fsl_mc_device *mc_dev;
+	struct fsl_mc_device *next;
+
+	list_for_each_entry_safe(mc_dev, next, &container->child_list,
+				 dev_node) {
+		WARN_ON(mc_dev->container != container);
+		fsl_mc_device_remove(mc_dev);
+	}
+}
+
+/**
+ * dprc_remove_devices - Removes devices for objects removed from a DPRC
+ *
+ * @container: pointer to the DPRC container object
+ * @obj_desc_array: array of object descriptors for child objects currently
+ * present in the DPRC in the MC.
+ * @num_child_objects_in_mc: number of entries in obj_desc_array
+ *
+ * Synchronizes the state of the Linux bus driver with the actual
+ * state of the MC by removing objects that have been dynamically
+ * removed in the physical DPRC.
+ */
+static void dprc_remove_devices(struct fsl_mc_dprc *container,
+				struct dprc_obj_desc *obj_desc_array,
+				int num_child_objects_in_mc)
+{
+	if (num_child_objects_in_mc != 0) {
+		/*
+		 * Remove child objects that are in the DPRC in Linux,
+		 * but not in the MC:
+		 */
+		int i;
+		struct fsl_mc_device *child_obj;
+		struct fsl_mc_device *next;
+
+		list_for_each_entry_safe(child_obj, next,
+					 &container->child_list, dev_node) {
+			for (i = 0; i < num_child_objects_in_mc; i++) {
+				if (strlen(obj_desc_array[i].type) != 0 &&
+				    FSL_MC_DEVICE_MATCH(child_obj,
+							&obj_desc_array[i]))
+					break;
+			}
+
+			if (i == num_child_objects_in_mc)
+				fsl_mc_device_remove(child_obj);
+		}
+	} else {
+		/*
+		 * There are no child objects for this DPRC in the MC.
+		 * So, remove all the child objects from Linux:
+		 */
+		dprc_remove_all_devices(container);
+	}
+}
+
+/**
+ * dprc_add_new_devices - Adds devices to the bus that represents a DPRC
+ *
+ * @container: pointer to the DPRC container object
+ * @obj_desc_array: array of device descriptors for child device currently
+ * present in the DPRC container in the MC.
+ * @num_child_objects_in_mc: number of entries in obj_desc_array
+ *
+ * Synchronizes the state of the Linux bus driver with the actual
+ * state of the MC by adding objects that have been newly discovered
+ * in the physical DPRC.
+ */
+static void dprc_add_new_devices(struct fsl_mc_dprc *container,
+				 struct dprc_obj_desc *obj_desc_array,
+				 int num_child_objects_in_mc)
+{
+	int error;
+	int i;
+	struct fsl_mc_device *mc_dev = container->mc_dev;
+	struct device *dev = &mc_dev->dev;
+
+	for (i = 0; i < num_child_objects_in_mc; i++) {
+		struct dprc_region_desc region_desc;
+		struct fsl_mc_device *child_obj;
+		struct fsl_mc_io *mc_io = NULL;
+		struct dprc_obj_desc *obj_desc = &obj_desc_array[i];
+
+		if (strlen(obj_desc->type) == 0)
+			continue;
+		/*
+		 * Check if device is already known to Linux:
+		 */
+		child_obj = fsl_mc_device_lookup(obj_desc, container);
+		if (child_obj != NULL)
+			continue;
+
+		if (strcmp(obj_desc->type, "dprc") == 0) {
+			/*
+			 * Get the MC portal physical address for the device
+			 * (specified in the device's first MMIO region):
+			 */
+			if (WARN_ON(obj_desc->region_count == 0))
+				continue;
+
+			error = dprc_get_obj_region(mc_dev->mc_io,
+						    mc_dev->mc_handle,
+						    obj_desc->type,
+						    obj_desc->id,
+						    0, &region_desc);
+			if (error < 0) {
+				FSL_MC_ERROR(dev,
+					     "dprc_get_obj_region() failed: %d\n",
+					     error);
+				continue;
+			}
+
+			if (region_desc.size != mc_dev->mc_io->portal_size) {
+				error = -EINVAL;
+				FSL_MC_ERROR(dev,
+					     "Invalid MC portal size: %lu\n",
+					     region_desc.size);
+				continue;
+			}
+
+			error = fsl_create_mc_io(region_desc.base_paddr,
+						 region_desc.size, 0, &mc_io);
+			if (error < 0)
+				continue;
+		}
+
+		error = fsl_mc_device_add(obj_desc,
+					  mc_io, dev, container, &child_obj);
+		if (error < 0) {
+			if (mc_io != NULL)
+				fsl_destroy_mc_io(mc_io);
+
+			continue;
+		}
+	}
+}
+
+/**
+ * dprc_scan_objects - Discover objects in a DPRC
+ *
+ * @container: pointer to the DPRC container to be scanned.
+ *
+ * Detects objects added and removed from a DPRC and synchronizes the
+ * state of the Linux bus driver, MC by adding and removing
+ * devices accordingly.
+ */
+int dprc_scan_objects(struct fsl_mc_dprc *container)
+{
+	int num_child_objects;
+	int dprc_get_obj_failures;
+	int error = -EINVAL;
+	struct dprc_obj_desc *child_obj_desc_array = NULL;
+	struct device *dev;
+	struct fsl_mc_device *container_dev;
+
+	if (WARN_ON(container->magic != FSL_MC_DPRC_MAGIC))
+		goto out;
+	container_dev = container->mc_dev;
+	if (WARN_ON(container_dev->magic != FSL_MC_DEVICE_MAGIC))
+		goto out;
+
+	dev = &container_dev->dev;
+	error = dprc_get_obj_count(container_dev->mc_io,
+				   container_dev->mc_handle,
+				   &num_child_objects);
+	if (error < 0) {
+		FSL_MC_ERROR(dev, "dprc_get_obj_count() failed: %d\n", error);
+		goto out;
+	}
+
+	if (num_child_objects != 0) {
+		int i;
+
+		child_obj_desc_array =
+		    kmalloc_array(num_child_objects,
+				  sizeof(*child_obj_desc_array), GFP_KERNEL);
+		if (child_obj_desc_array == NULL) {
+			error = -ENOMEM;
+			FSL_MC_ERROR(dev,
+				     "No memory to allocate obj_desc array\n");
+			goto out;
+		}
+
+		/*
+		 * Discover objects currently in the DPRC container in the MC:
+		 */
+		dprc_get_obj_failures = 0;
+		for (i = 0; i < num_child_objects; i++) {
+			struct dprc_obj_desc *obj_desc =
+			    &child_obj_desc_array[i];
+
+			error = dprc_get_obj(container_dev->mc_io,
+					     container_dev->mc_handle,
+					     i, obj_desc);
+			if (error < 0) {
+				FSL_MC_ERROR(dev,
+					     "dprc_get_obj(i=%d) failed: %d\n",
+					     i, error);
+				/*
+				 * Mark the obj entry as "invalid", by using the
+				 * empty string as obj type:
+				 */
+				obj_desc->type[0] = '\0';
+				obj_desc->id = error;
+				dprc_get_obj_failures++;
+				continue;
+			}
+
+			dev_info(dev, "Discovered object: type %s, id %d\n",
+				 obj_desc->type, obj_desc->id);
+		}
+
+		if (dprc_get_obj_failures != 0) {
+			FSL_MC_ERROR(dev,
+				     "%d out of %d devices could not be retrieved\n",
+				     dprc_get_obj_failures, num_child_objects);
+		}
+	}
+
+	dprc_remove_devices(container, child_obj_desc_array, num_child_objects);
+
+	dprc_add_new_devices(container, child_obj_desc_array,
+			     num_child_objects);
+
+	error = 0;
+out:
+	if (child_obj_desc_array != NULL)
+		kfree(child_obj_desc_array);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(dprc_scan_objects);
+
+/**
+ * dprc_scan_container - Scans the DPRC and synchronizes Linux bus state
+ *
+ * @container: pointer to the DPRC to be scanned.
+ *
+ * Scans the physical DPRC and synchronizes the state of the Linux
+ * bus driver with the actual state of the MC by adding and removing
+ * devices as appropriate.
+ */
+int dprc_scan_container(struct fsl_mc_dprc *container)
+{
+	int error = -EINVAL;
+
+	if (WARN_ON(container->magic != FSL_MC_DPRC_MAGIC))
+		goto error;
+	if (WARN_ON(container->mc_dev->magic != FSL_MC_DEVICE_MAGIC))
+		goto error;
+
+	error = dprc_scan_objects(container);
+	if (error < 0)
+		goto error;
+
+	return 0;
+error:
+	return error;
+}
+EXPORT_SYMBOL_GPL(dprc_scan_container);
+
+/**
+ * dprc_probe - callback invoked when a DPRC is being bound to this driver
+ *
+ * @mc_dev: Pointer to fsl-mc device representing an DPRC object
+ *
+ * It creates the corresponding fsl_mc_dprc object and opens the DPRC object
+ * in the MC.
+ * It scans the DPRC to discover MC portals and MC objects contained in it.
+ */
+static int dprc_probe(struct fsl_mc_device *mc_dev)
+{
+	int irq_count;
+	struct fsl_mc_io *mc_io;
+	struct fsl_mc_dprc *container = NULL;
+	int error = -EINVAL;
+	bool dprc_opened = false;
+
+	if (WARN_ON(mc_dev->magic != FSL_MC_DEVICE_MAGIC))
+		goto error;
+	if (WARN_ON(strcmp(mc_dev->obj_desc.type, "dprc") != 0))
+		goto error;
+
+	mc_io = mc_dev->mc_io;
+	if (WARN_ON(mc_io->magic != FSL_MC_IO_MAGIC))
+		goto error;
+
+	irq_count = mc_dev->obj_desc.irq_count;
+	if (WARN_ON(irq_count == 0))
+		goto error;
+
+	container = devm_kzalloc(&mc_dev->dev, sizeof(*container), GFP_KERNEL);
+	if (container == NULL) {
+		error = -ENOMEM;
+		FSL_MC_ERROR(&mc_dev->dev,
+			     "Failed to allocate memory for dprc device\n");
+		goto error;
+	}
+
+	mc_dev->mc_dev_data = container;
+	container->magic = FSL_MC_DPRC_MAGIC;
+	container->mc_dev = mc_dev;
+	INIT_LIST_HEAD(&container->child_list);
+	mutex_init(&container->mutex);
+
+	error = dprc_open(mc_io, mc_dev->obj_desc.id, &mc_dev->mc_handle);
+	if (error < 0) {
+		FSL_MC_ERROR(&mc_dev->dev, "dprc_open() failed: %d\n", error);
+		goto error;
+	}
+
+	dprc_opened = true;
+	error = dprc_scan_container(container);
+	if (error < 0)
+		goto error;
+
+	dev_info(&mc_dev->dev, "DPRC device bound to driver");
+	return 0;
+error:
+	if (container != NULL) {
+		if (dprc_opened)
+			(void)dprc_close(mc_io, mc_dev->mc_handle);
+
+		container->magic = 0x0;
+		devm_kfree(&mc_dev->dev, container);
+	}
+
+	return error;
+}
+
+/**
+ * dprc_remove - callback invoked when a DPRC is being unbound from this driver
+ *
+ * @mc_dev: Pointer to fsl-mc device representing an DPRC object
+ *
+ * It removes the DPRC's child objects from Linux (not from the MC) and
+ * closes the DPRC device in the MC.
+ * It destroys the corresponding fsl_mc_dprc object.
+ */
+static int dprc_remove(struct fsl_mc_device *mc_dev)
+{
+	struct fsl_mc_dprc *container;
+	int error = -EINVAL;
+
+	if (WARN_ON(mc_dev->magic != FSL_MC_DEVICE_MAGIC))
+		goto error;
+	if (WARN_ON(strcmp(mc_dev->obj_desc.type, "dprc") != 0))
+		goto error;
+	if (WARN_ON(mc_dev->mc_io == NULL))
+		goto error;
+
+	container = mc_dev->mc_dev_data;
+	if (WARN_ON(container->magic != FSL_MC_DPRC_MAGIC))
+		goto error;
+	if (WARN_ON(fsl_mc_bus->magic != FSL_MC_BUS_MAGIC))
+		goto error;
+
+	dprc_remove_all_devices(container);
+	error = dprc_close(mc_dev->mc_io, mc_dev->mc_handle);
+	if (error < 0)
+		FSL_MC_ERROR(&mc_dev->dev, "dprc_close() failed: %d\n", error);
+
+	container->magic = 0x0;
+	devm_kfree(&mc_dev->dev, container);
+
+	dev_info(&mc_dev->dev, "DPRC device unbound from driver");
+	return 0;
+error:
+	return error;
+}
+
+static const struct fsl_mc_device_match_id match_id_table[] = {
+	{
+	 .vendor = FSL_MC_VENDOR_FREESCALE,
+	 .obj_type = "dprc",
+	 .ver_major = DPRC_VER_MAJOR,
+	 .ver_minor = DPRC_VER_MINOR},
+	{.vendor = 0x0},
+};
+
+static struct fsl_mc_driver dprc_driver = {
+	.driver = {
+		   .name = FSL_MC_DPRC_DRIVER_NAME,
+		   .owner = THIS_MODULE,
+		   .pm = NULL,
+		   },
+	.match_id_table = match_id_table,
+	.probe = dprc_probe,
+	.remove = dprc_remove,
+};
+
+module_fsl_mc_driver(dprc_driver);
+
+MODULE_AUTHOR("Freescale Semiconductor Inc.");
+MODULE_DESCRIPTION("Freescale's DPRC container driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/fsl_mc_private.h b/include/linux/fsl_mc_private.h
index dabd030..4eacb2a 100644
--- a/include/linux/fsl_mc_private.h
+++ b/include/linux/fsl_mc_private.h
@@ -25,6 +25,8 @@
 			       __func__, ##__VA_ARGS__);		\
 	} while (0)

+#define FSL_MC_DPRC_DRIVER_NAME    "fsl_mc_dprc"
+
 #define FSL_MC_DEVICE_MATCH(_mc_dev, _obj_desc) \
 	(strcmp((_mc_dev)->obj_desc.type, (_obj_desc)->type) == 0 && \
 	 (_mc_dev)->obj_desc.id == (_obj_desc)->id)
@@ -78,7 +80,7 @@ struct fsl_mc_device *__must_check fsl_mc_device_lookup(struct dprc_obj_desc

 int __must_check dprc_scan_container(struct fsl_mc_dprc *container);

-int __must_check dprc_discover_container_objects(struct fsl_mc_dprc *container);
+int __must_check dprc_discover_objects(struct fsl_mc_dprc *container);

 extern struct fsl_mc_bus *fsl_mc_bus;

--
1.7.9.7

