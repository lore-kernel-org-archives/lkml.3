Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaIXJHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:07:50 -0400
Received: from mga03.intel.com ([134.134.136.65]:36918 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbaIXJHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:07:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="607709369"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v1 12/12] tpm: TPM2 sysfs attributes
Date: Wed, 24 Sep 2014 12:06:02 +0300
Message-Id: <1411549562-24242-13-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added tpm2-sysfs.c that implements sysfs attributes for a TPM2
device.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/Makefile        |   2 +-
 drivers/char/tpm/tpm-chip.c      |  10 +-
 drivers/char/tpm/tpm-interface.c |   1 +
 drivers/char/tpm/tpm2-commands.c |   2 +-
 drivers/char/tpm/tpm2-sysfs.c    | 242 +++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2.h          |  31 +++++
 6 files changed, 284 insertions(+), 4 deletions(-)
 create mode 100644 drivers/char/tpm/tpm2-sysfs.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 253e823..9e71c43 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel tpm device drivers.
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
-tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-commands.o
+tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-commands.o tpm2-sysfs.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o
 
 ifdef CONFIG_ACPI
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 128942b..91d8213 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -127,7 +127,10 @@ int tpm_chip_register(struct tpm_chip *chip)
 	if (rc)
 		return rc;
 
-	rc = tpm_sysfs_add_device(chip);
+	if (chip->tpm2)
+		rc = tpm2_sysfs_add_device(chip);
+	else
+		rc = tpm_sysfs_add_device(chip);
 	if (rc)
 		goto del_misc;
 
@@ -160,7 +163,10 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 	synchronize_rcu();
 
 	tpm_dev_del_device(chip);
-	tpm_sysfs_del_device(chip);
+	if (chip->tpm2)
+		tpm2_sysfs_del_device(chip);
+	else
+		tpm_sysfs_del_device(chip);
 	tpm_remove_ppi(&chip->dev->kobj);
 
 	if (!chip->tpm2)
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 7a9c096..26195db 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -899,6 +899,7 @@ void tpm_remove_hardware(struct device *dev)
 
 	tpm_chip_unregister(chip);
 
+
 	/* write it this way to be explicit (chip->dev == dev) */
 	put_device(chip->dev);
 }
diff --git a/drivers/char/tpm/tpm2-commands.c b/drivers/char/tpm/tpm2-commands.c
index a21dfd5..6365087 100644
--- a/drivers/char/tpm/tpm2-commands.c
+++ b/drivers/char/tpm/tpm2-commands.c
@@ -195,7 +195,7 @@ ssize_t tpm2_get_tpm_pt(struct device *dev, u32 property_id,  u32* value,
 	cmd.header.in = tpm2_get_tpm_pt_header;
 	cmd.params.tpm2_get_tpm_pt_in.cap_id =
 		cpu_to_be32(TPM2_CAP_TPM_PROPERTIES);
-	cmd.params.tpm2_get_tpm_pt_in.property_id = property_id;
+	cmd.params.tpm2_get_tpm_pt_in.property_id = cpu_to_be32(property_id);
 	cmd.params.tpm2_get_tpm_pt_in.property_cnt = cpu_to_be32(1);
 
 	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), desc);
diff --git a/drivers/char/tpm/tpm2-sysfs.c b/drivers/char/tpm/tpm2-sysfs.c
new file mode 100644
index 0000000..a254b2c
--- /dev/null
+++ b/drivers/char/tpm/tpm2-sysfs.c
@@ -0,0 +1,242 @@
+/*
+ * Copyright (C) 2004 IBM Corporation
+ * Authors:
+ * Leendert van Doorn <leendert@watson.ibm.com>
+ * Dave Safford <safford@watson.ibm.com>
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
+ *
+ * Copyright (C) 2013 Obsidian Research Corp
+ * Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
+ *
+ * sysfs filesystem inspection interface to the TPM
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ */
+#include <linux/device.h>
+#include "tpm.h"
+
+static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	u8 digest[TPM_DIGEST_SIZE];
+	ssize_t rc;
+	int i, j;
+	char *str = buf;
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	for (i = 0; i < TPM2_PLATFORM_PCR; i++) {
+		rc = tpm2_pcr_read_dev(chip, i, digest);
+		if (rc)
+			break;
+		str += sprintf(str, "PCR-%02d: ", i);
+		for (j = 0; j < TPM_DIGEST_SIZE; j++)
+			str += sprintf(str, "%02X ", digest[j]);
+		str += sprintf(str, "\n");
+	}
+
+	return str - buf;
+}
+static DEVICE_ATTR_RO(pcrs);
+
+static ssize_t enabled_sh_show(struct device *dev, struct device_attribute *attr,
+		     char *buf)
+{
+	struct tpm2_startup_clear value;
+	ssize_t rc;
+
+	rc = tpm2_get_tpm_pt(dev, TPM2_PT_STARTUP_CLEAR, (u32 *) &value,
+			     "could not retrieve STARTUP_CLEAR property");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", value.sh_enable);
+	return rc;
+}
+static DEVICE_ATTR_RO(enabled_sh);
+
+static ssize_t enabled_eh_show(struct device *dev, struct device_attribute *attr,
+		     char *buf)
+{
+	struct tpm2_startup_clear value;
+	ssize_t rc;
+
+	rc = tpm2_get_tpm_pt(dev, TPM2_PT_STARTUP_CLEAR, (u32 *) &value,
+			     "could not retrieve STARTUP_CLEAR property");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", value.eh_enable);
+	return rc;
+}
+static DEVICE_ATTR_RO(enabled_eh);
+
+static ssize_t owned_sh_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct tpm2_permanent value;
+	ssize_t rc;
+
+	rc = tpm2_get_tpm_pt(dev, TPM2_PT_PERMANENT, (u32 *) &value,
+			     "could not retrieve PERMANENT property");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", value.owner_auth_set);
+	return rc;
+}
+static DEVICE_ATTR_RO(owned_sh);
+
+static ssize_t owned_eh_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct tpm2_permanent value;
+	ssize_t rc;
+
+	rc = tpm2_get_tpm_pt(dev, TPM2_PT_PERMANENT, (u32 *) &value,
+			     "could not retrieve PERMANENT property");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", value.endorsement_auth_set);
+	return rc;
+}
+static DEVICE_ATTR_RO(owned_eh);
+
+static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	u32 value1;
+	u32 value2;
+	ssize_t rc;
+	char *str = buf;
+
+	rc = tpm2_get_tpm_pt(dev, TPM2_PT_MANUFACTURER, (u32 *) &value1,
+			     "could not retrieve MANUFACTURER property");
+	if (rc)
+		return 0;
+
+	str += sprintf(str, "Manufacturer: 0x%08x\n", be32_to_cpu(value1));
+	str += sprintf(str, "TCG version: 2.0\n");
+
+	rc = tpm2_get_tpm_pt(dev, TPM2_PT_FIRMWARE_VERSION_1, (u32 *) &value1,
+			     "could not retrieve FIRMWARE_VERSION_1 property");
+	if (rc)
+		return 0;
+
+	rc = tpm2_get_tpm_pt(dev, TPM2_PT_FIRMWARE_VERSION_2, (u32 *) &value2,
+			     "could not retrieve FIRMWARE_VERSION_2 property");
+	if (rc)
+		return 0;
+
+	str += sprintf(str, "Firmware version: 0x%08x 0x%08x\n", value1, value2);
+
+	return str - buf;
+}
+static DEVICE_ATTR_RO(caps);
+
+static ssize_t cancel_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	if (chip == NULL)
+		return 0;
+
+	chip->ops->cancel(chip);
+	return count;
+}
+static DEVICE_ATTR_WO(cancel);
+
+static ssize_t durations_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	if (chip->vendor.duration[TPM_LONG] == 0)
+		return 0;
+
+	return sprintf(buf, "%d %d %d [%s]\n",
+		       jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
+		       jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
+		       jiffies_to_usecs(chip->vendor.duration[TPM_LONG]),
+		       chip->vendor.duration_adjusted
+		       ? "adjusted" : "original");
+}
+static DEVICE_ATTR_RO(durations);
+
+static ssize_t timeouts_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d %d %d %d [%s]\n",
+		       jiffies_to_usecs(chip->vendor.timeout_a),
+		       jiffies_to_usecs(chip->vendor.timeout_b),
+		       jiffies_to_usecs(chip->vendor.timeout_c),
+		       jiffies_to_usecs(chip->vendor.timeout_d),
+		       chip->vendor.timeout_adjusted
+		       ? "adjusted" : "original");
+}
+static DEVICE_ATTR_RO(timeouts);
+
+static ssize_t version_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	char *str = buf;
+
+	str += sprintf(str, "2.0\n");
+
+	return str - buf;
+}
+
+static DEVICE_ATTR_RO(version);
+
+
+static ssize_t tpm2_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", chip->tpm2);
+}
+static DEVICE_ATTR_RO(tpm2);
+
+static struct attribute *tpm_dev_attrs[] = {
+	&dev_attr_pcrs.attr,
+	&dev_attr_enabled_sh.attr,
+	&dev_attr_enabled_eh.attr,
+	&dev_attr_owned_sh.attr,
+	&dev_attr_owned_eh.attr,
+	&dev_attr_caps.attr,
+	&dev_attr_cancel.attr,
+	&dev_attr_durations.attr,
+	&dev_attr_timeouts.attr,
+	&dev_attr_version.attr,
+	&dev_attr_tpm2.attr,
+	NULL,
+};
+
+static const struct attribute_group tpm_dev_group = {
+	.attrs = tpm_dev_attrs,
+};
+
+int tpm2_sysfs_add_device(struct tpm_chip *chip)
+{
+	int err;
+	err = sysfs_create_group(&chip->dev->kobj,
+				 &tpm_dev_group);
+
+	if (err)
+		dev_err(chip->dev,
+			"failed to create sysfs attributes, %d\n", err);
+	return err;
+}
+
+void tpm2_sysfs_del_device(struct tpm_chip *chip)
+{
+	sysfs_remove_group(&chip->dev->kobj, &tpm_dev_group);
+}
diff --git a/drivers/char/tpm/tpm2.h b/drivers/char/tpm/tpm2.h
index ba7c053..7a1502a 100644
--- a/drivers/char/tpm/tpm2.h
+++ b/drivers/char/tpm/tpm2.h
@@ -59,6 +59,34 @@ enum tpm2_capabilities {
 	TPM2_CAP_TPM_PROPERTIES = 6,
 };
 
+enum tpm2_tpm_properties {
+	TPM2_PT_MANUFACTURER		= 0x00000105,
+	TPM2_PT_FIRMWARE_VERSION_1	= 0x00000111,
+	TPM2_PT_FIRMWARE_VERSION_2	= 0x00000111,
+	TPM2_PT_PERMANENT		= 0x00000200,
+	TPM2_PT_STARTUP_CLEAR		= 0x00000201,
+};
+
+struct tpm2_permanent {
+	unsigned int owner_auth_set		: 1;
+	unsigned int endorsement_auth_set	: 1;
+	unsigned int lockout_auth_set		: 1;
+	unsigned int reserved1			: 5;
+	unsigned int disable_clear		: 1;
+	unsigned int in_lockout			: 1;
+	unsigned int tpm_generated_eps		: 1;
+	unsigned int reserved2			: 21;
+};
+
+struct tpm2_startup_clear {
+	unsigned int ph_enable			: 1;
+	unsigned int sh_enable			: 1;
+	unsigned int eh_enable			: 1;
+	unsigned int ph_enable_nv		: 1;
+	unsigned int reserved			: 27;
+	unsigned int orderly			: 1;
+};
+
 struct tpm_chip;
 
 #define TPM2_CC_FIRST	0x11F
@@ -74,4 +102,7 @@ int tpm2_do_selftest(struct tpm_chip *chip);
 int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max);
 void tpm2_gen_interrupt(struct tpm_chip *chip);
 
+int tpm2_sysfs_add_device(struct tpm_chip *chip);
+void tpm2_sysfs_del_device(struct tpm_chip *chip);
+
 #endif /* __DRIVERS_CHAR_TPM2_H__ */
-- 
2.1.0

