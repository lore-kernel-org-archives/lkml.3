Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbaJUOsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:48:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36973 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbaJUOsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:48:08 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/12] memory: tegra: Add API needed by the EMC driver
Date: Tue, 21 Oct 2014 16:45:41 +0200
Message-Id: <1413902788-7727-10-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413902788-7727-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1413902788-7727-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

The EMC driver needs to know the number of external memory devices and also
needs to update the EMEM configuration based on the new rate of the memory bus.

To know how to update the EMEM config, looks up the values of the burst regs in
the DT, for a given timing.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/memory/tegra/tegra-mc.c | 172 ++++++++++++++++++++++++++++++++++++++++
 include/soc/tegra/memory.h      |  17 ++++
 2 files changed, 189 insertions(+)
 create mode 100644 include/soc/tegra/memory.h

diff --git a/drivers/memory/tegra/tegra-mc.c b/drivers/memory/tegra/tegra-mc.c
index 0f0c8be..15ec018 100644
--- a/drivers/memory/tegra/tegra-mc.c
+++ b/drivers/memory/tegra/tegra-mc.c
@@ -16,8 +16,10 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/sort.h>
 
 #include <soc/tegra/ahb.h>
+#include <soc/tegra/fuse.h>
 
 #include "tegra-mc.h"
 
@@ -53,8 +55,59 @@
 #define  MC_EMEM_ARB_CFG_CYCLES_PER_UPDATE_MASK	0x1ff
 #define MC_EMEM_ARB_MISC0 0xd8
 
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
+#define MC_EMEM_ADR_CFG 0x54
+#define MC_EMEM_ADR_CFG_EMEM_NUMDEV BIT(0)
+
 struct tegra_smmu;
 
+static int t124_mc_burst_regs[] = {
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
+struct mc_timing {
+	unsigned long rate;
+
+	u32 mc_burst_data[ARRAY_SIZE(t124_mc_burst_regs)];
+};
+
 struct tegra_mc {
 	struct device *dev;
 	struct tegra_smmu *smmu;
@@ -64,6 +117,9 @@ struct tegra_mc {
 
 	const struct tegra_mc_soc *soc;
 	unsigned long tick;
+
+	struct mc_timing *timings;
+	unsigned int num_timings;
 };
 
 static inline u32 mc_readl(struct tegra_mc *mc, unsigned long offset)
@@ -789,6 +845,37 @@ static const struct of_device_id tegra_mc_of_match[] = {
 	{ }
 };
 
+void tegra_mc_write_emem_configuration(struct tegra_mc *mc, unsigned long rate)
+{
+	int i;
+	struct mc_timing timing;
+
+	for (i = 0; i < mc->num_timings; ++i) {
+		timing = mc->timings[i];
+
+		if (timing.rate == rate)
+			break;
+	}
+
+	if (i == mc->num_timings)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(t124_mc_burst_regs); ++i)
+		mc_writel(mc, timing.mc_burst_data[i], t124_mc_burst_regs[i]);
+}
+
+int tegra_mc_get_emem_device_count(struct tegra_mc *mc)
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
+
 /* XXX: provide prototype in public header */
 int tegra_mc_set_bandwidth(struct tegra_mc *mc, unsigned int id,
 			   unsigned long bandwidth)
@@ -966,11 +1053,68 @@ static irqreturn_t tegra_mc_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static int load_one_timing_from_dt(struct tegra_mc *mc,
+				   struct mc_timing *timing,
+				   struct device_node *node)
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
+
+	err = of_property_read_u32_array(node, "nvidia,emem-configuration",
+					 timing->mc_burst_data,
+					 ARRAY_SIZE(timing->mc_burst_data));
+	if (err) {
+		dev_err(mc->dev,
+			"timing %s: failed to read emc burst data\n",
+			node->name);
+		return err;
+	}
+
+	return 0;
+}
+
+static int load_timings_from_dt(struct tegra_mc *mc,
+				struct device_node *node)
+{
+	struct device_node *child;
+	int child_count = of_get_child_count(node);
+	int i = 0, err;
+
+	mc->timings = devm_kzalloc(mc->dev,
+				      sizeof(struct mc_timing) * child_count,
+				      GFP_KERNEL);
+	if (!mc->timings)
+		return -ENOMEM;
+
+	mc->num_timings = child_count;
+
+	for_each_child_of_node(node, child) {
+		struct mc_timing *timing = mc->timings + (i++);
+
+		err = load_one_timing_from_dt(mc, timing, child);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int tegra_mc_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
 	struct resource *res;
 	struct tegra_mc *mc;
+	struct device_node *node;
+	u32 ram_code, node_ram_code;
 	u32 value;
 	int err;
 
@@ -1001,6 +1145,34 @@ static int tegra_mc_probe(struct platform_device *pdev)
 		return PTR_ERR(mc->clk);
 	}
 
+	ram_code = tegra_read_ram_code();
+
+	mc->num_timings = 0;
+
+	for_each_child_of_node(pdev->dev.of_node, node) {
+		if (strcmp(node->name, "timings"))
+			continue;
+
+		err = of_property_read_u32(node, "nvidia,ram-code",
+						&node_ram_code);
+		if (err) {
+			dev_warn(&pdev->dev,
+				 "skipping timing without ram-code\n");
+			continue;
+		}
+
+		if (node_ram_code != ram_code)
+			continue;
+
+		err = load_timings_from_dt(mc, node);
+		if (err)
+			return err;
+		break;
+	}
+
+	if (mc->num_timings == 0)
+		dev_warn(&pdev->dev, "no memory timings registered\n");
+
 	err = tegra_mc_setup_latency_allowance(mc);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to setup latency allowance: %d\n",
diff --git a/include/soc/tegra/memory.h b/include/soc/tegra/memory.h
new file mode 100644
index 0000000..f307516
--- /dev/null
+++ b/include/soc/tegra/memory.h
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2014 NVIDIA Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __SOC_TEGRA_MEMORY_H__
+#define __SOC_TEGRA_MEMORY_H__
+
+struct tegra_mc;
+
+void tegra_mc_write_emem_configuration(struct tegra_mc *mc, unsigned long rate);
+int tegra_mc_get_emem_device_count(struct tegra_mc *mc);
+
+#endif /* __SOC_TEGRA_MEMORY_H__ */
-- 
1.9.3

