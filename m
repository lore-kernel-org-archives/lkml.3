Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaDYXHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 19:07:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40144 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbaDYXDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 19:03:20 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 05/10] ARM: OMAP4: hwmod: Add hwmod data for AES IP
Date: Fri, 25 Apr 2014 18:02:43 -0500
Message-ID: <1398466968-29506-6-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398466968-29506-1-git-send-email-joelf@ti.com>
References: <1398466968-29506-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Crypto modules AES0/1 belong to:
    PD_L4_PER power domain
    CD_L4_SEC clock domain
    On the L3, the AES modules are mapped to
    L3_CLK2: Peripherals and multimedia sub clock domain

We add hwmod data for the same.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   43 ++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 1219280..3b12244 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -4782,6 +4782,48 @@ static struct omap_hwmod_ocp_if omap44xx_mpu__emif2 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/*
+    Crypto modules AES0/1 belong to:
+	PD_L4_PER power domain
+	CD_L4_SEC clock domain
+	On the L3, the AES modules are mapped to
+	L3_CLK2: Peripherals and multimedia sub clock domain
+*/
+
+static struct omap_hwmod_class_sysconfig omap4_aes1_sysc = {
+	.rev_offs	= 0x80,
+	.sysc_offs	= 0x84,
+	.syss_offs	= 0x88,
+	.sysc_flags	= SYSS_HAS_RESET_STATUS,
+	.sysc_fields	= &omap_hwmod_sysc_type4,
+};
+
+static struct omap_hwmod_class omap4_aes1_hwmod_class = {
+	.name		= "aes1",
+	.sysc		= &omap4_aes1_sysc,
+};
+
+static struct omap_hwmod omap4_aes1_hwmod = {
+	.name		= "aes",
+	.class		= &omap4_aes1_hwmod_class,
+	.clkdm_name	= "l4_secure_clkdm",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs = OMAP4_CM_L4SEC_AES1_CLKCTRL_OFFSET,
+			.context_offs = OMAP4_RM_L4SEC_AES1_CONTEXT_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* l3_main_2 -> aes1 */
+static struct omap_hwmod_ocp_if omap4_l3_main_2__aes1 = {
+	.master		= &omap44xx_l3_main_2_hwmod,
+	.slave		= &omap4_aes1_hwmod,
+	.clk		= "aes1_fck",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 static struct omap_hwmod_ocp_if *omap44xx_hwmod_ocp_ifs[] __initdata = {
 	&omap44xx_l3_main_1__dmm,
 	&omap44xx_mpu__dmm,
@@ -4936,6 +4978,7 @@ static struct omap_hwmod_ocp_if *omap44xx_hwmod_ocp_ifs[] __initdata = {
 	&omap44xx_l4_abe__wd_timer3_dma,
 	&omap44xx_mpu__emif1,
 	&omap44xx_mpu__emif2,
+	&omap4_l3_main_2__aes1,
 	NULL,
 };
 
-- 
1.7.9.5

