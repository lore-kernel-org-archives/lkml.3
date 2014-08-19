Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbaHSPTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:19:20 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:57812 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaHSPRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:17:09 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Greg Ungerer <gerg@uclinux.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: [PATCH v9 4/9] arm: ks8695: Migrate debug_ll macros to shared directory
Date: Tue, 19 Aug 2014 16:16:42 +0100
Message-Id: <1408461407-10429-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408461407-10429-1-git-send-email-daniel.thompson@linaro.org>
References: <1408459715-10151-1-git-send-email-daniel.thompson@linaro.org>
 <1408461407-10429-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the migration a couple of uart definitions have been copied
from of the platform specific header files.

Note that, in order to keep oldconfig working nicely we must defer the
removal of arch/arm/mach-ks8695/include/mach/debug-macro.S until
DEBUG_LL_UART_NONE has been removed.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
---
 arch/arm/Kconfig.debug                                         |  8 ++++++++
 .../include/mach/debug-macro.S => include/debug/ks8695.S}      | 10 +++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)
 rename arch/arm/{mach-ks8695/include/mach/debug-macro.S => include/debug/ks8695.S} (80%)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 9c46729..97c3058 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -348,6 +348,13 @@ choice
 		  Say Y here if you want the debug print routines to direct
 		  their output to UART1 serial port on KEYSTONE2 devices.
 
+	config DEBUG_KS8695_UART
+		bool "KS8695 Debug UART"
+		depends on ARCH_KS8695
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on KS8695.
+
 	config DEBUG_MMP_UART2
 		bool "Kernel low-level debugging message via MMP UART2"
 		depends on ARCH_MMP
@@ -1017,6 +1024,7 @@ config DEBUG_LL_INCLUDE
 				 DEBUG_IMX6Q_UART || \
 				 DEBUG_IMX6SL_UART || \
 				 DEBUG_IMX6SX_UART
+	default "debug/ks8695.S" if DEBUG_KS8695_UART
 	default "debug/msm.S" if DEBUG_MSM_UART || DEBUG_QCOM_UARTDM
 	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
 	default "debug/s3c24xx.S" if DEBUG_S3C24XX_UART
diff --git a/arch/arm/mach-ks8695/include/mach/debug-macro.S b/arch/arm/include/debug/ks8695.S
similarity index 80%
rename from arch/arm/mach-ks8695/include/mach/debug-macro.S
rename to arch/arm/include/debug/ks8695.S
index a79e489..961da1f 100644
--- a/arch/arm/mach-ks8695/include/mach/debug-macro.S
+++ b/arch/arm/include/debug/ks8695.S
@@ -1,5 +1,5 @@
 /*
- * arch/arm/mach-ks8695/include/mach/debug-macro.S
+ * arch/arm/include/debug/ks8695.S
  *
  * Copyright (C) 2006 Ben Dooks <ben@simtec.co.uk>
  * Copyright (C) 2006 Simtec Electronics
@@ -11,8 +11,12 @@
  * published by the Free Software Foundation.
  */
 
-#include <mach/hardware.h>
-#include <mach/regs-uart.h>
+#define KS8695_UART_PA	0x03ffe000
+#define KS8695_UART_VA	0xf00fe000
+#define KS8695_URTH	(0x04)
+#define KS8695_URLS	(0x14)
+#define URLS_URTE	(1 << 6)
+#define URLS_URTHRE	(1 << 5)
 
 	.macro	addruart, rp, rv, tmp
 		ldr	\rp, =KS8695_UART_PA		@ physical base address
-- 
1.9.3

