Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3CNWNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:13:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64902 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab3CNWMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:12:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@vger.kernel.org
Cc: patches@linaro.org, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-mtd@lists.infradead.org, Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 6/6] mtd: remove h720x flash support
Date: Thu, 14 Mar 2013 23:12:08 +0100
Message-Id: <1363299128-8192-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363299128-8192-1-git-send-email-arnd@arndb.de>
References: <1363299128-8192-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:hcwXTxzN2waKxed5i5KOAsM0Jcq8BoQS98E7ualOmmj
 eWxNAVEDoMlNk6ANwjBoxHDt91ufMSlWcVFyexSIdYPPJv7ktn
 volz5pX53x8vwqv1nwQJc+F0dzlOEee1avhOVmO41+qYo1iP05
 Jasud7+JBm1B2DURYWal5QmG+PemCgXxrWXMvi71P/IzRH+x+O
 EGvFUzw7cyY+MEm7iMShDs/WzQaGrDTvZYFzUd0epIpgLwe0dy
 XA7qMXOmznE/W8eg1bnlwyD/IotuNNDH6MI+RcjhX8qnVYBMq0
 0NKEP/utuwVWxE0+TveVf+DhIgsp+azv6Z1bWNT8OuevJBEWPz
 KXWPAJSfVeLzr81Pk/dzYVpZfLx0IfvKZxThba631
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The h720x platform support is going away in linux-3.10, so the
MTD driver will also not be needed any more.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-mtd@lists.infradead.org
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/mtd/maps/Kconfig       |   7 ---
 drivers/mtd/maps/Makefile      |   1 -
 drivers/mtd/maps/h720x-flash.c | 120 -----------------------------------------
 3 files changed, 128 deletions(-)
 delete mode 100644 drivers/mtd/maps/h720x-flash.c

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 3ed17c4..2b108f2 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -372,13 +372,6 @@ config MTD_IMPA7
 	  This enables access to the NOR Flash on the impA7 board of
 	  implementa GmbH. If you have such a board, say 'Y' here.
 
-config MTD_H720X
-	tristate "Hynix evaluation board mappings"
-	depends on MTD_CFI && ( ARCH_H7201 || ARCH_H7202 )
-	help
-	  This enables access to the flash chips on the Hynix evaluation boards.
-	  If you have such a board, say 'Y'.
-
 # This needs CFI or JEDEC, depending on the cards found.
 config MTD_PCI
 	tristate "PCI MTD driver"
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index 4ded287..74587a0 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -42,7 +42,6 @@ obj-$(CONFIG_MTD_IMPA7)		+= impa7.o
 obj-$(CONFIG_MTD_UCLINUX)	+= uclinux.o
 obj-$(CONFIG_MTD_NETtel)	+= nettel.o
 obj-$(CONFIG_MTD_SCB2_FLASH)	+= scb2_flash.o
-obj-$(CONFIG_MTD_H720X)		+= h720x-flash.o
 obj-$(CONFIG_MTD_IXP4XX)	+= ixp4xx.o
 obj-$(CONFIG_MTD_IXP2000)	+= ixp2000.o
 obj-$(CONFIG_MTD_DMV182)	+= dmv182.o
diff --git a/drivers/mtd/maps/h720x-flash.c b/drivers/mtd/maps/h720x-flash.c
deleted file mode 100644
index 8ed6cb4..0000000
--- a/drivers/mtd/maps/h720x-flash.c
+++ /dev/null
@@ -1,120 +0,0 @@
-/*
- * Flash memory access on Hynix GMS30C7201/HMS30C7202 based
- * evaluation boards
- *
- * (C) 2002 Jungjun Kim <jungjun.kim@hynix.com>
- *     2003 Thomas Gleixner <tglx@linutronix.de>
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/errno.h>
-#include <linux/slab.h>
-
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/map.h>
-#include <linux/mtd/partitions.h>
-#include <mach/hardware.h>
-#include <asm/io.h>
-
-static struct mtd_info *mymtd;
-
-static struct map_info h720x_map = {
-	.name =		"H720X",
-	.bankwidth =	4,
-	.size =		H720X_FLASH_SIZE,
-	.phys =		H720X_FLASH_PHYS,
-};
-
-static struct mtd_partition h720x_partitions[] = {
-        {
-                .name = "ArMon",
-                .size = 0x00080000,
-                .offset = 0,
-                .mask_flags = MTD_WRITEABLE
-        },{
-                .name = "Env",
-                .size = 0x00040000,
-                .offset = 0x00080000,
-                .mask_flags = MTD_WRITEABLE
-        },{
-                .name = "Kernel",
-                .size = 0x00180000,
-                .offset = 0x000c0000,
-                .mask_flags = MTD_WRITEABLE
-        },{
-                .name = "Ramdisk",
-                .size = 0x00400000,
-                .offset = 0x00240000,
-                .mask_flags = MTD_WRITEABLE
-        },{
-                .name = "jffs2",
-                .size = MTDPART_SIZ_FULL,
-                .offset = MTDPART_OFS_APPEND
-        }
-};
-
-#define NUM_PARTITIONS ARRAY_SIZE(h720x_partitions)
-
-/*
- * Initialize FLASH support
- */
-static int __init h720x_mtd_init(void)
-{
-	h720x_map.virt = ioremap(h720x_map.phys, h720x_map.size);
-
-	if (!h720x_map.virt) {
-		printk(KERN_ERR "H720x-MTD: ioremap failed\n");
-		return -EIO;
-	}
-
-	simple_map_init(&h720x_map);
-
-	// Probe for flash bankwidth 4
-	printk (KERN_INFO "H720x-MTD probing 32bit FLASH\n");
-	mymtd = do_map_probe("cfi_probe", &h720x_map);
-	if (!mymtd) {
-		printk (KERN_INFO "H720x-MTD probing 16bit FLASH\n");
-	    // Probe for bankwidth 2
-	    h720x_map.bankwidth = 2;
-	    mymtd = do_map_probe("cfi_probe", &h720x_map);
-	}
-
-	if (mymtd) {
-		mymtd->owner = THIS_MODULE;
-
-		mtd_device_parse_register(mymtd, NULL, NULL,
-					  h720x_partitions, NUM_PARTITIONS);
-		return 0;
-	}
-
-	iounmap((void *)h720x_map.virt);
-	return -ENXIO;
-}
-
-/*
- * Cleanup
- */
-static void __exit h720x_mtd_cleanup(void)
-{
-
-	if (mymtd) {
-		mtd_device_unregister(mymtd);
-		map_destroy(mymtd);
-	}
-
-	if (h720x_map.virt) {
-		iounmap((void *)h720x_map.virt);
-		h720x_map.virt = 0;
-	}
-}
-
-
-module_init(h720x_mtd_init);
-module_exit(h720x_mtd_cleanup);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Thomas Gleixner <tglx@linutronix.de>");
-MODULE_DESCRIPTION("MTD map driver for Hynix evaluation boards");
-- 
1.8.1.2

