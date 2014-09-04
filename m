Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaIDJtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:49:35 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:36483
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751023AbaIDJtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:49:32 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>
CC: <shengjiu.wang@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V1 1/2] ARM: clk-imx6q: refine clock tree for ASRC
Date: Thu, 4 Sep 2014 17:48:58 +0800
Message-ID: <98d2985de76fa84525e9958522bd371a34ff84f0.1409824001.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(62966002)(36756003)(44976005)(80022001)(84676001)(118296001)(95666004)(74502001)(229853001)(90102001)(81342001)(64706001)(31966008)(107046002)(77156001)(81542001)(106466001)(97736001)(104166001)(85306004)(89996001)(88136002)(4396001)(85852003)(76482001)(50226001)(92726001)(26826002)(83072002)(68736004)(83322001)(102836001)(50986999)(79102001)(87286001)(6806004)(104016003)(48376002)(2201001)(19580395003)(20776003)(50466002)(21056001)(19580405001)(99396002)(33646002)(46102001)(86362001)(47776003)(77982001)(92566001)(105606002)(93916002)(87936001)(74662001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB350;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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

ASRC has "asrc", "asrc_ipg", "asrc_mem" clocks, and they share
the same gate bits.

Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 arch/arm/mach-imx/clk-imx6q.c             |    5 ++++-
 include/dt-bindings/clock/imx6qdl-clock.h |    4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index 2edcebf..d5bf1e2 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -107,6 +107,7 @@ static struct clk_div_table video_div_table[] = {
 };
 
 static unsigned int share_count_esai;
+static unsigned int share_count_asrc;
 
 static void __init imx6q_clocks_init(struct device_node *ccm_node)
 {
@@ -317,7 +318,9 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 
 	/*                                            name             parent_name          reg         shift */
 	clk[IMX6QDL_CLK_APBH_DMA]     = imx_clk_gate2("apbh_dma",      "usdhc3",            base + 0x68, 4);
-	clk[IMX6QDL_CLK_ASRC]         = imx_clk_gate2("asrc",          "asrc_podf",         base + 0x68, 6);
+	clk[IMX6QDL_CLK_ASRC]         = imx_clk_gate2_shared("asrc",         "asrc_podf",   base + 0x68, 6, &share_count_asrc);
+	clk[IMX6QDL_CLK_ASRC_IPG]     = imx_clk_gate2_shared("asrc_ipg",     "ahb",         base + 0x68, 6, &share_count_asrc);
+	clk[IMX6QDL_CLK_ASRC_MEM]     = imx_clk_gate2_shared("asrc_mem",     "ahb",         base + 0x68, 6, &share_count_asrc);
 	clk[IMX6QDL_CLK_CAN1_IPG]     = imx_clk_gate2("can1_ipg",      "ipg",               base + 0x68, 14);
 	clk[IMX6QDL_CLK_CAN1_SERIAL]  = imx_clk_gate2("can1_serial",   "can_root",          base + 0x68, 16);
 	clk[IMX6QDL_CLK_CAN2_IPG]     = imx_clk_gate2("can2_ipg",      "ipg",               base + 0x68, 18);
diff --git a/include/dt-bindings/clock/imx6qdl-clock.h b/include/dt-bindings/clock/imx6qdl-clock.h
index 323e865..1e99613 100644
--- a/include/dt-bindings/clock/imx6qdl-clock.h
+++ b/include/dt-bindings/clock/imx6qdl-clock.h
@@ -220,6 +220,8 @@
 #define IMX6QDL_CLK_LVDS2_GATE			207
 #define IMX6QDL_CLK_ESAI_IPG			208
 #define IMX6QDL_CLK_ESAI_MEM			209
-#define IMX6QDL_CLK_END				210
+#define IMX6QDL_CLK_ASRC_IPG			210
+#define IMX6QDL_CLK_ASRC_MEM			211
+#define IMX6QDL_CLK_END				212
 
 #endif /* __DT_BINDINGS_CLOCK_IMX6QDL_H */
-- 
1.7.9.5

