Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbaIIJ3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:29:40 -0400
Received: from mail-bn1bon0110.outbound.protection.outlook.com ([157.56.111.110]:42432
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753366AbaIIJ3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:29:38 -0400
X-Greylist: delayed 948 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 05:29:37 EDT
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>
CC: <shengjiu.wang@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V1 1/3] ARM: clk-imx6sl: refine clock tree for SSI
Date: Tue, 9 Sep 2014 17:13:25 +0800
Message-ID: <7ed21195ebff8b3ccbecaeb492504edd28deea2d.1410253534.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1410253534.git.shengjiu.wang@freescale.com>
References: <cover.1410253534.git.shengjiu.wang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019018)(6009001)(189002)(199003)(19580405001)(83322001)(77156001)(21056001)(62966002)(4396001)(77982001)(89996001)(87286001)(48376002)(84676001)(68736004)(87936001)(88136002)(102836001)(92726001)(26826002)(97736003)(50226001)(46102001)(104166001)(19580395003)(36756003)(44976005)(6806004)(105606002)(95666004)(104016003)(118296001)(90102001)(33646002)(50986999)(106466001)(80022001)(47776003)(64706001)(81342001)(93916002)(74662001)(86362001)(2201001)(50466002)(31966008)(99396002)(74502001)(81542001)(92566001)(20776003)(79102001)(83072002)(76482001)(85852003)(76176999)(107046002)(85306004)(229853001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB335;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0329B15C8A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each SSI has "ssi", "ssi_ipg" clocks, and they share same gate bits.

Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 arch/arm/mach-imx/clk-imx6sl.c           |   13 ++++++++++---
 include/dt-bindings/clock/imx6sl-clock.h |    5 ++++-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-imx/clk-imx6sl.c b/arch/arm/mach-imx/clk-imx6sl.c
index 6791ff3..c8de87b 100644
--- a/arch/arm/mach-imx/clk-imx6sl.c
+++ b/arch/arm/mach-imx/clk-imx6sl.c
@@ -95,6 +95,10 @@ static struct clk_div_table video_div_table[] = {
 	{ }
 };
 
+static unsigned int share_count_ssi1;
+static unsigned int share_count_ssi2;
+static unsigned int share_count_ssi3;
+
 static struct clk *clks[IMX6SL_CLK_END];
 static struct clk_onecell_data clk_data;
 static void __iomem *ccm_base;
@@ -392,9 +396,12 @@ static void __init imx6sl_clocks_init(struct device_node *ccm_node)
 	clks[IMX6SL_CLK_SDMA]         = imx_clk_gate2("sdma",         "ipg",               base + 0x7c, 6);
 	clks[IMX6SL_CLK_SPBA]         = imx_clk_gate2("spba",         "ipg",               base + 0x7c, 12);
 	clks[IMX6SL_CLK_SPDIF]        = imx_clk_gate2("spdif",        "spdif0_podf",       base + 0x7c, 14);
-	clks[IMX6SL_CLK_SSI1]         = imx_clk_gate2("ssi1",         "ssi1_podf",         base + 0x7c, 18);
-	clks[IMX6SL_CLK_SSI2]         = imx_clk_gate2("ssi2",         "ssi2_podf",         base + 0x7c, 20);
-	clks[IMX6SL_CLK_SSI3]         = imx_clk_gate2("ssi3",         "ssi3_podf",         base + 0x7c, 22);
+	clks[IMX6SL_CLK_SSI1_IPG]     = imx_clk_gate2_shared("ssi1_ipg",     "ipg",        base + 0x7c, 18, &share_count_ssi1);
+	clks[IMX6SL_CLK_SSI2_IPG]     = imx_clk_gate2_shared("ssi2_ipg",     "ipg",        base + 0x7c, 20, &share_count_ssi2);
+	clks[IMX6SL_CLK_SSI3_IPG]     = imx_clk_gate2_shared("ssi3_ipg",     "ipg",        base + 0x7c, 22, &share_count_ssi3);
+	clks[IMX6SL_CLK_SSI1]         = imx_clk_gate2_shared("ssi1",         "ssi1_podf",  base + 0x7c, 18, &share_count_ssi1);
+	clks[IMX6SL_CLK_SSI2]         = imx_clk_gate2_shared("ssi2",         "ssi2_podf",  base + 0x7c, 20, &share_count_ssi2);
+	clks[IMX6SL_CLK_SSI3]         = imx_clk_gate2_shared("ssi3",         "ssi3_podf",  base + 0x7c, 22, &share_count_ssi3);
 	clks[IMX6SL_CLK_UART]         = imx_clk_gate2("uart",         "ipg",               base + 0x7c, 24);
 	clks[IMX6SL_CLK_UART_SERIAL]  = imx_clk_gate2("uart_serial",  "uart_root",         base + 0x7c, 26);
 	clks[IMX6SL_CLK_USBOH3]       = imx_clk_gate2("usboh3",       "ipg",               base + 0x80, 0);
diff --git a/include/dt-bindings/clock/imx6sl-clock.h b/include/dt-bindings/clock/imx6sl-clock.h
index f10a928..9ce4e42 100644
--- a/include/dt-bindings/clock/imx6sl-clock.h
+++ b/include/dt-bindings/clock/imx6sl-clock.h
@@ -171,6 +171,9 @@
 #define IMX6SL_PLL5_BYPASS		158
 #define IMX6SL_PLL6_BYPASS		159
 #define IMX6SL_PLL7_BYPASS		160
-#define IMX6SL_CLK_END			161
+#define IMX6SL_CLK_SSI1_IPG		161
+#define IMX6SL_CLK_SSI2_IPG		162
+#define IMX6SL_CLK_SSI3_IPG		163
+#define IMX6SL_CLK_END			164
 
 #endif /* __DT_BINDINGS_CLOCK_IMX6SL_H */
-- 
1.7.9.5

