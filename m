Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaHWEKb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 00:10:31 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:29951
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751179AbaHWEKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 00:10:04 -0400
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <linuxppc-release@linux.freescale.net>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [RFC PATCH 3/4 v3] drivers/bus: Device driver for FSL-MC DPRC devices
Date: Fri, 22 Aug 2014 23:09:36 -0500
Message-ID: <1408766977-2283-4-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1408766977-2283-1-git-send-email-German.Rivera@freescale.com>
References: <1408766977-2283-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(47776003)(81342001)(83072002)(92726001)(62966002)(87936001)(74662001)(4396001)(31966008)(86362001)(85852003)(50466002)(74502001)(44976005)(92566001)(80022001)(84676001)(87286001)(89996001)(107046002)(88136002)(229853001)(19580405001)(26826002)(68736004)(90102001)(104016003)(97736001)(77156001)(48376002)(104166001)(93916002)(2201001)(76482001)(105606002)(77982001)(50986999)(76176999)(102836001)(19580395003)(21056001)(81542001)(85306004)(95666004)(50226001)(79102001)(36756003)(83322001)(46102001)(64706001)(99396002)(6806004)(20776003)(106466001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0743;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031257FE13
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
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
 drivers/bus/fsl-mc/fsl_mc_dprc.c |  395 ++++++++++++++++++++++++++++++++++++++
 include/linux/fsl_mc_private.h   |    6 +
 3 files changed, 403 insertions(+), 1 deletion(-)
 create mode 100644 drivers/bus/fsl-mc/fsl_mc_dprc.c

diff --git a/drivers/bus/fsl-mc/Makefile b/drivers/bus/fsl-mc/Makefile
index 2981d70..499dc9b 100644
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
 			      fsl_mc_sys.o \
diff --git a/drivers/bus/fsl-mc/fsl_mc_dprc.c b/drivers/bus/fsl-mc/fsl_mc_dprc.c
new file mode 100644
index 0000000..7372171
--- /dev/null
+++ b/drivers/bus/fsl-mc/fsl_mc_dprc.c
@@ -0,0 +1,395 @@
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
+struct dprc_child_objs {
+	int child_count;
+	struct dprc_obj_desc *child_array;
+};
+
+static int __fsl_mc_device_remove_if_not_in_mc(struct device *dev, void *data)
+{
+	int i;
+	struct dprc_child_objs *objs;
+	struct fsl_mc_device *mc_dev;
+
+	WARN_ON(dev == NULL);
+	WARN_ON(data == NULL);
+	mc_dev = to_fsl_mc_device(dev);
+	objs = data;
+
+	for (i = 0; i < objs->child_count; i++) {
+		struct dprc_obj_desc *obj_desc = &objs->child_array[i];
+
+		if (strlen(obj_desc->type) != 0 &&
+		    FSL_MC_DEVICE_MATCH(mc_dev, obj_desc))
+			break;
+	}
+
+	if (i == objs->child_count)
+		fsl_mc_device_remove(mc_dev);
+
+	return 0;
+}
+
+static int __fsl_mc_device_remove(struct device *dev, void *data)
+{
+	WARN_ON(dev == NULL);
+	WARN_ON(data != NULL);
+	fsl_mc_device_remove(to_fsl_mc_device(dev));
+	return 0;
+}
+
+/**
+ * dprc_remove_devices - Removes devices for objects removed from a DPRC
+ *
+ * @mc_bus_dev: pointer to the fsl-mc device that represents a DPRC object
+ * @obj_desc_array: array of object descriptors for child objects currently
+ * present in the DPRC in the MC.
+ * @num_child_objects_in_mc: number of entries in obj_desc_array
+ *
+ * Synchronizes the state of the Linux bus driver with the actual state of
+ * the MC by removing devices that represent MC objects that have
+ * been dynamically removed in the physical DPRC.
+ */
+static void dprc_remove_devices(struct fsl_mc_device *mc_bus_dev,
+				struct dprc_obj_desc *obj_desc_array,
+				int num_child_objects_in_mc)
+{
+	if (num_child_objects_in_mc != 0) {
+		/*
+		 * Remove child objects that are in the DPRC in Linux,
+		 * but not in the MC:
+		 */
+		struct dprc_child_objs objs;
+
+		objs.child_count = num_child_objects_in_mc;
+		objs.child_array = obj_desc_array;
+		device_for_each_child(&mc_bus_dev->dev, &objs,
+				      __fsl_mc_device_remove_if_not_in_mc);
+	} else {
+		/*
+		 * There are no child objects for this DPRC in the MC.
+		 * So, remove all the child devices from Linux:
+		 */
+		device_for_each_child(&mc_bus_dev->dev, NULL,
+				      __fsl_mc_device_remove);
+	}
+}
+
+static int __fsl_mc_device_match(struct device *dev, void *data)
+{
+	struct dprc_obj_desc *obj_desc = data;
+	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+
+	return FSL_MC_DEVICE_MATCH(mc_dev, obj_desc);
+}
+
+static struct fsl_mc_device *fsl_mc_device_lookup(struct dprc_obj_desc
+								*obj_desc,
+						  struct fsl_mc_device
+								*mc_bus_dev)
+{
+	struct device *dev;
+
+	dev = device_find_child(mc_bus_dev, obj_desc, __fsl_mc_device_match);
+	return (dev != NULL) ? to_fsl_mc_device(dev) : NULL;
+}
+
+/**
+ * dprc_add_new_devices - Adds devices to the logical bus for a DPRC
+ *
+ * @mc_bus_dev: pointer to the fsl-mc device that represents a DPRC object
+ * @obj_desc_array: array of device descriptors for child devices currently
+ * present in the physical DPRC.
+ * @num_child_objects_in_mc: number of entries in obj_desc_array
+ *
+ * Synchronizes the state of the Linux bus driver with the actual
+ * state of the MC by adding objects that have been newly discovered
+ * in the physical DPRC.
+ */
+static void dprc_add_new_devices(struct fsl_mc_device *mc_bus_dev,
+				 struct dprc_obj_desc *obj_desc_array,
+				 int num_child_objects_in_mc)
+{
+	int error;
+	int i;
+
+	for (i = 0; i < num_child_objects_in_mc; i++) {
+		struct dprc_region_desc region_desc;
+		struct fsl_mc_device *child_dev;
+		struct fsl_mc_io *mc_io = NULL;
+		struct dprc_obj_desc *obj_desc = &obj_desc_array[i];
+
+		if (strlen(obj_desc->type) == 0)
+			continue;
+		/*
+		 * Check if device is already known to Linux:
+		 */
+		child_dev = fsl_mc_device_lookup(obj_desc, mc_bus_dev);
+		if (child_dev != NULL)
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
+			error = dprc_get_obj_region(mc_bus_dev->mc_io,
+						    mc_bus_dev->mc_handle,
+						    obj_desc->type,
+						    obj_desc->id,
+						    0, &region_desc);
+			if (error < 0) {
+				dev_err(&mc_bus_dev->dev,
+					"dprc_get_obj_region() failed: %d\n",
+					error);
+				continue;
+			}
+
+			if (region_desc.size !=
+					mc_bus_dev->mc_io->portal_size) {
+				error = -EINVAL;
+				dev_err(&mc_bus_dev->dev,
+					"Invalid MC portal size: %lu\n",
+					region_desc.size);
+				continue;
+			}
+
+			error = fsl_create_mc_io(region_desc.base_paddr,
+						 region_desc.size, 0, &mc_io);
+			if (error < 0)
+				continue;
+		}
+
+		error = fsl_mc_device_add(obj_desc, mc_io, &mc_bus_dev->dev,
+					  &child_dev);
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
+ * @mc_bus_dev: pointer to the fsl-mc device that represents a DPRC object
+ *
+ * Detects objects added and removed from a DPRC and synchronizes the
+ * state of the Linux bus driver, MC by adding and removing
+ * devices accordingly.
+ */
+int dprc_scan_objects(struct fsl_mc_device *mc_bus_dev)
+{
+	int num_child_objects;
+	int dprc_get_obj_failures;
+	int error = -EINVAL;
+	struct dprc_obj_desc *child_obj_desc_array = NULL;
+
+	error = dprc_get_obj_count(mc_bus_dev->mc_io,
+				   mc_bus_dev->mc_handle,
+				   &num_child_objects);
+	if (error < 0) {
+		dev_err(&mc_bus_dev->dev, "dprc_get_obj_count() failed: %d\n",
+			error);
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
+			dev_err(&mc_bus_dev->dev,
+				"No memory to allocate obj_desc array\n");
+			goto out;
+		}
+
+		/*
+		 * Discover objects currently present in the physical DPRC:
+		 */
+		dprc_get_obj_failures = 0;
+		for (i = 0; i < num_child_objects; i++) {
+			struct dprc_obj_desc *obj_desc =
+			    &child_obj_desc_array[i];
+
+			error = dprc_get_obj(mc_bus_dev->mc_io,
+					     mc_bus_dev->mc_handle,
+					     i, obj_desc);
+			if (error < 0) {
+				dev_err(&mc_bus_dev->dev,
+					"dprc_get_obj(i=%d) failed: %d\n",
+					i, error);
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
+			dev_info(&mc_bus_dev->dev,
+				 "Discovered object: type %s, id %d\n",
+				 obj_desc->type, obj_desc->id);
+		}
+
+		if (dprc_get_obj_failures != 0) {
+			dev_err(&mc_bus_dev->dev,
+				"%d out of %d devices could not be retrieved\n",
+				dprc_get_obj_failures, num_child_objects);
+		}
+	}
+
+	dprc_remove_devices(mc_bus_dev, child_obj_desc_array,
+			    num_child_objects);
+
+	dprc_add_new_devices(mc_bus_dev, child_obj_desc_array,
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
+ * dprc_scan_container - Scans a physical DPRC and synchronizes Linux bus state
+ *
+ * @mc_bus_dev: pointer to the fsl-mc device that represents a DPRC object
+ *
+ * Scans the physical DPRC and synchronizes the state of the Linux
+ * bus driver with the actual state of the MC by adding and removing
+ * devices as appropriate.
+ */
+int dprc_scan_container(struct fsl_mc_device *mc_bus_dev)
+{
+	int error = -EINVAL;
+
+	error = dprc_scan_objects(mc_bus_dev);
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
+ * @mc_dev: Pointer to fsl-mc device representing a DPRC
+ *
+ * It opens the physical DPRC in the MC.
+ * It scans the DPRC to discover the MC objects contained in it.
+ */
+static int dprc_probe(struct fsl_mc_device *mc_dev)
+{
+	int error = -EINVAL;
+	bool dprc_opened = false;
+
+	if (WARN_ON(strcmp(mc_dev->obj_desc.type, "dprc") != 0))
+		goto error;
+
+	error = dprc_open(mc_dev->mc_io, mc_dev->obj_desc.id,
+			  &mc_dev->mc_handle);
+	if (error < 0) {
+		dev_err(&mc_dev->dev, "dprc_open() failed: %d\n", error);
+		goto error;
+	}
+
+	dprc_opened = true;
+	error = dprc_scan_container(mc_dev);
+	if (error < 0)
+		goto error;
+
+	dev_info(&mc_dev->dev, "DPRC device bound to driver");
+	return 0;
+error:
+	if (dprc_opened)
+		(void)dprc_close(mc_dev->mc_io, mc_dev->mc_handle);
+
+	return error;
+}
+
+/**
+ * dprc_remove - callback invoked when a DPRC is being unbound from this driver
+ *
+ * @mc_dev: Pointer to fsl-mc device representing the DPRC
+ *
+ * It removes the DPRC's child objects from Linux (not from the MC) and
+ * closes the DPRC device in the MC.
+ */
+static int dprc_remove(struct fsl_mc_device *mc_dev)
+{
+	int error = -EINVAL;
+
+	if (WARN_ON(strcmp(mc_dev->obj_desc.type, "dprc") != 0))
+		goto error;
+	if (WARN_ON(mc_dev->mc_io == NULL))
+		goto error;
+
+	device_for_each_child(mc_dev, NULL, __fsl_mc_device_remove);
+	error = dprc_close(mc_dev->mc_io, mc_dev->mc_handle);
+	if (error < 0)
+		dev_err(&mc_dev->dev, "dprc_close() failed: %d\n", error);
+
+	devm_kfree(&mc_dev->dev,  mc_dev->mc_dev_data);
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
index 3ff3f2b..ece79f3 100644
--- a/include/linux/fsl_mc_private.h
+++ b/include/linux/fsl_mc_private.h
@@ -15,6 +15,8 @@
 #include <linux/mutex.h>
 #include <linux/stringify.h>

+#define FSL_MC_DPRC_DRIVER_NAME    "fsl_mc_dprc"
+
 #define FSL_MC_DEVICE_MATCH(_mc_dev, _obj_desc) \
 	(strcmp((_mc_dev)->obj_desc.type, (_obj_desc)->type) == 0 && \
 	 (_mc_dev)->obj_desc.id == (_obj_desc)->id)
@@ -30,4 +32,8 @@ int __must_check fsl_mc_device_add(struct dprc_obj_desc *obj_desc,

 void fsl_mc_device_remove(struct fsl_mc_device *mc_dev);

+int __must_check dprc_scan_container(struct fsl_mc_device *mc_bus_dev);
+
+int __must_check dprc_scan_objects(struct fsl_mc_device *mc_bus_dev);
+
 #endif /* _FSL_MC_PRIVATE_H_ */
--
1.7.9.7

