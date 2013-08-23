Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab3HWMZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:25:05 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:41283 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab3HWMZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:25:00 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 36/40] ARM: ux500: Purge UIB framework when booting with ATAGs
Date: Fri, 23 Aug 2013 13:23:36 +0100
Message-Id: <1377260620-18829-37-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/Makefile           |  1 -
 arch/arm/mach-ux500/board-mop500-uib.c | 97 ----------------------------------
 arch/arm/mach-ux500/board-mop500.c     |  6 +--
 arch/arm/mach-ux500/board-mop500.h     |  3 --
 arch/arm/mach-ux500/cpu.c              |  5 --
 arch/arm/mach-ux500/setup.h            |  1 -
 6 files changed, 3 insertions(+), 110 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/board-mop500-uib.c

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index b34b74b..d5245c1 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -9,7 +9,6 @@ obj-$(CONFIG_CACHE_L2X0)	+= cache-l2x0.o
 obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o devices-db8500.o
 obj-$(CONFIG_MACH_MOP500)	+= board-mop500.o board-mop500-sdi.o \
 				board-mop500-regulators.o \
-				board-mop500-uib.o \
 				board-mop500-pins.o \
 				board-mop500-audio.o
 obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
diff --git a/arch/arm/mach-ux500/board-mop500-uib.c b/arch/arm/mach-ux500/board-mop500-uib.c
deleted file mode 100644
index 2742eec..0000000
--- a/arch/arm/mach-ux500/board-mop500-uib.c
+++ /dev/null
@@ -1,97 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
- * License terms: GNU General Public License (GPL), version 2
- */
-
-#define pr_fmt(fmt)	"mop500-uib: " fmt
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/i2c.h>
-
-#include "board-mop500.h"
-#include "id.h"
-
-enum mop500_uib {
-};
-
-struct uib {
-	const char *name;
-	const char *option;
-	void (*init)(void);
-};
-
-static struct uib __initdata mop500_uibs[] = {
-};
-
-static struct uib *mop500_uib;
-
-static int __init mop500_uib_setup(char *str)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(mop500_uibs); i++) {
-		struct uib *uib = &mop500_uibs[i];
-
-		if (!strcmp(str, uib->option)) {
-			mop500_uib = uib;
-			break;
-		}
-	}
-
-	if (i == ARRAY_SIZE(mop500_uibs))
-		pr_err("invalid uib= option (%s)\n", str);
-
-	return 1;
-}
-__setup("uib=", mop500_uib_setup);
-
-/*
- * The UIBs are detected after the I2C host controllers are registered, so
- * i2c_register_board_info() can't be used.
- */
-void mop500_uib_i2c_add(int busnum, struct i2c_board_info *info,
-		unsigned n)
-{
-	struct i2c_adapter *adap;
-	struct i2c_client *client;
-	int i;
-
-	adap = i2c_get_adapter(busnum);
-	if (!adap) {
-		pr_err("failed to get adapter i2c%d\n", busnum);
-		return;
-	}
-
-	for (i = 0; i < n; i++) {
-		client = i2c_new_device(adap, &info[i]);
-		if (!client)
-			pr_err("failed to register %s to i2c%d\n",
-					info[i].type, busnum);
-	}
-
-	i2c_put_adapter(adap);
-}
-
-static void __init __mop500_uib_init(struct uib *uib, const char *why)
-{
-	pr_info("%s (%s)\n", uib->name, why);
-	uib->init();
-}
-
-int __init mop500_uib_init(void)
-{
-	struct uib *uib = mop500_uib;
-
-	if (!cpu_is_u8500_family())
-		return -ENODEV;
-
-	if (uib) {
-		__mop500_uib_init(uib, "from uib= boot argument");
-		return 0;
-	}
-
-	return 0;
-}
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 3086192..8f1b98a 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -105,7 +105,7 @@ MACHINE_START(U8500, "ST-Ericsson MOP500 platform")
 	/* we re-use nomadik timer here */
 	.init_time	= ux500_timer_init,
 	.init_machine	= mop500_init_machine,
-	.init_late	= ux500_init_late,
+	.init_late	= NULL,
 MACHINE_END
 
 MACHINE_START(U8520, "ST-Ericsson U8520 Platform HREFP520")
@@ -114,7 +114,7 @@ MACHINE_START(U8520, "ST-Ericsson U8520 Platform HREFP520")
 	.init_irq	= ux500_init_irq,
 	.init_time	= ux500_timer_init,
 	.init_machine	= mop500_init_machine,
-	.init_late	= ux500_init_late,
+	.init_late	= NULL,
 MACHINE_END
 
 MACHINE_START(HREFV60, "ST-Ericsson U8500 Platform HREFv60+")
@@ -124,7 +124,7 @@ MACHINE_START(HREFV60, "ST-Ericsson U8500 Platform HREFv60+")
 	.init_irq	= ux500_init_irq,
 	.init_time	= ux500_timer_init,
 	.init_machine	= hrefv60_init_machine,
-	.init_late	= ux500_init_late,
+	.init_late	= NULL,
 MACHINE_END
 
 MACHINE_START(SNOWBALL, "Calao Systems Snowball platform")
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index 2fb89e2..511d6fe 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -93,7 +93,4 @@ void __init mop500_pinmaps_init(void);
 void __init snowball_pinmaps_init(void);
 void __init hrefv60_pinmaps_init(void);
 
-int __init mop500_uib_init(void);
-void mop500_uib_i2c_add(int busnum, struct i2c_board_info *info,
-		unsigned n);
 #endif
diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index e6fb023..24548cd 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -88,11 +88,6 @@ void __init ux500_init_irq(void)
 	}
 }
 
-void __init ux500_init_late(void)
-{
-	mop500_uib_init();
-}
-
 static const char * __init ux500_get_machine(void)
 {
 	return kasprintf(GFP_KERNEL, "DB%4x", dbx500_partnumber());
diff --git a/arch/arm/mach-ux500/setup.h b/arch/arm/mach-ux500/setup.h
index cad3ca8..8578d91 100644
--- a/arch/arm/mach-ux500/setup.h
+++ b/arch/arm/mach-ux500/setup.h
@@ -21,7 +21,6 @@ extern void __init u8500_map_io(void);
 extern struct device * __init u8500_init_devices(void);
 
 extern void __init ux500_init_irq(void);
-extern void __init ux500_init_late(void);
 
 extern struct device *ux500_soc_device_init(const char *soc_id);
 
-- 
1.8.1.2

