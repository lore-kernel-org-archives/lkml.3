Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbaBKKaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:30:19 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45254 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaBKKaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:30:11 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>
Subject: [PATCH] mfd: dbx500/abx500: root out hardcoded IRQ assignments
Date: Tue, 11 Feb 2014 11:29:59 +0100
Message-Id: <1392114599-481-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DBx500 and ABx500 should be getting their IRQs from the
device tree and nowhere else. Get rid of all the static assignments
everywhere, delete it from the driver, platform data and the
board files in one swift strike.

Lots of cross-dependencies in the MFD drivers for PRCMU and
AB8500 makes it necessary to strike everywhere at once to
eradicate IRQs passed as resources and platform data to the left
and right around the platform.

Cc: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Sam/Lee: I'm looking for an ACK on this to take the result through
ARM SoC.

I've been ambivalent on how to look up the IRQ resource for the
AB8500 from the device tree (as it is hanging off the main GIC
interrupt controller rather than the PRCMU) and eventually ended
up with this solution. I experimented with modifying mfd-core.c
to add resources from the device tree, but I didn't like the
result, it seems MFD cells should get their resources exclusively
from the parent instantiating the cell, so I ended up with this.

Maybe Broonie has ideas about this too?
---
 arch/arm/mach-ux500/board-mop500-audio.c |   1 -
 arch/arm/mach-ux500/cpu-db8500.c         |   4 -
 arch/arm/mach-ux500/irqs-board-mop500.h  |  55 --------------
 arch/arm/mach-ux500/irqs-db8500.h        | 125 -------------------------------
 arch/arm/mach-ux500/irqs.h               |  49 ------------
 drivers/mfd/ab8500-core.c                |  27 +++----
 drivers/mfd/db8500-prcmu.c               |  34 ++++++---
 include/linux/mfd/abx500/ab8500.h        |   2 -
 include/linux/mfd/dbx500-prcmu.h         |   2 -
 9 files changed, 36 insertions(+), 263 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/irqs-board-mop500.h
 delete mode 100644 arch/arm/mach-ux500/irqs-db8500.h
 delete mode 100644 arch/arm/mach-ux500/irqs.h

diff --git a/arch/arm/mach-ux500/board-mop500-audio.c b/arch/arm/mach-ux500/board-mop500-audio.c
index 9309ad4cbd09..b2a0899e7453 100644
--- a/arch/arm/mach-ux500/board-mop500-audio.c
+++ b/arch/arm/mach-ux500/board-mop500-audio.c
@@ -9,7 +9,6 @@
 #include <linux/gpio.h>
 #include <linux/platform_data/dma-ste-dma40.h>
 
-#include "irqs.h"
 #include <linux/platform_data/asoc-ux500-msp.h>
 
 #include "ste-dma40-db8500.h"
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 180b3c59be36..c20b0d962053 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -27,7 +27,6 @@
 #include <asm/mach/map.h>
 
 #include "setup.h"
-#include "irqs.h"
 
 #include "board-mop500-regulators.h"
 #include "board-mop500.h"
@@ -35,14 +34,11 @@
 #include "id.h"
 
 struct ab8500_platform_data ab8500_platdata = {
-	.irq_base	= MOP500_AB8500_IRQ_BASE,
 	.regulator	= &ab8500_regulator_plat_data,
 };
 
 struct prcmu_pdata db8500_prcmu_pdata = {
 	.ab_platdata	= &ab8500_platdata,
-	.ab_irq		= IRQ_DB8500_AB8500,
-	.irq_base	= IRQ_PRCMU_BASE,
 	.version_offset	= DB8500_PRCMU_FW_VERSION_OFFSET,
 	.legacy_offset	= DB8500_PRCMU_LEGACY_OFFSET,
 };
diff --git a/arch/arm/mach-ux500/irqs-board-mop500.h b/arch/arm/mach-ux500/irqs-board-mop500.h
deleted file mode 100644
index d526dd8e87d3..000000000000
--- a/arch/arm/mach-ux500/irqs-board-mop500.h
+++ /dev/null
@@ -1,55 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Rabin Vincent <rabin.vincent@stericsson.com>
- * License terms: GNU General Public License (GPL) version 2
- */
-
-#ifndef __MACH_IRQS_BOARD_MOP500_H
-#define __MACH_IRQS_BOARD_MOP500_H
-
-/* Number of AB8500 irqs is taken from header file */
-#include <linux/mfd/abx500/ab8500.h>
-
-#define MOP500_AB8500_IRQ_BASE		IRQ_BOARD_START
-#define MOP500_AB8500_IRQ_END		(MOP500_AB8500_IRQ_BASE \
-					 + AB8500_MAX_NR_IRQS)
-
-/* TC35892 */
-#define TC35892_NR_INTERNAL_IRQS	8
-#define TC35892_INT_GPIO(x)		(TC35892_NR_INTERNAL_IRQS + (x))
-#define TC35892_NR_GPIOS		24
-#define TC35892_NR_IRQS			TC35892_INT_GPIO(TC35892_NR_GPIOS)
-
-#define MOP500_EGPIO_NR_IRQS		TC35892_NR_IRQS
-
-#define MOP500_EGPIO_IRQ_BASE		MOP500_AB8500_IRQ_END
-#define MOP500_EGPIO_IRQ_END		(MOP500_EGPIO_IRQ_BASE \
-					 + MOP500_EGPIO_NR_IRQS)
-/* STMPE1601 irqs */
-#define STMPE_NR_INTERNAL_IRQS          9
-#define STMPE_INT_GPIO(x)               (STMPE_NR_INTERNAL_IRQS + (x))
-#define STMPE_NR_GPIOS                  24
-#define STMPE_NR_IRQS                   STMPE_INT_GPIO(STMPE_NR_GPIOS)
-
-#define MOP500_STMPE1601_IRQBASE        MOP500_EGPIO_IRQ_END
-#define MOP500_STMPE1601_IRQ(x)         (MOP500_STMPE1601_IRQBASE + (x))
-
-#define MOP500_STMPE1601_IRQ_END	\
-	MOP500_STMPE1601_IRQ(STMPE_NR_INTERNAL_IRQS)
-
-#define MOP500_NR_IRQS		MOP500_STMPE1601_IRQ_END
-
-#define MOP500_IRQ_END		MOP500_NR_IRQS
-
-/*
- * We may have several boards, but only one will run at a
- * time, so the one with most IRQs will bump this ahead,
- * but the IRQ_BOARD_START remains the same for either board.
- */
-#if MOP500_IRQ_END > IRQ_BOARD_END
-#undef IRQ_BOARD_END
-#define IRQ_BOARD_END	MOP500_IRQ_END
-#endif
-
-#endif
diff --git a/arch/arm/mach-ux500/irqs-db8500.h b/arch/arm/mach-ux500/irqs-db8500.h
deleted file mode 100644
index f3a9d5947ef3..000000000000
--- a/arch/arm/mach-ux500/irqs-db8500.h
+++ /dev/null
@@ -1,125 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Rabin Vincent <rabin.vincent@stericsson.com>
- * License terms: GNU General Public License (GPL) version 2
- */
-
-#ifndef __MACH_IRQS_DB8500_H
-#define __MACH_IRQS_DB8500_H
-
-#define IRQ_DB8500_MTU0			(IRQ_SHPI_START + 4)
-#define IRQ_DB8500_SPI2			(IRQ_SHPI_START + 6)
-#define IRQ_DB8500_PMU			(IRQ_SHPI_START + 7)
-#define IRQ_DB8500_SPI0			(IRQ_SHPI_START + 8)
-#define IRQ_DB8500_RTT			(IRQ_SHPI_START + 9)
-#define IRQ_DB8500_PKA			(IRQ_SHPI_START + 10)
-#define IRQ_DB8500_UART0		(IRQ_SHPI_START + 11)
-#define IRQ_DB8500_I2C3			(IRQ_SHPI_START + 12)
-#define IRQ_DB8500_L2CC			(IRQ_SHPI_START + 13)
-#define IRQ_DB8500_SSP0			(IRQ_SHPI_START + 14)
-#define IRQ_DB8500_CRYP1		(IRQ_SHPI_START + 15)
-#define IRQ_DB8500_MSP1_RX		(IRQ_SHPI_START + 16)
-#define IRQ_DB8500_MTU1			(IRQ_SHPI_START + 17)
-#define IRQ_DB8500_RTC			(IRQ_SHPI_START + 18)
-#define IRQ_DB8500_UART1		(IRQ_SHPI_START + 19)
-#define IRQ_DB8500_USB_WAKEUP		(IRQ_SHPI_START + 20)
-#define IRQ_DB8500_I2C0			(IRQ_SHPI_START + 21)
-#define IRQ_DB8500_I2C1			(IRQ_SHPI_START + 22)
-#define IRQ_DB8500_USBOTG		(IRQ_SHPI_START + 23)
-#define IRQ_DB8500_DMA_SECURE		(IRQ_SHPI_START + 24)
-#define IRQ_DB8500_DMA			(IRQ_SHPI_START + 25)
-#define IRQ_DB8500_UART2		(IRQ_SHPI_START + 26)
-#define IRQ_DB8500_ICN_PMU1		(IRQ_SHPI_START + 27)
-#define IRQ_DB8500_ICN_PMU2		(IRQ_SHPI_START + 28)
-#define IRQ_DB8500_HSIR_EXCEP		(IRQ_SHPI_START + 29)
-#define IRQ_DB8500_MSP0			(IRQ_SHPI_START + 31)
-#define IRQ_DB8500_HSIR_CH0_OVRRUN	(IRQ_SHPI_START + 32)
-#define IRQ_DB8500_HSIR_CH1_OVRRUN	(IRQ_SHPI_START + 33)
-#define IRQ_DB8500_HSIR_CH2_OVRRUN	(IRQ_SHPI_START + 34)
-#define IRQ_DB8500_HSIR_CH3_OVRRUN	(IRQ_SHPI_START + 35)
-#define IRQ_DB8500_HSIR_CH4_OVRRUN	(IRQ_SHPI_START + 36)
-#define IRQ_DB8500_HSIR_CH5_OVRRUN	(IRQ_SHPI_START + 37)
-#define IRQ_DB8500_HSIR_CH6_OVRRUN	(IRQ_SHPI_START + 38)
-#define IRQ_DB8500_HSIR_CH7_OVRRUN	(IRQ_SHPI_START + 39)
-#define IRQ_DB8500_AB8500		(IRQ_SHPI_START + 40)
-#define IRQ_DB8500_SDMMC2		(IRQ_SHPI_START + 41)
-#define IRQ_DB8500_SIA			(IRQ_SHPI_START + 42)
-#define IRQ_DB8500_SIA2			(IRQ_SHPI_START + 43)
-#define IRQ_DB8500_SVA			(IRQ_SHPI_START + 44)
-#define IRQ_DB8500_SVA2			(IRQ_SHPI_START + 45)
-#define IRQ_DB8500_PRCMU0		(IRQ_SHPI_START + 46)
-#define IRQ_DB8500_PRCMU1		(IRQ_SHPI_START + 47)
-#define IRQ_DB8500_DISP			(IRQ_SHPI_START + 48)
-#define IRQ_DB8500_SPI3			(IRQ_SHPI_START + 49)
-#define IRQ_DB8500_SDMMC1		(IRQ_SHPI_START + 50)
-#define IRQ_DB8500_I2C4			(IRQ_SHPI_START + 51)
-#define IRQ_DB8500_SSP1			(IRQ_SHPI_START + 52)
-#define IRQ_DB8500_SKE			(IRQ_SHPI_START + 53)
-#define IRQ_DB8500_KB			(IRQ_SHPI_START + 54)
-#define IRQ_DB8500_I2C2			(IRQ_SHPI_START + 55)
-#define IRQ_DB8500_B2R2			(IRQ_SHPI_START + 56)
-#define IRQ_DB8500_CRYP0		(IRQ_SHPI_START + 57)
-#define IRQ_DB8500_SDMMC3		(IRQ_SHPI_START + 59)
-#define IRQ_DB8500_SDMMC0		(IRQ_SHPI_START + 60)
-#define IRQ_DB8500_HSEM			(IRQ_SHPI_START + 61)
-#define IRQ_DB8500_MSP1			(IRQ_SHPI_START + 62)
-#define IRQ_DB8500_SBAG			(IRQ_SHPI_START + 63)
-#define IRQ_DB8500_SPI1			(IRQ_SHPI_START + 96)
-#define IRQ_DB8500_SRPTIMER		(IRQ_SHPI_START + 97)
-#define IRQ_DB8500_MSP2			(IRQ_SHPI_START + 98)
-#define IRQ_DB8500_SDMMC4		(IRQ_SHPI_START + 99)
-#define IRQ_DB8500_SDMMC5		(IRQ_SHPI_START + 100)
-#define IRQ_DB8500_HSIRD0		(IRQ_SHPI_START + 104)
-#define IRQ_DB8500_HSIRD1		(IRQ_SHPI_START + 105)
-#define IRQ_DB8500_HSITD0		(IRQ_SHPI_START + 106)
-#define IRQ_DB8500_HSITD1		(IRQ_SHPI_START + 107)
-#define IRQ_DB8500_CTI0			(IRQ_SHPI_START + 108)
-#define IRQ_DB8500_CTI1			(IRQ_SHPI_START + 109)
-#define IRQ_DB8500_ICN_ERR		(IRQ_SHPI_START + 110)
-#define IRQ_DB8500_MALI_PPMMU		(IRQ_SHPI_START + 112)
-#define IRQ_DB8500_MALI_PP		(IRQ_SHPI_START + 113)
-#define IRQ_DB8500_MALI_GPMMU		(IRQ_SHPI_START + 114)
-#define IRQ_DB8500_MALI_GP		(IRQ_SHPI_START + 115)
-#define IRQ_DB8500_MALI			(IRQ_SHPI_START + 116)
-#define IRQ_DB8500_PRCMU_SEM		(IRQ_SHPI_START + 118)
-#define IRQ_DB8500_GPIO0		(IRQ_SHPI_START + 119)
-#define IRQ_DB8500_GPIO1		(IRQ_SHPI_START + 120)
-#define IRQ_DB8500_GPIO2		(IRQ_SHPI_START + 121)
-#define IRQ_DB8500_GPIO3		(IRQ_SHPI_START + 122)
-#define IRQ_DB8500_GPIO4		(IRQ_SHPI_START + 123)
-#define IRQ_DB8500_GPIO5		(IRQ_SHPI_START + 124)
-#define IRQ_DB8500_GPIO6		(IRQ_SHPI_START + 125)
-#define IRQ_DB8500_GPIO7		(IRQ_SHPI_START + 126)
-#define IRQ_DB8500_GPIO8		(IRQ_SHPI_START + 127)
-
-#define IRQ_CA_WAKE_REQ_ED			(IRQ_SHPI_START + 71)
-#define IRQ_AC_READ_NOTIFICATION_0_ED		(IRQ_SHPI_START + 66)
-#define IRQ_AC_READ_NOTIFICATION_1_ED		(IRQ_SHPI_START + 64)
-#define IRQ_CA_MSG_PEND_NOTIFICATION_0_ED	(IRQ_SHPI_START + 67)
-#define IRQ_CA_MSG_PEND_NOTIFICATION_1_ED	(IRQ_SHPI_START + 65)
-
-#define IRQ_CA_WAKE_REQ_V1			(IRQ_SHPI_START + 83)
-#define IRQ_AC_READ_NOTIFICATION_0_V1		(IRQ_SHPI_START + 78)
-#define IRQ_AC_READ_NOTIFICATION_1_V1		(IRQ_SHPI_START + 76)
-#define IRQ_CA_MSG_PEND_NOTIFICATION_0_V1	(IRQ_SHPI_START + 79)
-#define IRQ_CA_MSG_PEND_NOTIFICATION_1_V1	(IRQ_SHPI_START + 77)
-
-#ifdef CONFIG_UX500_SOC_DB8500
-
-/* Virtual interrupts corresponding to the PRCMU wakeups.  */
-#define IRQ_PRCMU_BASE IRQ_SOC_START
-#define IRQ_PRCMU_END (IRQ_PRCMU_BASE + 23)
-
-/*
- * We may have several SoCs, but only one will run at a
- * time, so the one with most IRQs will bump this ahead,
- * but the IRQ_SOC_START remains the same for either SoC.
- */
-#if IRQ_SOC_END < IRQ_PRCMU_END
-#undef IRQ_SOC_END
-#define IRQ_SOC_END IRQ_PRCMU_END
-#endif
-
-#endif /* CONFIG_UX500_SOC_DB8500 */
-#endif
diff --git a/arch/arm/mach-ux500/irqs.h b/arch/arm/mach-ux500/irqs.h
deleted file mode 100644
index 15b2af698ed7..000000000000
--- a/arch/arm/mach-ux500/irqs.h
+++ /dev/null
@@ -1,49 +0,0 @@
-/*
- *  Copyright (C) 2008 STMicroelectronics
- *  Copyright (C) 2009 ST-Ericsson.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-#ifndef ASM_ARCH_IRQS_H
-#define ASM_ARCH_IRQS_H
-
-#define IRQ_LOCALTIMER			29
-#define IRQ_LOCALWDOG			30
-
-/* Shared Peripheral Interrupt (SHPI) */
-#define IRQ_SHPI_START			32
-
-/*
- * MTU0 preserved for now until plat-nomadik is taught not to use it.  Don't
- * add any other IRQs here, use the irqs-dbx500.h files.
- */
-#define IRQ_MTU0		(IRQ_SHPI_START + 4)
-
-#define DBX500_NR_INTERNAL_IRQS		166
-
-/* After chip-specific IRQ numbers we have the GPIO ones */
-#define NOMADIK_NR_GPIO			288
-#define NOMADIK_GPIO_TO_IRQ(gpio)	((gpio) + DBX500_NR_INTERNAL_IRQS)
-#define NOMADIK_IRQ_TO_GPIO(irq)	((irq) - DBX500_NR_INTERNAL_IRQS)
-#define IRQ_GPIO_END			NOMADIK_GPIO_TO_IRQ(NOMADIK_NR_GPIO)
-
-#define IRQ_SOC_START		IRQ_GPIO_END
-/* This will be overridden by SoC-specific irq headers */
-#define IRQ_SOC_END		IRQ_SOC_START
-
-#include "irqs-db8500.h"
-
-#define IRQ_BOARD_START		IRQ_SOC_END
-/* This will be overridden by board-specific irq headers */
-#define IRQ_BOARD_END		IRQ_BOARD_START
-
-#ifdef CONFIG_MACH_MOP500
-#include "irqs-board-mop500.h"
-#endif
-
-#define UX500_NR_IRQS		IRQ_BOARD_END
-
-#endif /* ASM_ARCH_IRQS_H */
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index aaff683cd37d..a8ee4a36a1d8 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -592,7 +592,7 @@ static int ab8500_irq_init(struct ab8500 *ab8500, struct device_node *np)
 
 	/* If ->irq_base is zero this will give a linear mapping */
 	ab8500->domain = irq_domain_add_simple(NULL,
-			num_irqs, ab8500->irq_base,
+			num_irqs, 0,
 			&ab8500_irq_ops, ab8500);
 
 	if (!ab8500->domain) {
@@ -1583,14 +1583,13 @@ static int ab8500_probe(struct platform_device *pdev)
 	if (!ab8500)
 		return -ENOMEM;
 
-	if (plat)
-		ab8500->irq_base = plat->irq_base;
-
 	ab8500->dev = &pdev->dev;
 
 	resource = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!resource)
+	if (!resource) {
+		dev_err(&pdev->dev, "no IRQ resource\n");
 		return -ENODEV;
+	}
 
 	ab8500->irq = resource->start;
 
@@ -1612,8 +1611,10 @@ static int ab8500_probe(struct platform_device *pdev)
 	else {
 		ret = get_register_interruptible(ab8500, AB8500_MISC,
 			AB8500_IC_NAME_REG, &value);
-		if (ret < 0)
+		if (ret < 0) {
+			dev_err(&pdev->dev, "could not probe HW\n");
 			return ret;
+		}
 
 		ab8500->version = value;
 	}
@@ -1759,30 +1760,30 @@ static int ab8500_probe(struct platform_device *pdev)
 	if (is_ab9540(ab8500))
 		ret = mfd_add_devices(ab8500->dev, 0, ab9540_devs,
 				ARRAY_SIZE(ab9540_devs), NULL,
-				ab8500->irq_base, ab8500->domain);
+				0, ab8500->domain);
 	else if (is_ab8540(ab8500)) {
 		ret = mfd_add_devices(ab8500->dev, 0, ab8540_devs,
 			      ARRAY_SIZE(ab8540_devs), NULL,
-			      ab8500->irq_base, NULL);
+			      0, ab8500->domain);
 		if (ret)
 			return ret;
 
 		if (is_ab8540_1p2_or_earlier(ab8500))
 			ret = mfd_add_devices(ab8500->dev, 0, ab8540_cut1_devs,
 			      ARRAY_SIZE(ab8540_cut1_devs), NULL,
-			      ab8500->irq_base, NULL);
+			      0, ab8500->domain);
 		else /* ab8540 >= cut2 */
 			ret = mfd_add_devices(ab8500->dev, 0, ab8540_cut2_devs,
 			      ARRAY_SIZE(ab8540_cut2_devs), NULL,
-			      ab8500->irq_base, NULL);
+			      0, ab8500->domain);
 	} else if (is_ab8505(ab8500))
 		ret = mfd_add_devices(ab8500->dev, 0, ab8505_devs,
 			      ARRAY_SIZE(ab8505_devs), NULL,
-			      ab8500->irq_base, ab8500->domain);
+			      0, ab8500->domain);
 	else
 		ret = mfd_add_devices(ab8500->dev, 0, ab8500_devs,
 				ARRAY_SIZE(ab8500_devs), NULL,
-				ab8500->irq_base, ab8500->domain);
+				0, ab8500->domain);
 	if (ret)
 		return ret;
 
@@ -1790,7 +1791,7 @@ static int ab8500_probe(struct platform_device *pdev)
 		/* Add battery management devices */
 		ret = mfd_add_devices(ab8500->dev, 0, ab8500_bm_devs,
 				      ARRAY_SIZE(ab8500_bm_devs), NULL,
-				      ab8500->irq_base, ab8500->domain);
+				      0, ab8500->domain);
 		if (ret)
 			dev_err(ab8500->dev, "error adding bm devices\n");
 	}
diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index e43e6e821117..7694e0700d34 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -25,6 +25,7 @@
 #include <linux/bitops.h>
 #include <linux/fs.h>
 #include <linux/of.h>
+#include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
 #include <linux/mfd/core.h>
@@ -2678,16 +2679,12 @@ static struct irq_domain_ops db8500_irq_ops = {
 	.xlate  = irq_domain_xlate_twocell,
 };
 
-static int db8500_irq_init(struct device_node *np, int irq_base)
+static int db8500_irq_init(struct device_node *np)
 {
 	int i;
 
-	/* In the device tree case, just take some IRQs */
-	if (np)
-		irq_base = 0;
-
 	db8500_irq_domain = irq_domain_add_simple(
-		np, NUM_PRCMU_WAKEUPS, irq_base,
+		np, NUM_PRCMU_WAKEUPS, 0,
 		&db8500_irq_ops, NULL);
 
 	if (!db8500_irq_domain) {
@@ -3114,10 +3111,10 @@ static void db8500_prcmu_update_cpufreq(void)
 }
 
 static int db8500_prcmu_register_ab8500(struct device *parent,
-					struct ab8500_platform_data *pdata,
-					int irq)
+					struct ab8500_platform_data *pdata)
 {
-	struct resource ab8500_resource = DEFINE_RES_IRQ(irq);
+	struct device_node *np;
+	struct resource ab8500_resource;
 	struct mfd_cell ab8500_cell = {
 		.name = "ab8500-core",
 		.of_compatible = "stericsson,ab8500",
@@ -3128,6 +3125,20 @@ static int db8500_prcmu_register_ab8500(struct device *parent,
 		.num_resources = 1,
 	};
 
+	if (!parent->of_node)
+		return -ENODEV;
+
+	/* Look up the device node, sneak the IRQ out of it */
+	for_each_child_of_node(parent->of_node, np) {
+		if (of_device_is_compatible(np, ab8500_cell.of_compatible))
+			break;
+	}
+	if (!np) {
+		dev_info(parent, "could not find AB8500 node in the device tree\n");
+		return -ENODEV;
+	}
+	of_irq_to_resource_table(np, &ab8500_resource, 1);
+
 	return mfd_add_devices(parent, 0, &ab8500_cell, 1, NULL, 0, NULL);
 }
 
@@ -3180,7 +3191,7 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
 		goto no_irq_return;
 	}
 
-	db8500_irq_init(np, pdata->irq_base);
+	db8500_irq_init(np);
 
 	prcmu_config_esram0_deep_sleep(ESRAM0_DEEP_SLEEP_STATE_RET);
 
@@ -3205,8 +3216,7 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
 		}
 	}
 
-	err = db8500_prcmu_register_ab8500(&pdev->dev, pdata->ab_platdata,
-					   pdata->ab_irq);
+	err = db8500_prcmu_register_ab8500(&pdev->dev, pdata->ab_platdata);
 	if (err) {
 		mfd_remove_devices(&pdev->dev);
 		pr_err("prcmu: Failed to add ab8500 subdevice\n");
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index a86ca1406fb8..4e7fe7417fc9 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -347,7 +347,6 @@ struct ab8500 {
 	struct mutex	lock;
 	struct mutex	irq_lock;
 	atomic_t	transfer_ongoing;
-	int		irq_base;
 	int		irq;
 	struct irq_domain  *domain;
 	enum ab8500_version version;
@@ -378,7 +377,6 @@ struct ab8500_sysctrl_platform_data;
  * @regulator: machine-specific constraints for regulators
  */
 struct ab8500_platform_data {
-	int irq_base;
 	void (*init) (struct ab8500 *);
 	struct ab8500_regulator_platform_data *regulator;
 	struct ab8500_codec_platform_data *codec;
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index 060e11256fbc..bf5109d38a26 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -183,8 +183,6 @@ struct prcmu_pdata
 	bool enable_set_ddr_opp;
 	bool enable_ape_opp_100_voltage;
 	struct ab8500_platform_data *ab_platdata;
-	int ab_irq;
-	int irq_base;
 	u32 version_offset;
 	u32 legacy_offset;
 	u32 adt_offset;
-- 
1.8.5.3

