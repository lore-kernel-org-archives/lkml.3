Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaFMQRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:17:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39579 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbaFMQQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:16:37 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Benoit Cousson <bcousson@baylibre.org>, Paul Walmsley <paul@pwsan.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sathya Prakash M R <sathyap@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [RESEND PATCH 1/2] ARM: AM43xx: hwmod: add DSS hwmod data
Date: Fri, 13 Jun 2014 11:15:46 -0500
Message-ID: <1402676147-3711-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.0.rc1
In-Reply-To: <1402676147-3711-1-git-send-email-balbi@ti.com>
References: <1402676147-3711-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sathya Prakash M R <sathyap@ti.com>

Add DSS hwmod data for AM43xx.

Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Sathya Prakash M R <sathyap@ti.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---

Note that this patch was originally send on May 9th [1], changes were requested
and a new version was sent on May 19th [2], then on May 27th [3] Tomi pinged
maintainer again and go no response.

Without this patch, we cannot get display working on any AM437x devices.

[1] http://marc.info/?l=linux-arm-kernel&m=139963677925227&w=2
[2] http://marc.info/?l=linux-arm-kernel&m=140049799425512&w=2
[3] http://marc.info/?l=linux-arm-kernel&m=140117232826754&w=2

 arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 98 ++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/prcm43xx.h             |  1 +
 2 files changed, 99 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
index 5c2cc80..d2a7b6d 100644
--- a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
@@ -19,6 +19,8 @@
 #include "omap_hwmod.h"
 #include "omap_hwmod_33xx_43xx_common_data.h"
 #include "prcm43xx.h"
+#include "omap_hwmod_common_data.h"
+
 
 /* IP blocks */
 static struct omap_hwmod am43xx_l4_hs_hwmod = {
@@ -415,6 +417,70 @@ static struct omap_hwmod am43xx_qspi_hwmod = {
 	},
 };
 
+/* Display sub system - DSS */
+
+struct omap_dss_dispc_dev_attr am43xx_dss_dispc_dev_attr = {
+	.manager_count		= 1,
+	.has_framedonetv_irq	= 0
+};
+
+
+static struct omap_hwmod_class_sysconfig am43xx_dispc_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class am43xx_dispc_hwmod_class = {
+	.name	= "dispc",
+	.sysc	= &am43xx_dispc_sysc,
+};
+
+static struct omap_hwmod am43xx_dss_core_hwmod = {
+	.name		= "dss_core",
+	.class		= &omap2_dss_hwmod_class,
+	.clkdm_name	= "dss_clkdm",
+	.main_clk	= "disp_clk",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = AM43XX_CM_PER_DSS_CLKCTRL_OFFSET,
+			.modulemode   = MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* display controller -dispc*/
+
+static struct omap_hwmod am43xx_dss_dispc_hwmod = {
+	.name		= "dss_dispc",
+	.class		= &am43xx_dispc_hwmod_class,
+	.clkdm_name	= "dss_clkdm",
+	.main_clk	= "disp_clk",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = AM43XX_CM_PER_DSS_CLKCTRL_OFFSET,
+		},
+	},
+	.dev_attr	= &am43xx_dss_dispc_dev_attr,
+};
+
+/*RFBI*/
+
+static struct omap_hwmod am43xx_dss_rfbi_hwmod = {
+	.name		= "dss_rfbi",
+	.class		= &omap2_rfbi_hwmod_class,
+	.clkdm_name	= "dss_clkdm",
+	.main_clk	= "disp_clk",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = AM43XX_CM_PER_DSS_CLKCTRL_OFFSET,
+		},
+	},
+};
+
 /* Interfaces */
 static struct omap_hwmod_ocp_if am43xx_l3_main__l4_hs = {
 	.master		= &am33xx_l3_main_hwmod,
@@ -654,6 +720,34 @@ static struct omap_hwmod_ocp_if am43xx_l3_s__qspi = {
 	.user           = OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+static struct omap_hwmod_ocp_if am43xx_dss__l3_main = {
+	.master		= &am43xx_dss_core_hwmod,
+	.slave		= &am33xx_l3_main_hwmod,
+	.clk		= "l3_gclk",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod_ocp_if am43xx_l4_ls__dss = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am43xx_dss_core_hwmod,
+	.clk		= "l4ls_gclk",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod_ocp_if am43xx_l4_ls__dss_dispc = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am43xx_dss_dispc_hwmod,
+	.clk		= "l4ls_gclk",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod_ocp_if am43xx_l4_ls__dss_rfbi = {
+	.master		= &am33xx_l4_ls_hwmod,
+	.slave		= &am43xx_dss_rfbi_hwmod,
+	.clk		= "l4ls_gclk",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_ifs[] __initdata = {
 	&am33xx_l4_wkup__synctimer,
 	&am43xx_l4_ls__timer8,
@@ -748,6 +842,10 @@ static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_ifs[] __initdata = {
 	&am43xx_l4_ls__ocp2scp1,
 	&am43xx_l3_s__usbotgss0,
 	&am43xx_l3_s__usbotgss1,
+	&am43xx_dss__l3_main,
+	&am43xx_l4_ls__dss,
+	&am43xx_l4_ls__dss_dispc,
+	&am43xx_l4_ls__dss_rfbi,
 	NULL,
 };
 
diff --git a/arch/arm/mach-omap2/prcm43xx.h b/arch/arm/mach-omap2/prcm43xx.h
index 7785be9..ad7b3e9 100644
--- a/arch/arm/mach-omap2/prcm43xx.h
+++ b/arch/arm/mach-omap2/prcm43xx.h
@@ -142,5 +142,6 @@
 #define AM43XX_CM_PER_USBPHYOCP2SCP0_CLKCTRL_OFFSET	0x05B8
 #define AM43XX_CM_PER_USB_OTG_SS1_CLKCTRL_OFFSET        0x0268
 #define AM43XX_CM_PER_USBPHYOCP2SCP1_CLKCTRL_OFFSET	0x05C0
+#define AM43XX_CM_PER_DSS_CLKCTRL_OFFSET		0x0a20
 
 #endif
-- 
2.0.0.rc1

