Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbaGANEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:04:55 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:56331 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbaGANEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:04:49 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ARM: mvebu: add armada drm init to Dove board setup
Date: Tue,  1 Jul 2014 15:04:31 +0200
Message-Id: <1404219871-18419-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

Adding both, driver and proper DT representation, especially when
subsystem DT bindings are not settled, is almost impossible right
now. To get some more code testing coverage on Armada DRM driver,
we add plain old platform_device registration now and get rid of
it incrementally as we did often in the past.

This adds DRM platform_device and required quirks to get it up
and running (framebuffer CMA, lcd resources, clks) which allows
us to remove it step-by-step again when bindings have settled.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-mvebu/dove.c |   70 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 69 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mvebu/dove.c b/arch/arm/mach-mvebu/dove.c
index b50464e..c8c2284 100644
--- a/arch/arm/mach-mvebu/dove.c
+++ b/arch/arm/mach-mvebu/dove.c
@@ -11,11 +11,75 @@
 #include <linux/init.h>
 #include <linux/mbus.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <asm/hardware/cache-tauros2.h>
 #include <asm/mach/arch.h>
+#include <asm/memblock.h>
 #include "common.h"
 
+/*
+ * Armada DRM framebuffer
+ */
+static struct resource armada_drm_resources[3] = {
+	DEFINE_RES_MEM(0, 0),
+};
+
+static const char *armada_drm_devices[4];
+
+static const struct platform_device_info armada_drm_dev_info __initconst = {
+	.name = "armada-510-drm",
+	.id = -1,
+	.res = armada_drm_resources,
+	.num_res = ARRAY_SIZE(armada_drm_resources),
+	.data = armada_drm_devices,
+	.size_data = sizeof(armada_drm_devices),
+};
+
+static void __init armada_drm_reserve(void)
+{
+	phys_addr_t phys;
+
+	/* Steal 32MB for the drm framebuffers */
+	phys = arm_memblock_steal(SZ_32M, SZ_2M);
+	armada_drm_resources[0].start = phys;
+	armada_drm_resources[0].end = phys + SZ_32M - 1;
+}
+
+static void __init armada_drm_init(void)
+{
+	struct device_node *np, *clknp = NULL;
+	struct platform_device *pdev;
+	int i = 0;
+
+	for_each_compatible_node(np, NULL, "marvell,dove-lcd") {
+		if (!of_device_is_available(np))
+			continue;
+
+		/* add lcd controller mmio resources */
+		if (of_address_to_resource(np, 0, &armada_drm_resources[i+1]))
+			continue;
+
+		/* get device name for component framework */
+		pdev = of_find_device_by_node(np);
+		if (pdev)
+			armada_drm_devices[i] = dev_name(&pdev->dev);
+		clknp = np;
+		i++;
+	}
+	armada_drm_devices[i++] = NULL;
+
+	pdev = platform_device_register_full(&armada_drm_dev_info);
+	/* assign last found lcd node to drm device for clk lookup */
+	pdev->dev.of_node = clknp;
+}
+
+static void __init dove_reserve(void)
+{
+	if (IS_ENABLED(CONFIG_DRM_ARMADA))
+		armada_drm_reserve();
+}
+
 static void __init dove_init(void)
 {
 	pr_info("Dove 88AP510 SoC\n");
@@ -25,6 +89,9 @@ static void __init dove_init(void)
 #endif
 	BUG_ON(mvebu_mbus_dt_init(false));
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+
+	if (IS_ENABLED(CONFIG_DRM_ARMADA))
+		armada_drm_init();
 }
 
 static const char * const dove_dt_compat[] = {
@@ -33,7 +100,8 @@ static const char * const dove_dt_compat[] = {
 };
 
 DT_MACHINE_START(DOVE_DT, "Marvell Dove")
+	.dt_compat	= dove_dt_compat,
 	.init_machine	= dove_init,
+	.reserve	= dove_reserve,
 	.restart	= mvebu_restart,
-	.dt_compat	= dove_dt_compat,
 MACHINE_END
-- 
1.7.2.5

