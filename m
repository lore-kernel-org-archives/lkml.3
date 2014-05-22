Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaEVPSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:18:44 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:61143 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaEVPSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:18:41 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, chris@printf.net,
        ulf.hansson@linaro.org
Cc: peter.griffin@linaro.org, kernel@stlinux.com, lee.jones@linaro.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH 1/8] mmc: sdhci-st: Intial support for ST SDHCI controller
Date: Thu, 22 May 2014 16:18:15 +0100
Message-Id: <1400771902-26553-2-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform driver adds initial support for the SDHCI host controller
found on STMicroelectronics SoCs.

It has been tested on STiH41x b2020 platforms currently.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 drivers/mmc/host/Kconfig    |  12 +++
 drivers/mmc/host/Makefile   |   1 +
 drivers/mmc/host/sdhci-st.c | 244 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 257 insertions(+)
 create mode 100644 drivers/mmc/host/sdhci-st.c

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 8aaf8c1..b62c40d 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -283,6 +283,18 @@ config MMC_SDHCI_BCM2835
 
 	  If unsure, say N.
 
+config MMC_SDHCI_ST
+	tristate "SDHCI support on STMicroelectronics SoC"
+	depends on ARCH_STI
+	depends on MMC_SDHCI_PLTFM
+	select MMC_SDHCI_IO_ACCESSORS
+	help
+	  This selects the Secure Digital Host Controller Interface in
+	  STMicroelectronics SoCs.
+
+	  If you have a controller with this interface, say Y or M here.
+	  If unsure, say N.
+
 config MMC_OMAP
 	tristate "TI OMAP Multimedia Card Interface support"
 	depends on ARCH_OMAP
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 0c8aa5e..6e0acf7 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_MMC_SDHCI_OF_HLWD)		+= sdhci-of-hlwd.o
 obj-$(CONFIG_MMC_SDHCI_BCM_KONA)	+= sdhci-bcm-kona.o
 obj-$(CONFIG_MMC_SDHCI_BCM2835)		+= sdhci-bcm2835.o
 obj-$(CONFIG_MMC_SDHCI_MSM)		+= sdhci-msm.o
+obj-$(CONFIG_MMC_SDHCI_ST)		+= sdhci-st.o
 
 ifeq ($(CONFIG_CB710_DEBUG),y)
 	CFLAGS-cb710-mmc	+= -DDEBUG
diff --git a/drivers/mmc/host/sdhci-st.c b/drivers/mmc/host/sdhci-st.c
new file mode 100644
index 0000000..1790fa7
--- /dev/null
+++ b/drivers/mmc/host/sdhci-st.c
@@ -0,0 +1,244 @@
+/*
+ * Support for SDHCI on STMicroelectronics SoCs
+ *
+ * Copyright (C) 2014 STMicroelectronics Ltd
+ * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
+ *
+ * Based on sdhci-cns3xxx.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/of_gpio.h>
+#include <linux/mmc/host.h>
+#include <linux/reset.h>
+
+#include "sdhci-pltfm.h"
+
+struct st_mmc_platform_data {
+	struct  reset_control	*rstc;
+};
+
+static int sdhci_st_8bit_width(struct sdhci_host *host, int width)
+{
+	u8 ctrl;
+
+	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
+
+	switch (width) {
+	case MMC_BUS_WIDTH_8:
+		ctrl |= SDHCI_CTRL_8BITBUS;
+		ctrl &= ~SDHCI_CTRL_4BITBUS;
+		break;
+	case MMC_BUS_WIDTH_4:
+		ctrl |= SDHCI_CTRL_4BITBUS;
+		ctrl &= ~SDHCI_CTRL_8BITBUS;
+		break;
+	default:
+		ctrl &= ~(SDHCI_CTRL_8BITBUS | SDHCI_CTRL_4BITBUS);
+		break;
+	}
+
+	sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
+
+	return 0;
+}
+
+static unsigned int sdhci_st_get_max_clk(struct sdhci_host *host)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+
+	return clk_get_rate(pltfm_host->clk);
+}
+
+static u32 sdhci_st_readl(struct sdhci_host *host, int reg)
+{
+	u32 ret;
+
+	switch (reg) {
+	case SDHCI_CAPABILITIES:
+		ret = readl(host->ioaddr + reg);
+		/* Support 3.3V and 1.8V */
+		ret &= ~SDHCI_CAN_VDD_300;
+		break;
+	default:
+		ret = readl(host->ioaddr + reg);
+	}
+	return ret;
+}
+
+static const struct sdhci_ops sdhci_st_ops = {
+	.get_max_clock = sdhci_st_get_max_clk,
+	.platform_bus_width = sdhci_st_8bit_width,
+	.read_l = sdhci_st_readl,
+};
+
+static const struct sdhci_pltfm_data sdhci_st_pdata = {
+	.ops = &sdhci_st_ops,
+	.quirks = SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC |
+	    SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
+};
+
+
+static int sdhci_st_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct sdhci_host *host;
+	struct st_mmc_platform_data *pdata;
+	struct sdhci_pltfm_host *pltfm_host;
+	struct clk *clk;
+	int ret = 0;
+	u16 host_version;
+
+	dev_dbg(&pdev->dev, "SDHCI ST platform driver\n");
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	pdata->rstc = devm_reset_control_get(&pdev->dev, NULL);
+	if (IS_ERR(pdata->rstc))
+		pdata->rstc = NULL;
+	else
+		reset_control_deassert(pdata->rstc);
+
+	clk =  devm_clk_get(&pdev->dev, "mmc");
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "Perpheral clk not found\n");
+		return PTR_ERR(clk);
+	}
+
+	host = sdhci_pltfm_init(pdev, &sdhci_st_pdata, 0);
+	if (IS_ERR(host)) {
+		dev_err(&pdev->dev, "Failed sdhci_pltfm_init\n");
+		return PTR_ERR(host);
+	}
+
+	clk_prepare_enable(clk);
+
+	host->mmc->caps |= MMC_CAP_8_BIT_DATA | MMC_CAP_BUS_WIDTH_TEST
+			| MMC_CAP_1_8V_DDR;
+
+	if (of_property_read_bool(np, "non-removable"))
+		host->mmc->caps |= MMC_CAP_NONREMOVABLE;
+
+	pltfm_host = sdhci_priv(host);
+	pltfm_host->clk = clk;
+
+	ret = sdhci_add_host(host);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed sdhci_add_host\n");
+		goto err_out;
+	}
+
+	pltfm_host->priv = pdata;
+
+	platform_set_drvdata(pdev, host);
+
+	host_version = readw_relaxed((host->ioaddr + SDHCI_HOST_VERSION));
+
+	dev_dbg(&pdev->dev, "SDHCI ST Initialised: Host Version: 0x%x Vendor Version 0x%x\n",
+		host_version, ((host_version & SDHCI_VENDOR_VER_MASK) >>
+			       SDHCI_VENDOR_VER_SHIFT));
+
+	return 0;
+
+err_out:
+	clk_disable_unprepare(clk);
+	sdhci_pltfm_free(pdev);
+
+	return ret;
+}
+
+static int sdhci_st_remove(struct platform_device *pdev)
+{
+	struct sdhci_host *host = platform_get_drvdata(pdev);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct st_mmc_platform_data *pdata = pltfm_host->priv;
+	int ret;
+
+	clk_disable_unprepare(pltfm_host->clk);
+
+	ret = sdhci_pltfm_unregister(pdev);
+
+	if (pdata->rstc)
+		reset_control_assert(pdata->rstc);
+
+	return ret;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int sdhci_st_suspend(struct device *dev)
+{
+	struct sdhci_host *host = dev_get_drvdata(dev);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct st_mmc_platform_data *pdata = pltfm_host->priv;
+	int ret = sdhci_suspend_host(host);
+
+	if (ret)
+		goto out;
+
+	if (pdata->rstc)
+		reset_control_assert(pdata->rstc);
+
+	clk_disable_unprepare(pltfm_host->clk);
+out:
+	return ret;
+}
+
+static int sdhci_st_resume(struct device *dev)
+{
+	struct sdhci_host *host = dev_get_drvdata(dev);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct st_mmc_platform_data *pdata = pltfm_host->priv;
+
+	clk_prepare_enable(pltfm_host->clk);
+
+	if (pdata->rstc)
+		reset_control_deassert(pdata->rstc);
+
+	return sdhci_resume_host(host);
+}
+
+static SIMPLE_DEV_PM_OPS(sdhci_st_pmops, sdhci_st_suspend, sdhci_st_resume);
+#define SDHCI_ST_PMOPS (&sdhci_st_pmops)
+#else
+#define SDHCI_ST_PMOPS NULL
+#endif
+
+static const struct of_device_id st_sdhci_match[] = {
+	{ .compatible = "st,sdhci" },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, st_sdhci_match);
+
+static struct platform_driver sdhci_st_driver = {
+	.probe = sdhci_st_probe,
+	.remove = sdhci_st_remove,
+	.driver = {
+		   .name = "sdhci-st",
+		   .owner = THIS_MODULE,
+		   .pm = SDHCI_ST_PMOPS,
+		   .of_match_table = of_match_ptr(st_sdhci_match),
+		  },
+};
+
+module_platform_driver(sdhci_st_driver);
+
+MODULE_DESCRIPTION("SDHCI driver for STMicroelectronics SoCs");
+MODULE_AUTHOR("Giuseppe Cavallaro <peppe.cavallaro@st.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:st-sdhci");
-- 
1.9.1

