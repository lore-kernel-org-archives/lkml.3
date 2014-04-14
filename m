Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbaDNQ0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:26:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48068 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbaDNQ0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:26:00 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/15] bus: omap_l3_noc: Add DRA7 interconnect error data
Date: Mon, 14 Apr 2014 11:25:25 -0500
Message-ID: <1397492726-17203-16-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397492726-17203-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajendra Nayak <rnayak@ti.com>

DRA7 is distinctly different from OMAP4 in terms of masters and clock
domain organization. There two main clock domains which is divided as
follows:
     <0x44000000 0x1000000> is clk1 and clk2 is the sub clock domain
     <0x45000000 0x1000> is clk3

Add all the data needed to handle L3 error handling on DRA7 devices
and mark clk2 as subdomain and provide a compatible flag for
functionality. Other than the data difference the hardware blocks
involved are essentially the same.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
[nm@ti.com: bugfixes and generic improvements, documentation]
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 .../devicetree/bindings/arm/omap/l3-noc.txt        |    1 +
 drivers/bus/omap_l3_noc.c                          |    1 +
 drivers/bus/omap_l3_noc.h                          |  133 ++++++++++++++++++++
 3 files changed, 135 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/omap/l3-noc.txt b/Documentation/devicetree/bindings/arm/omap/l3-noc.txt
index c0105de..45d0fc2 100644
--- a/Documentation/devicetree/bindings/arm/omap/l3-noc.txt
+++ b/Documentation/devicetree/bindings/arm/omap/l3-noc.txt
@@ -6,6 +6,7 @@ provided by Arteris.
 Required properties:
 - compatible : Should be "ti,omap3-l3-smx" for OMAP3 family
                Should be "ti,omap4-l3-noc" for OMAP4 family
+	       Should be "ti,dra7-l3-noc" for DRA7 family
 - reg:	Contains L3 register address range for each noc domain.
 - ti,hwmods: "l3_main_1", ... One hwmod for each noc domain.
 
diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 5e2a89d..9b32e53 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -176,6 +176,7 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 
 static const struct of_device_id l3_noc_match[] = {
 	{.compatible = "ti,omap4-l3-noc", .data = &omap_l3_data},
+	{.compatible = "ti,dra7-l3-noc", .data = &dra_l3_data},
 	{},
 };
 MODULE_DEVICE_TABLE(of, l3_noc_match);
diff --git a/drivers/bus/omap_l3_noc.h b/drivers/bus/omap_l3_noc.h
index 592821f..365a33c 100644
--- a/drivers/bus/omap_l3_noc.h
+++ b/drivers/bus/omap_l3_noc.h
@@ -206,4 +206,137 @@ static const struct omap_l3 omap_l3_data = {
 	.num_masters = ARRAY_SIZE(omap_l3_masters),
 };
 
+/* DRA7 data */
+static struct l3_target_data dra_l3_target_data_clk1[] = {
+	{0xdead, L3_TARGET_NOT_SUPPORTED,},
+	{0x0200, "DMM_P1",},
+	{0x0600, "DSP2_SDMA",},
+	{0x0b00, "EVE2",},
+	{0x1300, "DMM_P2",},
+	{0xdead, L3_TARGET_NOT_SUPPORTED,},
+	{0x0300, "DSP1_SDMA",},
+	{0x0a00, "EVE1",},
+	{0x0c00, "EVE3",},
+	{0x0d00, "EVE4",},
+	{0x2900, "DSS",},
+	{0x0100, "GPMC",},
+	{0x3700, "PCIE1",},
+	{0x1600, "IVA_CONFIG",},
+	{0x1800, "IVA_SL2IF",},
+	{0x0500, "L4_CFG",},
+	{0x1d00, "L4_WKUP",},
+	{0x3800, "PCIE2",},
+	{0xdead, L3_TARGET_NOT_SUPPORTED,},
+	{0x1200, "GPU",},
+	{0x1000, "IPU1",},
+	{0x1100, "IPU2",},
+	{0x2000, "TPCC_EDMA",},
+	{0x2e00, "TPTC1_EDMA",},
+	{0x2b00, "TPTC2_EDMA",},
+	{0x0700, "VCP1",},
+	{0x2500, "L4_PER2_P3",},
+	{0x0e00, "L4_PER3_P3",},
+	{0x2200, "MMU1",},
+	{0x1400, "PRUSS1",},
+};
+
+static struct l3_flagmux_data dra_l3_flagmux_clk1 = {
+	.offset = 0x803500,
+	.l3_targ = dra_l3_target_data_clk1,
+	.num_targ_data = ARRAY_SIZE(dra_l3_target_data_clk1),
+};
+
+static struct l3_target_data dra_l3_target_data_clk2[] = {
+	{0x0,   "RT_CLK1_1",},
+	{0xdead, L3_TARGET_NOT_SUPPORTED,},
+	{0xdead, L3_TARGET_NOT_SUPPORTED,},
+	{0xdead, L3_TARGET_NOT_SUPPORTED,},
+	{0x0900, "BB2D",},
+	{0xdead, L3_TARGET_NOT_SUPPORTED,},
+	{0x2100, "L4_PER1_P3",},
+	{0x1c00, "L4_PER1_P1",},
+	{0x1f00, "L4_PER1_P2",},
+	{0x2300, "L4_PER2_P1",},
+	{0x2400, "L4_PER2_P2",},
+	{0x2600, "L4_PER3_P1",},
+	{0x2700, "L4_PER3_P2",},
+	{0x2f00, "MCASP1",},
+	{0xdead, L3_TARGET_NOT_SUPPORTED,},
+	{0xdead, L3_TARGET_NOT_SUPPORTED,},
+	{0x2800, "MMU2",},
+	{0x0f00, "OCMC_RAM1",},
+	{0x1700, "OCMC_RAM2",},
+	{0x1900, "OCMC_RAM3",},
+	{0xdead, L3_TARGET_NOT_SUPPORTED,},
+	{0x3900, "QSPI",},
+};
+
+static struct l3_flagmux_data dra_l3_flagmux_clk2 = {
+	.offset = 0x803600,
+	.l3_targ = dra_l3_target_data_clk2,
+	.num_targ_data = ARRAY_SIZE(dra_l3_target_data_clk2),
+};
+
+static struct l3_target_data dra_l3_target_data_clk3[] = {
+	{0x0100, "L3_INSTR"},
+	{0x0300, "DEBUGSS_CT_TBR"},
+	{0x0,    "HOST CLK3"},
+};
+
+static struct l3_flagmux_data dra_l3_flagmux_clk3 = {
+	.offset = 0x200,
+	.l3_targ = dra_l3_target_data_clk3,
+	.num_targ_data = ARRAY_SIZE(dra_l3_target_data_clk3),
+};
+
+static struct l3_masters_data dra_l3_masters[] = {
+	{ 0x0, "MPU" },
+	{ 0x4, "CS_DAP" },
+	{ 0x8, "DSP1_MDMA" },
+	{ 0x9, "DSP1_CFG" },
+	{ 0xA, "DSP1_DMA" },
+	{ 0xB, "DSP2_MDMA" },
+	{ 0xC, "DSP2_CFG" },
+	{ 0xD, "DSP2_DMA" },
+	{ 0xE, "IVA" },
+	{ 0x10, "EVE1_P1" },
+	{ 0x11, "EVE2_P1" },
+	{ 0x12, "EVE3_P1" },
+	{ 0x13, "EVE4_P1" },
+	{ 0x14, "PRU1" },
+	{ 0x15, "PRU2" },
+	{ 0x18, "IPU1" },
+	{ 0x1C, "TC1_EDMA" },
+	{ 0x1D, "TC2_EDMA" },
+	{ 0x20, "DSS" },
+	{ 0x21, "MMU1" },
+	{ 0x22, "PCIE1" },
+	{ 0x23, "MMU2" },
+	{ 0x24, "VIP1" },
+	{ 0x25, "VIP2" },
+	{ 0x26, "VIP3" },
+	{ 0x27, "VPE" },
+	{ 0x28, "GPU_P1" },
+	{ 0x29, "GPU_P2" },
+	{ 0x2B, "GMAC_SW" },
+	{ 0x34, "EVE1_P2" },
+	{ 0x35, "EVE2_P2" },
+	{ 0x36, "EVE3_P2" },
+	{ 0x37, "EVE4_P2" }
+};
+
+static struct l3_flagmux_data *dra_l3_flagmux[] = {
+	&dra_l3_flagmux_clk1,
+	&dra_l3_flagmux_clk2,
+	&dra_l3_flagmux_clk3,
+};
+
+static const struct omap_l3 dra_l3_data = {
+	.l3_base = { [1] = L3_BASE_IS_SUBMODULE },
+	.l3_flagmux = dra_l3_flagmux,
+	.num_modules = ARRAY_SIZE(dra_l3_flagmux),
+	.l3_masters = dra_l3_masters,
+	.num_masters = ARRAY_SIZE(dra_l3_masters),
+};
+
 #endif	/* __OMAP_L3_NOC_H */
-- 
1.7.9.5

