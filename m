Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbaJGREA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:04:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:62499 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbaJGRD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:03:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,671,1406617200"; 
   d="scan'208";a="601858868"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, Will Arthur <will.c.arthur@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 7/7] tpm: TPM 2.0 FIFO Interface
Date: Tue,  7 Oct 2014 20:01:17 +0300
Message-Id: <1412701277-27794-8-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Arthur <will.c.arthur@intel.com>

Detect TPM 2.0 by using the extended STS (STS3) register. For TPM 2.0,
instead of calling tpm_get_timeouts(), assign duration and timeout
values defined in the TPM 2.0 PTP specification.

Signed-off-by: Will Arthur <will.c.arthur@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_tis.c | 77 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 60 insertions(+), 17 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index df04ce6..5c5a0cc 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2005, 2006 IBM Corporation
+ * Copyright (C) 2014 Intel Corporation
  *
  * Authors:
  * Leendert van Doorn <leendert@watson.ibm.com>
@@ -44,6 +45,10 @@ enum tis_status {
 	TPM_STS_DATA_EXPECT = 0x08,
 };
 
+enum tis_status3 {
+	TPM_STS3_TPM2_FAM = 0x04,
+};
+
 enum tis_int_flags {
 	TPM_GLOBAL_INT_ENABLE = 0x80000000,
 	TPM_INTF_BURST_COUNT_STATIC = 0x100,
@@ -70,6 +75,7 @@ enum tis_defaults {
 #define	TPM_INT_STATUS(l)		(0x0010 | ((l) << 12))
 #define	TPM_INTF_CAPS(l)		(0x0014 | ((l) << 12))
 #define	TPM_STS(l)			(0x0018 | ((l) << 12))
+#define	TPM_STS3(l)			(0x001b | ((l) << 12))
 #define	TPM_DATA_FIFO(l)		(0x0024 | ((l) << 12))
 
 #define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
@@ -344,6 +350,7 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
 {
 	int rc;
 	u32 ordinal;
+	unsigned long dur;
 
 	rc = tpm_tis_send_data(chip, buf, len);
 	if (rc < 0)
@@ -355,9 +362,14 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
 
 	if (chip->vendor.irq) {
 		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+
+		if (chip->flags & TPM_CHIP_FLAG_TPM2)
+			dur = tpm_calc_ordinal_duration(chip, ordinal);
+		else
+			dur = tpm_calc_ordinal_duration(chip, ordinal);
+
 		if (wait_for_tpm_stat
-		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
-		     tpm_calc_ordinal_duration(chip, ordinal),
+		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID, dur,
 		     &chip->vendor.read_queue, false) < 0) {
 			rc = -ETIME;
 			goto out_err;
@@ -531,24 +543,43 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	u32 vendor, intfcaps, intmask;
 	int rc, i, irq_s, irq_e, probe;
 	struct tpm_chip *chip;
+	u8 sts3;
+	u32 dummy;
 
 	chip = tpm_chip_alloc(dev, &tpm_tis);
-	if (!chip)
+	if (IS_ERR(chip))
 		return -ENODEV;
 
 	chip->vendor.iobase = devm_ioremap(dev, start, len);
 	if (!chip->vendor.iobase)
 		return -EIO;
 
+	sts3 = ioread8(chip->vendor.iobase + TPM_STS3(1));
+	if (sts3 & TPM_STS3_TPM2_FAM)
+		chip->flags = TPM_CHIP_FLAG_TPM2;
+
 	rc = tpm_chip_register(chip);
 	if (rc)
 		return -ENODEV;
 
-	/* Default timeouts */
-	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
-	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+        /* Default timeouts */
+        if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+                chip->vendor.timeout_a = usecs_to_jiffies(TPM2_TIMEOUT_A);
+                chip->vendor.timeout_b = usecs_to_jiffies(TPM2_TIMEOUT_B);
+                chip->vendor.timeout_c = usecs_to_jiffies(TPM2_TIMEOUT_C);
+                chip->vendor.timeout_d = usecs_to_jiffies(TPM2_TIMEOUT_D);
+                chip->vendor.duration[TPM_SHORT] =
+                        usecs_to_jiffies(TPM2_DURATION_SHORT);
+                chip->vendor.duration[TPM_MEDIUM] =
+                        usecs_to_jiffies(TPM2_DURATION_MEDIUM);
+                chip->vendor.duration[TPM_LONG] =
+                        usecs_to_jiffies(TPM2_DURATION_LONG);
+        } else {
+                chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+                chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
+                chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+                chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+        }
 
 	if (wait_startup(chip, 0) != 0) {
 		rc = -ENODEV;
@@ -563,9 +594,9 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
 	chip->vendor.manufacturer_id = vendor;
 
-	dev_info(dev,
-		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
-		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
+        dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
+                 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
+                 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
 	if (!itpm) {
 		probe = probe_itpm(chip);
@@ -612,7 +643,11 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		goto out_err;
 	}
 
-	if (tpm_do_selftest(chip)) {
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		rc = tpm2_do_selftest(chip);
+	else
+		rc = tpm_do_selftest(chip);
+	if (rc) {
 		dev_err(dev, "TPM self test failed\n");
 		rc = -ENODEV;
 		goto out_err;
@@ -673,7 +708,11 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 			chip->vendor.probed_irq = 0;
 
 			/* Generate Interrupts */
-			tpm_gen_interrupt(chip);
+			if (chip->flags & TPM_CHIP_FLAG_TPM2)
+				rc = tpm2_get_tpm_pt(chip, TPM2_CAP_TPM_PROPERTIES, &dummy,
+						     "attempting to generate an interrupt");
+			else
+				tpm_gen_interrupt(chip);
 
 			chip->vendor.irq = chip->vendor.probed_irq;
 
@@ -752,14 +791,18 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 static int tpm_tis_resume(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-	int ret;
+	int ret = 0;
 
 	if (chip->vendor.irq)
 		tpm_tis_reenable_interrupts(chip);
 
-	ret = tpm_pm_resume(dev);
-	if (!ret)
-		tpm_do_selftest(chip);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		tpm2_do_selftest(chip);
+	else {
+		ret = tpm_pm_resume(dev);
+		if (!ret)
+			tpm_do_selftest(chip);
+	}
 
 	return ret;
 }
-- 
2.1.0

