Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaGaLWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:22:36 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:58352 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaGaLWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:22:33 -0400
From: Humberto Silva Naves <hsnaves@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <ta.omasab@gmail.com>,
        Andreas Farber <afaerber@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Humberto Silva Naves <hsnaves@gmail.com>
Subject: [PATCHv2 3/5] clk: samsung: exynos5410: Add suspend/resume handling
Date: Thu, 31 Jul 2014 13:22:10 +0200
Message-Id: <1406805732-17372-4-git-send-email-hsnaves@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406805732-17372-1-git-send-email-hsnaves@gmail.com>
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements all the necessary code that handles register
saving and restoring during a suspend/resume cycle. To make this
possible, the local variable reg_base from the function
exynos5410_clk_init was changed to global. In addition, new
clock register definitions were added for the majority of the relevant
clocks inside the SoC.

Signed-off-by: Humberto Silva Naves <hsnaves@gmail.com>
---
 drivers/clk/samsung/clk-exynos5410.c |  231 +++++++++++++++++++++++++++++++++-
 1 file changed, 228 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5410.c b/drivers/clk/samsung/clk-exynos5410.c
index 92c56b7..a9c261c 100644
--- a/drivers/clk/samsung/clk-exynos5410.c
+++ b/drivers/clk/samsung/clk-exynos5410.c
@@ -16,6 +16,7 @@
 #include <linux/clk-provider.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/syscore_ops.h>
 
 #include "clk.h"
 
@@ -24,38 +25,134 @@
 #define MPLL_LOCK		0x4000
 #define MPLL_CON0		0x4100
 #define CPLL_LOCK		0x10020
+#define DPLL_LOCK		0x10030
+#define EPLL_LOCK		0x10040
+#define VPLL_LOCK		0x10050
+#define IPLL_LOCK		0x10060
 #define CPLL_CON0		0x10120
+#define CPLL_CON1		0x10124
+#define DPLL_CON0		0x10128
+#define DPLL_CON1		0x1012C
+#define EPLL_CON0		0x10130
+#define EPLL_CON1		0x10134
+#define EPLL_CON2		0x10138
+#define VPLL_CON0		0x10140
+#define VPLL_CON1		0x10144
+#define VPLL_CON2		0x10148
+#define IPLL_CON0		0x10150
+#define IPLL_CON1		0x10154
 #define BPLL_LOCK		0x20010
 #define BPLL_CON0		0x20110
 #define KPLL_LOCK		0x28000
 #define KPLL_CON0		0x28100
 
 #define SRC_CPU			0x200
+#define SRC_CPERI0		0x4200
 #define SRC_CPERI1		0x4204
 #define SRC_TOP0		0x10210
 #define SRC_TOP1		0x10214
 #define SRC_TOP2		0x10218
+#define SRC_TOP3		0x1021C
+#define SRC_GSCL		0x10220
+#define SRC_DISP0_0		0x10224
+#define SRC_DISP0_1		0x10228
+#define SRC_DISP1_0		0x1022C
+#define SRC_DISP1_1		0x10230
+#define SRC_MAU			0x10240
 #define SRC_FSYS		0x10244
 #define SRC_PERIC0		0x10250
+#define SRC_PERIC1		0x10254
 #define SRC_CDREX		0x20200
 #define SRC_KFC			0x28200
 
+#define SRC_MASK_TOP		0x10310
+#define SRC_MASK_GSCL		0x10320
+#define SRC_MASK_DISP0_0	0x10324
+#define SRC_MASK_DISP0_1	0x10328
+#define SRC_MASK_DISP1_0	0x1032C
+#define SRC_MASK_DISP1_1	0x10330
+#define SRC_MASK_MAU		0x10334
 #define SRC_MASK_FSYS		0x10340
+#define SRC_MASK_GEN		0x10344
 #define SRC_MASK_PERIC0		0x10350
+#define SRC_MASK_PERIC1		0x10354
 
 #define DIV_CPU0		0x500
+#define DIV_CPU1		0x504
+#define DIV_CPERI0		0x4500
+#define DIV_CPERI1		0x4504
+#define DIV_G2D			0x8500
+#define DIV_ISP0		0xC300
+#define DIV_ISP1		0xC304
+#define DIV_ISP2		0xC308
 #define DIV_TOP0		0x10510
 #define DIV_TOP1		0x10514
-#define DIV_FSYS1		0x1054c
+#define DIV_TOP2		0x10518
+#define DIV_TOP3		0x1051C
+#define DIV_GSCL		0x10520
+#define DIV_DISP0_0		0x10524
+#define DIV_DISP0_1		0x10528
+#define DIV_DISP1_0		0x1052C
+#define DIV_DISP1_1		0x10530
+#define DIV_GEN			0x1053C
+#define DIV_MAU			0x10544
+#define DIV_FSYS0		0x10548
+#define DIV_FSYS1		0x1054C
 #define DIV_FSYS2		0x10550
+#define DIV_FSYS3		0x10554
 #define DIV_PERIC0		0x10558
+#define DIV_PERIC1		0x1055C
+#define DIV_PERIC2		0x10560
+#define DIV_PERIC3		0x10564
+#define DIV_PERIC4		0x10568
+#define DIV_PERIC5		0x1056C
+#define DIV2_RATIO0		0x10590
+#define DIV2_RATIO1		0x10594
+#define DIV_CDREX		0x20500
+#define DIV_CDREX2		0x20504
 #define DIV_KFC0		0x28500
 
+#define GATE_BUS_CPU		0x700
+#define GATE_BUS_GSCL0		0x10710
+#define GATE_BUS_GSCL1		0x10720
+#define GATE_BUS_DISP0		0x10724
+#define GATE_BUS_DISP1		0x10728
+#define GATE_BUS_MFC		0x10734
+#define GATE_BUS_G3D		0x10738
+#define GATE_BUS_GEN		0x1073C
 #define GATE_BUS_FSYS0		0x10740
-
+#define GATE_BUS_FSYS1		0x10744
+#define GATE_BUS_CDREX		0x20700
+
+#define GATE_IP_CORE		0x4900
+#define GATE_IP_G2D		0x8800
+#define GATE_IP_ISP0		0xC800
+#define GATE_IP_ISP1		0xC804
+#define GATE_IP_GSCL0		0x10910
+#define GATE_IP_GSCL1		0x10920
+#define GATE_IP_DISP0		0x10924
+#define GATE_IP_DISP1		0x10928
+#define GATE_IP_MFC		0x1092C
+#define GATE_IP_G3D		0x10930
+#define GATE_IP_GEN		0x10934
 #define GATE_IP_FSYS		0x10944
 #define GATE_IP_PERIC		0x10950
 #define GATE_IP_PERIS		0x10960
+#define GATE_IP_CDREX		0x20900
+
+#define GATE_TOP_SCLK_GSCL	0x10820
+#define GATE_TOP_SCLK_DISP0	0x10824
+#define GATE_TOP_SCLK_DISP1	0x10828
+#define GATE_TOP_SCLK_GEN	0x1082C
+#define GATE_TOP_SCLK_MAU	0x1083C
+#define GATE_TOP_SCLK_FSYS	0x10840
+#define GATE_TOP_SCLK_PERIC	0x10850
+
+#define GATE_SCLK_CPU		0x800
+#define SCLK_SRC_ISP		0x10270
+#define SCLK_DIV_ISP		0x10580
+#define SCLK_DIV_ISP1		0x10584
+
 
 /* list of PLLs */
 enum exynos5410_plls {
@@ -64,6 +161,134 @@ enum exynos5410_plls {
 	nr_plls                 /* number of PLLs */
 };
 
+static void __iomem *reg_base;
+
+#ifdef CONFIG_PM_SLEEP
+static struct samsung_clk_reg_dump *exynos5410_save;
+
+/*
+ * list of controller registers to be saved and restored during a
+ * suspend/resume cycle.
+ */
+static unsigned long exynos5410_clk_regs[] __initdata = {
+	SRC_CDREX,
+	SRC_CPERI0,
+	SRC_CPERI1,
+	SRC_CPU,
+	SRC_DISP0_0,
+	SRC_DISP0_1,
+	SRC_DISP1_0,
+	SRC_DISP1_1,
+	SRC_FSYS,
+	SRC_GSCL,
+	SRC_KFC,
+	SRC_MAU,
+	SRC_PERIC0,
+	SRC_PERIC1,
+	SRC_TOP0,
+	SRC_TOP1,
+	SRC_TOP2,
+	SRC_TOP3,
+
+	DIV_CDREX,
+	DIV_CDREX2,
+	DIV_CPU0,
+	DIV_CPERI1,
+	DIV_DISP0_0,
+	DIV_DISP0_1,
+	DIV_DISP1_0,
+	DIV_DISP1_1,
+	DIV_FSYS0,
+	DIV_FSYS1,
+	DIV_FSYS2,
+	DIV_GEN,
+	DIV_GSCL,
+	DIV_G2D,
+	DIV_KFC0,
+	DIV_MAU,
+	DIV_PERIC0,
+	DIV_PERIC1,
+	DIV_PERIC2,
+	DIV_PERIC3,
+	DIV_PERIC4,
+	DIV_PERIC5,
+	DIV_TOP0,
+	DIV_TOP1,
+	DIV_TOP2,
+	DIV_TOP3,
+
+	GATE_BUS_DISP1,
+	GATE_BUS_FSYS0,
+
+	GATE_IP_CDREX,
+	GATE_IP_CORE,
+	GATE_IP_DISP0,
+	GATE_IP_DISP1,
+	GATE_IP_FSYS,
+	GATE_IP_GEN,
+	GATE_IP_GSCL0,
+	GATE_IP_GSCL1,
+	GATE_IP_G2D,
+	GATE_IP_G3D,
+	GATE_IP_MFC,
+	GATE_IP_PERIC,
+	GATE_IP_PERIS,
+
+	GATE_TOP_SCLK_DISP1,
+	GATE_TOP_SCLK_FSYS,
+	GATE_TOP_SCLK_GSCL,
+	GATE_TOP_SCLK_MAU,
+	GATE_TOP_SCLK_PERIC,
+
+	GATE_BUS_DISP1,
+	GATE_BUS_FSYS0,
+
+	GATE_SCLK_CPU,
+
+	SRC_MASK_DISP0_0,
+	SRC_MASK_DISP1_0,
+	SRC_MASK_FSYS,
+	SRC_MASK_MAU,
+	SRC_MASK_PERIC0,
+	SRC_MASK_PERIC1,
+};
+
+static int exynos5410_clk_suspend(void)
+{
+	samsung_clk_save(reg_base, exynos5410_save,
+				ARRAY_SIZE(exynos5410_clk_regs));
+
+	return 0;
+}
+
+static void exynos5410_clk_resume(void)
+{
+	samsung_clk_restore(reg_base, exynos5410_save,
+				ARRAY_SIZE(exynos5410_clk_regs));
+}
+
+static struct syscore_ops exynos5410_clk_syscore_ops = {
+	.suspend = exynos5410_clk_suspend,
+	.resume = exynos5410_clk_resume,
+};
+
+static void exynos5410_clk_sleep_init(void)
+{
+	exynos5410_save = samsung_clk_alloc_reg_dump(exynos5410_clk_regs,
+					ARRAY_SIZE(exynos5410_clk_regs));
+	if (!exynos5410_save) {
+		pr_warn("%s: failed to allocate sleep save data, no sleep support!\n",
+			__func__);
+		return;
+	}
+
+	register_syscore_ops(&exynos5410_clk_syscore_ops);
+}
+#else
+static void exynos5410_clk_sleep_init(void) {}
+#endif
+
+
 /* list of all parent clocks */
 PNAME(apll_p)		= { "fin_pll", "fout_apll", };
 PNAME(bpll_p)		= { "fin_pll", "fout_bpll", };
@@ -190,7 +415,6 @@ static struct samsung_pll_clock exynos5410_plls[nr_plls] __initdata = {
 static void __init exynos5410_clk_init(struct device_node *np)
 {
 	struct samsung_clk_provider *ctx;
-	void __iomem *reg_base;
 
 	if (np) {
 		reg_base = of_iomap(np, 0);
@@ -214,6 +438,7 @@ static void __init exynos5410_clk_init(struct device_node *np)
 	samsung_clk_register_gate(ctx, exynos5410_gate_clks,
 			ARRAY_SIZE(exynos5410_gate_clks));
 
+	exynos5410_clk_sleep_init();
 	samsung_clk_of_add_provider(np, ctx);
 
 	pr_debug("Exynos5410: clock setup completed.\n");
-- 
1.7.10.4

