Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab3BFQKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:10:50 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10707 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab3BFQKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:10:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 06 Feb 2013 08:10:46 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] ARM: tegra: Fix build error w/ ARCH_TEGRA_114_SOC w/o ARCH_TEGRA_3x_SOC
Date: Wed, 6 Feb 2013 18:10:30 +0200
Message-ID: <1360167030-14159-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the build error when ARCH_TEGRA_114_SOC is enabled
and ARCH_TEGRA_3x_SOC is disabled.

This provides Tegra114 with its own tegra114_init_early() instead of
making use of tegra30_init_early() so that T114 build doesn't depend
on T3x anymore.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mach-tegra/board-dt-tegra114.c |    2 +-
 arch/arm/mach-tegra/board.h             |    2 ++
 arch/arm/mach-tegra/common.c            |   25 +++++++++++++++++--------
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra114.c b/arch/arm/mach-tegra/board-dt-tegra114.c
index 72598e2..085d636 100644
--- a/arch/arm/mach-tegra/board-dt-tegra114.c
+++ b/arch/arm/mach-tegra/board-dt-tegra114.c
@@ -36,7 +36,7 @@ static const char * const tegra114_dt_board_compat[] = {
 DT_MACHINE_START(TEGRA114_DT, "NVIDIA Tegra114 (Flattened Device Tree)")
 	.smp		= smp_ops(tegra_smp_ops),
 	.map_io		= tegra_map_common_io,
-	.init_early	= tegra30_init_early,
+	.init_early	= tegra114_init_early,
 	.init_irq	= tegra_dt_init_irq,
 	.init_time	= clocksource_of_init,
 	.init_machine	= tegra114_dt_init,
diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h
index da8f5a3..86851c8 100644
--- a/arch/arm/mach-tegra/board.h
+++ b/arch/arm/mach-tegra/board.h
@@ -1,6 +1,7 @@
 /*
  * arch/arm/mach-tegra/board.h
  *
+ * Copyright (c) 2013 NVIDIA Corporation. All rights reserved.
  * Copyright (C) 2010 Google, Inc.
  *
  * Author:
@@ -27,6 +28,7 @@ void tegra_assert_system_reset(char mode, const char *cmd);
 
 void __init tegra20_init_early(void);
 void __init tegra30_init_early(void);
+void __init tegra114_init_early(void);
 void __init tegra_map_common_io(void);
 void __init tegra_init_irq(void);
 void __init tegra_dt_init_irq(void);
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 46c0718..5449a3f 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -1,6 +1,7 @@
 /*
  * arch/arm/mach-tegra/common.c
  *
+ * Copyright (c) 2013 NVIDIA Corporation. All rights reserved.
  * Copyright (C) 2010 Google, Inc.
  *
  * Author:
@@ -93,8 +94,7 @@ static void __init tegra_init_cache(void)
 
 }
 
-#ifdef CONFIG_ARCH_TEGRA_2x_SOC
-void __init tegra20_init_early(void)
+static void __init tegra_init_early(void)
 {
 	tegra_cpu_reset_handler_init();
 	tegra_apb_io_init();
@@ -102,22 +102,31 @@ void __init tegra20_init_early(void)
 	tegra_init_cache();
 	tegra_pmc_init();
 	tegra_powergate_init();
+}
+
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
+void __init tegra20_init_early(void)
+{
+	tegra_init_early();
 	tegra20_hotplug_init();
 }
 #endif
+
 #ifdef CONFIG_ARCH_TEGRA_3x_SOC
 void __init tegra30_init_early(void)
 {
-	tegra_cpu_reset_handler_init();
-	tegra_apb_io_init();
-	tegra_init_fuse();
-	tegra_init_cache();
-	tegra_pmc_init();
-	tegra_powergate_init();
+	tegra_init_early();
 	tegra30_hotplug_init();
 }
 #endif
 
+#ifdef CONFIG_ARCH_TEGRA_114_SOC
+void __init tegra114_init_early(void)
+{
+	tegra_init_early();
+}
+#endif
+
 void __init tegra_init_late(void)
 {
 	tegra_powergate_debugfs_init();
-- 
1.7.9.5

