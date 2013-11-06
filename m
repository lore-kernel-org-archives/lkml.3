Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab3KFQDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:03:42 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:47227 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab3KFQDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:03:09 -0500
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Nov 2013 11:03:08 EST
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, subhashj@codeaurora.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v7 2/2] mmc: sdhci-msm: Initial support for MSM chipsets
Date: Wed,  6 Nov 2013 17:56:45 +0200
Message-Id: <1383753405-23631-3-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383753405-23631-1-git-send-email-gdjakov@mm-sol.com>
References: <1383753405-23631-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform driver adds the initial support of Secure
Digital Host Controller Interface compliant controller
found in Qualcomm MSM chipsets.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 drivers/mmc/host/Kconfig     |   13 +
 drivers/mmc/host/Makefile    |    1 +
 drivers/mmc/host/sdhci-msm.c |  651 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 665 insertions(+)
 create mode 100644 drivers/mmc/host/sdhci-msm.c

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 7fc5099..e8da488 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -322,6 +322,19 @@ config MMC_ATMELMCI
 
 	  If unsure, say N.
 
+config MMC_SDHCI_MSM
+	tristate "Qualcomm SDHCI Controller Support"
+	depends on ARCH_MSM
+	depends on MMC_SDHCI_PLTFM
+	help
+	  This selects the Secure Digital Host Controller Interface (SDHCI)
+	  support present in MSM SOCs from Qualcomm. The controller
+	  supports SD/MMC/SDIO devices.
+
+	  If you have a controller with this interface, say Y or M here.
+
+	  If unsure, say N.
+
 config MMC_MSM
 	tristate "Qualcomm SDCC Controller Support"
 	depends on MMC && ARCH_MSM
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index c41d0c3..5faed14 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_MMC_SDHCI_OF_ESDHC)	+= sdhci-of-esdhc.o
 obj-$(CONFIG_MMC_SDHCI_OF_HLWD)		+= sdhci-of-hlwd.o
 obj-$(CONFIG_MMC_SDHCI_BCM_KONA)	+= sdhci-bcm-kona.o
 obj-$(CONFIG_MMC_SDHCI_BCM2835)		+= sdhci-bcm2835.o
+obj-$(CONFIG_MMC_SDHCI_MSM)		+= sdhci-msm.o
 
 ifeq ($(CONFIG_CB710_DEBUG),y)
 	CFLAGS-cb710-mmc	+= -DDEBUG
diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
new file mode 100644
index 0000000..57eba64
--- /dev/null
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -0,0 +1,651 @@
+/*
+ * drivers/mmc/host/sdhci-msm.c - Qualcomm MSM SDHCI Platform
+ * driver source file
+ *
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
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
+
+#define CORE_POWER		0x0
+#define CORE_SW_RST		BIT(7)
+
+#define CORE_PWRCTL_STATUS	0xdc
+#define CORE_PWRCTL_MASK	0xe0
+#define CORE_PWRCTL_CLEAR	0xe4
+#define CORE_PWRCTL_CTL		0xe8
+
+#define CORE_PWRCTL_BUS_OFF	BIT(0)
+#define CORE_PWRCTL_BUS_ON	BIT(1)
+#define CORE_PWRCTL_IO_LOW	BIT(2)
+#define CORE_PWRCTL_IO_HIGH	BIT(3)
+
+#define CORE_PWRCTL_BUS_SUCCESS	BIT(0)
+#define CORE_PWRCTL_BUS_FAIL	BIT(1)
+#define CORE_PWRCTL_IO_SUCCESS	BIT(2)
+#define CORE_PWRCTL_IO_FAIL	BIT(3)
+
+#define INT_MASK		0xf
+
+
+/* This structure keeps information per regulator */
+struct sdhci_msm_reg_data {
+	struct regulator *reg;
+	const char *name;
+	/* Voltage level values */
+	u32 low_vol_level;
+	u32 high_vol_level;
+	/* Load values for low power and high power mode */
+	u32 lpm_uA;
+	u32 hpm_uA;
+	/* Regulator should be kept in low power mode */
+	bool lpm_sup;
+};
+
+struct sdhci_msm_pltfm_data {
+	u32 caps;				/* Supported UHS-I Modes */
+	u32 caps2;				/* More capabilities */
+	struct sdhci_msm_reg_data vdd;		/* VDD/VCC regulator info */
+	struct sdhci_msm_reg_data vdd_io;	/* VDD IO regulator info */
+};
+
+struct sdhci_msm_host {
+	struct platform_device *pdev;
+	void __iomem *core_mem;	/* MSM SDCC mapped address */
+	int pwr_irq;		/* power irq */
+	struct clk *clk;	/* main SD/MMC bus clock */
+	struct clk *pclk;	/* SDHC peripheral bus clock */
+	struct clk *bus_clk;	/* SDHC bus voter clock */
+	struct sdhci_msm_pltfm_data pdata;
+	struct mmc_host *mmc;
+	struct sdhci_pltfm_data sdhci_msm_pdata;
+};
+
+/* MSM platform specific tuning */
+int sdhci_msm_execute_tuning(struct sdhci_host *host, u32 opcode)
+{
+	return 0;
+}
+
+#define MAX_PROP_SIZE 32
+static int sdhci_msm_dt_parse_vreg_info(struct device *dev,
+					struct sdhci_msm_reg_data *vreg,
+					const char *vreg_name)
+{
+	int len;
+	const __be32 *prop;
+	char prop_name[MAX_PROP_SIZE];
+	struct device_node *np = dev->of_node;
+
+	snprintf(prop_name, MAX_PROP_SIZE, "%s-supply", vreg_name);
+	if (!of_parse_phandle(np, prop_name, 0)) {
+		dev_info(dev, "No vreg data found for %s\n", vreg_name);
+		return -EINVAL;
+	}
+
+	vreg->name = vreg_name;
+
+	snprintf(prop_name, MAX_PROP_SIZE, "qcom,%s-lpm-sup", vreg_name);
+	if (of_get_property(np, prop_name, NULL))
+		vreg->lpm_sup = true;
+
+	snprintf(prop_name, MAX_PROP_SIZE, "qcom,%s-voltage-level", vreg_name);
+	prop = of_get_property(np, prop_name, &len);
+	if (!prop || (len != (2 * sizeof(__be32)))) {
+		dev_warn(dev, "%s %s property\n",
+		prop ? "invalid format" : "no", prop_name);
+	} else {
+		vreg->low_vol_level = be32_to_cpup(&prop[0]);
+		vreg->high_vol_level = be32_to_cpup(&prop[1]);
+	}
+
+	snprintf(prop_name, MAX_PROP_SIZE, "qcom,%s-current-level", vreg_name);
+	prop = of_get_property(np, prop_name, &len);
+	if (!prop || (len != (2 * sizeof(__be32)))) {
+		dev_warn(dev, "%s %s property\n",
+			 prop ? "invalid format" : "no", prop_name);
+	} else {
+		vreg->lpm_uA = be32_to_cpup(&prop[0]);
+		vreg->hpm_uA = be32_to_cpup(&prop[1]);
+	}
+
+	dev_dbg(dev, "%s: %svol=[%d %d]uV, curr=[%d %d]uA\n", vreg->name,
+		vreg->lpm_sup ? "lpm_sup, " : "", vreg->low_vol_level,
+		vreg->high_vol_level, vreg->lpm_uA, vreg->hpm_uA);
+
+	return 0;
+}
+
+/* Parse devicetree data */
+static int sdhci_msm_populate_pdata(struct device *dev,
+					struct sdhci_msm_pltfm_data *pdata)
+{
+	struct device_node *np = dev->of_node;
+	int len, i;
+
+	if (sdhci_msm_dt_parse_vreg_info(dev, &pdata->vdd, "vdd")) {
+		dev_err(dev, "failed parsing vdd data\n");
+		return -EINVAL;
+	}
+	if (sdhci_msm_dt_parse_vreg_info(dev, &pdata->vdd_io, "vdd-io")) {
+		dev_err(dev, "failed parsing vdd-io data\n");
+		return -EINVAL;
+	}
+
+	len = of_property_count_strings(np, "qcom,bus-speed-mode");
+
+	for (i = 0; i < len; i++) {
+		const char *name = NULL;
+
+		of_property_read_string_index(np,
+					"qcom,bus-speed-mode", i, &name);
+		if (!name)
+			continue;
+
+		if (!strncmp(name, "HS200_1p8v", sizeof("HS200_1p8v")))
+			pdata->caps2 |= MMC_CAP2_HS200_1_8V_SDR;
+		else if (!strncmp(name, "HS200_1p2v", sizeof("HS200_1p2v")))
+			pdata->caps2 |= MMC_CAP2_HS200_1_2V_SDR;
+		else if (!strncmp(name, "DDR_1p8v", sizeof("DDR_1p8v")))
+			pdata->caps |= MMC_CAP_1_8V_DDR | MMC_CAP_UHS_DDR50;
+		else if (!strncmp(name, "DDR_1p2v", sizeof("DDR_1p2v")))
+			pdata->caps |= MMC_CAP_1_2V_DDR | MMC_CAP_UHS_DDR50;
+	}
+
+	return 0;
+}
+
+/* Regulator utility functions */
+static int sdhci_msm_vreg_init_reg(struct device *dev,
+				   struct sdhci_msm_reg_data *vreg)
+{
+	vreg->reg = devm_regulator_get(dev, vreg->name);
+	if (IS_ERR(vreg->reg))
+		return PTR_ERR(vreg->reg);
+
+	/* sanity check */
+	if (!vreg->high_vol_level || !vreg->low_vol_level
+		|| vreg->low_vol_level > vreg->high_vol_level
+		|| !vreg->hpm_uA || !vreg->lpm_uA
+		|| vreg->lpm_uA > vreg->hpm_uA) {
+		dev_err(dev, "%s invalid constraints specified\n", vreg->name);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int sdhci_msm_vreg_enable(struct device *dev,
+				struct sdhci_msm_reg_data *vreg)
+{
+	int ret;
+
+	if (IS_ERR(vreg->reg))
+		return 0;
+
+	/* Put regulator in HPM (high power mode) */
+	ret = regulator_set_optimum_mode(vreg->reg, vreg->hpm_uA);
+	if (ret < 0) {
+		dev_err(dev, "regulator_set_optimum_mode(%s,uA_load=%d) fail (%d)\n",
+			vreg->name, vreg->hpm_uA, ret);
+		return ret;
+	}
+
+	if (!regulator_is_enabled(vreg->reg)) {
+		/* Set voltage level */
+		ret = regulator_set_voltage(vreg->reg, vreg->high_vol_level,
+						vreg->high_vol_level);
+		if (ret)
+			return ret;
+	}
+
+	ret = regulator_enable(vreg->reg);
+	if (ret) {
+		dev_err(dev, "regulator_enable(%s) fail (%d)\n",
+			vreg->name, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int sdhci_msm_vreg_disable(struct device *dev,
+				struct sdhci_msm_reg_data *vreg)
+{
+	int ret;
+
+	if (IS_ERR(vreg->reg))
+		return 0;
+
+	if (!regulator_is_enabled(vreg->reg))
+		return 0;
+
+	/* Put regulator in LPM (low power mode) */
+	if (vreg->lpm_sup) {
+		ret = regulator_set_optimum_mode(vreg->reg,
+			vreg->lpm_uA);
+		if (ret < 0)
+			return ret;
+	} else {
+		ret = regulator_set_optimum_mode(vreg->reg, 0);
+		if (ret < 0)
+			return ret;
+
+		/* Set min. voltage level to 0 */
+		ret = regulator_set_voltage(vreg->reg, 0, vreg->high_vol_level);
+		if (ret)
+			return ret;
+	}
+
+	ret = regulator_disable(vreg->reg);
+	if (ret) {
+		dev_err(dev, "regulator_disable(%s) fail (%d)\n",
+			vreg->name, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int sdhci_msm_setup_vreg(struct sdhci_msm_host *msm_host, bool enable)
+{
+	int ret, i;
+	struct sdhci_msm_reg_data *vreg_table[2];
+
+	vreg_table[0] = &msm_host->pdata.vdd;
+	vreg_table[1] = &msm_host->pdata.vdd_io;
+
+	for (i = 0; i < ARRAY_SIZE(vreg_table); i++) {
+		if (!vreg_table[i])
+			continue;
+		if (enable)
+			ret = sdhci_msm_vreg_enable(&msm_host->pdev->dev,
+						vreg_table[i]);
+		else
+			ret = sdhci_msm_vreg_disable(&msm_host->pdev->dev,
+						vreg_table[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/* This init function should be called only once for each SDHC slot */
+static int sdhci_msm_vreg_init(struct device *dev,
+				struct sdhci_msm_pltfm_data *pdata)
+{
+	struct sdhci_msm_reg_data *curr_vdd_reg = &pdata->vdd;
+	struct sdhci_msm_reg_data *curr_vdd_io_reg = &pdata->vdd_io;
+	int ret;
+
+	ret = sdhci_msm_vreg_init_reg(dev, curr_vdd_reg);
+	if (ret)
+		return ret;
+
+	ret = sdhci_msm_vreg_init_reg(dev, curr_vdd_io_reg);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static irqreturn_t sdhci_msm_pwr_irq(int irq, void *data)
+{
+	struct sdhci_host *host = (struct sdhci_host *)data;
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_msm_host *msm_host = pltfm_host->priv;
+	u8 irq_status;
+	u8 irq_ack = 0;
+	int ret = 0;
+
+	irq_status = readb_relaxed(msm_host->core_mem + CORE_PWRCTL_STATUS);
+	dev_dbg(mmc_dev(msm_host->mmc), "%s: Received IRQ(%d), status=0x%x\n",
+		mmc_hostname(msm_host->mmc), irq, irq_status);
+
+	/* Clear the interrupt */
+	writeb_relaxed(irq_status, (msm_host->core_mem + CORE_PWRCTL_CLEAR));
+	/*
+	 * SDHC has core_mem and hc_mem device memory and these memory
+	 * addresses do not fall within 1KB region. Hence, any update to
+	 * core_mem address space would require an mb() to ensure this gets
+	 * completed before its next update to registers within hc_mem.
+	 */
+	mb();
+
+	/* Handle BUS ON/OFF*/
+	if (irq_status & CORE_PWRCTL_BUS_ON) {
+		ret = sdhci_msm_setup_vreg(msm_host, true);
+		if (!ret)
+			ret = regulator_set_voltage(msm_host->pdata.vdd_io.reg,
+				msm_host->pdata.vdd_io.high_vol_level,
+				msm_host->pdata.vdd_io.high_vol_level);
+		if (ret)
+			irq_ack |= CORE_PWRCTL_BUS_FAIL;
+		else
+			irq_ack |= CORE_PWRCTL_BUS_SUCCESS;
+	}
+
+	if (irq_status & CORE_PWRCTL_BUS_OFF) {
+		ret = sdhci_msm_setup_vreg(msm_host, false);
+		if (!ret)
+			ret = regulator_set_voltage(msm_host->pdata.vdd_io.reg,
+				msm_host->pdata.vdd_io.low_vol_level,
+				msm_host->pdata.vdd_io.low_vol_level);
+		if (ret)
+			irq_ack |= CORE_PWRCTL_BUS_FAIL;
+		else
+			irq_ack |= CORE_PWRCTL_BUS_SUCCESS;
+	}
+
+	/* Handle IO LOW/HIGH */
+	if (irq_status & CORE_PWRCTL_IO_LOW) {
+		ret = regulator_set_voltage(msm_host->pdata.vdd_io.reg,
+			msm_host->pdata.vdd_io.low_vol_level,
+			msm_host->pdata.vdd_io.low_vol_level);
+		if (ret)
+			irq_ack |= CORE_PWRCTL_IO_FAIL;
+		else
+			irq_ack |= CORE_PWRCTL_IO_SUCCESS;
+	}
+
+	if (irq_status & CORE_PWRCTL_IO_HIGH) {
+		ret = regulator_set_voltage(msm_host->pdata.vdd_io.reg,
+			msm_host->pdata.vdd_io.high_vol_level,
+			msm_host->pdata.vdd_io.high_vol_level);
+		if (ret)
+			irq_ack |= CORE_PWRCTL_IO_FAIL;
+		else
+			irq_ack |= CORE_PWRCTL_IO_SUCCESS;
+	}
+
+	/* ACK status to the core */
+	writeb_relaxed(irq_ack, (msm_host->core_mem + CORE_PWRCTL_CTL));
+	/*
+	 * SDHC has core_mem and hc_mem device memory and these memory
+	 * addresses do not fall within 1KB region. Hence, any update to
+	 * core_mem address space would require an mb() to ensure this gets
+	 * completed before its next update to registers within hc_mem.
+	 */
+	mb();
+
+	dev_dbg(mmc_dev(msm_host->mmc), "%s: Handled IRQ(%d), ret=%d, ack=0x%x\n",
+		 mmc_hostname(msm_host->mmc), irq, ret, irq_ack);
+	return IRQ_HANDLED;
+}
+
+/* This function returns the max. current supported by VDD rail in mA */
+static u32 sdhci_msm_get_vdd_max_current(struct sdhci_msm_host *host)
+{
+	return host->pdata.vdd.hpm_uA / 1000;
+}
+
+static const struct of_device_id sdhci_msm_dt_match[] = {
+	{.compatible = "qcom,sdhci-msm"},
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
+	struct resource *core_memres = NULL;
+	int ret, dead;
+	u16 host_version;
+	u32 irq_status, irq_ctl;
+
+	if (!pdev->dev.of_node) {
+		dev_err(&pdev->dev, "No device tree data\n");
+		return -ENOENT;
+	}
+
+	msm_host = devm_kzalloc(&pdev->dev, sizeof(*msm_host), GFP_KERNEL);
+	if (!msm_host)
+		return -ENOMEM;
+
+	msm_host->sdhci_msm_pdata.ops = &sdhci_msm_ops;
+	host = sdhci_pltfm_init(pdev, &msm_host->sdhci_msm_pdata, 0);
+	if (IS_ERR(host)) {
+		dev_err(mmc_dev(host->mmc), "sdhci_pltfm_init error\n");
+		return PTR_ERR(host);
+	}
+
+	pltfm_host = sdhci_priv(host);
+	pltfm_host->priv = msm_host;
+	msm_host->mmc = host->mmc;
+	msm_host->pdev = pdev;
+
+	ret = mmc_of_parse(host->mmc);
+	if (ret) {
+		dev_err(&pdev->dev, "failed parsing mmc device tree\n");
+		goto pltfm_free;
+	}
+
+	ret = sdhci_msm_populate_pdata(&pdev->dev, &msm_host->pdata);
+	if (ret) {
+		dev_err(&pdev->dev, "DT parsing error\n");
+		goto pltfm_free;
+	}
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
+	if (!IS_ERR(msm_host->pclk)) {
+		ret = clk_prepare_enable(msm_host->pclk);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"Main peripheral clock setup fail (%d)\n",
+				ret);
+			goto bus_clk_disable;
+		}
+	}
+
+	/* Setup SDC MMC clock */
+	msm_host->clk = devm_clk_get(&pdev->dev, "core");
+	if (IS_ERR(msm_host->clk)) {
+		ret = PTR_ERR(msm_host->clk);
+		dev_err(&pdev->dev, "SDC MMC clock setup fail (%d)\n", ret);
+		goto pclk_disable;
+	}
+
+	ret = clk_prepare_enable(msm_host->clk);
+	if (ret)
+		goto pclk_disable;
+
+	/* Setup regulators */
+	ret = sdhci_msm_vreg_init(&pdev->dev, &msm_host->pdata);
+	if (ret) {
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Regulator setup fail (%d)\n", ret);
+		goto clk_disable;
+	}
+
+	core_memres = platform_get_resource_byname(pdev,
+						   IORESOURCE_MEM, "core_mem");
+	msm_host->core_mem = devm_ioremap_resource(&pdev->dev, core_memres);
+
+	if (IS_ERR(msm_host->core_mem)) {
+		dev_err(&pdev->dev, "Failed to remap registers\n");
+		ret = PTR_ERR(msm_host->core_mem);
+		goto vreg_disable;
+	}
+
+	/* Reset the core and Enable SDHC mode */
+	writel_relaxed(readl_relaxed(msm_host->core_mem + CORE_POWER) |
+			CORE_SW_RST, msm_host->core_mem + CORE_POWER);
+
+	/* SW reset can take upto 10HCLK + 15MCLK cycles. (min 40us) */
+	usleep_range(1000, 5000);
+	if (readl(msm_host->core_mem + CORE_POWER) & CORE_SW_RST) {
+		dev_err(&pdev->dev, "Stuck in reset\n");
+		ret = -ETIMEDOUT;
+		goto vreg_disable;
+	}
+
+	/* Set HC_MODE_EN bit in HC_MODE register */
+	writel_relaxed(HC_MODE_EN, (msm_host->core_mem + CORE_HC_MODE));
+
+	/*
+	 * CORE_SW_RST above may trigger power irq if previous status of PWRCTL
+	 * was either BUS_ON or IO_HIGH_V. So before we enable the power irq
+	 * interrupt in GIC (by registering the interrupt handler), we need to
+	 * ensure that any pending power irq interrupt status is acknowledged
+	 * otherwise power irq interrupt handler would be fired prematurely.
+	 */
+	irq_status = readl_relaxed(msm_host->core_mem + CORE_PWRCTL_STATUS);
+	writel_relaxed(irq_status, (msm_host->core_mem + CORE_PWRCTL_CLEAR));
+	irq_ctl = readl_relaxed(msm_host->core_mem + CORE_PWRCTL_CTL);
+	if (irq_status & (CORE_PWRCTL_BUS_ON | CORE_PWRCTL_BUS_OFF))
+		irq_ctl |= CORE_PWRCTL_BUS_SUCCESS;
+	if (irq_status & (CORE_PWRCTL_IO_HIGH | CORE_PWRCTL_IO_LOW))
+		irq_ctl |= CORE_PWRCTL_IO_SUCCESS;
+	writel_relaxed(irq_ctl, (msm_host->core_mem + CORE_PWRCTL_CTL));
+	/*
+	 * Ensure that above writes are propogated before interrupt enablement
+	 * in GIC.
+	 */
+	mb();
+
+	/*
+	 * Following are the deviations from SDHC spec v3.0 -
+	 * 1. Card detection is handled using separate GPIO.
+	 * 2. Bus power control is handled by interacting with PMIC.
+	 */
+	host->quirks |= SDHCI_QUIRK_BROKEN_CARD_DETECTION;
+	host->quirks |= SDHCI_QUIRK_SINGLE_POWER_WRITE;
+
+	host_version = readw_relaxed((host->ioaddr + SDHCI_HOST_VERSION));
+	dev_dbg(&pdev->dev, "Host Version: 0x%x Vendor Version 0x%x\n",
+		host_version, ((host_version & SDHCI_VENDOR_VER_MASK) >>
+		SDHCI_VENDOR_VER_SHIFT));
+
+	/* Setup PWRCTL irq */
+	msm_host->pwr_irq = platform_get_irq_byname(pdev, "pwr_irq");
+	if (msm_host->pwr_irq < 0) {
+		dev_err(&pdev->dev, "Failed to get pwr_irq by name (%d)\n",
+			msm_host->pwr_irq);
+		goto vreg_disable;
+	}
+	ret = devm_request_threaded_irq(&pdev->dev, msm_host->pwr_irq, NULL,
+					sdhci_msm_pwr_irq, IRQF_ONESHOT,
+					dev_name(&pdev->dev), host);
+	if (ret) {
+		dev_err(&pdev->dev, "Request threaded irq(%d) fail (%d)\n",
+			msm_host->pwr_irq, ret);
+		goto vreg_disable;
+	}
+
+	/* Enable pwr irq interrupts */
+	writel_relaxed(INT_MASK, (msm_host->core_mem + CORE_PWRCTL_MASK));
+
+	msm_host->mmc->caps |= msm_host->pdata.caps;
+	msm_host->mmc->caps2 |= msm_host->pdata.caps2;
+
+	ret = sdhci_add_host(host);
+	if (ret) {
+		dev_err(&pdev->dev, "Add host fail (%d)\n", ret);
+		goto vreg_disable;
+	}
+
+	ret = clk_set_rate(msm_host->clk, host->max_clk);
+	if (ret) {
+		dev_err(&pdev->dev, "MClk rate set fail (%d)\n", ret);
+		goto remove_host;
+	}
+
+	host->mmc->max_current_180 = host->mmc->max_current_300 =
+	host->mmc->max_current_330 = sdhci_msm_get_vdd_max_current(msm_host);
+
+	return 0;
+
+remove_host:
+	dead = (readl_relaxed(host->ioaddr + SDHCI_INT_STATUS) == 0xffffffff);
+	sdhci_remove_host(host, dead);
+vreg_disable:
+	if (!IS_ERR(msm_host->pdata.vdd.reg))
+		sdhci_msm_vreg_disable(&pdev->dev, &msm_host->pdata.vdd);
+	if (!IS_ERR(msm_host->pdata.vdd_io.reg))
+		sdhci_msm_vreg_disable(&pdev->dev, &msm_host->pdata.vdd_io);
+clk_disable:
+	if (!IS_ERR(msm_host->clk))
+		clk_disable_unprepare(msm_host->clk);
+pclk_disable:
+	if (!IS_ERR(msm_host->pclk))
+		clk_disable_unprepare(msm_host->pclk);
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
+	sdhci_msm_vreg_disable(&pdev->dev, &msm_host->pdata.vdd);
+	sdhci_msm_vreg_disable(&pdev->dev, &msm_host->pdata.vdd_io);
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

