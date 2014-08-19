Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaHSDlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 23:41:50 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:41461 "EHLO
	script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaHSDjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 23:39:46 -0400
X-DKIM: Courier DKIM Filter v0.50+pk-2014-03-23 mail.cs.helsinki.fi Tue, 19 Aug 2014 06:34:10 +0300
From: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
To: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, Vince Hsu <vinceh@nvidia.com>,
        devicetree@vger.kernel.org, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v3 05/15] clk: tegra: Add DFLL DVCO reset control for Tegra124
Date: Tue, 19 Aug 2014 06:33:15 +0300
Message-Id: <1408419205-10048-6-git-send-email-tuomas.tynkkynen@iki.fi>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>
References: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Walmsley <pwalmsley@nvidia.com>

The DVCO present in the DFLL IP block has a separate reset line,
exposed via the CAR IP block.  This reset line is asserted upon SoC
reset.  Unless something (such as the DFLL driver) deasserts this
line, the DVCO will not oscillate, although reads and writes to the
DFLL IP block will complete.

Thanks to Aleksandr Frid <afrid@nvidia.com> for identifying this and
saving hours of debugging time.

Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
[ttynkkynen: ported to tegra124 from tegra114]
Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 drivers/clk/tegra/clk-tegra124.c | 47 ++++++++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk.h          |  3 +++
 2 files changed, 50 insertions(+)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 9525c68..cc81eab 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -31,6 +31,9 @@
 #define CLK_SOURCE_CSITE 0x1d4
 #define CLK_SOURCE_EMC 0x19c
 
+#define RST_DFLL_DVCO			0x2f4
+#define DVFS_DFLL_RESET_SHIFT		0
+
 #define PLLC_BASE 0x80
 #define PLLC_OUT 0x84
 #define PLLC_MISC2 0x88
@@ -1386,6 +1389,50 @@ static void __init tegra124_clock_apply_init_table(void)
 	tegra_init_from_table(init_table, clks, TEGRA124_CLK_CLK_MAX);
 }
 
+/**
+ * tegra124_car_barrier - wait for pending writes to the CAR to complete
+ *
+ * Wait for any outstanding writes to the CAR MMIO space from this CPU
+ * to complete before continuing execution.  No return value.
+ */
+static void tegra124_car_barrier(void)
+{
+	readl_relaxed(clk_base + RST_DFLL_DVCO);
+}
+
+/**
+ * tegra124_clock_assert_dfll_dvco_reset - assert the DFLL's DVCO reset
+ *
+ * Assert the reset line of the DFLL's DVCO.  No return value.
+ */
+void tegra124_clock_assert_dfll_dvco_reset(void)
+{
+	u32 v;
+
+	v = readl_relaxed(clk_base + RST_DFLL_DVCO);
+	v |= (1 << DVFS_DFLL_RESET_SHIFT);
+	writel_relaxed(v, clk_base + RST_DFLL_DVCO);
+	tegra124_car_barrier();
+}
+EXPORT_SYMBOL(tegra124_clock_assert_dfll_dvco_reset);
+
+/**
+ * tegra124_clock_deassert_dfll_dvco_reset - deassert the DFLL's DVCO reset
+ *
+ * Deassert the reset line of the DFLL's DVCO, allowing the DVCO to
+ * operate.  No return value.
+ */
+void tegra124_clock_deassert_dfll_dvco_reset(void)
+{
+	u32 v;
+
+	v = readl_relaxed(clk_base + RST_DFLL_DVCO);
+	v &= ~(1 << DVFS_DFLL_RESET_SHIFT);
+	writel_relaxed(v, clk_base + RST_DFLL_DVCO);
+	tegra124_car_barrier();
+}
+EXPORT_SYMBOL(tegra124_clock_deassert_dfll_dvco_reset);
+
 static void __init tegra124_clock_init(struct device_node *np)
 {
 	struct device_node *node;
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 16ec8d6..4b3f3d0 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -627,6 +627,9 @@ void tegra114_clock_tune_cpu_trimmers_init(void);
 void tegra114_clock_assert_dfll_dvco_reset(void);
 void tegra114_clock_deassert_dfll_dvco_reset(void);
 
+void tegra124_clock_assert_dfll_dvco_reset(void);
+void tegra124_clock_deassert_dfll_dvco_reset(void);
+
 typedef void (*tegra_clk_apply_init_table_func)(void);
 extern tegra_clk_apply_init_table_func tegra_clk_apply_init_table;
 
-- 
1.8.1.5

