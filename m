Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaL2Xce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:32:34 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:41133 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaL2Xc2 (ORCPT
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
Subject: [PATCH v2 08/12] ARM: allow MULTIPLATFORM with !MMU
Date: Tue, 30 Dec 2014 00:32:11 +0100
Message-Id: <1419895935-22966-9-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1419895935-22966-1-git-send-email-stefan@agner.ch>
References: <1419895935-22966-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support SoC with heterogenous CPU architectures (such
as Freescale Vybrid/i.MXSX) it is preferable to use the same
architecture (ARCH_MXC in this case) for the MMU enabled and !MMU
CPU. Hence allow to select MULTIPLATFORM even without MMU.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/Kconfig | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 97d07ed..95007b9 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -228,7 +228,7 @@ config VECTORS_BASE
 	  in size.
 
 config ARM_PATCH_PHYS_VIRT
-	bool "Patch physical to virtual translations at runtime" if EMBEDDED
+	bool "Patch physical to virtual translations at runtime" if EMBEDDED || (ARCH_MULTIPLATFORM && MMU)
 	default y
 	depends on !XIP_KERNEL && MMU
 	depends on !ARCH_REALVIEW || !SPARSEMEM
@@ -303,15 +303,12 @@ config MMU
 #
 choice
 	prompt "ARM system type"
-	default ARCH_VERSATILE if !MMU
-	default ARCH_MULTIPLATFORM if MMU
+	default ARCH_MULTIPLATFORM
 
 config ARCH_MULTIPLATFORM
 	bool "Allow multiple platforms to be selected"
-	depends on MMU
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARM_HAS_SG_CHAIN
-	select ARM_PATCH_PHYS_VIRT
 	select AUTO_ZRELADDR
 	select CLKSRC_OF
 	select COMMON_CLK
@@ -783,13 +780,13 @@ comment "CPU Core family selection"
 
 config ARCH_MULTI_V4
 	bool "ARMv4 based platforms (FA526)"
-	depends on !ARCH_MULTI_V6_V7
+	depends on !ARCH_MULTI_V6_V7 && MMU
 	select ARCH_MULTI_V4_V5
 	select CPU_FA526
 
 config ARCH_MULTI_V4T
 	bool "ARMv4T based platforms (ARM720T, ARM920T, ...)"
-	depends on !ARCH_MULTI_V6_V7
+	depends on !ARCH_MULTI_V6_V7 && MMU
 	select ARCH_MULTI_V4_V5
 	select CPU_ARM920T if !(CPU_ARM7TDMI || CPU_ARM720T || \
 		CPU_ARM740T || CPU_ARM9TDMI || CPU_ARM922T || \
@@ -797,7 +794,7 @@ config ARCH_MULTI_V4T
 
 config ARCH_MULTI_V5
 	bool "ARMv5 based platforms (ARM926T, XSCALE, PJ1, ...)"
-	depends on !ARCH_MULTI_V6_V7
+	depends on !ARCH_MULTI_V6_V7 && MMU
 	select ARCH_MULTI_V4_V5
 	select CPU_ARM926T if !(CPU_ARM946E || CPU_ARM1020 || \
 		CPU_ARM1020E || CPU_ARM1022 || CPU_ARM1026 || \
@@ -808,11 +805,13 @@ config ARCH_MULTI_V4_V5
 
 config ARCH_MULTI_V6
 	bool "ARMv6 based platforms (ARM11)"
+	depends on MMU
 	select ARCH_MULTI_V6_V7
 	select CPU_V6K
 
 config ARCH_MULTI_V7
-	bool "ARMv7 based platforms (Cortex-A, PJ4, Scorpion, Krait)"
+	bool "ARMv7-A based platforms (Cortex-A, PJ4, Scorpion, Krait)"
+	depends on MMU
 	default y
 	select ARCH_MULTI_V6_V7
 	select CPU_V7
@@ -823,7 +822,7 @@ config ARCH_MULTI_V6_V7
 	select MIGHT_HAVE_CACHE_L2X0
 
 config ARCH_MULTI_CPU_AUTO
-	def_bool !(ARCH_MULTI_V4 || ARCH_MULTI_V4T || ARCH_MULTI_V6_V7)
+	def_bool !(ARCH_MULTI_V4 || ARCH_MULTI_V4T || ARCH_MULTI_V6_V7) && MMU
 	select ARCH_MULTI_V5
 
 endmenu
@@ -1960,7 +1959,7 @@ endchoice
 
 config XIP_KERNEL
 	bool "Kernel Execute-In-Place from ROM"
-	depends on !ARM_LPAE && !ARCH_MULTIPLATFORM
+	depends on !ARM_LPAE && (!ARCH_MULTIPLATFORM || ARCH_MULTI_V7M)
 	help
 	  Execute-In-Place allows the kernel to run from non-volatile storage
 	  directly addressable by the CPU, such as NOR flash. This saves RAM
-- 
2.2.1

