Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbaIVRJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:09:48 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:58163 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbaIVRJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:09:45 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, linus.walleij@linaro.org,
        gnurou@gmail.com
Cc: linux@arm.linux.org.uk, jingchang.lu@freescale.com, b20788@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 8/9] ARM: imx: clk-gate2: allow custom gate configuration
Date: Mon, 22 Sep 2014 19:09:29 +0200
Message-Id: <2ad051b257bae6249a48443a30d14b152407504e.1411404079.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
In-Reply-To: <cover.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 2-bit gates found i.MX and Vybrid SoC support different clock
configuration:

0b00: clk disabled
0b01: clk enabled in RUN mode but disabled in WAIT and STOP mode
0b10: clk enabled in RUN, WAIT and STOP mode (only Vybrid)
0b11: clk enabled in RUN and WAIT mode

For some clocks, we might want to configure different behaviour,
e.g. a memory clock should be on even in STOP mode. Add a new
function imx_clk_gate2_cgr which allow to configure specific
gate values through the cgr_val parameter.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/mach-imx/clk-gate2.c           |  7 +++++--
 arch/arm/mach-imx/clk-vf610.c           |  3 +++
 arch/arm/mach-imx/clk.h                 | 13 ++++++++++---
 include/dt-bindings/clock/vf610-clock.h |  3 ++-
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-imx/clk-gate2.c b/arch/arm/mach-imx/clk-gate2.c
index 84acdfd..8c22a84 100644
--- a/arch/arm/mach-imx/clk-gate2.c
+++ b/arch/arm/mach-imx/clk-gate2.c
@@ -31,6 +31,7 @@ struct clk_gate2 {
 	struct clk_hw hw;
 	void __iomem	*reg;
 	u8		bit_idx;
+	u8		cgr_val;
 	u8		flags;
 	spinlock_t	*lock;
 	unsigned int	*share_count;
@@ -50,7 +51,8 @@ static int clk_gate2_enable(struct clk_hw *hw)
 		goto out;
 
 	reg = readl(gate->reg);
-	reg |= 3 << gate->bit_idx;
+	reg &= ~(3 << gate->bit_idx);
+	reg |= gate->cgr_val << gate->bit_idx;
 	writel(reg, gate->reg);
 
 out:
@@ -110,7 +112,7 @@ static struct clk_ops clk_gate2_ops = {
 
 struct clk *clk_register_gate2(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
-		void __iomem *reg, u8 bit_idx,
+		void __iomem *reg, u8 bit_idx, u8 cgr_val,
 		u8 clk_gate2_flags, spinlock_t *lock,
 		unsigned int *share_count)
 {
@@ -125,6 +127,7 @@ struct clk *clk_register_gate2(struct device *dev, const char *name,
 	/* struct clk_gate2 assignments */
 	gate->reg = reg;
 	gate->bit_idx = bit_idx;
+	gate->cgr_val = cgr_val;
 	gate->flags = clk_gate2_flags;
 	gate->lock = lock;
 
diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
index a178184..1034e78 100644
--- a/arch/arm/mach-imx/clk-vf610.c
+++ b/arch/arm/mach-imx/clk-vf610.c
@@ -103,6 +103,7 @@ static struct clk_onecell_data clk_data;
 static unsigned int const clks_init_on[] __initconst = {
 	VF610_CLK_SYS_BUS,
 	VF610_CLK_DDR_SEL,
+	VF610_CLK_DDRMC,
 };
 
 static void __init vf610_clocks_init(struct device_node *ccm_node)
@@ -171,6 +172,8 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
 	clk[VF610_CLK_PLL4_MAIN_DIV] = clk_register_divider_table(NULL, "pll4_main_div", "pll4_main", 0, CCM_CACRR, 6, 3, 0, pll4_main_div_table, &imx_ccm_lock);
 	clk[VF610_CLK_PLL6_MAIN_DIV] = imx_clk_divider("pll6_main_div", "pll6_main", CCM_CACRR, 21, 1);
 
+	clk[VF610_CLK_DDRMC] = imx_clk_gate2_cgr("ddrmc", "ddr_sel", CCM_CCGR6, CCM_CCGRx_CGn(14), 0x2);
+
 	clk[VF610_CLK_USBPHY0] = imx_clk_gate("usbphy0", "pll3_main", PLL3_CTRL, 6);
 	clk[VF610_CLK_USBPHY1] = imx_clk_gate("usbphy1", "pll7_main", PLL7_CTRL, 6);
 
diff --git a/arch/arm/mach-imx/clk.h b/arch/arm/mach-imx/clk.h
index 4cdf8b6..d22e339 100644
--- a/arch/arm/mach-imx/clk.h
+++ b/arch/arm/mach-imx/clk.h
@@ -29,7 +29,7 @@ struct clk *imx_clk_pllv3(enum imx_pllv3_type type, const char *name,
 
 struct clk *clk_register_gate2(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
-		void __iomem *reg, u8 bit_idx,
+		void __iomem *reg, u8 bit_idx, u8 cgr_val,
 		u8 clk_gate_flags, spinlock_t *lock,
 		unsigned int *share_count);
 
@@ -43,7 +43,7 @@ static inline struct clk *imx_clk_gate2(const char *name, const char *parent,
 		void __iomem *reg, u8 shift)
 {
 	return clk_register_gate2(NULL, name, parent, CLK_SET_RATE_PARENT, reg,
-			shift, 0, &imx_ccm_lock, NULL);
+			shift, 0x3, 0, &imx_ccm_lock, NULL);
 }
 
 static inline struct clk *imx_clk_gate2_shared(const char *name,
@@ -51,7 +51,14 @@ static inline struct clk *imx_clk_gate2_shared(const char *name,
 		unsigned int *share_count)
 {
 	return clk_register_gate2(NULL, name, parent, CLK_SET_RATE_PARENT, reg,
-			shift, 0, &imx_ccm_lock, share_count);
+			shift, 0x3, 0, &imx_ccm_lock, share_count);
+}
+
+static inline struct clk *imx_clk_gate2_cgr(const char *name,
+		const char *parent, void __iomem *reg, u8 shift, u8 cgr_val)
+{
+	return clk_register_gate2(NULL, name, parent, CLK_SET_RATE_PARENT, reg,
+			shift, cgr_val, 0, &imx_ccm_lock, NULL);
 }
 
 struct clk *imx_clk_pfd(const char *name, const char *parent_name,
diff --git a/include/dt-bindings/clock/vf610-clock.h b/include/dt-bindings/clock/vf610-clock.h
index d6b56b2..84c4809 100644
--- a/include/dt-bindings/clock/vf610-clock.h
+++ b/include/dt-bindings/clock/vf610-clock.h
@@ -169,6 +169,7 @@
 #define VF610_CLK_PLL7_MAIN		156
 #define VF610_CLK_USBPHY0		157
 #define VF610_CLK_USBPHY1		158
-#define VF610_CLK_END			159
+#define VF610_CLK_DDRMC			159
+#define VF610_CLK_END			160
 
 #endif /* __DT_BINDINGS_CLOCK_VF610_H */
-- 
2.1.0

