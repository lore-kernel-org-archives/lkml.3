Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaAOSvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:51:36 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49388 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaAOSrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:47:40 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH v5 06/14] clk: qcom: Add support for branches/gate clocks
Date: Wed, 15 Jan 2014 10:47:26 -0800
Message-Id: <1389811654-21397-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
References: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Makefile     |   1 +
 drivers/clk/qcom/clk-branch.c | 159 ++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/qcom/clk-branch.h |  56 +++++++++++++++
 3 files changed, 216 insertions(+)
 create mode 100644 drivers/clk/qcom/clk-branch.c
 create mode 100644 drivers/clk/qcom/clk-branch.h

diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index 5d0a6e0ac01f..1b4f75f58031 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -4,3 +4,4 @@ clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-regmap.o
 clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-pll.o
 clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-rcg.o
 clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-rcg2.o
+clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-branch.o
diff --git a/drivers/clk/qcom/clk-branch.c b/drivers/clk/qcom/clk-branch.c
new file mode 100644
index 000000000000..6b4d2bcb1a53
--- /dev/null
+++ b/drivers/clk/qcom/clk-branch.c
@@ -0,0 +1,159 @@
+/*
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
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
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/export.h>
+#include <linux/clk-provider.h>
+#include <linux/regmap.h>
+
+#include "clk-branch.h"
+
+static bool clk_branch_in_hwcg_mode(const struct clk_branch *br)
+{
+	u32 val;
+
+	if (!br->hwcg_reg)
+		return 0;
+
+	regmap_read(br->clkr.regmap, br->hwcg_reg, &val);
+
+	return !!(val & BIT(br->hwcg_bit));
+}
+
+static bool clk_branch_check_halt(const struct clk_branch *br, bool enabling)
+{
+	bool invert = (br->halt_check == BRANCH_HALT_ENABLE);
+	u32 val;
+
+	regmap_read(br->clkr.regmap, br->halt_reg, &val);
+
+	val &= BIT(br->halt_bit);
+	if (invert)
+		val = !val;
+
+	return !!val == !enabling;
+}
+
+#define BRANCH_CLK_OFF			BIT(31)
+#define BRANCH_NOC_FSM_STATUS_SHIFT	28
+#define BRANCH_NOC_FSM_STATUS_MASK	0x7
+#define BRANCH_NOC_FSM_STATUS_ON	(0x2 << BRANCH_NOC_FSM_STATUS_SHIFT)
+
+static bool clk_branch2_check_halt(const struct clk_branch *br, bool enabling)
+{
+	u32 val;
+	u32 mask;
+
+	mask = BRANCH_NOC_FSM_STATUS_MASK << BRANCH_NOC_FSM_STATUS_SHIFT;
+	mask |= BRANCH_CLK_OFF;
+
+	regmap_read(br->clkr.regmap, br->halt_reg, &val);
+
+	if (enabling) {
+		val &= mask;
+		return (val & BRANCH_CLK_OFF) == 0 ||
+			val == BRANCH_NOC_FSM_STATUS_ON;
+	} else {
+		return val & BRANCH_CLK_OFF;
+	}
+}
+
+static int clk_branch_wait(const struct clk_branch *br, bool enabling,
+		bool (check_halt)(const struct clk_branch *, bool))
+{
+	bool voted = br->halt_check & BRANCH_VOTED;
+	const char *name = __clk_get_name(br->clkr.hw.clk);
+
+	/* Skip checking halt bit if the clock is in hardware gated mode */
+	if (clk_branch_in_hwcg_mode(br))
+		return 0;
+
+	if (br->halt_check == BRANCH_HALT_DELAY || (!enabling && voted)) {
+		udelay(10);
+	} else if (br->halt_check == BRANCH_HALT_ENABLE ||
+		   br->halt_check == BRANCH_HALT ||
+		   (enabling && voted)) {
+		int count = 200;
+
+		while (count-- > 0) {
+			if (check_halt(br, enabling))
+				return 0;
+			udelay(1);
+		}
+		WARN(1, "%s status stuck at 'o%s'", name,
+				enabling ? "ff" : "n");
+		return -EBUSY;
+	}
+	return 0;
+}
+
+static int clk_branch_toggle(struct clk_hw *hw, bool en,
+		bool (check_halt)(const struct clk_branch *, bool))
+{
+	struct clk_branch *br = to_clk_branch(hw);
+	int ret;
+
+	if (en) {
+		ret = clk_enable_regmap(hw);
+		if (ret)
+			return ret;
+	} else {
+		clk_disable_regmap(hw);
+	}
+
+	return clk_branch_wait(br, en, check_halt);
+}
+
+static int clk_branch_enable(struct clk_hw *hw)
+{
+	return clk_branch_toggle(hw, true, clk_branch_check_halt);
+}
+
+static void clk_branch_disable(struct clk_hw *hw)
+{
+	clk_branch_toggle(hw, false, clk_branch_check_halt);
+}
+
+const struct clk_ops clk_branch_ops = {
+	.enable = clk_branch_enable,
+	.disable = clk_branch_disable,
+	.is_enabled = clk_is_enabled_regmap,
+};
+EXPORT_SYMBOL_GPL(clk_branch_ops);
+
+static int clk_branch2_enable(struct clk_hw *hw)
+{
+	return clk_branch_toggle(hw, true, clk_branch2_check_halt);
+}
+
+static void clk_branch2_disable(struct clk_hw *hw)
+{
+	clk_branch_toggle(hw, false, clk_branch2_check_halt);
+}
+
+const struct clk_ops clk_branch2_ops = {
+	.enable = clk_branch2_enable,
+	.disable = clk_branch2_disable,
+	.is_enabled = clk_is_enabled_regmap,
+};
+EXPORT_SYMBOL_GPL(clk_branch2_ops);
+
+const struct clk_ops clk_branch_simple_ops = {
+	.enable = clk_enable_regmap,
+	.disable = clk_disable_regmap,
+	.is_enabled = clk_is_enabled_regmap,
+};
+EXPORT_SYMBOL_GPL(clk_branch_simple_ops);
diff --git a/drivers/clk/qcom/clk-branch.h b/drivers/clk/qcom/clk-branch.h
new file mode 100644
index 000000000000..284df3f3c55f
--- /dev/null
+++ b/drivers/clk/qcom/clk-branch.h
@@ -0,0 +1,56 @@
+/*
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
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
+#ifndef __QCOM_CLK_BRANCH_H__
+#define __QCOM_CLK_BRANCH_H__
+
+#include <linux/clk-provider.h>
+
+#include "clk-regmap.h"
+
+/**
+ * struct clk_branch - gating clock with status bit and dynamic hardware gating
+ *
+ * @hwcg_reg: dynamic hardware clock gating register
+ * @hwcg_bit: ORed with @hwcg_reg to enable dynamic hardware clock gating
+ * @halt_reg: halt register
+ * @halt_bit: ANDed with @halt_reg to test for clock halted
+ * @halt_check: type of halt checking to perform
+ * @clkr: handle between common and hardware-specific interfaces
+ *
+ * Clock which can gate its output.
+ */
+struct clk_branch {
+	u32	hwcg_reg;
+	u32	halt_reg;
+	u8	hwcg_bit;
+	u8	halt_bit;
+	u8	halt_check;
+#define BRANCH_VOTED			BIT(7) /* Delay on disable */
+#define BRANCH_HALT			0 /* pol: 1 = halt */
+#define BRANCH_HALT_VOTED		(BRANCH_HALT | BRANCH_VOTED)
+#define BRANCH_HALT_ENABLE		1 /* pol: 0 = halt */
+#define BRANCH_HALT_ENABLE_VOTED	(BRANCH_HALT_ENABLE | BRANCH_VOTED)
+#define BRANCH_HALT_DELAY		2 /* No bit to check; just delay */
+
+	struct clk_regmap clkr;
+};
+
+extern const struct clk_ops clk_branch_ops;
+extern const struct clk_ops clk_branch2_ops;
+extern const struct clk_ops clk_branch_simple_ops;
+
+#define to_clk_branch(_hw) \
+	container_of(to_clk_regmap(_hw), struct clk_branch, clkr)
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

