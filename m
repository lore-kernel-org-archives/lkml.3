Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaJUDoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 23:44:18 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:60098 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaJUDoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 23:44:16 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <9b4f36b80c5bcaba07346832b31ecaae>
X-DNS-TYPE: 1
From: zyw@rock-chips.com
To: Heiko Stuebner <heiko@sntech.de>
Cc: Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, dianders@chromium.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Chris Zhong <zyw@rock-chips.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Tony Xie <xxx@rock-chips.com>
Subject: [PATCH v3 3/6] clk: rockchip: RK3288: add suspend and resume
Date: Mon, 20 Oct 2014 20:44:02 -0700
Message-Id: <1413863042-2779-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413862894-2623-1-git-send-email-zyw@rock-chips.com>
References: <1413862894-2623-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Zhong <zyw@rock-chips.com>

save and restore some clks, which might be changed in suspend.

Signed-off-by: Tony Xie <xxx@rock-chips.com>
Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

Changes in v3: None
Changes in v2:
- __raw_readl/__raw_writel replaced by readl_relaxed/writel_relaxed

 drivers/clk/rockchip/clk-rk3288.c |   63 +++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index b22a2d2..415b928 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -16,6 +16,7 @@
 #include <linux/clk-provider.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/syscore_ops.h>
 #include <dt-bindings/clock/rk3288-cru.h>
 #include "clk.h"
 
@@ -680,6 +681,67 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(0, "pclk_isp_in", "ext_isp", 0, RK3288_CLKGATE_CON(16), 3, GFLAGS),
 };
 
+#ifdef CONFIG_PM_SLEEP
+static void __iomem *rk3288_cru_base;
+static const int rk3288_saved_cru_reg_ids[] = {
+	RK3288_MODE_CON,
+	RK3288_CLKSEL_CON(0),
+	RK3288_CLKSEL_CON(1),
+	RK3288_CLKSEL_CON(10),
+	RK3288_CLKSEL_CON(33),
+	RK3288_CLKSEL_CON(37),
+};
+
+static u32 rk3288_saved_cru_regs[ARRAY_SIZE(rk3288_saved_cru_reg_ids)];
+
+/*
+ * cru will be set in maskrom when system wake up from fastboot
+ * mode in suspend,
+ * so the operation is saving the changed regs.
+ * The apll/cpll/gpll will be set into slow mode in maskrom.
+ * It is mean that resume code run in 24m quit slowly!
+ * so we must resume these plls as soon as possible.
+ */
+static int rk3288_clk_suspend(void)
+{
+	int i, reg_id;
+
+	for (i = 0; i < ARRAY_SIZE(rk3288_saved_cru_reg_ids); i++) {
+		reg_id = rk3288_saved_cru_reg_ids[i];
+
+		rk3288_saved_cru_regs[i] =
+				readl_relaxed(rk3288_cru_base + reg_id);
+	}
+	return 0;
+}
+
+static void rk3288_clk_resume(void)
+{
+	int i, reg_id;
+
+	for (i = ARRAY_SIZE(rk3288_saved_cru_reg_ids) - 1; i >= 0; i--) {
+		reg_id = rk3288_saved_cru_reg_ids[i];
+
+		writel_relaxed(rk3288_saved_cru_regs[i] | 0xffff0000,
+			       rk3288_cru_base + reg_id);
+	}
+}
+
+static struct syscore_ops rk3288_clk_syscore_ops = {
+	.suspend = rk3288_clk_suspend,
+	.resume = rk3288_clk_resume,
+};
+
+static void rk3288_clk_sleep_init(void __iomem *reg_base)
+{
+	rk3288_cru_base = reg_base;
+	register_syscore_ops(&rk3288_clk_syscore_ops);
+}
+
+#else /* CONFIG_PM_SLEEP */
+static void rk3288_clk_sleep_init(void __iomem *reg_base) {}
+#endif
+
 static void __init rk3288_clk_init(struct device_node *np)
 {
 	void __iomem *reg_base;
@@ -713,5 +775,6 @@ static void __init rk3288_clk_init(struct device_node *np)
 
 	rockchip_register_softrst(np, 9, reg_base + RK3288_SOFTRST_CON(0),
 				  ROCKCHIP_SOFTRST_HIWORD_MASK);
+	rk3288_clk_sleep_init(reg_base);
 }
 CLK_OF_DECLARE(rk3288_cru, "rockchip,rk3288-cru", rk3288_clk_init);
-- 
1.7.9.5

