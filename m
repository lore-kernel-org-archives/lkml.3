Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3IRO5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:57:15 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13452 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3IRO5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:57:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Sep 2013 07:53:52 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH 11/12] clk: tegra: introduce common tegra_osc_clk_init
Date: Wed, 18 Sep 2013 17:41:03 +0300
Message-ID: <1379515331-19427-12-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a common tegra_osc_clk_init function which handles OSC and
pll ref probing and clock registration.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/Makefile        |    1 +
 drivers/clk/tegra/clk-tegra-osc.c |   81 +++++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk-tegra114.c  |   39 +-----------------
 drivers/clk/tegra/clk.h           |    4 ++
 4 files changed, 88 insertions(+), 37 deletions(-)
 create mode 100644 drivers/clk/tegra/clk-tegra-osc.c

diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
index a02e9a9..5b78841 100644
--- a/drivers/clk/tegra/Makefile
+++ b/drivers/clk/tegra/Makefile
@@ -10,6 +10,7 @@ obj-y					+= clk-tegra-audio.o
 obj-y					+= clk-tegra-periph.o
 obj-y					+= clk-tegra-pmc.o
 obj-y					+= clk-tegra-fixed.o
+obj-y					+= clk-tegra-osc.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= clk-tegra114.o
diff --git a/drivers/clk/tegra/clk-tegra-osc.c b/drivers/clk/tegra/clk-tegra-osc.c
new file mode 100644
index 0000000..bf8f32c
--- /dev/null
+++ b/drivers/clk/tegra/clk-tegra-osc.c
@@ -0,0 +1,81 @@
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
+#define OSC_CTRL			0x50
+#define OSC_CTRL_OSC_FREQ_SHIFT		28
+#define OSC_CTRL_PLL_REF_DIV_SHIFT	26
+
+int __init tegra_osc_clk_init(void __iomem *clk_base,
+				struct tegra_clk *tegra_clks,
+				unsigned long *input_freqs, int num,
+				unsigned long *osc_freq,
+				unsigned long *pll_ref_freq)
+{
+	struct clk *clk;
+	struct clk **dt_clk;
+	u32 val, pll_ref_div;
+	unsigned osc_idx;
+
+	val = readl_relaxed(clk_base + OSC_CTRL);
+	osc_idx = val >> OSC_CTRL_OSC_FREQ_SHIFT;
+
+	if (osc_idx < num)
+		*osc_freq = input_freqs[osc_idx];
+
+	if (!*osc_freq) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	dt_clk = tegra_lookup_dt_id(tegra_clk_clk_m, tegra_clks);
+	if (!dt_clk)
+		return 0;
+
+	clk = clk_register_fixed_rate(NULL, "clk_m", NULL, CLK_IS_ROOT,
+				      *osc_freq);
+	clk_register_clkdev(clk, "clk_m", NULL);
+	*dt_clk = clk;
+
+	/* pll_ref */
+	val = (val >> OSC_CTRL_PLL_REF_DIV_SHIFT) & 3;
+	pll_ref_div = 1 << val;
+	dt_clk = tegra_lookup_dt_id(tegra_clk_pll_ref, tegra_clks);
+	if (!dt_clk)
+		return 0;
+
+	clk = clk_register_fixed_factor(NULL, "pll_ref", "clk_m",
+					CLK_SET_RATE_PARENT, 1, pll_ref_div);
+	clk_register_clkdev(clk, "pll_ref", NULL);
+	*dt_clk = clk;
+
+	*pll_ref_freq = *osc_freq / pll_ref_div;
+
+	return 0;
+}
+
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 2598477..b2ddfbf 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -110,10 +110,6 @@
 #define PMC_CTRL_BLINK_ENB 7
 #define PMC_BLINK_TIMER 0x40
 
-#define OSC_CTRL			0x50
-#define OSC_CTRL_OSC_FREQ_SHIFT		28
-#define OSC_CTRL_PLL_REF_DIV_SHIFT	26
-
 #define PLLXC_SW_MAX_P			6
 
 #define CCLKG_BURST_POLICY 0x368
@@ -795,38 +791,6 @@ static struct clk **clks;
 static unsigned long osc_freq;
 static unsigned long pll_ref_freq;
 
-static int __init tegra114_osc_clk_init(void __iomem *clk_base)
-{
-	struct clk *clk;
-	u32 val, pll_ref_div;
-
-	val = readl_relaxed(clk_base + OSC_CTRL);
-
-	osc_freq = tegra114_input_freq[val >> OSC_CTRL_OSC_FREQ_SHIFT];
-	if (!osc_freq) {
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
-	/* clk_m */
-	clk = clk_register_fixed_rate(NULL, "clk_m", NULL, CLK_IS_ROOT,
-				      osc_freq);
-	clk_register_clkdev(clk, "clk_m", NULL);
-	clks[TEGRA114_CLK_CLK_M] = clk;
-
-	/* pll_ref */
-	val = (val >> OSC_CTRL_PLL_REF_DIV_SHIFT) & 3;
-	pll_ref_div = 1 << val;
-	clk = clk_register_fixed_factor(NULL, "pll_ref", "clk_m",
-					CLK_SET_RATE_PARENT, 1, pll_ref_div);
-	clk_register_clkdev(clk, "pll_ref", NULL);
-	clks[TEGRA114_CLK_PLL_REF] = clk;
-
-	pll_ref_freq = osc_freq / pll_ref_div;
-
-	return 0;
-}
-
 static __init void tegra114_utmi_param_configure(void __iomem *clk_base)
 {
 	u32 reg;
@@ -1407,7 +1371,8 @@ static void __init tegra114_clock_init(struct device_node *np)
 	if (!clks)
 		return;
 
-	if (tegra114_osc_clk_init(clk_base) < 0)
+	if (tegra_osc_clk_init(clk_base, tegra114_clks, tegra114_input_freq,
+		ARRAY_SIZE(tegra114_input_freq), &osc_freq, &pll_ref_freq) < 0)
 		return;
 
 	tegra_fixed_clk_init(tegra114_clks);
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 1f24f2a..3b28178 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -610,6 +610,10 @@ void tegra_periph_clk_init(void __iomem *clk_base, void __iomem *pmc_base,
 			struct tegra_clk *tegra_clks);
 void tegra_pmc_clk_init(void __iomem *pmc_base, struct tegra_clk *tegra_clks);
 void tegra_fixed_clk_init(struct tegra_clk *tegra_clks);
+int tegra_osc_clk_init(void __iomem *clk_base, struct tegra_clk *tegra_clks,
+				unsigned long *input_freqs, int num,
+				unsigned long *osc_freq,
+				unsigned long *pll_ref_freq);
 
 void tegra114_clock_tune_cpu_trimmers_high(void);
 void tegra114_clock_tune_cpu_trimmers_low(void);
-- 
1.7.7.rc0.72.g4b5ea.dirty

