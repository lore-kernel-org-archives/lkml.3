Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaIXJHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:07:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:37036 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbaIXJHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:07:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="604543974"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com,
        Will Arthur <will.c.arthur@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v1 10/12] tpm: TPM 2.0 FIFO Interface
Date: Wed, 24 Sep 2014 12:06:00 +0300
Message-Id: <1411549562-24242-11-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Arthur <will.c.arthur@intel.com>

Detect TPM 2.0 by using the extended STS (STS3) register. For TPM 2.0,
instead of calling tpm_get_timeouts(), assign duration and timeout
values defined in the TPM 2.0 PTP specification.

[jarkko.sakkinen: Added durations and timeouts handling. Rewrote
 the commit message.]

Signed-off-by: Will Arthur <will.c.arthur@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c |  3 +++
 drivers/char/tpm/tpm2.h          |  7 ++++++
 drivers/char/tpm/tpm_tis.c       | 53 ++++++++++++++++++++++++++++++++--------
 3 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index b1d1cc8..7a9c096 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -506,6 +506,9 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	struct duration_t *duration_cap;
 	ssize_t rc;
 
+	if (chip->tpm2)
+		return 0;
+
 	tpm_cmd.header.in = tpm_getcap_header;
 	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
 	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
diff --git a/drivers/char/tpm/tpm2.h b/drivers/char/tpm/tpm2.h
index 98b8b80..ba7c053 100644
--- a/drivers/char/tpm/tpm2.h
+++ b/drivers/char/tpm/tpm2.h
@@ -19,6 +19,13 @@
 enum tpm2_const {
 	TPM2_PLATFORM_PCR = 24,
 	TPM2_PCR_SELECT_MIN = ((TPM2_PLATFORM_PCR + 7) / 8),
+	TPM2_TIMEOUT_A = 750 * 1000,
+	TPM2_TIMEOUT_B = 2000 * 1000,
+	TPM2_TIMEOUT_C = 200 * 1000,
+	TPM2_TIMEOUT_D = 30 * 1000,
+	TPM2_DURATION_SHORT = 20 * 1000,
+	TPM2_DURATION_MEDIUM = 750 * 1000,
+	TPM2_DURATION_LONG = 2000 * 1000,
 };
 
 enum tpm2_structures {
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 2c46734..d33e60f 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -44,6 +44,12 @@ enum tis_status {
 	TPM_STS_DATA_EXPECT = 0x08,
 };
 
+enum tis_status3 {
+	TPM_STS3_TPM2_FAM = 0x04,
+	TPM_STS3_RST_EST = 0x02,
+	TPM_STS3_CANCEL = 0x01,
+};
+
 enum tis_int_flags {
 	TPM_GLOBAL_INT_ENABLE = 0x80000000,
 	TPM_INTF_BURST_COUNT_STATIC = 0x100,
@@ -70,6 +76,7 @@ enum tis_defaults {
 #define	TPM_INT_STATUS(l)		(0x0010 | ((l) << 12))
 #define	TPM_INTF_CAPS(l)		(0x0014 | ((l) << 12))
 #define	TPM_STS(l)			(0x0018 | ((l) << 12))
+#define	TPM_STS3(l)			(0x001b | ((l) << 12))
 #define	TPM_DATA_FIFO(l)		(0x0024 | ((l) << 12))
 
 #define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
@@ -534,21 +541,48 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	u32 vendor, intfcaps, intmask;
 	int rc, i, irq_s, irq_e, probe;
 	struct tpm_chip *chip;
+	u8 sts3;
 
-	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
+	chip = tpm_chip_alloc(dev, &tpm_tis);
+	if (!chip)
 		return -ENODEV;
 
 	chip->vendor.iobase = ioremap(start, len);
 	if (!chip->vendor.iobase) {
-		rc = -EIO;
-		goto out_err;
+		put_device(chip->dev);
+		kfree(chip);
+		return -EIO;
+	}
+
+	sts3 = ioread8(chip->vendor.iobase + TPM_STS3(1));
+	chip->tpm2 = (sts3 & (TPM_STS3_TPM2_FAM)) == TPM_STS3_TPM2_FAM;
+
+	rc = tpm_chip_register(chip);
+	if (rc) {
+		iounmap(chip->vendor.iobase);
+		put_device(chip->dev);
+		kfree(chip);
+		return -ENODEV;
 	}
 
 	/* Default timeouts */
-	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
-	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	if (chip->tpm2) {
+		chip->vendor.timeout_a = usecs_to_jiffies(TPM2_TIMEOUT_A);
+		chip->vendor.timeout_b = usecs_to_jiffies(TPM2_TIMEOUT_B);
+		chip->vendor.timeout_c = usecs_to_jiffies(TPM2_TIMEOUT_C);
+		chip->vendor.timeout_d = usecs_to_jiffies(TPM2_TIMEOUT_D);
+		chip->vendor.duration[TPM_SHORT] =
+			usecs_to_jiffies(TPM2_DURATION_SHORT);
+		chip->vendor.duration[TPM_MEDIUM] =
+			usecs_to_jiffies(TPM2_DURATION_MEDIUM);
+		chip->vendor.duration[TPM_LONG] =
+			usecs_to_jiffies(TPM2_DURATION_LONG);
+	} else {
+		chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+		chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
+		chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+		chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	}
 
 	if (wait_startup(chip, 0) != 0) {
 		rc = -ENODEV;
@@ -563,8 +597,8 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
 	chip->vendor.manufacturer_id = vendor;
 
-	dev_info(dev,
-		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
+	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
+		 chip->tpm2 ? "2.0" : "1.2",
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
 	if (!itpm) {
@@ -724,7 +758,6 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	list_add(&chip->vendor.list, &tis_chips);
 	mutex_unlock(&tis_lock);
 
-
 	return 0;
 out_err:
 	if (chip->vendor.iobase)
-- 
2.1.0

