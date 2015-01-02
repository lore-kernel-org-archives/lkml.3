Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbbABTwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 14:52:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49306 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbbABTwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 14:52:36 -0500
From: Dave Gerlach <d-gerlach@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: Benoit Cousson <bcousson@baylibre.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Suman Anna <s-anna@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Dave Gerlach <d-gerlach@ti.com>
Subject: [PATCH 1/3] ARM: OMAP2+: Use pdata-quirks for wkup_m3 deassert_hardreset
Date: Fri, 2 Jan 2015 13:51:57 -0600
Message-ID: <1420228319-41085-2-git-send-email-d-gerlach@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420228319-41085-1-git-send-email-d-gerlach@ti.com>
References: <1420228319-41085-1-git-send-email-d-gerlach@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pdata-quirks to provide platform data required for reset
of the wkup_m3 during boot.

Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
---
 arch/arm/mach-omap2/pdata-quirks.c    | 13 +++++++++++++
 include/linux/platform_data/wkup_m3.h | 23 +++++++++++++++++++++++
 2 files changed, 36 insertions(+)
 create mode 100644 include/linux/platform_data/wkup_m3.h

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 3d7eee1..b0c5916 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -18,6 +18,7 @@
 
 #include <linux/platform_data/pinctrl-single.h>
 #include <linux/platform_data/iommu-omap.h>
+#include <linux/platform_data/wkup_m3.h>
 
 #include "am35xx.h"
 #include "common.h"
@@ -288,6 +289,14 @@ static void __init omap3_tao3530_legacy_init(void)
 }
 #endif /* CONFIG_ARCH_OMAP3 */
 
+#ifdef CONFIG_SOC_AM33XX
+static struct wkup_m3_platform_data wkup_m3_data = {
+	.reset_name = "wkup_m3",
+	.assert_reset = omap_device_assert_hardreset,
+	.deassert_reset = omap_device_deassert_hardreset,
+};
+#endif
+
 #ifdef CONFIG_ARCH_OMAP4
 static void __init omap4_sdp_legacy_init(void)
 {
@@ -383,6 +392,10 @@ struct of_dev_auxdata omap_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("ti,am3517-emac", 0x5c000000, "davinci_emac.0",
 		       &am35xx_emac_pdata),
 #endif
+#ifdef CONFIG_SOC_AM33XX
+	OF_DEV_AUXDATA("ti,am3353-wkup-m3", 0x44d00000, "44d00000.wkup_m3",
+		       &wkup_m3_data),
+#endif
 #ifdef CONFIG_ARCH_OMAP4
 	OF_DEV_AUXDATA("ti,omap4-padconf", 0x4a100040, "4a100040.pinmux", &pcs_pdata),
 	OF_DEV_AUXDATA("ti,omap4-padconf", 0x4a31e040, "4a31e040.pinmux", &pcs_pdata),
diff --git a/include/linux/platform_data/wkup_m3.h b/include/linux/platform_data/wkup_m3.h
new file mode 100644
index 0000000..6ee33d7
--- /dev/null
+++ b/include/linux/platform_data/wkup_m3.h
@@ -0,0 +1,23 @@
+/*
+ * omap wkup_m3: platform data
+ *
+ * Copyright (C) 2014 Texas Instruments, Inc.
+ *
+ * Dave Gerlach <d-gerlach@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_PLATFORM_DATA_WKUP_M3_H
+#define _LINUX_PLATFORM_DATA_WKUP_M3_H
+
+struct wkup_m3_platform_data {
+	const char *reset_name;
+
+	int (*assert_reset)(struct platform_device *pdev, const char *name);
+	int (*deassert_reset)(struct platform_device *pdev, const char *name);
+};
+
+#endif /* _LINUX_PLATFORM_DATA_WKUP_M3_H */
-- 
2.1.0

