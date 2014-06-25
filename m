Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaFYAGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 20:06:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41348 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbaFYAG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 20:06:29 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [RFC/PATCH 07/12] clk: qcom: Add support for Krait clocks
Date: Tue, 24 Jun 2014 17:06:18 -0700
Message-Id: <1403654783-7176-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
References: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Krait clocks are made up of a series of muxes and a divider
that choose between a fixed rate clock and dedicated HFPLLs for
each CPU. Instead of using mmio accesses to remux parents, the
Krait implementation exposes the remux control via cp15
registers. Support these clocks.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Makefile    |   1 +
 drivers/clk/qcom/clk-krait.c | 121 +++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/qcom/clk-krait.h |  22 ++++++++
 3 files changed, 144 insertions(+)
 create mode 100644 drivers/clk/qcom/clk-krait.c
 create mode 100644 drivers/clk/qcom/clk-krait.h

diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index b733adbbad5a..b982d271d7db 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -7,6 +7,7 @@ clk-qcom-y += clk-rcg.o
 clk-qcom-y += clk-rcg2.o
 clk-qcom-y += clk-branch.o
 clk-qcom-y += clk-generic.o
+clk-qcom-y += clk-krait.o
 clk-qcom-y += clk-hfpll.o
 clk-qcom-y += reset.o
 
diff --git a/drivers/clk/qcom/clk-krait.c b/drivers/clk/qcom/clk-krait.c
new file mode 100644
index 000000000000..42834269a867
--- /dev/null
+++ b/drivers/clk/qcom/clk-krait.c
@@ -0,0 +1,121 @@
+/*
+ * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/clk-provider.h>
+#include <linux/spinlock.h>
+
+#include <asm/krait-l2-accessors.h>
+
+#include "clk-krait.h"
+
+/* Secondary and primary muxes share the same cp15 register */
+static DEFINE_SPINLOCK(kpss_clock_reg_lock);
+
+#define LPL_SHIFT	8
+static void __kpss_mux_set_sel(struct mux_clk *mux, int sel)
+{
+	unsigned long flags;
+	u32 regval;
+
+	spin_lock_irqsave(&kpss_clock_reg_lock, flags);
+	regval = krait_get_l2_indirect_reg(mux->offset);
+	regval &= ~(mux->mask << mux->shift);
+	regval |= (sel & mux->mask) << mux->shift;
+	if (mux->priv) {
+		regval &= ~(mux->mask << (mux->shift + LPL_SHIFT));
+		regval |= (sel & mux->mask) << (mux->shift + LPL_SHIFT);
+	}
+	krait_set_l2_indirect_reg(mux->offset, regval);
+	spin_unlock_irqrestore(&kpss_clock_reg_lock, flags);
+
+	/* Wait for switch to complete. */
+	mb();
+	udelay(1);
+}
+
+static int kpss_mux_set_sel(struct mux_clk *mux, int sel)
+{
+	mux->en_mask = sel;
+	/* Don't touch mux if CPU is off as it won't work */
+	if (__clk_is_enabled(mux->hw.clk))
+		__kpss_mux_set_sel(mux, sel);
+	return 0;
+}
+
+static int kpss_mux_get_sel(struct mux_clk *mux)
+{
+	u32 sel;
+
+	sel = krait_get_l2_indirect_reg(mux->offset);
+	sel >>= mux->shift;
+	sel &= mux->mask;
+	mux->en_mask = sel;
+
+	return sel;
+}
+
+static int kpss_mux_enable(struct mux_clk *mux)
+{
+	__kpss_mux_set_sel(mux, mux->en_mask);
+	return 0;
+}
+
+static void kpss_mux_disable(struct mux_clk *mux)
+{
+	__kpss_mux_set_sel(mux, mux->safe_sel);
+}
+
+const struct clk_mux_ops clk_mux_ops_kpss = {
+	.enable = kpss_mux_enable,
+	.disable = kpss_mux_disable,
+	.set_mux_sel = kpss_mux_set_sel,
+	.get_mux_sel = kpss_mux_get_sel,
+};
+EXPORT_SYMBOL_GPL(clk_mux_ops_kpss);
+
+/*
+ * The divider can divide by 2, 4, 6 and 8. But we only really need div-2. So
+ * force it to div-2 during handoff and treat it like a fixed div-2 clock.
+ */
+static int kpss_div2_get_div(struct div_clk *div)
+{
+	unsigned long flags;
+	u32 regval;
+	int val;
+
+	spin_lock_irqsave(&kpss_clock_reg_lock, flags);
+	regval = krait_get_l2_indirect_reg(div->offset);
+	val = (regval >> div->shift) & div->mask;
+	regval &= ~(div->mask << div->shift);
+	if (div->priv)
+		regval &= ~(div->mask << (div->shift + LPL_SHIFT));
+	krait_set_l2_indirect_reg(div->offset, regval);
+	spin_unlock_irqrestore(&kpss_clock_reg_lock, flags);
+
+	val = (val + 1) * 2;
+	WARN(val != 2, "Divider %s was configured to div-%d instead of 2!\n",
+		__clk_get_name(div->hw.clk), val);
+
+	return 2;
+}
+
+const struct clk_div_ops clk_div_ops_kpss_div2 = {
+	.get_div = kpss_div2_get_div,
+};
+EXPORT_SYMBOL_GPL(clk_div_ops_kpss_div2);
diff --git a/drivers/clk/qcom/clk-krait.h b/drivers/clk/qcom/clk-krait.h
new file mode 100644
index 000000000000..9c3eb38be542
--- /dev/null
+++ b/drivers/clk/qcom/clk-krait.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __SOC_QCOM_CLOCK_KRAIT_H
+#define __SOC_QCOM_CLOCK_KRAIT_H
+
+#include <linux/clk/msm-clk-generic.h>
+
+extern const struct clk_mux_ops clk_mux_ops_kpss;
+extern const struct clk_div_ops clk_div_ops_kpss_div2;
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

