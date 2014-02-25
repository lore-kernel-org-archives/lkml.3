Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaBYLl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:41:57 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:60749 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaBYLlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:41:52 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, DCG_UPD_stlinux_kernel@list.st.com,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH v2 3/3] ahci: st: Add support for ST's SATA IP
Date: Tue, 25 Feb 2014 11:41:21 +0000
Message-Id: <1393328481-7251-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393328481-7251-1-git-send-email-lee.jones@linaro.org>
References: <1393328481-7251-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org
Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/ata/Kconfig   |   9 ++
 drivers/ata/Makefile  |   1 +
 drivers/ata/ahci_st.c | 250 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 260 insertions(+)
 create mode 100644 drivers/ata/ahci_st.c

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 96176f4..968ca2f 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -98,6 +98,15 @@ config SATA_AHCI_PLATFORM
 
 	  If unsure, say N.
 
+config SATA_AHCI_ST
+	tristate "ST SATA support"
+	depends on SATA_AHCI_PLATFORM
+	select GENERIC_PHY
+	help
+	  This option enables support for ST SATA controller.
+
+	  If unsure, say N.
+
 config AHCI_IMX
 	tristate "Freescale i.MX AHCI SATA support"
 	depends on SATA_AHCI_PLATFORM && MFD_SYSCON
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 246050b..6bbd6da 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_ATA)		+= libata.o
 obj-$(CONFIG_SATA_AHCI)		+= ahci.o libahci.o
 obj-$(CONFIG_SATA_ACARD_AHCI)	+= acard-ahci.o libahci.o
 obj-$(CONFIG_SATA_AHCI_PLATFORM) += ahci_platform.o libahci.o
+obj-$(CONFIG_SATA_AHCI_ST)      += ahci_st.o
 obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
 obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
 obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
diff --git a/drivers/ata/ahci_st.c b/drivers/ata/ahci_st.c
new file mode 100644
index 0000000..91887a0
--- /dev/null
+++ b/drivers/ata/ahci_st.c
@@ -0,0 +1,250 @@
+/*
+ * Copyright (C) 2012 STMicroelectronics Limited
+ *
+ * Authors: Francesco Virlinzi <francesco.virlinzi@st.com>
+ *	    Alexandre Torgue <alexandre.torgue@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/export.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/ahci_platform.h>
+#include <linux/phy/phy.h>
+#include <linux/libata.h>
+#include <linux/reset.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+
+#include "ahci.h"
+
+#define ST_AHCI_OOBR			0xbc
+#define ST_AHCI_OOBR_WE			BIT(31)
+#define ST_AHCI_OOBR_CWMIN_SHIFT	24
+#define ST_AHCI_OOBR_CWMAX_SHIFT	16
+#define ST_AHCI_OOBR_CIMIN_SHIFT	8
+#define ST_AHCI_OOBR_CIMAX_SHIFT	0
+
+struct st_ahci_drv_data {
+	struct platform_device *ahci;
+	struct phy *phy;
+	struct reset_control *pwr;
+	struct reset_control *sw_rst;
+	struct reset_control *pwr_rst;
+	struct ahci_host_priv *hpriv;
+};
+
+static void st_ahci_configure_oob(void __iomem *mmio)
+{
+	unsigned long old_val, new_val;
+
+	new_val = (0x02 << ST_AHCI_OOBR_CWMIN_SHIFT) |
+		  (0x04 << ST_AHCI_OOBR_CWMAX_SHIFT) |
+		  (0x08 << ST_AHCI_OOBR_CIMIN_SHIFT) |
+		  (0x0C << ST_AHCI_OOBR_CIMAX_SHIFT);
+
+	old_val = readl(mmio + ST_AHCI_OOBR);
+	writel(old_val | ST_AHCI_OOBR_WE, mmio + ST_AHCI_OOBR);
+	writel(new_val | ST_AHCI_OOBR_WE, mmio + ST_AHCI_OOBR);
+	writel(new_val, mmio + ST_AHCI_OOBR);
+}
+
+static int st_ahci_deassert_resets(struct device *dev)
+{
+	struct st_ahci_drv_data *drv_data = dev_get_drvdata(dev);
+	int err;
+
+	if (drv_data->pwr) {
+		err = reset_control_deassert(drv_data->pwr);
+		if (err) {
+			dev_err(dev, "unable to bring out of pwrdwn\n");
+			return err;
+		}
+	}
+
+	st_ahci_configure_oob(drv_data->hpriv->mmio);
+
+	if (drv_data->sw_rst) {
+		err = reset_control_deassert(drv_data->sw_rst);
+		if (err) {
+			dev_err(dev, "unable to bring out of sw-rst\n");
+			return err;
+		}
+	}
+
+	if (drv_data->pwr_rst) {
+		err = reset_control_deassert(drv_data->pwr_rst);
+		if (err) {
+			dev_err(dev, "unable to bring out of pwr-rst\n");
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int st_ahci_probe_resets(struct platform_device *pdev)
+{
+	struct st_ahci_drv_data *drv_data = platform_get_drvdata(pdev);
+
+	drv_data->pwr = devm_reset_control_get(&pdev->dev, "pwr-dwn");
+	if (IS_ERR(drv_data->pwr)) {
+		dev_info(&pdev->dev, "power reset control not defined\n");
+		drv_data->pwr = NULL;
+	}
+
+	drv_data->sw_rst = devm_reset_control_get(&pdev->dev, "sw-rst");
+	if (IS_ERR(drv_data->sw_rst)) {
+		dev_info(&pdev->dev, "soft reset control not defined\n");
+		drv_data->sw_rst = NULL;
+	}
+
+	drv_data->pwr_rst = devm_reset_control_get(&pdev->dev, "pwr-rst");
+	if (IS_ERR(drv_data->pwr_rst)) {
+		dev_dbg(&pdev->dev, "power soft reset control not defined\n");
+		drv_data->pwr_rst = NULL;
+	}
+
+	return st_ahci_deassert_resets(&pdev->dev);
+}
+
+static const struct ata_port_info st_ahci_port_info = {
+	.flags          = AHCI_FLAG_COMMON,
+	.pio_mask       = ATA_PIO4,
+	.udma_mask      = ATA_UDMA6,
+	.port_ops       = &ahci_platform_ops,
+};
+
+static int st_ahci_probe(struct platform_device *pdev)
+{
+	struct st_ahci_drv_data *drv_data;
+	struct ahci_host_priv *hpriv;
+	int err;
+
+	drv_data = devm_kzalloc(&pdev->dev, sizeof(*drv_data), GFP_KERNEL);
+	if (!drv_data)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, drv_data);
+
+	hpriv = ahci_platform_get_resources(pdev);
+	if (IS_ERR(hpriv))
+		return PTR_ERR(hpriv);
+
+	drv_data->hpriv = hpriv;
+
+	err = st_ahci_probe_resets(pdev);
+	if (err)
+		goto put_resources;
+
+	err = ahci_platform_enable_resources(hpriv);
+	if (err)
+		goto put_resources;
+
+	err = ahci_platform_init_host(pdev, hpriv, &st_ahci_port_info, 0, 0);
+	if (err)
+		goto disable_resources;
+
+	return 0;
+
+disable_resources:
+       ahci_platform_disable_resources(hpriv);
+put_resources:
+       ahci_platform_put_resources(&pdev->dev, hpriv);
+
+       return err;
+}
+
+static int st_ahci_remove(struct platform_device *pdev)
+{
+	struct st_ahci_drv_data *drv_data = platform_get_drvdata(pdev);
+	struct ahci_host_priv *hpriv = drv_data->hpriv;
+	int err;
+
+	if (drv_data->pwr) {
+		err = reset_control_assert(drv_data->pwr);
+		if (err)
+			dev_err(&pdev->dev, "unable to pwrdwn\n");
+	}
+
+	ahci_platform_disable_resources(hpriv);
+	ahci_platform_put_resources(&pdev->dev, hpriv);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int st_ahci_suspend(struct device *dev)
+{
+	struct st_ahci_drv_data *drv_data = dev_get_drvdata(dev);
+	struct ahci_host_priv *hpriv = drv_data->hpriv;
+	int err;
+
+	if (drv_data->pwr) {
+		err = reset_control_assert(drv_data->pwr);
+		if (err) {
+			dev_err(dev, "unable to pwrdwn");
+			return err;
+		}
+	}
+
+	ahci_platform_disable_resources(hpriv);
+
+	return 0;
+}
+
+static int st_ahci_resume(struct device *dev)
+{
+	struct st_ahci_drv_data *drv_data = dev_get_drvdata(dev);
+	struct ahci_host_priv *hpriv = drv_data->hpriv;
+	int err;
+
+	err = ahci_platform_enable_resources(hpriv);
+	if (err)
+		goto put_resources;
+
+	err = st_ahci_deassert_resets(dev);
+	if (err)
+		goto disable_resources;
+
+	return 0;
+
+disable_resources:
+       ahci_platform_disable_resources(hpriv);
+put_resources:
+       ahci_platform_put_resources(dev, hpriv);
+
+       return err;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(st_ahci_pm_ops, st_ahci_suspend, st_ahci_resume);
+
+static struct of_device_id st_ahci_match[] = {
+	{ .compatible = "st,ahci", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, st_ahci_match);
+
+static struct platform_driver st_ahci_driver = {
+	.driver = {
+		.name = "st_ahci",
+		.owner = THIS_MODULE,
+		.pm = &st_ahci_pm_ops,
+		.of_match_table = of_match_ptr(st_ahci_match),
+	},
+	.probe = st_ahci_probe,
+	.remove = st_ahci_remove,
+};
+module_platform_driver(st_ahci_driver);
+
+MODULE_AUTHOR("Alexandre Torgue <alexandre.torgue@st.com>");
+MODULE_AUTHOR("Francesco Virlinzi <francesco.virlinzi@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics Sata Ahci driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.3.2

