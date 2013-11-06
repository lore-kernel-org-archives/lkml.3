Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab3KFKHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:07:42 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:37056 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab3KFKGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:06:00 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/7] ARM: ux500: Consolidate [A|D]8500 platform data
Date: Wed,  6 Nov 2013 10:05:43 +0000
Message-Id: <1383732348-18576-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732348-18576-1-git-send-email-lee.jones@linaro.org>
References: <1383732348-18576-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the platform data from all these files into one, delete empty
files and remove all references to them.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/Makefile             |  4 +--
 arch/arm/mach-ux500/board-mop500-audio.c |  2 --
 arch/arm/mach-ux500/board-mop500-sdi.c   |  2 --
 arch/arm/mach-ux500/board-mop500.c       | 48 --------------------------------
 arch/arm/mach-ux500/cpu-db8500.c         | 18 ++++++++++--
 arch/arm/mach-ux500/cpu.c                |  1 -
 arch/arm/mach-ux500/devices-db8500.c     | 28 -------------------
 arch/arm/mach-ux500/devices-db8500.h     | 19 -------------
 arch/arm/mach-ux500/devices.h            | 15 ----------
 9 files changed, 17 insertions(+), 120 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/board-mop500.c
 delete mode 100644 arch/arm/mach-ux500/devices-db8500.c
 delete mode 100644 arch/arm/mach-ux500/devices-db8500.h
 delete mode 100644 arch/arm/mach-ux500/devices.h

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 616b96e..66f351f 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -4,8 +4,8 @@
 
 obj-y				:= cpu.o devices.o id.o timer.o pm.o
 obj-$(CONFIG_CACHE_L2X0)	+= cache-l2x0.o
-obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o devices-db8500.o
-obj-$(CONFIG_MACH_MOP500)	+= board-mop500.o board-mop500-sdi.o \
+obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o
+obj-$(CONFIG_MACH_MOP500)	+= board-mop500-sdi.o \
 				board-mop500-regulators.o \
 				board-mop500-pins.o \
 				board-mop500-audio.o
diff --git a/arch/arm/mach-ux500/board-mop500-audio.c b/arch/arm/mach-ux500/board-mop500-audio.c
index 154e15f..d528059 100644
--- a/arch/arm/mach-ux500/board-mop500-audio.c
+++ b/arch/arm/mach-ux500/board-mop500-audio.c
@@ -10,13 +10,11 @@
 #include <linux/platform_data/pinctrl-nomadik.h>
 #include <linux/platform_data/dma-ste-dma40.h>
 
-#include "devices.h"
 #include "irqs.h"
 #include <linux/platform_data/asoc-ux500-msp.h>
 
 #include "ste-dma40-db8500.h"
 #include "board-mop500.h"
-#include "devices-db8500.h"
 
 static struct stedma40_chan_cfg msp0_dma_rx = {
 	.high_priority = true,
diff --git a/arch/arm/mach-ux500/board-mop500-sdi.c b/arch/arm/mach-ux500/board-mop500-sdi.c
index 26600a1..fcbf3a1 100644
--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ b/arch/arm/mach-ux500/board-mop500-sdi.c
@@ -14,10 +14,8 @@
 #include <linux/platform_data/dma-ste-dma40.h>
 
 #include <asm/mach-types.h>
-#include "devices.h"
 
 #include "db8500-regs.h"
-#include "devices-db8500.h"
 #include "board-mop500.h"
 #include "ste-dma40-db8500.h"
 
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
deleted file mode 100644
index d552163..0000000
--- a/arch/arm/mach-ux500/board-mop500.c
+++ /dev/null
@@ -1,48 +0,0 @@
-/*
- * Copyright (C) 2008-2012 ST-Ericsson
- *
- * Author: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2, as
- * published by the Free Software Foundation.
- *
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/clk.h>
-#include <linux/io.h>
-#include <linux/platform_data/db8500_thermal.h>
-#include <linux/amba/bus.h>
-#include <linux/amba/pl022.h>
-#include <linux/mfd/abx500/ab8500.h>
-#include <linux/regulator/ab8500.h>
-#include <linux/regulator/fixed.h>
-#include <linux/regulator/driver.h>
-#include <linux/mfd/tps6105x.h>
-#include <linux/platform_data/leds-lp55xx.h>
-#include <linux/input.h>
-#include <linux/delay.h>
-#include <linux/leds.h>
-#include <linux/pinctrl/consumer.h>
-#include <linux/platform_data/pinctrl-nomadik.h>
-#include <linux/platform_data/dma-ste-dma40.h>
-
-#include <asm/mach-types.h>
-
-#include "setup.h"
-#include "devices.h"
-#include "irqs.h"
-
-#include "ste-dma40-db8500.h"
-#include "db8500-regs.h"
-#include "devices-db8500.h"
-#include "board-mop500.h"
-#include "board-mop500-regulators.h"
-
-struct ab8500_platform_data ab8500_platdata = {
-	.irq_base	= MOP500_AB8500_IRQ_BASE,
-	.regulator	= &ab8500_regulator_plat_data,
-};
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 2e85c1e..0b5b27b 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -28,14 +28,26 @@
 #include <asm/mach/map.h>
 
 #include "setup.h"
-#include "devices.h"
 #include "irqs.h"
 
-#include "devices-db8500.h"
-#include "db8500-regs.h"
+#include "board-mop500-regulators.h"
 #include "board-mop500.h"
+#include "db8500-regs.h"
 #include "id.h"
 
+struct ab8500_platform_data ab8500_platdata = {
+	.irq_base	= MOP500_AB8500_IRQ_BASE,
+	.regulator	= &ab8500_regulator_plat_data,
+};
+
+struct prcmu_pdata db8500_prcmu_pdata = {
+	.ab_platdata	= &ab8500_platdata,
+	.ab_irq		= IRQ_DB8500_AB8500,
+	.irq_base	= IRQ_PRCMU_BASE,
+	.version_offset	= DB8500_PRCMU_FW_VERSION_OFFSET,
+	.legacy_offset	= DB8500_PRCMU_LEGACY_OFFSET,
+};
+
 /* minimum static i/o mapping required to boot U8500 platforms */
 static struct map_desc u8500_uart_io_desc[] __initdata = {
 	__IO_DEV_DESC(U8500_UART0_BASE, SZ_4K),
diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index f84d439..8f8004f 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -25,7 +25,6 @@
 #include <asm/mach/map.h>
 
 #include "setup.h"
-#include "devices.h"
 
 #include "board-mop500.h"
 #include "db8500-regs.h"
diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
deleted file mode 100644
index c59f89d..0000000
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
- * License terms: GNU General Public License (GPL) version 2
- */
-
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-#include <linux/amba/bus.h>
-#include <linux/amba/pl022.h>
-#include <linux/mfd/dbx500-prcmu.h>
-
-#include "setup.h"
-#include "irqs.h"
-
-#include "db8500-regs.h"
-#include "devices-db8500.h"
-
-struct prcmu_pdata db8500_prcmu_pdata = {
-	.ab_platdata	= &ab8500_platdata,
-	.ab_irq		= IRQ_DB8500_AB8500,
-	.irq_base	= IRQ_PRCMU_BASE,
-	.version_offset	= DB8500_PRCMU_FW_VERSION_OFFSET,
-	.legacy_offset	= DB8500_PRCMU_LEGACY_OFFSET,
-};
diff --git a/arch/arm/mach-ux500/devices-db8500.h b/arch/arm/mach-ux500/devices-db8500.h
deleted file mode 100644
index b8ffc99..0000000
--- a/arch/arm/mach-ux500/devices-db8500.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
- * License terms: GNU General Public License (GPL), version 2.
- */
-
-#ifndef __DEVICES_DB8500_H
-#define __DEVICES_DB8500_H
-
-#include "irqs.h"
-#include "db8500-regs.h"
-
-struct platform_device;
-
-extern struct ab8500_platform_data ab8500_platdata;
-extern struct prcmu_pdata db8500_prcmu_pdata;
-
-#endif
diff --git a/arch/arm/mach-ux500/devices.h b/arch/arm/mach-ux500/devices.h
deleted file mode 100644
index 5bca7c6..0000000
--- a/arch/arm/mach-ux500/devices.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * License terms: GNU General Public License (GPL) version 2
- */
-
-#ifndef __ASM_ARCH_DEVICES_H__
-#define __ASM_ARCH_DEVICES_H__
-
-struct platform_device;
-struct amba_device;
-
-extern struct amba_device ux500_pl031_device;
-
-#endif
-- 
1.8.1.2

