Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbaEMH7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:59:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54358 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbaEMH7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:59:13 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mugunthan V N <mugunthanvnm@ti.com>
Subject: [PATCH 1/1] arm: dra7xx: Add hwmod data for MDIO and CPSW
Date: Tue, 13 May 2014 13:28:57 +0530
Message-ID: <1399967937-20926-1-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 1.9.2.459.g68773ac
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding hwmod data for CPSW and MDIO which is present in DRA7xx SoC

Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 65 +++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index 810c205..02ea08f 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -273,6 +273,56 @@ static struct omap_hwmod dra7xx_ctrl_module_wkup_hwmod = {
 };
 
 /*
+ * 'gmac' class
+ * cpsw/gmac sub system
+ */
+static struct omap_hwmod_class_sysconfig dra7xx_gmac_sysc = {
+	.rev_offs	= 0x0,
+	.sysc_offs	= 0x8,
+	.syss_offs	= 0x4,
+	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE |
+			   SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | MSTANDBY_FORCE |
+			   MSTANDBY_NO),
+	.sysc_fields	= &omap_hwmod_sysc_type3,
+};
+
+static struct omap_hwmod_class dra7xx_gmac_hwmod_class = {
+	.name		= "gmac",
+	.sysc		= &dra7xx_gmac_sysc,
+};
+
+static struct omap_hwmod dra7xx_gmac_hwmod = {
+	.name		= "gmac",
+	.class		= &dra7xx_gmac_hwmod_class,
+	.clkdm_name	= "gmac_clkdm",
+	.flags		= (HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY),
+	.main_clk	= "dpll_gmac_ck",
+	.mpu_rt_idx	= 1,
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= DRA7XX_CM_GMAC_GMAC_CLKCTRL_OFFSET,
+			.context_offs	= DRA7XX_RM_GMAC_GMAC_CONTEXT_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * 'mdio' class
+ */
+static struct omap_hwmod_class dra7xx_mdio_hwmod_class = {
+	.name		= "davinci_mdio",
+};
+
+static struct omap_hwmod dra7xx_mdio_hwmod = {
+	.name		= "davinci_mdio",
+	.class		= &dra7xx_mdio_hwmod_class,
+	.clkdm_name	= "gmac_clkdm",
+	.main_clk	= "dpll_gmac_ck",
+};
+
+/*
  * 'dcan' class
  *
  */
@@ -1999,6 +2049,19 @@ static struct omap_hwmod_ocp_if dra7xx_l4_wkup__ctrl_module_wkup = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+static struct omap_hwmod_ocp_if dra7xx_l4_per2__cpgmac0 = {
+	.master		= &dra7xx_l4_per2_hwmod,
+	.slave		= &dra7xx_gmac_hwmod,
+	.clk		= "dpll_gmac_ck",
+	.user		= OCP_USER_MPU,
+};
+
+static struct omap_hwmod_ocp_if dra7xx_gmac__mdio = {
+	.master		= &dra7xx_gmac_hwmod,
+	.slave		= &dra7xx_mdio_hwmod,
+	.user		= OCP_USER_MPU,
+};
+
 /* l4_wkup -> dcan1 */
 static struct omap_hwmod_ocp_if dra7xx_l4_wkup__dcan1 = {
 	.master		= &dra7xx_l4_wkup_hwmod,
@@ -2652,6 +2715,8 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
 	&dra7xx_l4_wkup__ctrl_module_wkup,
 	&dra7xx_l4_wkup__dcan1,
 	&dra7xx_l4_per2__dcan2,
+	&dra7xx_l4_per2__cpgmac0,
+	&dra7xx_gmac__mdio,
 	&dra7xx_l4_cfg__dma_system,
 	&dra7xx_l3_main_1__dss,
 	&dra7xx_l3_main_1__dispc,
-- 
1.9.2.459.g68773ac

