Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3FGMVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:21:53 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:45032 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab3FGMVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:21:43 -0400
MBOX-Line: From nobody Fri Jun  7 06:19:09 2013
Subject: [PATCH 3/3] clk: tegra: T114: add DFLL DVCO reset control
To: linux-tegra@vger.kernel.org, mturquette@linaro.org
From: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Aleksandr Frid <afrid@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 07 Jun 2013 06:19:09 -0600
Message-ID: <20130607121901.21868.65416.stgit@dusk.lan>
In-Reply-To: <20130607121505.21868.72360.stgit@dusk.lan>
References: <20130607121505.21868.72360.stgit@dusk.lan>
User-Agent: StGit/0.16-37-g27ac3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DFLL DVCO reset line control functions to the CAR IP block driver.

The DVCO present in the DFLL IP block has a separate reset line,
exposed via the CAR IP block.  This reset line is asserted upon SoC
reset.  Unless something (such as the DFLL driver) deasserts this
line, the DVCO will not oscillate, although reads and writes to the
DFLL IP block will complete.

Thanks to Aleksandr Frid <afrid@nvidia.com> for identifying this and
saving hours of debugging time.

Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Aleksandr Frid <afrid@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra114.c |   37 +++++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk.h          |    2 ++
 2 files changed, 39 insertions(+)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index b35c78d..4ab15e3 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -29,6 +29,7 @@
 #define RST_DEVICES_L			0x004
 #define RST_DEVICES_H			0x008
 #define RST_DEVICES_U			0x00C
+#define RST_DFLL_DVCO			0x2F4
 #define RST_DEVICES_V			0x358
 #define RST_DEVICES_W			0x35C
 #define RST_DEVICES_X			0x28C
@@ -47,6 +48,9 @@
 #define CPU_FINETRIM_R			0x4e4	/* rise->rise prop dly inc A */
 #define RST_DEVICES_NUM			5
 
+/* RST_DFLL_DVCO bitfields */
+#define DVFS_DFLL_RESET_SHIFT		0
+
 /* CPU_FINETRIM_SELECT and CPU_FINETRIM_DR bitfields */
 #define CPU_FINETRIM_1_FCPU_1		BIT(0)	/* fcpu0 */
 #define CPU_FINETRIM_1_FCPU_2		BIT(1)	/* fcpu1 */
@@ -2183,6 +2187,39 @@ void tegra114_clock_tune_cpu_trimmers_init(void)
 }
 EXPORT_SYMBOL(tegra114_clock_tune_cpu_trimmers_init);
 
+/**
+ * tegra114_clock_assert_dfll_dvco_reset - assert the DFLL's DVCO reset
+ *
+ * Assert the reset line of the DFLL's DVCO.  No return value.
+ */
+void tegra114_clock_assert_dfll_dvco_reset(void)
+{
+	u32 v;
+
+	v = readl_relaxed(clk_base + RST_DFLL_DVCO);
+	v |= (1 << DVFS_DFLL_RESET_SHIFT);
+	writel_relaxed(v, clk_base + RST_DFLL_DVCO);
+	tegra114_car_barrier();
+}
+EXPORT_SYMBOL(tegra114_clock_assert_dfll_dvco_reset);
+
+/**
+ * tegra114_clock_deassert_dfll_dvco_reset - deassert the DFLL's DVCO reset
+ *
+ * Deassert the reset line of the DFLL's DVCO, allowing the DVCO to
+ * operate.  No return value.
+ */
+void tegra114_clock_deassert_dfll_dvco_reset(void)
+{
+	u32 v;
+
+	v = readl_relaxed(clk_base + RST_DFLL_DVCO);
+	v &= ~(1 << DVFS_DFLL_RESET_SHIFT);
+	writel_relaxed(v, clk_base + RST_DFLL_DVCO);
+	tegra114_car_barrier();
+}
+EXPORT_SYMBOL(tegra114_clock_deassert_dfll_dvco_reset);
+
 static void __init tegra114_clock_init(struct device_node *np)
 {
 	struct device_node *node;
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index c0b72fc..c2d84a1 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -574,6 +574,8 @@ void tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
 void tegra114_clock_tune_cpu_trimmers_high(void);
 void tegra114_clock_tune_cpu_trimmers_low(void);
 void tegra114_clock_tune_cpu_trimmers_init(void);
+void tegra114_clock_assert_dfll_dvco_reset(void);
+void tegra114_clock_deassert_dfll_dvco_reset(void);
 
 typedef void (*tegra_clk_apply_init_table_func)(void);
 extern tegra_clk_apply_init_table_func tegra_clk_apply_init_table;


