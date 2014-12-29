Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaL2Xd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:33:27 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:41143 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaL2Xc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 18:32:28 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        marc.zyngier@arm.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2 09/12] ARM: efm32: move into multiplatform
Date: Tue, 30 Dec 2014 00:32:12 +0100
Message-Id: <1419895935-22966-10-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1419895935-22966-1-git-send-email-stefan@agner.ch>
References: <1419895935-22966-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Since the multiplatform configuration can support no-MMU kernels now,
there is nothing stopping us from moving the efm32 platform in there
as well. This introduces a new ARCH_MULTI_V7M CPU architecture selection
option, since v7-M is incompatible with v7-A, and we can have either
of the two enabled for multiplatform, but not both at the same time.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/Kconfig                 | 35 ++++++++++++++++-------------------
 arch/arm/configs/efm32_defconfig |  2 ++
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 95007b9..8fe035b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -314,7 +314,7 @@ config ARCH_MULTIPLATFORM
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
 	select MIGHT_HAVE_PCI
-	select MULTI_IRQ_HANDLER
+	select MULTI_IRQ_HANDLER if !ARCH_MULTI_V7M
 	select SPARSE_IRQ
 	select USE_OF
 
@@ -400,24 +400,6 @@ config ARCH_EBSA110
 	  Ethernet interface, two PCMCIA sockets, two serial ports and a
 	  parallel port.
 
-config ARCH_EFM32
-	bool "Energy Micro efm32"
-	depends on !MMU
-	select ARCH_REQUIRE_GPIOLIB
-	select ARM_NVIC
-	select AUTO_ZRELADDR
-	select CLKSRC_OF
-	select COMMON_CLK
-	select CPU_V7M
-	select GENERIC_CLOCKEVENTS
-	select NO_DMA
-	select NO_IOPORT_MAP
-	select SPARSE_IRQ
-	select USE_OF
-	help
-	  Support for Energy Micro's (now Silicon Labs) efm32 Giant Gecko
-	  processors.
-
 config ARCH_EP93XX
 	bool "EP93xx-based"
 	select ARCH_HAS_HOLES_MEMORYMODEL
@@ -778,6 +760,14 @@ menu "Multiple platform selection"
 
 comment "CPU Core family selection"
 
+config ARCH_MULTI_V7M
+	bool "ARMv7-M based platforms (Cortex-M)"
+	depends on !MMU && !(ARCH_MULTI_V4_V5 || ARCH_MULTI_V6_V7)
+	select CPU_V7M
+	select ARM_NVIC
+	select NO_DMA # for now
+	select NO_IOPORT_MAP # for now
+
 config ARCH_MULTI_V4
 	bool "ARMv4 based platforms (FA526)"
 	depends on !ARCH_MULTI_V6_V7 && MMU
@@ -834,6 +824,13 @@ config ARCH_VIRT
 	select ARM_PSCI
 	select HAVE_ARM_ARCH_TIMER
 
+config ARCH_EFM32
+	bool "Energy Micro efm32" if ARCH_MULTI_V7M
+	depends on !MMU
+	help
+	  Support for Energy Micro's (now Silicon Labs) efm32 Giant Gecko
+	  processors.
+
 #
 # This is sorted alphabetically by mach-* pathname.  However, plat-*
 # Kconfigs may be included either alphabetically (according to the
diff --git a/arch/arm/configs/efm32_defconfig b/arch/arm/configs/efm32_defconfig
index f59fffb..7bd2486 100644
--- a/arch/arm/configs/efm32_defconfig
+++ b/arch/arm/configs/efm32_defconfig
@@ -16,6 +16,8 @@ CONFIG_EMBEDDED=y
 # CONFIG_IOSCHED_DEADLINE is not set
 # CONFIG_IOSCHED_CFQ is not set
 # CONFIG_MMU is not set
+# CONFIG_ARCH_MULTI_V7 is not set
+CONFIG_ARCH_MULTI_V7M=y
 CONFIG_ARCH_EFM32=y
 # CONFIG_KUSER_HELPERS is not set
 CONFIG_SET_MEM_PARAM=y
-- 
2.2.1

