Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbaLBQ74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:59:56 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:60804 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbaLBQ7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:59:55 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de
Cc: jingchang.lu@freescale.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH] ARM: imx: pllv3: add shift for frequency multiplier
Date: Tue,  2 Dec 2014 17:59:42 +0100
Message-Id: <1417539582-11387-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add shift capabilties for the frequency multiplier (DIV_SELECT) to
support Vybrid's USB PLL oddity. The PLL3 and PLL7 are the only
PLL control registers which have the DIV_SELECT bit shifted by
one. Be aware, there are known documentation errors in the
reference manual too.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
I first thought of an additional parameter for clk_pllv3_recalc_rate,
but since this function is used in multiple SoCs it would have made
the change much larger. By creating a new type for Vybrid's USB PLL
it is also much more explicit that the USB PLL's on Vybrid are
different to the others...

 arch/arm/mach-imx/clk-pllv3.c | 10 +++++++---
 arch/arm/mach-imx/clk-vf610.c |  4 ++--
 arch/arm/mach-imx/clk.h       |  1 +
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-imx/clk-pllv3.c b/arch/arm/mach-imx/clk-pllv3.c
index 0ad6e54..641ebc5 100644
--- a/arch/arm/mach-imx/clk-pllv3.c
+++ b/arch/arm/mach-imx/clk-pllv3.c
@@ -31,6 +31,7 @@
  * @base:	 base address of PLL registers
  * @powerup_set: set POWER bit to power up the PLL
  * @div_mask:	 mask of divider bits
+ * @div_shift:	 shift of divider bits
  *
  * IMX PLL clock version 3, found on i.MX6 series.  Divider for pllv3
  * is actually a multiplier, and always sits at bit 0.
@@ -40,6 +41,7 @@ struct clk_pllv3 {
 	void __iomem	*base;
 	bool		powerup_set;
 	u32		div_mask;
+	u32		div_shift;
 };
 
 #define to_clk_pllv3(_hw) container_of(_hw, struct clk_pllv3, hw)
@@ -97,7 +99,7 @@ static unsigned long clk_pllv3_recalc_rate(struct clk_hw *hw,
 					   unsigned long parent_rate)
 {
 	struct clk_pllv3 *pll = to_clk_pllv3(hw);
-	u32 div = readl_relaxed(pll->base)  & pll->div_mask;
+	u32 div = (readl_relaxed(pll->base) >> pll->div_shift)  & pll->div_mask;
 
 	return (div == 1) ? parent_rate * 22 : parent_rate * 20;
 }
@@ -125,8 +127,8 @@ static int clk_pllv3_set_rate(struct clk_hw *hw, unsigned long rate,
 		return -EINVAL;
 
 	val = readl_relaxed(pll->base);
-	val &= ~pll->div_mask;
-	val |= div;
+	val &= ~(pll->div_mask << pll->div_shift);
+	val |= (div << pll->div_shift);
 	writel_relaxed(val, pll->base);
 
 	return clk_pllv3_wait_lock(pll);
@@ -295,6 +297,8 @@ struct clk *imx_clk_pllv3(enum imx_pllv3_type type, const char *name,
 	case IMX_PLLV3_SYS:
 		ops = &clk_pllv3_sys_ops;
 		break;
+	case IMX_PLLV3_USB_VF610:
+		pll->div_shift = 1;
 	case IMX_PLLV3_USB:
 		ops = &clk_pllv3_ops;
 		pll->powerup_set = true;
diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
index 5937dde..cb21777 100644
--- a/arch/arm/mach-imx/clk-vf610.c
+++ b/arch/arm/mach-imx/clk-vf610.c
@@ -172,11 +172,11 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
 
 	clk[VF610_CLK_PLL1] = imx_clk_pllv3(IMX_PLLV3_GENERIC, "pll1", "pll1_bypass_src", PLL1_CTRL, 0x1);
 	clk[VF610_CLK_PLL2] = imx_clk_pllv3(IMX_PLLV3_GENERIC, "pll2", "pll2_bypass_src", PLL2_CTRL, 0x1);
-	clk[VF610_CLK_PLL3] = imx_clk_pllv3(IMX_PLLV3_USB,     "pll3", "pll3_bypass_src", PLL3_CTRL, 0x1);
+	clk[VF610_CLK_PLL3] = imx_clk_pllv3(IMX_PLLV3_USB_VF610,     "pll3", "pll3_bypass_src", PLL3_CTRL, 0x2);
 	clk[VF610_CLK_PLL4] = imx_clk_pllv3(IMX_PLLV3_AV,      "pll4", "pll4_bypass_src", PLL4_CTRL, 0x7f);
 	clk[VF610_CLK_PLL5] = imx_clk_pllv3(IMX_PLLV3_ENET,    "pll5", "pll5_bypass_src", PLL5_CTRL, 0x3);
 	clk[VF610_CLK_PLL6] = imx_clk_pllv3(IMX_PLLV3_AV,      "pll6", "pll6_bypass_src", PLL6_CTRL, 0x7f);
-	clk[VF610_CLK_PLL7] = imx_clk_pllv3(IMX_PLLV3_USB,     "pll7", "pll7_bypass_src", PLL7_CTRL, 0x1);
+	clk[VF610_CLK_PLL7] = imx_clk_pllv3(IMX_PLLV3_USB_VF610,     "pll7", "pll7_bypass_src", PLL7_CTRL, 0x2);
 
 	clk[VF610_PLL1_BYPASS] = imx_clk_mux_flags("pll1_bypass", PLL1_CTRL, 16, 1, pll1_bypass_sels, ARRAY_SIZE(pll1_bypass_sels), CLK_SET_RATE_PARENT);
 	clk[VF610_PLL2_BYPASS] = imx_clk_mux_flags("pll2_bypass", PLL2_CTRL, 16, 1, pll2_bypass_sels, ARRAY_SIZE(pll2_bypass_sels), CLK_SET_RATE_PARENT);
diff --git a/arch/arm/mach-imx/clk.h b/arch/arm/mach-imx/clk.h
index 5ef82e2..6a07903 100644
--- a/arch/arm/mach-imx/clk.h
+++ b/arch/arm/mach-imx/clk.h
@@ -20,6 +20,7 @@ enum imx_pllv3_type {
 	IMX_PLLV3_GENERIC,
 	IMX_PLLV3_SYS,
 	IMX_PLLV3_USB,
+	IMX_PLLV3_USB_VF610,
 	IMX_PLLV3_AV,
 	IMX_PLLV3_ENET,
 };
-- 
2.1.3

