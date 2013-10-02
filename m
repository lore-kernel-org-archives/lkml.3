Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3JBTHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 15:07:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40947 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab3JBTHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 15:07:11 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH v2 4/9] clk: msm: Add support for phase locked loops (PLLs)
Date: Wed,  2 Oct 2013 12:07:01 -0700
Message-Id: <1380740826-29457-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-Reply-To: <1380740826-29457-1-git-send-email-sboyd@codeaurora.org>
References: <1380740826-29457-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for MSM's PLLs (phase locked loops). This is
sufficient enough to be able to determine the rate the PLL is
running at. We can add rate setting support later when it's
needed.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/Kconfig       |   2 +
 drivers/clk/Makefile      |   1 +
 drivers/clk/msm/Kconfig   |   5 ++
 drivers/clk/msm/Makefile  |   3 +
 drivers/clk/msm/clk-pll.c | 147 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/msm/clk-pll.h |  45 ++++++++++++++
 6 files changed, 203 insertions(+)
 create mode 100644 drivers/clk/msm/Kconfig
 create mode 100644 drivers/clk/msm/Makefile
 create mode 100644 drivers/clk/msm/clk-pll.c
 create mode 100644 drivers/clk/msm/clk-pll.h

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 279407a..efb7606 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -93,6 +93,8 @@ config CLK_PPC_CORENET
 	  This adds the clock driver support for Freescale PowerPC corenet
 	  platforms using common clock framework.
 
+source "drivers/clk/msm/Kconfig"
+
 endmenu
 
 source "drivers/clk/mvebu/Kconfig"
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 7b11106..6838b07 100644
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
index 0000000..91558ce
--- /dev/null
+++ b/drivers/clk/msm/Kconfig
@@ -0,0 +1,5 @@
+config COMMON_CLK_MSM
+	tristate "Support for Qualcomm's MSM designs"
+	depends on OF
+	select REGMAP_MMIO
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
index 0000000..7470bdd
--- /dev/null
+++ b/drivers/clk/msm/clk-pll.c
@@ -0,0 +1,147 @@
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
+#include <linux/bug.h>
+#include <linux/delay.h>
+#include <linux/export.h>
+#include <linux/clk-provider.h>
+#include <linux/regmap.h>
+
+#include <asm/div64.h>
+
+#include "clk-pll.h"
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
+	int ret;
+
+	/* Disable PLL bypass mode. */
+	ret = regmap_update_bits(hw->regmap, pll->mode_reg, PLL_BYPASSNL,
+				 PLL_BYPASSNL);
+	if (ret)
+		return ret;
+
+	/*
+	 * H/W requires a 5us delay between disabling the bypass and
+	 * de-asserting the reset. Delay 10us just to be safe.
+	 */
+	udelay(10);
+
+	/* De-assert active-low PLL reset. */
+	ret = regmap_update_bits(hw->regmap, pll->mode_reg, PLL_RESET_N,
+				 PLL_RESET_N);
+	if (ret)
+		return ret;
+
+	/* Wait until PLL is locked. */
+	udelay(50);
+
+	/* Enable PLL output. */
+	ret = regmap_update_bits(hw->regmap, pll->mode_reg, PLL_OUTCTRL,
+				 PLL_OUTCTRL);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void clk_pll_disable(struct clk_hw *hw)
+{
+	struct clk_pll *pll = to_clk_pll(hw);
+	u32 mask;
+
+	mask = PLL_OUTCTRL | PLL_RESET_N | PLL_BYPASSNL;
+	regmap_update_bits(hw->regmap, pll->mode_reg, mask, 0);
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
+	regmap_read(hw->regmap, pll->l_reg, &l);
+	regmap_read(hw->regmap, pll->m_reg, &m);
+	regmap_read(hw->regmap, pll->n_reg, &n);
+
+	l &= 0x3ff;
+	m &= 0x7ffff;
+	n &= 0x7ffff;
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
+const struct clk_ops clk_pll_ops = {
+	.enable = clk_pll_enable,
+	.disable = clk_pll_disable,
+	.recalc_rate = clk_pll_recalc_rate,
+};
+EXPORT_SYMBOL_GPL(clk_pll_ops);
+
+static int wait_for_pll(struct clk_pll *pll)
+{
+	u32 val;
+	int count;
+	int ret;
+	const char *name = __clk_get_name(pll->hw.clk);
+
+	/* Wait for pll to enable. */
+	for (count = 200; count > 0; count--) {
+		ret = regmap_read(pll->hw.regmap, pll->status_reg, &val);
+		if (ret)
+			return ret;
+		if (val & BIT(pll->status_bit))
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
+	int ret;
+	struct clk_pll *p = to_clk_pll(__clk_get_hw(__clk_get_parent(hw->clk)));
+
+	ret = clk_enable_regmap(hw);
+	if (ret)
+		return ret;
+
+	return wait_for_pll(p);
+}
+
+const struct clk_ops clk_pll_vote_ops = {
+	.enable = clk_pll_vote_enable,
+	.disable = clk_disable_regmap,
+};
+EXPORT_SYMBOL_GPL(clk_pll_vote_ops);
diff --git a/drivers/clk/msm/clk-pll.h b/drivers/clk/msm/clk-pll.h
new file mode 100644
index 0000000..a15125c
--- /dev/null
+++ b/drivers/clk/msm/clk-pll.h
@@ -0,0 +1,45 @@
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
+#include <linux/clk-provider.h>
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
+	u32	l_reg;
+	u32	m_reg;
+	u32	n_reg;
+	u32	config_reg;
+	u32	mode_reg;
+	u32	status_reg;
+	u8	status_bit;
+
+	struct clk_hw	hw;
+};
+
+extern const struct clk_ops clk_pll_ops;
+extern const struct clk_ops clk_pll_vote_ops;
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

