Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaLCXP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:15:57 -0500
Received: from mail-bn1bon0132.outbound.protection.outlook.com ([157.56.111.132]:1441
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752554AbaLCXOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:14:52 -0500
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>, <bhamciu1@freescale.com>,
        <R89243@freescale.com>, <Geoff.Thorpe@freescale.com>,
        <bhupesh.sharma@freescale.com>, <nir.erez@freescale.com>,
        <richard.schmitt@freescale.com>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [PATCH 3/3 v5] drivers/bus: Device driver for FSL-MC DPRC devices
Date: Wed, 3 Dec 2014 17:12:59 -0600
Message-ID: <1417648379-12518-4-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <1417648379-12518-1-git-send-email-German.Rivera@freescale.com>
References: <1417648379-12518-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(4396001)(6806004)(69596002)(19580395003)(19580405001)(44976005)(50226001)(48376002)(50466002)(50986999)(76176999)(21056001)(104166001)(120916001)(102836001)(62966003)(77156002)(99396003)(47776003)(20776003)(64706001)(89996001)(92726001)(106466001)(93916002)(575784001)(86362001)(105606002)(81156004)(92566001)(2201001)(229853001)(87286001)(107046002)(87936001)(84676001)(88136002)(95666004)(31966008)(46102003)(97736003)(36756003)(68736005)(104016003)(77096005);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1298;H:az84smr01.freescale.net;FPR:;SPF:Fail;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1298;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1298;
X-Forefront-PRVS: 0414DF926F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=German.Rivera@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1298;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A DPRC (Data Path Resource Container) is an isolation device
that contains a set of DPAA networking devices to be
assigned to an isolation domain (e.g., a virtual machine).

Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
---
Changes in v5:
None

Changes in v4:
- Addressed comments from Alex Graf:
  * Fixed typo in comment

Changes in v3:
- Addressed comments from Kim Phillips:
  * Renamed files:
    drivers/bus/fsl-mc/fsl_mc_dprc.c -> drivers/bus/fsl-mc/dprc-driver.c

- Addressed comments from Timur Tabi:
  * Changed dprc_scan_container() to just return dprc_scan_objects()
  * Changed all functions that had goto out/error when no common cleanup
    was done, to just have multiple return points.
  * Replaced error cleanup boolean flags with multiple exit points.
  * REmoved __must_chewck from dprc_scan_*() functions

Changes in v2:
- Addressed comments from Kim Phillips:
  * Fix warning in drivers/bus/fsl-mc/fsl_mc_dprc.c:173
  * Fixed linker errors when MC bus driver built as module

 drivers/bus/fsl-mc/Makefile      |   3 +-
 drivers/bus/fsl-mc/dprc-driver.c | 383 +++++++++++++++++++++++++++++++++++++++
 drivers/bus/fsl-mc/mc-bus.c      |   8 +
 include/linux/fsl/mc-private.h   |  10 +
 4 files changed, 403 insertions(+), 1 deletion(-)
 create mode 100644 drivers/bus/fsl-mc/dprc-driver.c

diff --git a/drivers/bus/fsl-mc/Makefile b/drivers/bus/fsl-mc/Makefile
index decd339..424e58e 100644
--- a/drivers/bus/fsl-mc/Makefile
+++ b/drivers/bus/fsl-mc/Makefile
@@ -10,5 +10,6 @@ obj-$(CONFIG_FSL_MC_BUS) += mc-bus-driver.o
 mc-bus-driver-objs := mc-bus.o \
 		      mc-sys.o \
 		      dprc.o \
-		      dpmng.o
+		      dpmng.o \
+		      dprc-driver.o

diff --git a/drivers/bus/fsl-mc/dprc-driver.c b/drivers/bus/fsl-mc/dprc-driver.c
new file mode 100644
index 0000000..e1fa031
--- /dev/null
+++ b/drivers/bus/fsl-mc/dprc-driver.c
@@ -0,0 +1,383 @@
+/*
+ * Freescale data path resource container (DPRC) driver
+ *
+ * Copyright (C) 2014 Freescale Semiconductor, Inc.
+ * Author: German Rivera <German.Rivera@freescale.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/fsl/mc-private.h>
+#include <linux/fsl/mc-sys.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include "dprc-cmd.h"
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
+	dev = device_find_child(&mc_bus_dev->dev, obj_desc,
+				__fsl_mc_device_match);
+
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
+					"Invalid MC portal size: %u\n",
+					region_desc.size);
+				continue;
+			}
+
+			error = fsl_create_mc_io(&mc_bus_dev->dev,
+						 region_desc.base_paddr,
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
+	int error;
+	struct dprc_obj_desc *child_obj_desc_array = NULL;
+
+	error = dprc_get_obj_count(mc_bus_dev->mc_io,
+				   mc_bus_dev->mc_handle,
+				   &num_child_objects);
+	if (error < 0) {
+		dev_err(&mc_bus_dev->dev, "dprc_get_obj_count() failed: %d\n",
+			error);
+		return error;
+	}
+
+	if (num_child_objects != 0) {
+		int i;
+
+		child_obj_desc_array =
+		    devm_kmalloc_array(&mc_bus_dev->dev, num_child_objects,
+				       sizeof(*child_obj_desc_array),
+				       GFP_KERNEL);
+		if (child_obj_desc_array == NULL)
+			return -ENOMEM;
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
+	if (child_obj_desc_array != NULL)
+		devm_kfree(&mc_bus_dev->dev, child_obj_desc_array);
+
+	return 0;
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
+	return dprc_scan_objects(mc_bus_dev);
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
+	int error;
+
+	if (WARN_ON(strcmp(mc_dev->obj_desc.type, "dprc") != 0))
+		return -EINVAL;
+
+	error = dprc_open(mc_dev->mc_io, mc_dev->obj_desc.id,
+			  &mc_dev->mc_handle);
+	if (error < 0) {
+		dev_err(&mc_dev->dev, "dprc_open() failed: %d\n", error);
+		return error;
+	}
+
+	error = dprc_scan_container(mc_dev);
+	if (error < 0)
+		goto error_cleanup_open;
+
+	dev_info(&mc_dev->dev, "DPRC device bound to driver");
+	return 0;
+
+error_cleanup_open:
+	(void)dprc_close(mc_dev->mc_io, mc_dev->mc_handle);
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
+	int error;
+
+	if (WARN_ON(strcmp(mc_dev->obj_desc.type, "dprc") != 0))
+		return -EINVAL;
+	if (WARN_ON(mc_dev->mc_io == NULL))
+		return -EINVAL;
+
+	device_for_each_child(&mc_dev->dev, NULL, __fsl_mc_device_remove);
+	error = dprc_close(mc_dev->mc_io, mc_dev->mc_handle);
+	if (error < 0)
+		dev_err(&mc_dev->dev, "dprc_close() failed: %d\n", error);
+
+	dev_info(&mc_dev->dev, "DPRC device unbound from driver");
+	return 0;
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
+int __init dprc_driver_init(void)
+{
+	return fsl_mc_driver_register(&dprc_driver);
+}
+
+void __exit dprc_driver_exit(void)
+{
+	fsl_mc_driver_unregister(&dprc_driver);
+}
diff --git a/drivers/bus/fsl-mc/mc-bus.c b/drivers/bus/fsl-mc/mc-bus.c
index 3db8a73..afbe4f5 100644
--- a/drivers/bus/fsl-mc/mc-bus.c
+++ b/drivers/bus/fsl-mc/mc-bus.c
@@ -558,8 +558,15 @@ static int __init fsl_mc_bus_driver_init(void)
 		goto error_cleanup_bus;
 	}

+	error = dprc_driver_init();
+	if (error < 0)
+		goto error_cleanup_driver;
+
 	return 0;

+error_cleanup_driver:
+	platform_driver_unregister(&fsl_mc_bus_driver);
+
 error_cleanup_bus:
 	bus_unregister(&fsl_mc_bus_type);

@@ -575,6 +582,7 @@ static void __exit fsl_mc_bus_driver_exit(void)
 	if (WARN_ON(mc_dev_cache == NULL))
 		return;

+	dprc_driver_exit();
 	platform_driver_unregister(&fsl_mc_bus_driver);
 	bus_unregister(&fsl_mc_bus_type);
 	kmem_cache_destroy(mc_dev_cache);
diff --git a/include/linux/fsl/mc-private.h b/include/linux/fsl/mc-private.h
index 604832a..431a0b1 100644
--- a/include/linux/fsl/mc-private.h
+++ b/include/linux/fsl/mc-private.h
@@ -15,6 +15,8 @@
 #include <linux/mutex.h>
 #include <linux/stringify.h>

+#define FSL_MC_DPRC_DRIVER_NAME    "fsl_mc_dprc"
+
 #define FSL_MC_DEVICE_MATCH(_mc_dev, _obj_desc) \
 	(strcmp((_mc_dev)->obj_desc.type, (_obj_desc)->type) == 0 && \
 	 (_mc_dev)->obj_desc.id == (_obj_desc)->id)
@@ -30,4 +32,12 @@ int __must_check fsl_mc_device_add(struct dprc_obj_desc *obj_desc,

 void fsl_mc_device_remove(struct fsl_mc_device *mc_dev);

+int dprc_scan_container(struct fsl_mc_device *mc_bus_dev);
+
+int dprc_scan_objects(struct fsl_mc_device *mc_bus_dev);
+
+int __init dprc_driver_init(void);
+
+void __exit dprc_driver_exit(void);
+
 #endif /* _FSL_MC_PRIVATE_H_ */
--
2.2.0

