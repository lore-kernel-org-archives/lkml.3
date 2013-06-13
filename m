Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab3FMBtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:49:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41170 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab3FMBtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:49:15 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: [RFC/PATCH 07/13] clk: msm: Add support for branches/gate clocks
Date: Wed, 12 Jun 2013 18:49:03 -0700
Message-Id: <1371088149-22562-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.378.g9926f66
In-Reply-To: <1371088149-22562-1-git-send-email-sboyd@codeaurora.org>
References: <1371088149-22562-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/devicetree/bindings/clock/msm.txt |  28 ++++
 drivers/clk/msm/Makefile                        |   1 +
 drivers/clk/msm/clk-branch.c                    | 190 ++++++++++++++++++++++++
 drivers/clk/msm/clk-branch.h                    |  48 ++++++
 4 files changed, 267 insertions(+)
 create mode 100644 drivers/clk/msm/clk-branch.c
 create mode 100644 drivers/clk/msm/clk-branch.h

diff --git a/Documentation/devicetree/bindings/clock/msm.txt b/Documentation/devicetree/bindings/clock/msm.txt
index f4595fa..6840398 100644
--- a/Documentation/devicetree/bindings/clock/msm.txt
+++ b/Documentation/devicetree/bindings/clock/msm.txt
@@ -69,3 +69,31 @@ Example:
 		clocks = <&pxo>, <&pll2>, <&pll8>;
 	};
 
+CXC Binding
+-----------
+
+Required properties:
+- compatible : shall be "qcom,cxc-clock".
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : from common clock binding; shall be set to the source being gated
+
+Example:
+	gsbi5_uart_clk: gsbi5_uart_cxc {
+		#clock-cells = <0>;
+		compatible = "qcom,cxc-clock";
+		clocks = <&gsbi5_uart_rcg>;
+	};
+
+CXC With Hardware Gating Binding
+--------------------------------
+
+Required properties:
+- compatible : shall be "qcom,cxc-hg-clock".
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : from common clock binding; shall be set to the source being gated
+
+	gsbi5_uart_ahb: gsbi5_uart_ahb {
+		#clock-cells = <0>;
+		compatible = "qcom,cxc-hg-clock";
+		clocks = <&cfpb_clk>;
+	};
diff --git a/drivers/clk/msm/Makefile b/drivers/clk/msm/Makefile
index fb78ac9..e1cee29 100644
--- a/drivers/clk/msm/Makefile
+++ b/drivers/clk/msm/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_COMMON_CLK_MSM) += clk-msm.o
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-pll.o
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-rcg.o
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-rcg2.o
+clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-branch.o
diff --git a/drivers/clk/msm/clk-branch.c b/drivers/clk/msm/clk-branch.c
new file mode 100644
index 0000000..ff2e599
--- /dev/null
+++ b/drivers/clk/msm/clk-branch.c
@@ -0,0 +1,190 @@
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
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/clk-provider.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+
+#include "clk-branch.h"
+
+/**
+ * struct clk_branch - gating clock with status bit and dynamic hardware gating
+ *
+ * @ctl_reg: clock control register
+ * @ctl_bit: ORed with @ctl_reg to enable the clock
+ * @hwcg_reg: dynamic hardware clock gating register
+ * @hwcg_bit: ORed with @hwcg_reg to enable dynamic hardware clock gating
+ * @halt_reg: halt register
+ * @halt_bit: ANDed with @halt_reg to test for clock halted
+ * @halt_check: type of halt checking to perform
+ * @hw: handle between common and hardware-specific interfaces
+ * @lock: register lock
+ *
+ * Clock which can gate its output.
+ */
+struct clk_branch {
+	void __iomem	*ctl_reg;
+	void __iomem	*hwcg_reg;
+	void __iomem	*halt_reg;
+
+	u8		ctl_bit;
+	u8		hwcg_bit;
+	u8		halt_bit;
+	u8		halt_check;
+
+	struct clk_hw	hw;
+	spinlock_t	*lock;
+};
+
+#define to_clk_branch(_hw) container_of(_hw, struct clk_branch, hw)
+
+static bool clk_branch_is_halted(const struct clk_branch *br)
+{
+	bool invert = (br->halt_check == BRANCH_HALT_ENABLE);
+	u32 status_bit = readl_relaxed(br->halt_reg) & BIT(br->halt_bit);
+	return invert ? !status_bit : status_bit;
+}
+
+static bool clk_branch_in_hwcg_mode(const struct clk_branch *br)
+{
+	if (!br->hwcg_reg)
+		return 0;
+
+	return !!(readl_relaxed(br->hwcg_reg) & BIT(br->hwcg_bit));
+}
+
+static int clk_branch_wait(const struct clk_branch *br, bool enabling)
+{
+	bool voted = br->halt_check & BRANCH_VOTED;
+	const char *name = __clk_get_name(br->hw.clk);
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
+			if (clk_branch_is_halted(br) == !enabling)
+				return 0;
+			udelay(1);
+		}
+		WARN("%s status stuck at 'o%s'", name, enabling ? "ff" : "n");
+		return -EBUSY;
+	}
+	return 0;
+}
+
+static int clk_branch_toggle(const struct clk_hw *hw, bool en)
+{
+	struct clk_branch *br = to_clk_branch(hw);
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(br->lock, flags);
+
+	val = readl_relaxed(br->ctl_reg);
+	if (en)
+		val |= BIT(br->ctl_bit);
+	else
+		val &= ~BIT(br->ctl_bit);
+	writel(val, br->ctl_reg);
+
+	spin_unlock_irqrestore(br->lock, flags);
+
+	return clk_branch_wait(br, en);
+}
+
+static int clk_branch_enable(struct clk_hw *hw)
+{
+	return clk_branch_toggle(hw, true);
+}
+
+static void clk_branch_disable(struct clk_hw *hw)
+{
+	clk_branch_toggle(hw, false);
+}
+
+static int clk_branch_is_enabled(struct clk_hw *hw)
+{
+	struct clk_branch *br = to_clk_branch(hw);
+	u32 val;
+
+	val = readl_relaxed(br->ctl_reg);
+	val &= BIT(br->ctl_bit);
+
+	return val ? 1 : 0;
+}
+
+static const struct clk_ops clk_branch_ops = {
+	.enable = clk_branch_enable,
+	.is_enabled = clk_branch_is_enabled,
+	.disable = clk_branch_disable,
+};
+
+struct clk *branch_clk_register(struct device *dev, struct branch_desc *desc,
+		spinlock_t *lock, struct clk_init_data *init)
+{
+	struct clk_branch *b;
+
+	b = devm_kzalloc(dev, sizeof(*b), GFP_KERNEL);
+	if (!b)
+		return ERR_PTR(-ENOMEM);
+
+	b->ctl_reg = desc->base + desc->ctl_reg;
+	b->halt_reg = desc->base + desc->halt_reg;
+	b->ctl_bit = desc->ctl_bit;
+	b->halt_bit = desc->halt_bit;
+	b->halt_check = desc->halt_check;
+	b->lock = lock;
+
+	init->ops = &clk_branch_ops;
+	init->flags |= CLK_SET_RATE_PARENT;
+	b->hw.init = init;
+
+	return devm_clk_register(dev, &b->hw);
+}
+
+struct clk *branch_hg_clk_register(struct device *dev, struct branch_desc *desc,
+		spinlock_t *lock, struct clk_init_data *init)
+{
+	struct clk_branch *b;
+
+	b = devm_kzalloc(dev, sizeof(*b), GFP_KERNEL);
+	if (!b)
+		return ERR_PTR(-ENOMEM);
+
+	b->ctl_reg = desc->base + desc->ctl_reg;
+	b->halt_reg = desc->base + desc->halt_reg;
+	b->hwcg_reg = desc->base + desc->hwcg_reg;
+	b->ctl_bit = desc->ctl_bit;
+	b->halt_bit = desc->halt_bit;
+	b->halt_check = desc->halt_check;
+	b->lock = lock;
+
+	init->ops = &clk_branch_ops;
+	init->flags |= CLK_SET_RATE_PARENT;
+	b->hw.init = init;
+
+	return devm_clk_register(dev, &b->hw);
+}
diff --git a/drivers/clk/msm/clk-branch.h b/drivers/clk/msm/clk-branch.h
new file mode 100644
index 0000000..bcb7345
--- /dev/null
+++ b/drivers/clk/msm/clk-branch.h
@@ -0,0 +1,48 @@
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
+#ifndef __MSM_CLK_BRANCH_H__
+#define __MSM_CLK_BRANCH_H__
+
+#include <linux/spinlock.h>
+
+struct device;
+struct clk;
+struct clk_init_data;
+
+struct branch_desc {
+	void __iomem *base;
+	u32 ctl_reg;
+	u32 hwcg_reg;
+	u32 halt_reg;
+
+	u8 ctl_bit;
+	u8 hwcg_bit;
+	u8 halt_bit;
+	u8 halt_check;
+#define BRANCH_VOTED			BIT(7) /* Delay on disable */
+#define BRANCH_HALT			0 /* pol: 1 = halt */
+#define BRANCH_HALT_VOTED		(BRANCH_HALT | BRANCH_VOTED)
+#define BRANCH_HALT_ENABLE		1 /* pol: 0 = halt */
+#define BRANCH_HALT_ENABLE_VOTED	(BRANCH_HALT_ENABLE | BRANCH_VOTED)
+#define BRANCH_HALT_DELAY		2 /* No bit to check; just delay */
+};
+
+extern struct clk *branch_clk_register(struct device *dev,
+		struct branch_desc *desc, spinlock_t *lock,
+		struct clk_init_data *init);
+extern struct clk *branch_hg_clk_register(struct device *dev,
+		struct branch_desc *desc, spinlock_t *lock,
+		struct clk_init_data *init);
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

