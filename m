Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaDPKQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:16:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:17683 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879AbaDPKQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:16:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,871,1389772800"; 
   d="scan'208";a="494059185"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] pwm_lpss: Add support for PCI devices
Date: Thu, 17 Apr 2014 02:18:58 +0800
Message-Id: <1397672338-3510-1-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Not all systems enumerate the PWM devices via ACPI. They can also be exposed
via the PCI interface.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
---
 drivers/pwm/pwm-lpss.c |  159 ++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 128 insertions(+), 31 deletions(-)

diff --git a/drivers/pwm/pwm-lpss.c b/drivers/pwm/pwm-lpss.c
index 449e372..aa8af08 100644
--- a/drivers/pwm/pwm-lpss.c
+++ b/drivers/pwm/pwm-lpss.c
@@ -6,6 +6,7 @@
  * Author: Chew Kean Ho <kean.ho.chew@intel.com>
  * Author: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
  * Author: Chew Chiau Ee <chiau.ee.chew@intel.com>
+ * Author: Alan Cox <alan@linux.intel.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -19,6 +20,9 @@
 #include <linux/module.h>
 #include <linux/pwm.h>
 #include <linux/platform_device.h>
+#include <linux/pci.h>
+
+static int pci_drv, plat_drv;	/* So we know which drivers registered */
 
 #define PWM				0x00000000
 #define PWM_ENABLE			BIT(31)
@@ -34,6 +38,15 @@ struct pwm_lpss_chip {
 	struct pwm_chip chip;
 	void __iomem *regs;
 	struct clk *clk;
+	unsigned long clk_rate;
+};
+
+struct pwm_lpss_boardinfo {
+	unsigned long clk_rate;
+};
+
+static const struct pwm_lpss_boardinfo byt_info = {
+	25000000
 };
 
 static inline struct pwm_lpss_chip *to_lpwm(struct pwm_chip *chip)
@@ -55,7 +68,7 @@ static int pwm_lpss_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	/* The equation is: base_unit = ((freq / c) * 65536) + correction */
 	base_unit = freq * 65536;
 
-	c = clk_get_rate(lpwm->clk);
+	c = lpwm->clk_rate;
 	if (!c)
 		return -EINVAL;
 
@@ -113,52 +126,47 @@ static const struct pwm_ops pwm_lpss_ops = {
 	.owner = THIS_MODULE,
 };
 
-static const struct acpi_device_id pwm_lpss_acpi_match[] = {
-	{ "80860F09", 0 },
-	{ },
-};
-MODULE_DEVICE_TABLE(acpi, pwm_lpss_acpi_match);
-
-static int pwm_lpss_probe(struct platform_device *pdev)
+static struct pwm_lpss_chip *pwm_lpss_probe(struct device *dev,
+			struct resource *r, struct pwm_lpss_boardinfo *info)
 {
 	struct pwm_lpss_chip *lpwm;
-	struct resource *r;
 	int ret;
 
-	lpwm = devm_kzalloc(&pdev->dev, sizeof(*lpwm), GFP_KERNEL);
+	lpwm = devm_kzalloc(dev, sizeof(*lpwm), GFP_KERNEL);
 	if (!lpwm)
-		return -ENOMEM;
-
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		return ERR_PTR(-ENOMEM);
 
-	lpwm->regs = devm_ioremap_resource(&pdev->dev, r);
+	lpwm->regs = devm_ioremap_resource(dev, r);
 	if (IS_ERR(lpwm->regs))
-		return PTR_ERR(lpwm->regs);
-
-	lpwm->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(lpwm->clk)) {
-		dev_err(&pdev->dev, "failed to get PWM clock\n");
-		return PTR_ERR(lpwm->clk);
+		return lpwm->regs;
+
+	if (info) {
+		lpwm->clk_rate = info->clk_rate;
+	} else {
+		lpwm->clk = devm_clk_get(dev, NULL);
+		if (IS_ERR(lpwm->clk)) {
+			dev_err(dev, "failed to get PWM clock\n");
+			return ERR_CAST(lpwm->clk);
+		}
+		lpwm->clk_rate = clk_get_rate(lpwm->clk);
 	}
 
-	lpwm->chip.dev = &pdev->dev;
+	lpwm->chip.dev = dev;
 	lpwm->chip.ops = &pwm_lpss_ops;
 	lpwm->chip.base = -1;
 	lpwm->chip.npwm = 1;
 
 	ret = pwmchip_add(&lpwm->chip);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to add PWM chip: %d\n", ret);
-		return ret;
+		dev_err(dev, "failed to add PWM chip: %d\n", ret);
+		return ERR_PTR(ret);
 	}
 
-	platform_set_drvdata(pdev, lpwm);
-	return 0;
+	return lpwm;
 }
 
-static int pwm_lpss_remove(struct platform_device *pdev)
+static int pwm_lpss_remove(struct pwm_lpss_chip *lpwm)
 {
-	struct pwm_lpss_chip *lpwm = platform_get_drvdata(pdev);
 	u32 ctrl;
 
 	ctrl = readl(lpwm->regs + PWM);
@@ -167,15 +175,104 @@ static int pwm_lpss_remove(struct platform_device *pdev)
 	return pwmchip_remove(&lpwm->chip);
 }
 
-static struct platform_driver pwm_lpss_driver = {
+static int pwm_lpss_probe_pci(struct pci_dev *pdev,
+			      const struct pci_device_id *id)
+{
+	struct pwm_lpss_boardinfo *info;
+	struct pwm_lpss_chip *lpwm;
+	int err;
+
+	err = pci_enable_device(pdev);
+	if (err < 0)
+		return err;
+
+	info =  (struct pwm_lpss_boardinfo *)id->driver_data;
+	lpwm = pwm_lpss_probe(&pdev->dev, &pdev->resource[0], info);
+	if (IS_ERR(lpwm))
+		return PTR_ERR(lpwm);
+
+	pci_set_drvdata(pdev, lpwm);
+	return 0;
+}
+
+static void pwm_lpss_remove_pci(struct pci_dev *pdev)
+{
+	struct pwm_lpss_chip *lpwm = pci_get_drvdata(pdev);
+
+	pwm_lpss_remove(lpwm);
+	pci_disable_device(pdev);
+}
+
+static struct pci_device_id pwm_lpss_pci_ids[] = {
+	{ PCI_VDEVICE(INTEL, 0x0f08), (unsigned long)&byt_info},
+	{ PCI_VDEVICE(INTEL, 0x0f09), (unsigned long)&byt_info},
+	{ },
+};
+MODULE_DEVICE_TABLE(pci, pwm_lpss_pci_ids);
+
+static struct pci_driver pwm_lpss_driver_pci = {
+	.name = "pwm-lpss",
+	.id_table = pwm_lpss_pci_ids,
+	.probe = pwm_lpss_probe_pci,
+	.remove = pwm_lpss_remove_pci,
+};
+
+static int pwm_lpss_probe_platform(struct platform_device *pdev)
+{
+	struct pwm_lpss_chip *lpwm;
+	struct resource *r;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	lpwm = pwm_lpss_probe(&pdev->dev, r, NULL);
+	if (IS_ERR(lpwm))
+		return PTR_ERR(lpwm);
+
+	platform_set_drvdata(pdev, lpwm);
+	return 0;
+}
+
+static int pwm_lpss_remove_platform(struct platform_device *pdev)
+{
+	struct pwm_lpss_chip *lpwm = platform_get_drvdata(pdev);
+
+	return pwm_lpss_remove(lpwm);
+}
+
+static const struct acpi_device_id pwm_lpss_acpi_match[] = {
+	{ "80860F09", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, pwm_lpss_acpi_match);
+
+static struct platform_driver pwm_lpss_driver_platform = {
 	.driver = {
 		.name = "pwm-lpss",
 		.acpi_match_table = pwm_lpss_acpi_match,
 	},
-	.probe = pwm_lpss_probe,
-	.remove = pwm_lpss_remove,
+	.probe = pwm_lpss_probe_platform,
+	.remove = pwm_lpss_remove_platform,
 };
-module_platform_driver(pwm_lpss_driver);
+
+static int __init pwm_init(void)
+{
+	pci_drv = pci_register_driver(&pwm_lpss_driver_pci);
+	plat_drv = platform_driver_register(&pwm_lpss_driver_platform);
+	if (pci_drv && plat_drv)
+		return pci_drv;
+
+	return 0;
+}
+module_init(pwm_init);
+
+static void __exit pwm_exit(void)
+{
+	if (!pci_drv)
+		pci_unregister_driver(&pwm_lpss_driver_pci);
+	if (!plat_drv)
+		platform_driver_unregister(&pwm_lpss_driver_platform);
+}
+module_exit(pwm_exit);
 
 MODULE_DESCRIPTION("PWM driver for Intel LPSS");
 MODULE_AUTHOR("Mika Westerberg <mika.westerberg@linux.intel.com>");
-- 
1.7.4.4

