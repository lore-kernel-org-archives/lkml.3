Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab3IRR7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:59:35 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:59242 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3IRRyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:54:13 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Tony Prisk <linux@prisktech.co.nz>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/26] ARM: vt8500: prepare for arch-wide .init_time callback
Date: Wed, 18 Sep 2013 19:53:41 +0200
Message-Id: <1379526839-14798-9-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current vt8500 board init calls of_clk_init() from vtwm_clk_init. To allow
consolidation of DT driven .time_init, move of_clock_init() to a temporary
.time_init callback that will be removed when arch-wide callback is available.
With previous pmc_base parsing helper for vt8500 clock providers, we can also
safely remove the call to vtwm_clk_init() and get rid of some includes.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Prisk <linux@prisktech.co.nz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-vt8500/common.h |   24 ------------------------
 arch/arm/mach-vt8500/vt8500.c |   13 ++++++++-----
 drivers/clk/clk-vt8500.c      |   10 ----------
 3 files changed, 8 insertions(+), 39 deletions(-)
 delete mode 100644 arch/arm/mach-vt8500/common.h

diff --git a/arch/arm/mach-vt8500/common.h b/arch/arm/mach-vt8500/common.h
deleted file mode 100644
index 087787a..0000000
--- a/arch/arm/mach-vt8500/common.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/* linux/arch/arm/mach-vt8500/dt_common.h
- *
- * Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef __ARCH_ARM_MACH_VT8500_DT_COMMON_H
-#define __ARCH_ARM_MACH_VT8500_DT_COMMON_H
-
-#include <linux/of.h>
-
-/* defined in drivers/clk/clk-vt8500.c */
-void __init vtwm_clk_init(void __iomem *pmc_base);
-
-#endif
diff --git a/arch/arm/mach-vt8500/vt8500.c b/arch/arm/mach-vt8500/vt8500.c
index eefaa60..5041563 100644
--- a/arch/arm/mach-vt8500/vt8500.c
+++ b/arch/arm/mach-vt8500/vt8500.c
@@ -18,6 +18,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/clk-provider.h>
 #include <linux/clocksource.h>
 #include <linux/io.h>
 #include <linux/pm.h>
@@ -33,8 +34,6 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 
-#include "common.h"
-
 #define LEGACY_GPIO_BASE	0xD8110000
 #define LEGACY_PMC_BASE		0xD8130000
 
@@ -75,6 +74,12 @@ static void vt8500_power_off(void)
 	asm("mcr%? p15, 0, %0, c7, c0, 4" : : "r" (0));
 }
 
+static void __init vt8500_init_time(void)
+{
+	of_clk_init(NULL);
+	clocksource_of_init();
+}
+
 void __init vt8500_init(void)
 {
 	struct device_node *np;
@@ -162,8 +167,6 @@ void __init vt8500_init(void)
 	else
 		pr_err("%s: PMC Hibernation register could not be remapped, not enabling power off!\n", __func__);
 
-	vtwm_clk_init(pmc_base);
-
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
@@ -180,7 +183,7 @@ DT_MACHINE_START(WMT_DT, "VIA/Wondermedia SoC (Device Tree Support)")
 	.dt_compat	= vt8500_dt_compat,
 	.map_io		= vt8500_map_io,
 	.init_machine	= vt8500_init,
-	.init_time	= clocksource_of_init,
+	.init_time	= vt8500_init_time,
 	.restart	= vt8500_restart,
 MACHINE_END
 
diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index a5ee01c..88212d7 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -715,13 +715,3 @@ static void __init wm8850_pll_init(struct device_node *node)
 	vtwm_pll_clk_init(node, PLL_TYPE_WM8850);
 }
 CLK_OF_DECLARE(wm8850_pll, "wm,wm8850-pll-clock", wm8850_pll_init);
-
-void __init vtwm_clk_init(void __iomem *base)
-{
-	if (!base)
-		return;
-
-	pmc_base = base;
-
-	of_clk_init(NULL);
-}
-- 
1.7.10.4

