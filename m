Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab3IRO4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:56:07 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:6063 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab3IRO4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:56:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Sep 2013 07:52:42 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH 10/12] clk: tegra: move fixed clocks to common file
Date: Wed, 18 Sep 2013 17:41:02 +0300
Message-ID: <1379515331-19427-11-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new file for fixed clocks common between several Tegra
SoCs and move Tegra114 to this new infrastructure.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/Makefile          |    1 +
 drivers/clk/tegra/clk-tegra-fixed.c |   62 +++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk-tegra114.c    |   26 +--------------
 drivers/clk/tegra/clk.h             |    1 +
 4 files changed, 65 insertions(+), 25 deletions(-)
 create mode 100644 drivers/clk/tegra/clk-tegra-fixed.c

diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
index f415246..a02e9a9 100644
--- a/drivers/clk/tegra/Makefile
+++ b/drivers/clk/tegra/Makefile
@@ -9,6 +9,7 @@ obj-y					+= clk-super.o
 obj-y					+= clk-tegra-audio.o
 obj-y					+= clk-tegra-periph.o
 obj-y					+= clk-tegra-pmc.o
+obj-y					+= clk-tegra-fixed.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= clk-tegra114.o
diff --git a/drivers/clk/tegra/clk-tegra-fixed.c b/drivers/clk/tegra/clk-tegra-fixed.c
new file mode 100644
index 0000000..252d710
--- /dev/null
+++ b/drivers/clk/tegra/clk-tegra-fixed.c
@@ -0,0 +1,62 @@
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
+void __init tegra_fixed_clk_init(struct tegra_clk *tegra_clks)
+{
+	struct clk *clk;
+	struct clk **dt_clk;
+
+	/* clk_32k */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_clk_32k, tegra_clks);
+	if (dt_clk) {
+		clk = clk_register_fixed_rate(NULL, "clk_32k", NULL,
+					CLK_IS_ROOT, 32768);
+		clk_register_clkdev(clk, "clk_32k", NULL);
+		*dt_clk = clk;
+	}
+
+	/* clk_m_div2 */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_clk_m_div2, tegra_clks);
+	if (dt_clk) {
+		clk = clk_register_fixed_factor(NULL, "clk_m_div2", "clk_m",
+					CLK_SET_RATE_PARENT, 1, 2);
+		clk_register_clkdev(clk, "clk_m_div2", NULL);
+		*dt_clk = clk;
+	}
+
+	/* clk_m_div4 */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_clk_m_div4, tegra_clks);
+	if (dt_clk) {
+		clk = clk_register_fixed_factor(NULL, "clk_m_div4", "clk_m",
+					CLK_SET_RATE_PARENT, 1, 4);
+		clk_register_clkdev(clk, "clk_m_div4", NULL);
+		*dt_clk = clk;
+	}
+}
+
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 19cd57b..2598477 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -827,30 +827,6 @@ static int __init tegra114_osc_clk_init(void __iomem *clk_base)
 	return 0;
 }
 
-static void __init tegra114_fixed_clk_init(void __iomem *clk_base)
-{
-	struct clk *clk;
-
-	/* clk_32k */
-	clk = clk_register_fixed_rate(NULL, "clk_32k", NULL, CLK_IS_ROOT,
-				      32768);
-	clk_register_clkdev(clk, "clk_32k", NULL);
-	clks[TEGRA114_CLK_CLK_32K] = clk;
-
-	/* clk_m_div2 */
-	clk = clk_register_fixed_factor(NULL, "clk_m_div2", "clk_m",
-					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "clk_m_div2", NULL);
-	clks[TEGRA114_CLK_CLK_M_DIV2] = clk;
-
-	/* clk_m_div4 */
-	clk = clk_register_fixed_factor(NULL, "clk_m_div4", "clk_m",
-					CLK_SET_RATE_PARENT, 1, 4);
-	clk_register_clkdev(clk, "clk_m_div4", NULL);
-	clks[TEGRA114_CLK_CLK_M_DIV4] = clk;
-
-}
-
 static __init void tegra114_utmi_param_configure(void __iomem *clk_base)
 {
 	u32 reg;
@@ -1434,7 +1410,7 @@ static void __init tegra114_clock_init(struct device_node *np)
 	if (tegra114_osc_clk_init(clk_base) < 0)
 		return;
 
-	tegra114_fixed_clk_init(clk_base);
+	tegra_fixed_clk_init(tegra114_clks);
 	tegra114_pll_init(clk_base, pmc_base);
 	tegra114_periph_clk_init(clk_base, pmc_base);
 	tegra_audio_clk_init(clk_base, pmc_base, tegra114_clks, NULL);
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 3ce60c2..1f24f2a 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -609,6 +609,7 @@ void tegra_audio_clk_init(void __iomem *clk_base,
 void tegra_periph_clk_init(void __iomem *clk_base, void __iomem *pmc_base,
 			struct tegra_clk *tegra_clks);
 void tegra_pmc_clk_init(void __iomem *pmc_base, struct tegra_clk *tegra_clks);
+void tegra_fixed_clk_init(struct tegra_clk *tegra_clks);
 
 void tegra114_clock_tune_cpu_trimmers_high(void);
 void tegra114_clock_tune_cpu_trimmers_low(void);
-- 
1.7.7.rc0.72.g4b5ea.dirty

