Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab3HWMYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:24:55 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45117 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab3HWMYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 32/40] ARM: ux500: Delete U8500 UIB support when booting with ATAGs
Date: Fri, 23 Aug 2013 13:23:32 +0100
Message-Id: <1377260620-18829-33-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/Makefile                |  1 -
 arch/arm/mach-ux500/board-mop500-u8500uib.c | 14 --------------
 arch/arm/mach-ux500/board-mop500-uib.c      | 30 +----------------------------
 arch/arm/mach-ux500/board-mop500.h          |  1 -
 4 files changed, 1 insertion(+), 45 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/board-mop500-u8500uib.c

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index cac22ba..8634a3fa 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -10,7 +10,6 @@ obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o devices-db8500.o
 obj-$(CONFIG_MACH_MOP500)	+= board-mop500.o board-mop500-sdi.o \
 				board-mop500-regulators.o \
 				board-mop500-uib.o board-mop500-stuib.o \
-				board-mop500-u8500uib.o \
 				board-mop500-pins.o \
 				board-mop500-audio.o
 obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
diff --git a/arch/arm/mach-ux500/board-mop500-u8500uib.c b/arch/arm/mach-ux500/board-mop500-u8500uib.c
deleted file mode 100644
index 43c9ff1..0000000
--- a/arch/arm/mach-ux500/board-mop500-u8500uib.c
+++ /dev/null
@@ -1,14 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Board data for the U8500 UIB, also known as the New UIB
- * License terms: GNU General Public License (GPL), version 2
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-
-#include "board-mop500.h"
-
-void __init mop500_u8500uib_init(void)
-{
-}
diff --git a/arch/arm/mach-ux500/board-mop500-uib.c b/arch/arm/mach-ux500/board-mop500-uib.c
index bdaa422..0e94f1d 100644
--- a/arch/arm/mach-ux500/board-mop500-uib.c
+++ b/arch/arm/mach-ux500/board-mop500-uib.c
@@ -16,7 +16,6 @@
 
 enum mop500_uib {
 	STUIB,
-	U8500UIB,
 };
 
 struct uib {
@@ -31,11 +30,6 @@ static struct uib __initdata mop500_uibs[] = {
 		.option	= "stuib",
 		.init	= mop500_stuib_init,
 	},
-	[U8500UIB] = {
-		.name	= "U8500-UIB",
-		.option	= "u8500uib",
-		.init	= mop500_u8500uib_init,
-	},
 };
 
 static struct uib *mop500_uib;
@@ -93,14 +87,9 @@ static void __init __mop500_uib_init(struct uib *uib, const char *why)
 	uib->init();
 }
 
-/*
- * Detect the UIB attached based on the presence or absence of i2c devices.
- */
 int __init mop500_uib_init(void)
 {
 	struct uib *uib = mop500_uib;
-	struct i2c_adapter *i2c0;
-	int ret;
 
 	if (!cpu_is_u8500_family())
 		return -ENODEV;
@@ -110,24 +99,7 @@ int __init mop500_uib_init(void)
 		return 0;
 	}
 
-	i2c0 = i2c_get_adapter(0);
-	if (!i2c0) {
-		__mop500_uib_init(&mop500_uibs[STUIB],
-				"fallback, could not get i2c0");
-		return -ENODEV;
-	}
-
-	/* U8500-UIB has the TC35893 at 0x44 on I2C0, the ST-UIB doesn't. */
-	ret = i2c_smbus_xfer(i2c0, 0x44, 0, I2C_SMBUS_WRITE, 0,
-			I2C_SMBUS_QUICK, NULL);
-	i2c_put_adapter(i2c0);
-
-	if (ret == 0)
-		uib = &mop500_uibs[U8500UIB];
-	else
-		uib = &mop500_uibs[STUIB];
-
-	__mop500_uib_init(uib, "detected");
+	__mop500_uib_init(&mop500_uibs[STUIB], "detected");
 
 	return 0;
 }
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index cf6b304..223639b 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -89,7 +89,6 @@ extern struct msp_i2s_platform_data msp2_platform_data;
 extern struct msp_i2s_platform_data msp3_platform_data;
 extern struct pl022_ssp_controller ssp0_plat;
 
-void __init mop500_u8500uib_init(void);
 void __init mop500_stuib_init(void);
 void __init mop500_pinmaps_init(void);
 void __init snowball_pinmaps_init(void);
-- 
1.8.1.2

