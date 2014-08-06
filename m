Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbaHFIfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 04:35:40 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:49450
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754182AbaHFIfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:35:36 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>
CC: <shengjiu.wang@freescale.com>, <Guangyu.Chen@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 2/3] ARM: clk-imx6q: Add missing lvds and anaclk clock to the clock tree
Date: Wed, 6 Aug 2014 16:35:14 +0800
Message-ID: <f98c6ea35ef4fa382d8aaf4ff370530aeb5b107f.1407313676.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1407313676.git.shengjiu.wang@freescale.com>
References: <cover.1407313676.git.shengjiu.wang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(87936001)(87286001)(88136002)(79102001)(50226001)(4396001)(47776003)(20776003)(99396002)(81342001)(80022001)(64706001)(81542001)(2201001)(89996001)(92726001)(85306004)(85852003)(83072002)(92566001)(81156004)(21056001)(106466001)(95666004)(105606002)(97736001)(104016003)(77982001)(33646002)(19580395003)(74662001)(84676001)(77156001)(229853001)(6806004)(46102001)(44976005)(83322001)(69596002)(36756003)(76482001)(68736004)(62966002)(76176999)(48376002)(74502001)(19580405001)(50466002)(31966008)(86362001)(26826002)(50986999)(107046002)(93916002)(102836001)(104166001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB441;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02951C14DC
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

anaclk1 and anaclk2 is the clock source for lvds1_in and lvds2_in. lvds1_in
and lvds2_in can be used to provide external clock source to the internal
pll, such as pll4_audio and pll5_video.
pll4_audio and pll5_video can have multiple source, not only "osc", so
add them.

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 arch/arm/mach-imx/clk-imx6q.c             |   12 ++++++++++--
 include/dt-bindings/clock/imx6qdl-clock.h |    8 +++++++-
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index 1d6dd59..330aad3 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -73,6 +73,7 @@ static const char *lvds_sels[] = {
 	"pll4_audio", "pll5_video", "pll8_mlb", "enet_ref",
 	"pcie_ref_125m", "sata_ref_100m",
 };
+static const char *pll_av_sels[] = { "osc", "lvds1_in", "lvds2_in", "dummy", };
 
 static struct clk *clk[IMX6QDL_CLK_END];
 static struct clk_onecell_data clk_data;
@@ -119,6 +120,9 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	clk[IMX6QDL_CLK_CKIL] = imx_obtain_fixed_clock("ckil", 0);
 	clk[IMX6QDL_CLK_CKIH] = imx_obtain_fixed_clock("ckih1", 0);
 	clk[IMX6QDL_CLK_OSC] = imx_obtain_fixed_clock("osc", 0);
+	/* Clock source from external clock via ANACLK1/2 PADs */
+	clk[IMX6QDL_CLK_ANACLK1] = imx_obtain_fixed_clock("anaclk1", 0);
+	clk[IMX6QDL_CLK_ANACLK2] = imx_obtain_fixed_clock("anaclk2", 0);
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-anatop");
 	base = of_iomap(np, 0);
@@ -136,8 +140,8 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	clk[IMX6QDL_CLK_PLL1_SYS]      = imx_clk_pllv3(IMX_PLLV3_SYS,	"pll1_sys",	"osc", base,        0x7f);
 	clk[IMX6QDL_CLK_PLL2_BUS]      = imx_clk_pllv3(IMX_PLLV3_GENERIC,	"pll2_bus",	"osc", base + 0x30, 0x1);
 	clk[IMX6QDL_CLK_PLL3_USB_OTG]  = imx_clk_pllv3(IMX_PLLV3_USB,	"pll3_usb_otg",	"osc", base + 0x10, 0x3);
-	clk[IMX6QDL_CLK_PLL4_AUDIO]    = imx_clk_pllv3(IMX_PLLV3_AV,	"pll4_audio",	"osc", base + 0x70, 0x7f);
-	clk[IMX6QDL_CLK_PLL5_VIDEO]    = imx_clk_pllv3(IMX_PLLV3_AV,	"pll5_video",	"osc", base + 0xa0, 0x7f);
+	clk[IMX6QDL_CLK_PLL4_AUDIO]    = imx_clk_pllv3(IMX_PLLV3_AV,	"pll4_audio",	"pll4_sel", base + 0x70, 0x7f);
+	clk[IMX6QDL_CLK_PLL5_VIDEO]    = imx_clk_pllv3(IMX_PLLV3_AV,	"pll5_video",	"pll5_sel", base + 0xa0, 0x7f);
 	clk[IMX6QDL_CLK_PLL6_ENET]     = imx_clk_pllv3(IMX_PLLV3_ENET,	"pll6_enet",	"osc", base + 0xe0, 0x3);
 	clk[IMX6QDL_CLK_PLL7_USB_HOST] = imx_clk_pllv3(IMX_PLLV3_USB,	"pll7_usb_host","osc", base + 0x20, 0x3);
 
@@ -169,6 +173,8 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 
 	clk[IMX6QDL_CLK_LVDS1_SEL] = imx_clk_mux("lvds1_sel", base + 0x160, 0, 5, lvds_sels, ARRAY_SIZE(lvds_sels));
 	clk[IMX6QDL_CLK_LVDS2_SEL] = imx_clk_mux("lvds2_sel", base + 0x160, 5, 5, lvds_sels, ARRAY_SIZE(lvds_sels));
+	clk[IMX6QDL_CLK_PLL4_SEL]  = imx_clk_mux("pll4_sel",  base + 0x70, 14, 2, pll_av_sels, ARRAY_SIZE(pll_av_sels));
+	clk[IMX6QDL_CLK_PLL5_SEL]  = imx_clk_mux("pll5_sel",  base + 0xa0, 14, 2, pll_av_sels, ARRAY_SIZE(pll_av_sels));
 
 	/*
 	 * lvds1_gate and lvds2_gate are pseudo-gates.  Both can be
@@ -178,6 +184,8 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	 */
 	clk[IMX6QDL_CLK_LVDS1_GATE] = imx_clk_gate("lvds1_gate", "lvds1_sel", base + 0x160, 10);
 	clk[IMX6QDL_CLK_LVDS2_GATE] = imx_clk_gate("lvds2_gate", "lvds2_sel", base + 0x160, 11);
+	clk[IMX6QDL_CLK_LVDS1_IN] = imx_clk_gate("lvds1_in", "anaclk1", base + 0x160, 12);
+	clk[IMX6QDL_CLK_LVDS2_IN] = imx_clk_gate("lvds2_in", "anaclk2", base + 0x160, 13);
 
 	/*                                            name              parent_name        reg       idx */
 	clk[IMX6QDL_CLK_PLL2_PFD0_352M] = imx_clk_pfd("pll2_pfd0_352m", "pll2_bus",     base + 0x100, 0);
diff --git a/include/dt-bindings/clock/imx6qdl-clock.h b/include/dt-bindings/clock/imx6qdl-clock.h
index 323e865..5519526 100644
--- a/include/dt-bindings/clock/imx6qdl-clock.h
+++ b/include/dt-bindings/clock/imx6qdl-clock.h
@@ -220,6 +220,12 @@
 #define IMX6QDL_CLK_LVDS2_GATE			207
 #define IMX6QDL_CLK_ESAI_IPG			208
 #define IMX6QDL_CLK_ESAI_MEM			209
-#define IMX6QDL_CLK_END				210
+#define IMX6QDL_CLK_LVDS1_IN			210
+#define IMX6QDL_CLK_LVDS2_IN			211
+#define IMX6QDL_CLK_ANACLK1			212
+#define IMX6QDL_CLK_ANACLK2			213
+#define IMX6QDL_CLK_PLL4_SEL			214
+#define IMX6QDL_CLK_PLL5_SEL			215
+#define IMX6QDL_CLK_END				216
 
 #endif /* __DT_BINDINGS_CLOCK_IMX6QDL_H */
-- 
1.7.9.5

