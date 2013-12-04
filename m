Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab3LDXge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:36:34 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:39537 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab3LDXfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:35:42 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Mike Turquette <mturquette@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 5/7] clk: highbank: allow for different PLL frequency range
Date: Wed,  4 Dec 2013 17:35:25 -0600
Message-Id: <1386200127-23143-6-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386200127-23143-1-git-send-email-robherring2@gmail.com>
References: <1386200127-23143-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Newer versions of Calxeda PLLs have a different frequency range. Make
the max frequency a variable and add a DT property to handle different
maximum frequencies for the PLLs.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/clk-highbank.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
index dc7ca30..89efcbc 100644
--- a/drivers/clk/clk-highbank.c
+++ b/drivers/clk/clk-highbank.c
@@ -30,7 +30,7 @@
 #define HB_PLL_DIVQ_SHIFT	16
 #define HB_PLL_DIVQ_MASK	0x00070000
 #define HB_PLL_DIVR_SHIFT	8
-#define HB_PLL_DIVR_MASK	0x00001f00
+#define HB_PLL_DIVR_MASK	0x00003f00
 #define HB_PLL_RANGE_SHIFT	4
 #define HB_PLL_RANGE_MASK	0x00000070
 #define HB_PLL_BYPASS		0x00000008
@@ -38,9 +38,7 @@
 #define HB_PLL_EXT_BYPASS	0x00000002
 #define HB_PLL_EXT_ENA		0x00000001
 
-#define HB_PLL_VCO_MIN_FREQ	2133000000
-#define HB_PLL_MAX_FREQ		HB_PLL_VCO_MIN_FREQ
-#define HB_PLL_MIN_FREQ		(HB_PLL_VCO_MIN_FREQ / 64)
+#define HB_PLL_MAX_FREQ		2133000000
 
 #define HB_A9_BCLK_DIV_MASK	0x00000006
 #define HB_A9_BCLK_DIV_SHIFT	1
@@ -49,6 +47,7 @@
 struct hb_clk {
         struct clk_hw	hw;
 	void __iomem	*reg;
+	u32 max_freq;
 	char *parent_name;
 };
 #define to_hb_clk(p) container_of(p, struct hb_clk, hw)
@@ -119,19 +118,21 @@ static unsigned long clk_pll_recalc_rate(struct clk_hw *hwclk,
 	return vco_freq / (1 << divq);
 }
 
-static void clk_pll_calc(unsigned long rate, unsigned long ref_freq,
+static void clk_pll_calc(struct clk_hw *hwclk, unsigned long rate,
+			unsigned long ref_freq,
 			u32 *pdivq, u32 *pdivf)
 {
+	u32 pll_max_freq = to_hb_clk(hwclk)->max_freq;
 	u32 divq, divf;
 	unsigned long vco_freq;
 
-	if (rate < HB_PLL_MIN_FREQ)
-		rate = HB_PLL_MIN_FREQ;
-	if (rate > HB_PLL_MAX_FREQ)
-		rate = HB_PLL_MAX_FREQ;
+	if (rate < (pll_max_freq / 64))
+		rate = pll_max_freq / 64;
+	if (rate > pll_max_freq)
+		rate = pll_max_freq;
 
 	for (divq = 1; divq <= 6; divq++) {
-		if ((rate * (1 << divq)) >= HB_PLL_VCO_MIN_FREQ)
+		if ((rate * (1 << divq)) >= pll_max_freq)
 			break;
 	}
 
@@ -149,7 +150,7 @@ static long clk_pll_round_rate(struct clk_hw *hwclk, unsigned long rate,
 	u32 divq, divf;
 	unsigned long ref_freq = *parent_rate;
 
-	clk_pll_calc(rate, ref_freq, &divq, &divf);
+	clk_pll_calc(hwclk, rate, ref_freq, &divq, &divf);
 
 	return (ref_freq * (divf + 1)) / (1 << divq);
 }
@@ -161,7 +162,7 @@ static int clk_pll_set_rate(struct clk_hw *hwclk, unsigned long rate,
 	u32 divq, divf;
 	u32 reg;
 
-	clk_pll_calc(rate, parent_rate, &divq, &divf);
+	clk_pll_calc(hwclk, rate, parent_rate, &divq, &divf);
 
 	reg = readl(hbclk->reg);
 	if (divf != ((reg & HB_PLL_DIVF_MASK) >> HB_PLL_DIVF_SHIFT)) {
@@ -304,6 +305,10 @@ static __init struct clk *hb_clk_init(struct device_node *node, const struct clk
 
 	of_property_read_string(node, "clock-output-names", &clk_name);
 
+	of_property_read_u32(node, "calxeda,pll-max-hz", &hb_clk->max_freq);
+	if (!hb_clk->max_freq)
+		hb_clk->max_freq = HB_PLL_MAX_FREQ;
+
 	init.name = clk_name;
 	init.ops = ops;
 	init.flags = 0;
-- 
1.8.3.2

