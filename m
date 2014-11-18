Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaKRMXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:23:45 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44890 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbaKRMXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:23:42 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, Joerg Roedel <jroedel@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 10/14] memory: tegra: Add API needed by the EMC driver
Date: Tue, 18 Nov 2014 13:13:12 +0100
Message-Id: <1416312860-4446-11-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416312860-4446-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1416312860-4446-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

The EMC driver needs to know the number of external memory devices and
also needs to update the EMEM configuration based on the new rate of the
memory bus.

To know how to update the EMEM config, looks up the values of the burst
regs in the DT, for a given timing.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

---

v5:	* Misc. style fixes
	* Move new function prototypes to include/soc/tegra/mc.h
	* Plug two device_node leaks

v4:	* Adapt to changes in the iommu patchset
	* Improve error reporting
	* Adapt to changes in the OF bindings
---
 drivers/memory/tegra/mc.c       | 136 ++++++++++++++++++++++++++++++++++++++++
 drivers/memory/tegra/tegra124.c |  44 +++++++++++++
 include/soc/tegra/mc.h          |  14 ++++-
 3 files changed, 193 insertions(+), 1 deletion(-)

diff --git a/drivers/memory/tegra/mc.c b/drivers/memory/tegra/mc.c
index 9b7c164..f5fb80d 100644
--- a/drivers/memory/tegra/mc.c
+++ b/drivers/memory/tegra/mc.c
@@ -13,6 +13,9 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/sort.h>
+
+#include <soc/tegra/fuse.h>
 
 #include "mc.h"
 
@@ -48,6 +51,9 @@
 #define  MC_EMEM_ARB_CFG_CYCLES_PER_UPDATE_MASK	0x1ff
 #define MC_EMEM_ARB_MISC0 0xd8
 
+#define MC_EMEM_ADR_CFG 0x54
+#define MC_EMEM_ADR_CFG_EMEM_NUMDEV BIT(0)
+
 static const struct of_device_id tegra_mc_of_match[] = {
 #ifdef CONFIG_ARCH_TEGRA_3x_SOC
 	{ .compatible = "nvidia,tegra30-mc", .data = &tegra30_mc_soc },
@@ -94,6 +100,130 @@ static int tegra_mc_setup_latency_allowance(struct tegra_mc *mc)
 	return 0;
 }
 
+void tegra_mc_write_emem_configuration(struct tegra_mc *mc, unsigned long rate)
+{
+	unsigned int i;
+	struct tegra_mc_timing *timing = NULL;
+
+	for (i = 0; i < mc->num_timings; i++) {
+		if (mc->timings[i].rate == rate) {
+			timing = &mc->timings[i];
+			break;
+		}
+	}
+
+	if (!timing) {
+		dev_err(mc->dev, "no memory timing registered for rate %lu\n",
+			rate);
+		return;
+	}
+
+	for (i = 0; i < mc->soc->num_emem_regs; ++i)
+		mc_writel(mc, timing->emem_data[i], mc->soc->emem_regs[i]);
+}
+
+unsigned int tegra_mc_get_emem_device_count(struct tegra_mc *mc)
+{
+	u8 dram_count;
+
+	dram_count = mc_readl(mc, MC_EMEM_ADR_CFG);
+	dram_count &= MC_EMEM_ADR_CFG_EMEM_NUMDEV;
+	dram_count++;
+
+	return dram_count;
+}
+
+static int load_one_timing(struct tegra_mc *mc,
+			   struct tegra_mc_timing *timing,
+			   struct device_node *node)
+{
+	int err;
+	u32 tmp;
+
+	err = of_property_read_u32(node, "clock-frequency", &tmp);
+	if (err) {
+		dev_err(mc->dev,
+			"timing %s: failed to read rate\n", node->name);
+		return err;
+	}
+
+	timing->rate = tmp;
+	timing->emem_data = devm_kcalloc(mc->dev, mc->soc->num_emem_regs,
+					 sizeof(u32), GFP_KERNEL);
+	if (!timing->emem_data)
+		return -ENOMEM;
+
+	err = of_property_read_u32_array(node, "nvidia,emem-configuration",
+					 timing->emem_data,
+					 mc->soc->num_emem_regs);
+	if (err) {
+		dev_err(mc->dev,
+			"timing %s: failed to read EMEM configuration\n",
+			node->name);
+		return err;
+	}
+
+	return 0;
+}
+
+static int load_timings(struct tegra_mc *mc, struct device_node *node)
+{
+	struct device_node *child;
+	struct tegra_mc_timing *timing;
+	int child_count = of_get_child_count(node);
+	int i = 0, err;
+
+	mc->timings = devm_kcalloc(mc->dev, child_count, sizeof(*timing),
+				   GFP_KERNEL);
+	if (!mc->timings)
+		return -ENOMEM;
+
+	mc->num_timings = child_count;
+
+	for_each_child_of_node(node, child) {
+		timing = &mc->timings[i++];
+
+		err = load_one_timing(mc, timing, child);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int tegra_mc_setup_timings(struct tegra_mc *mc)
+{
+	struct device_node *node;
+	u32 ram_code, node_ram_code;
+	int err;
+
+	ram_code = tegra_read_ram_code();
+
+	mc->num_timings = 0;
+
+	for_each_child_of_node(mc->dev->of_node, node) {
+		err = of_property_read_u32(node, "nvidia,ram-code",
+					   &node_ram_code);
+		if (err || (node_ram_code != ram_code)) {
+			of_node_put(node);
+			continue;
+		}
+
+		err = load_timings(mc, node);
+		if (err)
+			return err;
+		of_node_put(node);
+		break;
+	}
+
+	if (mc->num_timings == 0)
+		dev_warn(mc->dev,
+			 "no memory timings for RAM code %u registered\n",
+			 ram_code);
+
+	return 0;
+}
+
 static const char *const status_names[32] = {
 	[ 1] = "External interrupt",
 	[ 6] = "EMEM address decode error",
@@ -251,6 +381,12 @@ static int tegra_mc_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	err = tegra_mc_setup_timings(mc);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to setup timings: %d\n", err);
+		return err;
+	}
+
 	if (IS_ENABLED(CONFIG_TEGRA_IOMMU_SMMU)) {
 		mc->smmu = tegra_smmu_probe(&pdev->dev, mc->soc->smmu, mc);
 		if (IS_ERR(mc->smmu)) {
diff --git a/drivers/memory/tegra/tegra124.c b/drivers/memory/tegra/tegra124.c
index ccd19d8..ee26d84 100644
--- a/drivers/memory/tegra/tegra124.c
+++ b/drivers/memory/tegra/tegra124.c
@@ -15,6 +15,48 @@
 
 #include "mc.h"
 
+#define MC_EMEM_ARB_CFG				0x90
+#define MC_EMEM_ARB_OUTSTANDING_REQ		0x94
+#define MC_EMEM_ARB_TIMING_RCD			0x98
+#define MC_EMEM_ARB_TIMING_RP			0x9c
+#define MC_EMEM_ARB_TIMING_RC			0xa0
+#define MC_EMEM_ARB_TIMING_RAS			0xa4
+#define MC_EMEM_ARB_TIMING_FAW			0xa8
+#define MC_EMEM_ARB_TIMING_RRD			0xac
+#define MC_EMEM_ARB_TIMING_RAP2PRE		0xb0
+#define MC_EMEM_ARB_TIMING_WAP2PRE		0xb4
+#define MC_EMEM_ARB_TIMING_R2R			0xb8
+#define MC_EMEM_ARB_TIMING_W2W			0xbc
+#define MC_EMEM_ARB_TIMING_R2W			0xc0
+#define MC_EMEM_ARB_TIMING_W2R			0xc4
+#define MC_EMEM_ARB_DA_TURNS			0xd0
+#define MC_EMEM_ARB_DA_COVERS			0xd4
+#define MC_EMEM_ARB_MISC0			0xd8
+#define MC_EMEM_ARB_MISC1			0xdc
+#define MC_EMEM_ARB_RING1_THROTTLE		0xe0
+
+static const unsigned long tegra124_mc_emem_regs[] = {
+	MC_EMEM_ARB_CFG,
+	MC_EMEM_ARB_OUTSTANDING_REQ,
+	MC_EMEM_ARB_TIMING_RCD,
+	MC_EMEM_ARB_TIMING_RP,
+	MC_EMEM_ARB_TIMING_RC,
+	MC_EMEM_ARB_TIMING_RAS,
+	MC_EMEM_ARB_TIMING_FAW,
+	MC_EMEM_ARB_TIMING_RRD,
+	MC_EMEM_ARB_TIMING_RAP2PRE,
+	MC_EMEM_ARB_TIMING_WAP2PRE,
+	MC_EMEM_ARB_TIMING_R2R,
+	MC_EMEM_ARB_TIMING_W2W,
+	MC_EMEM_ARB_TIMING_R2W,
+	MC_EMEM_ARB_TIMING_W2R,
+	MC_EMEM_ARB_DA_TURNS,
+	MC_EMEM_ARB_DA_COVERS,
+	MC_EMEM_ARB_MISC0,
+	MC_EMEM_ARB_MISC1,
+	MC_EMEM_ARB_RING1_THROTTLE
+};
+
 static const struct tegra_mc_client tegra124_mc_clients[] = {
 	{
 		.id = 0x00,
@@ -991,6 +1033,8 @@ const struct tegra_mc_soc tegra124_mc_soc = {
 	.num_address_bits = 34,
 	.atom_size = 32,
 	.smmu = &tegra124_smmu_soc,
+	.emem_regs = tegra124_mc_emem_regs,
+	.num_emem_regs = ARRAY_SIZE(tegra124_mc_emem_regs),
 };
 #endif /* CONFIG_ARCH_TEGRA_124_SOC */
 
diff --git a/include/soc/tegra/mc.h b/include/soc/tegra/mc.h
index 63deb8d..90b558e 100644
--- a/include/soc/tegra/mc.h
+++ b/include/soc/tegra/mc.h
@@ -20,6 +20,12 @@ struct tegra_smmu_enable {
 	unsigned int bit;
 };
 
+struct tegra_mc_timing {
+	unsigned long rate;
+
+	u32 *emem_data;
+};
+
 /* latency allowance */
 struct tegra_mc_la {
 	unsigned int reg;
@@ -84,7 +90,7 @@ struct tegra_mc_soc {
 	const struct tegra_mc_client *clients;
 	unsigned int num_clients;
 
-	const unsigned int *emem_regs;
+	const unsigned long *emem_regs;
 	unsigned int num_emem_regs;
 
 	unsigned int num_address_bits;
@@ -102,6 +108,12 @@ struct tegra_mc {
 
 	const struct tegra_mc_soc *soc;
 	unsigned long tick;
+
+	struct tegra_mc_timing *timings;
+	unsigned int num_timings;
 };
 
+void tegra_mc_write_emem_configuration(struct tegra_mc *mc, unsigned long rate);
+unsigned int tegra_mc_get_emem_device_count(struct tegra_mc *mc);
+
 #endif /* __SOC_TEGRA_MC_H__ */
-- 
1.9.3

