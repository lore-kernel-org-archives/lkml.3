Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbaIIPgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:36:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51396 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704AbaIIPgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:36:51 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>
Cc: Kumar Gala <galak@codeaurora.org>, linux-ide@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v4 2/3] ata: Add Qualcomm ARM SoC AHCI SATA host controller driver
Date: Tue,  9 Sep 2014 10:36:47 -0500
Message-Id: <1410277008-20242-2-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1410277008-20242-1-git-send-email-galak@codeaurora.org>
References: <1410277008-20242-1-git-send-email-galak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Qualcomm AHCI SATA controller that exists on several
SoC and specifically the IPQ806x family of chips.  The IPQ806x SATA support
requires the associated IPQ806x SATA PHY Driver to be enabled as well.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
(reposted with Hans on list)

v4:
* Added simple PM ops implementation
* Added setting of pmalive clk

v3:
* Added comment about suspend/resume not supported
* Fixup ahci_platform_init_host for upstream change to interface
* cleanup error handling of rxoob clk, moved to devm_clk_get/put

v2:
* Fixed MODULE_LICENSE to be GPL v2

 drivers/ata/Kconfig     | 10 +++++
 drivers/ata/Makefile    |  1 +
 drivers/ata/ahci_qcom.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 110 insertions(+)
 create mode 100644 drivers/ata/ahci_qcom.c

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index e1b9278..165d2fa 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -133,6 +133,16 @@ config AHCI_MVEBU
 
 	  If unsure, say N.
 
+config AHCI_QCOM
+	tristate "Qualcomm AHCI SATA support"
+	depends on ARCH_QCOM
+	help
+	  This option enables support for AHCI SATA controller
+	  integrated into Qualcomm ARM SoC chipsets. For more
+	  information please refer to http://www.qualcomm.com/chipsets.
+
+	  If unsure, say N.
+
 config AHCI_SUNXI
 	tristate "Allwinner sunxi AHCI SATA support"
 	depends on ARCH_SUNXI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index ae41107..812435c 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
 obj-$(CONFIG_AHCI_DA850)	+= ahci_da850.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_MVEBU)	+= ahci_mvebu.o libahci.o libahci_platform.o
+obj-$(CONFIG_AHCI_QCOM)		+= ahci_qcom.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_ST)		+= ahci_st.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_TEGRA)	+= ahci_tegra.o libahci.o libahci_platform.o
diff --git a/drivers/ata/ahci_qcom.c b/drivers/ata/ahci_qcom.c
new file mode 100644
index 0000000..3da0c94
--- /dev/null
+++ b/drivers/ata/ahci_qcom.c
@@ -0,0 +1,99 @@
+/*
+ * Qualcomm ARM SoC AHCI SATA platform driver
+ *
+ * based on the AHCI SATA platform driver by Jeff Garzik and Anton Vorontsov
+ *
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/ahci_platform.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/libata.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+#include "ahci.h"
+
+static const struct ata_port_info qcom_ahci_port_info = {
+	.flags		= AHCI_FLAG_COMMON,
+	.pio_mask	= ATA_PIO4,
+	.udma_mask	= ATA_UDMA6,
+	.port_ops	= &ahci_platform_ops,
+};
+
+static int qcom_ahci_probe(struct platform_device *pdev)
+{
+	struct ahci_host_priv *hpriv;
+	struct clk *rxoob_clk, *pmalive_clk;
+	int rc;
+
+	hpriv = ahci_platform_get_resources(pdev);
+	if (IS_ERR(hpriv))
+		return PTR_ERR(hpriv);
+
+	/* Try and set the rxoob clk to 100Mhz */
+	rxoob_clk = of_clk_get_by_name(pdev->dev.of_node, "rxoob");
+	if (IS_ERR(rxoob_clk))
+		return PTR_ERR(rxoob_clk);
+
+	rc = clk_set_rate(rxoob_clk, 100000000);
+	if (rc)
+		return rc;
+
+	/* Try and set the pmalive clk to 100Mhz */
+	pmalive_clk = of_clk_get_by_name(pdev->dev.of_node, "pmalive");
+	if (IS_ERR(pmalive_clk))
+		return PTR_ERR(pmalive_clk);
+
+	rc = clk_set_rate(pmalive_clk, 100000000);
+	if (rc)
+		return rc;
+
+	rc = ahci_platform_enable_resources(hpriv);
+	if (rc)
+		return rc;
+
+	rc = ahci_platform_init_host(pdev, hpriv, &qcom_ahci_port_info);
+	if (rc)
+		goto disable_resources;
+
+	return 0;
+disable_resources:
+	ahci_platform_disable_resources(hpriv);
+	return rc;
+}
+
+static const struct of_device_id qcom_ahci_of_match[] = {
+	{ .compatible = "qcom,msm-ahci", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, qcom_ahci_of_match);
+
+static SIMPLE_DEV_PM_OPS(qcom_ahci_pm_ops, ahci_platform_suspend,
+			 ahci_platform_resume);
+
+static struct platform_driver qcom_ahci_driver = {
+	.probe = qcom_ahci_probe,
+	.remove = ata_platform_remove_one,
+	.driver = {
+		.name = "qcom_ahci_qcom",
+		.owner = THIS_MODULE,
+		.of_match_table = qcom_ahci_of_match,
+		.pm = &qcom_ahci_pm_ops,
+	},
+};
+module_platform_driver(qcom_ahci_driver);
+
+MODULE_DESCRIPTION("Qualcomm AHCI SATA platform driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("ahci:qcom");
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

