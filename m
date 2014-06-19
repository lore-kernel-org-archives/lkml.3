Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbaFSLwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:52:51 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16455 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbaFSLws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:52:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 19 Jun 2014 04:43:22 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <pdeschrijver@nvidia.com>, <rui.zhang@intel.com>,
        <edubezval@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <mikko.perttunen@kapsi.fi>,
        <mlongnecker@nvidia.com>, <dtundlam@nvidia.com>, <talho@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [RFC 3/5] ARM: tegra: Add thermal reset (thermtrip) support to PMC
Date: Thu, 19 Jun 2014 14:50:38 +0300
Message-ID: <1403178640-16052-4-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1403178640-16052-1-git-send-email-mperttunen@nvidia.com>
References: <1403178640-16052-1-git-send-email-mperttunen@nvidia.com>
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
 arch/arm/mach-tegra/pmc.c | 95 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 91 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-tegra/pmc.c b/arch/arm/mach-tegra/pmc.c
index e1677c0..69143cd 100644
--- a/arch/arm/mach-tegra/pmc.c
+++ b/arch/arm/mach-tegra/pmc.c
@@ -51,6 +51,22 @@
 #define PMC_CPUPWRGOOD_TIMER	0xc8
 #define PMC_CPUPWROFF_TIMER	0xcc
 
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
 static u8 tegra_cpu_domains[] = {
 	0xFF,			/* not available for CPU0 */
 	TEGRA_POWERGATE_CPU1,
@@ -295,11 +311,19 @@ void tegra_pmc_suspend_init(void)
 }
 #endif
 
+#define PMC_HAS_THERMAL_RESET (1 << 0)
+
 static const struct of_device_id matches[] __initconst = {
-	{ .compatible = "nvidia,tegra124-pmc" },
-	{ .compatible = "nvidia,tegra114-pmc" },
-	{ .compatible = "nvidia,tegra30-pmc" },
-	{ .compatible = "nvidia,tegra20-pmc" },
+	{
+		.compatible = "nvidia,tegra124-pmc",
+		.data = (void *)PMC_HAS_THERMAL_RESET
+	},
+	{
+		.compatible = "nvidia,tegra114-pmc",
+		.data = (void *)PMC_HAS_THERMAL_RESET
+	},
+	{ .compatible = "nvidia,tegra30-pmc", .data = 0 },
+	{ .compatible = "nvidia,tegra20-pmc", .data = 0 },
 	{ }
 };
 
@@ -324,6 +348,67 @@ void __init tegra_pmc_init_irq(void)
 	tegra_pmc_writel(val, PMC_CTRL);
 }
 
+void __init tegra_pmc_init_thermal_reset(struct device_node *np)
+{
+	u32 pmu_i2c_addr, i2c_ctrl_id, reg_addr, reg_data, pinmux;
+	bool pmu_16bit_ops;
+	u32 val, checksum;
+	const struct of_device_id *match = of_match_node(matches, np);
+
+	if (!((u32)match->data & PMC_HAS_THERMAL_RESET))
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
 void __init tegra_pmc_init(void)
 {
 	struct device_node *np;
@@ -399,4 +484,6 @@ void __init tegra_pmc_init(void)
 	pmc_pm_data.lp0_vec_size = lp0_vec[1];
 
 	pmc_pm_data.suspend_mode = suspend_mode;
+
+	tegra_pmc_init_thermal_reset(np);
 }
-- 
1.8.1.5

