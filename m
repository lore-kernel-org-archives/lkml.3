Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaH2LoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:44:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48211 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751678AbaH2LoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:44:06 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Raphael Rigo <ml-arm@syscall.eu>, Arnaud Ebalard <arno@natisbad.org>,
        Simon Boulay <simon.boulay@vitec.com>
Subject: [PATCH 1/4] clk: mvebu: Fix clk frequency value if SSCG is enabled
Date: Fri, 29 Aug 2014 13:43:37 +0200
Message-Id: <1409312620-20631-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409312620-20631-1-git-send-email-gregory.clement@free-electrons.com>
References: <1409312620-20631-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the SSCG (Spread Spectrum Clock Generator) is enabled, it shifts
the frequency of the clock. The percentage is no more than 1% but when
the clock is used for a timer it leads to a clock drift.

This patch allows to correct the affected clock when the SSCG is
enabled. The check is done in an new optional function related to each
SoC: is_sscg_enabled(). If this function is not present then no
correction is done on the clock frequency.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/clk/mvebu/common.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/mvebu/common.h |  1 +
 2 files changed, 75 insertions(+)

diff --git a/drivers/clk/mvebu/common.c b/drivers/clk/mvebu/common.c
index 25ceccf939ad..834d36cf79b0 100644
--- a/drivers/clk/mvebu/common.c
+++ b/drivers/clk/mvebu/common.c
@@ -26,8 +26,78 @@
  * Core Clocks
  */
 
+#define SSCG_CONF_MODE(reg)	(((reg) >> 16) & 0x3)
+#define SSCG_SPREAD_DOWN	0x0
+#define SSCG_SPREAD_UP		0x1
+#define SSCG_SPREAD_CENTRAL	0x2
+#define SSCG_CONF_LOW(reg)	(((reg) >> 8) & 0xFF)
+#define SSCG_CONF_HIGH(reg)	((reg) & 0xFF)
+
 static struct clk_onecell_data clk_data;
 
+static u32 fix_sscg_deviation(struct device_node *np, u32 system_clk)
+{
+	struct device_node *sscg_np = NULL;
+	void __iomem *sscg_map;
+	u32 sscg_reg;
+	s32 low_bound, high_bound;
+	u64 freq_swing_half;
+
+	sscg_np = of_find_node_by_name(np, "sscg");
+	if (sscg_np == NULL) {
+		pr_err("cannot get SSCG register node\n");
+		return system_clk;
+	}
+
+	sscg_map = of_iomap(sscg_np, 0);
+	if (sscg_map == NULL) {
+		pr_err("cannot map SSCG register\n");
+		goto out;
+	}
+
+	sscg_reg = readl(sscg_map);
+	high_bound = SSCG_CONF_HIGH(sscg_reg);
+	low_bound = SSCG_CONF_LOW(sscg_reg);
+
+	if ((high_bound - low_bound) <= 0)
+		goto out;
+	/*
+	 * From the datasheet we got the following formula
+	 * Spread percentage = 1/96 * (H - L) / H
+	 * H = SSCG_High_Boundary
+	 * L = SSCG_Low_Boundary
+	 *
+	 * As the deviation is half of spread then it lead to the
+	 * following formula in the code.
+	 *
+	 * To avoid an overflow and not lose any significant digit in
+	 * the same time we have to use a 64 bit integer.
+	 */
+
+	freq_swing_half = (((u64)high_bound - (u64)low_bound)
+			* (u64)system_clk);
+	do_div(freq_swing_half, (2 * 96 * high_bound));
+
+	switch (SSCG_CONF_MODE(sscg_reg)) {
+	case SSCG_SPREAD_DOWN:
+		system_clk -= freq_swing_half;
+		break;
+	case SSCG_SPREAD_UP:
+		system_clk += freq_swing_half;
+		break;
+	case SSCG_SPREAD_CENTRAL:
+	default:
+		break;
+	}
+
+	iounmap(sscg_map);
+
+out:
+	of_node_put(sscg_np);
+
+	return system_clk;
+}
+
 void __init mvebu_coreclk_setup(struct device_node *np,
 				const struct coreclk_soc_desc *desc)
 {
@@ -62,6 +132,10 @@ void __init mvebu_coreclk_setup(struct device_node *np,
 	of_property_read_string_index(np, "clock-output-names", 1,
 				      &cpuclk_name);
 	rate = desc->get_cpu_freq(base);
+
+	if (desc->is_sscg_enabled && desc->is_sscg_enabled(base))
+		rate = fix_sscg_deviation(np, rate);
+
 	clk_data.clks[1] = clk_register_fixed_rate(NULL, cpuclk_name, NULL,
 						   CLK_IS_ROOT, rate);
 	WARN_ON(IS_ERR(clk_data.clks[1]));
diff --git a/drivers/clk/mvebu/common.h b/drivers/clk/mvebu/common.h
index f968b4d9df92..495f94ff4c90 100644
--- a/drivers/clk/mvebu/common.h
+++ b/drivers/clk/mvebu/common.h
@@ -28,6 +28,7 @@ struct coreclk_soc_desc {
 	u32 (*get_tclk_freq)(void __iomem *sar);
 	u32 (*get_cpu_freq)(void __iomem *sar);
 	void (*get_clk_ratio)(void __iomem *sar, int id, int *mult, int *div);
+	bool (*is_sscg_enabled)(void __iomem *sar);
 	const struct coreclk_ratio *ratios;
 	int num_ratios;
 };
-- 
1.9.1

