Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbaJXPrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:47:21 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:55429 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbaJXPrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:47:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Paul Bolle <pebolle@tiscali.nl>,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v12 00/15] arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)
Date: Fri, 24 Oct 2014 17:46:53 +0200
Message-ID: <1822066.pI6QN22RDx@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414148076-12685-1-git-send-email-daniel.thompson@linaro.org>
References: <1414148076-12685-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:u6o9q35ag3hjx1aEOLTsejzq/vOvo4aW6E6HJq+ENfZ
 +q5q4dMy4unIKGi7ZWJA/NWNT+o/1QRD0/R6QZ6BRcfidrBRPS
 nBFSKkU3TVwU5ko66Did/HkO0CnlQvAJULXEYqw/nn7Mpq6g+N
 E7M7cDnWB9aJY0Eg7vbE3mNXEQ+iUR1zkCieuMNV05qRfvKQ4W
 9hJDLbHhtIHLKPMxFPEh0l+wbv+2dGVg3r87kIMR4vkKXMeFpA
 aM3nXXfTuIN1/lTrU9uytTb3VLv5HlB1TwreQOkO84/7FfIWOU
 Msa0OpdGQxa2lwLat7tsoT6RzLbXyM7A6M6D4BtPHSDS6fNJZL
 vHsyBh530ih9pnehzSL0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2014 11:54:21 Daniel Thompson wrote:
> This patchset removes some single-platform compatibility tricks related
> to DEBUG_LL and, as a result, allows multi_v7_defconfig derived builds
> to enable DEBUG_LL. Currently the user selected kbuild setting is
> ignored and the PL01X's DEBUG_LL stub is silently selected instead. This
> is a pain if your hardware doesn't have this cell, not least because it
> takes a little time to figure out that kbuild built the wrong code.
> 

Hi Daniel,

All the patches in your series look good to me this time. If Russell
has no further comments, I'd like to put them into a branch in arm-soc.
It has turned out that a lot of changes in Kconfig.debug are for adding
new platforms, so we have fewer conflicts if we take it this way.

I would actually have put the defconfig changes into a combined patch,
I don't see a reason to split those up by platform, but I don't mind
merging them the way you have them either.

There is still a related bug that we should also fix, but I'd say let's
take your current patches first and then add whatever is missing
on top. Specifically, a snippet like this

        default 0xd4017000 if DEBUG_MMP_UART2
        default 0xd4018000 if DEBUG_MMP_UART3
        default 0xe0000000 if ARCH_SPEAR13XX
        default 0xe4007000 if DEBUG_HIP04_UART
        default 0xf0000be0 if ARCH_EBSA110

still means you get the wrong default when you build a multiplatform
kernel that you want to boot on HIP04 and you set DEBUG_HIP04_UART
but you happen to also have ARCH_SPEAR13XX enabled.

I have a patch that I use locally for randconfig builds that tries
to fix this. It has some overlaps with your work but most parts are
distinct. See below.

	Arnd

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 64d0e21cf7e7..bb27d0b19197 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -211,6 +211,14 @@ choice
 		  Say Y here if you want the debug print routines to direct
 		  their output to the serial port in the DC21285 (Footbridge).
 
+	config DEBUG_EP93XX
+		bool "Kernel low-level debugging messages via ep93xx UART"
+		depends on ARCH_EP93XX
+		select DEBUG_UART_PL01X
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Cirrus Logic EP93xx based platforms.
+
 	config DEBUG_FOOTBRIDGE_COM1
 		bool "Kernel low-level debugging messages via footbridge 8250 at PCI COM1"
 		depends on FOOTBRIDGE
@@ -218,6 +226,14 @@ choice
 		  Say Y here if you want the debug print routines to direct
 		  their output to the 8250 at PCI COM1.
 
+	config DEBUG_GEMINI
+		bool "Kernel low-level debugging messages via Cortina Systems Gemini UART"
+		depends on ARCH_GEMINI
+		select DEBUG_UART_8250
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Cirrus Logic EP93xx based platforms.
+
 	config DEBUG_HI3620_UART
 		bool "Hisilicon HI3620 Debug UART"
 		depends on ARCH_HI3xxx
@@ -351,6 +367,14 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on i.MX6SX.
 
+	config DEBUG_INTEGRATOR
+		bool "Kernel low-level debugging messages via ARM Integrator UART"
+		depends on ARCH_INTEGRATOR
+		select DEBUG_UART_PL01X
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Cirrus Logic EP93xx based platforms.
+
 	config DEBUG_KEYSTONE_UART0
 		bool "Kernel low-level debugging on KEYSTONE2 using UART0"
 		depends on ARCH_KEYSTONE
@@ -367,6 +391,14 @@ choice
 		  Say Y here if you want the debug print routines to direct
 		  their output to UART1 serial port on KEYSTONE2 devices.
 
+	config DEBUG_LPC32XX
+		bool "Kernel low-level debugging messages via NXP LPC32xx UART"
+		depends on ARCH_LPC32XX
+		select DEBUG_UART_8250
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Cirrus Logic EP93xx based platforms.
+
 	config DEBUG_MESON_UARTAO
 		bool "Kernel low-level debugging via Meson6 UARTAO"
 		depends on ARCH_MESON
@@ -427,7 +459,7 @@ choice
 
 	config DEBUG_MVEBU_UART
 		bool "Kernel low-level debugging messages via MVEBU UART (old bootloaders)"
-		depends on ARCH_MVEBU
+		depends on ARCH_MVEBU && CPU_V7
 		select DEBUG_UART_8250
 		help
 		  Say Y here if you want kernel low-level debugging support
@@ -440,25 +472,40 @@ choice
 		  Plathome OpenBlocks AX3, when using the original
 		  bootloader.
 
+		  This option will not work on older Marvell platforms
+		  (Kirkwood, Dove, MV78xx0, Orion5x), which should  piock
+		  the "new bootloader" variant.
+
 		  If the wrong DEBUG_MVEBU_UART* option is selected,
 		  when u-boot hands over to the kernel, the system
 		  silently crashes, with no serial output at all.
 
 	config DEBUG_MVEBU_UART_ALTERNATE
 		bool "Kernel low-level debugging messages via MVEBU UART (new bootloaders)"
-		depends on ARCH_MVEBU
+		depends on ARCH_MVEBU || ARCH_DOVE || ARCH_KIRKWOOD || ARCH_MV78XX0 || ARCH_ORION5X
 		select DEBUG_UART_8250
 		help
 		  Say Y here if you want kernel low-level debugging support
-		  on MVEBU based platforms.
+		  on MVEBU based platforms (Armada XP, Armada 3xx, Kirkwood,
+		  Dove, MV78xx0, Orion5x).
 
 		  This option should be used with the new bootloaders
 		  that remap the internal registers at 0xf1000000.
+		  All of the older (pre Armada XP/370) platforms also use
+		  this address, regardless of the boot loader version.
 
 		  If the wrong DEBUG_MVEBU_UART* option is selected,
 		  when u-boot hands over to the kernel, the system
 		  silently crashes, with no serial output at all.
 
+	config DEBUG_MT6589_UART0
+		bool "Mediatek mt6589 UART0"
+		depends on ARCH_MEDIATEK
+		select DEBUG_UART_8250
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  for Mediatek mt6589 based platforms on UART0.
+
 	config DEBUG_VF_UART
 		bool "Vybrid UART"
 		depends on SOC_VF610
@@ -823,6 +870,22 @@ choice
 		  Say Y here if you want the debug print routines to direct
 		  their output to the uart1 port on SiRFmarco devices.
 
+	config DEBUG_SPEAR3XX
+		bool "Kernel low-level debugging messages via ST SPEAr 3xx/6xx UART"
+		depends on ARCH_SPEAR3XX || ARCH_SPEAR6XX
+		select DEBUG_UART_PL01X
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Cirrus Logic EP93xx based platforms.
+
+	config DEBUG_SPEAR13XX
+		bool "Kernel low-level debugging messages via ST SPEAr 13xx UART"
+		depends on ARCH_SPEAR13XX
+		select DEBUG_UART_PL01X
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Cirrus Logic EP93xx based platforms.
+
 	config STIH41X_DEBUG_ASC2
 		bool "Use StiH415/416 ASC2 UART for low-level debug"
 		depends on ARCH_STI
@@ -860,13 +923,13 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on Ux500 based platforms.
 
-	config DEBUG_MT6589_UART0
-		bool "Mediatek mt6589 UART0"
-		depends on ARCH_MEDIATEK
-		select DEBUG_UART_8250
+	config DEBUG_VERSATILE
+		bool "Kernel low-level debugging messages via ARM Versatile UART"
+		depends on ARCH_VERSATILE
+		select DEBUG_UART_PL01X
 		help
 		  Say Y here if you want kernel low-level debugging support
-		  for Mediatek mt6589 based platforms on UART0.
+		  on Cirrus Logic EP93xx based platforms.
 
 	config DEBUG_VEXPRESS_UART0_DETECT
 		bool "Autodetect UART0 on Versatile Express Cortex-A core tiles"
@@ -1078,20 +1141,13 @@ config DEBUG_LL_INCLUDE
 
 # Compatibility options for PL01x
 config DEBUG_UART_PL01X
-	def_bool ARCH_EP93XX || \
-		ARCH_INTEGRATOR || \
-		ARCH_SPEAR3XX || \
-		ARCH_SPEAR6XX || \
-		ARCH_SPEAR13XX || \
-		ARCH_VERSATILE
+	bool
 
 # Compatibility options for 8250
 config DEBUG_UART_8250
-	def_bool ARCH_DOVE || ARCH_EBSA110 || \
-		(FOOTBRIDGE && !DEBUG_DC21285_PORT) || \
-		ARCH_GEMINI || ARCH_IOP13XX || ARCH_IOP32X || \
-		ARCH_IOP33X || ARCH_IXP4XX || \
-		ARCH_LPC32XX || ARCH_MV78XX0 || ARCH_ORION5X || ARCH_RPC
+	def_bool ARCH_EBSA110 || (FOOTBRIDGE && !DEBUG_DC21285_PORT) || \
+		ARCH_IOP13XX || ARCH_IOP32X || ARCH_IOP33X || ARCH_IXP4XX || \
+		ARCH_RPC
 
 # Compatibility options for BCM63xx
 config DEBUG_UART_BCM63XX
@@ -1113,10 +1169,10 @@ config DEBUG_UART_PHYS
 	default 0x1010c000 if DEBUG_REALVIEW_PB1176_PORT
 	default 0x10124000 if DEBUG_RK3X_UART0
 	default 0x10126000 if DEBUG_RK3X_UART1
-	default 0x101f1000 if ARCH_VERSATILE
+	default 0x101f1000 if DEBUG_VERSATILE
 	default 0x101fb000 if DEBUG_NOMADIK_UART
 	default 0x11006000 if DEBUG_MT6589_UART0
-	default 0x16000000 if ARCH_INTEGRATOR
+	default 0x16000000 if DEBUG_INTEGRATOR
 	default 0x18000300 if DEBUG_BCM_5301X
 	default 0x1c090000 if DEBUG_VEXPRESS_UART0_RS1
 	default 0x20060000 if DEBUG_RK29_UART0
@@ -1125,9 +1181,9 @@ config DEBUG_UART_PHYS
 	default 0x20201000 if DEBUG_BCM2835
 	default 0x3e000000 if DEBUG_BCM_KONA_UART
 	default 0x4000e400 if DEBUG_LL_UART_EFM32
-	default 0x40090000 if ARCH_LPC32XX
+	default 0x40090000 if DEBUG_LPC32XX
 	default 0x40100000 if DEBUG_PXA_UART1
-	default 0x42000000 if ARCH_GEMINI
+	default 0x42000000 if DEBUG_GEMINI
 	default 0x50000000 if DEBUG_S3C24XX_UART && (DEBUG_S3C_UART0 || \
 				DEBUG_S3C2410_UART0)
 	default 0x50004000 if DEBUG_S3C24XX_UART && (DEBUG_S3C_UART1 || \
@@ -1140,24 +1196,22 @@ config DEBUG_UART_PHYS
 	default 0x80070000 if DEBUG_IMX23_UART
 	default 0x80074000 if DEBUG_IMX28_UART
 	default 0x80230000 if DEBUG_PICOXCELL_UART
-	default 0x808c0000 if ARCH_EP93XX
+	default 0x808c0000 if DEBUG_EP93XX || ARCH_EP93XX
 	default 0x90020000 if DEBUG_NSPIRE_CLASSIC_UART || DEBUG_NSPIRE_CX_UART
 	default 0xa9a00000 if DEBUG_MSM_UART
 	default 0xb0090000 if DEBUG_VEXPRESS_UART0_CRX
 	default 0xc0013000 if DEBUG_U300_UART
 	default 0xc8000000 if ARCH_IXP4XX && !CPU_BIG_ENDIAN
 	default 0xc8000003 if ARCH_IXP4XX && CPU_BIG_ENDIAN
-	default 0xd0000000 if ARCH_SPEAR3XX || ARCH_SPEAR6XX
+	default 0xd0000000 if DEBUG_SPEAR3XX
 	default 0xd0012000 if DEBUG_MVEBU_UART
 	default 0xc81004c0 if DEBUG_MESON_UARTAO
 	default 0xd4017000 if DEBUG_MMP_UART2
 	default 0xd4018000 if DEBUG_MMP_UART3
-	default 0xe0000000 if ARCH_SPEAR13XX
 	default 0xe4007000 if DEBUG_HIP04_UART
+	default 0xe0000000 if DEBUG_SPEAR13XX
 	default 0xf0000be0 if ARCH_EBSA110
 	default 0xf1012000 if DEBUG_MVEBU_UART_ALTERNATE
-	default 0xf1012000 if ARCH_DOVE || ARCH_MV78XX0 || \
-				ARCH_ORION5X
 	default 0xf7fc9000 if DEBUG_BERLIN_UART
 	default 0xf8b00000 if DEBUG_HIX5HD2_UART
 	default 0xf991e000 if DEBUG_QCOM_UARTDM
@@ -1174,7 +1228,7 @@ config DEBUG_UART_PHYS
 		DEBUG_LL_UART_EFM32 || \
 		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_MESON_UARTAO || \
 		DEBUG_MSM_UART || DEBUG_QCOM_UARTDM || DEBUG_S3C24XX_UART || \
-		DEBUG_UART_BCM63XX
+		DEBUG_UART_BCM63XX || ARCH_EP93XX
 
 config DEBUG_UART_VIRT
 	hex "Virtual base address of debug UART"
@@ -1185,14 +1239,15 @@ config DEBUG_UART_VIRT
 	default 0xf0201000 if DEBUG_BCM2835
 	default 0xf1000300 if DEBUG_BCM_5301X
 	default 0xf1006000 if DEBUG_MT6589_UART0
-	default 0xf11f1000 if ARCH_VERSATILE
-	default 0xf1600000 if ARCH_INTEGRATOR
+	default 0xf11f1000 if DEBUG_VERSATILE
+	default 0xf1600000 if DEBUG_INTEGRATOR
 	default 0xf1c28000 if DEBUG_SUNXI_UART0
 	default 0xf1c28400 if DEBUG_SUNXI_UART1
 	default 0xf1f02800 if DEBUG_SUNXI_R_UART
 	default 0xf2100000 if DEBUG_PXA_UART1
-	default 0xf4090000 if ARCH_LPC32XX
-	default 0xf4200000 if ARCH_GEMINI
+	default 0xf31004c0 if DEBUG_MESON_UARTAO
+	default 0xf4090000 if DEBUG_LPC32XX
+	default 0xf4200000 if DEBUG_GEMINI
 	default 0xf7000000 if DEBUG_S3C24XX_UART && (DEBUG_S3C_UART0 || \
 				DEBUG_S3C2410_UART0)
 	default 0xf7004000 if DEBUG_S3C24XX_UART && (DEBUG_S3C_UART1 || \
@@ -1208,12 +1263,10 @@ config DEBUG_UART_VIRT
 	default 0xfb009000 if DEBUG_REALVIEW_STD_PORT
 	default 0xfb10c000 if DEBUG_REALVIEW_PB1176_PORT
 	default 0xfcfe8600 if DEBUG_UART_BCM63XX
-	default 0xfd000000 if ARCH_SPEAR3XX || ARCH_SPEAR6XX
-	default 0xfd000000 if ARCH_SPEAR13XX
-	default 0xfd012000 if ARCH_MV78XX0
-	default 0xfde12000 if ARCH_DOVE
-	default 0xfe012000 if ARCH_ORION5X
-	default 0xf31004c0 if DEBUG_MESON_UARTAO
+	default 0xfd000000 if DEBUG_SPEAR3XX || DEBUG_SPEAR13XX
+	default 0xfd012000 if DEBUG_MVEBU_UART_ALTERNATE && ARCH_MV78XX0
+	default 0xfde12000 if DEBUG_MVEBU_UART_ALTERNATE && ARCH_DOVE
+	default 0xfe012000 if DEBUG_MVEBU_UART_ALTERNATE && ARCH_ORION5X
 	default 0xfe017000 if DEBUG_MMP_UART2
 	default 0xfe018000 if DEBUG_MMP_UART3
 	default 0xfe100000 if DEBUG_IMX23_UART || DEBUG_IMX28_UART
@@ -1234,7 +1287,7 @@ config DEBUG_UART_VIRT
 	default 0xfed60000 if DEBUG_RK29_UART0
 	default 0xfed64000 if DEBUG_RK29_UART1 || DEBUG_RK3X_UART2
 	default 0xfed68000 if DEBUG_RK29_UART2 || DEBUG_RK3X_UART3
-	default 0xfedc0000 if ARCH_EP93XX
+	default 0xfedc0000 if DEBUG_EP93XX
 	default 0xfee003f8 if FOOTBRIDGE
 	default 0xfee20000 if DEBUG_NSPIRE_CLASSIC_UART || DEBUG_NSPIRE_CX_UART
 	default 0xfee82340 if ARCH_IOP13XX
@@ -1269,7 +1322,7 @@ config DEBUG_UART_8250_WORD
 config DEBUG_UART_8250_FLOW_CONTROL
 	bool "Enable flow control for 8250 UART"
 	depends on DEBUG_LL_UART_8250 || DEBUG_UART_8250
-	default y if ARCH_EBSA110 || FOOTBRIDGE || ARCH_GEMINI || ARCH_RPC
+	default y if ARCH_EBSA110 || FOOTBRIDGE || DEBUG_GEMINI || ARCH_RPC
 
 config DEBUG_UNCOMPRESS
 	bool

