Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937667Ab3DKAHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:07:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63566 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937451Ab3DKAG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/30] ARM: exynos: move debug-macro.S to include/debug/
Date: Thu, 11 Apr 2013 02:04:45 +0200
Message-Id: <1365638712-1028578-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:cqbEJztM87/OPzh2LIerWacD2xRRg5KHNp26RvEiHJQ
 8ln4HGkxYw9UoP6+JDPuLsKsKsLgJqzQdqkLb5q1fD14Xy+OtJ
 0YOGW+0UcJKt7056J0u0qLmKy1k1puQzfzpZYps4FN/t227b+d
 52Rx52B6+WRmQppDp+Iv71hG5J9PIjHvq107z7C6ZH0D229tZt
 OpWPxO6+ZMKTrJ6HDmytm+p5lmS+uChEP8HKgprjHndh0PILID
 t/s7T1vkfn8GJovEoxQlk8ENHOG20rhvVrtaSiL6tGFHKMNPBd
 GmqNtmpAraOespzIVVG6s4lvMfBtquQvtcg3AOhTXbNWTv/SOx
 GcutLPF6pdYtH1bGdkBr10ytpXbvShCoGZ30uQvd4FJBotOBPV
 GXsWzEfU2IX7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The move is necessary to support early debug output on exynos
with multiplatform configurations. This implies also moving the
plat/debug-macro.S file, but we are leaving the remaining users of that
file in place, to avoid adding large numbers of extra configuration
options to Kconfig.debug

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig.debug                                       |  8 ++++++++
 .../include/mach/debug-macro.S => include/debug/exynos.S}    | 12 ++++++------
 .../include/plat/debug-macro.S => include/debug/samsung.S}   |  2 +-
 arch/arm/mach-s3c24xx/include/mach/debug-macro.S             |  2 +-
 arch/arm/mach-s3c64xx/include/mach/debug-macro.S             |  2 +-
 arch/arm/mach-s5p64x0/include/mach/debug-macro.S             |  2 +-
 arch/arm/mach-s5pc100/include/mach/debug-macro.S             |  2 +-
 arch/arm/mach-s5pv210/include/mach/debug-macro.S             |  2 +-
 8 files changed, 20 insertions(+), 12 deletions(-)
 rename arch/arm/{mach-exynos/include/mach/debug-macro.S => include/debug/exynos.S} (84%)
 rename arch/arm/{plat-samsung/include/plat/debug-macro.S => include/debug/samsung.S} (98%)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index e00bd4d..54d6fdc 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -348,6 +348,7 @@ choice
 
 	config DEBUG_S3C_UART0
 		depends on PLAT_SAMSUNG
+		select DEBUG_EXYNOS_UART if ARCH_EXYNOS
 		bool "Use S3C UART 0 for low-level debug"
 		help
 		  Say Y here if you want the debug print routines to direct
@@ -359,6 +360,7 @@ choice
 
 	config DEBUG_S3C_UART1
 		depends on PLAT_SAMSUNG
+		select DEBUG_EXYNOS_UART if ARCH_EXYNOS
 		bool "Use S3C UART 1 for low-level debug"
 		help
 		  Say Y here if you want the debug print routines to direct
@@ -370,6 +372,7 @@ choice
 
 	config DEBUG_S3C_UART2
 		depends on PLAT_SAMSUNG
+		select DEBUG_EXYNOS_UART if ARCH_EXYNOS
 		bool "Use S3C UART 2 for low-level debug"
 		help
 		  Say Y here if you want the debug print routines to direct
@@ -381,6 +384,7 @@ choice
 
 	config DEBUG_S3C_UART3
 		depends on PLAT_SAMSUNG && ARCH_EXYNOS
+		select DEBUG_EXYNOS_UART
 		bool "Use S3C UART 3 for low-level debug"
 		help
 		  Say Y here if you want the debug print routines to direct
@@ -510,6 +514,9 @@ choice
 
 endchoice
 
+config DEBUG_EXYNOS_UART
+	bool
+
 config DEBUG_IMX_UART_PORT
 	int "i.MX Debug UART Port Selection" if DEBUG_IMX1_UART || \
 						DEBUG_IMX25_UART || \
@@ -607,6 +614,7 @@ config DEBUG_LL_INCLUDE
 	string
 	default "debug/bcm2835.S" if DEBUG_BCM2835
 	default "debug/cns3xxx.S" if DEBUG_CNS3XXX
+	default "debug/exynos.S" if DEBUG_EXYNOS_UART
 	default "debug/icedcc.S" if DEBUG_ICEDCC
 	default "debug/imx.S" if DEBUG_IMX1_UART || \
 				 DEBUG_IMX25_UART || \
diff --git a/arch/arm/mach-exynos/include/mach/debug-macro.S b/arch/arm/include/debug/exynos.S
similarity index 84%
rename from arch/arm/mach-exynos/include/mach/debug-macro.S
rename to arch/arm/include/debug/exynos.S
index e0c86ea..b17fdb7 100644
--- a/arch/arm/mach-exynos/include/mach/debug-macro.S
+++ b/arch/arm/include/debug/exynos.S
@@ -1,10 +1,7 @@
-/* linux/arch/arm/mach-exynos4/include/mach/debug-macro.S
- *
+/*
  * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
- * Based on arch/arm/mach-s3c6400/include/mach/debug-macro.S
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -12,7 +9,10 @@
 
 /* pull in the relevant register and map files. */
 
-#include <mach/map.h>
+#define S3C_ADDR_BASE   0xF6000000
+#define S3C_VA_UART	S3C_ADDR_BASE + 0x01000000
+#define EXYNOS4_PA_UART	0x13800000
+#define EXYNOS5_PA_UART	0x12C00000
 
 	/* note, for the boot process to work we have to keep the UART
 	 * virtual address aligned to an 1MiB boundary for the L1
@@ -36,4 +36,4 @@
 #define fifo_full fifo_full_s5pv210
 #define fifo_level fifo_level_s5pv210
 
-#include <plat/debug-macro.S>
+#include <debug/samsung.S>
diff --git a/arch/arm/plat-samsung/include/plat/debug-macro.S b/arch/arm/include/debug/samsung.S
similarity index 98%
rename from arch/arm/plat-samsung/include/plat/debug-macro.S
rename to arch/arm/include/debug/samsung.S
index f3a9cff..8d8d922 100644
--- a/arch/arm/plat-samsung/include/plat/debug-macro.S
+++ b/arch/arm/include/debug/samsung.S
@@ -9,7 +9,7 @@
  * published by the Free Software Foundation.
 */
 
-#include <plat/regs-serial.h>
+#include <linux/serial_s3c.h>
 
 /* The S5PV210/S5PC110 implementations are as belows. */
 
diff --git a/arch/arm/mach-s3c24xx/include/mach/debug-macro.S b/arch/arm/mach-s3c24xx/include/mach/debug-macro.S
index 13ed33c..2558952 100644
--- a/arch/arm/mach-s3c24xx/include/mach/debug-macro.S
+++ b/arch/arm/mach-s3c24xx/include/mach/debug-macro.S
@@ -98,4 +98,4 @@
 
 /* include the reset of the code which will do the work */
 
-#include <plat/debug-macro.S>
+#include <debug/samsung.S>
diff --git a/arch/arm/mach-s3c64xx/include/mach/debug-macro.S b/arch/arm/mach-s3c64xx/include/mach/debug-macro.S
index c0c076a..dd9ccca 100644
--- a/arch/arm/mach-s3c64xx/include/mach/debug-macro.S
+++ b/arch/arm/mach-s3c64xx/include/mach/debug-macro.S
@@ -35,4 +35,4 @@
  * will be fine with us.
  */
 
-#include <plat/debug-macro.S>
+#include <debug/samsung.S>
diff --git a/arch/arm/mach-s5p64x0/include/mach/debug-macro.S b/arch/arm/mach-s5p64x0/include/mach/debug-macro.S
index e80ba3c..5e2916f 100644
--- a/arch/arm/mach-s5p64x0/include/mach/debug-macro.S
+++ b/arch/arm/mach-s5p64x0/include/mach/debug-macro.S
@@ -30,4 +30,4 @@
 #endif
 	.endm
 
-#include <plat/debug-macro.S>
+#include <debug/samsung.S>
diff --git a/arch/arm/mach-s5pc100/include/mach/debug-macro.S b/arch/arm/mach-s5pc100/include/mach/debug-macro.S
index 694f759..66cb7f1 100644
--- a/arch/arm/mach-s5pc100/include/mach/debug-macro.S
+++ b/arch/arm/mach-s5pc100/include/mach/debug-macro.S
@@ -36,4 +36,4 @@
  * will be fine with us.
  */
 
-#include <plat/debug-macro.S>
+#include <debug/samsung.S>
diff --git a/arch/arm/mach-s5pv210/include/mach/debug-macro.S b/arch/arm/mach-s5pv210/include/mach/debug-macro.S
index 79e5559..80c2199 100644
--- a/arch/arm/mach-s5pv210/include/mach/debug-macro.S
+++ b/arch/arm/mach-s5pv210/include/mach/debug-macro.S
@@ -38,4 +38,4 @@
  * will be fine with us.
  */
 
-#include <plat/debug-macro.S>
+#include <debug/samsung.S>
-- 
1.8.1.2

