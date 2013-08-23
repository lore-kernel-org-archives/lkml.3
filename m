Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab3HWM3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:29:23 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:57912 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615Ab3HWMYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:36 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 23/40] ARM: ux500: Stop enabling GPIOs when not booting with Device Tree
Date: Fri, 23 Aug 2013 13:23:23 +0100
Message-Id: <1377260620-18829-24-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500.c   |  2 --
 arch/arm/mach-ux500/cpu-db8500.c     | 24 ---------------
 arch/arm/mach-ux500/devices-common.c | 60 ------------------------------------
 arch/arm/mach-ux500/devices-common.h |  5 ---
 arch/arm/mach-ux500/devices-db8500.c |  1 -
 arch/arm/mach-ux500/devices.h        |  2 --
 6 files changed, 94 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/devices-common.c

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index d53d672..7763c5b 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -15,7 +15,6 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/platform_data/db8500_thermal.h>
-#include <linux/gpio.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/pl022.h>
 #include <linux/amba/serial.h>
@@ -25,7 +24,6 @@
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/driver.h>
 #include <linux/mfd/tps6105x.h>
-#include <linux/mfd/abx500/ab8500-gpio.h>
 #include <linux/platform_data/leds-lp55xx.h>
 #include <linux/input.h>
 #include <linux/delay.h>
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 33264f5..69cee39 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -139,28 +139,6 @@ static struct platform_device *platform_devs[] __initdata = {
 	&db8500_pmu_device,
 };
 
-static resource_size_t __initdata db8500_gpio_base[] = {
-	U8500_GPIOBANK0_BASE,
-	U8500_GPIOBANK1_BASE,
-	U8500_GPIOBANK2_BASE,
-	U8500_GPIOBANK3_BASE,
-	U8500_GPIOBANK4_BASE,
-	U8500_GPIOBANK5_BASE,
-	U8500_GPIOBANK6_BASE,
-	U8500_GPIOBANK7_BASE,
-	U8500_GPIOBANK8_BASE,
-};
-
-static void __init db8500_add_gpios(struct device *parent)
-{
-	struct nmk_gpio_platform_data pdata = {
-		.supports_sleepmode = true,
-	};
-
-	dbx500_add_gpios(parent, ARRAY_AND_SIZE(db8500_gpio_base),
-			 IRQ_DB8500_GPIO0, &pdata);
-}
-
 static const char *db8500_read_soc_id(void)
 {
 	void __iomem *uid = __io_address(U8500_BB_UID_BASE);
@@ -190,8 +168,6 @@ struct device * __init u8500_init_devices(void)
 
 	parent = db8500_soc_device_init();
 
-	db8500_add_gpios(parent);
-
 	for (i = 0; i < ARRAY_SIZE(platform_devs); i++)
 		platform_devs[i]->dev.parent = parent;
 
diff --git a/arch/arm/mach-ux500/devices-common.c b/arch/arm/mach-ux500/devices-common.c
deleted file mode 100644
index f71b3d7..0000000
--- a/arch/arm/mach-ux500/devices-common.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
- * License terms: GNU General Public License (GPL), version 2.
- */
-
-#include <linux/kernel.h>
-#include <linux/dma-mapping.h>
-#include <linux/err.h>
-#include <linux/irq.h>
-#include <linux/slab.h>
-#include <linux/platform_device.h>
-#include <linux/platform_data/pinctrl-nomadik.h>
-
-#include "irqs.h"
-
-#include "devices-common.h"
-
-static struct platform_device *
-dbx500_add_gpio(struct device *parent, int id, resource_size_t addr, int irq,
-		struct nmk_gpio_platform_data *pdata)
-{
-	struct resource resources[] = {
-		{
-			.start	= addr,
-			.end	= addr + 127,
-			.flags	= IORESOURCE_MEM,
-		},
-		{
-			.start	= irq,
-			.end	= irq,
-			.flags	= IORESOURCE_IRQ,
-		}
-	};
-
-	return platform_device_register_resndata(
-		parent,
-		"gpio",
-		id,
-		resources,
-		ARRAY_SIZE(resources),
-		pdata,
-		sizeof(*pdata));
-}
-
-void dbx500_add_gpios(struct device *parent, resource_size_t *base, int num,
-		      int irq, struct nmk_gpio_platform_data *pdata)
-{
-	int first = 0;
-	int i;
-
-	for (i = 0; i < num; i++, first += 32, irq++) {
-		pdata->first_gpio = first;
-		pdata->first_irq = NOMADIK_GPIO_TO_IRQ(first);
-		pdata->num_gpio = 32;
-
-		dbx500_add_gpio(parent, i, base[i], irq, pdata);
-	}
-}
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index 7167b69..ce48a02 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -33,9 +33,4 @@ dbx500_add_uart(struct device *parent, const char *name, resource_size_t base,
 	return amba_ahb_device_add(parent, name, base, SZ_4K, irq, 0, pdata, 0);
 }
 
-struct nmk_gpio_platform_data;
-
-void dbx500_add_gpios(struct device *parent, resource_size_t *base, int num,
-		      int irq, struct nmk_gpio_platform_data *pdata);
-
 #endif
diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 3c5393b..d30205b 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -9,7 +9,6 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
-#include <linux/gpio.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/pl022.h>
 #include <linux/platform_data/dma-ste-dma40.h>
diff --git a/arch/arm/mach-ux500/devices.h b/arch/arm/mach-ux500/devices.h
index eafb07a..da23c05 100644
--- a/arch/arm/mach-ux500/devices.h
+++ b/arch/arm/mach-ux500/devices.h
@@ -10,8 +10,6 @@
 struct platform_device;
 struct amba_device;
 
-extern struct platform_device u8500_gpio_devs[];
-
 extern struct amba_device ux500_pl031_device;
 
 extern struct platform_device u8500_dma40_device;
-- 
1.8.1.2

