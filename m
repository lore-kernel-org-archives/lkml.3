Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbaCJPiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:38:13 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:51811 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbaCJPhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:37:33 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org, ulf.hansson@linaro.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v11 2/3] mmc: sdhci-msm: Initial support for Qualcomm chipsets
Date: Mon, 10 Mar 2014 17:37:12 +0200
Message-Id: <1394465833-22581-3-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394465833-22581-1-git-send-email-gdjakov@mm-sol.com>
References: <1394465833-22581-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform driver adds the initial support of Secure
Digital Host Controller Interface compliant controller
found in Qualcomm chipsets.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Tested-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 drivers/mmc/host/Kconfig     |   13 +++
 drivers/mmc/host/Makefile    |    1 +
 drivers/mmc/host/sdhci-msm.c |  208 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 222 insertions(+)
 create mode 100644 drivers/mmc/host/sdhci-msm.c

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 82cc34d..66ef8b9 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -334,6 +334,19 @@ config MMC_ATMELMCI
 
 	  If unsure, say N.
 
+config MMC_SDHCI_MSM
+	tristate "Qualcomm SDHCI Controller Support"
+	depends on ARCH_QCOM
+	depends on MMC_SDHCI_PLTFM
+	help
+	  This selects the Secure Digital Host Controller Interface (SDHCI)
+	  support present in Qualcomm SOCs. The controller supports
+	  SD/MMC/SDIO devices.
+
+	  If you have a controller with this interface, say Y or M here.
+
+	  If unsure, say N.
+
 config MMC_MSM
 	tristate "Qualcomm SDCC Controller Support"
 	depends on MMC && (ARCH_MSM7X00A || ARCH_MSM7X30 || ARCH_QSD8X50)
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index f162f87a0..0c8aa5e 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_MMC_SDHCI_OF_ESDHC)	+= sdhci-of-esdhc.o
 obj-$(CONFIG_MMC_SDHCI_OF_HLWD)		+= sdhci-of-hlwd.o
 obj-$(CONFIG_MMC_SDHCI_BCM_KONA)	+= sdhci-bcm-kona.o
 obj-$(CONFIG_MMC_SDHCI_BCM2835)		+= sdhci-bcm2835.o
+obj-$(CONFIG_MMC_SDHCI_MSM)		+= sdhci-msm.o
 
 ifeq ($(CONFIG_CB710_DEBUG),y)
 	CFLAGS-cb710-mmc	+= -DDEBUG
diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
new file mode 100644
index 0000000..3b0606f
--- /dev/null
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -0,0 +1,208 @@
+/*
+ * drivers/mmc/host/sdhci-msm.c - Qualcomm SDHCI Platform driver
+ *
+ * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/delay.h>
+
+#include "sdhci-pltfm.h"
+
+#define CORE_HC_MODE		0x78
+#define HC_MODE_EN		0x1
+#define CORE_POWER		0x0
+#define CORE_SW_RST		BIT(7)
+
+
+struct sdhci_msm_host {
+	struct platform_device *pdev;
+	void __iomem *core_mem;	/* MSM SDCC mapped address */
+	struct clk *clk;	/* main SD/MMC bus clock */
+	struct clk *pclk;	/* SDHC peripheral bus clock */
+	struct clk *bus_clk;	/* SDHC bus voter clock */
+	struct mmc_host *mmc;
+	struct sdhci_pltfm_data sdhci_msm_pdata;
+};
+
+/* Platform specific tuning */
+static int sdhci_msm_execute_tuning(struct sdhci_host *host, u32 opcode)
+{
+	/*
+	 * Tuning is required for SDR104, HS200 and HS400 cards and if the clock
+	 * frequency greater than 100MHz in those modes. The standard tuning
+	 * procedure should not be executed, but a custom implementation will be
+	 * added here instead.
+	 */
+	return 0;
+}
+
+static const struct of_device_id sdhci_msm_dt_match[] = {
+	{ .compatible = "qcom,sdhci-msm-v4" },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, sdhci_msm_dt_match);
+
+static struct sdhci_ops sdhci_msm_ops = {
+	.platform_execute_tuning = sdhci_msm_execute_tuning,
+};
+
+static int sdhci_msm_probe(struct platform_device *pdev)
+{
+	struct sdhci_host *host;
+	struct sdhci_pltfm_host *pltfm_host;
+	struct sdhci_msm_host *msm_host;
+	struct resource *core_memres;
+	int ret;
+	u16 host_version;
+
+	msm_host = devm_kzalloc(&pdev->dev, sizeof(*msm_host), GFP_KERNEL);
+	if (!msm_host)
+		return -ENOMEM;
+
+	msm_host->sdhci_msm_pdata.ops = &sdhci_msm_ops;
+	host = sdhci_pltfm_init(pdev, &msm_host->sdhci_msm_pdata, 0);
+	if (IS_ERR(host))
+		return PTR_ERR(host);
+
+	pltfm_host = sdhci_priv(host);
+	pltfm_host->priv = msm_host;
+	msm_host->mmc = host->mmc;
+	msm_host->pdev = pdev;
+
+	ret = mmc_of_parse(host->mmc);
+	if (ret)
+		goto pltfm_free;
+
+	sdhci_get_of_property(pdev);
+
+	/* Setup SDCC bus voter clock. */
+	msm_host->bus_clk = devm_clk_get(&pdev->dev, "bus");
+	if (!IS_ERR(msm_host->bus_clk)) {
+		/* Vote for max. clk rate for max. performance */
+		ret = clk_set_rate(msm_host->bus_clk, INT_MAX);
+		if (ret)
+			goto pltfm_free;
+		ret = clk_prepare_enable(msm_host->bus_clk);
+		if (ret)
+			goto pltfm_free;
+	}
+
+	/* Setup main peripheral bus clock */
+	msm_host->pclk = devm_clk_get(&pdev->dev, "iface");
+	if (IS_ERR(msm_host->pclk)) {
+		ret = PTR_ERR(msm_host->pclk);
+		dev_err(&pdev->dev, "Perpheral clk setup failed (%d)\n", ret);
+		goto bus_clk_disable;
+	}
+
+	ret = clk_prepare_enable(msm_host->pclk);
+	if (ret)
+		goto bus_clk_disable;
+
+	/* Setup SDC MMC clock */
+	msm_host->clk = devm_clk_get(&pdev->dev, "core");
+	if (IS_ERR(msm_host->clk)) {
+		ret = PTR_ERR(msm_host->clk);
+		dev_err(&pdev->dev, "SDC MMC clk setup failed (%d)\n", ret);
+		goto pclk_disable;
+	}
+
+	ret = clk_prepare_enable(msm_host->clk);
+	if (ret)
+		goto pclk_disable;
+
+	core_memres = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	msm_host->core_mem = devm_ioremap_resource(&pdev->dev, core_memres);
+
+	if (IS_ERR(msm_host->core_mem)) {
+		dev_err(&pdev->dev, "Failed to remap registers\n");
+		ret = PTR_ERR(msm_host->core_mem);
+		goto clk_disable;
+	}
+
+	/* Reset the core and Enable SDHC mode */
+	writel_relaxed(readl_relaxed(msm_host->core_mem + CORE_POWER) |
+		       CORE_SW_RST, msm_host->core_mem + CORE_POWER);
+
+	/* SW reset can take upto 10HCLK + 15MCLK cycles. (min 40us) */
+	usleep_range(1000, 5000);
+	if (readl(msm_host->core_mem + CORE_POWER) & CORE_SW_RST) {
+		dev_err(&pdev->dev, "Stuck in reset\n");
+		ret = -ETIMEDOUT;
+		goto clk_disable;
+	}
+
+	/* Set HC_MODE_EN bit in HC_MODE register */
+	writel_relaxed(HC_MODE_EN, (msm_host->core_mem + CORE_HC_MODE));
+
+	host->quirks |= SDHCI_QUIRK_BROKEN_CARD_DETECTION;
+	host->quirks |= SDHCI_QUIRK_SINGLE_POWER_WRITE;
+
+	host_version = readw_relaxed((host->ioaddr + SDHCI_HOST_VERSION));
+	dev_dbg(&pdev->dev, "Host Version: 0x%x Vendor Version 0x%x\n",
+		host_version, ((host_version & SDHCI_VENDOR_VER_MASK) >>
+			       SDHCI_VENDOR_VER_SHIFT));
+
+	ret = sdhci_add_host(host);
+	if (ret)
+		goto clk_disable;
+
+	return 0;
+
+clk_disable:
+	clk_disable_unprepare(msm_host->clk);
+pclk_disable:
+	clk_disable_unprepare(msm_host->pclk);
+bus_clk_disable:
+	if (!IS_ERR(msm_host->bus_clk))
+		clk_disable_unprepare(msm_host->bus_clk);
+pltfm_free:
+	sdhci_pltfm_free(pdev);
+	return ret;
+}
+
+static int sdhci_msm_remove(struct platform_device *pdev)
+{
+	struct sdhci_host *host = platform_get_drvdata(pdev);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_msm_host *msm_host = pltfm_host->priv;
+	int dead = (readl_relaxed(host->ioaddr + SDHCI_INT_STATUS) ==
+		    0xffffffff);
+
+	sdhci_remove_host(host, dead);
+	sdhci_pltfm_free(pdev);
+	clk_disable_unprepare(msm_host->clk);
+	clk_disable_unprepare(msm_host->pclk);
+	if (!IS_ERR(msm_host->bus_clk))
+		clk_disable_unprepare(msm_host->bus_clk);
+	return 0;
+}
+
+static struct platform_driver sdhci_msm_driver = {
+	.probe = sdhci_msm_probe,
+	.remove = sdhci_msm_remove,
+	.driver = {
+		   .name = "sdhci_msm",
+		   .owner = THIS_MODULE,
+		   .of_match_table = sdhci_msm_dt_match,
+	},
+};
+
+module_platform_driver(sdhci_msm_driver);
+
+MODULE_DESCRIPTION("Qualcomm Secure Digital Host Controller Interface driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

