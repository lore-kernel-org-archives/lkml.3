Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbaISKhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:37:46 -0400
Received: from mail-bn1bon0133.outbound.protection.outlook.com ([157.56.111.133]:61847
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754085AbaISKhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:37:45 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ARM: ls1021a: add gating clocks to IP blocks.
Date: Fri, 19 Sep 2014 18:37:27 +0800
Message-ID: <1411123047-7544-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(46102003)(83072002)(6806004)(48376002)(4396001)(85852003)(80022003)(50226001)(74502003)(74662003)(93916002)(83322001)(97736003)(102836001)(86362001)(62966002)(107046002)(19580395003)(79102003)(229853001)(92726001)(44976005)(68736004)(19580405001)(104016003)(77982003)(69596002)(81342003)(31966008)(50986999)(81542003)(2201001)(90102001)(104166001)(92566001)(81156004)(26826002)(64706001)(106466001)(20776003)(47776003)(105606002)(76482002)(85306004)(87936001)(89996001)(87286001)(99396002)(36756003)(50466002)(77156001)(21056001)(95666004)(84676001)(88136002)(2004002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
X-Forefront-PRVS: 0339F89554
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A given application may not use all the peripherals on the device.
In this case, it may be desirable to disable unused peripherals.
DCFG provides a mechanism for gating clocks to IP blocks that are
not used when running an application.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 arch/arm/mach-imx/Makefile                |   2 +
 arch/arm/mach-imx/clk-ls1021a.c           | 124 ++++++++++++++++++++++++++++++
 arch/arm/mach-imx/clk.h                   |  21 +++++
 include/dt-bindings/clock/ls1021a-clock.h |  54 +++++++++++++
 4 files changed, 201 insertions(+)
 create mode 100644 arch/arm/mach-imx/clk-ls1021a.c
 create mode 100644 include/dt-bindings/clock/ls1021a-clock.h

diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index 6e4fcd8..f6a1544 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -110,4 +110,6 @@ obj-$(CONFIG_SOC_IMX53) += mach-imx53.o
 
 obj-$(CONFIG_SOC_VF610) += clk-vf610.o mach-vf610.o
 
+obj-$(CONFIG_SOC_LS1021A) += clk-ls1021a.o
+
 obj-y += devices/
diff --git a/arch/arm/mach-imx/clk-ls1021a.c b/arch/arm/mach-imx/clk-ls1021a.c
new file mode 100644
index 0000000..680b616
--- /dev/null
+++ b/arch/arm/mach-imx/clk-ls1021a.c
@@ -0,0 +1,124 @@
+/*
+ * Copyright 2014 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/mfd/syscon.h>
+#include <linux/of_address.h>
+#include <dt-bindings/clock/ls1021a-clock.h>
+
+#include "clk.h"
+
+static struct clk *clk[LS1021A_CLK_END];
+static struct clk_onecell_data clk_data;
+
+static void __init ls1021a_clocks_init(struct device_node *np)
+{
+	void __iomem *dcfg_base;
+
+#define DCFG_CCSR_DEVDISR1	(dcfg_base + 0x70)
+#define DCFG_CCSR_DEVDISR2	(dcfg_base + 0x74)
+#define DCFG_CCSR_DEVDISR3	(dcfg_base + 0x78)
+#define DCFG_CCSR_DEVDISR4	(dcfg_base + 0x7c)
+#define DCFG_CCSR_DEVDISR5	(dcfg_base + 0x80)
+
+	dcfg_base = of_iomap(np, 0);
+
+	BUG_ON(!dcfg_base);
+
+	clk[LS1021A_CLK_PBL_EN] = ls1021a_clk_gate("pbl_en", "dummy",
+						DCFG_CCSR_DEVDISR1, 0, true);
+	clk[LS1021A_CLK_ESDHC_EN] = ls1021a_clk_gate("esdhc_en", "dummy",
+						DCFG_CCSR_DEVDISR1, 2, true);
+	clk[LS1021A_CLK_DMA1_EN] = ls1021a_clk_gate("dma1_en", "dummy",
+						DCFG_CCSR_DEVDISR1, 8, true);
+	clk[LS1021A_CLK_DMA2_EN] = ls1021a_clk_gate("dma2_en", "dummy",
+						DCFG_CCSR_DEVDISR1, 9, true);
+	clk[LS1021A_CLK_USB3_PHY_EN] = ls1021a_clk_gate("usb3_phy_en", "dummy",
+						DCFG_CCSR_DEVDISR1, 12, true);
+	clk[LS1021A_CLK_USB2_EN] = ls1021a_clk_gate("usb2_en", "dummy",
+						DCFG_CCSR_DEVDISR1, 13, true);
+	clk[LS1021A_CLK_SATA_EN] = ls1021a_clk_gate("sata_en", "dummy",
+						DCFG_CCSR_DEVDISR1, 16, true);
+	clk[LS1021A_CLK_USB3_EN] = ls1021a_clk_gate("usb3_en", "dummy",
+						DCFG_CCSR_DEVDISR1, 17, true);
+	clk[LS1021A_CLK_SEC_EN] = ls1021a_clk_gate("sec_en", "dummy",
+						DCFG_CCSR_DEVDISR1, 22, true);
+	clk[LS1021A_CLK_2D_ACE_EN] = ls1021a_clk_gate("2d_ace_en", "dummy",
+						DCFG_CCSR_DEVDISR1, 30, true);
+	clk[LS1021A_CLK_QE_EN] = ls1021a_clk_gate("qe_en", "dummy",
+						DCFG_CCSR_DEVDISR1, 31, true);
+
+	clk[LS1021A_CLK_ETSEC1_EN] = ls1021a_clk_gate("etsec1_en", "dummy",
+						DCFG_CCSR_DEVDISR2, 0, true);
+	clk[LS1021A_CLK_ETSEC2_EN] = ls1021a_clk_gate("etsec2_en", "dummy",
+						DCFG_CCSR_DEVDISR2, 1, true);
+	clk[LS1021A_CLK_ETSEC3_EN] = ls1021a_clk_gate("etsec3_en", "dummy",
+						DCFG_CCSR_DEVDISR2, 2, true);
+
+	clk[LS1021A_CLK_PEX1_EN] = ls1021a_clk_gate("pex1_en", "dummy",
+						DCFG_CCSR_DEVDISR3, 0, true);
+	clk[LS1021A_CLK_PEX2_EN] = ls1021a_clk_gate("pex2_en", "dummy",
+						DCFG_CCSR_DEVDISR3, 1, true);
+
+	clk[LS1021A_CLK_DUART1_EN] = ls1021a_clk_gate("duart1_en", "dummy",
+						DCFG_CCSR_DEVDISR4, 2, true);
+	clk[LS1021A_CLK_DUART2_EN] = ls1021a_clk_gate("duart2_en", "dummy",
+						DCFG_CCSR_DEVDISR4, 3, true);
+	clk[LS1021A_CLK_QSPI_EN] = ls1021a_clk_gate("qspi_en", "dummy",
+						DCFG_CCSR_DEVDISR4, 4, true);
+
+	clk[LS1021A_CLK_DDR_EN] = ls1021a_clk_gate("ddr_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 0, true);
+	clk[LS1021A_CLK_OCRAM1_EN] = ls1021a_clk_gate("ocram1_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 4, true);
+	clk[LS1021A_CLK_IFC_EN] = ls1021a_clk_gate("ifc_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 8, true);
+	clk[LS1021A_CLK_GPIO_EN] = ls1021a_clk_gate("gpio_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 9, true);
+	clk[LS1021A_CLK_DBG_EN] = ls1021a_clk_gate("dbg_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 10, true);
+	clk[LS1021A_CLK_FLEXCAN1_EN] = ls1021a_clk_gate("flexcan1_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 12, true);
+	clk[LS1021A_CLK_FLEXCAN234_EN] = ls1021a_clk_gate("flexcan234_en",
+					"dummy", DCFG_CCSR_DEVDISR5, 13, true);
+	/* For flextiemr 2/3/4/5/6/7/8 */
+	clk[LS1021A_CLK_FLEXTIMER_EN] = ls1021a_clk_gate("flextimer_en",
+					"dummy", DCFG_CCSR_DEVDISR5, 14, true);
+	clk[LS1021A_CLK_SECMON_EN] = ls1021a_clk_gate("secmon_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 17, true);
+	clk[LS1021A_CLK_WDOG12_EN] = ls1021a_clk_gate("wdog12_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 21, true);
+	clk[LS1021A_CLK_I2C23_EN] = ls1021a_clk_gate("i2c23_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 22, true);
+	/* For SAI 1/2/3/4 */
+	clk[LS1021A_CLK_SAI_EN] = ls1021a_clk_gate("sai_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 23, true);
+	/* For lpuart 2/3/4/5/6  */
+	clk[LS1021A_CLK_LPUART_EN] = ls1021a_clk_gate("lpuart_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 24, true);
+	clk[LS1021A_CLK_DSPI12_EN] = ls1021a_clk_gate("dspi12_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 25, true);
+	clk[LS1021A_CLK_ASRC_EN] = ls1021a_clk_gate("asrc_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 26, true);
+	clk[LS1021A_CLK_SPDIF_EN] = ls1021a_clk_gate("spdif_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 27, true);
+	clk[LS1021A_CLK_I2C1_EN] = ls1021a_clk_gate("i2c1_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 29, true);
+	clk[LS1021A_CLK_LPUART1_EN] = ls1021a_clk_gate("lpuart1_en", "dummy",
+						DCFG_CCSR_DEVDISR5, 30, true);
+	clk[LS1021A_CLK_FLEXTIMER1_EN] = ls1021a_clk_gate("flextimer1_en",
+					"dummy", DCFG_CCSR_DEVDISR5, 31, true);
+
+	/* Add the clocks to provider list */
+	clk_data.clks = clk;
+	clk_data.clk_num = ARRAY_SIZE(clk);
+	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
+}
+CLK_OF_DECLARE(ls1021a, "fsl,ls1021a-gate", ls1021a_clocks_init);
diff --git a/arch/arm/mach-imx/clk.h b/arch/arm/mach-imx/clk.h
index 4cdf8b6..dd9e369 100644
--- a/arch/arm/mach-imx/clk.h
+++ b/arch/arm/mach-imx/clk.h
@@ -107,6 +107,27 @@ static inline struct clk *imx_clk_gate_dis(const char *name, const char *parent,
 			shift, CLK_GATE_SET_TO_DISABLE, &imx_ccm_lock);
 }
 
+/* The DCFG registers are in big endian mode on LS1021A SoC */
+static inline u8 ls1021a_clk_calculate_shift(u8 shift)
+{
+	int m, n;
+
+	m = shift / 8;
+	n = shift % 8;
+
+	return (3 - m) * 8 + n;
+}
+
+static inline struct clk *ls1021a_clk_gate(const char *name, const char *parent,
+		void __iomem *reg, u8 shift, bool big_endian)
+{
+	if (big_endian)
+		shift = ls1021a_clk_calculate_shift(shift);
+
+	return clk_register_gate(NULL, name, parent, CLK_SET_RATE_PARENT, reg,
+			shift, CLK_GATE_SET_TO_DISABLE, &imx_ccm_lock);
+}
+
 static inline struct clk *imx_clk_mux(const char *name, void __iomem *reg,
 		u8 shift, u8 width, const char **parents, int num_parents)
 {
diff --git a/include/dt-bindings/clock/ls1021a-clock.h b/include/dt-bindings/clock/ls1021a-clock.h
new file mode 100644
index 0000000..f259882
--- /dev/null
+++ b/include/dt-bindings/clock/ls1021a-clock.h
@@ -0,0 +1,54 @@
+/*
+ * Copyright 2014 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __DT_BINDINGS_CLOCK_LS1021A_H
+#define __DT_BINDINGS_CLOCK_LS1021A_H
+
+#define LS1021A_CLK_DUMMY	0
+#define LS1021A_CLK_PBL_EN	1
+#define LS1021A_CLK_ESDHC_EN	2
+#define LS1021A_CLK_DMA1_EN	3
+#define LS1021A_CLK_DMA2_EN	4
+#define LS1021A_CLK_USB3_PHY_EN	5
+#define LS1021A_CLK_USB2_EN	6
+#define LS1021A_CLK_SATA_EN	7
+#define LS1021A_CLK_USB3_EN	8
+#define LS1021A_CLK_SEC_EN	9
+#define LS1021A_CLK_2D_ACE_EN	10
+#define LS1021A_CLK_QE_EN	11
+#define LS1021A_CLK_ETSEC1_EN	12
+#define LS1021A_CLK_ETSEC2_EN	13
+#define LS1021A_CLK_ETSEC3_EN	14
+#define LS1021A_CLK_PEX1_EN	15
+#define LS1021A_CLK_PEX2_EN	16
+#define LS1021A_CLK_DUART1_EN	17
+#define LS1021A_CLK_DUART2_EN	18
+#define LS1021A_CLK_QSPI_EN	19
+#define LS1021A_CLK_DDR_EN	20
+#define LS1021A_CLK_OCRAM1_EN	21
+#define LS1021A_CLK_IFC_EN	22
+#define LS1021A_CLK_GPIO_EN	23
+#define LS1021A_CLK_DBG_EN	24
+#define LS1021A_CLK_FLEXCAN1_EN	25
+#define LS1021A_CLK_FLEXCAN234_EN	26
+#define LS1021A_CLK_FLEXTIMER_EN	27
+#define LS1021A_CLK_SECMON_EN	28
+#define LS1021A_CLK_WDOG12_EN	28
+#define LS1021A_CLK_I2C23_EN	30
+#define LS1021A_CLK_SAI_EN	31
+#define LS1021A_CLK_LPUART_EN	32
+#define LS1021A_CLK_DSPI12_EN	33
+#define LS1021A_CLK_ASRC_EN	34
+#define LS1021A_CLK_SPDIF_EN	35
+#define LS1021A_CLK_I2C1_EN	36
+#define LS1021A_CLK_LPUART1_EN	37
+#define LS1021A_CLK_FLEXTIMER1_EN	38
+#define LS1021A_CLK_END		39
+
+#endif /* __DT_BINDINGS_CLOCK_LS1021A_H */
-- 
2.1.0.27.g96db324

