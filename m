Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbaJUIXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:23:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:37658 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbaJUIXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:23:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,760,1406617200"; 
   d="scan'208";a="592957408"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: fix multiple race conditions in tpm_ppi.c
Date: Tue, 21 Oct 2014 11:22:41 +0300
Message-Id: <1413879761-25392-1-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Traversal of the ACPI device tree was not done right. It should lookup
  PPI only under the ACPI device that it is associated. Otherwise, it could
  match to a wrong PPI interface if there are two TPM devices in the device
  tree.
* Removed global ACPI handle and version string from tpm_ppi.c as this
  is racy. Instead they should be associated with the chip.
* Moved code just a tiny bit towards two-phase allocation to implement
  fix for the PPI race conditions.
* Added missing copyright platter in tpm_ppi.c.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c |  31 +++++----
 drivers/char/tpm/tpm.h           |  21 ++++--
 drivers/char/tpm/tpm_ppi.c       | 134 ++++++++++++++++++++++++---------------
 drivers/char/tpm/tpm_tis.c       |  25 ++++++--
 4 files changed, 136 insertions(+), 75 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 6af1700..98d0baa 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -900,7 +900,7 @@ void tpm_remove_hardware(struct device *dev)
 
 	tpm_dev_del_device(chip);
 	tpm_sysfs_del_device(chip);
-	tpm_remove_ppi(&dev->kobj);
+	tpm_remove_ppi(chip, &dev->kobj);
 	tpm_bios_log_teardown(chip->bios_dir);
 
 	/* write it this way to be explicit (chip->dev == dev) */
@@ -1077,17 +1077,9 @@ static void tpm_dev_release(struct device *dev)
  * upon errant exit from this function specific probe function should call
  * pci_disable_device
  */
-struct tpm_chip *tpm_register_hardware(struct device *dev,
-				       const struct tpm_class_ops *ops)
+struct tpm_chip *tpm_chip_register(struct tpm_chip *chip, struct device *dev,
+				   const struct tpm_class_ops *ops)
 {
-	struct tpm_chip *chip;
-
-	/* Driver specific per-device data */
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
-
-	if (chip == NULL)
-		return NULL;
-
 	mutex_init(&chip->tpm_mutex);
 	INIT_LIST_HEAD(&chip->list);
 
@@ -1115,7 +1107,7 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 	if (tpm_sysfs_add_device(chip))
 		goto del_misc;
 
-	if (tpm_add_ppi(&dev->kobj))
+	if (tpm_add_ppi(chip, &dev->kobj))
 		goto del_sysfs;
 
 	chip->bios_dir = tpm_bios_log_setup(chip->devname);
@@ -1137,6 +1129,21 @@ out_free:
 	kfree(chip);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(tpm_chip_register);
+
+struct tpm_chip *tpm_register_hardware(struct device *dev,
+				       const struct tpm_class_ops *ops)
+{
+	struct tpm_chip *chip;
+
+	/* Driver specific per-device data */
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+
+	if (chip == NULL)
+		return NULL;
+
+	return tpm_chip_register(chip, dev, ops);
+}
 EXPORT_SYMBOL_GPL(tpm_register_hardware);
 
 MODULE_AUTHOR("Leendert van Doorn (leendert@watson.ibm.com)");
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index e4d0888..ef0ae84 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -27,6 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/tpm.h>
+#include <linux/acpi.h>
 
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
@@ -94,6 +95,8 @@ struct tpm_vendor_specific {
 #define TPM_VID_WINBOND  0x1050
 #define TPM_VID_STM      0x104A
 
+#define TPM_PPI_VERSION_LEN		3
+
 struct tpm_chip {
 	struct device *dev;	/* Device stuff */
 	const struct tpm_class_ops *ops;
@@ -109,6 +112,11 @@ struct tpm_chip {
 
 	struct dentry **bios_dir;
 
+#ifdef CONFIG_ACPI
+	acpi_handle acpi_dev_handle;
+	char ppi_version[TPM_PPI_VERSION_LEN + 1];
+#endif /* CONFIG_ACPI */
+
 	struct list_head list;
 	void (*release) (struct device *);
 };
@@ -321,7 +329,10 @@ extern int tpm_get_timeouts(struct tpm_chip *);
 extern void tpm_gen_interrupt(struct tpm_chip *);
 extern int tpm_do_selftest(struct tpm_chip *);
 extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
-extern struct tpm_chip* tpm_register_hardware(struct device *,
+extern struct tpm_chip *tpm_chip_register(struct tpm_chip *chip,
+					  struct device *dev,
+					  const struct tpm_class_ops *ops);
+extern struct tpm_chip *tpm_register_hardware(struct device *,
 					      const struct tpm_class_ops *ops);
 extern void tpm_dev_vendor_release(struct tpm_chip *);
 extern void tpm_remove_hardware(struct device *);
@@ -338,15 +349,15 @@ void tpm_sysfs_del_device(struct tpm_chip *chip);
 int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 
 #ifdef CONFIG_ACPI
-extern int tpm_add_ppi(struct kobject *);
-extern void tpm_remove_ppi(struct kobject *);
+extern int tpm_add_ppi(struct tpm_chip *chip, struct kobject *parent);
+extern void tpm_remove_ppi(struct tpm_chip *chip, struct kobject *parent);
 #else
-static inline int tpm_add_ppi(struct kobject *parent)
+static inline int tpm_add_ppi(struct tpm_chip *chip, struct kobject *parent)
 {
 	return 0;
 }
 
-static inline void tpm_remove_ppi(struct kobject *parent)
+static inline void tpm_remove_ppi(struct tpm_chip *chip, struct kobject *parent)
 {
 }
 #endif
diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 61dcc80..36b5b69 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -1,3 +1,22 @@
+/*
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * Authors:
+ * Xiaoyan Zhang <xiaoyan.zhang@intel.com>
+ * Jiang Liu <jiang.liu@linux.intel.com>
+ * Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * This file contains implementation of the sysfs interface for PPI.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+
 #include <linux/acpi.h>
 #include "tpm.h"
 
@@ -22,45 +41,22 @@ static const u8 tpm_ppi_uuid[] = {
 	0x8D, 0x10, 0x08, 0x9D, 0x16, 0x53
 };
 
-static char tpm_ppi_version[PPI_VERSION_LEN + 1];
-static acpi_handle tpm_ppi_handle;
-
-static acpi_status ppi_callback(acpi_handle handle, u32 level, void *context,
-				void **return_value)
-{
-	union acpi_object *obj;
-
-	if (!acpi_check_dsm(handle, tpm_ppi_uuid, TPM_PPI_REVISION_ID,
-			    1 << TPM_PPI_FN_VERSION))
-		return AE_OK;
-
-	/* Cache version string */
-	obj = acpi_evaluate_dsm_typed(handle, tpm_ppi_uuid,
-				      TPM_PPI_REVISION_ID, TPM_PPI_FN_VERSION,
-				      NULL, ACPI_TYPE_STRING);
-	if (obj) {
-		strlcpy(tpm_ppi_version, obj->string.pointer,
-			PPI_VERSION_LEN + 1);
-		ACPI_FREE(obj);
-	}
-
-	*return_value = handle;
-
-	return AE_CTRL_TERMINATE;
-}
-
 static inline union acpi_object *
-tpm_eval_dsm(int func, acpi_object_type type, union acpi_object *argv4)
+tpm_eval_dsm(acpi_handle dev_handle, int func, acpi_object_type type,
+	     union acpi_object *argv4)
 {
-	BUG_ON(!tpm_ppi_handle);
-	return acpi_evaluate_dsm_typed(tpm_ppi_handle, tpm_ppi_uuid,
-				       TPM_PPI_REVISION_ID, func, argv4, type);
+	BUG_ON(!dev_handle);
+	return acpi_evaluate_dsm_typed(dev_handle, tpm_ppi_uuid,
+				       TPM_PPI_REVISION_ID,
+				       func, argv4, type);
 }
 
 static ssize_t tpm_show_ppi_version(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%s\n", tpm_ppi_version);
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n", chip->ppi_version);
 }
 
 static ssize_t tpm_show_ppi_request(struct device *dev,
@@ -68,8 +64,10 @@ static ssize_t tpm_show_ppi_request(struct device *dev,
 {
 	ssize_t size = -EINVAL;
 	union acpi_object *obj;
+	struct tpm_chip *chip = dev_get_drvdata(dev);
 
-	obj = tpm_eval_dsm(TPM_PPI_FN_GETREQ, ACPI_TYPE_PACKAGE, NULL);
+	obj = tpm_eval_dsm(chip->acpi_dev_handle, TPM_PPI_FN_GETREQ,
+			   ACPI_TYPE_PACKAGE, NULL);
 	if (!obj)
 		return -ENXIO;
 
@@ -103,14 +101,15 @@ static ssize_t tpm_store_ppi_request(struct device *dev,
 	int func = TPM_PPI_FN_SUBREQ;
 	union acpi_object *obj, tmp;
 	union acpi_object argv4 = ACPI_INIT_DSM_ARGV4(1, &tmp);
+	struct tpm_chip *chip = dev_get_drvdata(dev);
 
 	/*
 	 * the function to submit TPM operation request to pre-os environment
 	 * is updated with function index from SUBREQ to SUBREQ2 since PPI
 	 * version 1.1
 	 */
-	if (acpi_check_dsm(tpm_ppi_handle, tpm_ppi_uuid, TPM_PPI_REVISION_ID,
-			   1 << TPM_PPI_FN_SUBREQ2))
+	if (acpi_check_dsm(chip->acpi_dev_handle, tpm_ppi_uuid,
+			   TPM_PPI_REVISION_ID, 1 << TPM_PPI_FN_SUBREQ2))
 		func = TPM_PPI_FN_SUBREQ2;
 
 	/*
@@ -119,7 +118,7 @@ static ssize_t tpm_store_ppi_request(struct device *dev,
 	 * string/package type. For PPI version 1.0 and 1.1, use buffer type
 	 * for compatibility, and use package type since 1.2 according to spec.
 	 */
-	if (strcmp(tpm_ppi_version, "1.2") < 0) {
+	if (strcmp(chip->ppi_version, "1.2") < 0) {
 		if (sscanf(buf, "%d", &req) != 1)
 			return -EINVAL;
 		argv4.type = ACPI_TYPE_BUFFER;
@@ -131,7 +130,8 @@ static ssize_t tpm_store_ppi_request(struct device *dev,
 			return -EINVAL;
 	}
 
-	obj = tpm_eval_dsm(func, ACPI_TYPE_INTEGER, &argv4);
+	obj = tpm_eval_dsm(chip->acpi_dev_handle, func, ACPI_TYPE_INTEGER,
+			   &argv4);
 	if (!obj) {
 		return -ENXIO;
 	} else {
@@ -157,6 +157,7 @@ static ssize_t tpm_show_ppi_transition_action(struct device *dev,
 		.buffer.length = 0,
 		.buffer.pointer = NULL
 	};
+	struct tpm_chip *chip = dev_get_drvdata(dev);
 
 	static char *info[] = {
 		"None",
@@ -171,9 +172,10 @@ static ssize_t tpm_show_ppi_transition_action(struct device *dev,
 	 * (e.g. Capella with PPI 1.0) need integer/string/buffer type, so for
 	 * compatibility, define params[3].type as buffer, if PPI version < 1.2
 	 */
-	if (strcmp(tpm_ppi_version, "1.2") < 0)
+	if (strcmp(chip->ppi_version, "1.2") < 0)
 		obj = &tmp;
-	obj = tpm_eval_dsm(TPM_PPI_FN_GETACT, ACPI_TYPE_INTEGER, obj);
+	obj = tpm_eval_dsm(chip->acpi_dev_handle, TPM_PPI_FN_GETACT,
+			   ACPI_TYPE_INTEGER, obj);
 	if (!obj) {
 		return -ENXIO;
 	} else {
@@ -196,8 +198,10 @@ static ssize_t tpm_show_ppi_response(struct device *dev,
 	acpi_status status = -EINVAL;
 	union acpi_object *obj, *ret_obj;
 	u64 req, res;
+	struct tpm_chip *chip = dev_get_drvdata(dev);
 
-	obj = tpm_eval_dsm(TPM_PPI_FN_GETRSP, ACPI_TYPE_PACKAGE, NULL);
+	obj = tpm_eval_dsm(chip->acpi_dev_handle, TPM_PPI_FN_GETRSP,
+			   ACPI_TYPE_PACKAGE, NULL);
 	if (!obj)
 		return -ENXIO;
 
@@ -248,7 +252,8 @@ cleanup:
 	return status;
 }
 
-static ssize_t show_ppi_operations(char *buf, u32 start, u32 end)
+static ssize_t show_ppi_operations(acpi_handle dev_handle, char *buf, u32 start,
+				   u32 end)
 {
 	int i;
 	u32 ret;
@@ -264,14 +269,15 @@ static ssize_t show_ppi_operations(char *buf, u32 start, u32 end)
 		"User not required",
 	};
 
-	if (!acpi_check_dsm(tpm_ppi_handle, tpm_ppi_uuid, TPM_PPI_REVISION_ID,
+	if (!acpi_check_dsm(dev_handle, tpm_ppi_uuid, TPM_PPI_REVISION_ID,
 			    1 << TPM_PPI_FN_GETOPR))
 		return -EPERM;
 
 	tmp.integer.type = ACPI_TYPE_INTEGER;
 	for (i = start; i <= end; i++) {
 		tmp.integer.value = i;
-		obj = tpm_eval_dsm(TPM_PPI_FN_GETOPR, ACPI_TYPE_INTEGER, &argv);
+		obj = tpm_eval_dsm(dev_handle, TPM_PPI_FN_GETOPR,
+				   ACPI_TYPE_INTEGER, &argv);
 		if (!obj) {
 			return -ENOMEM;
 		} else {
@@ -291,14 +297,20 @@ static ssize_t tpm_show_ppi_tcg_operations(struct device *dev,
 					   struct device_attribute *attr,
 					   char *buf)
 {
-	return show_ppi_operations(buf, 0, PPI_TPM_REQ_MAX);
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	return show_ppi_operations(chip->acpi_dev_handle, buf, 0,
+				   PPI_TPM_REQ_MAX);
 }
 
 static ssize_t tpm_show_ppi_vs_operations(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf)
 {
-	return show_ppi_operations(buf, PPI_VS_REQ_START, PPI_VS_REQ_END);
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	return show_ppi_operations(chip->acpi_dev_handle, buf, PPI_VS_REQ_START,
+				   PPI_VS_REQ_END);
 }
 
 static DEVICE_ATTR(version, S_IRUGO, tpm_show_ppi_version, NULL);
@@ -323,16 +335,34 @@ static struct attribute_group ppi_attr_grp = {
 	.attrs = ppi_attrs
 };
 
-int tpm_add_ppi(struct kobject *parent)
+int tpm_add_ppi(struct tpm_chip *chip, struct kobject *parent)
 {
-	/* Cache TPM ACPI handle and version string */
-	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT, ACPI_UINT32_MAX,
-			    ppi_callback, NULL, NULL, &tpm_ppi_handle);
-	return tpm_ppi_handle ? sysfs_create_group(parent, &ppi_attr_grp) : 0;
+	union acpi_object *obj;
+
+	if (!chip->acpi_dev_handle)
+		return 0;
+
+	if (!acpi_check_dsm(chip->acpi_dev_handle, tpm_ppi_uuid,
+			    TPM_PPI_REVISION_ID, 1 << TPM_PPI_FN_VERSION))
+		return 0;
+
+	/* Cache PPI version string. */
+	obj = acpi_evaluate_dsm_typed(chip->acpi_dev_handle, tpm_ppi_uuid,
+				      TPM_PPI_REVISION_ID, TPM_PPI_FN_VERSION,
+				      NULL, ACPI_TYPE_STRING);
+	if (obj) {
+		strlcpy(chip->ppi_version, obj->string.pointer,
+			PPI_VERSION_LEN + 1);
+		ACPI_FREE(obj);
+	} else
+		return -ENOMEM;
+
+	return chip->acpi_dev_handle ?
+		sysfs_create_group(parent, &ppi_attr_grp) : 0;
 }
 
-void tpm_remove_ppi(struct kobject *parent)
+void tpm_remove_ppi(struct tpm_chip *chip, struct kobject *parent)
 {
-	if (tpm_ppi_handle)
+	if (chip->ppi_version[0] != '\0')
 		sysfs_remove_group(parent, &ppi_attr_grp);
 }
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 2c46734..8446e14 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -528,15 +528,17 @@ static bool interrupts = true;
 module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
-static int tpm_tis_init(struct device *dev, resource_size_t start,
-			resource_size_t len, unsigned int irq)
+static int tpm_tis_init(struct device *dev, struct tpm_chip *chip,
+			resource_size_t start, resource_size_t len,
+			unsigned int irq)
 {
 	u32 vendor, intfcaps, intmask;
 	int rc, i, irq_s, irq_e, probe;
-	struct tpm_chip *chip;
 
-	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
+	if (!tpm_chip_register(chip, dev, &tpm_tis)) {
+		kfree(chip);
 		return -ENODEV;
+	}
 
 	chip->vendor.iobase = ioremap(start, len);
 	if (!chip->vendor.iobase) {
@@ -777,6 +779,7 @@ static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
 static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 				      const struct pnp_device_id *pnp_id)
 {
+	struct tpm_chip *chip;
 	resource_size_t start, len;
 	unsigned int irq = 0;
 
@@ -791,7 +794,13 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 	if (is_itpm(pnp_dev))
 		itpm = true;
 
-	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (chip == NULL)
+		return NULL;
+	if (pnp_acpi_device(pnp_dev))
+		chip->acpi_dev_handle = pnp_acpi_device(pnp_dev)->handle;
+
+	return tpm_tis_init(&pnp_dev->dev, chip, start, len, irq);
 }
 
 static struct pnp_device_id tpm_pnp_tbl[] = {
@@ -849,6 +858,7 @@ module_param(force, bool, 0444);
 MODULE_PARM_DESC(force, "Force device probe rather than using ACPI entry");
 static int __init init_tis(void)
 {
+	struct tpm_chip *chip;
 	int rc;
 #ifdef CONFIG_PNP
 	if (!force)
@@ -863,7 +873,10 @@ static int __init init_tis(void)
 		rc = PTR_ERR(pdev);
 		goto err_dev;
 	}
-	rc = tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0);
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (chip == NULL)
+		goto err_init;
+	rc = tpm_tis_init(&pdev->dev, chip, TIS_MEM_BASE, TIS_MEM_LEN, 0);
 	if (rc)
 		goto err_init;
 	return 0;
-- 
2.1.0

