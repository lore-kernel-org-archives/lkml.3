Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbbALSm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:42:29 -0500
Received: from down.free-electrons.com ([37.187.137.238]:56627 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755684AbbALSm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:42:26 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 5/7] ARM: at91: move debug-macro.S into the common space
Date: Mon, 12 Jan 2015 19:42:14 +0100
Message-Id: <1421088136-10172-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421088136-10172-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421088136-10172-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move debug-macro.S from include/mach/ to include/debug where all other common
debug macros are.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 MAINTAINERS                                           |  1 +
 arch/arm/Kconfig.debug                                |  9 +++++++--
 .../mach/debug-macro.S => include/debug/at91.S}       | 19 +++++++++++--------
 3 files changed, 19 insertions(+), 10 deletions(-)
 rename arch/arm/{mach-at91/include/mach/debug-macro.S => include/debug/at91.S} (68%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3589d67437f8..8c25979a3c43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -877,6 +877,7 @@ F:	arch/arm/boot/dts/at91*.dts
 F:	arch/arm/boot/dts/at91*.dtsi
 F:	arch/arm/boot/dts/sama*.dts
 F:	arch/arm/boot/dts/sama*.dtsi
+F:	arch/arm/include/debug/at91.S
 
 ARM/ATMEL AT91 Clock Support
 M:	Boris Brezillon <boris.brezillon@free-electrons.com>
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 5ddd4906f7a7..e34d24949c6a 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -115,15 +115,18 @@ choice
 		    0x80024000      | 0xf0024000     | UART9
 
 	config AT91_DEBUG_LL_DBGU0
-		bool "Kernel low-level debugging on rm9200, 9260/9g20, 9261/9g10 and 9rl"
+		bool "Kernel low-level debugging on rm9200, 9260/9g20, 9261/9g10, 9rl, 9x5, 9n12"
+		select DEBUG_AT91_UART
 		depends on HAVE_AT91_DBGU0
 
 	config AT91_DEBUG_LL_DBGU1
-		bool "Kernel low-level debugging on 9263 and 9g45"
+		bool "Kernel low-level debugging on 9263, 9g45 and sama5d3"
+		select DEBUG_AT91_UART
 		depends on HAVE_AT91_DBGU1
 
 	config AT91_DEBUG_LL_DBGU2
 		bool "Kernel low-level debugging on sama5d4"
+		select DEBUG_AT91_UART
 		depends on HAVE_AT91_DBGU2
 
 	config DEBUG_BCM2835
@@ -1165,6 +1168,8 @@ config DEBUG_LL_INCLUDE
 	string
 	default "debug/sa1100.S" if DEBUG_SA1100
 	default "debug/8250.S" if DEBUG_LL_UART_8250 || DEBUG_UART_8250
+	default "debug/at91.S" if AT91_DEBUG_LL_DBGU0 || AT91_DEBUG_LL_DBGU1 || \
+				AT91_DEBUG_LL_DBGU2
 	default "debug/asm9260.S" if DEBUG_ASM9260_UART
 	default "debug/clps711x.S" if DEBUG_CLPS711X_UART1 || DEBUG_CLPS711X_UART2
 	default "debug/meson.S" if DEBUG_MESON_UARTAO
diff --git a/arch/arm/mach-at91/include/mach/debug-macro.S b/arch/arm/include/debug/at91.S
similarity index 68%
rename from arch/arm/mach-at91/include/mach/debug-macro.S
rename to arch/arm/include/debug/at91.S
index 2103a90f2261..80a6501b4d50 100644
--- a/arch/arm/mach-at91/include/mach/debug-macro.S
+++ b/arch/arm/include/debug/at91.S
@@ -1,6 +1,4 @@
 /*
- * arch/arm/mach-at91/include/mach/debug-macro.S
- *
  *  Copyright (C) 2003-2005 SAN People
  *
  * Debugging macro include header
@@ -11,18 +9,23 @@
  *
 */
 
-#include <mach/hardware.h>
-#include <mach/at91_dbgu.h>
-
 #if defined(CONFIG_AT91_DEBUG_LL_DBGU0)
-#define AT91_DBGU AT91_BASE_DBGU0
+#define AT91_DBGU 0xfffff200 /* AT91_BASE_DBGU0 */
 #elif defined(CONFIG_AT91_DEBUG_LL_DBGU1)
-#define AT91_DBGU AT91_BASE_DBGU1
+#define AT91_DBGU 0xffffee00 /* AT91_BASE_DBGU1 */
 #else
 /* On sama5d4, use USART3 as low level serial console */
-#define AT91_DBGU SAMA5D4_BASE_USART3
+#define AT91_DBGU 0xfc00c000 /* SAMA5D4_BASE_USART3 */
 #endif
 
+/* Keep in sync with mach-at91/include/mach/hardware.h */
+#define AT91_IO_P2V(x) ((x) - 0x01000000)
+
+#define AT91_DBGU_SR		(0x14)	/* Status Register */
+#define AT91_DBGU_THR		(0x1c)	/* Transmitter Holding Register */
+#define AT91_DBGU_TXRDY		(1 << 1)	/* Transmitter Ready */
+#define AT91_DBGU_TXEMPTY	(1 << 9)	/* Transmitter Empty */
+
 	.macro	addruart, rp, rv, tmp
 	ldr	\rp, =AT91_DBGU				@ System peripherals (phys address)
 	ldr	\rv, =AT91_IO_P2V(AT91_DBGU)		@ System peripherals (virt address)
-- 
2.1.0

