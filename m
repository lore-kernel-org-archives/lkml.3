Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbaKTAMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:12:34 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60881 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbaKTAKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:10:51 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Josh Cartwright <joshc@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kenneth Westfield <kwestfie@codeaurora.org>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Kumar Gala <galak@codeaurora.org>,
        Rajendra Nayak <rnayak@codeaurora.com>
Subject: [PATCH 3/7] clk: qcom: Add support for cdiv clocks
Date: Wed, 19 Nov 2014 16:10:41 -0800
Message-Id: <1416442245-21967-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
In-Reply-To: <1416442245-21967-1-git-send-email-sboyd@codeaurora.org>
References: <1416442245-21967-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Cartwright <joshc@codeaurora.org>

cdiv clocks are dividers with a on/off gate control.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Signed-off-by: Rajendra Nayak <rnayak@codeaurora.com>
[sboyd@codeaurora.org: Switch to using generic divider code]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Makefile   |  1 +
 drivers/clk/qcom/clk-cdiv.c | 72 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/qcom/clk-cdiv.h | 29 ++++++++++++++++++
 3 files changed, 102 insertions(+)
 create mode 100644 drivers/clk/qcom/clk-cdiv.c
 create mode 100644 drivers/clk/qcom/clk-cdiv.h

diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index 783cfb24faa4..f26917c6bfd7 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -6,6 +6,7 @@ clk-qcom-y += clk-pll.o
 clk-qcom-y += clk-rcg.o
 clk-qcom-y += clk-rcg2.o
 clk-qcom-y += clk-branch.o
+clk-qcom-y += clk-cdiv.o
 clk-qcom-y += reset.o
 
 obj-$(CONFIG_APQ_GCC_8084) += gcc-apq8084.o
diff --git a/drivers/clk/qcom/clk-cdiv.c b/drivers/clk/qcom/clk-cdiv.c
new file mode 100644
index 000000000000..dc93e8feae43
--- /dev/null
+++ b/drivers/clk/qcom/clk-cdiv.c
@@ -0,0 +1,72 @@
+/*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+#include <linux/regmap.h>
+#include <linux/export.h>
+
+#include "clk-cdiv.h"
+
+static inline struct clk_regmap_div *to_clk_regmap_div(struct clk_hw *hw)
+{
+	return container_of(to_clk_regmap(hw), struct clk_regmap_div, clkr);
+}
+
+static long div_round_rate(struct clk_hw *hw, unsigned long rate,
+			   unsigned long *prate)
+{
+	struct clk_regmap_div *divider = to_clk_regmap_div(hw);
+
+	return divider_round_rate(hw, rate, prate, NULL, divider->width,
+				  CLK_DIVIDER_ROUND_CLOSEST);
+}
+
+static int div_set_rate(struct clk_hw *hw, unsigned long rate,
+			unsigned long parent_rate)
+{
+	struct clk_regmap_div *divider = to_clk_regmap_div(hw);
+	struct clk_regmap *clkr = &divider->clkr;
+	u32 div;
+
+	div = divider_get_val(rate, parent_rate, NULL, divider->width,
+			      CLK_DIVIDER_ROUND_CLOSEST);
+
+	return regmap_update_bits(clkr->regmap, divider->reg,
+				  (BIT(divider->width) - 1) << divider->shift,
+				  div << divider->shift);
+}
+
+static unsigned long div_recalc_rate(struct clk_hw *hw,
+				     unsigned long parent_rate)
+{
+	struct clk_regmap_div *divider = to_clk_regmap_div(hw);
+	struct clk_regmap *clkr = &divider->clkr;
+	u32 div;
+
+	regmap_read(clkr->regmap, divider->reg, &div);
+	div >>= divider->shift;
+	div &= BIT(divider->width) - 1;
+
+	return divider_recalc_rate(hw, parent_rate, div, NULL,
+				   CLK_DIVIDER_ROUND_CLOSEST);
+}
+
+const struct clk_ops clk_regmap_div_ops = {
+	.enable = clk_enable_regmap,
+	.disable = clk_disable_regmap,
+	.round_rate = div_round_rate,
+	.set_rate = div_set_rate,
+	.recalc_rate = div_recalc_rate,
+};
+EXPORT_SYMBOL_GPL(clk_regmap_div_ops);
diff --git a/drivers/clk/qcom/clk-cdiv.h b/drivers/clk/qcom/clk-cdiv.h
new file mode 100644
index 000000000000..50aa338621d6
--- /dev/null
+++ b/drivers/clk/qcom/clk-cdiv.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __QCOM_CLK_CDIV_H__
+#define __QCOM_CLK_CDIV_H__
+
+#include <linux/clk-provider.h>
+#include "clk-regmap.h"
+
+struct clk_regmap_div {
+	u32			reg;
+	u32			shift;
+	u32			width;
+	struct clk_regmap	clkr;
+};
+
+extern const struct clk_ops clk_regmap_div_ops;
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

