Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaIDJtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:49:33 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:1778
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750902AbaIDJtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:49:31 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>
CC: <shengjiu.wang@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V1 2/2] ARM: clk-imx6q: refine clock tree for SSI
Date: Thu, 4 Sep 2014 17:48:59 +0800
Message-ID: <1f6481989f10f7777b56574f240895a5fb4ac189.1409824001.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <98d2985de76fa84525e9958522bd371a34ff84f0.1409824001.git.shengjiu.wang@freescale.com>
References: <98d2985de76fa84525e9958522bd371a34ff84f0.1409824001.git.shengjiu.wang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(107046002)(229853001)(90102001)(77156001)(26826002)(4396001)(104166001)(48376002)(50986999)(50226001)(31966008)(99396002)(97736001)(106466001)(33646002)(104016003)(102836001)(105606002)(50466002)(74662001)(92726001)(89996001)(64706001)(2201001)(92566001)(21056001)(79102001)(62966002)(87286001)(20776003)(68736004)(47776003)(95666004)(93916002)(86362001)(80022001)(87936001)(44976005)(76482001)(19580405001)(19580395003)(46102001)(76176999)(85306004)(74502001)(77982001)(118296001)(81342001)(6806004)(36756003)(88136002)(83322001)(84676001)(81542001)(85852003)(83072002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB329;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0324C2C0E2
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each SSI has "ssi", "ssi_ipg" clocks, and they share same gate bits.

Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 arch/arm/mach-imx/clk-imx6q.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index d5bf1e2..013d3cd 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -108,6 +108,9 @@ static struct clk_div_table video_div_table[] = {
 
 static unsigned int share_count_esai;
 static unsigned int share_count_asrc;
+static unsigned int share_count_ssi1;
+static unsigned int share_count_ssi2;
+static unsigned int share_count_ssi3;
 
 static void __init imx6q_clocks_init(struct device_node *ccm_node)
 {
@@ -392,9 +395,12 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	clk[IMX6QDL_CLK_SDMA]         = imx_clk_gate2("sdma",          "ahb",               base + 0x7c, 6);
 	clk[IMX6QDL_CLK_SPBA]         = imx_clk_gate2("spba",          "ipg",               base + 0x7c, 12);
 	clk[IMX6QDL_CLK_SPDIF]        = imx_clk_gate2("spdif",         "spdif_podf",        base + 0x7c, 14);
-	clk[IMX6QDL_CLK_SSI1_IPG]     = imx_clk_gate2("ssi1_ipg",      "ipg",               base + 0x7c, 18);
-	clk[IMX6QDL_CLK_SSI2_IPG]     = imx_clk_gate2("ssi2_ipg",      "ipg",               base + 0x7c, 20);
-	clk[IMX6QDL_CLK_SSI3_IPG]     = imx_clk_gate2("ssi3_ipg",      "ipg",               base + 0x7c, 22);
+	clk[IMX6QDL_CLK_SSI1_IPG]     = imx_clk_gate2_shared("ssi1_ipg",      "ipg",        base + 0x7c, 18, &share_count_ssi1);
+	clk[IMX6QDL_CLK_SSI2_IPG]     = imx_clk_gate2_shared("ssi2_ipg",      "ipg",        base + 0x7c, 20, &share_count_ssi2);
+	clk[IMX6QDL_CLK_SSI3_IPG]     = imx_clk_gate2_shared("ssi3_ipg",      "ipg",        base + 0x7c, 22, &share_count_ssi3);
+	clk[IMX6QDL_CLK_SSI1]         = imx_clk_gate2_shared("ssi1",          "ssi1_podf",  base + 0x7c, 18, &share_count_ssi1);
+	clk[IMX6QDL_CLK_SSI2]         = imx_clk_gate2_shared("ssi2",          "ssi2_podf",  base + 0x7c, 20, &share_count_ssi2);
+	clk[IMX6QDL_CLK_SSI3]         = imx_clk_gate2_shared("ssi3",          "ssi3_podf",  base + 0x7c, 22, &share_count_ssi3);
 	clk[IMX6QDL_CLK_UART_IPG]     = imx_clk_gate2("uart_ipg",      "ipg",               base + 0x7c, 24);
 	clk[IMX6QDL_CLK_UART_SERIAL]  = imx_clk_gate2("uart_serial",   "uart_serial_podf",  base + 0x7c, 26);
 	clk[IMX6QDL_CLK_USBOH3]       = imx_clk_gate2("usboh3",        "ipg",               base + 0x80, 0);
-- 
1.7.9.5

