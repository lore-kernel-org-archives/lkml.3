Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab3CGNOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:14:35 -0500
Received: from mout.gmx.net ([212.227.15.19]:64814 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab3CGNOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:14:30 -0500
X-Authenticated: #20192376
X-Provags-ID: V01U2FsdGVkX18qQOl6BNsqwLGzs1yiaQbwgpteKyLPkMeCqK4ZNV
	xQQT3LB7k1f9nH
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: paul@pwsan.com, tony@atomide.com
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        afzal@ti.com, hvaibhav@ti.com, daniel@zonque.org,
        Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [PATCH] ARM: OMAP2+: am33xx: preserve JTAG clock aka debugss_ick.
Date: Thu,  7 Mar 2013 14:13:27 +0100
Message-Id: <1362662007-13782-2-git-send-email-andreas.fenkart@streamunlimited.com>
X-Mailer: git-send-email 1.7.10.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes JTAG support on am33xx.

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
---
 arch/arm/Kconfig.debug                |    6 ++++++
 arch/arm/mach-omap2/cclock33xx_data.c |   11 ++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index acdddda..8120940 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -632,4 +632,10 @@ config PID_IN_CONTEXTIDR
 	  additional instructions during context switch. Say Y here only if you
 	  are planning to use hardware trace tools with this kernel.
 
+config JTAG
+	bool "Enable JTAG clock"
+	depends on SOC_AM33XX
+	help
+	  Enable or keep JTAG clock enabled
+
 endmenu
diff --git a/arch/arm/mach-omap2/cclock33xx_data.c b/arch/arm/mach-omap2/cclock33xx_data.c
index 476b820..b7470de 100644
--- a/arch/arm/mach-omap2/cclock33xx_data.c
+++ b/arch/arm/mach-omap2/cclock33xx_data.c
@@ -429,9 +429,14 @@ DEFINE_STRUCT_CLK(smartreflex1_fck, dpll_core_ck_parents, clk_ops_null);
  *     - usbotg_fck (its additional clock and not really a modulemode)
  *     - ieee5000
  */
-DEFINE_CLK_GATE(debugss_ick, "dpll_core_m4_ck", &dpll_core_m4_ck, 0x0,
-		AM33XX_CM_WKUP_DEBUGSS_CLKCTRL, AM33XX_MODULEMODE_SWCTRL_SHIFT,
-		0x0, NULL);
+#ifdef CONFIG_JTAG
+#define DEBUGSS_FLAGS CLK_IGNORE_UNUSED
+#else
+#define DEBUGSS_FLAGS 0x0
+#endif
+DEFINE_CLK_GATE(debugss_ick, "dpll_core_m4_ck", &dpll_core_m4_ck,
+		DEBUGSS_FLAGS, AM33XX_CM_WKUP_DEBUGSS_CLKCTRL,
+		AM33XX_MODULEMODE_SWCTRL_SHIFT, 0x0, NULL);
 
 DEFINE_CLK_GATE(mmu_fck, "dpll_core_m4_ck", &dpll_core_m4_ck, 0x0,
 		AM33XX_CM_GFX_MMUDATA_CLKCTRL, AM33XX_MODULEMODE_SWCTRL_SHIFT,
-- 
1.7.10.4

