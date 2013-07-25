Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3GYArn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 20:47:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34896 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab3GYAnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 20:43:47 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH v1 05/14] clk: msm: Add support for phase locked loops (PLLs)
Date: Wed, 24 Jul 2013 17:43:33 -0700
Message-Id: <1374713022-6049-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.840.g6a90778
In-Reply-To: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for MSM's PLLs (phase locked loops). This is
sufficient enough to be able to determine the rate the PLL is
running at. We can add rate setting support later when it's
needed.

Cc: devicetree@vger.kernel.org
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/devicetree/bindings/clock/msm.txt |  40 ++++
 drivers/clk/Kconfig                             |   2 +
 drivers/clk/Makefile                            |   1 +
 drivers/clk/msm/Kconfig                         |   4 +
 drivers/clk/msm/Makefile                        |   3 +
 drivers/clk/msm/clk-pll.c                       | 233 ++++++++++++++++++++++++
 drivers/clk/msm/clk-pll.h                       |  43 +++++
 7 files changed, 326 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/msm.txt
 create mode 100644 drivers/clk/msm/Kconfig
 create mode 100644 drivers/clk/msm/Makefile
 create mode 100644 drivers/clk/msm/clk-pll.c
 create mode 100644 drivers/clk/msm/clk-pll.h

diff --git a/Documentation/devicetree/bindings/clock/msm.txt b/Documentation/devicetree/bindings/clock/msm.txt
new file mode 100644
index 0000000..2192621
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/msm.txt
@@ -0,0 +1,40 @@
+Bindings for Qualcomm's clock controllers
+
+These bindings use the common clock binding
+Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+PLL Binding
+-----------
+
+Required properties:
+- compatible : shall be "qcom,pll".
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : from common clock binding; shall be set to the reference clock
+
+Example:
+	pll8: pll8 {
+		#clock-cells = <0>;
+		compatible = "qcom,pll";
+		clocks = <&pxo>;
+	};
+
+Voteable PLL Binding
+--------------------
+
+Voteable PLLs are PLLs surrounded by a voting wrapper that aggregates
+votes from multiple masters in the system and enables or disables the
+PLL according to the current vote.
+
+Required properties:
+- compatible: shall be "qcom,pll-vote"
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : from common clock binding; shall be set to the pll that is wrapped
+  in voting logic
+
+Example:
+	vpll8: vpll8 {
+		#clock-cells = <0>;
+		compatible = "qcom,pll-vote";
+		clocks = <&pll8>;
+	};
+
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 51380d6..fad596b8 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -87,6 +87,8 @@ config CLK_PPC_CORENET
 	  This adds the clock driver support for Freescale PowerPC corenet
 	  platforms using common clock framework.
 
+source "drivers/clk/msm/Kconfig"
+
 endmenu
 
 source "drivers/clk/mvebu/Kconfig"
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 4038c2b..67df66f 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_PLAT_SPEAR)	+= spear/
 obj-$(CONFIG_ARCH_U300)		+= clk-u300.o
 obj-$(CONFIG_COMMON_CLK_VERSATILE) += versatile/
 obj-$(CONFIG_ARCH_SIRF)		+= clk-prima2.o
+obj-$(CONFIG_COMMON_CLK_MSM)	+= msm/
 obj-$(CONFIG_PLAT_ORION)	+= mvebu/
 ifeq ($(CONFIG_COMMON_CLK), y)
 obj-$(CONFIG_ARCH_MMP)		+= mmp/
diff --git a/drivers/clk/msm/Kconfig b/drivers/clk/msm/Kconfig
new file mode 100644
index 0000000..bf7e3d2
--- /dev/null
+++ b/drivers/clk/msm/Kconfig
@@ -0,0 +1,4 @@
+menuconfig COMMON_CLK_MSM
+	tristate "Support for Qualcomm's MSM designs"
+	depends on OF
+
diff --git a/drivers/clk/msm/Makefile b/drivers/clk/msm/Makefile
new file mode 100644
index 0000000..16b750f
--- /dev/null
+++ b/drivers/clk/msm/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_COMMON_CLK_MSM) += clk-msm.o
+
+clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-pll.o
diff --git a/drivers/clk/msm/clk-pll.c b/drivers/clk/msm/clk-pll.c
new file mode 100644
index 0000000..03c2c41
--- /dev/null
+++ b/drivers/clk/msm/clk-pll.c
@@ -0,0 +1,233 @@
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
+#include <asm/div64.h>
+
+#include "clk-pll.h"
+
+/**
+ * struct clk_pll - phase locked loop (PLL)
+ * @l_reg: L register
+ * @m_reg: M register
+ * @n_reg: N register
+ * @config_reg: config register
+ * @mode_reg: mode register
+ * @status_reg: status register
+ * @status_bit: ANDed with @status_reg to determine if PLL is enabled
+ * @hw: handle between common and hardware-specific interfaces
+ */
+struct clk_pll {
+	void __iomem *l_reg;
+	void __iomem *m_reg;
+	void __iomem *n_reg;
+	void __iomem *config_reg;
+	void __iomem *mode_reg;
+	void __iomem *status_reg;
+	u8 status_bit;
+
+	struct clk_hw	hw;
+};
+
+#define to_clk_pll(_hw) container_of(_hw, struct clk_pll, hw)
+
+#define PLL_OUTCTRL	BIT(0)
+#define PLL_BYPASSNL	BIT(1)
+#define PLL_RESET_N	BIT(2)
+
+static int clk_pll_enable(struct clk_hw *hw)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	u32 mode;
+
+	mode = readl_relaxed(pll->mode_reg);
+	/* Disable PLL bypass mode. */
+	mode |= PLL_BYPASSNL;
+	writel(mode, pll->mode_reg);
+
+	/*
+	 * H/W requires a 5us delay between disabling the bypass and
+	 * de-asserting the reset. Delay 10us just to be safe.
+	 */
+	udelay(10);
+
+	/* De-assert active-low PLL reset. */
+	mode |= PLL_RESET_N;
+	writel(mode, pll->mode_reg);
+
+	/* Wait until PLL is locked. */
+	udelay(50);
+
+	/* Enable PLL output. */
+	mode |= PLL_OUTCTRL;
+	writel(mode, pll->mode_reg);
+
+	return 0;
+}
+
+static void clk_pll_disable(struct clk_hw *hw)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	u32 mode;
+
+	mode = readl_relaxed(pll->mode_reg);
+	mode &= ~(PLL_OUTCTRL | PLL_RESET_N | PLL_BYPASSNL);
+	writel_relaxed(mode, pll->mode_reg);
+}
+
+static unsigned long
+clk_pll_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	u32 l, m, n;
+	unsigned long rate;
+	u64 tmp;
+
+	l = readl_relaxed(pll->l_reg) & 0x3ff;
+	m = readl_relaxed(pll->m_reg) & 0x7ffff;
+	n = readl_relaxed(pll->n_reg) & 0x7ffff;
+
+	rate = parent_rate * l;
+	if (n) {
+		tmp = parent_rate;
+		tmp *= m;
+		do_div(tmp, n);
+		rate += tmp;
+	}
+	return rate;
+}
+
+static const struct clk_ops clk_pll_ops = {
+	.enable = clk_pll_enable,
+	.disable = clk_pll_disable,
+	.recalc_rate = clk_pll_recalc_rate,
+};
+
+struct clk *pll_clk_register(struct device *dev, struct pll_desc *desc,
+		struct clk_init_data *init)
+{
+	struct clk_pll *p;
+
+	p = devm_kzalloc(dev, sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+
+	p->l_reg = desc->base + desc->l_reg;
+	p->m_reg = desc->base + desc->m_reg;
+	p->n_reg = desc->base + desc->n_reg;
+	p->config_reg = desc->base + desc->config_reg;
+	p->mode_reg = desc->base + desc->mode_reg;
+	p->status_reg = desc->base + desc->status_reg;
+	p->status_bit = desc->status_bit;
+
+	init->ops = &clk_pll_ops;
+	p->hw.init = init;
+
+	return devm_clk_register(dev, &p->hw);
+}
+
+/**
+ * struct clk_pll_vote - phase locked loop (PLL) with hardware voting wrapper
+ * @vote_reg: Voting register
+ * @vote_bit: ORed into @vote_reg to enable PLL
+ * @hw: handle between common and hardware-specific interfaces
+ */
+struct clk_pll_vote {
+	void __iomem	*vote_reg;
+	u8		vote_bit;
+	struct clk_hw	hw;
+};
+
+#define to_clk_pll_vote(_hw) container_of(_hw, struct clk_pll_vote, hw)
+
+static DEFINE_SPINLOCK(pll_vote_lock);
+
+static int wait_for_pll(struct clk_pll *pll)
+{
+	int count;
+	const char *name = __clk_get_name(pll->hw.clk);
+
+	/* Wait for pll to enable. */
+	for (count = 200; count > 0; count--) {
+		if (readl_relaxed(pll->status_reg) & BIT(pll->status_bit))
+			return 0;
+		udelay(1);
+	}
+
+	WARN("%s didn't enable after voting for it!\n", name);
+	return -ETIMEDOUT;
+}
+
+static int clk_pll_vote_enable(struct clk_hw *hw)
+{
+	u32 val;
+	unsigned long flags;
+	struct clk_pll_vote *pll = to_clk_pll_vote(hw);
+	struct clk_pll *p = to_clk_pll(__clk_get_hw(__clk_get_parent(hw->clk)));
+
+	spin_lock_irqsave(&pll_vote_lock, flags);
+
+	val = readl_relaxed(pll->vote_reg);
+	val |= BIT(pll->vote_bit);
+	writel(val, pll->vote_reg);
+
+	spin_unlock_irqrestore(&pll_vote_lock, flags);
+
+	return wait_for_pll(p);
+}
+
+static void clk_pll_vote_disable(struct clk_hw *hw)
+{
+	u32 val;
+	unsigned long flags;
+	struct clk_pll_vote *pll = to_clk_pll_vote(hw);
+
+	spin_lock_irqsave(&pll_vote_lock, flags);
+
+	val = readl_relaxed(pll->vote_reg);
+	val &= ~BIT(pll->vote_bit);
+	writel_relaxed(val, pll->vote_reg);
+
+	spin_unlock_irqrestore(&pll_vote_lock, flags);
+}
+
+static const struct clk_ops clk_pll_vote_ops = {
+	.enable = clk_pll_vote_enable,
+	.disable = clk_pll_vote_disable,
+};
+
+struct clk *pll_vote_clk_register(struct device *dev,
+		struct pll_vote_desc *desc, struct clk_init_data *init)
+{
+	struct clk_pll_vote *p;
+
+	p = devm_kzalloc(dev, sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+
+	p->vote_reg = desc->base + desc->vote_reg;
+	p->vote_bit = desc->vote_bit;
+
+	init->ops = &clk_pll_vote_ops;
+	p->hw.init = init;
+
+	return devm_clk_register(dev, &p->hw);
+}
diff --git a/drivers/clk/msm/clk-pll.h b/drivers/clk/msm/clk-pll.h
new file mode 100644
index 0000000..4e63a5e
--- /dev/null
+++ b/drivers/clk/msm/clk-pll.h
@@ -0,0 +1,43 @@
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
+#ifndef __MSM_CLK_PLL_H__
+#define __MSM_CLK_PLL_H__
+
+struct device;
+struct clk;
+struct clk_init_data;
+
+struct pll_desc {
+	void __iomem *base;
+	u16 l_reg;
+	u16 m_reg;
+	u16 n_reg;
+	u16 config_reg;
+	u16 mode_reg;
+	u16 status_reg;
+	u8 status_bit;
+};
+
+struct pll_vote_desc {
+	void __iomem *base;
+	u16 vote_reg;
+	u8 vote_bit;
+};
+
+extern struct clk *pll_clk_register(struct device *dev, struct pll_desc *desc,
+		struct clk_init_data *init);
+extern struct clk *pll_vote_clk_register(struct device *dev,
+		struct pll_vote_desc *desc, struct clk_init_data *init);
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

