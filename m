Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3IQWAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 18:00:10 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2517 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab3IQWAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 18:00:08 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Christian Daudt" <csd@broadcom.com>
To: "Russell King" <linux@arm.linux.org.uk>, "Olof Johansson" <olof@lixom.net>,
        "Stephen Warren" <swarren@nvidia.com>
cc: "Christian Daudt" <csd@broadcom.com>, linux-arm-kernel@lists.infradead.org,
        "Chris Ball" <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        bcm@fixthebug.org
Subject: [PATCH] ARM: bcm: Add DEBUG_LL console support
Date: Tue, 17 Sep 2013 14:59:47 -0700
Message-ID: <1379455187-5812-1-git-send-email-csd@broadcom.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
X-WSS-ID: 7E2610660UO8260549-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds low level debug uart support to Broadcom
 mobile based SOCs.

Signed-off-by: Christian Daudt <csd@broadcom.com>
Reviewed-by: James King <jamesk@broadcom.com>

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 583f4a0..a69d62a 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -93,6 +93,16 @@ choice
 		bool "Kernel low-level debugging on BCM2835 PL011 UART"
 		depends on ARCH_BCM2835
 
+	config DEBUG_BCM_KONA_UART
+		bool "Kernel low-level debugging messages via BCM KONA UART"
+		depends on ARCH_BCM
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Broadcom SoC platforms.
+		  This low level debug works for Broadcom
+		  mobile SoCs in the Kona family of chips (e.g. bcm28155,
+		  bcm11351, etc...)
+
 	config DEBUG_CLPS711X_UART1
 		bool "Kernel low-level debugging messages via UART1"
 		depends on ARCH_CLPS711X
@@ -761,6 +771,7 @@ endchoice
 
 config DEBUG_LL_INCLUDE
 	string
+	default "debug/bcm_kona.S" if DEBUG_BCM_KONA_UART
 	default "debug/bcm2835.S" if DEBUG_BCM2835
 	default "debug/cns3xxx.S" if DEBUG_CNS3XXX
 	default "debug/exynos.S" if DEBUG_EXYNOS_UART
diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index 65edf6d..ace92e4 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -30,6 +30,8 @@ CONFIG_ARCH_BCM=y
 CONFIG_ARM_THUMBEE=y
 CONFIG_ARM_ERRATA_743622=y
 CONFIG_PREEMPT=y
+CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_BCM_KONA_UART=y
 CONFIG_AEABI=y
 # CONFIG_OABI_COMPAT is not set
 # CONFIG_COMPACTION is not set
diff --git a/arch/arm/include/debug/bcm_kona.S b/arch/arm/include/debug/bcm_kona.S
new file mode 100644
index 0000000..5e22032
--- /dev/null
+++ b/arch/arm/include/debug/bcm_kona.S
@@ -0,0 +1,20 @@
+/*
+ * Copyright (C) 1994-1999 Russell King
+ * Moved from linux/arch/arm/kernel/debug.S by Ben Dooks
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Modified by Broadcom for Kona chipsets
+ */
+#define	UARTB_PHYS_BASE	0x3e000000
+#define	UART_SHIFT	2
+
+		.macro	addruart, rp, rv, tmp
+		mov	\rp, #UARTB_PHYS_BASE	@ physical base address of UART
+		mov	\rv, #0x0e300000	@ virtual base address of UART
+		orr	\rv, \rv, #0xf0000000
+		.endm
+
+#include "8250_32.S"
-- 
1.7.10.4


