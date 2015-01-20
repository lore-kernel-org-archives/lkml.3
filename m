Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbbATCFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:05:48 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41471 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbbATCFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:05:40 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 4/8] clk: qcom: Add simple regmap based muxes
Date: Mon, 19 Jan 2015 18:05:31 -0800
Message-Id: <1421719535-28398-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
In-Reply-To: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
References: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for muxes that use regmap instead of readl/writel
directly. We don't support as many features as clk-mux.c, but
this is good enough to support getting and setting parents.
Adding a table based lookup can be added in the future if needed.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Makefile         |  1 +
 drivers/clk/qcom/clk-regmap-mux.c | 59 +++++++++++++++++++++++++++++++++++++++
 drivers/clk/qcom/clk-regmap-mux.h | 29 +++++++++++++++++++
 3 files changed, 89 insertions(+)
 create mode 100644 drivers/clk/qcom/clk-regmap-mux.c
 create mode 100644 drivers/clk/qcom/clk-regmap-mux.h

diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index ed8976e87c0b..f5e5607f3965 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -7,6 +7,7 @@ clk-qcom-y += clk-rcg.o
 clk-qcom-y += clk-rcg2.o
 clk-qcom-y += clk-branch.o
 clk-qcom-y += clk-regmap-divider.o
+clk-qcom-y += clk-regmap-mux.o
 clk-qcom-y += reset.o
 
 obj-$(CONFIG_APQ_GCC_8084) += gcc-apq8084.o
diff --git a/drivers/clk/qcom/clk-regmap-mux.c b/drivers/clk/qcom/clk-regmap-mux.c
new file mode 100644
index 000000000000..cae3071f384c
--- /dev/null
+++ b/drivers/clk/qcom/clk-regmap-mux.c
@@ -0,0 +1,59 @@
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
+#include "clk-regmap-mux.h"
+
+static inline struct clk_regmap_mux *to_clk_regmap_mux(struct clk_hw *hw)
+{
+	return container_of(to_clk_regmap(hw), struct clk_regmap_mux, clkr);
+}
+
+static u8 mux_get_parent(struct clk_hw *hw)
+{
+	struct clk_regmap_mux *mux = to_clk_regmap_mux(hw);
+	struct clk_regmap *clkr = to_clk_regmap(hw);
+	unsigned int mask = GENMASK(mux->width - 1, 0);
+	unsigned int val;
+
+	regmap_read(clkr->regmap, mux->reg, &val);
+
+	val >>= mux->shift;
+	val &= mask;
+
+	return val;
+}
+
+static int mux_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_regmap_mux *mux = to_clk_regmap_mux(hw);
+	struct clk_regmap *clkr = to_clk_regmap(hw);
+	unsigned int mask = GENMASK(mux->width + mux->shift - 1, mux->shift);
+	unsigned int val;
+
+	val = index;
+	val <<= mux->shift;
+
+	return regmap_update_bits(clkr->regmap, mux->reg, mask, val);
+}
+
+const struct clk_ops clk_regmap_mux_closest_ops = {
+	.get_parent = mux_get_parent,
+	.set_parent = mux_set_parent,
+	.determine_rate = __clk_mux_determine_rate_closest,
+};
+EXPORT_SYMBOL_GPL(clk_regmap_mux_closest_ops);
diff --git a/drivers/clk/qcom/clk-regmap-mux.h b/drivers/clk/qcom/clk-regmap-mux.h
new file mode 100644
index 000000000000..5cec76154fda
--- /dev/null
+++ b/drivers/clk/qcom/clk-regmap-mux.h
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
+#ifndef __QCOM_CLK_REGMAP_MUX_H__
+#define __QCOM_CLK_REGMAP_MUX_H__
+
+#include <linux/clk-provider.h>
+#include "clk-regmap.h"
+
+struct clk_regmap_mux {
+	u32			reg;
+	u32			shift;
+	u32			width;
+	struct clk_regmap	clkr;
+};
+
+extern const struct clk_ops clk_regmap_mux_closest_ops;
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

