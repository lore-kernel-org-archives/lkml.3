Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaLaIUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:20:01 -0500
Received: from mail-bl2on0114.outbound.protection.outlook.com ([65.55.169.114]:26407
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751772AbaLaIT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:19:56 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v8 08/21] ARM: imx6q: clk: Add support for mipi_core_cfg clock as a shared clock gate
Date: Wed, 31 Dec 2014 16:23:26 +0800
Message-ID: <1420014219-915-9-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420014219-915-1-git-send-email-Ying.Liu@freescale.com>
References: <1420014219-915-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(4396001)(87936001)(86362001)(120916001)(84676001)(85426001)(36756003)(21056001)(92566001)(89996001)(104016003)(19580395003)(50986999)(76176999)(2950100001)(81156004)(2351001)(69596002)(48376002)(64706001)(31966008)(46102003)(68736005)(6806004)(97736003)(106466001)(47776003)(77096005)(50226001)(99396003)(20776003)(107046002)(229853001)(62966003)(19580405001)(77156002)(50466002)(110136001)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0639;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0639;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0639;
X-Forefront-PRVS: 0442E569BC
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0639;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2014 08:19:53.6010
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0639
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CG8 field of the CCM CCGR3 register is named as 'mipi_core_cfg' clock,
according to the i.MX6q/sdl reference manuals.  This clock is actually the
gate for several clocks, including the hsi_tx_sel clock's output and the
video_27m clock's output.  The MIPI DSI host controller embedded in the
i.MX6q/sdl SoCs uses the video_27m clock to generate PLL reference clock and
MIPI core configuration clock.  In order to gate/ungate the two MIPI DSI
host controller relevant clocks, this patch adds the mipi_core_cfg clock as
a shared clock gate.

Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v7->v8:
 * None.

v6->v7:
 * None.

v5->v6:
 * Add two spaces in the clock driver to eliminate two errors reported by
   the checkpatch.pl script.

v4->v5:
 * None.

v3->v4:
 * None.

v2->v3:
 * Newly introduced in v3.

 arch/arm/mach-imx/clk-imx6q.c             | 1 +
 include/dt-bindings/clock/imx6qdl-clock.h | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index 080d5b7..0f4d07c 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -418,6 +418,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	clk[IMX6QDL_CLK_LDB_DI1]      = imx_clk_gate2("ldb_di1",       "ldb_di1_podf",      base + 0x74, 14);
 	clk[IMX6QDL_CLK_IPU2_DI1]     = imx_clk_gate2("ipu2_di1",      "ipu2_di1_sel",      base + 0x74, 10);
 	clk[IMX6QDL_CLK_HSI_TX]       = imx_clk_gate2_shared("hsi_tx", "hsi_tx_podf",       base + 0x74, 16, &share_count_mipi_core_cfg);
+	clk[IMX6QDL_CLK_MIPI_CORE_CFG] = imx_clk_gate2_shared("mipi_core_cfg", "video_27m", base + 0x74, 16, &share_count_mipi_core_cfg);
 	if (cpu_is_imx6dl())
 		/*
 		 * The multiplexer and divider of the imx6q clock gpu2d get
diff --git a/include/dt-bindings/clock/imx6qdl-clock.h b/include/dt-bindings/clock/imx6qdl-clock.h
index 25625bf..dbc828c 100644
--- a/include/dt-bindings/clock/imx6qdl-clock.h
+++ b/include/dt-bindings/clock/imx6qdl-clock.h
@@ -249,6 +249,7 @@
 #define IMX6QDL_PLL7_BYPASS			236
 #define IMX6QDL_CLK_GPT_3M			237
 #define IMX6QDL_CLK_VIDEO_27M			238
-#define IMX6QDL_CLK_END				239
+#define IMX6QDL_CLK_MIPI_CORE_CFG		239
+#define IMX6QDL_CLK_END				240
 
 #endif /* __DT_BINDINGS_CLOCK_IMX6QDL_H */
-- 
2.1.0

