Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbaHEIOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:14:17 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17217 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590AbaHEIOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:14:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 05 Aug 2014 01:05:30 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 3/3] ARM: tegra: Add thermal reset (thermtrip) support to PMC
Date: Tue, 5 Aug 2014 11:13:00 +0300
Message-ID: <1407226380-747-4-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a device tree controlled option to enable PMC-based
thermal reset in overheating situations. Thermtrip is supported on
Tegra114 and Tegra124. The thermal reset only works when the thermal
sensors are calibrated, so a soctherm driver is also required.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 drivers/soc/tegra/pmc.c | 348 ++++++++++++++++++++++++++++++------------------
 1 file changed, 216 insertions(+), 132 deletions(-)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index a2c0ceb..2c617d7 100644
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
+	bool has_thermal_reset;
 };
 
 /**
@@ -606,6 +623,203 @@ void tegra_pmc_enter_suspend_mode(enum tegra_suspend_mode mode)
 }
 #endif
 
+static const char * const tegra20_powergates[] = {
+	[TEGRA_POWERGATE_CPU] = "cpu",
+	[TEGRA_POWERGATE_3D] = "3d",
+	[TEGRA_POWERGATE_VENC] = "venc",
+	[TEGRA_POWERGATE_VDEC] = "vdec",
+	[TEGRA_POWERGATE_PCIE] = "pcie",
+	[TEGRA_POWERGATE_L2] = "l2",
+	[TEGRA_POWERGATE_MPE] = "mpe",
+};
+
+static const struct tegra_pmc_soc tegra20_pmc_soc = {
+	.num_powergates = ARRAY_SIZE(tegra20_powergates),
+	.powergates = tegra20_powergates,
+	.num_cpu_powergates = 0,
+	.cpu_powergates = NULL,
+};
+
+static const char * const tegra30_powergates[] = {
+	[TEGRA_POWERGATE_CPU] = "cpu0",
+	[TEGRA_POWERGATE_3D] = "3d0",
+	[TEGRA_POWERGATE_VENC] = "venc",
+	[TEGRA_POWERGATE_VDEC] = "vdec",
+	[TEGRA_POWERGATE_PCIE] = "pcie",
+	[TEGRA_POWERGATE_L2] = "l2",
+	[TEGRA_POWERGATE_MPE] = "mpe",
+	[TEGRA_POWERGATE_HEG] = "heg",
+	[TEGRA_POWERGATE_SATA] = "sata",
+	[TEGRA_POWERGATE_CPU1] = "cpu1",
+	[TEGRA_POWERGATE_CPU2] = "cpu2",
+	[TEGRA_POWERGATE_CPU3] = "cpu3",
+	[TEGRA_POWERGATE_CELP] = "celp",
+	[TEGRA_POWERGATE_3D1] = "3d1",
+};
+
+static const u8 tegra30_cpu_powergates[] = {
+	TEGRA_POWERGATE_CPU,
+	TEGRA_POWERGATE_CPU1,
+	TEGRA_POWERGATE_CPU2,
+	TEGRA_POWERGATE_CPU3,
+};
+
+static const struct tegra_pmc_soc tegra30_pmc_soc = {
+	.num_powergates = ARRAY_SIZE(tegra30_powergates),
+	.powergates = tegra30_powergates,
+	.num_cpu_powergates = ARRAY_SIZE(tegra30_cpu_powergates),
+	.cpu_powergates = tegra30_cpu_powergates,
+	.has_thermal_reset = true,
+};
+
+static const char * const tegra114_powergates[] = {
+	[TEGRA_POWERGATE_CPU] = "crail",
+	[TEGRA_POWERGATE_3D] = "3d",
+	[TEGRA_POWERGATE_VENC] = "venc",
+	[TEGRA_POWERGATE_VDEC] = "vdec",
+	[TEGRA_POWERGATE_MPE] = "mpe",
+	[TEGRA_POWERGATE_HEG] = "heg",
+	[TEGRA_POWERGATE_CPU1] = "cpu1",
+	[TEGRA_POWERGATE_CPU2] = "cpu2",
+	[TEGRA_POWERGATE_CPU3] = "cpu3",
+	[TEGRA_POWERGATE_CELP] = "celp",
+	[TEGRA_POWERGATE_CPU0] = "cpu0",
+	[TEGRA_POWERGATE_C0NC] = "c0nc",
+	[TEGRA_POWERGATE_C1NC] = "c1nc",
+	[TEGRA_POWERGATE_DIS] = "dis",
+	[TEGRA_POWERGATE_DISB] = "disb",
+	[TEGRA_POWERGATE_XUSBA] = "xusba",
+	[TEGRA_POWERGATE_XUSBB] = "xusbb",
+	[TEGRA_POWERGATE_XUSBC] = "xusbc",
+};
+
+static const u8 tegra114_cpu_powergates[] = {
+	TEGRA_POWERGATE_CPU0,
+	TEGRA_POWERGATE_CPU1,
+	TEGRA_POWERGATE_CPU2,
+	TEGRA_POWERGATE_CPU3,
+};
+
+static const struct tegra_pmc_soc tegra114_pmc_soc = {
+	.num_powergates = ARRAY_SIZE(tegra114_powergates),
+	.powergates = tegra114_powergates,
+	.num_cpu_powergates = ARRAY_SIZE(tegra114_cpu_powergates),
+	.cpu_powergates = tegra114_cpu_powergates,
+	.has_thermal_reset = true,
+};
+
+static const char * const tegra124_powergates[] = {
+	[TEGRA_POWERGATE_CPU] = "crail",
+	[TEGRA_POWERGATE_3D] = "3d",
+	[TEGRA_POWERGATE_VENC] = "venc",
+	[TEGRA_POWERGATE_PCIE] = "pcie",
+	[TEGRA_POWERGATE_VDEC] = "vdec",
+	[TEGRA_POWERGATE_L2] = "l2",
+	[TEGRA_POWERGATE_MPE] = "mpe",
+	[TEGRA_POWERGATE_HEG] = "heg",
+	[TEGRA_POWERGATE_SATA] = "sata",
+	[TEGRA_POWERGATE_CPU1] = "cpu1",
+	[TEGRA_POWERGATE_CPU2] = "cpu2",
+	[TEGRA_POWERGATE_CPU3] = "cpu3",
+	[TEGRA_POWERGATE_CELP] = "celp",
+	[TEGRA_POWERGATE_CPU0] = "cpu0",
+	[TEGRA_POWERGATE_C0NC] = "c0nc",
+	[TEGRA_POWERGATE_C1NC] = "c1nc",
+	[TEGRA_POWERGATE_SOR] = "sor",
+	[TEGRA_POWERGATE_DIS] = "dis",
+	[TEGRA_POWERGATE_DISB] = "disb",
+	[TEGRA_POWERGATE_XUSBA] = "xusba",
+	[TEGRA_POWERGATE_XUSBB] = "xusbb",
+	[TEGRA_POWERGATE_XUSBC] = "xusbc",
+	[TEGRA_POWERGATE_VIC] = "vic",
+	[TEGRA_POWERGATE_IRAM] = "iram",
+};
+
+static const u8 tegra124_cpu_powergates[] = {
+	TEGRA_POWERGATE_CPU0,
+	TEGRA_POWERGATE_CPU1,
+	TEGRA_POWERGATE_CPU2,
+	TEGRA_POWERGATE_CPU3,
+};
+
+static const struct tegra_pmc_soc tegra124_pmc_soc = {
+	.num_powergates = ARRAY_SIZE(tegra124_powergates),
+	.powergates = tegra124_powergates,
+	.num_cpu_powergates = ARRAY_SIZE(tegra124_cpu_powergates),
+	.cpu_powergates = tegra124_cpu_powergates,
+	.has_thermal_reset = true,
+};
+
+static const struct of_device_id tegra_pmc_match[] = {
+	{ .compatible = "nvidia,tegra124-pmc", .data = &tegra124_pmc_soc },
+	{ .compatible = "nvidia,tegra114-pmc", .data = &tegra114_pmc_soc },
+	{ .compatible = "nvidia,tegra30-pmc", .data = &tegra30_pmc_soc },
+	{ .compatible = "nvidia,tegra20-pmc", .data = &tegra20_pmc_soc },
+	{ }
+};
+
+void tegra_pmc_init_thermal_reset(struct device_node *np)
+{
+	u32 pmu_i2c_addr, i2c_ctrl_id, reg_addr, reg_data, pinmux;
+	bool pmu_16bit_ops;
+	u32 val, checksum;
+	const struct of_device_id *match = of_match_node(tegra_pmc_match, np);
+	const struct tegra_pmc_soc *data = match->data;
+
+	if (!data->has_thermal_reset)
+		return;
+
+	pmu_16bit_ops =
+		of_property_read_bool(np, "nvidia,thermtrip-pmu-16bit-ops");
+	if (of_property_read_u32(
+		np, "nvidia,thermtrip-pmu-i2c-addr", &pmu_i2c_addr))
+		goto disabled;
+	if (of_property_read_u32(
+		np, "nvidia,thermtrip-i2c-controller", &i2c_ctrl_id))
+		goto disabled;
+	if (of_property_read_u32(
+		np, "nvidia,thermtrip-reg-addr", &reg_addr))
+		goto disabled;
+	if (of_property_read_u32(
+		np, "nvidia,thermtrip-reg-data", &reg_data))
+		goto disabled;
+	if (of_property_read_u32(
+		np, "nvidia,thermtrip-pinmux", &pinmux))
+		pinmux = 0;
+
+	val = tegra_pmc_readl(PMC_SENSOR_CTRL);
+	val |= PMC_SENSOR_CTRL_SCRATCH_WRITE | PMC_SENSOR_CTRL_ENABLE_RST;
+	tegra_pmc_writel(val, PMC_SENSOR_CTRL);
+
+	val = (reg_data << PMC_SCRATCH54_DATA_SHIFT) |
+	      (reg_addr << PMC_SCRATCH54_ADDR_SHIFT);
+	tegra_pmc_writel(val, PMC_SCRATCH54);
+
+	val = 0;
+	val |= PMC_SCRATCH55_RESET_TEGRA;
+	val |= i2c_ctrl_id << PMC_SCRATCH55_CNTRL_ID_SHIFT;
+	val |= pinmux << PMC_SCRATCH55_PINMUX_SHIFT;
+	if (pmu_16bit_ops)
+		val |= PMC_SCRATCH55_16BITOP;
+	val |= pmu_i2c_addr << PMC_SCRATCH55_I2CSLV1_SHIFT;
+
+	checksum = reg_addr + reg_data + (val & 0xFF) + ((val >> 8) & 0xFF) +
+		((val >> 24) & 0xFF);
+	checksum &= 0xFF;
+	checksum = 0x100 - checksum;
+
+	val |= checksum << PMC_SCRATCH55_CHECKSUM_SHIFT;
+
+	tegra_pmc_writel(val, PMC_SCRATCH55);
+
+	pr_info("Tegra: PMC thermal reset enabled\n");
+
+	return;
+
+disabled:
+	pr_warn("Tegra: PMC thermal reset disabled\n");
+}
+
 static int tegra_pmc_parse_dt(struct tegra_pmc *pmc, struct device_node *np)
 {
 	u32 value, values[2];
@@ -730,6 +944,8 @@ static int tegra_pmc_probe(struct platform_device *pdev)
 
 	tegra_pmc_init(pmc);
 
+	tegra_pmc_init_thermal_reset(pdev->dev.of_node);
+
 	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
 		err = tegra_powergate_debugfs_init();
 		if (err < 0)
@@ -757,138 +973,6 @@ static int tegra_pmc_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(tegra_pmc_pm_ops, tegra_pmc_suspend, tegra_pmc_resume);
 
-static const char * const tegra20_powergates[] = {
-	[TEGRA_POWERGATE_CPU] = "cpu",
-	[TEGRA_POWERGATE_3D] = "3d",
-	[TEGRA_POWERGATE_VENC] = "venc",
-	[TEGRA_POWERGATE_VDEC] = "vdec",
-	[TEGRA_POWERGATE_PCIE] = "pcie",
-	[TEGRA_POWERGATE_L2] = "l2",
-	[TEGRA_POWERGATE_MPE] = "mpe",
-};
-
-static const struct tegra_pmc_soc tegra20_pmc_soc = {
-	.num_powergates = ARRAY_SIZE(tegra20_powergates),
-	.powergates = tegra20_powergates,
-	.num_cpu_powergates = 0,
-	.cpu_powergates = NULL,
-};
-
-static const char * const tegra30_powergates[] = {
-	[TEGRA_POWERGATE_CPU] = "cpu0",
-	[TEGRA_POWERGATE_3D] = "3d0",
-	[TEGRA_POWERGATE_VENC] = "venc",
-	[TEGRA_POWERGATE_VDEC] = "vdec",
-	[TEGRA_POWERGATE_PCIE] = "pcie",
-	[TEGRA_POWERGATE_L2] = "l2",
-	[TEGRA_POWERGATE_MPE] = "mpe",
-	[TEGRA_POWERGATE_HEG] = "heg",
-	[TEGRA_POWERGATE_SATA] = "sata",
-	[TEGRA_POWERGATE_CPU1] = "cpu1",
-	[TEGRA_POWERGATE_CPU2] = "cpu2",
-	[TEGRA_POWERGATE_CPU3] = "cpu3",
-	[TEGRA_POWERGATE_CELP] = "celp",
-	[TEGRA_POWERGATE_3D1] = "3d1",
-};
-
-static const u8 tegra30_cpu_powergates[] = {
-	TEGRA_POWERGATE_CPU,
-	TEGRA_POWERGATE_CPU1,
-	TEGRA_POWERGATE_CPU2,
-	TEGRA_POWERGATE_CPU3,
-};
-
-static const struct tegra_pmc_soc tegra30_pmc_soc = {
-	.num_powergates = ARRAY_SIZE(tegra30_powergates),
-	.powergates = tegra30_powergates,
-	.num_cpu_powergates = ARRAY_SIZE(tegra30_cpu_powergates),
-	.cpu_powergates = tegra30_cpu_powergates,
-};
-
-static const char * const tegra114_powergates[] = {
-	[TEGRA_POWERGATE_CPU] = "crail",
-	[TEGRA_POWERGATE_3D] = "3d",
-	[TEGRA_POWERGATE_VENC] = "venc",
-	[TEGRA_POWERGATE_VDEC] = "vdec",
-	[TEGRA_POWERGATE_MPE] = "mpe",
-	[TEGRA_POWERGATE_HEG] = "heg",
-	[TEGRA_POWERGATE_CPU1] = "cpu1",
-	[TEGRA_POWERGATE_CPU2] = "cpu2",
-	[TEGRA_POWERGATE_CPU3] = "cpu3",
-	[TEGRA_POWERGATE_CELP] = "celp",
-	[TEGRA_POWERGATE_CPU0] = "cpu0",
-	[TEGRA_POWERGATE_C0NC] = "c0nc",
-	[TEGRA_POWERGATE_C1NC] = "c1nc",
-	[TEGRA_POWERGATE_DIS] = "dis",
-	[TEGRA_POWERGATE_DISB] = "disb",
-	[TEGRA_POWERGATE_XUSBA] = "xusba",
-	[TEGRA_POWERGATE_XUSBB] = "xusbb",
-	[TEGRA_POWERGATE_XUSBC] = "xusbc",
-};
-
-static const u8 tegra114_cpu_powergates[] = {
-	TEGRA_POWERGATE_CPU0,
-	TEGRA_POWERGATE_CPU1,
-	TEGRA_POWERGATE_CPU2,
-	TEGRA_POWERGATE_CPU3,
-};
-
-static const struct tegra_pmc_soc tegra114_pmc_soc = {
-	.num_powergates = ARRAY_SIZE(tegra114_powergates),
-	.powergates = tegra114_powergates,
-	.num_cpu_powergates = ARRAY_SIZE(tegra114_cpu_powergates),
-	.cpu_powergates = tegra114_cpu_powergates,
-};
-
-static const char * const tegra124_powergates[] = {
-	[TEGRA_POWERGATE_CPU] = "crail",
-	[TEGRA_POWERGATE_3D] = "3d",
-	[TEGRA_POWERGATE_VENC] = "venc",
-	[TEGRA_POWERGATE_PCIE] = "pcie",
-	[TEGRA_POWERGATE_VDEC] = "vdec",
-	[TEGRA_POWERGATE_L2] = "l2",
-	[TEGRA_POWERGATE_MPE] = "mpe",
-	[TEGRA_POWERGATE_HEG] = "heg",
-	[TEGRA_POWERGATE_SATA] = "sata",
-	[TEGRA_POWERGATE_CPU1] = "cpu1",
-	[TEGRA_POWERGATE_CPU2] = "cpu2",
-	[TEGRA_POWERGATE_CPU3] = "cpu3",
-	[TEGRA_POWERGATE_CELP] = "celp",
-	[TEGRA_POWERGATE_CPU0] = "cpu0",
-	[TEGRA_POWERGATE_C0NC] = "c0nc",
-	[TEGRA_POWERGATE_C1NC] = "c1nc",
-	[TEGRA_POWERGATE_SOR] = "sor",
-	[TEGRA_POWERGATE_DIS] = "dis",
-	[TEGRA_POWERGATE_DISB] = "disb",
-	[TEGRA_POWERGATE_XUSBA] = "xusba",
-	[TEGRA_POWERGATE_XUSBB] = "xusbb",
-	[TEGRA_POWERGATE_XUSBC] = "xusbc",
-	[TEGRA_POWERGATE_VIC] = "vic",
-	[TEGRA_POWERGATE_IRAM] = "iram",
-};
-
-static const u8 tegra124_cpu_powergates[] = {
-	TEGRA_POWERGATE_CPU0,
-	TEGRA_POWERGATE_CPU1,
-	TEGRA_POWERGATE_CPU2,
-	TEGRA_POWERGATE_CPU3,
-};
-
-static const struct tegra_pmc_soc tegra124_pmc_soc = {
-	.num_powergates = ARRAY_SIZE(tegra124_powergates),
-	.powergates = tegra124_powergates,
-	.num_cpu_powergates = ARRAY_SIZE(tegra124_cpu_powergates),
-	.cpu_powergates = tegra124_cpu_powergates,
-};
-
-static const struct of_device_id tegra_pmc_match[] = {
-	{ .compatible = "nvidia,tegra124-pmc", .data = &tegra124_pmc_soc },
-	{ .compatible = "nvidia,tegra114-pmc", .data = &tegra114_pmc_soc },
-	{ .compatible = "nvidia,tegra30-pmc", .data = &tegra30_pmc_soc },
-	{ .compatible = "nvidia,tegra20-pmc", .data = &tegra20_pmc_soc },
-	{ }
-};
-
 static struct platform_driver tegra_pmc_driver = {
 	.driver = {
 		.name = "tegra-pmc",
-- 
1.8.1.5

