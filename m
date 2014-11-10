Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaKJMvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:51:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:30336 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbaKJMvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:51:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,352,1413270000"; 
   d="scan'208";a="634417624"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v6 10/10] tpm: TPM 2.0 sysfs attributes
Date: Mon, 10 Nov 2014 14:49:54 +0200
Message-Id: <1415623794-6090-11-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415623794-6090-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1415623794-6090-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manadatory sysfs attributes for TPM 2.0 devices so that it is easy
to check whether storage hierarchies are enabled.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 Documentation/ABI/stable/sysfs-class-tpm2 |  57 +++++++++++
 drivers/char/tpm/Makefile                 |   2 +-
 drivers/char/tpm/tpm-chip.c               |  15 ++-
 drivers/char/tpm/tpm-dev.c                |   6 +-
 drivers/char/tpm/tpm.h                    |  19 ++++
 drivers/char/tpm/tpm2-sysfs.c             | 152 ++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_crb.c                |  20 ++--
 7 files changed, 248 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-class-tpm2
 create mode 100644 drivers/char/tpm/tpm2-sysfs.c

diff --git a/Documentation/ABI/stable/sysfs-class-tpm2 b/Documentation/ABI/stable/sysfs-class-tpm2
new file mode 100644
index 0000000..301ab2e
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-class-tpm2
@@ -0,0 +1,57 @@
+What:		/sys/class/misc/tpmX/device/
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The device/ directory under a specific TPM instance exposes
+		the properties of that TPM chip.
+
+What:		/sys/class/misc/tpmX/device/family
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The protocol family in the major.minor format.
+
+What:		/sys/class/misc/tpmX/device/sh_enabled
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The "sh_enabled" property prints a '1' if the Storage Hierarchy
+		is enabled, i.e. if PM_PT_STARTUP_CLEAR.shEnable is set.
+
+What:		/sys/class/misc/tpmX/device/sh_owned
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The "sh_owned" property prints a '1' if the ownership of the
+		Storage Hierarchy has been taken, i.e. if
+		TPM_PT_PERMANENT.ownerAuthSet is set.
+
+What:		/sys/class/misc/tpmX/device/eh_enabled
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The "eh_enabled" property prints a '1' if the Endorsement
+		Hierarchy is enabled, i.e if PM_PT_STARTUP_CLEAR.ehEnable is
+		set.
+
+What:		/sys/class/misc/tpmX/device/eh_owned
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The "eh_owned" property prints a '1' if the ownership of the
+		Endrosoment Hierarchy has been taken, i.e if
+		TPM_PT_PERMANENT.endorsementAuthSet is set.
+
+What:		/sys/class/misc/tpmX/device/manufacturer
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The "manufacturer" property prints the vendor ID of the TPM
+		manufacturer.
+
+What:		/sys/class/misc/tpmX/device/firmware
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The property prints the vendor-specific value indicating the
+		version of the firmware.
diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index e6d26dd..15e3b4c 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel tpm device drivers.
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
-tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o
+tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o tpm2-sysfs.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o
 
 ifdef CONFIG_ACPI
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 811e431..b334252 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -144,14 +144,12 @@ int tpm_chip_register(struct tpm_chip *chip)
 	if (rc)
 		return rc;
 
-	/* Populate sysfs for TPM1 devices. */
-	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
-		rc = tpm_add_ppi(chip);
-		if (rc)
-			goto out_err;
+	rc = tpm_add_ppi(chip);
+	if (rc)
+		goto out_err;
 
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
 		chip->bios_dir = tpm_bios_log_setup(chip->devname);
-	}
 
 	/* Make the chip available. */
 	spin_lock(&driver_lock);
@@ -182,8 +180,9 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 	spin_unlock(&driver_lock);
 	synchronize_rcu();
 
-	/* Clean up sysfs for TPM1 devices. */
-	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		tpm_remove_ppi(chip);
+	} else {
 		if (chip->bios_dir)
 			tpm_bios_log_teardown(chip->bios_dir);
 		tpm_remove_ppi(chip);
diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index 42b61776..d567ec6 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -23,6 +23,7 @@
 #include "tpm.h"
 
 ATTRIBUTE_GROUPS(tpm_dev);
+ATTRIBUTE_GROUPS(tpm2_dev);
 
 struct file_priv {
 	struct tpm_chip *chip;
@@ -201,7 +202,10 @@ int tpm_dev_add_device(struct tpm_chip *chip)
 	else
 		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
 
-	chip->dev.groups = tpm_dev_groups;
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		chip->dev.groups = tpm2_dev_groups;
+	else
+		chip->dev.groups = tpm_dev_groups;
 
 	dev_set_name(&chip->dev, chip->devname);
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index feadbff..fc37f88 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -108,6 +108,24 @@ enum tpm2_capabilities {
 	TPM2_CAP_TPM_PROPERTIES = 6,
 };
 
+enum tpm2_tpm_properties {
+	TPM2_PT_MANUFACTURER		= 0x00000105,
+	TPM2_PT_FIRMWARE_VERSION_1	= 0x0000010C,
+	TPM2_PT_FIRMWARE_VERSION_2	= 0x0000010D,
+	TPM2_PT_PERMANENT		= 0x00000200,
+	TPM2_PT_STARTUP_CLEAR		= 0x00000201,
+};
+
+enum tpm2_pt_startup_clear {
+	TPM2_PT_SC_SH_ENABLE	= BIT(1),
+	TPM2_PT_SC_EH_ENABLE	= BIT(2),
+};
+
+enum tpm2_pt_permanent {
+	TPM2_PT_PM_OWNER_AUTH_SET	= BIT(0),
+	TPM2_PT_PM_ENDORSEMENT_AUTH_SET	= BIT(1),
+};
+
 enum tpm2_startup_types {
 	TPM2_SU_CLEAR	= 0x0000,
 	TPM2_SU_STATE	= 0x0001,
@@ -381,6 +399,7 @@ struct tpm_cmd_t {
 extern struct class *tpm_class;
 extern dev_t tpm_devt;
 extern struct attribute *tpm_dev_attrs[];
+extern struct attribute *tpm2_dev_attrs[];
 
 ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
 ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
diff --git a/drivers/char/tpm/tpm2-sysfs.c b/drivers/char/tpm/tpm2-sysfs.c
new file mode 100644
index 0000000..9e5e2e3
--- /dev/null
+++ b/drivers/char/tpm/tpm2-sysfs.c
@@ -0,0 +1,152 @@
+/*
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * Authors:
+ * Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+ *
+ * TPM2 sysfs attributes
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ */
+#include <linux/device.h>
+#include <linux/slab.h>
+#include "tpm.h"
+
+static ssize_t sh_enabled_show(struct device *dev, struct device_attribute *attr,
+		     char *buf)
+{
+	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
+	u32 value;
+	ssize_t rc;
+
+	rc = tpm2_get_tpm_pt(chip, TPM2_PT_STARTUP_CLEAR, &value,
+			     "could not retrieve STARTUP_CLEAR property");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", (value & TPM2_PT_SC_SH_ENABLE) > 0);
+	return rc;
+}
+static DEVICE_ATTR_RO(sh_enabled);
+
+static ssize_t sh_owned_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
+	u32 value;
+	ssize_t rc;
+
+	rc = tpm2_get_tpm_pt(chip, TPM2_PT_PERMANENT, &value,
+			     "could not retrieve PERMANENT property");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", (value & TPM2_PT_PM_OWNER_AUTH_SET) > 0);
+	return rc;
+}
+static DEVICE_ATTR_RO(sh_owned);
+
+static ssize_t eh_enabled_show(struct device *dev, struct device_attribute *attr,
+		     char *buf)
+{
+	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
+	u32 value;
+	ssize_t rc;
+
+	rc = tpm2_get_tpm_pt(chip, TPM2_PT_STARTUP_CLEAR, &value,
+			     "could not retrieve STARTUP_CLEAR property");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", (value & TPM2_PT_SC_EH_ENABLE) > 0);
+	return rc;
+}
+static DEVICE_ATTR_RO(eh_enabled);
+
+static ssize_t eh_owned_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
+	u32 value;
+	ssize_t rc;
+
+	rc = tpm2_get_tpm_pt(chip, TPM2_PT_PERMANENT, &value,
+			     "could not retrieve PERMANENT property");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", (value & TPM2_PT_PM_ENDORSEMENT_AUTH_SET) > 0);
+	return rc;
+}
+static DEVICE_ATTR_RO(eh_owned);
+
+static ssize_t manufacturer_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
+	u32 manufacturer;
+	ssize_t rc;
+	char *str = buf;
+
+	rc = tpm2_get_tpm_pt(chip, TPM2_PT_MANUFACTURER, (u32 *) &manufacturer,
+			     "could not retrieve MANUFACTURER property");
+	if (rc)
+		return 0;
+
+	str += sprintf(str, "0x%08x\n", be32_to_cpu(manufacturer));
+
+	return str - buf;
+}
+static DEVICE_ATTR_RO(manufacturer);
+
+static ssize_t firmware_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
+	u32 firmware1;
+	u32 firmware2;
+	ssize_t rc;
+	char *str = buf;
+
+	rc = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_1, (u32 *) &firmware1,
+			     "could not retrieve FIRMWARE_VERSION_1 property");
+	if (rc)
+		return 0;
+
+	rc = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_2, (u32 *) &firmware2,
+			     "could not retrieve FIRMWARE_VERSION_2 property");
+	if (rc)
+		return 0;
+
+	str += sprintf(str, "0x%08x.0x%08x\n", firmware1, firmware2);
+
+	return str - buf;
+}
+static DEVICE_ATTR_RO(firmware);
+
+static ssize_t family_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	char *str = buf;
+
+	str += sprintf(str, "2.0\n");
+
+	return str - buf;
+}
+static DEVICE_ATTR_RO(family);
+
+struct attribute *tpm2_dev_attrs[] = {
+	&dev_attr_sh_enabled.attr,
+	&dev_attr_sh_owned.attr,
+	&dev_attr_eh_enabled.attr,
+	&dev_attr_eh_owned.attr,
+	&dev_attr_manufacturer.attr,
+	&dev_attr_firmware.attr,
+	&dev_attr_family.attr,
+	NULL,
+};
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index e36f637..c9b95c0 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -167,7 +167,7 @@ static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	cca = priv->cca;
 
 	if (len > le32_to_cpu(cca->cmd_size)) {
-		dev_err(chip->dev,
+		dev_err(&chip->dev,
 			"invalid command count value %x %zx\n",
 			(unsigned int) len,
 			(size_t) le32_to_cpu(cca->cmd_size));
@@ -198,7 +198,7 @@ static void crb_cancel(struct tpm_chip *chip)
 	wmb();
 
 	if (crb_do_acpi_start(chip))
-		dev_err(chip->dev, "ACPI Start failed\n");
+		dev_err(&chip->dev, "ACPI Start failed\n");
 
 	cca->cancel = 0;
 }
@@ -231,24 +231,22 @@ static int crb_acpi_add(struct acpi_device *device)
 	int rc;
 
 	chip = tpmm_chip_alloc(dev, &tpm_crb);
-	if (IS_ERR(chip)) {
-		dev_err(dev, "allocating chip failed\n");
+	if (IS_ERR(chip))
 		return PTR_ERR(chip);
-	}
 
 	chip->flags = TPM_CHIP_FLAG_TPM2;
 
 	status = acpi_get_table(ACPI_SIG_TPM2, 1,
 				(struct acpi_table_header **) &buf);
 	if (ACPI_FAILURE(status)) {
-		dev_err(dev, "could not get TPM2 ACPI table\n");
+		dev_err(dev, "failed to get TPM2 ACPI table\n");
 		return -ENODEV;
 	}
 
 	priv = (struct crb_priv *) devm_kzalloc(dev, sizeof(struct crb_priv),
 						GFP_KERNEL);
 	if (!priv) {
-		dev_err(dev, "allocating memory failed\n");
+		dev_err(dev, "failed to devm_kzalloc for private data\n");
 		return -ENOMEM;
 	}
 
@@ -285,16 +283,12 @@ static int crb_acpi_add(struct acpi_device *device)
 	chip->acpi_dev_handle = device->handle;
 
 	rc = tpm2_do_selftest(chip);
-	if (rc) {
-		dev_err(dev, "self-test failed\n");
+	if (rc)
 		return rc;
-	}
 
 	rc = tpm_chip_register(chip);
-	if (rc) {
-		dev_err(dev, "registering the chip failed\n");
+	if (rc)
 		return rc;
-	}
 
 	return 0;
 }
-- 
2.1.0

