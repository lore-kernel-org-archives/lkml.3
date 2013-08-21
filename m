Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab3HUOdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:33:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50366 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab3HUOcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:32:22 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>, <balbi@ti.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ian.campbell@citrix.com>,
        <linux@arm.linux.org.uk>, <javier.martinez@collabora.co.uk>,
        <devicetree@vger.kernel.org>, <kishon@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v3 4/5] arm: omap5: hwmod: add missing ocp2scp hwmod data
Date: Wed, 21 Aug 2013 20:01:33 +0530
Message-ID: <1377095494-15380-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1377095494-15380-1-git-send-email-kishon@ti.com>
References: <1377095494-15380-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Cousson <bcousson@baylibre.com>

without that hwmod data, USB3 will not in OMAP5 boards.

Signed-off-by: Benoit Cousson <bcousson@baylibre.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c |   45 ++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_54xx_data.c b/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
index 3c70f5c..33ae523 100644
--- a/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
@@ -1114,6 +1114,42 @@ static struct omap_hwmod omap54xx_mpu_hwmod = {
 };
 
 /*
+ * 'ocp2scp' class
+ * bridge to transform ocp interface protocol to scp (serial control port)
+ * protocol
+ */
+
+static struct omap_hwmod_class_sysconfig omap54xx_ocp2scp_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_SIDLEMODE |
+			SYSC_HAS_SOFTRESET | SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class omap54xx_ocp2scp_hwmod_class = {
+	.name	= "ocp2scp",
+	.sysc	= &omap54xx_ocp2scp_sysc,
+};
+
+/* ocp2scp1 */
+static struct omap_hwmod omap54xx_ocp2scp1_hwmod = {
+	.name		= "ocp2scp1",
+	.class		= &omap54xx_ocp2scp_hwmod_class,
+	.clkdm_name	= "l3init_clkdm",
+	.main_clk	= "l4_root_clk_div",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = OMAP54XX_CM_L3INIT_OCP2SCP1_CLKCTRL_OFFSET,
+			.context_offs = OMAP54XX_RM_L3INIT_OCP2SCP1_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+};
+
+/*
  * 'timer' class
  * general purpose timer module with accurate 1ms tick
  * This class contains several variants: ['timer_1ms', 'timer']
@@ -1920,6 +1956,14 @@ static struct omap_hwmod_ocp_if omap54xx_l4_cfg__mpu = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* l4_cfg -> ocp2scp1 */
+static struct omap_hwmod_ocp_if omap54xx_l4_cfg__ocp2scp1 = {
+	.master		= &omap54xx_l4_cfg_hwmod,
+	.slave		= &omap54xx_ocp2scp1_hwmod,
+	.clk		= "l4_root_clk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 /* l4_wkup -> timer1 */
 static struct omap_hwmod_ocp_if omap54xx_l4_wkup__timer1 = {
 	.master		= &omap54xx_l4_wkup_hwmod,
@@ -2122,6 +2166,7 @@ static struct omap_hwmod_ocp_if *omap54xx_hwmod_ocp_ifs[] __initdata = {
 	&omap54xx_l4_per__mmc4,
 	&omap54xx_l4_per__mmc5,
 	&omap54xx_l4_cfg__mpu,
+	&omap54xx_l4_cfg__ocp2scp1,
 	&omap54xx_l4_wkup__timer1,
 	&omap54xx_l4_per__timer2,
 	&omap54xx_l4_per__timer3,
-- 
1.7.10.4

