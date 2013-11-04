Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3KDDjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 22:39:33 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:44379 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab3KDDi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 22:38:58 -0500
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>
Cc: linux-kernel@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>
Subject: [PATCH 2/5 v2] tpm: Pull everything related to sysfs into tpm-sysfs.c
Date: Sun,  3 Nov 2013 20:38:43 -0700
Message-Id: <1383536326-28772-3-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CLASS-sysfs.c is a common idiom for linux subsystems.

This pulls all the sysfs attribute functions and related code
into tpm-sysfs.c. To support this change some constants are moved
from tpm.c to tpm.h and __tpm_pcr_read is made non-static and is
called tpm_pcr_read_dev.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
---
 drivers/char/tpm/Makefile           |   2 +-
 drivers/char/tpm/tpm-interface.c    | 281 +------------------------------
 drivers/char/tpm/tpm-sysfs.c        | 318 ++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm.h              |  54 +++---
 drivers/char/tpm/tpm_atmel.c        |  16 --
 drivers/char/tpm/tpm_i2c_atmel.c    |  30 ----
 drivers/char/tpm/tpm_i2c_infineon.c |  30 ----
 drivers/char/tpm/tpm_i2c_nuvoton.c  |  30 ----
 drivers/char/tpm/tpm_i2c_stm_st33.c |  25 ---
 drivers/char/tpm/tpm_ibmvtpm.c      |  28 ----
 drivers/char/tpm/tpm_infineon.c     |  16 --
 drivers/char/tpm/tpm_nsc.c          |  16 --
 drivers/char/tpm/tpm_tis.c          |  30 ----
 drivers/char/tpm/xen-tpmfront.c     |  31 ----
 14 files changed, 356 insertions(+), 551 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-sysfs.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index d835e87..4d85dd6 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel tpm device drivers.
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
-tpm-y := tpm-interface.o tpm-dev.o
+tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o
 
 ifdef CONFIG_ACPI
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 9b9bb7b..5ab3caa 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -32,13 +32,6 @@
 #include "tpm.h"
 #include "tpm_eventlog.h"
 
-enum tpm_duration {
-	TPM_SHORT = 0,
-	TPM_MEDIUM = 1,
-	TPM_LONG = 2,
-	TPM_UNDEFINED,
-};
-
 #define TPM_MAX_ORDINAL 243
 #define TSC_MAX_ORDINAL 12
 #define TPM_PROTECTED_COMMAND 0x00
@@ -405,24 +398,6 @@ out:
 #define TPM_DIGEST_SIZE 20
 #define TPM_RET_CODE_IDX 6
 
-enum tpm_capabilities {
-	TPM_CAP_FLAG = cpu_to_be32(4),
-	TPM_CAP_PROP = cpu_to_be32(5),
-	CAP_VERSION_1_1 = cpu_to_be32(0x06),
-	CAP_VERSION_1_2 = cpu_to_be32(0x1A)
-};
-
-enum tpm_sub_capabilities {
-	TPM_CAP_PROP_PCR = cpu_to_be32(0x101),
-	TPM_CAP_PROP_MANUFACTURER = cpu_to_be32(0x103),
-	TPM_CAP_FLAG_PERM = cpu_to_be32(0x108),
-	TPM_CAP_FLAG_VOL = cpu_to_be32(0x109),
-	TPM_CAP_PROP_OWNER = cpu_to_be32(0x111),
-	TPM_CAP_PROP_TIS_TIMEOUT = cpu_to_be32(0x115),
-	TPM_CAP_PROP_TIS_DURATION = cpu_to_be32(0x120),
-
-};
-
 static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
 			    int len, const char *desc)
 {
@@ -442,7 +417,6 @@ static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
 }
 
 #define TPM_INTERNAL_RESULT_SIZE 200
-#define TPM_TAG_RQU_COMMAND cpu_to_be16(193)
 #define TPM_ORD_GET_CAP cpu_to_be32(101)
 #define TPM_ORD_GET_RANDOM cpu_to_be32(70)
 
@@ -642,70 +616,6 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
 	return rc;
 }
 
-ssize_t tpm_show_enabled(struct device *dev, struct device_attribute *attr,
-			char *buf)
-{
-	cap_t cap;
-	ssize_t rc;
-
-	rc = tpm_getcap(dev, TPM_CAP_FLAG_PERM, &cap,
-			 "attempting to determine the permanent enabled state");
-	if (rc)
-		return 0;
-
-	rc = sprintf(buf, "%d\n", !cap.perm_flags.disable);
-	return rc;
-}
-EXPORT_SYMBOL_GPL(tpm_show_enabled);
-
-ssize_t tpm_show_active(struct device *dev, struct device_attribute *attr,
-			char *buf)
-{
-	cap_t cap;
-	ssize_t rc;
-
-	rc = tpm_getcap(dev, TPM_CAP_FLAG_PERM, &cap,
-			 "attempting to determine the permanent active state");
-	if (rc)
-		return 0;
-
-	rc = sprintf(buf, "%d\n", !cap.perm_flags.deactivated);
-	return rc;
-}
-EXPORT_SYMBOL_GPL(tpm_show_active);
-
-ssize_t tpm_show_owned(struct device *dev, struct device_attribute *attr,
-			char *buf)
-{
-	cap_t cap;
-	ssize_t rc;
-
-	rc = tpm_getcap(dev, TPM_CAP_PROP_OWNER, &cap,
-			 "attempting to determine the owner state");
-	if (rc)
-		return 0;
-
-	rc = sprintf(buf, "%d\n", cap.owned);
-	return rc;
-}
-EXPORT_SYMBOL_GPL(tpm_show_owned);
-
-ssize_t tpm_show_temp_deactivated(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	cap_t cap;
-	ssize_t rc;
-
-	rc = tpm_getcap(dev, TPM_CAP_FLAG_VOL, &cap,
-			 "attempting to determine the temporary state");
-	if (rc)
-		return 0;
-
-	rc = sprintf(buf, "%d\n", cap.stclear_flags.deactivated);
-	return rc;
-}
-EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
-
 /*
  * tpm_chip_find_get - return tpm_chip for given chip number
  */
@@ -735,7 +645,7 @@ static struct tpm_input_header pcrread_header = {
 	.ordinal = TPM_ORDINAL_PCRREAD
 };
 
-static int __tpm_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
+int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 {
 	int rc;
 	struct tpm_cmd_t cmd;
@@ -770,7 +680,7 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
 	chip = tpm_chip_find_get(chip_num);
 	if (chip == NULL)
 		return -ENODEV;
-	rc = __tpm_pcr_read(chip, pcr_idx, res_buf);
+	rc = tpm_pcr_read_dev(chip, pcr_idx, res_buf);
 	tpm_chip_put(chip);
 	return rc;
 }
@@ -894,189 +804,8 @@ int tpm_send(u32 chip_num, void *cmd, size_t buflen)
 }
 EXPORT_SYMBOL_GPL(tpm_send);
 
-ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
-		      char *buf)
-{
-	cap_t cap;
-	u8 digest[TPM_DIGEST_SIZE];
-	ssize_t rc;
-	int i, j, num_pcrs;
-	char *str = buf;
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-
-	rc = tpm_getcap(dev, TPM_CAP_PROP_PCR, &cap,
-			"attempting to determine the number of PCRS");
-	if (rc)
-		return 0;
-
-	num_pcrs = be32_to_cpu(cap.num_pcrs);
-	for (i = 0; i < num_pcrs; i++) {
-		rc = __tpm_pcr_read(chip, i, digest);
-		if (rc)
-			break;
-		str += sprintf(str, "PCR-%02d: ", i);
-		for (j = 0; j < TPM_DIGEST_SIZE; j++)
-			str += sprintf(str, "%02X ", digest[j]);
-		str += sprintf(str, "\n");
-	}
-	return str - buf;
-}
-EXPORT_SYMBOL_GPL(tpm_show_pcrs);
-
-#define  READ_PUBEK_RESULT_SIZE 314
-#define TPM_ORD_READPUBEK cpu_to_be32(124)
-static struct tpm_input_header tpm_readpubek_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
-	.length = cpu_to_be32(30),
-	.ordinal = TPM_ORD_READPUBEK
-};
-
-ssize_t tpm_show_pubek(struct device *dev, struct device_attribute *attr,
-		       char *buf)
-{
-	u8 *data;
-	struct tpm_cmd_t tpm_cmd;
-	ssize_t err;
-	int i, rc;
-	char *str = buf;
-
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-
-	tpm_cmd.header.in = tpm_readpubek_header;
-	err = transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
-			"attempting to read the PUBEK");
-	if (err)
-		goto out;
-
-	/*
-	   ignore header 10 bytes
-	   algorithm 32 bits (1 == RSA )
-	   encscheme 16 bits
-	   sigscheme 16 bits
-	   parameters (RSA 12->bytes: keybit, #primes, expbit)
-	   keylenbytes 32 bits
-	   256 byte modulus
-	   ignore checksum 20 bytes
-	 */
-	data = tpm_cmd.params.readpubek_out_buffer;
-	str +=
-	    sprintf(str,
-		    "Algorithm: %02X %02X %02X %02X\n"
-		    "Encscheme: %02X %02X\n"
-		    "Sigscheme: %02X %02X\n"
-		    "Parameters: %02X %02X %02X %02X "
-		    "%02X %02X %02X %02X "
-		    "%02X %02X %02X %02X\n"
-		    "Modulus length: %d\n"
-		    "Modulus:\n",
-		    data[0], data[1], data[2], data[3],
-		    data[4], data[5],
-		    data[6], data[7],
-		    data[12], data[13], data[14], data[15],
-		    data[16], data[17], data[18], data[19],
-		    data[20], data[21], data[22], data[23],
-		    be32_to_cpu(*((__be32 *) (data + 24))));
-
-	for (i = 0; i < 256; i++) {
-		str += sprintf(str, "%02X ", data[i + 28]);
-		if ((i + 1) % 16 == 0)
-			str += sprintf(str, "\n");
-	}
-out:
-	rc = str - buf;
-	return rc;
-}
-EXPORT_SYMBOL_GPL(tpm_show_pubek);
-
-
-ssize_t tpm_show_caps(struct device *dev, struct device_attribute *attr,
-		      char *buf)
-{
-	cap_t cap;
-	ssize_t rc;
-	char *str = buf;
-
-	rc = tpm_getcap(dev, TPM_CAP_PROP_MANUFACTURER, &cap,
-			"attempting to determine the manufacturer");
-	if (rc)
-		return 0;
-	str += sprintf(str, "Manufacturer: 0x%x\n",
-		       be32_to_cpu(cap.manufacturer_id));
-
-	/* Try to get a TPM version 1.2 TPM_CAP_VERSION_INFO */
-	rc = tpm_getcap(dev, CAP_VERSION_1_2, &cap,
-			 "attempting to determine the 1.2 version");
-	if (!rc) {
-		str += sprintf(str,
-			       "TCG version: %d.%d\nFirmware version: %d.%d\n",
-			       cap.tpm_version_1_2.Major,
-			       cap.tpm_version_1_2.Minor,
-			       cap.tpm_version_1_2.revMajor,
-			       cap.tpm_version_1_2.revMinor);
-	} else {
-		/* Otherwise just use TPM_STRUCT_VER */
-		rc = tpm_getcap(dev, CAP_VERSION_1_1, &cap,
-				"attempting to determine the 1.1 version");
-		if (rc)
-			return 0;
-		str += sprintf(str,
-			       "TCG version: %d.%d\nFirmware version: %d.%d\n",
-			       cap.tpm_version.Major,
-			       cap.tpm_version.Minor,
-			       cap.tpm_version.revMajor,
-			       cap.tpm_version.revMinor);
-	}
-
-	return str - buf;
-}
-EXPORT_SYMBOL_GPL(tpm_show_caps);
-
-ssize_t tpm_show_durations(struct device *dev, struct device_attribute *attr,
-			  char *buf)
-{
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-
-	if (chip->vendor.duration[TPM_LONG] == 0)
-		return 0;
-
-	return sprintf(buf, "%d %d %d [%s]\n",
-		       jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
-		       jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
-		       jiffies_to_usecs(chip->vendor.duration[TPM_LONG]),
-		       chip->vendor.duration_adjusted
-		       ? "adjusted" : "original");
-}
-EXPORT_SYMBOL_GPL(tpm_show_durations);
-
-ssize_t tpm_show_timeouts(struct device *dev, struct device_attribute *attr,
-			  char *buf)
-{
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-
-	return sprintf(buf, "%d %d %d %d [%s]\n",
-		       jiffies_to_usecs(chip->vendor.timeout_a),
-		       jiffies_to_usecs(chip->vendor.timeout_b),
-		       jiffies_to_usecs(chip->vendor.timeout_c),
-		       jiffies_to_usecs(chip->vendor.timeout_d),
-		       chip->vendor.timeout_adjusted
-		       ? "adjusted" : "original");
-}
-EXPORT_SYMBOL_GPL(tpm_show_timeouts);
-
-ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
-			const char *buf, size_t count)
-{
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-	if (chip == NULL)
-		return 0;
-
-	chip->vendor.cancel(chip);
-	return count;
-}
-EXPORT_SYMBOL_GPL(tpm_store_cancel);
-
 static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask,
-					bool check_cancel, bool *canceled)
+				   bool check_cancel, bool *canceled)
 {
 	u8 status = chip->vendor.status(chip);
 
@@ -1150,7 +879,7 @@ void tpm_remove_hardware(struct device *dev)
 	synchronize_rcu();
 
 	tpm_dev_del_device(chip);
-	sysfs_remove_group(&dev->kobj, chip->vendor.attr_group);
+	tpm_sysfs_del_device(chip);
 	tpm_remove_ppi(&dev->kobj);
 	tpm_bios_log_teardown(chip->bios_dir);
 
@@ -1367,7 +1096,7 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 	if (tpm_dev_add_device(chip))
 		goto put_device;
 
-	if (sysfs_create_group(&dev->kobj, chip->vendor.attr_group))
+	if (tpm_sysfs_add_device(chip))
 		goto del_misc;
 
 	if (tpm_add_ppi(&dev->kobj))
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
new file mode 100644
index 0000000..3bcfed0
--- /dev/null
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -0,0 +1,318 @@
+/*
+ * Copyright (C) 2004 IBM Corporation
+ * Authors:
+ * Leendert van Doorn <leendert@watson.ibm.com>
+ * Dave Safford <safford@watson.ibm.com>
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
+ *
+ * Copyright (C) 2013 Obsidian Reearch Corp
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
+/* XXX for now this helper is duplicated in tpm.c */
+static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
+			    int len, const char *desc)
+{
+	int err;
+
+	len = tpm_transmit(chip, (u8 *) cmd, len);
+	if (len <  0)
+		return len;
+	else if (len < TPM_HEADER_SIZE)
+		return -EFAULT;
+
+	err = be32_to_cpu(cmd->header.out.return_code);
+	if (err != 0 && desc)
+		dev_err(chip->dev, "A TPM error (%d) occurred %s\n", err, desc);
+
+	return err;
+}
+
+#define	 READ_PUBEK_RESULT_SIZE 314
+#define TPM_ORD_READPUBEK cpu_to_be32(124)
+static struct tpm_input_header tpm_readpubek_header = {
+	.tag = TPM_TAG_RQU_COMMAND,
+	.length = cpu_to_be32(30),
+	.ordinal = TPM_ORD_READPUBEK
+};
+static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	u8 *data;
+	struct tpm_cmd_t tpm_cmd;
+	ssize_t err;
+	int i, rc;
+	char *str = buf;
+
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	tpm_cmd.header.in = tpm_readpubek_header;
+	err = transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
+			   "attempting to read the PUBEK");
+	if (err)
+		goto out;
+
+	/*
+	   ignore header 10 bytes
+	   algorithm 32 bits (1 == RSA )
+	   encscheme 16 bits
+	   sigscheme 16 bits
+	   parameters (RSA 12->bytes: keybit, #primes, expbit)
+	   keylenbytes 32 bits
+	   256 byte modulus
+	   ignore checksum 20 bytes
+	 */
+	data = tpm_cmd.params.readpubek_out_buffer;
+	str +=
+	    sprintf(str,
+		    "Algorithm: %02X %02X %02X %02X\n"
+		    "Encscheme: %02X %02X\n"
+		    "Sigscheme: %02X %02X\n"
+		    "Parameters: %02X %02X %02X %02X "
+		    "%02X %02X %02X %02X "
+		    "%02X %02X %02X %02X\n"
+		    "Modulus length: %d\n"
+		    "Modulus:\n",
+		    data[0], data[1], data[2], data[3],
+		    data[4], data[5],
+		    data[6], data[7],
+		    data[12], data[13], data[14], data[15],
+		    data[16], data[17], data[18], data[19],
+		    data[20], data[21], data[22], data[23],
+		    be32_to_cpu(*((__be32 *) (data + 24))));
+
+	for (i = 0; i < 256; i++) {
+		str += sprintf(str, "%02X ", data[i + 28]);
+		if ((i + 1) % 16 == 0)
+			str += sprintf(str, "\n");
+	}
+out:
+	rc = str - buf;
+	return rc;
+}
+static DEVICE_ATTR_RO(pubek);
+
+static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	cap_t cap;
+	u8 digest[TPM_DIGEST_SIZE];
+	ssize_t rc;
+	int i, j, num_pcrs;
+	char *str = buf;
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	rc = tpm_getcap(dev, TPM_CAP_PROP_PCR, &cap,
+			"attempting to determine the number of PCRS");
+	if (rc)
+		return 0;
+
+	num_pcrs = be32_to_cpu(cap.num_pcrs);
+	for (i = 0; i < num_pcrs; i++) {
+		rc = tpm_pcr_read_dev(chip, i, digest);
+		if (rc)
+			break;
+		str += sprintf(str, "PCR-%02d: ", i);
+		for (j = 0; j < TPM_DIGEST_SIZE; j++)
+			str += sprintf(str, "%02X ", digest[j]);
+		str += sprintf(str, "\n");
+	}
+	return str - buf;
+}
+static DEVICE_ATTR_RO(pcrs);
+
+static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
+		     char *buf)
+{
+	cap_t cap;
+	ssize_t rc;
+
+	rc = tpm_getcap(dev, TPM_CAP_FLAG_PERM, &cap,
+			 "attempting to determine the permanent enabled state");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", !cap.perm_flags.disable);
+	return rc;
+}
+static DEVICE_ATTR_RO(enabled);
+
+ssize_t active_show(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	cap_t cap;
+	ssize_t rc;
+
+	rc = tpm_getcap(dev, TPM_CAP_FLAG_PERM, &cap,
+			 "attempting to determine the permanent active state");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", !cap.perm_flags.deactivated);
+	return rc;
+}
+static DEVICE_ATTR_RO(active);
+
+static ssize_t owned_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	cap_t cap;
+	ssize_t rc;
+
+	rc = tpm_getcap(dev, TPM_CAP_PROP_OWNER, &cap,
+			 "attempting to determine the owner state");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", cap.owned);
+	return rc;
+}
+static DEVICE_ATTR_RO(owned);
+
+static ssize_t temp_deactivated_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	cap_t cap;
+	ssize_t rc;
+
+	rc = tpm_getcap(dev, TPM_CAP_FLAG_VOL, &cap,
+			 "attempting to determine the temporary state");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", cap.stclear_flags.deactivated);
+	return rc;
+}
+static DEVICE_ATTR_RO(temp_deactivated);
+
+static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	cap_t cap;
+	ssize_t rc;
+	char *str = buf;
+
+	rc = tpm_getcap(dev, TPM_CAP_PROP_MANUFACTURER, &cap,
+			"attempting to determine the manufacturer");
+	if (rc)
+		return 0;
+	str += sprintf(str, "Manufacturer: 0x%x\n",
+		       be32_to_cpu(cap.manufacturer_id));
+
+	/* Try to get a TPM version 1.2 TPM_CAP_VERSION_INFO */
+	rc = tpm_getcap(dev, CAP_VERSION_1_2, &cap,
+			 "attempting to determine the 1.2 version");
+	if (!rc) {
+		str += sprintf(str,
+			       "TCG version: %d.%d\nFirmware version: %d.%d\n",
+			       cap.tpm_version_1_2.Major,
+			       cap.tpm_version_1_2.Minor,
+			       cap.tpm_version_1_2.revMajor,
+			       cap.tpm_version_1_2.revMinor);
+	} else {
+		/* Otherwise just use TPM_STRUCT_VER */
+		rc = tpm_getcap(dev, CAP_VERSION_1_1, &cap,
+				"attempting to determine the 1.1 version");
+		if (rc)
+			return 0;
+		str += sprintf(str,
+			       "TCG version: %d.%d\nFirmware version: %d.%d\n",
+			       cap.tpm_version.Major,
+			       cap.tpm_version.Minor,
+			       cap.tpm_version.revMajor,
+			       cap.tpm_version.revMinor);
+	}
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
+	chip->vendor.cancel(chip);
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
+static struct attribute *tpm_dev_attrs[] = {
+	&dev_attr_pubek.attr,
+	&dev_attr_pcrs.attr,
+	&dev_attr_enabled.attr,
+	&dev_attr_active.attr,
+	&dev_attr_owned.attr,
+	&dev_attr_temp_deactivated.attr,
+	&dev_attr_caps.attr,
+	&dev_attr_cancel.attr,
+	&dev_attr_durations.attr,
+	&dev_attr_timeouts.attr,
+	NULL,
+};
+
+static const struct attribute_group tpm_dev_group = {
+	.attrs = tpm_dev_attrs,
+};
+
+int tpm_sysfs_add_device(struct tpm_chip *chip)
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
+void tpm_sysfs_del_device(struct tpm_chip *chip)
+{
+	sysfs_remove_group(&chip->dev->kobj, &tpm_dev_group);
+}
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 496228c..14ba162 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -46,6 +46,14 @@ enum tpm_addr {
 	TPM_ADDR = 0x4E,
 };
 
+/* Indexes the duration array */
+enum tpm_duration {
+	TPM_SHORT = 0,
+	TPM_MEDIUM = 1,
+	TPM_LONG = 2,
+	TPM_UNDEFINED,
+};
+
 #define TPM_WARN_RETRY          0x800
 #define TPM_WARN_DOING_SELFTEST 0x802
 #define TPM_ERR_DEACTIVATED     0x6
@@ -53,27 +61,6 @@ enum tpm_addr {
 #define TPM_ERR_INVALID_POSTINIT 38
 
 #define TPM_HEADER_SIZE		10
-extern ssize_t tpm_show_pubek(struct device *, struct device_attribute *attr,
-				char *);
-extern ssize_t tpm_show_pcrs(struct device *, struct device_attribute *attr,
-				char *);
-extern ssize_t tpm_show_caps(struct device *, struct device_attribute *attr,
-				char *);
-extern ssize_t tpm_store_cancel(struct device *, struct device_attribute *attr,
-				const char *, size_t);
-extern ssize_t tpm_show_enabled(struct device *, struct device_attribute *attr,
-				char *);
-extern ssize_t tpm_show_active(struct device *, struct device_attribute *attr,
-				char *);
-extern ssize_t tpm_show_owned(struct device *, struct device_attribute *attr,
-				char *);
-extern ssize_t tpm_show_temp_deactivated(struct device *,
-					 struct device_attribute *attr, char *);
-extern ssize_t tpm_show_durations(struct device *,
-				  struct device_attribute *attr, char *);
-extern ssize_t tpm_show_timeouts(struct device *,
-				 struct device_attribute *attr, char *);
-
 struct tpm_chip;
 
 struct tpm_vendor_specific {
@@ -95,7 +82,6 @@ struct tpm_vendor_specific {
 	u8 (*status) (struct tpm_chip *);
 	void (*release) (struct device *);
 	struct miscdevice miscdev;
-	struct attribute_group *attr_group;
 	struct list_head list;
 	int locality;
 	unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
@@ -171,6 +157,8 @@ struct tpm_output_header {
 	__be32	return_code;
 } __packed;
 
+#define TPM_TAG_RQU_COMMAND cpu_to_be16(193)
+
 struct	stclear_flags_t {
 	__be16	tag;
 	u8	deactivated;
@@ -244,6 +232,24 @@ typedef union {
 	struct duration_t duration;
 } cap_t;
 
+enum tpm_capabilities {
+	TPM_CAP_FLAG = cpu_to_be32(4),
+	TPM_CAP_PROP = cpu_to_be32(5),
+	CAP_VERSION_1_1 = cpu_to_be32(0x06),
+	CAP_VERSION_1_2 = cpu_to_be32(0x1A)
+};
+
+enum tpm_sub_capabilities {
+	TPM_CAP_PROP_PCR = cpu_to_be32(0x101),
+	TPM_CAP_PROP_MANUFACTURER = cpu_to_be32(0x103),
+	TPM_CAP_FLAG_PERM = cpu_to_be32(0x108),
+	TPM_CAP_FLAG_VOL = cpu_to_be32(0x109),
+	TPM_CAP_PROP_OWNER = cpu_to_be32(0x111),
+	TPM_CAP_PROP_TIS_TIMEOUT = cpu_to_be32(0x115),
+	TPM_CAP_PROP_TIS_DURATION = cpu_to_be32(0x120),
+
+};
+
 struct	tpm_getcap_params_in {
 	__be32	cap;
 	__be32	subcap_size;
@@ -340,6 +346,10 @@ extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 
 int tpm_dev_add_device(struct tpm_chip *chip);
 void tpm_dev_del_device(struct tpm_chip *chip);
+int tpm_sysfs_add_device(struct tpm_chip *chip);
+void tpm_sysfs_del_device(struct tpm_chip *chip);
+
+int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 
 #ifdef CONFIG_ACPI
 extern int tpm_add_ppi(struct kobject *);
diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
index 9692e2f..7e665d0 100644
--- a/drivers/char/tpm/tpm_atmel.c
+++ b/drivers/char/tpm/tpm_atmel.c
@@ -121,21 +121,6 @@ static bool tpm_atml_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == ATML_STATUS_READY);
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR |S_IWGRP, NULL, tpm_store_cancel);
-
-static struct attribute* atmel_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	NULL,
-};
-
-static struct attribute_group atmel_attr_grp = { .attrs = atmel_attrs };
-
 static const struct tpm_vendor_specific tpm_atmel = {
 	.recv = tpm_atml_recv,
 	.send = tpm_atml_send,
@@ -144,7 +129,6 @@ static const struct tpm_vendor_specific tpm_atmel = {
 	.req_complete_mask = ATML_STATUS_BUSY | ATML_STATUS_DATA_AVAIL,
 	.req_complete_val = ATML_STATUS_DATA_AVAIL,
 	.req_canceled = tpm_atml_req_canceled,
-	.attr_group = &atmel_attr_grp,
 };
 
 static struct platform_device *pdev;
diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
index 079c19d..fe8bdce 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -135,35 +135,6 @@ static u8 i2c_atmel_read_status(struct tpm_chip *chip)
 	return ATMEL_STS_OK;
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
-static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
-static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
-static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
-static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
-
-static struct attribute *i2c_atmel_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_enabled.attr,
-	&dev_attr_active.attr,
-	&dev_attr_owned.attr,
-	&dev_attr_temp_deactivated.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	&dev_attr_durations.attr,
-	&dev_attr_timeouts.attr,
-	NULL,
-};
-
-static struct attribute_group i2c_atmel_attr_grp = {
-	.attrs = i2c_atmel_attrs
-};
-
 static bool i2c_atmel_req_canceled(struct tpm_chip *chip, u8 status)
 {
 	return false;
@@ -177,7 +148,6 @@ static const struct tpm_vendor_specific i2c_atmel = {
 	.req_complete_mask = ATMEL_STS_OK,
 	.req_complete_val = ATMEL_STS_OK,
 	.req_canceled = i2c_atmel_req_canceled,
-	.attr_group = &i2c_atmel_attr_grp,
 };
 
 static int i2c_atmel_probe(struct i2c_client *client,
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index c1ba7fa..ac1218f 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -566,35 +566,6 @@ static bool tpm_tis_i2c_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == TPM_STS_COMMAND_READY);
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
-static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
-static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
-static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
-static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
-
-static struct attribute *tis_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_enabled.attr,
-	&dev_attr_active.attr,
-	&dev_attr_owned.attr,
-	&dev_attr_temp_deactivated.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	&dev_attr_durations.attr,
-	&dev_attr_timeouts.attr,
-	NULL,
-};
-
-static struct attribute_group tis_attr_grp = {
-	.attrs = tis_attrs
-};
-
 static struct tpm_vendor_specific tpm_tis_i2c = {
 	.status = tpm_tis_i2c_status,
 	.recv = tpm_tis_i2c_recv,
@@ -603,7 +574,6 @@ static struct tpm_vendor_specific tpm_tis_i2c = {
 	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled = tpm_tis_i2c_req_canceled,
-	.attr_group = &tis_attr_grp,
 };
 
 static int tpm_tis_i2c_init(struct device *dev)
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 3766fe7..5cb9670 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -456,35 +456,6 @@ static bool i2c_nuvoton_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == TPM_STS_COMMAND_READY);
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
-static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
-static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
-static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
-static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
-
-static struct attribute *i2c_nuvoton_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_enabled.attr,
-	&dev_attr_active.attr,
-	&dev_attr_owned.attr,
-	&dev_attr_temp_deactivated.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	&dev_attr_durations.attr,
-	&dev_attr_timeouts.attr,
-	NULL,
-};
-
-static struct attribute_group i2c_nuvoton_attr_grp = {
-	.attrs = i2c_nuvoton_attrs
-};
-
 static const struct tpm_vendor_specific tpm_i2c = {
 	.status = i2c_nuvoton_read_status,
 	.recv = i2c_nuvoton_recv,
@@ -493,7 +464,6 @@ static const struct tpm_vendor_specific tpm_i2c = {
 	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled = i2c_nuvoton_req_canceled,
-	.attr_group = &i2c_nuvoton_attr_grp,
 };
 
 /* The only purpose for the handler is to signal to any waiting threads that
diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index e519e68..6902f7b 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -574,30 +574,6 @@ static bool tpm_st33_i2c_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == TPM_STS_COMMAND_READY);
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
-static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
-static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
-static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-
-static struct attribute *stm_tpm_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_enabled.attr,
-	&dev_attr_active.attr,
-	&dev_attr_owned.attr,
-	&dev_attr_temp_deactivated.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr, NULL,
-};
-
-static struct attribute_group stm_tpm_attr_grp = {
-	.attrs = stm_tpm_attrs
-};
-
 static struct tpm_vendor_specific st_i2c_tpm = {
 	.send = tpm_stm_i2c_send,
 	.recv = tpm_stm_i2c_recv,
@@ -606,7 +582,6 @@ static struct tpm_vendor_specific st_i2c_tpm = {
 	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled = tpm_st33_i2c_req_canceled,
-	.attr_group = &stm_tpm_attr_grp,
 };
 
 static int interrupts;
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 14af0c1..1300e38 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -404,33 +404,6 @@ static bool tpm_ibmvtpm_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == 0);
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
-static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
-static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
-static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
-		   NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
-static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
-
-static struct attribute *ibmvtpm_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_enabled.attr,
-	&dev_attr_active.attr,
-	&dev_attr_owned.attr,
-	&dev_attr_temp_deactivated.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	&dev_attr_durations.attr,
-	&dev_attr_timeouts.attr, NULL,
-};
-
-static struct attribute_group ibmvtpm_attr_grp = { .attrs = ibmvtpm_attrs };
-
 static const struct tpm_vendor_specific tpm_ibmvtpm = {
 	.recv = tpm_ibmvtpm_recv,
 	.send = tpm_ibmvtpm_send,
@@ -439,7 +412,6 @@ static const struct tpm_vendor_specific tpm_ibmvtpm = {
 	.req_complete_mask = 0,
 	.req_complete_val = 0,
 	.req_canceled = tpm_ibmvtpm_req_canceled,
-	.attr_group = &ibmvtpm_attr_grp,
 };
 
 static const struct dev_pm_ops tpm_ibmvtpm_pm_ops = {
diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
index c75c10c..9525be5 100644
--- a/drivers/char/tpm/tpm_infineon.c
+++ b/drivers/char/tpm/tpm_infineon.c
@@ -371,21 +371,6 @@ static u8 tpm_inf_status(struct tpm_chip *chip)
 	return tpm_data_in(STAT);
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-
-static struct attribute *inf_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	NULL,
-};
-
-static struct attribute_group inf_attr_grp = {.attrs = inf_attrs };
-
 static const struct tpm_vendor_specific tpm_inf = {
 	.recv = tpm_inf_recv,
 	.send = tpm_inf_send,
@@ -393,7 +378,6 @@ static const struct tpm_vendor_specific tpm_inf = {
 	.status = tpm_inf_status,
 	.req_complete_mask = 0,
 	.req_complete_val = 0,
-	.attr_group = &inf_attr_grp,
 };
 
 static const struct pnp_device_id tpm_inf_pnp_tbl[] = {
diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index a4acac9..ad980be 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -232,21 +232,6 @@ static bool tpm_nsc_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == NSC_STATUS_RDY);
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR|S_IWGRP, NULL, tpm_store_cancel);
-
-static struct attribute * nsc_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	NULL,
-};
-
-static struct attribute_group nsc_attr_grp = { .attrs = nsc_attrs };
-
 static const struct tpm_vendor_specific tpm_nsc = {
 	.recv = tpm_nsc_recv,
 	.send = tpm_nsc_send,
@@ -255,7 +240,6 @@ static const struct tpm_vendor_specific tpm_nsc = {
 	.req_complete_mask = NSC_STATUS_OBF,
 	.req_complete_val = NSC_STATUS_OBF,
 	.req_canceled = tpm_nsc_req_canceled,
-	.attr_group = &nsc_attr_grp,
 };
 
 static struct platform_device *pdev = NULL;
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index c606ca1..b5d876b 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -432,35 +432,6 @@ static bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
 	}
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
-static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
-static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
-static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
-		   NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
-static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
-
-static struct attribute *tis_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_enabled.attr,
-	&dev_attr_active.attr,
-	&dev_attr_owned.attr,
-	&dev_attr_temp_deactivated.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	&dev_attr_durations.attr,
-	&dev_attr_timeouts.attr, NULL,
-};
-
-static struct attribute_group tis_attr_grp = {
-	.attrs = tis_attrs
-};
-
 static struct tpm_vendor_specific tpm_tis = {
 	.status = tpm_tis_status,
 	.recv = tpm_tis_recv,
@@ -469,7 +440,6 @@ static struct tpm_vendor_specific tpm_tis = {
 	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled = tpm_tis_req_canceled,
-	.attr_group = &tis_attr_grp,
 };
 
 static irqreturn_t tis_int_probe(int irq, void *dev_id)
diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index e3c7c01..d4f6b521 100644
--- a/drivers/char/tpm/xen-tpmfront.c
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -143,36 +143,6 @@ static int vtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	return length;
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
-static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
-static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
-static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
-		NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
-static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
-
-static struct attribute *vtpm_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_enabled.attr,
-	&dev_attr_active.attr,
-	&dev_attr_owned.attr,
-	&dev_attr_temp_deactivated.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	&dev_attr_durations.attr,
-	&dev_attr_timeouts.attr,
-	NULL,
-};
-
-static struct attribute_group vtpm_attr_grp = {
-	.attrs = vtpm_attrs,
-};
-
 static const struct tpm_vendor_specific tpm_vtpm = {
 	.status = vtpm_status,
 	.recv = vtpm_recv,
@@ -181,7 +151,6 @@ static const struct tpm_vendor_specific tpm_vtpm = {
 	.req_complete_mask = VTPM_STATUS_IDLE | VTPM_STATUS_RESULT,
 	.req_complete_val  = VTPM_STATUS_IDLE | VTPM_STATUS_RESULT,
 	.req_canceled      = vtpm_req_canceled,
-	.attr_group = &vtpm_attr_grp,
 };
 
 static irqreturn_t tpmif_interrupt(int dummy, void *dev_id)
-- 
1.8.1.2

