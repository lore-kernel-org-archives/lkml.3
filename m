Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab3IROyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:54:55 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1706 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3IROyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:54:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Sep 2013 07:51:32 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH 09/12] clk: tegra: move PMC clocks to common file
Date: Wed, 18 Sep 2013 17:41:01 +0300
Message-ID: <1379515331-19427-10-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new file for PMC clocks common between several Tegra
SoCs and move Tegra114 to this new infrastructure.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/Makefile        |    1 +
 drivers/clk/tegra/clk-tegra-pmc.c |  131 +++++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk-tegra114.c  |   69 +-------------------
 drivers/clk/tegra/clk.h           |    2 +-
 4 files changed, 134 insertions(+), 69 deletions(-)
 create mode 100644 drivers/clk/tegra/clk-tegra-pmc.c

diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
index 304ea5d..f415246 100644
--- a/drivers/clk/tegra/Makefile
+++ b/drivers/clk/tegra/Makefile
@@ -8,6 +8,7 @@ obj-y					+= clk-pll-out.o
 obj-y					+= clk-super.o
 obj-y					+= clk-tegra-audio.o
 obj-y					+= clk-tegra-periph.o
+obj-y					+= clk-tegra-pmc.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= clk-tegra114.o
diff --git a/drivers/clk/tegra/clk-tegra-pmc.c b/drivers/clk/tegra/clk-tegra-pmc.c
new file mode 100644
index 0000000..2655acd
--- /dev/null
+++ b/drivers/clk/tegra/clk-tegra-pmc.c
@@ -0,0 +1,131 @@
+/*
+ * Copyright (c) 2012, 2013, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/delay.h>
+#include <linux/export.h>
+#include <linux/clk/tegra.h>
+
+#include "clk.h"
+#include "clk-id.h"
+
+#define PMC_CLK_OUT_CNTRL 0x1a8
+#define PMC_DPD_PADS_ORIDE 0x1c
+#define PMC_DPD_PADS_ORIDE_BLINK_ENB 20
+#define PMC_CTRL 0
+#define PMC_CTRL_BLINK_ENB 7
+#define PMC_BLINK_TIMER 0x40
+
+struct pmc_clk_init_data {
+	char *mux_name;
+	char *gate_name;
+	const char **parents;
+	int num_parents;
+	int mux_id;
+	int gate_id;
+	char *dev_name;
+	u8 mux_shift;
+	u8 gate_shift;
+};
+
+#define PMC_CLK(_num, _mux_shift, _gate_shift)\
+	{\
+		.mux_name = "clk_out_" #_num "_mux",\
+		.gate_name = "clk_out_" #_num,\
+		.parents = clk_out ##_num ##_parents,\
+		.num_parents = ARRAY_SIZE(clk_out ##_num ##_parents),\
+		.mux_id = tegra_clk_clk_out_ ##_num ##_mux,\
+		.gate_id = tegra_clk_clk_out_ ##_num,\
+		.dev_name = "extern" #_num,\
+		.mux_shift = _mux_shift,\
+		.gate_shift = _gate_shift,\
+	}
+
+static DEFINE_SPINLOCK(clk_out_lock);
+
+static const char *clk_out1_parents[] = { "clk_m", "clk_m_div2",
+	"clk_m_div4", "extern1",
+};
+
+static const char *clk_out2_parents[] = { "clk_m", "clk_m_div2",
+	"clk_m_div4", "extern2",
+};
+
+static const char *clk_out3_parents[] = { "clk_m", "clk_m_div2",
+	"clk_m_div4", "extern3",
+};
+
+static struct pmc_clk_init_data pmc_clks[] = {
+	PMC_CLK(1, 6, 2),
+	PMC_CLK(2, 14, 10),
+	PMC_CLK(3, 22, 18),
+};
+
+void __init tegra_pmc_clk_init(void __iomem *pmc_base,
+				struct tegra_clk *tegra_clks)
+{
+	struct clk *clk;
+	struct clk **dt_clk;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(pmc_clks); i++) {
+		struct pmc_clk_init_data *data;
+
+		data = pmc_clks + i;
+
+		dt_clk = tegra_lookup_dt_id(data->mux_id, tegra_clks);
+		if (!dt_clk)
+			continue;
+
+		clk = clk_register_mux(NULL, data->mux_name, data->parents,
+				data->num_parents, 0,
+				pmc_base + PMC_CLK_OUT_CNTRL, data->mux_shift,
+				3, 0, &clk_out_lock);
+		*dt_clk = clk;
+
+
+		dt_clk = tegra_lookup_dt_id(data->gate_id, tegra_clks);
+		if (!dt_clk)
+			continue;
+
+		clk = clk_register_gate(NULL, data->gate_name, data->mux_name,
+					0, pmc_base + PMC_CLK_OUT_CNTRL,
+					data->gate_shift, 0, &clk_out_lock);
+		*dt_clk = clk;
+		clk_register_clkdev(clk, data->dev_name, data->gate_name);
+	}
+
+	/* blink */
+	clk = clk_register_gate(NULL, "blink_override", "clk_32k", 0,
+				pmc_base + PMC_DPD_PADS_ORIDE,
+				PMC_DPD_PADS_ORIDE_BLINK_ENB, 0, NULL);
+
+	dt_clk = tegra_lookup_dt_id(tegra_clk_blink, tegra_clks);
+	if (!dt_clk)
+		return;
+
+	clk = clk_register_gate(NULL, "blink", "blink_override", 0,
+				pmc_base + PMC_CTRL,
+				PMC_CTRL_BLINK_ENB, 0, NULL);
+	clk_register_clkdev(clk, "blink", NULL);
+	*dt_clk = clk;
+}
+
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 9bcdd29..19cd57b 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -173,7 +173,6 @@ static DEFINE_SPINLOCK(pll_d_lock);
 static DEFINE_SPINLOCK(pll_d2_lock);
 static DEFINE_SPINLOCK(pll_u_lock);
 static DEFINE_SPINLOCK(pll_re_lock);
-static DEFINE_SPINLOCK(clk_out_lock);
 static DEFINE_SPINLOCK(sysrate_lock);
 
 static struct div_nmp pllxc_nmp = {
@@ -1094,72 +1093,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clks[TEGRA114_CLK_PLL_E_OUT0] = clk;
 }
 
-static const char *clk_out1_parents[] = { "clk_m", "clk_m_div2",
-	"clk_m_div4", "extern1",
-};
-
-static const char *clk_out2_parents[] = { "clk_m", "clk_m_div2",
-	"clk_m_div4", "extern2",
-};
-
-static const char *clk_out3_parents[] = { "clk_m", "clk_m_div2",
-	"clk_m_div4", "extern3",
-};
-
-static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
-{
-	struct clk *clk;
-
-	/* clk_out_1 */
-	clk = clk_register_mux(NULL, "clk_out_1_mux", clk_out1_parents,
-			       ARRAY_SIZE(clk_out1_parents), 0,
-			       pmc_base + PMC_CLK_OUT_CNTRL, 6, 3, 0,
-			       &clk_out_lock);
-	clks[TEGRA114_CLK_CLK_OUT_1_MUX] = clk;
-	clk = clk_register_gate(NULL, "clk_out_1", "clk_out_1_mux", 0,
-				pmc_base + PMC_CLK_OUT_CNTRL, 2, 0,
-				&clk_out_lock);
-	clk_register_clkdev(clk, "extern1", "clk_out_1");
-	clks[TEGRA114_CLK_CLK_OUT_1] = clk;
-
-	/* clk_out_2 */
-	clk = clk_register_mux(NULL, "clk_out_2_mux", clk_out2_parents,
-			       ARRAY_SIZE(clk_out2_parents), 0,
-			       pmc_base + PMC_CLK_OUT_CNTRL, 14, 3, 0,
-			       &clk_out_lock);
-	clks[TEGRA114_CLK_CLK_OUT_2_MUX] = clk;
-	clk = clk_register_gate(NULL, "clk_out_2", "clk_out_2_mux", 0,
-				pmc_base + PMC_CLK_OUT_CNTRL, 10, 0,
-				&clk_out_lock);
-	clk_register_clkdev(clk, "extern2", "clk_out_2");
-	clks[TEGRA114_CLK_CLK_OUT_2] = clk;
-
-	/* clk_out_3 */
-	clk = clk_register_mux(NULL, "clk_out_3_mux", clk_out3_parents,
-			       ARRAY_SIZE(clk_out3_parents), 0,
-			       pmc_base + PMC_CLK_OUT_CNTRL, 22, 3, 0,
-			       &clk_out_lock);
-	clks[TEGRA114_CLK_CLK_OUT_3_MUX] = clk;
-	clk = clk_register_gate(NULL, "clk_out_3", "clk_out_3_mux", 0,
-				pmc_base + PMC_CLK_OUT_CNTRL, 18, 0,
-				&clk_out_lock);
-	clk_register_clkdev(clk, "extern3", "clk_out_3");
-	clks[TEGRA114_CLK_CLK_OUT_3] = clk;
-
-	/* blink */
-	/* clear the blink timer register to directly output clk_32k */
-	writel_relaxed(0, pmc_base + PMC_BLINK_TIMER);
-	clk = clk_register_gate(NULL, "blink_override", "clk_32k", 0,
-				pmc_base + PMC_DPD_PADS_ORIDE,
-				PMC_DPD_PADS_ORIDE_BLINK_ENB, 0, NULL);
-	clk = clk_register_gate(NULL, "blink", "blink_override", 0,
-				pmc_base + PMC_CTRL,
-				PMC_CTRL_BLINK_ENB, 0, NULL);
-	clk_register_clkdev(clk, "blink", NULL);
-	clks[TEGRA114_CLK_BLINK] = clk;
-
-}
-
 static const char *sclk_parents[] = { "clk_m", "pll_c_out1", "pll_p_out4",
 			       "pll_p", "pll_p_out2", "unused",
 			       "clk_32k", "pll_m_out1" };
@@ -1505,7 +1438,7 @@ static void __init tegra114_clock_init(struct device_node *np)
 	tegra114_pll_init(clk_base, pmc_base);
 	tegra114_periph_clk_init(clk_base, pmc_base);
 	tegra_audio_clk_init(clk_base, pmc_base, tegra114_clks, NULL);
-	tegra114_pmc_clk_init(pmc_base);
+	tegra_pmc_clk_init(pmc_base, tegra114_clks);
 
 	tegra114_super_clk_init(clk_base);
 
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index e847aa9..3ce60c2 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -606,9 +606,9 @@ void tegra_add_of_provider(struct device_node *np);
 void tegra_audio_clk_init(void __iomem *clk_base,
 			void __iomem *pmc_base, struct tegra_clk *tegra_clks,
 			struct tegra_clk_pll_freq_table *freq_table);
-
 void tegra_periph_clk_init(void __iomem *clk_base, void __iomem *pmc_base,
 			struct tegra_clk *tegra_clks);
+void tegra_pmc_clk_init(void __iomem *pmc_base, struct tegra_clk *tegra_clks);
 
 void tegra114_clock_tune_cpu_trimmers_high(void);
 void tegra114_clock_tune_cpu_trimmers_low(void);
-- 
1.7.7.rc0.72.g4b5ea.dirty

