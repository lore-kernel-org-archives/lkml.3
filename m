Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933839AbaHZEh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:37:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22246 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933750AbaHZEhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:37:50 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <haojian.zhuang@linaro.org>,
        <mturquette@linaro.org>, <chao.xie@marvell.com>,
        <xiechao_mail@163.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/12] clk: mmp: add mmp2 DT support for clock driver
Date: Tue, 26 Aug 2014 12:38:22 +0800
Message-ID: <1409027904-21859-11-git-send-email-chao.xie@marvell.com>
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

It adds the DT support for mmp2 clock subsystem.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 .../bindings/clock/marvell-mmp2-clock.txt          |  20 ++
 drivers/clk/mmp/Makefile                           |   1 +
 drivers/clk/mmp/clk-of-mmp2.c                      | 307 +++++++++++++++++++++
 include/dt-bindings/clock/marvell-mmp2.h           |  74 +++++
 4 files changed, 402 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/marvell-mmp2-clock.txt
 create mode 100644 drivers/clk/mmp/clk-of-mmp2.c
 create mode 100644 include/dt-bindings/clock/marvell-mmp2.h

diff --git a/Documentation/devicetree/bindings/clock/marvell-mmp2-clock.txt b/Documentation/devicetree/bindings/clock/marvell-mmp2-clock.txt
new file mode 100644
index 0000000..ad4b409
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/marvell-mmp2-clock.txt
@@ -0,0 +1,20 @@
+* Marvell MMP2 Clock Controller
+
+The MMP2 clock subsystem generates and supplies clock to various
+controllers within the MMP2 SoC.
+
+Required Properties:
+
+- compatible: should be one of the following.
+  - "marvell,mmp2-clock" - controller compatible with MMP2 SoC.
+
+- reg: physical base address of the clock subsystem and length of memory mapped
+  region. There are 3 places in SOC has clock control logic:
+  "mpmu", "apmu", "apbc". So three reg spaces need to be defined.
+
+- #clock-cells: should be 1.
+
+Each clock is assigned an identifier and client nodes use this identifier
+to specify the clock which they consume.
+
+All these identifier could be found in <dt-bindings/clock/marvell-mmp2.h>.
diff --git a/drivers/clk/mmp/Makefile b/drivers/clk/mmp/Makefile
index b803fac..25a2bf1 100644
--- a/drivers/clk/mmp/Makefile
+++ b/drivers/clk/mmp/Makefile
@@ -5,6 +5,7 @@
 obj-y += clk-apbc.o clk-apmu.o clk-frac.o clk-mix.o clk-gate.o clk.o
 
 obj-$(CONFIG_MACH_MMP_DT) += clk-of-pxa168.o clk-of-pxa910.o
+obj-$(CONFIG_MACH_MMP2_DT) += clk-of-mmp2.o
 
 obj-$(CONFIG_CPU_PXA168) += clk-pxa168.o
 obj-$(CONFIG_CPU_PXA910) += clk-pxa910.o
diff --git a/drivers/clk/mmp/clk-of-mmp2.c b/drivers/clk/mmp/clk-of-mmp2.c
new file mode 100644
index 0000000..3a3e9c2
--- /dev/null
+++ b/drivers/clk/mmp/clk-of-mmp2.c
@@ -0,0 +1,307 @@
+/*
+ * mmp2 clock framework source file
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
+#include <dt-bindings/clock/marvell-mmp2.h>
+
+#include "clk.h"
+
+#define APBC_RTC	0x0
+#define APBC_TWSI0	0x4
+#define APBC_TWSI1	0x8
+#define APBC_TWSI2	0xc
+#define APBC_TWSI3	0x10
+#define APBC_TWSI4	0x7c
+#define APBC_TWSI5	0x80
+#define APBC_KPC	0x18
+#define APBC_UART0	0x2c
+#define APBC_UART1	0x30
+#define APBC_UART2	0x34
+#define APBC_UART3	0x88
+#define APBC_GPIO	0x38
+#define APBC_PWM0	0x3c
+#define APBC_PWM1	0x40
+#define APBC_PWM2	0x44
+#define APBC_PWM3	0x48
+#define APBC_SSP0	0x50
+#define APBC_SSP1	0x54
+#define APBC_SSP2	0x58
+#define APBC_SSP3	0x5c
+#define APMU_SDH0	0x54
+#define APMU_SDH1	0x58
+#define APMU_SDH2	0xe8
+#define APMU_SDH3	0xec
+#define APMU_USB	0x5c
+#define APMU_DISP0	0x4c
+#define APMU_DISP1	0x110
+#define APMU_CCIC0	0x50
+#define APMU_CCIC1	0xf4
+#define MPMU_UART_PLL	0x14
+
+struct mmp2_clk_unit {
+	struct mmp_clk_unit unit;
+	void __iomem *mpmu_base;
+	void __iomem *apmu_base;
+	void __iomem *apbc_base;
+};
+
+static struct mmp_param_fixed_rate_clk fixed_rate_clks[] = {
+	{MMP2_CLK_CLK32, "clk32", NULL, CLK_IS_ROOT, 32768},
+	{MMP2_CLK_VCTCXO, "vctcxo", NULL, CLK_IS_ROOT, 26000000},
+	{MMP2_CLK_PLL1, "pll1", NULL, CLK_IS_ROOT, 800000000},
+	{MMP2_CLK_PLL2, "pll2", NULL, CLK_IS_ROOT, 960000000},
+	{MMP2_CLK_USB_PLL, "usb_pll", NULL, CLK_IS_ROOT, 480000000},
+};
+
+static struct mmp_param_fixed_factor_clk fixed_factor_clks[] = {
+	{MMP2_CLK_PLL1_2, "pll1_2", "pll1", 1, 2, 0},
+	{MMP2_CLK_PLL1_4, "pll1_4", "pll1_2", 1, 2, 0},
+	{MMP2_CLK_PLL1_8, "pll1_8", "pll1_4", 1, 2, 0},
+	{MMP2_CLK_PLL1_16, "pll1_16", "pll1_8", 1, 2, 0},
+	{MMP2_CLK_PLL1_20, "pll1_20", "pll1_4", 1, 5, 0},
+	{MMP2_CLK_PLL1_3, "pll1_3", "pll1", 1, 3, 0},
+	{MMP2_CLK_PLL1_6, "pll1_6", "pll1_3", 1, 2, 0},
+	{MMP2_CLK_PLL1_12, "pll1_12", "pll1_6", 1, 2, 0},
+	{MMP2_CLK_PLL2_2, "pll2_2", "pll2", 1, 2, 0},
+	{MMP2_CLK_PLL2_4, "pll2_4", "pll2_2", 1, 2, 0},
+	{MMP2_CLK_PLL2_8, "pll2_8", "pll2_4", 1, 2, 0},
+	{MMP2_CLK_PLL2_16, "pll2_16", "pll2_8", 1, 2, 0},
+	{MMP2_CLK_PLL2_3, "pll2_3", "pll2", 1, 3, 0},
+	{MMP2_CLK_PLL2_6, "pll2_6", "pll2_3", 1, 2, 0},
+	{MMP2_CLK_PLL2_12, "pll2_12", "pll2_6", 1, 2, 0},
+	{MMP2_CLK_VCTCXO_2, "vctcxo_2", "vctcxo", 1, 2, 0},
+	{MMP2_CLK_VCTCXO_4, "vctcxo_4", "vctcxo_2", 1, 2, 0},
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
+	{.num = 14634, .den = 2165},	/*14.745MHZ */
+	{.num = 3521, .den = 689},	/*19.23MHZ */
+	{.num = 9679, .den = 5728},	/*58.9824MHZ */
+	{.num = 15850, .den = 9451},	/*59.429MHZ */
+};
+
+static void mmp2_pll_init(struct mmp2_clk_unit *pxa_unit)
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
+	mmp_clk_add(unit, MMP2_CLK_UART_PLL, clk);
+}
+
+static DEFINE_SPINLOCK(uart0_lock);
+static DEFINE_SPINLOCK(uart1_lock);
+static DEFINE_SPINLOCK(uart2_lock);
+static const char *uart_parent_names[] = {"uart_pll", "vctcxo"};
+
+static DEFINE_SPINLOCK(ssp0_lock);
+static DEFINE_SPINLOCK(ssp1_lock);
+static DEFINE_SPINLOCK(ssp2_lock);
+static DEFINE_SPINLOCK(ssp3_lock);
+static const char *ssp_parent_names[] = {"vctcxo_4", "vctcxo_2", "vctcxo", "pll1_16"};
+
+static struct mmp_param_mux_clk apbc_mux_clks[] = {
+	{0, "uart0_mux", uart_parent_names, ARRAY_SIZE(uart_parent_names), CLK_SET_RATE_PARENT, APBC_UART0, 4, 3, 0, &uart0_lock},
+	{0, "uart1_mux", uart_parent_names, ARRAY_SIZE(uart_parent_names), CLK_SET_RATE_PARENT, APBC_UART1, 4, 3, 0, &uart1_lock},
+	{0, "uart2_mux", uart_parent_names, ARRAY_SIZE(uart_parent_names), CLK_SET_RATE_PARENT, APBC_UART2, 4, 3, 0, &uart2_lock},
+	{0, "uart3_mux", uart_parent_names, ARRAY_SIZE(uart_parent_names), CLK_SET_RATE_PARENT, APBC_UART3, 4, 3, 0, &uart2_lock},
+	{0, "ssp0_mux", ssp_parent_names, ARRAY_SIZE(ssp_parent_names), CLK_SET_RATE_PARENT, APBC_SSP0, 4, 3, 0, &ssp0_lock},
+	{0, "ssp1_mux", ssp_parent_names, ARRAY_SIZE(ssp_parent_names), CLK_SET_RATE_PARENT, APBC_SSP1, 4, 3, 0, &ssp1_lock},
+	{0, "ssp2_mux", ssp_parent_names, ARRAY_SIZE(ssp_parent_names), CLK_SET_RATE_PARENT, APBC_SSP2, 4, 3, 0, &ssp2_lock},
+	{0, "ssp3_mux", ssp_parent_names, ARRAY_SIZE(ssp_parent_names), CLK_SET_RATE_PARENT, APBC_SSP3, 4, 3, 0, &ssp3_lock},
+};
+
+static struct mmp_param_gate_clk apbc_gate_clks[] = {
+	{MMP2_CLK_TWSI0, "twsi0_clk", "vctcxo", CLK_SET_RATE_PARENT, APBC_TWSI0, 0x7, 0x3, 0x0, 0, NULL},
+	{MMP2_CLK_TWSI1, "twsi1_clk", "vctcxo", CLK_SET_RATE_PARENT, APBC_TWSI1, 0x7, 0x3, 0x0, 0, NULL},
+	{MMP2_CLK_TWSI2, "twsi2_clk", "vctcxo", CLK_SET_RATE_PARENT, APBC_TWSI2, 0x7, 0x3, 0x0, 0, NULL},
+	{MMP2_CLK_TWSI3, "twsi3_clk", "vctcxo", CLK_SET_RATE_PARENT, APBC_TWSI3, 0x7, 0x3, 0x0, 0, NULL},
+	{MMP2_CLK_TWSI4, "twsi4_clk", "vctcxo", CLK_SET_RATE_PARENT, APBC_TWSI4, 0x7, 0x3, 0x0, 0, NULL},
+	{MMP2_CLK_TWSI5, "twsi5_clk", "vctcxo", CLK_SET_RATE_PARENT, APBC_TWSI5, 0x7, 0x3, 0x0, 0, NULL},
+	{MMP2_CLK_GPIO, "gpio_clk", "vctcxo", CLK_SET_RATE_PARENT, APBC_GPIO, 0x7, 0x3, 0x0, 0, NULL},
+	{MMP2_CLK_KPC, "kpc_clk", "clk32", CLK_SET_RATE_PARENT, APBC_KPC, 0x7, 0x3, 0x0, MMP_CLK_GATE_NEED_DELAY, NULL},
+	{MMP2_CLK_RTC, "rtc_clk", "clk32", CLK_SET_RATE_PARENT, APBC_RTC, 0x87, 0x83, 0x0, MMP_CLK_GATE_NEED_DELAY, NULL},
+	{MMP2_CLK_PWM0, "pwm0_clk", "pll1_48", CLK_SET_RATE_PARENT, APBC_PWM0, 0x7, 0x3, 0x0, 0, NULL},
+	{MMP2_CLK_PWM1, "pwm1_clk", "pll1_48", CLK_SET_RATE_PARENT, APBC_PWM1, 0x7, 0x3, 0x0, 0, NULL},
+	{MMP2_CLK_PWM2, "pwm2_clk", "pll1_48", CLK_SET_RATE_PARENT, APBC_PWM2, 0x7, 0x3, 0x0, 0, NULL},
+	{MMP2_CLK_PWM3, "pwm3_clk", "pll1_48", CLK_SET_RATE_PARENT, APBC_PWM3, 0x7, 0x3, 0x0, 0, NULL},
+	/* The gate clocks has mux parent. */
+	{MMP2_CLK_UART0, "uart0_clk", "uart0_mux", CLK_SET_RATE_PARENT, APBC_UART0, 0x7, 0x3, 0x0, 0, &uart0_lock},
+	{MMP2_CLK_UART1, "uart1_clk", "uart1_mux", CLK_SET_RATE_PARENT, APBC_UART1, 0x7, 0x3, 0x0, 0, &uart1_lock},
+	{MMP2_CLK_UART2, "uart2_clk", "uart2_mux", CLK_SET_RATE_PARENT, APBC_UART2, 0x7, 0x3, 0x0, 0, &uart2_lock},
+	{MMP2_CLK_UART3, "uart3_clk", "uart3_mux", CLK_SET_RATE_PARENT, APBC_UART3, 0x7, 0x3, 0x0, 0, &uart2_lock},
+	{MMP2_CLK_SSP0, "ssp0_clk", "ssp0_mux", CLK_SET_RATE_PARENT, APBC_SSP0, 0x7, 0x3, 0x0, 0, &ssp0_lock},
+	{MMP2_CLK_SSP1, "ssp1_clk", "ssp1_mux", CLK_SET_RATE_PARENT, APBC_SSP1, 0x7, 0x3, 0x0, 0, &ssp1_lock},
+	{MMP2_CLK_SSP2, "ssp2_clk", "ssp2_mux", CLK_SET_RATE_PARENT, APBC_SSP2, 0x7, 0x3, 0x0, 0, &ssp2_lock},
+	{MMP2_CLK_SSP3, "ssp3_clk", "ssp3_mux", CLK_SET_RATE_PARENT, APBC_SSP3, 0x7, 0x3, 0x0, 0, &ssp3_lock},
+};
+
+static void mmp2_apb_periph_clk_init(struct mmp2_clk_unit *pxa_unit)
+{
+	struct mmp_clk_unit *unit = &pxa_unit->unit;
+
+	mmp_register_mux_clks(unit, apbc_mux_clks, pxa_unit->apbc_base,
+				ARRAY_SIZE(apbc_mux_clks));
+
+	mmp_register_gate_clks(unit, apbc_gate_clks, pxa_unit->apbc_base,
+				ARRAY_SIZE(apbc_gate_clks));
+}
+
+static DEFINE_SPINLOCK(sdh_lock);
+static const char *sdh_parent_names[] = {"pll1_4", "pll2", "usb_pll", "pll1"};
+static struct mmp_clk_mix_config sdh_mix_config = {
+	.reg_info = DEFINE_MIX_REG_INFO(4, 10, 2, 8, 32),
+};
+
+static DEFINE_SPINLOCK(usb_lock);
+
+static DEFINE_SPINLOCK(disp0_lock);
+static DEFINE_SPINLOCK(disp1_lock);
+static const char *disp_parent_names[] = {"pll1", "pll1_16", "pll2", "vctcxo"};
+
+static DEFINE_SPINLOCK(ccic0_lock);
+static DEFINE_SPINLOCK(ccic1_lock);
+static const char *ccic_parent_names[] = {"pll1_2", "pll1_16", "vctcxo"};
+static struct mmp_clk_mix_config ccic0_mix_config = {
+	.reg_info = DEFINE_MIX_REG_INFO(4, 17, 2, 6, 32),
+};
+static struct mmp_clk_mix_config ccic1_mix_config = {
+	.reg_info = DEFINE_MIX_REG_INFO(4, 16, 2, 6, 32),
+};
+
+static struct mmp_param_mux_clk apmu_mux_clks[] = {
+	{MMP2_CLK_DISP0_MUX, "disp0_mux", disp_parent_names, ARRAY_SIZE(disp_parent_names), CLK_SET_RATE_PARENT, APMU_DISP0, 6, 2, 0, &disp0_lock},
+	{MMP2_CLK_DISP1_MUX, "disp1_mux", disp_parent_names, ARRAY_SIZE(disp_parent_names), CLK_SET_RATE_PARENT, APMU_DISP1, 6, 2, 0, &disp1_lock},
+};
+
+static struct mmp_param_div_clk apmu_div_clks[] = {
+	{0, "disp0_div", "disp0_mux", CLK_SET_RATE_PARENT, APMU_DISP0, 8, 4, 0, &disp0_lock},
+	{0, "disp0_sphy_div", "disp0_mux", CLK_SET_RATE_PARENT, APMU_DISP0, 15, 5, 0, &disp0_lock},
+	{0, "disp1_div", "disp1_mux", CLK_SET_RATE_PARENT, APMU_DISP1, 8, 4, 0, &disp1_lock},
+	{0, "ccic0_sphy_div", "ccic0_mix_clk", CLK_SET_RATE_PARENT, APMU_CCIC0, 10, 5, 0, &ccic0_lock},
+	{0, "ccic1_sphy_div", "ccic1_mix_clk", CLK_SET_RATE_PARENT, APMU_CCIC1, 10, 5, 0, &ccic1_lock},
+};
+
+static struct mmp_param_gate_clk apmu_gate_clks[] = {
+	{MMP2_CLK_USB, "usb_clk", "usb_pll", 0, APMU_USB, 0x9, 0x9, 0x0, 0, &usb_lock},
+	/* The gate clocks has mux parent. */
+	{MMP2_CLK_SDH0, "sdh0_clk", "sdh_mix_clk", CLK_SET_RATE_PARENT, APMU_SDH0, 0x1b, 0x1b, 0x0, 0, &sdh_lock},
+	{MMP2_CLK_SDH1, "sdh1_clk", "sdh_mix_clk", CLK_SET_RATE_PARENT, APMU_SDH1, 0x1b, 0x1b, 0x0, 0, &sdh_lock},
+	{MMP2_CLK_SDH1, "sdh2_clk", "sdh_mix_clk", CLK_SET_RATE_PARENT, APMU_SDH2, 0x1b, 0x1b, 0x0, 0, &sdh_lock},
+	{MMP2_CLK_SDH1, "sdh3_clk", "sdh_mix_clk", CLK_SET_RATE_PARENT, APMU_SDH3, 0x1b, 0x1b, 0x0, 0, &sdh_lock},
+	{MMP2_CLK_DISP0, "disp0_clk", "disp0_div", CLK_SET_RATE_PARENT, APMU_DISP0, 0x1b, 0x1b, 0x0, 0, &disp0_lock},
+	{MMP2_CLK_DISP0_SPHY, "disp0_sphy_clk", "disp0_sphy_div", CLK_SET_RATE_PARENT, APMU_DISP0, 0x1024, 0x1024, 0x0, 0, &disp0_lock},
+	{MMP2_CLK_DISP1, "disp1_clk", "disp1_div", CLK_SET_RATE_PARENT, APMU_DISP1, 0x1b, 0x1b, 0x0, 0, &disp1_lock},
+	{MMP2_CLK_CCIC_ARBITER, "ccic_arbiter", "vctcxo", CLK_SET_RATE_PARENT, APMU_CCIC0, 0x1800, 0x1800, 0x0, 0, &ccic0_lock},
+	{MMP2_CLK_CCIC0, "ccic0_clk", "ccic0_mix_clk", CLK_SET_RATE_PARENT, APMU_CCIC0, 0x1b, 0x1b, 0x0, 0, &ccic0_lock},
+	{MMP2_CLK_CCIC0_PHY, "ccic0_phy_clk", "ccic0_mix_clk", CLK_SET_RATE_PARENT, APMU_CCIC0, 0x24, 0x24, 0x0, 0, &ccic0_lock},
+	{MMP2_CLK_CCIC0_SPHY, "ccic0_sphy_clk", "ccic0_sphy_div", CLK_SET_RATE_PARENT, APMU_CCIC0, 0x300, 0x300, 0x0, 0, &ccic0_lock},
+	{MMP2_CLK_CCIC1, "ccic1_clk", "ccic1_mix_clk", CLK_SET_RATE_PARENT, APMU_CCIC1, 0x1b, 0x1b, 0x0, 0, &ccic1_lock},
+	{MMP2_CLK_CCIC1_PHY, "ccic1_phy_clk", "ccic1_mix_clk", CLK_SET_RATE_PARENT, APMU_CCIC1, 0x24, 0x24, 0x0, 0, &ccic1_lock},
+	{MMP2_CLK_CCIC1_SPHY, "ccic1_sphy_clk", "ccic1_sphy_div", CLK_SET_RATE_PARENT, APMU_CCIC1, 0x300, 0x300, 0x0, 0, &ccic1_lock},
+};
+
+static void mmp2_axi_periph_clk_init(struct mmp2_clk_unit *pxa_unit)
+{
+	struct clk *clk;
+	struct mmp_clk_unit *unit = &pxa_unit->unit;
+
+	sdh_mix_config.reg_info.reg_clk_ctrl = pxa_unit->apmu_base + APMU_SDH0;
+	clk = mmp_clk_register_mix(NULL, "sdh_mix_clk", sdh_parent_names,
+					ARRAY_SIZE(sdh_parent_names),
+					CLK_SET_RATE_PARENT,
+					&sdh_mix_config, &sdh_lock);
+
+	ccic0_mix_config.reg_info.reg_clk_ctrl = pxa_unit->apmu_base + APMU_CCIC0;
+	clk = mmp_clk_register_mix(NULL, "ccic0_mix_clk", ccic_parent_names,
+					ARRAY_SIZE(ccic_parent_names),
+					CLK_SET_RATE_PARENT,
+					&ccic0_mix_config, &ccic0_lock);
+	mmp_clk_add(unit, MMP2_CLK_CCIC0_MIX, clk);
+
+	ccic1_mix_config.reg_info.reg_clk_ctrl = pxa_unit->apmu_base + APMU_CCIC1;
+	clk = mmp_clk_register_mix(NULL, "ccic1_mix_clk", ccic_parent_names,
+					ARRAY_SIZE(ccic_parent_names),
+					CLK_SET_RATE_PARENT,
+					&ccic1_mix_config, &ccic1_lock);
+	mmp_clk_add(unit, MMP2_CLK_CCIC1_MIX, clk);
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
+static void __init mmp2_clk_init(struct device_node *np)
+{
+	struct mmp2_clk_unit *pxa_unit;
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
+	mmp_clk_init(np, &pxa_unit->unit, MMP2_NR_CLKS);
+
+	mmp2_pll_init(pxa_unit);
+
+	mmp2_apb_periph_clk_init(pxa_unit);
+
+	mmp2_axi_periph_clk_init(pxa_unit);
+}
+
+CLK_OF_DECLARE(mmp2_clk, "marvell,mmp2-clock", mmp2_clk_init);
diff --git a/include/dt-bindings/clock/marvell-mmp2.h b/include/dt-bindings/clock/marvell-mmp2.h
new file mode 100644
index 0000000..591f7fb
--- /dev/null
+++ b/include/dt-bindings/clock/marvell-mmp2.h
@@ -0,0 +1,74 @@
+#ifndef __DTS_MARVELL_MMP2_CLOCK_H
+#define __DTS_MARVELL_MMP2_CLOCK_H
+
+/* fixed clocks and plls */
+#define MMP2_CLK_CLK32			1
+#define MMP2_CLK_VCTCXO			2
+#define MMP2_CLK_PLL1			3
+#define MMP2_CLK_PLL1_2			8
+#define MMP2_CLK_PLL1_4			9
+#define MMP2_CLK_PLL1_8			10
+#define MMP2_CLK_PLL1_16		11
+#define MMP2_CLK_PLL1_3			12
+#define MMP2_CLK_PLL1_6			13
+#define MMP2_CLK_PLL1_12		14
+#define MMP2_CLK_PLL1_20		15
+#define MMP2_CLK_PLL2			16
+#define MMP2_CLK_PLL2_2			17
+#define MMP2_CLK_PLL2_4			18
+#define MMP2_CLK_PLL2_8			19
+#define MMP2_CLK_PLL2_16		20
+#define MMP2_CLK_PLL2_3			21
+#define MMP2_CLK_PLL2_6			22
+#define MMP2_CLK_PLL2_12		23
+#define MMP2_CLK_VCTCXO_2		24
+#define MMP2_CLK_VCTCXO_4		25
+#define MMP2_CLK_UART_PLL		26
+#define MMP2_CLK_USB_PLL		27
+
+/* apb periphrals */
+#define MMP2_CLK_TWSI0			60
+#define MMP2_CLK_TWSI1			61
+#define MMP2_CLK_TWSI2			62
+#define MMP2_CLK_TWSI3			63
+#define MMP2_CLK_TWSI4			64
+#define MMP2_CLK_TWSI5			65
+#define MMP2_CLK_GPIO			66
+#define MMP2_CLK_KPC			67
+#define MMP2_CLK_RTC			68
+#define MMP2_CLK_PWM0			69
+#define MMP2_CLK_PWM1			70
+#define MMP2_CLK_PWM2			71
+#define MMP2_CLK_PWM3			72
+#define MMP2_CLK_UART0			73
+#define MMP2_CLK_UART1			74
+#define MMP2_CLK_UART2			75
+#define MMP2_CLK_UART3			76
+#define MMP2_CLK_SSP0			77
+#define MMP2_CLK_SSP1			78
+#define MMP2_CLK_SSP2			79
+#define MMP2_CLK_SSP3			80
+
+/* axi periphrals */
+#define MMP2_CLK_SDH0			101
+#define MMP2_CLK_SDH1			102
+#define MMP2_CLK_SDH2			103
+#define MMP2_CLK_SDH3			104
+#define MMP2_CLK_USB			105
+#define MMP2_CLK_DISP0			106
+#define MMP2_CLK_DISP0_MUX		107
+#define MMP2_CLK_DISP0_SPHY		108
+#define MMP2_CLK_DISP1			109
+#define MMP2_CLK_DISP1_MUX		110
+#define MMP2_CLK_CCIC_ARBITER		111
+#define MMP2_CLK_CCIC0			112
+#define MMP2_CLK_CCIC0_MIX		113
+#define MMP2_CLK_CCIC0_PHY		114
+#define MMP2_CLK_CCIC0_SPHY		115
+#define MMP2_CLK_CCIC1			116
+#define MMP2_CLK_CCIC1_MIX		117
+#define MMP2_CLK_CCIC1_PHY		118
+#define MMP2_CLK_CCIC1_SPHY		119
+
+#define MMP2_NR_CLKS			200
+#endif
-- 
1.8.3.2

