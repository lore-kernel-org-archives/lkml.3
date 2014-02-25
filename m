Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaBYWSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:18:06 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:4314 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaBYWSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:18:04 -0500
X-IronPort-AV: E=Sophos;i="4.97,542,1389772800"; 
   d="scan'208";a="16790664"
From: Markus Mayer <markus.mayer@linaro.org>
To: Matt Porter <matt.porter@linaro.org>, Christian Daudt <bcm@fixthebug.org>
CC: ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] ARM: bcm281xx: Move kona_l2_cache_init() so it can be shared
Date: Tue, 25 Feb 2014 14:17:43 -0800
Message-ID: <1393366666-28625-2-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393366666-28625-1-git-send-email-markus.mayer@linaro.org>
References: <1393366666-28625-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for future SoCs, move kona_l2_cache_init() from board
specific board_bcm281xx.c to shared kona.c, so multiple SoC families
can make use of it. Also change the return type to "void", since we
never look at the return code anyway.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/mach-bcm/board_bcm281xx.c |   26 +-------------------------
 arch/arm/mach-bcm/kona.c           |   30 +++++++++++++++++++++++++++++-
 arch/arm/mach-bcm/kona.h           |    3 ++-
 3 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/arch/arm/mach-bcm/board_bcm281xx.c b/arch/arm/mach-bcm/board_bcm281xx.c
index cb3dc36..4874f56 100644
--- a/arch/arm/mach-bcm/board_bcm281xx.c
+++ b/arch/arm/mach-bcm/board_bcm281xx.c
@@ -12,37 +12,13 @@
  */
 
 #include <linux/of_platform.h>
-#include <linux/init.h>
-#include <linux/device.h>
-#include <linux/platform_device.h>
+#include <linux/of_address.h>
 #include <linux/clocksource.h>
 
 #include <asm/mach/arch.h>
-#include <asm/mach/time.h>
-#include <asm/hardware/cache-l2x0.h>
 
-#include "bcm_kona_smc.h"
 #include "kona.h"
 
-static int __init kona_l2_cache_init(void)
-{
-	if (!IS_ENABLED(CONFIG_CACHE_L2X0))
-		return 0;
-
-	if (bcm_kona_smc_init() < 0) {
-		pr_info("Kona secure API not available. Skipping L2 init\n");
-		return 0;
-	}
-
-	bcm_kona_smc(SSAPI_ENABLE_L2_CACHE, 0, 0, 0, 0);
-
-	/*
-	 * The aux_val and aux_mask have no effect since L2 cache is already
-	 * enabled.  Pass 0s for aux_val and 1s for aux_mask for default value.
-	 */
-	return l2x0_of_init(0, ~0);
-}
-
 static void bcm_board_setup_restart(void)
 {
 	struct device_node *np;
diff --git a/arch/arm/mach-bcm/kona.c b/arch/arm/mach-bcm/kona.c
index 6939d90..2f1db29 100644
--- a/arch/arm/mach-bcm/kona.c
+++ b/arch/arm/mach-bcm/kona.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2013 Broadcom Corporation
+ * Copyright (C) 2012-2014 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -12,10 +12,38 @@
  */
 
 #include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <asm/hardware/cache-l2x0.h>
 #include <asm/io.h>
 
+#include "bcm_kona_smc.h"
 #include "kona.h"
 
+void __init kona_l2_cache_init(void)
+{
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_CACHE_L2X0))
+		return;
+
+	ret = bcm_kona_smc_init();
+	if (ret) {
+		pr_info("Secure API not available (%d). Skipping L2 init.\n",
+			ret);
+		return;
+	}
+
+	bcm_kona_smc(SSAPI_ENABLE_L2_CACHE, 0, 0, 0, 0);
+
+	/*
+	 * The aux_val and aux_mask have no effect since L2 cache is already
+	 * enabled.  Pass 0s for aux_val and 1s for aux_mask for default value.
+	 */
+	ret = l2x0_of_init(0, ~0);
+	if (ret)
+		pr_err("Couldn't enable L2 cache: %d\n", ret);
+}
+
 static void __iomem *watchdog_base;
 
 void bcm_kona_setup_restart(void)
diff --git a/arch/arm/mach-bcm/kona.h b/arch/arm/mach-bcm/kona.h
index 291eca3..f42aef8 100644
--- a/arch/arm/mach-bcm/kona.h
+++ b/arch/arm/mach-bcm/kona.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2013 Broadcom Corporation
+ * Copyright (C) 2012-2014 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -13,5 +13,6 @@
 
 #include <linux/reboot.h>
 
+void __init kona_l2_cache_init(void);
 void bcm_kona_setup_restart(void);
 void bcm_kona_restart(enum reboot_mode mode, const char *cmd);
-- 
1.7.9.5

