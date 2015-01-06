Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbbAFKzC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:55:02 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:39033 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176AbbAFKyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:54:10 -0500
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, wni@nvidia.com,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v5 3/3] ARM: tegra: Add thermal reset (thermtrip) support to PMC
Date: Tue,  6 Jan 2015 12:52:58 +0200
Message-Id: <1420541578-27968-4-git-send-email-mikko.perttunen@kapsi.fi>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420541578-27968-1-git-send-email-mikko.perttunen@kapsi.fi>
References: <1420541578-27968-1-git-send-email-mikko.perttunen@kapsi.fi>
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

This adds a device tree controlled option to enable PMC-based
thermal reset in overheating situations. Thermtrip is supported on
Tegra30, Tegra114 and Tegra124. The thermal reset only works when
the thermal sensors are calibrated, so a soctherm driver is also
required.

The thermtrip event is triggered by the soctherm block, and all
soctherm sensors default to showing a temperature of zero Celsius
before they are initialized. Because of this, it is safe to initialize
thermtrip and soctherm in any order.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 drivers/soc/tegra/pmc.c | 107 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index a2c0ceb..9ed8be5 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -83,11 +83,28 @@
 
 #define GPU_RG_CNTRL			0x2d4
 
+#define PMC_SENSOR_CTRL			0x1b0
+#define PMC_SENSOR_CTRL_SCRATCH_WRITE	(1 << 2)
+#define PMC_SENSOR_CTRL_ENABLE_RST	(1 << 1)
+
+#define PMC_SCRATCH54			0x258
+#define PMC_SCRATCH54_DATA_SHIFT	8
+#define PMC_SCRATCH54_ADDR_SHIFT	0
+
+#define PMC_SCRATCH55			0x25c
+#define PMC_SCRATCH55_RESET_TEGRA	(1 << 31)
+#define PMC_SCRATCH55_CNTRL_ID_SHIFT	27
+#define PMC_SCRATCH55_PINMUX_SHIFT	24
+#define PMC_SCRATCH55_16BITOP		(1 << 15)
+#define PMC_SCRATCH55_CHECKSUM_SHIFT	16
+#define PMC_SCRATCH55_I2CSLV1_SHIFT	0
+
 struct tegra_pmc_soc {
 	unsigned int num_powergates;
 	const char *const *powergates;
 	unsigned int num_cpu_powergates;
 	const u8 *cpu_powergates;
+	bool has_tsense_reset;
 };
 
 /**
@@ -703,6 +720,90 @@ static void tegra_pmc_init(struct tegra_pmc *pmc)
 	tegra_pmc_writel(value, PMC_CNTRL);
 }
 
+static const struct of_device_id tegra_pmc_match[];
+
+void tegra_pmc_init_tsense_reset(struct device *dev)
+{
+	u32 pmu_i2c_addr, i2c_ctrl_id, reg_addr, reg_data, pinmux;
+	u32 value, checksum;
+	struct device_node *np = dev->of_node;
+	struct device_node *tt_np;
+	const struct of_device_id *match = of_match_node(tegra_pmc_match, np);
+	const struct tegra_pmc_soc *data = match->data;
+
+	if (!data->has_tsense_reset)
+		return;
+
+	tt_np = of_find_node_by_name(np, "i2c-thermtrip");
+	if (!tt_np) {
+		dev_warn(dev, "no i2c-thermtrip node found, disabling emergency thermal reset\n");
+		return;
+	}
+
+	if (of_property_read_u32(tt_np, "nvidia,i2c-controller-id", &i2c_ctrl_id)) {
+		dev_err(dev, "I2C bus controller id missing, disabling emergency thermal reset\n");
+		goto put_tt;
+	}
+
+	if (of_property_read_u32(tt_np, "nvidia,bus-addr", &pmu_i2c_addr)) {
+		dev_err(dev, "nvidia,bus-addr missing, disabling emergency thermal reset\n");
+		goto put_tt;
+	}
+
+	if (of_property_read_u32(tt_np, "nvidia,reg-addr", &reg_addr)) {
+		dev_err(dev, "nvidia,reg-addr missing, disabling emergency thermal reset\n");
+		goto put_tt;
+	}
+
+	if (of_property_read_u32(tt_np, "nvidia,reg-data", &reg_data)) {
+		dev_err(dev, "nvidia,reg-data missing, disabling emergency thermal reset\n");
+		goto put_tt;
+	}
+
+	if (of_property_read_u32(tt_np, "nvidia,pinmux-id", &pinmux))
+		pinmux = 0;
+
+	of_node_put(tt_np);
+
+	value = tegra_pmc_readl(PMC_SENSOR_CTRL);
+	value |= PMC_SENSOR_CTRL_SCRATCH_WRITE;
+	tegra_pmc_writel(value, PMC_SENSOR_CTRL);
+
+	value = (reg_data << PMC_SCRATCH54_DATA_SHIFT) |
+	      (reg_addr << PMC_SCRATCH54_ADDR_SHIFT);
+	tegra_pmc_writel(value, PMC_SCRATCH54);
+
+	value = 0;
+	value |= PMC_SCRATCH55_RESET_TEGRA;
+	value |= i2c_ctrl_id << PMC_SCRATCH55_CNTRL_ID_SHIFT;
+	value |= pinmux << PMC_SCRATCH55_PINMUX_SHIFT;
+	value |= pmu_i2c_addr << PMC_SCRATCH55_I2CSLV1_SHIFT;
+
+	/* Calculate checksum of SCRATCH54, SCRATCH55 fields.
+	 * Bits 23:16 will contain the checksum and are currently zero,
+	 * so they are not added.
+	 */
+	checksum = reg_addr + reg_data + (value & 0xff) + ((value >> 8) & 0xff)
+		+ ((value >> 24) & 0xff);
+	checksum &= 0xff;
+	checksum = 0x100 - checksum;
+
+	value |= checksum << PMC_SCRATCH55_CHECKSUM_SHIFT;
+
+	tegra_pmc_writel(value, PMC_SCRATCH55);
+
+	value = tegra_pmc_readl(PMC_SENSOR_CTRL);
+	value |= PMC_SENSOR_CTRL_ENABLE_RST;
+	tegra_pmc_writel(value, PMC_SENSOR_CTRL);
+
+	dev_info(dev, "PMC emergency thermal reset enabled\n");
+
+	return;
+
+put_tt:
+	of_node_put(tt_np);
+}
+
 static int tegra_pmc_probe(struct platform_device *pdev)
 {
 	void __iomem *base = pmc->base;
@@ -730,6 +831,8 @@ static int tegra_pmc_probe(struct platform_device *pdev)
 
 	tegra_pmc_init(pmc);
 
+	tegra_pmc_init_tsense_reset(&pdev->dev);
+
 	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
 		err = tegra_powergate_debugfs_init();
 		if (err < 0)
@@ -772,6 +875,7 @@ static const struct tegra_pmc_soc tegra20_pmc_soc = {
 	.powergates = tegra20_powergates,
 	.num_cpu_powergates = 0,
 	.cpu_powergates = NULL,
+	.has_tsense_reset = false,
 };
 
 static const char * const tegra30_powergates[] = {
@@ -803,6 +907,7 @@ static const struct tegra_pmc_soc tegra30_pmc_soc = {
 	.powergates = tegra30_powergates,
 	.num_cpu_powergates = ARRAY_SIZE(tegra30_cpu_powergates),
 	.cpu_powergates = tegra30_cpu_powergates,
+	.has_tsense_reset = true,
 };
 
 static const char * const tegra114_powergates[] = {
@@ -838,6 +943,7 @@ static const struct tegra_pmc_soc tegra114_pmc_soc = {
 	.powergates = tegra114_powergates,
 	.num_cpu_powergates = ARRAY_SIZE(tegra114_cpu_powergates),
 	.cpu_powergates = tegra114_cpu_powergates,
+	.has_tsense_reset = true,
 };
 
 static const char * const tegra124_powergates[] = {
@@ -879,6 +985,7 @@ static const struct tegra_pmc_soc tegra124_pmc_soc = {
 	.powergates = tegra124_powergates,
 	.num_cpu_powergates = ARRAY_SIZE(tegra124_cpu_powergates),
 	.cpu_powergates = tegra124_cpu_powergates,
+	.has_tsense_reset = true,
 };
 
 static const struct of_device_id tegra_pmc_match[] = {
-- 
2.1.3

