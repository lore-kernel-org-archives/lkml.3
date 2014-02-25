Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaBYWSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:18:20 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:13984 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaBYWSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:18:18 -0500
X-IronPort-AV: E=Sophos;i="4.97,542,1389772800"; 
   d="scan'208";a="16363943"
From: Markus Mayer <markus.mayer@linaro.org>
To: Matt Porter <matt.porter@linaro.org>, Christian Daudt <bcm@fixthebug.org>
CC: ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] ARM: bcm281xx: Consolidate reboot code
Date: Tue, 25 Feb 2014 14:17:44 -0800
Message-ID: <1393366666-28625-3-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393366666-28625-1-git-send-email-markus.mayer@linaro.org>
References: <1393366666-28625-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate reboot code and remove unnecessary functions.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/mach-bcm/board_bcm281xx.c |   46 ++++++++++++++++++++++++---------
 arch/arm/mach-bcm/kona.c           |   50 ------------------------------------
 arch/arm/mach-bcm/kona.h           |    4 ---
 3 files changed, 34 insertions(+), 66 deletions(-)

diff --git a/arch/arm/mach-bcm/board_bcm281xx.c b/arch/arm/mach-bcm/board_bcm281xx.c
index 4874f56..e0d0bc5e 100644
--- a/arch/arm/mach-bcm/board_bcm281xx.c
+++ b/arch/arm/mach-bcm/board_bcm281xx.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2012-2013 Broadcom Corporation
+ * Copyright (C) 2012-2014 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -19,25 +19,47 @@
 
 #include "kona.h"
 
-static void bcm_board_setup_restart(void)
+#define SECWDOG_OFFSET			0x00000000
+#define SECWDOG_RESERVED_MASK		0xe2000000
+#define SECWDOG_WD_LOAD_FLAG_MASK	0x10000000
+#define SECWDOG_EN_MASK			0x08000000
+#define SECWDOG_SRSTEN_MASK		0x04000000
+#define SECWDOG_CLKS_SHIFT		20
+#define SECWDOG_COUNT_SHIFT		0
+
+static void bcm281xx_restart(enum reboot_mode mode, const char *cmd)
 {
-	struct device_node *np;
+	uint32_t val;
+	void __iomem *base;
+	struct device_node *np_wdog;
 
-	np = of_find_compatible_node(NULL, NULL, "brcm,bcm11351");
-	if (np) {
-		if (of_device_is_available(np))
-			bcm_kona_setup_restart();
-		of_node_put(np);
+	np_wdog = of_find_compatible_node(NULL, NULL, "brcm,kona-wdt");
+	if (!np_wdog) {
+		pr_emerg("Couldn't find brcm,kona-wdt\n");
+		return;
+	}
+	base = of_iomap(np_wdog, 0);
+	if (!base) {
+		pr_emerg("Couldn't map brcm,kona-wdt\n");
+		return;
 	}
-	/* Restart setup for other boards goes here */
+
+	/* Enable watchdog with short timeout (244us). */
+	val = readl(base + SECWDOG_OFFSET);
+	val &= SECWDOG_RESERVED_MASK | SECWDOG_WD_LOAD_FLAG_MASK;
+	val |= SECWDOG_EN_MASK | SECWDOG_SRSTEN_MASK |
+		(0x15 << SECWDOG_CLKS_SHIFT) |
+		(0x8 << SECWDOG_COUNT_SHIFT);
+	writel(val, base + SECWDOG_OFFSET);
+
+	/* Wait for reset */
+	while (1);
 }
 
 static void __init board_init(void)
 {
 	of_platform_populate(NULL, of_default_bus_match_table, NULL,
 		&platform_bus);
-
-	bcm_board_setup_restart();
 	kona_l2_cache_init();
 }
 
@@ -45,6 +67,6 @@ static const char * const bcm11351_dt_compat[] = { "brcm,bcm11351", NULL, };
 
 DT_MACHINE_START(BCM11351_DT, "BCM281xx Broadcom Application Processor")
 	.init_machine = board_init,
-	.restart = bcm_kona_restart,
+	.restart = bcm281xx_restart,
 	.dt_compat = bcm11351_dt_compat,
 MACHINE_END
diff --git a/arch/arm/mach-bcm/kona.c b/arch/arm/mach-bcm/kona.c
index 2f1db29..768bc28 100644
--- a/arch/arm/mach-bcm/kona.c
+++ b/arch/arm/mach-bcm/kona.c
@@ -11,10 +11,8 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <asm/hardware/cache-l2x0.h>
-#include <asm/io.h>
 
 #include "bcm_kona_smc.h"
 #include "kona.h"
@@ -43,51 +41,3 @@ void __init kona_l2_cache_init(void)
 	if (ret)
 		pr_err("Couldn't enable L2 cache: %d\n", ret);
 }
-
-static void __iomem *watchdog_base;
-
-void bcm_kona_setup_restart(void)
-{
-	struct device_node *np_wdog;
-
-	/*
-	 * The assumption is that whoever calls bcm_kona_setup_restart()
-	 * also needs a Kona Watchdog Timer entry in Device Tree, i.e. we
-	 * report an error if the DT entry is missing.
-	 */
-	np_wdog = of_find_compatible_node(NULL, NULL, "brcm,kona-wdt");
-	if (!np_wdog) {
-		pr_err("brcm,kona-wdt not found in DT, reboot disabled\n");
-		return;
-	}
-	watchdog_base = of_iomap(np_wdog, 0);
-	WARN(!watchdog_base, "failed to map watchdog base");
-	of_node_put(np_wdog);
-}
-
-#define SECWDOG_OFFSET			0x00000000
-#define SECWDOG_RESERVED_MASK		0xE2000000
-#define SECWDOG_WD_LOAD_FLAG_MASK	0x10000000
-#define SECWDOG_EN_MASK			0x08000000
-#define SECWDOG_SRSTEN_MASK		0x04000000
-#define SECWDOG_CLKS_SHIFT		20
-#define SECWDOG_LOCK_SHIFT		0
-
-void bcm_kona_restart(enum reboot_mode mode, const char *cmd)
-{
-	uint32_t val;
-
-	if (!watchdog_base)
-		panic("Watchdog not mapped. Reboot failed.\n");
-
-	/* Enable watchdog2 with very short timeout. */
-	val = readl(watchdog_base + SECWDOG_OFFSET);
-	val &= SECWDOG_RESERVED_MASK | SECWDOG_WD_LOAD_FLAG_MASK;
-	val |= SECWDOG_EN_MASK | SECWDOG_SRSTEN_MASK |
-		(0x8 << SECWDOG_CLKS_SHIFT) |
-		(0x8 << SECWDOG_LOCK_SHIFT);
-	writel(val, watchdog_base + SECWDOG_OFFSET);
-
-	while (1)
-		;
-}
diff --git a/arch/arm/mach-bcm/kona.h b/arch/arm/mach-bcm/kona.h
index f42aef8..3a7a017 100644
--- a/arch/arm/mach-bcm/kona.h
+++ b/arch/arm/mach-bcm/kona.h
@@ -11,8 +11,4 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/reboot.h>
-
 void __init kona_l2_cache_init(void);
-void bcm_kona_setup_restart(void);
-void bcm_kona_restart(enum reboot_mode mode, const char *cmd);
-- 
1.7.9.5

