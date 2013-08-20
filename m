Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3HTIiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:38:55 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:37407
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252Ab3HTIiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:38:52 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zcb8kzbb2dIzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Liu Ying <Ying.Liu@freescale.com>
To: <kernel@pengutronix.de>
CC: <gregkh@linuxfoundation.org>, <shawn.guo@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
Subject: [PATCH 1/3] ARM: imx6q: refactor some ldb related clocks
Date: Tue, 20 Aug 2013 16:38:50 +0800
Message-ID: <1376987932-5540-2-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376987932-5540-1-git-send-email-Ying.Liu@freescale.com>
References: <1376987932-5540-1-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ldb_di[0/1]_ipu_div dividers may divide their parent clock
frequencies by either 3.5 or 7. The non-integral dividers cannot
be dealt with the common clock framework directly, so they cannot
be registered as common clock dividers. So this patch adds a fixed
factor clock of 1/7 and introduces ldb_di[0/1]_div_sel multiplexers
so that the fixed factor clocks of 1/3.5 and 1/7 can be set to be
the parents of ldb_di[0/1]_div_sel multiplexers. The ldb_di[0/1]_podf
dividers are no longer used then.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 .../devicetree/bindings/clock/imx6q-clock.txt      |    6 +++--
 arch/arm/mach-imx/clk-imx6q.c                      |   25 ++++++++++++--------
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/imx6q-clock.txt b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
index 5a90a72..90e923e 100644
--- a/Documentation/devicetree/bindings/clock/imx6q-clock.txt
+++ b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
@@ -89,8 +89,6 @@ clocks and IDs.
 	gpu3d_shader		74
 	ipu1_podf		75
 	ipu2_podf		76
-	ldb_di0_podf		77
-	ldb_di1_podf		78
 	ipu1_di0_pre		79
 	ipu1_di1_pre		80
 	ipu2_di0_pre		81
@@ -215,6 +213,10 @@ clocks and IDs.
 	cko2      		200
 	cko      		201
 	vdoa      		202
+	ldb_di0_div_7		203
+	ldb_di1_div_7		204
+	ldb_di0_div_sel		205
+	ldb_di1_div_sel		206
 
 Examples:
 
diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index 9181a24..2b5be96 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -189,6 +189,8 @@ static const char *gpu3d_core_sels[]	= { "mmdc_ch0_axi", "pll3_usb_otg", "pll2_p
 static const char *gpu3d_shader_sels[] = { "mmdc_ch0_axi", "pll3_usb_otg", "pll2_pfd1_594m", "pll3_pfd0_720m", };
 static const char *ipu_sels[]		= { "mmdc_ch0_axi", "pll2_pfd2_396m", "pll3_120m", "pll3_pfd1_540m", };
 static const char *ldb_di_sels[]	= { "pll5_video_div", "pll2_pfd0_352m", "pll2_pfd2_396m", "mmdc_ch1_axi", "pll3_usb_otg", };
+static const char *ldb_di0_div_sels[]	= { "ldb_di0_div_3_5", "ldb_di0_div_7", };
+static const char *ldb_di1_div_sels[]	= { "ldb_di1_div_3_5", "ldb_di1_div_7", };
 static const char *ipu_di_pre_sels[]	= { "mmdc_ch0_axi", "pll3_usb_otg", "pll5_video_div", "pll2_pfd0_352m", "pll2_pfd2_396m", "pll3_pfd1_540m", };
 static const char *ipu1_di0_sels[]	= { "ipu1_di0_pre", "dummy", "dummy", "ldb_di0", "ldb_di1", };
 static const char *ipu1_di1_sels[]	= { "ipu1_di1_pre", "dummy", "dummy", "ldb_di0", "ldb_di1", };
@@ -233,11 +235,11 @@ enum mx6q_clks {
 	periph_clk2, periph2_clk2, ipg, ipg_per, esai_pred, esai_podf,
 	asrc_pred, asrc_podf, spdif_pred, spdif_podf, can_root, ecspi_root,
 	gpu2d_core_podf, gpu3d_core_podf, gpu3d_shader, ipu1_podf, ipu2_podf,
-	ldb_di0_podf, ldb_di1_podf, ipu1_di0_pre, ipu1_di1_pre, ipu2_di0_pre,
-	ipu2_di1_pre, hsi_tx_podf, ssi1_pred, ssi1_podf, ssi2_pred, ssi2_podf,
-	ssi3_pred, ssi3_podf, uart_serial_podf, usdhc1_podf, usdhc2_podf,
-	usdhc3_podf, usdhc4_podf, enfc_pred, enfc_podf, emi_podf,
-	emi_slow_podf, vpu_axi_podf, cko1_podf, axi, mmdc_ch0_axi_podf,
+	ldb_di0_podf_unused, ldb_di1_podf_unused, ipu1_di0_pre, ipu1_di1_pre,
+	ipu2_di0_pre, ipu2_di1_pre, hsi_tx_podf, ssi1_pred, ssi1_podf,
+	ssi2_pred, ssi2_podf, ssi3_pred, ssi3_podf, uart_serial_podf,
+	usdhc1_podf, usdhc2_podf, usdhc3_podf, usdhc4_podf, enfc_pred, enfc_podf,
+	emi_podf, emi_slow_podf, vpu_axi_podf, cko1_podf, axi, mmdc_ch0_axi_podf,
 	mmdc_ch1_axi_podf, arm, ahb, apbh_dma, asrc, can1_ipg, can1_serial,
 	can2_ipg, can2_serial, ecspi1, ecspi2, ecspi3, ecspi4, ecspi5, enet,
 	esai, gpt_ipg, gpt_ipg_per, gpu2d_core, gpu3d_core, hdmi_iahb,
@@ -251,7 +253,8 @@ enum mx6q_clks {
 	ssi2_ipg, ssi3_ipg, rom, usbphy1, usbphy2, ldb_di0_div_3_5, ldb_di1_div_3_5,
 	sata_ref, sata_ref_100m, pcie_ref, pcie_ref_125m, enet_ref, usbphy1_gate,
 	usbphy2_gate, pll4_post_div, pll5_post_div, pll5_video_div, eim_slow,
-	spdif, cko2_sel, cko2_podf, cko2, cko, vdoa, clk_max
+	spdif, cko2_sel, cko2_podf, cko2, cko, vdoa, ldb_di0_div_7, ldb_di1_div_7,
+	ldb_di0_div_sel, ldb_di1_div_sel, clk_max
 };
 
 static struct clk *clk[clk_max];
@@ -387,6 +390,8 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	clk[ipu2_sel]         = imx_clk_mux("ipu2_sel",         base + 0x3c, 14, 2, ipu_sels,          ARRAY_SIZE(ipu_sels));
 	clk[ldb_di0_sel]      = imx_clk_mux_flags("ldb_di0_sel", base + 0x2c, 9,  3, ldb_di_sels,      ARRAY_SIZE(ldb_di_sels), CLK_SET_RATE_PARENT);
 	clk[ldb_di1_sel]      = imx_clk_mux_flags("ldb_di1_sel", base + 0x2c, 12, 3, ldb_di_sels,      ARRAY_SIZE(ldb_di_sels), CLK_SET_RATE_PARENT);
+	clk[ldb_di0_div_sel]  = imx_clk_mux_flags("ldb_di0_div_sel", base + 0x20, 10, 1, ldb_di0_div_sels, ARRAY_SIZE(ldb_di0_div_sels), CLK_SET_RATE_PARENT);
+	clk[ldb_di1_div_sel]  = imx_clk_mux_flags("ldb_di1_div_sel", base + 0x20, 11, 1, ldb_di1_div_sels, ARRAY_SIZE(ldb_di1_div_sels), CLK_SET_RATE_PARENT);
 	clk[ipu1_di0_pre_sel] = imx_clk_mux("ipu1_di0_pre_sel", base + 0x34, 6,  3, ipu_di_pre_sels,   ARRAY_SIZE(ipu_di_pre_sels));
 	clk[ipu1_di1_pre_sel] = imx_clk_mux("ipu1_di1_pre_sel", base + 0x34, 15, 3, ipu_di_pre_sels,   ARRAY_SIZE(ipu_di_pre_sels));
 	clk[ipu2_di0_pre_sel] = imx_clk_mux("ipu2_di0_pre_sel", base + 0x38, 6,  3, ipu_di_pre_sels,   ARRAY_SIZE(ipu_di_pre_sels));
@@ -436,9 +441,9 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	clk[ipu1_podf]        = imx_clk_divider("ipu1_podf",        "ipu1_sel",          base + 0x3c, 11, 3);
 	clk[ipu2_podf]        = imx_clk_divider("ipu2_podf",        "ipu2_sel",          base + 0x3c, 16, 3);
 	clk[ldb_di0_div_3_5]  = imx_clk_fixed_factor("ldb_di0_div_3_5", "ldb_di0_sel", 2, 7);
-	clk[ldb_di0_podf]     = imx_clk_divider_flags("ldb_di0_podf", "ldb_di0_div_3_5", base + 0x20, 10, 1, 0);
+	clk[ldb_di0_div_7]    = imx_clk_fixed_factor("ldb_di0_div_7",   "ldb_di0_sel", 1, 7);
 	clk[ldb_di1_div_3_5]  = imx_clk_fixed_factor("ldb_di1_div_3_5", "ldb_di1_sel", 2, 7);
-	clk[ldb_di1_podf]     = imx_clk_divider_flags("ldb_di1_podf", "ldb_di1_div_3_5", base + 0x20, 11, 1, 0);
+	clk[ldb_di1_div_7]    = imx_clk_fixed_factor("ldb_di1_div_7",   "ldb_di1_sel", 1, 7);
 	clk[ipu1_di0_pre]     = imx_clk_divider("ipu1_di0_pre",     "ipu1_di0_pre_sel",  base + 0x34, 3,  3);
 	clk[ipu1_di1_pre]     = imx_clk_divider("ipu1_di1_pre",     "ipu1_di1_pre_sel",  base + 0x34, 12, 3);
 	clk[ipu2_di0_pre]     = imx_clk_divider("ipu2_di0_pre",     "ipu2_di0_pre_sel",  base + 0x38, 3,  3);
@@ -508,8 +513,8 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	clk[ipu1_di1]     = imx_clk_gate2("ipu1_di1",      "ipu1_di1_sel",      base + 0x74, 4);
 	clk[ipu2]         = imx_clk_gate2("ipu2",          "ipu2_podf",         base + 0x74, 6);
 	clk[ipu2_di0]     = imx_clk_gate2("ipu2_di0",      "ipu2_di0_sel",      base + 0x74, 8);
-	clk[ldb_di0]      = imx_clk_gate2("ldb_di0",       "ldb_di0_podf",      base + 0x74, 12);
-	clk[ldb_di1]      = imx_clk_gate2("ldb_di1",       "ldb_di1_podf",      base + 0x74, 14);
+	clk[ldb_di0]      = imx_clk_gate2("ldb_di0",       "ldb_di0_div_sel",   base + 0x74, 12);
+	clk[ldb_di1]      = imx_clk_gate2("ldb_di1",       "ldb_di1_div_sel",   base + 0x74, 14);
 	clk[ipu2_di1]     = imx_clk_gate2("ipu2_di1",      "ipu2_di1_sel",      base + 0x74, 10);
 	clk[hsi_tx]       = imx_clk_gate2("hsi_tx",        "hsi_tx_podf",       base + 0x74, 16);
 	if (cpu_is_imx6dl())
-- 
1.7.9.5


