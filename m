Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaFDQbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:31:11 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62636 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbaFDQbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:31:07 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        chris@printf.net, ulf.hansson@linaro.org, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com
Cc: peter.griffin@linaro.org, kernel@stlinux.com, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH v3 01/10] mmc: sdhci-st: Intial support for ST SDHCI controller
Date: Wed,  4 Jun 2014 17:30:15 +0100
Message-Id: <1401899424-1365-2-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org>
References: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform driver adds initial support for the SDHCI host controller
found on STMicroelectronics SoCs.

It has been tested on STiH41x b2020 platforms currently.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 drivers/mmc/host/Kconfig    |  12 +++
 drivers/mmc/host/Makefile   |   1 +
 drivers/mmc/host/sdhci-st.c | 201 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 214 insertions(+)
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
index 0000000..f321472
--- /dev/null
+++ b/drivers/mmc/host/sdhci-st.c
@@ -0,0 +1,201 @@
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
+#include <linux/mmc/host.h>
+
+#include "sdhci-pltfm.h"
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
+	}
+
+	sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
+
+	return 0;
+}
+
+static u32 sdhci_st_readl(struct sdhci_host *host, int reg)
+{
+	u32 ret;
+
+	switch (reg) {
+	case SDHCI_CAPABILITIES:
+		ret = readl_relaxed(host->ioaddr + reg);
+		/* Support 3.3V and 1.8V */
+		ret &= ~SDHCI_CAN_VDD_300;
+		break;
+	default:
+		ret = readl_relaxed(host->ioaddr + reg);
+	}
+	return ret;
+}
+
+static const struct sdhci_ops sdhci_st_ops = {
+	.get_max_clock = sdhci_pltfm_clk_get_max_clock,
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
+	struct sdhci_host *host;
+	struct sdhci_pltfm_host *pltfm_host;
+	struct clk *clk;
+	int ret = 0;
+	u16 host_version;
+
+	clk =  devm_clk_get(&pdev->dev, "mmc");
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "Peripheral clk not found\n");
+		return PTR_ERR(clk);
+	}
+
+	host = sdhci_pltfm_init(pdev, &sdhci_st_pdata, 0);
+	if (IS_ERR(host)) {
+		dev_err(&pdev->dev, "Failed sdhci_pltfm_init\n");
+		return PTR_ERR(host);
+	}
+
+	ret = mmc_of_parse(host->mmc);
+
+	if (ret) {
+		dev_err(&pdev->dev, "Failed mmc_of_parse\n");
+		return ret;
+	}
+
+	clk_prepare_enable(clk);
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
+	platform_set_drvdata(pdev, host);
+
+	host_version = readw_relaxed((host->ioaddr + SDHCI_HOST_VERSION));
+
+	dev_info(&pdev->dev, "SDHCI ST Initialised: Host Version: 0x%x Vendor Version 0x%x\n",
+		((host_version & SDHCI_SPEC_VER_MASK) >> SDHCI_SPEC_VER_SHIFT),
+		((host_version & SDHCI_VENDOR_VER_MASK) >>
+		SDHCI_VENDOR_VER_SHIFT));
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
+	int ret;
+
+	clk_disable_unprepare(pltfm_host->clk);
+
+	ret = sdhci_pltfm_unregister(pdev);
+
+	return ret;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int sdhci_st_suspend(struct device *dev)
+{
+	struct sdhci_host *host = dev_get_drvdata(dev);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	int ret = sdhci_suspend_host(host);
+
+	if (ret)
+		goto out;
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
+
+	clk_prepare_enable(pltfm_host->clk);
+
+	return sdhci_resume_host(host);
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(sdhci_st_pmops, sdhci_st_suspend, sdhci_st_resume);
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
+		   .pm = &sdhci_st_pmops,
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

