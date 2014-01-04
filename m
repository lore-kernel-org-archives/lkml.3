Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaADCne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:43:34 -0500
Received: from mout.gmx.net ([212.227.15.15]:54956 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbaADCnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:43:12 -0500
From: Peter Huewe <peterhuewe@gmx.de>
To: James Morris <jmorris@namei.org>
Cc: Ashley Lai <ashley@ashleylai.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 09/15] tpm: Move sysfs functions from tpm-interface to tpm-sysfs
Date: Sat,  4 Jan 2014 03:44:43 +0100
Message-Id: <1388803489-13258-9-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
References: <201401040335.04980.PeterHuewe@gmx.de>
 <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:mNwaxBc9X4D7r/C8oHl6bguFY7NDpNSCQsNUfqJx+Ut2SV6APoi
 KnpLy1ToDhpPzbfTuBIAX/2D3ka1XGlzd6dshyuBP1wJ2fA1q42iSp9ln1uFq3Y1KC4eHW2
 Lr2fRekmE1TFyXTLBwX5P4/ehdjr9XkQWTY/9pLLesGCtfiqJXnwQcwOgGXiYrygLBoXTTn
 7NKPNab1GsElEJQmWrvRg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

CLASS-sysfs.c is a common idiom for linux subsystems.

This is the first step to pulling all the sysfs support code from
the drivers into tpm-sysfs. This is a plain text copy from tpm-interface
with support changes to make it compile.

_tpm_pcr_read is made non-static and is called tpm_pcr_read_dev.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/Makefile        |   2 +-
 drivers/char/tpm/tpm-interface.c | 275 +-------------------------------------
 drivers/char/tpm/tpm-sysfs.c     | 281 +++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm.h           |  30 +++++
 4 files changed, 314 insertions(+), 274 deletions(-)
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
index 0b9e9ca..3f8bddf 100644
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
@@ -894,187 +804,6 @@ int tpm_send(u32 chip_num, void *cmd, size_t buflen)
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
 					bool check_cancel, bool *canceled)
 {
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
new file mode 100644
index 0000000..310d960
--- /dev/null
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -0,0 +1,281 @@
+/*
+ * Copyright (C) 2004 IBM Corporation
+ * Authors:
+ * Leendert van Doorn <leendert@watson.ibm.com>
+ * Dave Safford <safford@watson.ibm.com>
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
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
+/* XXX for now this helper is duplicated in tpm-interface.c */
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
+#define READ_PUBEK_RESULT_SIZE 314
+#define TPM_ORD_READPUBEK cpu_to_be32(124)
+static struct tpm_input_header tpm_readpubek_header = {
+	.tag = TPM_TAG_RQU_COMMAND,
+	.length = cpu_to_be32(30),
+	.ordinal = TPM_ORD_READPUBEK
+};
+
+ssize_t tpm_show_pubek(struct device *dev, struct device_attribute *attr,
+		       char *buf)
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
+EXPORT_SYMBOL_GPL(tpm_show_pubek);
+
+ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
+		      char *buf)
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
+EXPORT_SYMBOL_GPL(tpm_show_pcrs);
+
+ssize_t tpm_show_enabled(struct device *dev, struct device_attribute *attr,
+			char *buf)
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
+EXPORT_SYMBOL_GPL(tpm_show_enabled);
+
+ssize_t tpm_show_active(struct device *dev, struct device_attribute *attr,
+			char *buf)
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
+EXPORT_SYMBOL_GPL(tpm_show_active);
+
+ssize_t tpm_show_owned(struct device *dev, struct device_attribute *attr,
+			char *buf)
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
+EXPORT_SYMBOL_GPL(tpm_show_owned);
+
+ssize_t tpm_show_temp_deactivated(struct device *dev,
+				struct device_attribute *attr, char *buf)
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
+EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
+
+ssize_t tpm_show_caps(struct device *dev, struct device_attribute *attr,
+		      char *buf)
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
+EXPORT_SYMBOL_GPL(tpm_show_caps);
+
+ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	if (chip == NULL)
+		return 0;
+
+	chip->vendor.cancel(chip);
+	return count;
+}
+EXPORT_SYMBOL_GPL(tpm_store_cancel);
+
+ssize_t tpm_show_durations(struct device *dev, struct device_attribute *attr,
+			  char *buf)
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
+EXPORT_SYMBOL_GPL(tpm_show_durations);
+
+ssize_t tpm_show_timeouts(struct device *dev, struct device_attribute *attr,
+			  char *buf)
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
+EXPORT_SYMBOL_GPL(tpm_show_timeouts);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 496228c..41b1480 100644
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
@@ -171,6 +179,8 @@ struct tpm_output_header {
 	__be32	return_code;
 } __packed;
 
+#define TPM_TAG_RQU_COMMAND cpu_to_be16(193)
+
 struct	stclear_flags_t {
 	__be16	tag;
 	u8	deactivated;
@@ -244,6 +254,24 @@ typedef union {
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
@@ -341,6 +369,8 @@ extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 int tpm_dev_add_device(struct tpm_chip *chip);
 void tpm_dev_del_device(struct tpm_chip *chip);
 
+int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
+
 #ifdef CONFIG_ACPI
 extern int tpm_add_ppi(struct kobject *);
 extern void tpm_remove_ppi(struct kobject *);
-- 
1.8.1.5

