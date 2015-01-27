Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbbA0LCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:02:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:60826 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbbA0LCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:02:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,474,1418112000"; 
   d="scan'208";a="668274299"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, stefanb@linux.vnet.ibm.com,
        linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net,
        jmorris@namei.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: fix suspend/resume paths for TPM 2.0
Date: Tue, 27 Jan 2015 13:02:44 +0200
Message-Id: <1422356564-17312-1-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed suspend/resume paths for TPM 2.0 and consolidated all the
associated code to the tpm_pm_suspend() and tpm_pm_resume()
functions. Resume path should be handled by the firmware, i.e.
Startup(CLEAR) for hibernate and Startup(STATE) for suspend.

There might be some non-PC embedded devices in the future where
Startup() is not the handled by the FW but fixing the code for
those IMHO should be postponed until there is hardware available
to test the fixes although extra Startup in the driver code is
essentially a NOP.

Reported-by: Peter Hüwe <PeterHuewe@gmx.de>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c | 10 ++++++++--
 drivers/char/tpm/tpm_crb.c       | 16 +---------------
 drivers/char/tpm/tpm_tis.c       | 22 ++++++++++------------
 3 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index bf53a37..93c8b90fd 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -901,8 +901,13 @@ int tpm_pm_suspend(struct device *dev)
 	if (chip == NULL)
 		return -ENODEV;
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		return tpm2_shutdown(chip, TPM2_SU_CLEAR);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		rc = tpm2_shutdown(chip, TPM2_SU_STATE);
+		if (rc < 0)
+			return rc;
+
+		return 0;
+	}
 
 	/* for buggy tpm, flush pcrs with extend to selected dummy */
 	if (tpm_suspend_pcr) {
@@ -952,6 +957,7 @@ EXPORT_SYMBOL_GPL(tpm_pm_suspend);
 int tpm_pm_resume(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
+	int ret;
 
 	if (chip == NULL)
 		return -ENODEV;
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 3dd23cf..3e080f5 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -95,21 +95,7 @@ struct crb_priv {
 	u8 __iomem *rsp;
 };
 
-#ifdef CONFIG_PM_SLEEP
-static int crb_resume(struct device *dev)
-{
-	int rc;
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-
-	rc = tpm2_shutdown(chip, TPM2_SU_STATE);
-	if (!rc)
-		rc = tpm2_do_selftest(chip);
-
-	return rc;
-}
-#endif
-
-static SIMPLE_DEV_PM_OPS(crb_pm, tpm_pm_suspend, crb_resume);
+static SIMPLE_DEV_PM_OPS(crb_pm, tpm_pm_suspend, tpm_pm_resume);
 
 static u8 crb_status(struct tpm_chip *chip)
 {
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 6725bef..c105eb7 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -865,25 +865,23 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 static int tpm_tis_resume(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-	int ret = 0;
+	int ret;
 
 	if (chip->vendor.irq)
 		tpm_tis_reenable_interrupts(chip);
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
-		/* NOP if firmware properly does this. */
-		tpm2_startup(chip, TPM2_SU_STATE);
+	ret = tpm_pm_resume(dev);
+	if (ret)
+		return ret;
 
-		ret = tpm2_shutdown(chip, TPM2_SU_STATE);
-		if (!ret)
-			ret = tpm2_do_selftest(chip);
-	} else {
-		ret = tpm_pm_resume(dev);
-		if (!ret)
-			tpm_do_selftest(chip);
+	/* TPM 1.2 requires self-test on resume. */
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
+		ret = tpm_do_selftest(chip);
+		if (ret < 0)
+			return ret;
 	}
 
-	return ret;
+	return 0;
 }
 #endif
 
-- 
2.1.4

