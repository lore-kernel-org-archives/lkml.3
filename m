Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3ISNXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:23:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58715 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab3ISNWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:22:54 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balajitk@ti.com>, <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 10/15] ARM: omap5: hwmod: Add ocp2scp3 and sata hwmods
Date: Thu, 19 Sep 2013 16:22:27 +0300
Message-ID: <1379596947-15213-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1379595943-14622-1-git-send-email-rogerq@ti.com>
References: <1379595943-14622-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <keshava_mgowda@ti.com>

Create hwmods for ocp2scp3 and sata modules.

[Roger Q] Clean up.

CC: Benoit Cousson <bcousson@baylibre.com>
Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c |   72 ++++++++++++++++++++++++++++
 1 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_54xx_data.c b/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
index 3dae6b9..2b698b8 100644
--- a/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
@@ -1545,6 +1545,76 @@ static struct omap_hwmod omap54xx_wd_timer2_hwmod = {
 	},
 };
 
+/*
+ * 'ocp2scp' class
+ * bridge to transform ocp interface protocol to scp (serial control port)
+ * protocol
+ */
+/* ocp2scp3 */
+static struct omap_hwmod omap54xx_ocp2scp3_hwmod;
+/* l4_cfg -> ocp2scp3 */
+static struct omap_hwmod_ocp_if omap54xx_l4_cfg__ocp2scp3 = {
+	.master		= &omap54xx_l4_cfg_hwmod,
+	.slave		= &omap54xx_ocp2scp3_hwmod,
+	.clk		= "l4_root_clk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod omap54xx_ocp2scp3_hwmod = {
+	.name		= "ocp2scp3",
+	.class		= &omap54xx_ocp2scp_hwmod_class,
+	.clkdm_name	= "l3init_clkdm",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = OMAP54XX_CM_L3INIT_OCP2SCP3_CLKCTRL_OFFSET,
+			.context_offs = OMAP54XX_RM_L3INIT_OCP2SCP3_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+};
+
+/*
+ * 'sata' class
+ * sata:  serial ata interface  gen2 compliant   ( 1 rx/ 1 tx)
+ */
+
+static struct omap_hwmod_class_sysconfig omap54xx_sata_sysc = {
+	.sysc_offs	= 0x0000,
+	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
+			   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class omap54xx_sata_hwmod_class = {
+	.name	= "sata",
+	.sysc	= &omap54xx_sata_sysc,
+};
+
+/* sata */
+static struct omap_hwmod omap54xx_sata_hwmod = {
+	.name		= "sata",
+	.class		= &omap54xx_sata_hwmod_class,
+	.clkdm_name	= "l3init_clkdm",
+	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
+	.main_clk	= "func_48m_fclk",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = OMAP54XX_CM_L3INIT_SATA_CLKCTRL_OFFSET,
+			.context_offs = OMAP54XX_RM_L3INIT_SATA_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* l4_cfg -> sata */
+static struct omap_hwmod_ocp_if omap54xx_l4_cfg__sata = {
+	.master		= &omap54xx_l4_cfg_hwmod,
+	.slave		= &omap54xx_sata_hwmod,
+	.clk		= "l3_iclk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
 
 /*
  * Interfaces
@@ -2192,6 +2262,8 @@ static struct omap_hwmod_ocp_if *omap54xx_hwmod_ocp_ifs[] __initdata = {
 	&omap54xx_l4_per__uart6,
 	&omap54xx_l4_cfg__usb_otg_ss,
 	&omap54xx_l4_wkup__wd_timer2,
+	&omap54xx_l4_cfg__ocp2scp3,
+	&omap54xx_l4_cfg__sata,
 	NULL,
 };
 
-- 
1.7.4.1

