Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbaJXOqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:46:46 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:43372 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756458AbaJXOk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:40:56 -0400
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com,
        pdeschrijver@nvidia.com, rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: mturquette@linaro.org, pwalmsley@nvidia.com, vinceh@nvidia.com,
        pgaikwad@nvidia.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tuomas.tynkkynen@iki.fi,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>
Subject: [PATCH v5 05/16] clk: tegra: Add DFLL DVCO reset control for Tegra124
Date: Fri, 24 Oct 2014 17:39:12 +0300
Message-Id: <1414161563-16812-6-git-send-email-mikko.perttunen@kapsi.fi>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414161563-16812-1-git-send-email-mikko.perttunen@kapsi.fi>
References: <1414161563-16812-1-git-send-email-mikko.perttunen@kapsi.fi>
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
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
Signed-off-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
---
 drivers/clk/tegra/clk-tegra124.c | 47 ++++++++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk.h          |  3 +++
 2 files changed, 50 insertions(+)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index e3a8584..7c3cef7 100644
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
@@ -1394,6 +1397,50 @@ static void __init tegra124_clock_apply_init_table(void)
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
2.1.0

