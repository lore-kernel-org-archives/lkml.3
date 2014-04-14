Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbaDNNtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:49:09 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:46826 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbaDNNtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:49:06 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH] ARM: debug: qcom: make UART address selection configuration option
Date: Mon, 14 Apr 2014 16:47:34 +0300
Message-Id: <1397483254-3612-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <53458708.40702@codeaurora.org>
References: <53458708.40702@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Separate Qualcomm low-level debugging UART to two options.

DEBUG_MSM_UART is used in earlier non-multi platform arches,
like MSM7X00A, QSD8X50 and MSM7X30.

DEBUG_QCOM_UARTDM is used in multi-plafrom arches and have
embedded data mover.

Make DEBUG_UART_PHYS and DEBUG_UART_BASE user adjustable by
Kconfig menu.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 arch/arm/Kconfig.debug       | 81 ++++++++++++++++++--------------------------
 arch/arm/include/debug/msm.S | 46 +++----------------------
 arch/arm/mach-msm/Kconfig    |  3 --
 3 files changed, 38 insertions(+), 92 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 4a2fc0bf..cdbfd8b 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -349,56 +349,39 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on MMP UART3.

-	config DEBUG_MSM_UART1
-		bool "Kernel low-level debugging messages via MSM UART1"
-		depends on ARCH_MSM7X00A || ARCH_MSM7X30 || ARCH_QSD8X50
-		select DEBUG_MSM_UART
+	config DEBUG_MSM_UART
+		bool "Kernel low-level debugging messages via MSM UART"
+		depends on ARCH_MSM
 		help
 		  Say Y here if you want the debug print routines to direct
-		  their output to the first serial port on MSM devices.
+		  their output to the serial port on MSM devices.

-	config DEBUG_MSM_UART2
-		bool "Kernel low-level debugging messages via MSM UART2"
-		depends on ARCH_MSM7X00A || ARCH_MSM7X30 || ARCH_QSD8X50
-		select DEBUG_MSM_UART
-		help
-		  Say Y here if you want the debug print routines to direct
-		  their output to the second serial port on MSM devices.
+		  ARCH                DEBUG_UART_PHYS   DEBUG_UART_BASE   #
+		  MSM7X00A, QSD8X50   0xa9a00000        0xe1000000        UART1
+		  MSM7X00A, QSD8X50   0xa9b00000        0xe1000000        UART2
+		  MSM7X00A, QSD8X50   0xa9c00000        0xe1000000        UART3

-	config DEBUG_MSM_UART3
-		bool "Kernel low-level debugging messages via MSM UART3"
-		depends on ARCH_MSM7X00A || ARCH_MSM7X30 || ARCH_QSD8X50
-		select DEBUG_MSM_UART
-		help
-		  Say Y here if you want the debug print routines to direct
-		  their output to the third serial port on MSM devices.
+		  MSM7X30             0xaca00000        0xe1000000        UART1
+		  MSM7X30             0xacb00000        0xe1000000        UART2
+		  MSM7X30             0xacc00000        0xe1000000        UART3

-	config DEBUG_MSM8660_UART
-		bool "Kernel low-level debugging messages via MSM 8660 UART"
-		depends on ARCH_MSM8X60
-		select MSM_HAS_DEBUG_UART_HS
-		select DEBUG_MSM_UART
-		help
-		  Say Y here if you want the debug print routines to direct
-		  their output to the serial port on MSM 8660 devices.
+		  Please adjust DEBUG_UART_PHYS and DEBUG_UART_BASE configuration
+		  options based on your needs.

-	config DEBUG_MSM8960_UART
-		bool "Kernel low-level debugging messages via MSM 8960 UART"
-		depends on ARCH_MSM8960
-		select MSM_HAS_DEBUG_UART_HS
-		select DEBUG_MSM_UART
+	config DEBUG_QCOM_UARTDM
+		bool "Kernel low-level debugging messages via QCOM UARTDM"
+		depends on ARCH_QCOM
 		help
 		  Say Y here if you want the debug print routines to direct
-		  their output to the serial port on MSM 8960 devices.
+		  their output to the serial port on Qualcomm devices.

-	config DEBUG_MSM8974_UART
-		bool "Kernel low-level debugging messages via MSM 8974 UART"
-		depends on ARCH_MSM8974
-		select MSM_HAS_DEBUG_UART_HS
-		select DEBUG_MSM_UART
-		help
-		  Say Y here if you want the debug print routines to direct
-		  their output to the serial port on MSM 8974 devices.
+		  ARCH      DEBUG_UART_PHYS   DEBUG_UART_BASE
+		  MSM8X60   0x19c40000        0xf0040000
+		  MSM8960   0x16440000        0xf0040000
+		  MSM8974   0xf991e000        0xfa71e000
+
+		  Please adjust DEBUG_UART_PHYS and DEBUG_UART_BASE configuration
+		  options based on your needs.

 	config DEBUG_MVEBU_UART
 		bool "Kernel low-level debugging messages via MVEBU UART (old bootloaders)"
@@ -950,10 +933,6 @@ config DEBUG_STI_UART
 	bool
 	depends on ARCH_STI

-config DEBUG_MSM_UART
-	bool
-	depends on ARCH_MSM || ARCH_QCOM
-
 config DEBUG_LL_INCLUDE
 	string
 	default "debug/8250.S" if DEBUG_LL_UART_8250 || DEBUG_UART_8250
@@ -971,7 +950,7 @@ config DEBUG_LL_INCLUDE
 				 DEBUG_IMX53_UART ||\
 				 DEBUG_IMX6Q_UART || \
 				 DEBUG_IMX6SL_UART
-	default "debug/msm.S" if DEBUG_MSM_UART
+	default "debug/msm.S" if DEBUG_MSM_UART || DEBUG_QCOM_UARTDM
 	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
 	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
 	default "debug/sti.S" if DEBUG_STI_UART
@@ -1035,6 +1014,7 @@ config DEBUG_UART_PHYS
 	default 0x80074000 if DEBUG_IMX28_UART
 	default 0x808c0000 if ARCH_EP93XX
 	default 0x90020000 if DEBUG_NSPIRE_CLASSIC_UART || DEBUG_NSPIRE_CX_UART
+	default 0xa9a00000 if DEBUG_MSM_UART
 	default 0xb0090000 if DEBUG_VEXPRESS_UART0_CRX
 	default 0xc0013000 if DEBUG_U300_UART
 	default 0xc8000000 if ARCH_IXP4XX && !CPU_BIG_ENDIAN
@@ -1050,6 +1030,7 @@ config DEBUG_UART_PHYS
 				ARCH_ORION5X
 	default 0xf7fc9000 if DEBUG_BERLIN_UART
 	default 0xf8b00000 if DEBUG_HI3716_UART
+	default 0xf991e000 if DEBUG_QCOM_UARTDM
 	default 0xfcb00000 if DEBUG_HI3620_UART
 	default 0xfe800000 if ARCH_IOP32X
 	default 0xffc02000 if DEBUG_SOCFPGA_UART
@@ -1058,11 +1039,13 @@ config DEBUG_UART_PHYS
 	default 0xfffff700 if ARCH_IOP33X
 	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
 		DEBUG_LL_UART_EFM32 || \
-		DEBUG_UART_8250 || DEBUG_UART_PL01X
+		DEBUG_UART_8250 || DEBUG_UART_PL01X || \
+		DEBUG_MSM_UART || DEBUG_QCOM_UARTDM

 config DEBUG_UART_VIRT
 	hex "Virtual base address of debug UART"
 	default 0xe0010fe0 if ARCH_RPC
+	default 0xe1000000 if DEBUG_MSM_UART
 	default 0xf0000be0 if ARCH_EBSA110
 	default 0xf0009000 if DEBUG_CNS3XXX
 	default 0xf01fb000 if DEBUG_NOMADIK_UART
@@ -1078,6 +1061,7 @@ config DEBUG_UART_VIRT
 	default 0xf7fc9000 if DEBUG_BERLIN_UART
 	default 0xf8009000 if DEBUG_VEXPRESS_UART0_CA9
 	default 0xf8090000 if DEBUG_VEXPRESS_UART0_RS1
+	default 0xfa71e000 if DEBUG_QCOM_UARTDM
 	default 0xfb009000 if DEBUG_REALVIEW_STD_PORT
 	default 0xfb10c000 if DEBUG_REALVIEW_PB1176_PORT
 	default 0xfd000000 if ARCH_SPEAR3XX || ARCH_SPEAR6XX
@@ -1116,7 +1100,8 @@ config DEBUG_UART_VIRT
 	default 0xff003000 if DEBUG_U300_UART
 	default DEBUG_UART_PHYS if !MMU
 	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
-		DEBUG_UART_8250 || DEBUG_UART_PL01X
+		DEBUG_UART_8250 || DEBUG_UART_PL01X || \
+		DEBUG_MSM_UART || DEBUG_QCOM_UARTDM

 config DEBUG_UART_8250_SHIFT
 	int "Register offset shift for the 8250 debug UART"
diff --git a/arch/arm/include/debug/msm.S b/arch/arm/include/debug/msm.S
index 9d653d4..9ef5761 100644
--- a/arch/arm/include/debug/msm.S
+++ b/arch/arm/include/debug/msm.S
@@ -15,51 +15,15 @@
  *
  */

-#if defined(CONFIG_ARCH_MSM7X00A) || defined(CONFIG_ARCH_QSD8X50)
-#define MSM_UART1_PHYS        0xA9A00000
-#define MSM_UART2_PHYS        0xA9B00000
-#define MSM_UART3_PHYS        0xA9C00000
-#elif defined(CONFIG_ARCH_MSM7X30)
-#define MSM_UART1_PHYS        0xACA00000
-#define MSM_UART2_PHYS        0xACB00000
-#define MSM_UART3_PHYS        0xACC00000
-#endif
-
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
-#ifdef CONFIG_DEBUG_MSM8660_UART
-#define MSM_DEBUG_UART_BASE	0xF0040000
-#define MSM_DEBUG_UART_PHYS	0x19C40000
-#endif
-
-#ifdef CONFIG_DEBUG_MSM8960_UART
-#define MSM_DEBUG_UART_BASE	0xF0040000
-#define MSM_DEBUG_UART_PHYS	0x16440000
-#endif
-
-#ifdef CONFIG_DEBUG_MSM8974_UART
-#define MSM_DEBUG_UART_BASE	0xFA71E000
-#define MSM_DEBUG_UART_PHYS	0xF991E000
-#endif
-
 	.macro	addruart, rp, rv, tmp
-#ifdef MSM_DEBUG_UART_PHYS
-	ldr	\rp, =MSM_DEBUG_UART_PHYS
-	ldr	\rv, =MSM_DEBUG_UART_BASE
+#ifdef CONFIG_DEBUG_UART_PHYS
+	ldr	\rp, =CONFIG_DEBUG_UART_PHYS
+	ldr	\rv, =CONFIG_DEBUG_UART_VIRT
 #endif
 	.endm

 	.macro	senduart, rd, rx
-#ifdef CONFIG_MSM_HAS_DEBUG_UART_HS
+#ifdef CONFIG_DEBUG_QCOM_UARTDM
 	@ Write the 1 character to UARTDM_TF
 	str	\rd, [\rx, #0x70]
 #else
@@ -68,7 +32,7 @@
 	.endm

 	.macro	waituart, rd, rx
-#ifdef CONFIG_MSM_HAS_DEBUG_UART_HS
+#ifdef CONFIG_DEBUG_QCOM_UARTDM
 	@ check for TX_EMT in UARTDM_SR
 	ldr	\rd, [\rx, #0x08]
 	tst	\rd, #0x08
diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index a7f959e..9b26976 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -42,9 +42,6 @@ config ARCH_QSD8X50

 endchoice

-config MSM_HAS_DEBUG_UART_HS
-	bool
-
 config MSM_SOC_REV_A
 	bool

--
1.8.3.2

