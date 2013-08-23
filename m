Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab3HWM25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:28:57 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:64884 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab3HWMYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:38 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 24/40] ARM: ux500: Deactivate enablement of DMA40 during ATAG booting
Date: Fri, 23 Aug 2013 13:23:24 +0100
Message-Id: <1377260620-18829-25-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
References: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's time to remove all ATAG support from ux500 and rely solely on
Device Tree booting. This patch is part of that endeavour.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.h   |  1 -
 arch/arm/mach-ux500/cpu-db8500.c     |  2 --
 arch/arm/mach-ux500/devices-db8500.c | 36 ------------------------------------
 arch/arm/mach-ux500/devices.h        |  2 --
 4 files changed, 41 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index 06eb894..3b35a73 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -92,7 +92,6 @@ extern struct amba_pl011_data uart0_plat;
 extern struct amba_pl011_data uart1_plat;
 extern struct amba_pl011_data uart2_plat;
 extern struct pl022_ssp_controller ssp0_plat;
-extern struct stedma40_platform_data dma40_plat_data;
 
 void __init mop500_u8500uib_init(void);
 void __init mop500_stuib_init(void);
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 69cee39..1289a67 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -33,7 +33,6 @@
 #include "irqs.h"
 
 #include "devices-db8500.h"
-#include "ste-dma40-db8500.h"
 #include "db8500-regs.h"
 #include "board-mop500.h"
 #include "id.h"
@@ -135,7 +134,6 @@ static struct platform_device db8500_pmu_device = {
 };
 
 static struct platform_device *platform_devs[] __initdata = {
-	&u8500_dma40_device,
 	&db8500_pmu_device,
 };
 
diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index d30205b..1b2faba 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -11,7 +11,6 @@
 #include <linux/io.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/pl022.h>
-#include <linux/platform_data/dma-ste-dma40.h>
 #include <linux/mfd/dbx500-prcmu.h>
 
 #include "setup.h"
@@ -19,41 +18,6 @@
 
 #include "db8500-regs.h"
 #include "devices-db8500.h"
-#include "ste-dma40-db8500.h"
-
-static struct resource dma40_resources[] = {
-	[0] = {
-		.start = U8500_DMA_BASE,
-		.end   = U8500_DMA_BASE + SZ_4K - 1,
-		.flags = IORESOURCE_MEM,
-		.name  = "base",
-	},
-	[1] = {
-		.start = U8500_DMA_LCPA_BASE,
-		.end   = U8500_DMA_LCPA_BASE + 2 * SZ_1K - 1,
-		.flags = IORESOURCE_MEM,
-		.name  = "lcpa",
-	},
-	[2] = {
-		.start = IRQ_DB8500_DMA,
-		.end   = IRQ_DB8500_DMA,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-struct stedma40_platform_data dma40_plat_data = {
-	.disabled_channels = {-1},
-};
-
-struct platform_device u8500_dma40_device = {
-	.dev = {
-		.platform_data = &dma40_plat_data,
-	},
-	.name = "dma40",
-	.id = 0,
-	.num_resources = ARRAY_SIZE(dma40_resources),
-	.resource = dma40_resources
-};
 
 struct prcmu_pdata db8500_prcmu_pdata = {
 	.ab_platdata	= &ab8500_platdata,
diff --git a/arch/arm/mach-ux500/devices.h b/arch/arm/mach-ux500/devices.h
index da23c05..5bca7c6 100644
--- a/arch/arm/mach-ux500/devices.h
+++ b/arch/arm/mach-ux500/devices.h
@@ -12,6 +12,4 @@ struct amba_device;
 
 extern struct amba_device ux500_pl031_device;
 
-extern struct platform_device u8500_dma40_device;
-
 #endif
-- 
1.8.1.2

