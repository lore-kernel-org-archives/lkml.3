Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaG1PAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:00:52 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:51042 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaG1O5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:57:55 -0400
From: Stefan Agner <stefan@agner.ch>
To: peter.chen@freescale.com, s.hauer@pengutronix.de, shawn.guo@freescale.com
Cc: b35083@freescale.com, jingchang.lu@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 2/7] ARM: imx: clk-vf610: Add USBPHY clocks
Date: Mon, 28 Jul 2014 16:57:28 +0200
Message-Id: <01d727d703ca04c7328ad13f0e4887d7cadd1232.1406558450.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <cover.1406558450.git.stefan@agner.ch>
References: <cover.1406558450.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds PLL7 which is required for USBPHY1. It also adds
the USB PHY and USB Controller clocks and the gates to enable them.

Acked-by: Jingchang Lu <jingchang.lu@freescale.com>
Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/mach-imx/clk-vf610.c           | 12 ++++++++++--
 include/dt-bindings/clock/vf610-clock.h |  5 ++++-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
index 22dc3ee..159c5c4 100644
--- a/arch/arm/mach-imx/clk-vf610.c
+++ b/arch/arm/mach-imx/clk-vf610.c
@@ -58,6 +58,8 @@
 #define PFD_PLL1_BASE		(anatop_base + 0x2b0)
 #define PFD_PLL2_BASE		(anatop_base + 0x100)
 #define PFD_PLL3_BASE		(anatop_base + 0xf0)
+#define PLL3_CTRL		(anatop_base + 0x10)
+#define PLL7_CTRL		(anatop_base + 0x20)
 
 static void __iomem *anatop_base;
 static void __iomem *ccm_base;
@@ -148,6 +150,9 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
 	clk[VF610_CLK_PLL5_MAIN] = imx_clk_fixed_factor("pll5_main", "fast_clk_sel", 125, 6);
 	/* pll6: default 960Mhz */
 	clk[VF610_CLK_PLL6_MAIN] = imx_clk_fixed_factor("pll6_main", "fast_clk_sel", 40, 1);
+	/* pll7: USB1 PLL at 480MHz */
+	clk[VF610_CLK_PLL7_MAIN] = imx_clk_pllv3(IMX_PLLV3_USB,	"pll7_main", "fast_clk_sel", PLL7_CTRL, 0x2);
+
 	clk[VF610_CLK_PLL1_PFD_SEL] = imx_clk_mux("pll1_pfd_sel", CCM_CCSR, 16, 3, pll1_sels, 5);
 	clk[VF610_CLK_PLL2_PFD_SEL] = imx_clk_mux("pll2_pfd_sel", CCM_CCSR, 19, 3, pll2_sels, 5);
 	clk[VF610_CLK_SYS_SEL] = imx_clk_mux("sys_sel", CCM_CCSR, 0, 3, sys_sels, ARRAY_SIZE(sys_sels));
@@ -160,8 +165,11 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
 	clk[VF610_CLK_PLL4_MAIN_DIV] = clk_register_divider_table(NULL, "pll4_main_div", "pll4_main", 0, CCM_CACRR, 6, 3, 0, pll4_main_div_table, &imx_ccm_lock);
 	clk[VF610_CLK_PLL6_MAIN_DIV] = imx_clk_divider("pll6_main_div", "pll6_main", CCM_CACRR, 21, 1);
 
-	clk[VF610_CLK_USBC0] = imx_clk_gate2("usbc0", "pll3_main", CCM_CCGR1, CCM_CCGRx_CGn(4));
-	clk[VF610_CLK_USBC1] = imx_clk_gate2("usbc1", "pll3_main", CCM_CCGR7, CCM_CCGRx_CGn(4));
+	clk[VF610_CLK_USBPHY0] = imx_clk_gate("usbphy0", "pll3_main", PLL3_CTRL, 6);
+	clk[VF610_CLK_USBPHY1] = imx_clk_gate("usbphy1", "pll7_main", PLL7_CTRL, 6);
+
+	clk[VF610_CLK_USBC0] = imx_clk_gate2("usbc0", "ipg_bus", CCM_CCGR1, CCM_CCGRx_CGn(4));
+	clk[VF610_CLK_USBC1] = imx_clk_gate2("usbc1", "ipg_bus", CCM_CCGR7, CCM_CCGRx_CGn(4));
 
 	clk[VF610_CLK_QSPI0_SEL] = imx_clk_mux("qspi0_sel", CCM_CSCMR1, 22, 2, qspi_sels, 4);
 	clk[VF610_CLK_QSPI0_EN] = imx_clk_gate("qspi0_en", "qspi0_sel", CCM_CSCDR3, 4);
diff --git a/include/dt-bindings/clock/vf610-clock.h b/include/dt-bindings/clock/vf610-clock.h
index a916029..6593757 100644
--- a/include/dt-bindings/clock/vf610-clock.h
+++ b/include/dt-bindings/clock/vf610-clock.h
@@ -164,6 +164,9 @@
 #define VF610_CLK_DMAMUX1		151
 #define VF610_CLK_DMAMUX2		152
 #define VF610_CLK_DMAMUX3		153
-#define VF610_CLK_END			154
+#define VF610_CLK_PLL7_MAIN		154
+#define VF610_CLK_USBPHY0		155
+#define VF610_CLK_USBPHY1		156
+#define VF610_CLK_END			157
 
 #endif /* __DT_BINDINGS_CLOCK_VF610_H */
-- 
2.0.2

