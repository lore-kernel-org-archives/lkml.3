Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbaISWuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 18:50:20 -0400
Received: from mail-bn1on0137.outbound.protection.outlook.com ([157.56.110.137]:27616
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758132AbaISWtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 18:49:53 -0400
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>,
        <linuxppc-release@linux.freescale.net>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [PATCH 3/3 v2] drivers/bus: Device driver for FSL-MC DPRC devices
Date: Fri, 19 Sep 2014 17:49:41 -0500
Message-ID: <1411166981-3610-4-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>
References: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(92726001)(92566001)(106466001)(90102001)(102836001)(229853001)(107046002)(2201001)(64706001)(20776003)(50466002)(26826002)(86362001)(104016003)(93916002)(76176999)(62966002)(4396001)(50226001)(81156004)(36756003)(76482002)(21056001)(104166001)(105606002)(89996001)(95666004)(97736003)(88136002)(79102003)(74662003)(80022003)(74502003)(50986999)(77982003)(46102003)(99396002)(81342003)(81542003)(77156001)(31966008)(68736004)(19580405001)(19580395003)(69596002)(47776003)(87936001)(48376002)(83072002)(85852003)(6806004)(84676001)(87286001)(44976005)(83322001)(85306004);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB321;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB321;
X-Forefront-PRVS: 0339F89554
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
Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
---
Changes in v2:
- Addressed comments from Kim Phillips:
  * Fix warning in drivers/bus/fsl-mc/fsl_mc_dprc.c:173
  * Fixed linker errors when MC bus driver built as module

 drivers/bus/fsl-mc/Makefile      |   11 +-
 drivers/bus/fsl-mc/fsl_mc_bus.c  |   10 +
 drivers/bus/fsl-mc/fsl_mc_dprc.c |  402 ++++++++++++++++++++++++++++++++++++++
 include/linux/fsl_mc_private.h   |   10 +
 4 files changed, 428 insertions(+), 5 deletions(-)
 create mode 100644 drivers/bus/fsl-mc/fsl_mc_dprc.c

diff --git a/drivers/bus/fsl-mc/Makefile b/drivers/bus/fsl-mc/Makefile
index 2981d70..8ee3284 100644
--- a/drivers/bus/fsl-mc/Makefile
+++ b/drivers/bus/fsl-mc/Makefile
@@ -5,10 +5,11 @@
 #
 # This file is released under the GPLv2
 #
-obj-$(CONFIG_FSL_MC_BUS) += fsl_mc_bus_driver.o
+obj-$(CONFIG_FSL_MC_BUS) += fsl_mc_bus_driver.o \

-fsl_mc_bus_driver-objs := fsl_mc_bus.o \
-			      fsl_mc_sys.o \
-			      dprc.o \
-			      dpmng.o
+fsl_mc_bus_driver-objs :=	fsl_mc_bus.o \
+				fsl_mc_sys.o \
+				dprc.o \
+				dpmng.o \
+				fsl_mc_dprc.o

diff --git a/drivers/bus/fsl-mc/fsl_mc_bus.c b/drivers/bus/fsl-mc/fsl_mc_bus.c
index e3a994f..afe16cd 100644
--- a/drivers/bus/fsl-mc/fsl_mc_bus.c
+++ b/drivers/bus/fsl-mc/fsl_mc_bus.c
@@ -539,6 +539,7 @@ static int __init fsl_mc_bus_driver_init(void)
 {
 	int error = -EINVAL;
 	bool bus_registered = false;
+	bool platform_driver_registered = false;

 	mc_dev_cache = kmem_cache_create("fsl_mc_device",
 					 sizeof(struct fsl_mc_device), 0, 0,
@@ -564,8 +565,16 @@ static int __init fsl_mc_bus_driver_init(void)
 		goto error;
 	}

+	platform_driver_registered = true;
+	error = dprc_driver_init();
+	if (error < 0)
+		goto error;
+
 	return 0;
 error:
+	if (platform_driver_registered)
+		platform_driver_unregister(&fsl_mc_bus_driver);
+
 	if (bus_registered)
 		bus_unregister(&fsl_mc_bus_type);

@@ -582,6 +591,7 @@ static void __exit fsl_mc_bus_driver_exit(void)
 	if (WARN_ON(mc_dev_cache == NULL))
 		return;

+	dprc_driver_exit();
 	platform_driver_unregister(&fsl_mc_bus_driver);
 	bus_unregister(&fsl_mc_bus_type);
 	kmem_cache_destroy(mc_dev_cache);
diff --git a/drivers/bus/fsl-mc/fsl_mc_dprc.c b/drivers/bus/fsl-mc/fsl_mc_dprc.c
new file mode 100644
index 0000000..bf96de0
--- /dev/null
+++ b/drivers/bus/fsl-mc/fsl_mc_dprc.c
@@ -0,0 +1,402 @@
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
+		    devm_kmalloc_array(&mc_bus_dev->dev, num_child_objects,
+				       sizeof(*child_obj_desc_array),
+				       GFP_KERNEL);
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
+		devm_kfree(&mc_bus_dev->dev, child_obj_desc_array);
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
+	device_for_each_child(&mc_dev->dev, NULL, __fsl_mc_device_remove);
+	error = dprc_close(mc_dev->mc_io, mc_dev->mc_handle);
+	if (error < 0)
+		dev_err(&mc_dev->dev, "dprc_close() failed: %d\n", error);
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
+int __init dprc_driver_init(void)
+{
+	return fsl_mc_driver_register(&dprc_driver);
+}
+
+void __exit dprc_driver_exit(void)
+{
+	fsl_mc_driver_unregister(&dprc_driver);
+}
diff --git a/include/linux/fsl_mc_private.h b/include/linux/fsl_mc_private.h
index 3ff3f2b..52721f7 100644
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
@@ -30,4 +32,12 @@ int __must_check fsl_mc_device_add(struct dprc_obj_desc *obj_desc,

 void fsl_mc_device_remove(struct fsl_mc_device *mc_dev);

+int __must_check dprc_scan_container(struct fsl_mc_device *mc_bus_dev);
+
+int __must_check dprc_scan_objects(struct fsl_mc_device *mc_bus_dev);
+
+int __init dprc_driver_init(void);
+
+void __exit dprc_driver_exit(void);
+
 #endif /* _FSL_MC_PRIVATE_H_ */
--
1.7.9.7

