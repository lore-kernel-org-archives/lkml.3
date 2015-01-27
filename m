Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbbA0SIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:08:04 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:10606 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759273AbbA0SIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:08:02 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/7] ARM: at91: merge all SOC_AT91SAM9xxx
Date: Tue, 27 Jan 2015 19:07:21 +0100
Message-ID: <b7f8ea95ea687f3f867d2e2270e59ea42bd992b5.1422381280.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1422381280.git.nicolas.ferre@atmel.com>
References: <cover.1422381280.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Only use SOC_AT91SAM9 for all the at91sam9 SoCs. It removes all the empty
at91sam9xxx.c SoC files. It also removes the useless at91_init_soc affectation
procedure and its "init" function pointer.
Only the SoC detection and display are kept for the at91sam9:
at91_soc_is_enabled() and at91_boot_soc.map_io() function calls are also
removed.

It enables HAVE_AT91_SMD and HAVE_AT91_UTMI for all the sam9 SoCs but this only
represents 96 bytes of uncompressed kernel code.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
[nicolas.ferre@atmel.com: different organization of the patches]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/configs/at91_dt_defconfig    | 10 +---
 arch/arm/mach-at91/Kconfig            | 92 ++++++++++-------------------------
 arch/arm/mach-at91/Makefile           |  7 ---
 arch/arm/mach-at91/at91sam9260.c      | 26 ----------
 arch/arm/mach-at91/at91sam9261.c      | 25 ----------
 arch/arm/mach-at91/at91sam9263.c      | 24 ---------
 arch/arm/mach-at91/at91sam9g45.c      | 24 ---------
 arch/arm/mach-at91/at91sam9n12.c      | 20 --------
 arch/arm/mach-at91/at91sam9rl.c       | 25 ----------
 arch/arm/mach-at91/at91sam9x5.c       | 20 --------
 arch/arm/mach-at91/include/mach/cpu.h | 52 ++++++--------------
 arch/arm/mach-at91/setup.c            | 19 --------
 arch/arm/mach-at91/soc.h              | 36 --------------
 13 files changed, 41 insertions(+), 339 deletions(-)
 delete mode 100644 arch/arm/mach-at91/at91sam9260.c
 delete mode 100644 arch/arm/mach-at91/at91sam9261.c
 delete mode 100644 arch/arm/mach-at91/at91sam9263.c
 delete mode 100644 arch/arm/mach-at91/at91sam9g45.c
 delete mode 100644 arch/arm/mach-at91/at91sam9n12.c
 delete mode 100644 arch/arm/mach-at91/at91sam9rl.c
 delete mode 100644 arch/arm/mach-at91/at91sam9x5.c

diff --git a/arch/arm/configs/at91_dt_defconfig b/arch/arm/configs/at91_dt_defconfig
index a67375f24b21..f2670f638e97 100644
--- a/arch/arm/configs/at91_dt_defconfig
+++ b/arch/arm/configs/at91_dt_defconfig
@@ -15,15 +15,7 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_IOSCHED_CFQ is not set
 CONFIG_ARCH_AT91=y
 CONFIG_SOC_AT91RM9200=y
-CONFIG_SOC_AT91SAM9260=y
-CONFIG_SOC_AT91SAM9261=y
-CONFIG_SOC_AT91SAM9263=y
-CONFIG_SOC_AT91SAM9RL=y
-CONFIG_SOC_AT91SAM9G45=y
-CONFIG_SOC_AT91SAM9X5=y
-CONFIG_SOC_AT91SAM9N12=y
-CONFIG_MACH_AT91RM9200_DT=y
-CONFIG_MACH_AT91SAM9_DT=y
+CONFIG_SOC_AT91SAM9=y
 CONFIG_AT91_TIMER_HZ=128
 CONFIG_AEABI=y
 CONFIG_UACCESS_WITH_MEMCPY=y
diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index c6956b863b9d..c6740e359a44 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -16,15 +16,6 @@ config HAVE_AT91_SMD
 config HAVE_AT91_H32MX
 	bool
 
-config SOC_AT91SAM9
-	bool
-	select ATMEL_AIC_IRQ
-	select COMMON_CLK_AT91
-	select CPU_ARM926T
-	select GENERIC_CLOCKEVENTS
-	select MEMORY
-	select ATMEL_SDRAMC
-
 config SOC_SAMA5
 	bool
 	select ATMEL_AIC5_IRQ
@@ -92,67 +83,36 @@ config SOC_AT91RM9200
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USB_CLK
 
-config SOC_AT91SAM9260
-	bool "AT91SAM9260, AT91SAM9XE or AT91SAM9G20"
-	select SOC_AT91SAM9
-	select HAVE_AT91_USB_CLK
-	help
-	  Select this if you are using one of Atmel's AT91SAM9260, AT91SAM9XE
-	  or AT91SAM9G20 SoC.
-
-config SOC_AT91SAM9261
-	bool "AT91SAM9261 or AT91SAM9G10"
-	select HAVE_FB_ATMEL
-	select SOC_AT91SAM9
-	select HAVE_AT91_USB_CLK
-	help
-	  Select this if you are using one of Atmel's AT91SAM9261 or AT91SAM9G10 SoC.
-
-config SOC_AT91SAM9263
-	bool "AT91SAM9263"
-	select HAVE_FB_ATMEL
-	select SOC_AT91SAM9
-	select HAVE_AT91_USB_CLK
-
-config SOC_AT91SAM9RL
-	bool "AT91SAM9RL"
-	select HAVE_FB_ATMEL
-	select SOC_AT91SAM9
-	select HAVE_AT91_UTMI
-
-config SOC_AT91SAM9G45
-	bool "AT91SAM9G45 or AT91SAM9M10 families"
-	select HAVE_FB_ATMEL
-	select SOC_AT91SAM9
-	select HAVE_AT91_UTMI
-	select HAVE_AT91_USB_CLK
-	help
-	  Select this if you are using one of Atmel's AT91SAM9G45 family SoC.
-	  This support covers AT91SAM9G45, AT91SAM9G46, AT91SAM9M10 and AT91SAM9M11.
-
-config SOC_AT91SAM9X5
-	bool "AT91SAM9x5 family"
-	select HAVE_FB_ATMEL
-	select SOC_AT91SAM9
-	select HAVE_AT91_UTMI
+config SOC_AT91SAM9
+	bool "AT91SAM9"
+	select ATMEL_AIC_IRQ
+	select ATMEL_SDRAMC
+	select COMMON_CLK_AT91
+	select CPU_ARM926T
+	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_SMD
 	select HAVE_AT91_USB_CLK
-	help
-	  Select this if you are using one of Atmel's AT91SAM9x5 family SoC.
-	  This means that your SAM9 name finishes with a '5' (except if it is
-	  AT91SAM9G45!).
-	  This support covers AT91SAM9G15, AT91SAM9G25, AT91SAM9X25, AT91SAM9G35
-	  and AT91SAM9X35.
-
-config SOC_AT91SAM9N12
-	bool "AT91SAM9N12 family"
+	select HAVE_AT91_UTMI
 	select HAVE_FB_ATMEL
-	select SOC_AT91SAM9
-	select HAVE_AT91_USB_CLK
+	select MEMORY
 	help
-	  Select this if you are using Atmel's AT91SAM9N12 SoC.
-
-# ----------------------------------------------------------
+	  Select this if you are using one of those Atmel SoC:
+	    AT91SAM9260
+	    AT91SAM9261
+	    AT91SAM9263
+	    AT91SAM9G15
+	    AT91SAM9G20
+	    AT91SAM9G25
+	    AT91SAM9G35
+	    AT91SAM9G45
+	    AT91SAM9G46
+	    AT91SAM9M10
+	    AT91SAM9M11
+	    AT91SAM9N12
+	    AT91SAM9RL
+	    AT91SAM9X25
+	    AT91SAM9X35
+	    AT91SAM9XE
 endif # SOC_SAM_V4_V5
 
 comment "AT91 Feature Selections"
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 8ef7d9a2e855..ad7fc5834188 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -8,13 +8,6 @@ obj-$(CONFIG_SOC_AT91SAM9)	+= sam9_smc.o
 
 # CPU-specific support
 obj-$(CONFIG_SOC_AT91RM9200)	+= at91rm9200.o at91rm9200_time.o
-obj-$(CONFIG_SOC_AT91SAM9260)	+= at91sam9260.o
-obj-$(CONFIG_SOC_AT91SAM9261)	+= at91sam9261.o
-obj-$(CONFIG_SOC_AT91SAM9263)	+= at91sam9263.o
-obj-$(CONFIG_SOC_AT91SAM9G45)	+= at91sam9g45.o
-obj-$(CONFIG_SOC_AT91SAM9N12)	+= at91sam9n12.o
-obj-$(CONFIG_SOC_AT91SAM9X5)	+= at91sam9x5.o
-obj-$(CONFIG_SOC_AT91SAM9RL)	+= at91sam9rl.o
 obj-$(CONFIG_SOC_SAMA5D3)	+= sama5d3.o
 obj-$(CONFIG_SOC_SAMA5D4)	+= sama5d4.o
 
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
deleted file mode 100644
index 37b7ce4c6a3b..000000000000
--- a/arch/arm/mach-at91/at91sam9260.c
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- * arch/arm/mach-at91/at91sam9260.c
- *
- *  Copyright (C) 2006 SAN People
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-
-#include <asm/system_misc.h>
-#include <mach/cpu.h>
-#include <mach/at91_dbgu.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-
-/* --------------------------------------------------------------------
- *  AT91SAM9260 processor initialization
- * -------------------------------------------------------------------- */
-
-AT91_SOC_START(at91sam9260)
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
deleted file mode 100644
index aebbf76b6038..000000000000
--- a/arch/arm/mach-at91/at91sam9261.c
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * arch/arm/mach-at91/at91sam9261.c
- *
- *  Copyright (C) 2005 SAN People
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-
-#include <asm/system_misc.h>
-#include <mach/cpu.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-
-/* --------------------------------------------------------------------
- *  AT91SAM9261 processor initialization
- * -------------------------------------------------------------------- */
-
-AT91_SOC_START(at91sam9261)
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
deleted file mode 100644
index dca29457d9cc..000000000000
--- a/arch/arm/mach-at91/at91sam9263.c
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * arch/arm/mach-at91/at91sam9263.c
- *
- *  Copyright (C) 2007 Atmel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-
-#include <asm/system_misc.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-
-/* --------------------------------------------------------------------
- *  AT91SAM9263 processor initialization
- * -------------------------------------------------------------------- */
-
-AT91_SOC_START(at91sam9263)
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
deleted file mode 100644
index 4957a9ef748a..000000000000
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- *  Chip-specific setup code for the AT91SAM9G45 family
- *
- *  Copyright (C) 2009 Atmel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-
-#include <asm/system_misc.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-
-/* --------------------------------------------------------------------
- *  AT91SAM9G45 processor initialization
- * -------------------------------------------------------------------- */
-
-AT91_SOC_START(at91sam9g45)
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9n12.c b/arch/arm/mach-at91/at91sam9n12.c
deleted file mode 100644
index b5ea69a3eaf6..000000000000
--- a/arch/arm/mach-at91/at91sam9n12.c
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * SoC specific setup code for the AT91SAM9N12
- *
- * Copyright (C) 2012 Atmel Corporation.
- *
- * Licensed under GPLv2 or later.
- */
-
-#include <asm/system_misc.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-
-/* --------------------------------------------------------------------
- *  AT91SAM9N12 processor initialization
- * -------------------------------------------------------------------- */
-
-AT91_SOC_START(at91sam9n12)
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
deleted file mode 100644
index 6cb40e4ec20f..000000000000
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * arch/arm/mach-at91/at91sam9rl.c
- *
- *  Copyright (C) 2005 SAN People
- *  Copyright (C) 2007 Atmel Corporation
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive for
- * more details.
- */
-
-#include <asm/system_misc.h>
-#include <mach/cpu.h>
-#include <mach/at91_dbgu.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-
-/* --------------------------------------------------------------------
- *  AT91SAM9RL processor initialization
- * -------------------------------------------------------------------- */
-
-AT91_SOC_START(at91sam9rl)
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
deleted file mode 100644
index 7b60a529db01..000000000000
--- a/arch/arm/mach-at91/at91sam9x5.c
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- *  Chip-specific setup code for the AT91SAM9x5 family
- *
- *  Copyright (C) 2010-2012 Atmel Corporation.
- *
- * Licensed under GPLv2 or later.
- */
-
-#include <asm/system_misc.h>
-#include <mach/hardware.h>
-
-#include "soc.h"
-#include "generic.h"
-
-/* --------------------------------------------------------------------
- *  AT91SAM9x5 processor initialization
- * -------------------------------------------------------------------- */
-
-AT91_SOC_START(at91sam9x5)
-AT91_SOC_END
diff --git a/arch/arm/mach-at91/include/mach/cpu.h b/arch/arm/mach-at91/include/mach/cpu.h
index 61914fb35f5d..ce7c80a44983 100644
--- a/arch/arm/mach-at91/include/mach/cpu.h
+++ b/arch/arm/mach-at91/include/mach/cpu.h
@@ -152,69 +152,45 @@ static inline int at91_soc_is_detected(void)
 #define cpu_is_at91rm9200_pqfp() (0)
 #endif
 
-#ifdef CONFIG_SOC_AT91SAM9260
+#ifdef CONFIG_SOC_AT91SAM9
 #define cpu_is_at91sam9xe()	(at91_soc_initdata.subtype == AT91_SOC_SAM9XE)
 #define cpu_is_at91sam9260()	(at91_soc_initdata.type == AT91_SOC_SAM9260)
 #define cpu_is_at91sam9g20()	(at91_soc_initdata.type == AT91_SOC_SAM9G20)
-#else
-#define cpu_is_at91sam9xe()	(0)
-#define cpu_is_at91sam9260()	(0)
-#define cpu_is_at91sam9g20()	(0)
-#endif
-
-#ifdef CONFIG_SOC_AT91SAM9261
 #define cpu_is_at91sam9261()	(at91_soc_initdata.type == AT91_SOC_SAM9261)
 #define cpu_is_at91sam9g10()	(at91_soc_initdata.type == AT91_SOC_SAM9G10)
-#else
-#define cpu_is_at91sam9261()	(0)
-#define cpu_is_at91sam9g10()	(0)
-#endif
-
-#ifdef CONFIG_SOC_AT91SAM9263
 #define cpu_is_at91sam9263()	(at91_soc_initdata.type == AT91_SOC_SAM9263)
-#else
-#define cpu_is_at91sam9263()	(0)
-#endif
-
-#ifdef CONFIG_SOC_AT91SAM9RL
 #define cpu_is_at91sam9rl()	(at91_soc_initdata.type == AT91_SOC_SAM9RL)
-#else
-#define cpu_is_at91sam9rl()	(0)
-#endif
-
-#ifdef CONFIG_SOC_AT91SAM9G45
 #define cpu_is_at91sam9g45()	(at91_soc_initdata.type == AT91_SOC_SAM9G45)
 #define cpu_is_at91sam9g45es()	(at91_soc_initdata.subtype == AT91_SOC_SAM9G45ES)
 #define cpu_is_at91sam9m10()	(at91_soc_initdata.subtype == AT91_SOC_SAM9M10)
 #define cpu_is_at91sam9g46()	(at91_soc_initdata.subtype == AT91_SOC_SAM9G46)
 #define cpu_is_at91sam9m11()	(at91_soc_initdata.subtype == AT91_SOC_SAM9M11)
-#else
-#define cpu_is_at91sam9g45()	(0)
-#define cpu_is_at91sam9g45es()	(0)
-#define cpu_is_at91sam9m10()	(0)
-#define cpu_is_at91sam9g46()	(0)
-#define cpu_is_at91sam9m11()	(0)
-#endif
-
-#ifdef CONFIG_SOC_AT91SAM9X5
 #define cpu_is_at91sam9x5()	(at91_soc_initdata.type == AT91_SOC_SAM9X5)
 #define cpu_is_at91sam9g15()	(at91_soc_initdata.subtype == AT91_SOC_SAM9G15)
 #define cpu_is_at91sam9g35()	(at91_soc_initdata.subtype == AT91_SOC_SAM9G35)
 #define cpu_is_at91sam9x35()	(at91_soc_initdata.subtype == AT91_SOC_SAM9X35)
 #define cpu_is_at91sam9g25()	(at91_soc_initdata.subtype == AT91_SOC_SAM9G25)
 #define cpu_is_at91sam9x25()	(at91_soc_initdata.subtype == AT91_SOC_SAM9X25)
+#define cpu_is_at91sam9n12()	(at91_soc_initdata.type == AT91_SOC_SAM9N12)
 #else
+#define cpu_is_at91sam9xe()	(0)
+#define cpu_is_at91sam9260()	(0)
+#define cpu_is_at91sam9g20()	(0)
+#define cpu_is_at91sam9261()	(0)
+#define cpu_is_at91sam9g10()	(0)
+#define cpu_is_at91sam9263()	(0)
+#define cpu_is_at91sam9rl()	(0)
+#define cpu_is_at91sam9g45()	(0)
+#define cpu_is_at91sam9g45es()	(0)
+#define cpu_is_at91sam9m10()	(0)
+#define cpu_is_at91sam9g46()	(0)
+#define cpu_is_at91sam9m11()	(0)
 #define cpu_is_at91sam9x5()	(0)
 #define cpu_is_at91sam9g15()	(0)
 #define cpu_is_at91sam9g35()	(0)
 #define cpu_is_at91sam9x35()	(0)
 #define cpu_is_at91sam9g25()	(0)
 #define cpu_is_at91sam9x25()	(0)
-#endif
-
-#ifdef CONFIG_SOC_AT91SAM9N12
-#define cpu_is_at91sam9n12()	(at91_soc_initdata.type == AT91_SOC_SAM9N12)
-#else
 #define cpu_is_at91sam9n12()	(0)
 #endif
 
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 4c184285d38f..41abd1708496 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -66,48 +66,40 @@ static void __init soc_detect(u32 dbgu_base)
 	case ARCH_ID_AT91SAM9260:
 		at91_soc_initdata.type = AT91_SOC_SAM9260;
 		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
-		at91_boot_soc = at91sam9260_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9261:
 		at91_soc_initdata.type = AT91_SOC_SAM9261;
 		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
-		at91_boot_soc = at91sam9261_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9263:
 		at91_soc_initdata.type = AT91_SOC_SAM9263;
 		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
-		at91_boot_soc = at91sam9263_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9G20:
 		at91_soc_initdata.type = AT91_SOC_SAM9G20;
 		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
-		at91_boot_soc = at91sam9260_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9G45:
 		at91_soc_initdata.type = AT91_SOC_SAM9G45;
 		if (cidr == ARCH_ID_AT91SAM9G45ES)
 			at91_soc_initdata.subtype = AT91_SOC_SAM9G45ES;
-		at91_boot_soc = at91sam9g45_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9RL64:
 		at91_soc_initdata.type = AT91_SOC_SAM9RL;
 		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
-		at91_boot_soc = at91sam9rl_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9X5:
 		at91_soc_initdata.type = AT91_SOC_SAM9X5;
-		at91_boot_soc = at91sam9x5_soc;
 		break;
 
 	case ARCH_ID_AT91SAM9N12:
 		at91_soc_initdata.type = AT91_SOC_SAM9N12;
-		at91_boot_soc = at91sam9n12_soc;
 		break;
 
 	case ARCH_ID_SAMA5:
@@ -123,13 +115,11 @@ static void __init soc_detect(u32 dbgu_base)
 	if ((socid & ~AT91_CIDR_EXT) == ARCH_ID_AT91SAM9G10) {
 		at91_soc_initdata.type = AT91_SOC_SAM9G10;
 		at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_NONE;
-		at91_boot_soc = at91sam9261_soc;
 	}
 	/* at91sam9xe */
 	else if ((cidr & AT91_CIDR_ARCH) == ARCH_FAMILY_AT91SAM9XE) {
 		at91_soc_initdata.type = AT91_SOC_SAM9260;
 		at91_soc_initdata.subtype = AT91_SOC_SAM9XE;
-		at91_boot_soc = at91sam9260_soc;
 	}
 
 	if (!at91_soc_is_detected())
@@ -318,12 +308,6 @@ void __init at91_map_io(void)
 	if (at91_soc_initdata.subtype != AT91_SOC_SUBTYPE_NONE)
 		pr_info("Detected soc subtype: %s\n",
 			at91_get_soc_subtype(&at91_soc_initdata));
-
-	if (!at91_soc_is_enabled())
-		panic(pr_fmt("Soc not enabled"));
-
-	if (at91_boot_soc.map_io)
-		at91_boot_soc.map_io();
 }
 
 void __init at91_alt_map_io(void)
@@ -401,7 +385,4 @@ static void at91_dt_ramc(void)
 void __init at91_dt_initialize(void)
 {
 	at91_dt_ramc();
-
-	if (at91_boot_soc.init)
-		at91_boot_soc.init();
 }
diff --git a/arch/arm/mach-at91/soc.h b/arch/arm/mach-at91/soc.h
index ae6c0b2f1146..0593dcceb287 100644
--- a/arch/arm/mach-at91/soc.h
+++ b/arch/arm/mach-at91/soc.h
@@ -7,18 +7,10 @@
 struct at91_init_soc {
 	int builtin;
 	void (*map_io)(void);
-	void (*init)(void);
 };
 
 extern struct at91_init_soc at91_boot_soc;
 extern struct at91_init_soc at91rm9200_soc;
-extern struct at91_init_soc at91sam9260_soc;
-extern struct at91_init_soc at91sam9261_soc;
-extern struct at91_init_soc at91sam9263_soc;
-extern struct at91_init_soc at91sam9g45_soc;
-extern struct at91_init_soc at91sam9rl_soc;
-extern struct at91_init_soc at91sam9x5_soc;
-extern struct at91_init_soc at91sam9n12_soc;
 extern struct at91_init_soc sama5d3_soc;
 extern struct at91_init_soc sama5d4_soc;
 
@@ -40,34 +32,6 @@ static inline int at91_soc_is_enabled(void)
 #define at91rm9200_soc	at91_boot_soc
 #endif
 
-#if !defined(CONFIG_SOC_AT91SAM9260)
-#define at91sam9260_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_AT91SAM9261)
-#define at91sam9261_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_AT91SAM9263)
-#define at91sam9263_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_AT91SAM9G45)
-#define at91sam9g45_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_AT91SAM9RL)
-#define at91sam9rl_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_AT91SAM9X5)
-#define at91sam9x5_soc	at91_boot_soc
-#endif
-
-#if !defined(CONFIG_SOC_AT91SAM9N12)
-#define at91sam9n12_soc	at91_boot_soc
-#endif
-
 #if !defined(CONFIG_SOC_SAMA5D3)
 #define sama5d3_soc	at91_boot_soc
 #endif
-- 
2.1.3

