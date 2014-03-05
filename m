Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbaCEWIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:08:01 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:38298 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaCEWIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:08:00 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2] ARM: vf610: add UART choice for low-level debug
Date: Wed,  5 Mar 2014 23:07:48 +0100
Message-Id: <4031771265d98dad7b0cc15a1e523f026338b432.1394057216.git.stefan@agner.ch>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add choice for low-level debug UART. Similar to i.MX6, there is a
numeric configuration, valid choices are 0 to 3.
Note that the kernel assumes that the boot loader initialized clock
properly.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/Kconfig.debug      |  9 +++++++++
 arch/arm/include/debug/vf.S | 15 +++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 0531da8..c2005a7 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -946,6 +946,15 @@ config DEBUG_IMX_UART_PORT
 	  Choose UART port on which kernel low-level debug messages
 	  should be output.
 
+config DEBUG_VF_UART_PORT
+	int "Vybrid Debug UART Port Selection" if DEBUG_VF_UART
+	default 1
+	range 0 3
+	depends on SOC_VF610
+	help
+	  Choose UART port on which kernel low-level debug messages
+	  should be output.
+
 config DEBUG_TEGRA_UART
 	bool
 	depends on ARCH_TEGRA
diff --git a/arch/arm/include/debug/vf.S b/arch/arm/include/debug/vf.S
index ba12cc4..b889338 100644
--- a/arch/arm/include/debug/vf.S
+++ b/arch/arm/include/debug/vf.S
@@ -7,9 +7,20 @@
  *
  */
 
+#define VF_UART0_BASE_ADDR	0x40027000
+#define VF_UART1_BASE_ADDR	0x40028000
+#define VF_UART2_BASE_ADDR	0x40029000
+#define VF_UART3_BASE_ADDR	0x4002a000
+#define VF_UART_BASE_ADDR(n)	VF_UART##n##_BASE_ADDR
+#define VF_UART_BASE(n)		VF_UART_BASE_ADDR(n)
+#define VF_UART_PHYSICAL_BASE	VF_UART_BASE(CONFIG_DEBUG_VF_UART_PORT)
+
+#define VF_UART_VIRTUAL_BASE	0xfe000000
+
 	.macro	addruart, rp, rv, tmp
-	ldr	\rp, =0x40028000	@ physical
-	ldr	\rv, =0xfe028000	@ virtual
+	ldr	\rp, =VF_UART_PHYSICAL_BASE 	@ physical
+	and	\rv, \rp, #0xffffff		@ offset within 16MB section
+	add	\rv, \rv, #VF_UART_VIRTUAL_BASE
 	.endm
 
 	.macro	senduart, rd, rx
-- 
1.9.0

