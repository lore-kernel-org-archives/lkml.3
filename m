Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab3JPPlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:41:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43913 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760774Ab3JPPjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:39:43 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [PATCH V7 2/8] ARM: OMAP2+: add missing lateinit hook for calling pm late init
Date: Wed, 16 Oct 2013 10:39:02 -0500
Message-ID: <1381937948-27057-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381937948-27057-1-git-send-email-nm@ti.com>
References: <1381937948-27057-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AM335x, AM43xx, OMAP5 and DRA7 have missing late init hook. Introduce
SoC specific hook with a call to OMAP2+ generic lateinit hook. This
allows the generic late initializations such as cpufreq hooks to be
active.

Based on out-of-tree patches that need to be introduced in
mainline, this introduction allows us to provide the foundation for
further SoC specific features as they are developed.

Cc: Benoit Cousson <bcousson@baylibre.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/board-generic.c |    4 ++++
 arch/arm/mach-omap2/common.h        |    4 ++++
 arch/arm/mach-omap2/io.c            |   20 ++++++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 3017a9d..e366064 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -128,6 +128,7 @@ DT_MACHINE_START(AM33XX_DT, "Generic AM33XX (Flattened Device Tree)")
 	.init_irq	= omap_intc_of_init,
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_generic_init,
+	.init_late	= am33xx_init_late,
 	.init_time	= omap3_gptimer_timer_init,
 	.dt_compat	= am33xx_boards_compat,
 	.restart	= am33xx_restart,
@@ -167,6 +168,7 @@ DT_MACHINE_START(OMAP5_DT, "Generic OMAP5 (Flattened Device Tree)")
 	.init_early	= omap5_init_early,
 	.init_irq	= omap_gic_of_init,
 	.init_machine	= omap_generic_init,
+	.init_late	= omap5_init_late,
 	.init_time	= omap5_realtime_timer_init,
 	.dt_compat	= omap5_boards_compat,
 	.restart	= omap44xx_restart,
@@ -182,6 +184,7 @@ static const char *am43_boards_compat[] __initdata = {
 DT_MACHINE_START(AM43_DT, "Generic AM43 (Flattened Device Tree)")
 	.map_io		= am33xx_map_io,
 	.init_early	= am43xx_init_early,
+	.init_late	= am43xx_init_late,
 	.init_irq	= omap_gic_of_init,
 	.init_machine	= omap_generic_init,
 	.init_time	= omap3_sync32k_timer_init,
@@ -200,6 +203,7 @@ DT_MACHINE_START(DRA7XX_DT, "Generic DRA7XX (Flattened Device Tree)")
 	.smp		= smp_ops(omap4_smp_ops),
 	.map_io		= omap5_map_io,
 	.init_early	= dra7xx_init_early,
+	.init_late	= dra7xx_init_late,
 	.init_irq	= omap_gic_of_init,
 	.init_machine	= omap_generic_init,
 	.init_time	= omap5_realtime_timer_init,
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index c6aebf0..f7644fe 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -98,6 +98,7 @@ void am35xx_init_early(void);
 void ti81xx_init_early(void);
 void am33xx_init_early(void);
 void am43xx_init_early(void);
+void am43xx_init_late(void);
 void omap4430_init_early(void);
 void omap5_init_early(void);
 void omap3_init_late(void);	/* Do not use this one */
@@ -109,8 +110,11 @@ void omap35xx_init_late(void);
 void omap3630_init_late(void);
 void am35xx_init_late(void);
 void ti81xx_init_late(void);
+void am33xx_init_late(void);
+void omap5_init_late(void);
 int omap2_common_pm_late_init(void);
 void dra7xx_init_early(void);
+void dra7xx_init_late(void);
 
 #ifdef CONFIG_SOC_BUS
 void omap_soc_device_init(void);
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index ff2113c..a2cbb44 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -583,6 +583,11 @@ void __init am33xx_init_early(void)
 	omap_hwmod_init_postsetup();
 	omap_clk_init = am33xx_clk_init;
 }
+
+void __init am33xx_init_late(void)
+{
+	omap_common_late_init();
+}
 #endif
 
 #ifdef CONFIG_SOC_AM43XX
@@ -596,6 +601,11 @@ void __init am43xx_init_early(void)
 	omap2_set_globals_cm(AM33XX_L4_WK_IO_ADDRESS(AM43XX_PRCM_BASE), NULL);
 	omap3xxx_check_revision();
 }
+
+void __init am43xx_init_late(void)
+{
+	omap_common_late_init();
+}
 #endif
 
 #ifdef CONFIG_ARCH_OMAP4
@@ -651,6 +661,11 @@ void __init omap5_init_early(void)
 	omap54xx_hwmod_init();
 	omap_hwmod_init_postsetup();
 }
+
+void __init omap5_init_late(void)
+{
+	omap_common_late_init();
+}
 #endif
 
 #ifdef CONFIG_SOC_DRA7XX
@@ -671,6 +686,11 @@ void __init dra7xx_init_early(void)
 	dra7xx_hwmod_init();
 	omap_hwmod_init_postsetup();
 }
+
+void __init dra7xx_init_late(void)
+{
+	omap_common_late_init();
+}
 #endif
 
 
-- 
1.7.9.5

