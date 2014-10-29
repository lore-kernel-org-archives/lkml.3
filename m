Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbaJ2LxC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:53:02 -0400
Received: from mail-pa0-f67.google.com ([209.85.220.67]:40916 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbaJ2Lw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:52:59 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org
Cc: mturquette@linaro.org, Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, khilman@kernel.org,
        linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        Tony Xie <xxx@rock-chips.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 3/7] clk: rockchip: RK3288: add suspend and resume
Date: Wed, 29 Oct 2014 19:52:01 +0800
Message-Id: <1414583525-17395-4-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414583525-17395-1-git-send-email-zyw@rock-chips.com>
References: <1414583525-17395-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

save and restore some clks, which might be changed in suspend.

Signed-off-by: Tony Xie <xxx@rock-chips.com>
Signed-off-by: Chris Zhong <zyw@rock-chips.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>

---

Changes in v6:
- modify comments

Changes in v5:
- modify comments

Changes in v4: None
Changes in v3: None
Changes in v2:
- __raw_readl/__raw_writel replaced by readl_relaxed/writel_relaxed

 drivers/clk/rockchip/clk-rk3288.c |   60 +++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 2327829..66a9cb0 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -16,6 +16,7 @@
 #include <linux/clk-provider.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/syscore_ops.h>
 #include <dt-bindings/clock/rk3288-cru.h>
 #include "clk.h"
 
@@ -762,6 +763,64 @@ static const char *rk3288_critical_clocks[] __initconst = {
 	"hclk_peri",
 };
 
+#ifdef CONFIG_PM_SLEEP
+static void __iomem *rk3288_cru_base;
+
+/* Some CRU registers will be reset in maskrom when the system
+ * wakes up from fastboot.
+ * So save them before suspend, restore them after resume.
+ */
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
@@ -810,5 +869,6 @@ static void __init rk3288_clk_init(struct device_node *np)
 				  ROCKCHIP_SOFTRST_HIWORD_MASK);
 
 	rockchip_register_restart_notifier(RK3288_GLB_SRST_FST);
+	rk3288_clk_sleep_init(reg_base);
 }
 CLK_OF_DECLARE(rk3288_cru, "rockchip,rk3288-cru", rk3288_clk_init);
-- 
1.7.9.5

