Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab3JHKHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:07:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54313 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab3JHKHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:07:10 -0400
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [PATCH v2 1/6] ARM: OMAP5: hwmod data: Add USB Host and TLL modules
Date: Tue, 8 Oct 2013 13:06:34 +0300
Message-ID: <1381226799-29158-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1381226799-29158-1-git-send-email-rogerq@ti.com>
References: <1381226799-29158-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add hwmod data for High Speed USB host and TLL modules

CC: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c |  135 ++++++++++++++++++++++++++++
 1 files changed, 135 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_54xx_data.c b/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
index 1a21a81..1dd2c20 100644
--- a/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
@@ -1501,6 +1501,123 @@ static struct omap_hwmod omap54xx_uart6_hwmod = {
 };
 
 /*
+ * 'usb_host_hs' class
+ * high-speed multi-port usb host controller
+ */
+
+static struct omap_hwmod_class_sysconfig omap54xx_usb_host_hs_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_RESET_STATUS |
+			   SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
+			   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class omap54xx_usb_host_hs_hwmod_class = {
+	.name	= "usb_host_hs",
+	.sysc	= &omap54xx_usb_host_hs_sysc,
+};
+
+static struct omap_hwmod omap54xx_usb_host_hs_hwmod = {
+	.name		= "usb_host_hs",
+	.class		= &omap54xx_usb_host_hs_hwmod_class,
+	.clkdm_name	= "l3init_clkdm",
+	/*
+	 * Errata: USBHOST Configured In Smart-Idle Can Lead To a Deadlock
+	 * id: i660
+	 *
+	 * Description:
+	 * In the following configuration :
+	 * - USBHOST module is set to smart-idle mode
+	 * - PRCM asserts idle_req to the USBHOST module ( This typically
+	 *   happens when the system is going to a low power mode : all ports
+	 *   have been suspended, the master part of the USBHOST module has
+	 *   entered the standby state, and SW has cut the functional clocks)
+	 * - an USBHOST interrupt occurs before the module is able to answer
+	 *   idle_ack, typically a remote wakeup IRQ.
+	 * Then the USB HOST module will enter a deadlock situation where it
+	 * is no more accessible nor functional.
+	 *
+	 * Workaround:
+	 * Don't use smart idle; use only force idle, hence HWMOD_SWSUP_SIDLE
+	 */
+
+	/*
+	 * Errata: USB host EHCI may stall when entering smart-standby mode
+	 * Id: i571
+	 *
+	 * Description:
+	 * When the USBHOST module is set to smart-standby mode, and when it is
+	 * ready to enter the standby state (i.e. all ports are suspended and
+	 * all attached devices are in suspend mode), then it can wrongly assert
+	 * the Mstandby signal too early while there are still some residual OCP
+	 * transactions ongoing. If this condition occurs, the internal state
+	 * machine may go to an undefined state and the USB link may be stuck
+	 * upon the next resume.
+	 *
+	 * Workaround:
+	 * Don't use smart standby; use only force standby,
+	 * hence HWMOD_SWSUP_MSTANDBY
+	 */
+
+	/*
+	 * During system boot; If the hwmod framework resets the module
+	 * the module will have smart idle settings; which can lead to deadlock
+	 * (above Errata Id:i660); so, dont reset the module during boot;
+	 * Use HWMOD_INIT_NO_RESET.
+	 */
+
+	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY |
+			  HWMOD_INIT_NO_RESET,
+	.main_clk	= "l3init_60m_fclk",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = OMAP54XX_CM_L3INIT_USB_HOST_HS_CLKCTRL_OFFSET,
+			.context_offs = OMAP54XX_RM_L3INIT_USB_HOST_HS_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
+ * 'usb_tll_hs' class
+ * usb_tll_hs module is the adapter on the usb_host_hs ports
+ */
+
+static struct omap_hwmod_class_sysconfig omap54xx_usb_tll_hs_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_CLOCKACTIVITY |
+			   SYSC_HAS_ENAWAKEUP | SYSC_HAS_SIDLEMODE |
+			   SYSC_HAS_SOFTRESET | SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class omap54xx_usb_tll_hs_hwmod_class = {
+	.name	= "usb_tll_hs",
+	.sysc	= &omap54xx_usb_tll_hs_sysc,
+};
+
+static struct omap_hwmod omap54xx_usb_tll_hs_hwmod = {
+	.name		= "usb_tll_hs",
+	.class		= &omap54xx_usb_tll_hs_hwmod_class,
+	.clkdm_name	= "l3init_clkdm",
+	.main_clk	= "l4_root_clk_div",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = OMAP54XX_CM_L3INIT_USB_TLL_HS_CLKCTRL_OFFSET,
+			.context_offs = OMAP54XX_RM_L3INIT_USB_TLL_HS_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+};
+
+/*
  * 'usb_otg_ss' class
  * 2.0 super speed (usb_otg_ss) controller
  */
@@ -2140,6 +2257,22 @@ static struct omap_hwmod_ocp_if omap54xx_l4_per__uart6 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* l4_cfg -> usb_host_hs */
+static struct omap_hwmod_ocp_if omap54xx_l4_cfg__usb_host_hs = {
+	.master		= &omap54xx_l4_cfg_hwmod,
+	.slave		= &omap54xx_usb_host_hs_hwmod,
+	.clk		= "l3_iclk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l4_cfg -> usb_tll_hs */
+static struct omap_hwmod_ocp_if omap54xx_l4_cfg__usb_tll_hs = {
+	.master		= &omap54xx_l4_cfg_hwmod,
+	.slave		= &omap54xx_usb_tll_hs_hwmod,
+	.clk		= "l4_root_clk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 /* l4_cfg -> usb_otg_ss */
 static struct omap_hwmod_ocp_if omap54xx_l4_cfg__usb_otg_ss = {
 	.master		= &omap54xx_l4_cfg_hwmod,
@@ -2225,6 +2358,8 @@ static struct omap_hwmod_ocp_if *omap54xx_hwmod_ocp_ifs[] __initdata = {
 	&omap54xx_l4_per__uart4,
 	&omap54xx_l4_per__uart5,
 	&omap54xx_l4_per__uart6,
+	&omap54xx_l4_cfg__usb_host_hs,
+	&omap54xx_l4_cfg__usb_tll_hs,
 	&omap54xx_l4_cfg__usb_otg_ss,
 	&omap54xx_l4_wkup__wd_timer2,
 	NULL,
-- 
1.7.4.1

