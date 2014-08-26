Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803AbaHZEhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:37:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52658 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933745AbaHZEhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:37:47 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <haojian.zhuang@linaro.org>,
        <mturquette@linaro.org>, <chao.xie@marvell.com>,
        <xiechao_mail@163.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/12] clk: mmp: add pxa910 DT support for clock driver
Date: Tue, 26 Aug 2014 12:38:21 +0800
Message-ID: <1409027904-21859-10-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1409027904-21859-1-git-send-email-chao.xie@marvell.com>
References: <1409027904-21859-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-26_02:2014-08-25,2014-08-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408260059
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

It adds the DT support for pxa910 clock subsystem.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 .../bindings/clock/marvell-pxa910-clock.txt        |  20 ++
 drivers/clk/mmp/Makefile                           |   2 +-
 drivers/clk/mmp/clk-of-pxa910.c                    | 260 +++++++++++++++++++++
 include/dt-bindings/clock/marvell-pxa910.h         |  54 +++++
 4 files changed, 335 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/clock/marvell-pxa910-clock.txt
 create mode 100644 drivers/clk/mmp/clk-of-pxa910.c
 create mode 100644 include/dt-bindings/clock/marvell-pxa910.h

diff --git a/Documentation/devicetree/bindings/clock/marvell-pxa910-clock.txt b/Documentation/devicetree/bindings/clock/marvell-pxa910-clock.txt
new file mode 100644
index 0000000..643b57b0
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/marvell-pxa910-clock.txt
@@ -0,0 +1,20 @@
+* Marvell PXA910 Clock Controller
+
+The PXA910 clock subsystem generates and supplies clock to various
+controllers within the PXA910 SoC.
+
+Required Properties:
+
+- compatible: should be one of the following.
+  - "marvell,pxa910-clock" - controller compatible with PXA910 SoC.
+
+- reg: physical base address of the clock subsystem and length of memory mapped
+  region. There are 4 places in SOC has clock control logic:
+  "mpmu", "apmu", "apbc", "apbcp". So four reg spaces need to be defined.
+
+- #clock-cells: should be 1.
+
+Each clock is assigned an identifier and client nodes use this identifier
+to specify the clock which they consume.
+
+All these identifier could be found in <dt-bindings/clock/marvell-pxa910.h>.
diff --git a/drivers/clk/mmp/Makefile b/drivers/clk/mmp/Makefile
index 37c14fa..b803fac 100644
--- a/drivers/clk/mmp/Makefile
+++ b/drivers/clk/mmp/Makefile
@@ -4,7 +4,7 @@
 
 obj-y += clk-apbc.o clk-apmu.o clk-frac.o clk-mix.o clk-gate.o clk.o
 
-obj-$(CONFIG_MACH_MMP_DT) += clk-of-pxa168.o
+obj-$(CONFIG_MACH_MMP_DT) += clk-of-pxa168.o clk-of-pxa910.o
 
 obj-$(CONFIG_CPU_PXA168) += clk-pxa168.o
 obj-$(CONFIG_CPU_PXA910) += clk-pxa910.o
diff --git a/drivers/clk/mmp/clk-of-pxa910.c b/drivers/clk/mmp/clk-of-pxa910.c
new file mode 100644
index 0000000..f746376
--- /dev/null
+++ b/drivers/clk/mmp/clk-of-pxa910.c
@@ -0,0 +1,260 @@
+/*
+ * pxa910 clock framework source file
+ *
+ * Copyright (C) 2012 Marvell
+ * Chao Xie <xiechao.mail@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/of_address.h>
+
+#include <dt-bindings/clock/marvell-pxa910.h>
+
+#include "clk.h"
+
+#define APBC_RTC	0x28
+#define APBC_TWSI0	0x2c
+#define APBC_KPC	0x18
+#define APBC_UART0	0x0
+#define APBC_UART1	0x4
+#define APBC_GPIO	0x8
+#define APBC_PWM0	0xc
+#define APBC_PWM1	0x10
+#define APBC_PWM2	0x14
+#define APBC_PWM3	0x18
+#define APBC_SSP0	0x1c
+#define APBC_SSP1	0x20
+#define APBC_SSP2	0x4c
+#define APBCP_TWSI1	0x28
+#define APBCP_UART2	0x1c
+#define APMU_SDH0	0x54
+#define APMU_SDH1	0x58
+#define APMU_USB	0x5c
+#define APMU_DISP0	0x4c
+#define APMU_CCIC0	0x50
+#define APMU_DFC	0x60
+#define MPMU_UART_PLL	0x14
+
+struct pxa910_clk_unit {
+	struct mmp_clk_unit unit;
+	void __iomem *mpmu_base;
+	void __iomem *apmu_base;
+	void __iomem *apbc_base;
+	void __iomem *apbcp_base;
+};
+
+static struct mmp_param_fixed_rate_clk fixed_rate_clks[] = {
+	{PXA910_CLK_CLK32, "clk32", NULL, CLK_IS_ROOT, 32768},
+	{PXA910_CLK_VCTCXO, "vctcxo", NULL, CLK_IS_ROOT, 26000000},
+	{PXA910_CLK_PLL1, "pll1", NULL, CLK_IS_ROOT, 624000000},
+};
+
+static struct mmp_param_fixed_factor_clk fixed_factor_clks[] = {
+	{PXA910_CLK_PLL1_2, "pll1_2", "pll1", 1, 2, 0},
+	{PXA910_CLK_PLL1_4, "pll1_4", "pll1_2", 1, 2, 0},
+	{PXA910_CLK_PLL1_8, "pll1_8", "pll1_4", 1, 2, 0},
+	{PXA910_CLK_PLL1_16, "pll1_16", "pll1_8", 1, 2, 0},
+	{PXA910_CLK_PLL1_6, "pll1_6", "pll1_2", 1, 3, 0},
+	{PXA910_CLK_PLL1_12, "pll1_12", "pll1_6", 1, 2, 0},
+	{PXA910_CLK_PLL1_24, "pll1_24", "pll1_12", 1, 2, 0},
+	{PXA910_CLK_PLL1_48, "pll1_48", "pll1_24", 1, 2, 0},
+	{PXA910_CLK_PLL1_96, "pll1_96", "pll1_48", 1, 2, 0},
+	{PXA910_CLK_PLL1_13, "pll1_13", "pll1", 1, 13, 0},
+	{PXA910_CLK_PLL1_13_1_5, "pll1_13_1_5", "pll1_13", 2, 3, 0},
+	{PXA910_CLK_PLL1_2_1_5, "pll1_2_1_5", "pll1_2", 2, 3, 0},
+	{PXA910_CLK_PLL1_3_16, "pll1_3_16", "pll1", 3, 16, 0},
+};
+
+static struct mmp_clk_factor_masks uart_factor_masks = {
+	.factor = 2,
+	.num_mask = 0x1fff,
+	.den_mask = 0x1fff,
+	.num_shift = 16,
+	.den_shift = 0,
+};
+
+static struct mmp_clk_factor_tbl uart_factor_tbl[] = {
+	{.num = 8125, .den = 1536},	/*14.745MHZ */
+};
+
+static void pxa910_pll_init(struct pxa910_clk_unit *pxa_unit)
+{
+	struct clk *clk;
+	struct mmp_clk_unit *unit = &pxa_unit->unit;
+
+	mmp_register_fixed_rate_clks(unit, fixed_rate_clks,
+					ARRAY_SIZE(fixed_rate_clks));
+
+	mmp_register_fixed_factor_clks(unit, fixed_factor_clks,
+					ARRAY_SIZE(fixed_factor_clks));
+
+	clk = mmp_clk_register_factor("uart_pll", "pll1_4",
+				CLK_SET_RATE_PARENT,
+				pxa_unit->mpmu_base + MPMU_UART_PLL,
+				&uart_factor_masks, uart_factor_tbl,
+				ARRAY_SIZE(uart_factor_tbl), NULL);
+	mmp_clk_add(unit, PXA910_CLK_UART_PLL, clk);
+}
+
+static DEFINE_SPINLOCK(uart0_lock);
+static DEFINE_SPINLOCK(uart1_lock);
+static DEFINE_SPINLOCK(uart2_lock);
+static const char *uart_parent_names[] = {"pll1_3_16", "uart_pll"};
+
+static DEFINE_SPINLOCK(ssp0_lock);
+static DEFINE_SPINLOCK(ssp1_lock);
+static const char *ssp_parent_names[] = {"pll1_96", "pll1_48", "pll1_24", "pll1_12"};
+
+static struct mmp_param_mux_clk apbc_mux_clks[] = {
+	{0, "uart0_mux", uart_parent_names, ARRAY_SIZE(uart_parent_names), CLK_SET_RATE_PARENT, APBC_UART0, 4, 3, 0, &uart0_lock},
+	{0, "uart1_mux", uart_parent_names, ARRAY_SIZE(uart_parent_names), CLK_SET_RATE_PARENT, APBC_UART1, 4, 3, 0, &uart1_lock},
+	{0, "ssp0_mux", ssp_parent_names, ARRAY_SIZE(ssp_parent_names), CLK_SET_RATE_PARENT, APBC_SSP0, 4, 3, 0, &ssp0_lock},
+	{0, "ssp1_mux", ssp_parent_names, ARRAY_SIZE(ssp_parent_names), CLK_SET_RATE_PARENT, APBC_SSP1, 4, 3, 0, &ssp1_lock},
+};
+
+static struct mmp_param_mux_clk apbcp_mux_clks[] = {
+	{0, "uart2_mux", uart_parent_names, ARRAY_SIZE(uart_parent_names), CLK_SET_RATE_PARENT, APBCP_UART2, 4, 3, 0, &uart2_lock},
+};
+
+static struct mmp_param_gate_clk apbc_gate_clks[] = {
+	{PXA910_CLK_TWSI0, "twsi0_clk", "pll1_13_1_5", CLK_SET_RATE_PARENT, APBC_TWSI0, 0x7, 0x3, 0x0, 0, NULL},
+	{PXA910_CLK_GPIO, "gpio_clk", "vctcxo", CLK_SET_RATE_PARENT, APBC_GPIO, 0x7, 0x3, 0x0, 0, NULL},
+	{PXA910_CLK_KPC, "kpc_clk", "clk32", CLK_SET_RATE_PARENT, APBC_KPC, 0x7, 0x3, 0x0, MMP_CLK_GATE_NEED_DELAY, NULL},
+	{PXA910_CLK_RTC, "rtc_clk", "clk32", CLK_SET_RATE_PARENT, APBC_RTC, 0x87, 0x83, 0x0, MMP_CLK_GATE_NEED_DELAY, NULL},
+	{PXA910_CLK_PWM0, "pwm0_clk", "pll1_48", CLK_SET_RATE_PARENT, APBC_PWM0, 0x7, 0x3, 0x0, 0, NULL},
+	{PXA910_CLK_PWM1, "pwm1_clk", "pll1_48", CLK_SET_RATE_PARENT, APBC_PWM1, 0x7, 0x3, 0x0, 0, NULL},
+	{PXA910_CLK_PWM2, "pwm2_clk", "pll1_48", CLK_SET_RATE_PARENT, APBC_PWM2, 0x7, 0x3, 0x0, 0, NULL},
+	{PXA910_CLK_PWM3, "pwm3_clk", "pll1_48", CLK_SET_RATE_PARENT, APBC_PWM3, 0x7, 0x3, 0x0, 0, NULL},
+	/* The gate clocks has mux parent. */
+	{PXA910_CLK_UART0, "uart0_clk", "uart0_mux", CLK_SET_RATE_PARENT, APBC_UART0, 0x7, 0x3, 0x0, 0, &uart0_lock},
+	{PXA910_CLK_UART1, "uart1_clk", "uart1_mux", CLK_SET_RATE_PARENT, APBC_UART1, 0x7, 0x3, 0x0, 0, &uart1_lock},
+	{PXA910_CLK_SSP0, "ssp0_clk", "ssp0_mux", CLK_SET_RATE_PARENT, APBC_SSP0, 0x7, 0x3, 0x0, 0, &ssp0_lock},
+	{PXA910_CLK_SSP1, "ssp1_clk", "ssp1_mux", CLK_SET_RATE_PARENT, APBC_SSP1, 0x7, 0x3, 0x0, 0, &ssp1_lock},
+};
+
+static struct mmp_param_gate_clk apbcp_gate_clks[] = {
+	{PXA910_CLK_TWSI1, "twsi1_clk", "pll1_13_1_5", CLK_SET_RATE_PARENT, APBCP_TWSI1, 0x7, 0x3, 0x0, 0, NULL},
+	/* The gate clocks has mux parent. */
+	{PXA910_CLK_UART2, "uart2_clk", "uart2_mux", CLK_SET_RATE_PARENT, APBCP_UART2, 0x7, 0x3, 0x0, 0, &uart2_lock},
+};
+
+static void pxa910_apb_periph_clk_init(struct pxa910_clk_unit *pxa_unit)
+{
+	struct mmp_clk_unit *unit = &pxa_unit->unit;
+
+	mmp_register_mux_clks(unit, apbc_mux_clks, pxa_unit->apbc_base,
+				ARRAY_SIZE(apbc_mux_clks));
+
+	mmp_register_mux_clks(unit, apbcp_mux_clks, pxa_unit->apbcp_base,
+				ARRAY_SIZE(apbcp_mux_clks));
+
+	mmp_register_gate_clks(unit, apbc_gate_clks, pxa_unit->apbc_base,
+				ARRAY_SIZE(apbc_gate_clks));
+
+	mmp_register_gate_clks(unit, apbcp_gate_clks, pxa_unit->apbcp_base,
+				ARRAY_SIZE(apbcp_gate_clks));
+}
+
+static DEFINE_SPINLOCK(sdh0_lock);
+static DEFINE_SPINLOCK(sdh1_lock);
+static const char *sdh_parent_names[] = {"pll1_12", "pll1_13"};
+
+static DEFINE_SPINLOCK(usb_lock);
+
+static DEFINE_SPINLOCK(disp0_lock);
+static const char *disp_parent_names[] = {"pll1_2", "pll1_12"};
+
+static DEFINE_SPINLOCK(ccic0_lock);
+static const char *ccic_parent_names[] = {"pll1_2", "pll1_12"};
+static const char *ccic_phy_parent_names[] = {"pll1_6", "pll1_12"};
+
+static struct mmp_param_mux_clk apmu_mux_clks[] = {
+	{0, "sdh0_mux", sdh_parent_names, ARRAY_SIZE(sdh_parent_names), CLK_SET_RATE_PARENT, APMU_SDH0, 6, 1, 0, &sdh0_lock},
+	{0, "sdh1_mux", sdh_parent_names, ARRAY_SIZE(sdh_parent_names), CLK_SET_RATE_PARENT, APMU_SDH1, 6, 1, 0, &sdh1_lock},
+	{0, "disp0_mux", disp_parent_names, ARRAY_SIZE(disp_parent_names), CLK_SET_RATE_PARENT, APMU_DISP0, 6, 1, 0, &disp0_lock},
+	{0, "ccic0_mux", ccic_parent_names, ARRAY_SIZE(ccic_parent_names), CLK_SET_RATE_PARENT, APMU_CCIC0, 6, 1, 0, &ccic0_lock},
+	{0, "ccic0_phy_mux", ccic_phy_parent_names, ARRAY_SIZE(ccic_phy_parent_names), CLK_SET_RATE_PARENT, APMU_CCIC0, 7, 1, 0, &ccic0_lock},
+};
+
+static struct mmp_param_div_clk apmu_div_clks[] = {
+	{0, "ccic0_sphy_div", "ccic0_mux", CLK_SET_RATE_PARENT, APMU_CCIC0, 10, 5, 0, &ccic0_lock},
+};
+
+static struct mmp_param_gate_clk apmu_gate_clks[] = {
+	{PXA910_CLK_DFC, "dfc_clk", "pll1_4", CLK_SET_RATE_PARENT, APMU_DFC, 0x19b, 0x19b, 0x0, 0, NULL},
+	{PXA910_CLK_USB, "usb_clk", "usb_pll", 0, APMU_USB, 0x9, 0x9, 0x0, 0, &usb_lock},
+	{PXA910_CLK_SPH, "sph_clk", "usb_pll", 0, APMU_USB, 0x12, 0x12, 0x0, 0, &usb_lock},
+	/* The gate clocks has mux parent. */
+	{PXA910_CLK_SDH0, "sdh0_clk", "sdh0_mux", CLK_SET_RATE_PARENT, APMU_SDH0, 0x1b, 0x1b, 0x0, 0, &sdh0_lock},
+	{PXA910_CLK_SDH1, "sdh1_clk", "sdh1_mux", CLK_SET_RATE_PARENT, APMU_SDH1, 0x1b, 0x1b, 0x0, 0, &sdh1_lock},
+	{PXA910_CLK_DISP0, "disp0_clk", "disp0_mux", CLK_SET_RATE_PARENT, APMU_DISP0, 0x1b, 0x1b, 0x0, 0, &disp0_lock},
+	{PXA910_CLK_CCIC0, "ccic0_clk", "ccic0_mux", CLK_SET_RATE_PARENT, APMU_CCIC0, 0x1b, 0x1b, 0x0, 0, &ccic0_lock},
+	{PXA910_CLK_CCIC0_PHY, "ccic0_phy_clk", "ccic0_phy_mux", CLK_SET_RATE_PARENT, APMU_CCIC0, 0x24, 0x24, 0x0, 0, &ccic0_lock},
+	{PXA910_CLK_CCIC0_SPHY, "ccic0_sphy_clk", "ccic0_sphy_div", CLK_SET_RATE_PARENT, APMU_CCIC0, 0x300, 0x300, 0x0, 0, &ccic0_lock},
+};
+
+static void pxa910_axi_periph_clk_init(struct pxa910_clk_unit *pxa_unit)
+{
+	struct mmp_clk_unit *unit = &pxa_unit->unit;
+
+	mmp_register_mux_clks(unit, apmu_mux_clks, pxa_unit->apmu_base,
+				ARRAY_SIZE(apmu_mux_clks));
+
+	mmp_register_div_clks(unit, apmu_div_clks, pxa_unit->apmu_base,
+				ARRAY_SIZE(apmu_div_clks));
+
+	mmp_register_gate_clks(unit, apmu_gate_clks, pxa_unit->apmu_base,
+				ARRAY_SIZE(apmu_gate_clks));
+}
+
+static void __init pxa910_clk_init(struct device_node *np)
+{
+	struct pxa910_clk_unit *pxa_unit;
+
+	pxa_unit = kzalloc(sizeof(*pxa_unit), GFP_KERNEL);
+	if (!pxa_unit)
+		return;
+
+	pxa_unit->mpmu_base = of_iomap(np, 0);
+	if (!pxa_unit->mpmu_base) {
+		pr_err("failed to map mpmu registers\n");
+		return;
+	}
+
+	pxa_unit->apmu_base = of_iomap(np, 1);
+	if (!pxa_unit->mpmu_base) {
+		pr_err("failed to map apmu registers\n");
+		return;
+	}
+
+	pxa_unit->apbc_base = of_iomap(np, 2);
+	if (!pxa_unit->apbc_base) {
+		pr_err("failed to map apbc registers\n");
+		return;
+	}
+
+	pxa_unit->apbcp_base = of_iomap(np, 3);
+	if (!pxa_unit->mpmu_base) {
+		pr_err("failed to map apbcp registers\n");
+		return;
+	}
+
+	mmp_clk_init(np, &pxa_unit->unit, PXA910_NR_CLKS);
+
+	pxa910_pll_init(pxa_unit);
+
+	pxa910_apb_periph_clk_init(pxa_unit);
+
+	pxa910_axi_periph_clk_init(pxa_unit);
+}
+
+CLK_OF_DECLARE(pxa910_clk, "marvell,pxa910-clock", pxa910_clk_init);
diff --git a/include/dt-bindings/clock/marvell-pxa910.h b/include/dt-bindings/clock/marvell-pxa910.h
new file mode 100644
index 0000000..719cffb
--- /dev/null
+++ b/include/dt-bindings/clock/marvell-pxa910.h
@@ -0,0 +1,54 @@
+#ifndef __DTS_MARVELL_PXA910_CLOCK_H
+#define __DTS_MARVELL_PXA910_CLOCK_H
+
+/* fixed clocks and plls */
+#define PXA910_CLK_CLK32		1
+#define PXA910_CLK_VCTCXO		2
+#define PXA910_CLK_PLL1			3
+#define PXA910_CLK_PLL1_2		8
+#define PXA910_CLK_PLL1_4		9
+#define PXA910_CLK_PLL1_8		10
+#define PXA910_CLK_PLL1_16		11
+#define PXA910_CLK_PLL1_6		12
+#define PXA910_CLK_PLL1_12		13
+#define PXA910_CLK_PLL1_24		14
+#define PXA910_CLK_PLL1_48		15
+#define PXA910_CLK_PLL1_96		16
+#define PXA910_CLK_PLL1_13		17
+#define PXA910_CLK_PLL1_13_1_5		18
+#define PXA910_CLK_PLL1_2_1_5		19
+#define PXA910_CLK_PLL1_3_16		20
+#define PXA910_CLK_UART_PLL		27
+
+/* apb periphrals */
+#define PXA910_CLK_TWSI0		60
+#define PXA910_CLK_TWSI1		61
+#define PXA910_CLK_TWSI2		62
+#define PXA910_CLK_TWSI3		63
+#define PXA910_CLK_GPIO			64
+#define PXA910_CLK_KPC			65
+#define PXA910_CLK_RTC			66
+#define PXA910_CLK_PWM0			67
+#define PXA910_CLK_PWM1			68
+#define PXA910_CLK_PWM2			69
+#define PXA910_CLK_PWM3			70
+#define PXA910_CLK_UART0		71
+#define PXA910_CLK_UART1		72
+#define PXA910_CLK_UART2		73
+#define PXA910_CLK_SSP0			74
+#define PXA910_CLK_SSP1			75
+
+/* axi periphrals */
+#define PXA910_CLK_DFC			100
+#define PXA910_CLK_SDH0			101
+#define PXA910_CLK_SDH1			102
+#define PXA910_CLK_SDH2			103
+#define PXA910_CLK_USB			104
+#define PXA910_CLK_SPH			105
+#define PXA910_CLK_DISP0		106
+#define PXA910_CLK_CCIC0		107
+#define PXA910_CLK_CCIC0_PHY		108
+#define PXA910_CLK_CCIC0_SPHY		109
+
+#define PXA910_NR_CLKS			200
+#endif
-- 
1.8.3.2

