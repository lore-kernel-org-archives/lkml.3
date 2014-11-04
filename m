Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbaKDLRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:17:42 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34560 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbaKDLQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:16:28 -0500
From: Vignesh R <vigneshr@ti.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Vignesh R <vigneshr@ti.com>
Subject: [PATCH v2 2/3] ARM: OMAP2+: hwmod: AM335x/AM43x: add hwmod support for tscadc on am43x-evm
Date: Tue, 4 Nov 2014 16:45:27 +0530
Message-ID: <1415099728-10959-3-git-send-email-vigneshr@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415099728-10959-1-git-send-email-vigneshr@ti.com>
References: <1415099728-10959-1-git-send-email-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds hwmod support for tscadc to work on am43xx-evm. The am33xx
hwmod structures of tscadc has been moved to ipblock_data so that it can
be reused in am43xx. The clock domain names are separately set for am33xx
and am43xx. Thus tscadc dt entries can now be added to am43xx board
dt files.

Signed-off-by: Vignesh R <vigneshr@ti.com>
---
 .../mach-omap2/omap_hwmod_33xx_43xx_common_data.h  |  1 +
 .../mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c | 56 ++++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c         | 49 -------------------
 arch/arm/mach-omap2/omap_hwmod_43xx_data.c         |  1 +
 4 files changed, 58 insertions(+), 49 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h
index 6e57b8ad0db5..b92a7c7825fa 100644
--- a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h
+++ b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h
@@ -65,6 +65,7 @@ extern struct omap_hwmod_ocp_if am33xx_l4_ls__timer4;
 extern struct omap_hwmod_ocp_if am33xx_l4_ls__timer5;
 extern struct omap_hwmod_ocp_if am33xx_l4_ls__timer6;
 extern struct omap_hwmod_ocp_if am33xx_l4_ls__timer7;
+extern struct omap_hwmod_ocp_if am33xx_l4_wkup__adc_tsc;
 extern struct omap_hwmod_ocp_if am33xx_l3_main__tpcc;
 extern struct omap_hwmod_ocp_if am33xx_l3_main__tptc0;
 extern struct omap_hwmod_ocp_if am33xx_l3_main__tptc1;
diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
index 7f44922ab540..ce9c133ea9ff 100644
--- a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
@@ -29,6 +29,7 @@
 #define CLKCTRL(oh, clkctrl) ((oh).prcm.omap4.clkctrl_offs = (clkctrl))
 #define RSTCTRL(oh, rstctrl) ((oh).prcm.omap4.rstctrl_offs = (rstctrl))
 #define RSTST(oh, rstst) ((oh).prcm.omap4.rstst_offs = (rstst))
+#define CLKDMNAME(oh, clkdmname) ((oh).clkdm_name = (clkdmname))
 
 /*
  * 'l3' class
@@ -151,6 +152,45 @@ struct omap_hwmod_class am33xx_wkup_m3_hwmod_class = {
 };
 
 /*
+ * 'adc/tsc' class
+ * TouchScreen Controller (Anolog-To-Digital Converter)
+ */
+static struct omap_hwmod_class_sysconfig am33xx_adc_tsc_sysc = {
+	.rev_offs	= 0x00,
+	.sysc_offs	= 0x10,
+	.sysc_flags	= SYSC_HAS_SIDLEMODE,
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			SIDLE_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class am33xx_adc_tsc_hwmod_class = {
+	.name		= "adc_tsc",
+	.sysc		= &am33xx_adc_tsc_sysc,
+};
+
+struct omap_hwmod am33xx_adc_tsc_hwmod = {
+	.name		= "adc_tsc",
+	.class		= &am33xx_adc_tsc_hwmod_class,
+	.clkdm_name	= "l4_wkup_clkdm",
+	.main_clk	= "adc_tsc_fck",
+	.prcm		= {
+		.omap4  = {
+			.modulemode     = MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* L4 WKUP -> ADC_TSC */
+
+struct omap_hwmod_ocp_if am33xx_l4_wkup__adc_tsc = {
+	.master		= &am33xx_l4_wkup_hwmod,
+	.slave		= &am33xx_adc_tsc_hwmod,
+	.clk		= "dpll_core_m4_div2_ck",
+	.user		= OCP_USER_MPU,
+};
+
+/*
  * 'pru-icss' class
  * Programmable Real-Time Unit and Industrial Communication Subsystem
  */
@@ -1370,6 +1410,7 @@ static void omap_hwmod_am33xx_clkctrl(void)
 	CLKCTRL(am33xx_timer5_hwmod, AM33XX_CM_PER_TIMER5_CLKCTRL_OFFSET);
 	CLKCTRL(am33xx_timer6_hwmod, AM33XX_CM_PER_TIMER6_CLKCTRL_OFFSET);
 	CLKCTRL(am33xx_timer7_hwmod, AM33XX_CM_PER_TIMER7_CLKCTRL_OFFSET);
+	CLKCTRL(am33xx_adc_tsc_hwmod, AM33XX_CM_WKUP_ADC_TSC_CLKCTRL_OFFSET);
 	CLKCTRL(am33xx_smartreflex0_hwmod,
 		AM33XX_CM_WKUP_SMARTREFLEX0_CLKCTRL_OFFSET);
 	CLKCTRL(am33xx_smartreflex1_hwmod,
@@ -1398,6 +1439,18 @@ static void omap_hwmod_am33xx_clkctrl(void)
 	CLKCTRL(am33xx_aes0_hwmod , AM33XX_CM_PER_AES0_CLKCTRL_OFFSET);
 }
 
+static void am33xx_hwmod_clockdomain(void)
+{
+	CLKDMNAME(am33xx_l4_hs_hwmod, "l4hs_clkdm");
+	CLKDMNAME(am33xx_adc_tsc_hwmod, "l4_wkup_clkdm");
+}
+
+static void am43xx_hwmod_clockdomain(void)
+{
+	CLKDMNAME(am33xx_l4_hs_hwmod, "l3_clkdm");
+	CLKDMNAME(am33xx_adc_tsc_hwmod, "l3s_tsc_clkdm");
+}
+
 static void omap_hwmod_am33xx_rst(void)
 {
 	RSTCTRL(am33xx_pruss_hwmod, AM33XX_RM_PER_RSTCTRL_OFFSET);
@@ -1409,6 +1462,7 @@ void omap_hwmod_am33xx_reg(void)
 {
 	omap_hwmod_am33xx_clkctrl();
 	omap_hwmod_am33xx_rst();
+	am33xx_hwmod_clockdomain();
 }
 
 static void omap_hwmod_am43xx_clkctrl(void)
@@ -1443,6 +1497,7 @@ static void omap_hwmod_am43xx_clkctrl(void)
 	CLKCTRL(am33xx_timer5_hwmod, AM43XX_CM_PER_TIMER5_CLKCTRL_OFFSET);
 	CLKCTRL(am33xx_timer6_hwmod, AM43XX_CM_PER_TIMER6_CLKCTRL_OFFSET);
 	CLKCTRL(am33xx_timer7_hwmod, AM43XX_CM_PER_TIMER7_CLKCTRL_OFFSET);
+	CLKCTRL(am33xx_adc_tsc_hwmod, AM43XX_CM_WKUP_ADC_TSC_CLKCTRL_OFFSET);
 	CLKCTRL(am33xx_smartreflex0_hwmod,
 		AM43XX_CM_WKUP_SMARTREFLEX0_CLKCTRL_OFFSET);
 	CLKCTRL(am33xx_smartreflex1_hwmod,
@@ -1482,4 +1537,5 @@ void omap_hwmod_am43xx_reg(void)
 {
 	omap_hwmod_am43xx_clkctrl();
 	omap_hwmod_am43xx_rst();
+	am43xx_hwmod_clockdomain();
 }
diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
index ce7d260495cb..c3ff14828850 100644
--- a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
@@ -88,37 +88,6 @@ static struct omap_hwmod am33xx_wkup_m3_hwmod = {
 };
 
 /*
- * 'adc/tsc' class
- * TouchScreen Controller (Anolog-To-Digital Converter)
- */
-static struct omap_hwmod_class_sysconfig am33xx_adc_tsc_sysc = {
-	.rev_offs	= 0x00,
-	.sysc_offs	= 0x10,
-	.sysc_flags	= SYSC_HAS_SIDLEMODE,
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
-			SIDLE_SMART_WKUP),
-	.sysc_fields	= &omap_hwmod_sysc_type2,
-};
-
-static struct omap_hwmod_class am33xx_adc_tsc_hwmod_class = {
-	.name		= "adc_tsc",
-	.sysc		= &am33xx_adc_tsc_sysc,
-};
-
-static struct omap_hwmod am33xx_adc_tsc_hwmod = {
-	.name		= "adc_tsc",
-	.class		= &am33xx_adc_tsc_hwmod_class,
-	.clkdm_name	= "l4_wkup_clkdm",
-	.main_clk	= "adc_tsc_fck",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_WKUP_ADC_TSC_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
-/*
  * Modules omap_hwmod structures
  *
  * The following IPs are excluded for the moment because:
@@ -426,24 +395,6 @@ static struct omap_hwmod_ocp_if am33xx_l4_wkup__gpio0 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
-/* L4 WKUP -> ADC_TSC */
-static struct omap_hwmod_addr_space am33xx_adc_tsc_addrs[] = {
-	{
-		.pa_start	= 0x44E0D000,
-		.pa_end		= 0x44E0D000 + SZ_8K - 1,
-		.flags		= ADDR_TYPE_RT
-	},
-	{ }
-};
-
-static struct omap_hwmod_ocp_if am33xx_l4_wkup__adc_tsc = {
-	.master		= &am33xx_l4_wkup_hwmod,
-	.slave		= &am33xx_adc_tsc_hwmod,
-	.clk		= "dpll_core_m4_div2_ck",
-	.addr		= am33xx_adc_tsc_addrs,
-	.user		= OCP_USER_MPU,
-};
-
 static struct omap_hwmod_ocp_if am33xx_l4_hs__cpgmac0 = {
 	.master		= &am33xx_l4_hs_hwmod,
 	.slave		= &am33xx_cpgmac0_hwmod,
diff --git a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
index fea01aa3ef42..3ce8d28c0f9a 100644
--- a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
@@ -809,6 +809,7 @@ static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_ifs[] __initdata = {
 	&am33xx_l4_ls__timer5,
 	&am33xx_l4_ls__timer6,
 	&am33xx_l4_ls__timer7,
+	&am33xx_l4_wkup__adc_tsc,
 	&am33xx_l3_main__tpcc,
 	&am33xx_l4_ls__uart2,
 	&am33xx_l4_ls__uart3,
-- 
1.9.1

