Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaL2GkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 01:40:13 -0500
Received: from mail-bn1bon0133.outbound.protection.outlook.com ([157.56.111.133]:13568
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751995AbaL2GgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 01:36:07 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v6 07/21] ARM: imx6q: clk: Change hsi_tx clock to be a shared clock gate
Date: Mon, 29 Dec 2014 14:39:14 +0800
Message-ID: <1419835168-9034-8-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419835168-9034-1-git-send-email-Ying.Liu@freescale.com>
References: <1419835168-9034-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(99396003)(229853001)(47776003)(107046002)(2950100001)(62966003)(77156002)(84676001)(110136001)(104016003)(6806004)(50226001)(64706001)(19580405001)(20776003)(2351001)(19580395003)(105606002)(36756003)(4396001)(106466001)(77096005)(89996001)(48376002)(87936001)(50466002)(97736003)(76176999)(50986999)(21056001)(120916001)(85426001)(68736005)(46102003)(86362001)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0640;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0640;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0640;
X-Forefront-PRVS: 0440AC9990
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0640;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2014 06:36:03.7653
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0640
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CG8 field of the CCM CCGR3 register is named as 'mipi_core_cfg'
clock, according to the i.MX6q/sdl reference manuals.  This clock is
actually the gate for several clocks, including the hsi_tx_sel clock's
output and the video_27m clock's output.  So, this patch changes the
hsi_tx clock to be a shared clock gate.

Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v5->v6:
 * None.

v4->v5:
 * None.

v3->v4:
 * None.

v2->v3:
 * Newly introduced in v3.

 arch/arm/mach-imx/clk-imx6q.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index f19472a..080d5b7 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -119,6 +119,7 @@ static unsigned int share_count_asrc;
 static unsigned int share_count_ssi1;
 static unsigned int share_count_ssi2;
 static unsigned int share_count_ssi3;
+static unsigned int share_count_mipi_core_cfg;
 
 static void __init imx6q_clocks_init(struct device_node *ccm_node)
 {
@@ -416,7 +417,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	clk[IMX6QDL_CLK_LDB_DI0]      = imx_clk_gate2("ldb_di0",       "ldb_di0_podf",      base + 0x74, 12);
 	clk[IMX6QDL_CLK_LDB_DI1]      = imx_clk_gate2("ldb_di1",       "ldb_di1_podf",      base + 0x74, 14);
 	clk[IMX6QDL_CLK_IPU2_DI1]     = imx_clk_gate2("ipu2_di1",      "ipu2_di1_sel",      base + 0x74, 10);
-	clk[IMX6QDL_CLK_HSI_TX]       = imx_clk_gate2("hsi_tx",        "hsi_tx_podf",       base + 0x74, 16);
+	clk[IMX6QDL_CLK_HSI_TX]       = imx_clk_gate2_shared("hsi_tx", "hsi_tx_podf",       base + 0x74, 16, &share_count_mipi_core_cfg);
 	if (cpu_is_imx6dl())
 		/*
 		 * The multiplexer and divider of the imx6q clock gpu2d get
-- 
2.1.0

