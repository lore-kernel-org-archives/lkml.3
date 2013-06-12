Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab3FLBsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:48:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59584 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755Ab3FLBsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:48:10 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] ARM: msm: Move debug-macro.S to include/debug
Date: Tue, 11 Jun 2013 18:48:04 -0700
Message-Id: <1371001686-15985-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.251.g1462b67
In-Reply-To: <1371001686-15985-1-git-send-email-sboyd@codeaurora.org>
References: <1371001686-15985-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more step to allowing MSM to participate in the
multi-platform defconfig.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig.debug                             |  9 +++-
 .../mach/debug-macro.S => include/debug/msm.S}     | 32 ++++++++++-
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h    |  9 ----
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h    |  9 ----
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h    |  5 --
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h    |  9 ----
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h    |  5 --
 arch/arm/mach-msm/include/mach/msm_iomap.h         | 12 -----
 arch/arm/mach-msm/include/mach/uncompress.h        | 63 ----------------------
 arch/arm/mach-msm/io.c                             | 23 ++------
 10 files changed, 42 insertions(+), 134 deletions(-)
 rename arch/arm/{mach-msm/include/mach/debug-macro.S => include/debug/msm.S} (61%)
 delete mode 100644 arch/arm/mach-msm/include/mach/uncompress.h

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 1d41908..b6c2875 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -632,6 +632,11 @@ config DEBUG_LL_INCLUDE
 				 DEBUG_IMX51_UART || \
 				 DEBUG_IMX53_UART ||\
 				 DEBUG_IMX6Q_UART
+	default "debug/msm.S" if DEBUG_MSM_UART1 || \
+				 DEBUG_MSM_UART2 || \
+				 DEBUG_MSM_UART3 || \
+				 DEBUG_MSM8660_UART || \
+				 DEBUG_MSM8960_UART
 	default "debug/mvebu.S" if DEBUG_MVEBU_UART
 	default "debug/mxs.S" if DEBUG_IMX23_UART || DEBUG_IMX28_UART
 	default "debug/nomadik.S" if DEBUG_NOMADIK_UART
@@ -652,13 +657,13 @@ config DEBUG_LL_INCLUDE
 
 config DEBUG_UNCOMPRESS
 	bool
-	default y if ARCH_MULTIPLATFORM && DEBUG_LL && \
+	default y if (ARCH_MULTIPLATFORM || ARCH_MSM) && DEBUG_LL && \
 		     !DEBUG_OMAP2PLUS_UART && \
 		     !DEBUG_TEGRA_UART
 
 config UNCOMPRESS_INCLUDE
 	string
-	default "debug/uncompress.h" if ARCH_MULTIPLATFORM
+	default "debug/uncompress.h" if ARCH_MULTIPLATFORM || ARCH_MSM
 	default "mach/uncompress.h"
 
 config EARLY_PRINTK
diff --git a/arch/arm/mach-msm/include/mach/debug-macro.S b/arch/arm/include/debug/msm.S
similarity index 61%
rename from arch/arm/mach-msm/include/mach/debug-macro.S
rename to arch/arm/include/debug/msm.S
index 0e05f88..9166e1b 100644
--- a/arch/arm/mach-msm/include/mach/debug-macro.S
+++ b/arch/arm/include/debug/msm.S
@@ -15,8 +15,36 @@
  *
  */
 
-#include <mach/hardware.h>
-#include <mach/msm_iomap.h>
+#if defined(CONFIG_ARCH_MSM7X00A) || defined(CONFIG_ARCH_QSD8X50)
+#define MSM_UART1_PHYS        0xA9A00000
+#define MSM_UART2_PHYS        0xA9B00000
+#define MSM_UART3_PHYS        0xA9C00000
+#elif defined(CONFIG_ARCH_MSM7X30)
+#define MSM_UART1_PHYS        0xACA00000
+#define MSM_UART2_PHYS        0xACB00000
+#define MSM_UART3_PHYS        0xACC00000
+#endif
+
+#if defined(CONFIG_DEBUG_MSM_UART1)
+#define MSM_DEBUG_UART_BASE	0xE1000000
+#define MSM_DEBUG_UART_PHYS	MSM_UART1_PHYS
+#elif defined(CONFIG_DEBUG_MSM_UART2)
+#define MSM_DEBUG_UART_BASE	0xE1000000
+#define MSM_DEBUG_UART_PHYS	MSM_UART2_PHYS
+#elif defined(CONFIG_DEBUG_MSM_UART3)
+#define MSM_DEBUG_UART_BASE	0xE1000000
+#define MSM_DEBUG_UART_PHYS	MSM_UART3_PHYS
+#endif
+
+#ifdef CONFIG_DEBUG_MSM8660_UART
+#define MSM_DEBUG_UART_BASE	0xF0040000
+#define MSM_DEBUG_UART_PHYS	0x19C40000
+#endif
+
+#ifdef CONFIG_DEBUG_MSM8960_UART
+#define MSM_DEBUG_UART_BASE	0xF0040000
+#define MSM_DEBUG_UART_PHYS	0x16440000
+#endif
 
 	.macro	addruart, rp, rv, tmp
 #ifdef MSM_DEBUG_UART_PHYS
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
index 67dc0e9..5c604d4 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
@@ -63,15 +63,6 @@
 #define MSM_SHARED_RAM_PHYS   0x01F00000
 #define MSM_SHARED_RAM_SIZE   SZ_1M
 
-#define MSM_UART1_PHYS        0xA9A00000
-#define MSM_UART1_SIZE        SZ_4K
-
-#define MSM_UART2_PHYS        0xA9B00000
-#define MSM_UART2_SIZE        SZ_4K
-
-#define MSM_UART3_PHYS        0xA9C00000
-#define MSM_UART3_SIZE        SZ_4K
-
 #define MSM_SDC1_PHYS         0xA0400000
 #define MSM_SDC1_SIZE         SZ_4K
 
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
index 198202c..0676648 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
@@ -80,15 +80,6 @@
 #define MSM_SHARED_RAM_PHYS   0x00100000
 #define MSM_SHARED_RAM_SIZE   SZ_1M
 
-#define MSM_UART1_PHYS        0xACA00000
-#define MSM_UART1_SIZE        SZ_4K
-
-#define MSM_UART2_PHYS        0xACB00000
-#define MSM_UART2_SIZE        SZ_4K
-
-#define MSM_UART3_PHYS        0xACC00000
-#define MSM_UART3_SIZE        SZ_4K
-
 #define MSM_MDC_BASE	      IOMEM(0xE0200000)
 #define MSM_MDC_PHYS	      0xAA500000
 #define MSM_MDC_SIZE	      SZ_1M
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
index 7bca8d7..396958b 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
@@ -38,9 +38,4 @@
 #define MSM8960_TMR0_PHYS	0x0208A000
 #define MSM8960_TMR0_SIZE	SZ_4K
 
-#ifdef CONFIG_DEBUG_MSM8960_UART
-#define MSM_DEBUG_UART_BASE	0xF0040000
-#define MSM_DEBUG_UART_PHYS	0x16440000
-#endif
-
 #endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
index 0faa894..57e59cb 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
@@ -74,15 +74,6 @@
 #define MSM_SHARED_RAM_PHYS (MSM_SMI_BASE + 0x00100000)
 #define MSM_SHARED_RAM_SIZE   SZ_1M
 
-#define MSM_UART1_PHYS        0xA9A00000
-#define MSM_UART1_SIZE        SZ_4K
-
-#define MSM_UART2_PHYS        0xA9B00000
-#define MSM_UART2_SIZE        SZ_4K
-
-#define MSM_UART3_PHYS        0xA9C00000
-#define MSM_UART3_SIZE        SZ_4K
-
 #define MSM_MDC_BASE	      IOMEM(0xE0200000)
 #define MSM_MDC_PHYS	      0xAA500000
 #define MSM_MDC_SIZE	      SZ_1M
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index 4f57b43..dede6aa 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -41,9 +41,4 @@
 #define MSM8X60_TMR0_PHYS	0x02040000
 #define MSM8X60_TMR0_SIZE	SZ_4K
 
-#ifdef CONFIG_DEBUG_MSM8660_UART
-#define MSM_DEBUG_UART_BASE	0xF0040000
-#define MSM_DEBUG_UART_PHYS	0x19C40000
-#endif
-
 #endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index c56e81f..0b36c42 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -48,18 +48,6 @@
 #include "msm_iomap-8x60.h"
 #include "msm_iomap-8960.h"
 
-#define MSM_DEBUG_UART_SIZE	SZ_4K
-#if defined(CONFIG_DEBUG_MSM_UART1)
-#define MSM_DEBUG_UART_BASE	0xE1000000
-#define MSM_DEBUG_UART_PHYS	MSM_UART1_PHYS
-#elif defined(CONFIG_DEBUG_MSM_UART2)
-#define MSM_DEBUG_UART_BASE	0xE1000000
-#define MSM_DEBUG_UART_PHYS	MSM_UART2_PHYS
-#elif defined(CONFIG_DEBUG_MSM_UART3)
-#define MSM_DEBUG_UART_BASE	0xE1000000
-#define MSM_DEBUG_UART_PHYS	MSM_UART3_PHYS
-#endif
-
 /* Virtual addresses shared across all MSM targets. */
 #define MSM_CSR_BASE		IOMEM(0xE0001000)
 #define MSM_TMR_BASE		IOMEM(0xF0200000)
diff --git a/arch/arm/mach-msm/include/mach/uncompress.h b/arch/arm/mach-msm/include/mach/uncompress.h
deleted file mode 100644
index 9432487..0000000
--- a/arch/arm/mach-msm/include/mach/uncompress.h
+++ /dev/null
@@ -1,63 +0,0 @@
-/*
- * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef __ASM_ARCH_MSM_UNCOMPRESS_H
-#define __ASM_ARCH_MSM_UNCOMPRESS_H
-
-#include <asm/barrier.h>
-#include <asm/processor.h>
-#include <mach/msm_iomap.h>
-
-#define UART_CSR      (*(volatile uint32_t *)(MSM_DEBUG_UART_PHYS + 0x08))
-#define UART_TF       (*(volatile uint32_t *)(MSM_DEBUG_UART_PHYS + 0x0c))
-
-#define UART_DM_SR    (*((volatile uint32_t *)(MSM_DEBUG_UART_PHYS + 0x08)))
-#define UART_DM_CR    (*((volatile uint32_t *)(MSM_DEBUG_UART_PHYS + 0x10)))
-#define UART_DM_ISR   (*((volatile uint32_t *)(MSM_DEBUG_UART_PHYS + 0x14)))
-#define UART_DM_NCHAR (*((volatile uint32_t *)(MSM_DEBUG_UART_PHYS + 0x40)))
-#define UART_DM_TF    (*((volatile uint32_t *)(MSM_DEBUG_UART_PHYS + 0x70)))
-
-static void putc(int c)
-{
-#if defined(MSM_DEBUG_UART_PHYS)
-#ifdef CONFIG_MSM_HAS_DEBUG_UART_HS
-	/*
-	 * Wait for TX_READY to be set; but skip it if we have a
-	 * TX underrun.
-	 */
-	if (!(UART_DM_SR & 0x08))
-		while (!(UART_DM_ISR & 0x80))
-			cpu_relax();
-
-	UART_DM_CR = 0x300;
-	UART_DM_NCHAR = 0x1;
-	UART_DM_TF = c;
-#else
-	while (!(UART_CSR & 0x04))
-		cpu_relax();
-	UART_TF = c;
-#endif
-#endif
-}
-
-static inline void flush(void)
-{
-}
-
-static inline void arch_decomp_setup(void)
-{
-}
-
-#endif
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index efa113e..284cc56 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -52,10 +52,6 @@ static struct map_desc msm_io_desc[] __initdata = {
 	MSM_CHIP_DEVICE_TYPE(GPIO1, MSM7X00, MT_DEVICE_NONSHARED),
 	MSM_CHIP_DEVICE_TYPE(GPIO2, MSM7X00, MT_DEVICE_NONSHARED),
 	MSM_DEVICE_TYPE(CLK_CTL, MT_DEVICE_NONSHARED),
-#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
-	defined(CONFIG_DEBUG_MSM_UART3)
-	MSM_DEVICE_TYPE(DEBUG_UART, MT_DEVICE_NONSHARED),
-#endif
 	{
 		.virtual =  (unsigned long) MSM_SHARED_RAM_BASE,
 		.pfn = __phys_to_pfn(MSM_SHARED_RAM_PHYS),
@@ -71,6 +67,7 @@ void __init msm_map_common_io(void)
 	 * pages are peripheral interface or not.
 	 */
 	asm("mcr p15, 0, %0, c15, c2, 4" : : "r" (0));
+	debug_ll_io_init();
 	iotable_init(msm_io_desc, ARRAY_SIZE(msm_io_desc));
 }
 #endif
@@ -87,10 +84,6 @@ static struct map_desc qsd8x50_io_desc[] __initdata = {
 	MSM_DEVICE(SCPLL),
 	MSM_DEVICE(AD5),
 	MSM_DEVICE(MDC),
-#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
-	defined(CONFIG_DEBUG_MSM_UART3)
-	MSM_DEVICE(DEBUG_UART),
-#endif
 	{
 		.virtual =  (unsigned long) MSM_SHARED_RAM_BASE,
 		.pfn = __phys_to_pfn(MSM_SHARED_RAM_PHYS),
@@ -101,6 +94,7 @@ static struct map_desc qsd8x50_io_desc[] __initdata = {
 
 void __init msm_map_qsd8x50_io(void)
 {
+	debug_ll_io_init();
 	iotable_init(qsd8x50_io_desc, ARRAY_SIZE(qsd8x50_io_desc));
 }
 #endif /* CONFIG_ARCH_QSD8X50 */
@@ -109,13 +103,11 @@ void __init msm_map_qsd8x50_io(void)
 static struct map_desc msm8x60_io_desc[] __initdata = {
 	MSM_CHIP_DEVICE(TMR, MSM8X60),
 	MSM_CHIP_DEVICE(TMR0, MSM8X60),
-#ifdef CONFIG_DEBUG_MSM8660_UART
-	MSM_DEVICE(DEBUG_UART),
-#endif
 };
 
 void __init msm_map_msm8x60_io(void)
 {
+	debug_ll_io_init();
 	iotable_init(msm8x60_io_desc, ARRAY_SIZE(msm8x60_io_desc));
 }
 #endif /* CONFIG_ARCH_MSM8X60 */
@@ -124,13 +116,11 @@ void __init msm_map_msm8x60_io(void)
 static struct map_desc msm8960_io_desc[] __initdata = {
 	MSM_CHIP_DEVICE(TMR, MSM8960),
 	MSM_CHIP_DEVICE(TMR0, MSM8960),
-#ifdef CONFIG_DEBUG_MSM8960_UART
-	MSM_DEVICE(DEBUG_UART),
-#endif
 };
 
 void __init msm_map_msm8960_io(void)
 {
+	debug_ll_io_init();
 	iotable_init(msm8960_io_desc, ARRAY_SIZE(msm8960_io_desc));
 }
 #endif /* CONFIG_ARCH_MSM8960 */
@@ -150,10 +140,6 @@ static struct map_desc msm7x30_io_desc[] __initdata = {
 	MSM_DEVICE(SAW),
 	MSM_DEVICE(GCC),
 	MSM_DEVICE(TCSR),
-#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
-	defined(CONFIG_DEBUG_MSM_UART3)
-	MSM_DEVICE(DEBUG_UART),
-#endif
 	{
 		.virtual =  (unsigned long) MSM_SHARED_RAM_BASE,
 		.pfn = __phys_to_pfn(MSM_SHARED_RAM_PHYS),
@@ -164,6 +150,7 @@ static struct map_desc msm7x30_io_desc[] __initdata = {
 
 void __init msm_map_msm7x30_io(void)
 {
+	debug_ll_io_init();
 	iotable_init(msm7x30_io_desc, ARRAY_SIZE(msm7x30_io_desc));
 }
 #endif /* CONFIG_ARCH_MSM7X30 */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

