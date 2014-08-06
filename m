Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaHFSPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:15:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40603 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbaHFSPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:15:15 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] clk: qcom: Add support for setting rates on PLLs
Date: Wed,  6 Aug 2014 11:15:10 -0700
Message-Id: <1407348912-9124-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1407348912-9124-1-git-send-email-sboyd@codeaurora.org>
References: <1407348912-9124-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PLLs may require changing their rate at runtime. Add support
for these PLLs.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/clk-pll.c | 68 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/clk/qcom/clk-pll.h | 20 ++++++++++++++
 2 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-pll.c b/drivers/clk/qcom/clk-pll.c
index 9db03d3b1657..b823bc3b6250 100644
--- a/drivers/clk/qcom/clk-pll.c
+++ b/drivers/clk/qcom/clk-pll.c
@@ -97,7 +97,7 @@ static unsigned long
 clk_pll_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
 {
 	struct clk_pll *pll = to_clk_pll(hw);
-	u32 l, m, n;
+	u32 l, m, n, config;
 	unsigned long rate;
 	u64 tmp;
 
@@ -116,13 +116,79 @@ clk_pll_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
 		do_div(tmp, n);
 		rate += tmp;
 	}
+	if (pll->post_div_width) {
+		regmap_read(pll->clkr.regmap, pll->config_reg, &config);
+		config >>= pll->post_div_shift;
+		config &= BIT(pll->post_div_width) - 1;
+		rate /= config + 1;
+	}
+
 	return rate;
 }
 
+static const
+struct pll_freq_tbl *find_freq(const struct pll_freq_tbl *f, unsigned long rate)
+{
+	if (!f)
+		return NULL;
+
+	for (; f->freq; f++)
+		if (rate <= f->freq)
+			return f;
+
+	return NULL;
+}
+
+static long
+clk_pll_determine_rate(struct clk_hw *hw, unsigned long rate,
+		       unsigned long *p_rate, struct clk **p)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	const struct pll_freq_tbl *f;
+
+	f = find_freq(pll->freq_tbl, rate);
+	if (!f)
+		return clk_pll_recalc_rate(hw, *p_rate);
+
+	return f->freq;
+}
+
+static int
+clk_pll_set_rate(struct clk_hw *hw, unsigned long rate, unsigned long p_rate)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	const struct pll_freq_tbl *f;
+	bool enabled;
+	u32 mode;
+	u32 enable_mask = PLL_OUTCTRL | PLL_BYPASSNL | PLL_RESET_N;
+
+	f = find_freq(pll->freq_tbl, rate);
+	if (!f)
+		return -EINVAL;
+
+	regmap_read(pll->clkr.regmap, pll->mode_reg, &mode);
+	enabled = (mode & enable_mask) == enable_mask;
+
+	if (enabled)
+		clk_pll_disable(hw);
+
+	regmap_update_bits(pll->clkr.regmap, pll->l_reg, 0x3ff, f->l);
+	regmap_update_bits(pll->clkr.regmap, pll->m_reg, 0x7ffff, f->m);
+	regmap_update_bits(pll->clkr.regmap, pll->n_reg, 0x7ffff, f->n);
+	regmap_write(pll->clkr.regmap, pll->config_reg, f->ibits);
+
+	if (enabled)
+		clk_pll_enable(hw);
+
+	return 0;
+}
+
 const struct clk_ops clk_pll_ops = {
 	.enable = clk_pll_enable,
 	.disable = clk_pll_disable,
 	.recalc_rate = clk_pll_recalc_rate,
+	.determine_rate = clk_pll_determine_rate,
+	.set_rate = clk_pll_set_rate,
 };
 EXPORT_SYMBOL_GPL(clk_pll_ops);
 
diff --git a/drivers/clk/qcom/clk-pll.h b/drivers/clk/qcom/clk-pll.h
index 3003e9962472..c9c0cda306d0 100644
--- a/drivers/clk/qcom/clk-pll.h
+++ b/drivers/clk/qcom/clk-pll.h
@@ -18,6 +18,21 @@
 #include "clk-regmap.h"
 
 /**
+ * struct pll_freq_tbl - PLL frequency table
+ * @l: L value
+ * @m: M value
+ * @n: N value
+ * @ibits: internal values
+ */
+struct pll_freq_tbl {
+	unsigned long freq;
+	u16 l;
+	u16 m;
+	u16 n;
+	u32 ibits;
+};
+
+/**
  * struct clk_pll - phase locked loop (PLL)
  * @l_reg: L register
  * @m_reg: M register
@@ -26,6 +41,7 @@
  * @mode_reg: mode register
  * @status_reg: status register
  * @status_bit: ANDed with @status_reg to determine if PLL is enabled
+ * @freq_tbl: PLL frequency table
  * @hw: handle between common and hardware-specific interfaces
  */
 struct clk_pll {
@@ -36,6 +52,10 @@ struct clk_pll {
 	u32	mode_reg;
 	u32	status_reg;
 	u8	status_bit;
+	u8	post_div_width;
+	u8	post_div_shift;
+
+	const struct pll_freq_tbl *freq_tbl;
 
 	struct clk_regmap clkr;
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

