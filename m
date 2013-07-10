Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab3GJEKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 00:10:17 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:46588
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903Ab3GJEKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 00:10:14 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: rafael.j.wysocki@intel.com, bhelgaas@google.com, a.zummo@towertech.it,
        key@linux.vnet.ibm.com, mail@srajiv.net, tpmdd@selhorst.net,
        tpmdd@sirrix.com, matthew.garrett@nebula.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, tpmdd-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH 3/4] tpm: Convert tpm_tis driver to use dev_pm_ops from legacy pm_ops
Date: Tue,  9 Jul 2013 22:10:09 -0600
Message-Id: <1373429409-3944-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert drivers/char/tpm/tpm_tis.c to use dev_pm_ops instead of legacy pm_ops.
This patch depends on pnp driver bus ops change to invoke pnp_driver
dev_pm_ops.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/char/tpm/tpm_tis.c |   60 ++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 36 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 4519cb3..5796d01 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -766,6 +766,25 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 }
 #endif
 
+#ifdef CONFIG_PM_SLEEP
+static int tpm_tis_resume(struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	int ret;
+
+	if (chip->vendor.irq)
+		tpm_tis_reenable_interrupts(chip);
+
+	ret = tpm_pm_resume(dev);
+	if (!ret)
+		tpm_do_selftest(chip);
+
+	return ret;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
+
 #ifdef CONFIG_PNP
 static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 				      const struct pnp_device_id *pnp_id)
@@ -787,26 +806,6 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
 }
 
-static int tpm_tis_pnp_suspend(struct pnp_dev *dev, pm_message_t msg)
-{
-	return tpm_pm_suspend(&dev->dev);
-}
-
-static int tpm_tis_pnp_resume(struct pnp_dev *dev)
-{
-	struct tpm_chip *chip = pnp_get_drvdata(dev);
-	int ret;
-
-	if (chip->vendor.irq)
-		tpm_tis_reenable_interrupts(chip);
-
-	ret = tpm_pm_resume(&dev->dev);
-	if (!ret)
-		tpm_do_selftest(chip);
-
-	return ret;
-}
-
 static struct pnp_device_id tpm_pnp_tbl[] = {
 	{"PNP0C31", 0},		/* TPM */
 	{"ATM1200", 0},		/* Atmel */
@@ -835,9 +834,12 @@ static struct pnp_driver tis_pnp_driver = {
 	.name = "tpm_tis",
 	.id_table = tpm_pnp_tbl,
 	.probe = tpm_tis_pnp_init,
-	.suspend = tpm_tis_pnp_suspend,
-	.resume = tpm_tis_pnp_resume,
 	.remove = tpm_tis_pnp_remove,
+#ifdef CONFIG_PM_SLEEP
+	.driver	= {
+		.pm = &tpm_tis_pm,
+	},
+#endif
 };
 
 #define TIS_HID_USR_IDX sizeof(tpm_pnp_tbl)/sizeof(struct pnp_device_id) -2
@@ -846,20 +848,6 @@ module_param_string(hid, tpm_pnp_tbl[TIS_HID_USR_IDX].id,
 MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
 #endif
 
-#ifdef CONFIG_PM_SLEEP
-static int tpm_tis_resume(struct device *dev)
-{
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-
-	if (chip->vendor.irq)
-		tpm_tis_reenable_interrupts(chip);
-
-	return tpm_pm_resume(dev);
-}
-#endif
-
-static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
-
 static struct platform_driver tis_drv = {
 	.driver = {
 		.name = "tpm_tis",
-- 
1.7.10.4

