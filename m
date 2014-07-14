Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbaGNP2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:28:05 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64564 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbaGNP1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:27:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Bolle <pebolle@tiscali.nl>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/4] arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)
Date: Mon, 14 Jul 2014 17:27:49 +0200
Message-ID: <4527083.RFD2neZ6Bp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53C39D5F.6050901@linaro.org>
References: <1401206421-29832-1-git-send-email-daniel.thompson@linaro.org> <20140712111004.GI21766@n2100.arm.linux.org.uk> <53C39D5F.6050901@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:TCJkIADQSufjLtkuyX0FKGdWVCRvLSq4j/DjipQRj2w
 nSUgXwzizksndN9ySOoIvnCTUaBUY84IzyXT1iCYmpSnkolpyx
 2byeadTr59+E8d61WtjbpVJHG8jD+RB1ZWMkTNPcA29UWJ+6Jp
 0XKfUWTYmdfnw14QPRrsnwS6bDG5hYzYY3YGUAZtPE34lenBkX
 3Inb33iZyFz5Jh1HIr/dPPdzcws7IfEN9mPkUFp+qumnEpiUTJ
 OU96zAN1RhRvxt5+CCVgj2CBeURUNRvXg+TfGFD2NUdT7lE6di
 MW9K2o3ERIxszrDMHZ8HtqE02PNe8JslJAnVb57D/8FNEx3sm1
 PC/YAfoTrZeaXLdg8apI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 July 2014 10:05:35 Daniel Thompson wrote:
> On 12/07/14 12:10, Russell King - ARM Linux wrote:
> > On Sat, Jul 12, 2014 at 11:16:02AM +0100, Russell King - ARM Linux wrote:
> >> On Mon, Jun 30, 2014 at 12:30:51PM +0100, Daniel Thompson wrote:
> >>> This patchset removes some single-platform compatibility tricks related
> >>> to DEBUG_LL and, as a result, allows multi_v7_defconfig derived builds
> >>> to enable DEBUG_LL. Currently the user selected kbuild setting is
> >>> ignored and the PL01X's DEBUG_LL stub is silently selected instead. This
> >>> is a pain if your hardware doesn't have this cell, not least because it
> >>> takes a little time to figure out that kbuild built the wrong code.
> >>
> >> I don't think this is quite right, because I'm now seeing randconfig
> >> finding build errors with this.  We can end up with this configuration:
> >>
> >> CONFIG_DEBUG_LL=y
> >> CONFIG_DEBUG_LL_UART_NONE=y
> >> # CONFIG_DEBUG_ICEDCC is not set
> >> # CONFIG_DEBUG_SEMIHOSTING is not set
> >> # CONFIG_DEBUG_LL_UART_8250 is not set
> >> # CONFIG_DEBUG_LL_UART_PL01X is not set
> >> CONFIG_DEBUG_LL_INCLUDE="mach/debug-macro.S"
> >> # CONFIG_DEBUG_UART_8250 is not set
> >>
> >> which results in:
> >>
> >> arch/arm/kernel/debug.S:24:33: fatal error: mach/debug-macro.S: No such file or directory
> >> make[2]: *** [arch/arm/kernel/debug.o] Error 1
> >> arch/arm/kernel/head.S:27:33: fatal error: mach/debug-macro.S: No such file or directory
> >> make[2]: *** [arch/arm/kernel/head.o] Error 1
> >> Full config file:
> >> http://www.arm.linux.org.uk/developer/build/file.php?lid=11023
> 
> Thanks. I will look at this.
> 
> Problem is that by making the build system honour the user choice we end
> up breaking the build when the user makes a bad choice (albeit a bad
> choice that they should not have been given in the first place).
> 
> I guess the best fix is to get rid of CONFIG_DEBUG_LL_UART_NONE altogether.

Yes, that seems like the best plan forward. I think my analysis is still
correct that DEBUG_LL_UART_NONE is only used on ARCH_KS8695, ARCH_NETX,
ARCH_OMAP1, and ARCH_SA1100 today.

> > Note that this also breaks building versatile as an oldconfig.  I'll drop
> > the patch series from my tree for the time being.
> 
> There is a difficult problem with oldconfig.
> 
> Today DEBUG_LL only works on versatile defconfigs (and oldconfig
> upgrades from there) because although CONFIG_DEBUG_LL_UART_NONE is
> selected the build system does not honour this and behaves as though the
> use selected CONFIG_DEBUG_LL_UART_PL01X instead.

It took me a while to understand what you mean here. It's the
DEBUG_UART_PL01X/DEBUG_UART_8250 options getting triggered for
some platforms when CONFIG_DEBUG_LL_UART_NONE is set, rather
than the DEBUG_LL_UART_PL01X/DEBUG_LL_UART_8250 options.

> Unfortunately if we fix this and remove CONFIG_DEBUG_LL_UART_NONE as
> proposed above then the oldconfig will silently select
> CONFIG_DEBUG_SEMIHOSTING.
> 
> In other words I will be able to offer a patch so that oldconfig
> *compiles* but I don't know how to get it to preserve behaviour (or
> whether this matters).
> 
> Hints about what to do would be very welcome.

For a 'choice' statement, 'oldconfig' will always pick what is listed
as the 'default' option, and in the absence of that will pick the
first option it finds.

We could do it for one of pl01x or 8250 by rearranging the order, but
not for both. I think something like this would work, but I don't know
if that's the nicest solution. I'm also getting a few simple merge
conflicts because of the mach-kirkwood removal.

This patch introduces separate options for all users of DEBUG_UART_PL01X
and some that use DEBUG_UART_8250. It still leaves the ones that use
8250 but will never be multiplatform as far as I can tell, (strongarm,
ixp and pxa).

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 8f90595069a1..0f89d1b84524 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -200,6 +200,14 @@ choice
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
@@ -207,6 +215,14 @@ choice
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
@@ -324,6 +340,14 @@ choice
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
@@ -340,6 +364,14 @@ choice
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
 	config DEBUG_MMP_UART2
 		bool "Kernel low-level debugging message via MMP UART2"
 		depends on ARCH_MMP
@@ -393,7 +425,7 @@ choice
 
 	config DEBUG_MVEBU_UART
 		bool "Kernel low-level debugging messages via MVEBU UART (old bootloaders)"
-		depends on ARCH_MVEBU
+		depends on ARCH_MVEBU && CPU_V7
 		select DEBUG_UART_8250
 		help
 		  Say Y here if you want kernel low-level debugging support
@@ -406,20 +438,27 @@ choice
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
@@ -781,6 +820,22 @@ choice
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
@@ -818,6 +873,14 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on Ux500 based platforms.
 
+	config DEBUG_VERSATILE
+		bool "Kernel low-level debugging messages via ARM Versatile UART"
+		depends on ARCH_VERSATILE
+		select DEBUG_UART_PL01X
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Cirrus Logic EP93xx based platforms.
+
 	config DEBUG_VEXPRESS_UART0_DETECT
 		bool "Autodetect UART0 on Versatile Express Cortex-A core tiles"
 		depends on ARCH_VEXPRESS && CPU_CP15_MMU
@@ -1021,20 +1084,13 @@ config DEBUG_LL_INCLUDE
 
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
-		ARCH_IOP33X || ARCH_IXP4XX || ARCH_KIRKWOOD || \
-		ARCH_LPC32XX || ARCH_MV78XX0 || ARCH_ORION5X || ARCH_RPC
+	def_bool ARCH_EBSA110 || (FOOTBRIDGE && !DEBUG_DC21285_PORT) || \
+		ARCH_IOP13XX || ARCH_IOP32X || ARCH_IOP33X || ARCH_IXP4XX || \
+		ARCH_RPC
 
 config DEBUG_UART_PHYS
 	hex "Physical base address of debug UART"
@@ -1051,9 +1107,9 @@ config DEBUG_UART_PHYS
 	default 0x1010c000 if DEBUG_REALVIEW_PB1176_PORT
 	default 0x10124000 if DEBUG_RK3X_UART0
 	default 0x10126000 if DEBUG_RK3X_UART1
-	default 0x101f1000 if ARCH_VERSATILE
+	default 0x101f1000 if DEBUG_VERSATILE
 	default 0x101fb000 if DEBUG_NOMADIK_UART
-	default 0x16000000 if ARCH_INTEGRATOR
+	default 0x16000000 if DEBUG_INTEGRATOR
 	default 0x18000300 if DEBUG_BCM_5301X
 	default 0x1c090000 if DEBUG_VEXPRESS_UART0_RS1
 	default 0x20060000 if DEBUG_RK29_UART0
@@ -1062,9 +1118,9 @@ config DEBUG_UART_PHYS
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
@@ -1075,22 +1131,20 @@ config DEBUG_UART_PHYS
 	default 0x80070000 if DEBUG_IMX23_UART
 	default 0x80074000 if DEBUG_IMX28_UART
 	default 0x80230000 if DEBUG_PICOXCELL_UART
-	default 0x808c0000 if ARCH_EP93XX
+	default 0x808c0000 if DEBUG_EP93XX
 	default 0x90020000 if DEBUG_NSPIRE_CLASSIC_UART || DEBUG_NSPIRE_CX_UART
 	default 0xa9a00000 if DEBUG_MSM_UART
 	default 0xb0090000 if DEBUG_VEXPRESS_UART0_CRX
 	default 0xc0013000 if DEBUG_U300_UART
 	default 0xc8000000 if ARCH_IXP4XX && !CPU_BIG_ENDIAN
 	default 0xc8000003 if ARCH_IXP4XX && CPU_BIG_ENDIAN
-	default 0xd0000000 if ARCH_SPEAR3XX || ARCH_SPEAR6XX
+	default 0xd0000000 if DEBUG_SPEAR3XX
 	default 0xd0012000 if DEBUG_MVEBU_UART
 	default 0xd4017000 if DEBUG_MMP_UART2
 	default 0xd4018000 if DEBUG_MMP_UART3
-	default 0xe0000000 if ARCH_SPEAR13XX
+	default 0xe0000000 if DEBUG_SPEAR13XX
 	default 0xf0000be0 if ARCH_EBSA110
 	default 0xf1012000 if DEBUG_MVEBU_UART_ALTERNATE
-	default 0xf1012000 if ARCH_DOVE || ARCH_KIRKWOOD || ARCH_MV78XX0 || \
-				ARCH_ORION5X
 	default 0xf7fc9000 if DEBUG_BERLIN_UART
 	default 0xf8b00000 if DEBUG_HI3716_UART
 	default 0xf991e000 if DEBUG_QCOM_UARTDM
@@ -1114,13 +1168,13 @@ config DEBUG_UART_VIRT
 	default 0xf01fb000 if DEBUG_NOMADIK_UART
 	default 0xf0201000 if DEBUG_BCM2835
 	default 0xf1000300 if DEBUG_BCM_5301X
-	default 0xf11f1000 if ARCH_VERSATILE
-	default 0xf1600000 if ARCH_INTEGRATOR
+	default 0xf11f1000 if DEBUG_VERSATILE
+	default 0xf1600000 if DEBUG_INTEGRATOR
 	default 0xf1c28000 if DEBUG_SUNXI_UART0
 	default 0xf1c28400 if DEBUG_SUNXI_UART1
 	default 0xf2100000 if DEBUG_PXA_UART1
-	default 0xf4090000 if ARCH_LPC32XX
-	default 0xf4200000 if ARCH_GEMINI
+	default 0xf4090000 if DEBUG_LPC32XX
+	default 0xf4200000 if DEBUG_GEMINI
 	default 0xf7000000 if DEBUG_S3C24XX_UART && (DEBUG_S3C_UART0 || \
 				DEBUG_S3C2410_UART0)
 	default 0xf7004000 if DEBUG_S3C24XX_UART && (DEBUG_S3C_UART1 || \
@@ -1133,11 +1187,10 @@ config DEBUG_UART_VIRT
 	default 0xfa71e000 if DEBUG_QCOM_UARTDM
 	default 0xfb009000 if DEBUG_REALVIEW_STD_PORT
 	default 0xfb10c000 if DEBUG_REALVIEW_PB1176_PORT
-	default 0xfd000000 if ARCH_SPEAR3XX || ARCH_SPEAR6XX
-	default 0xfd000000 if ARCH_SPEAR13XX
-	default 0xfd012000 if ARCH_MV78XX0
-	default 0xfde12000 if ARCH_DOVE
-	default 0xfe012000 if ARCH_ORION5X
+	default 0xfd000000 if DEBUG_SPEAR3XX || DEBUG_SPEAR13XX
+	default 0xfd012000 if DEBUG_MVEBU_UART_ALTERNATE && ARCH_MV78XX0
+	default 0xfde12000 if DEBUG_MVEBU_UART_ALTERNATE && ARCH_DOVE
+	default 0xfe012000 if DEBUG_MVEBU_UART_ALTERNATE && ARCH_ORION5X
 	default 0xfe017000 if DEBUG_MMP_UART2
 	default 0xfe018000 if DEBUG_MMP_UART3
 	default 0xfe100000 if DEBUG_IMX23_UART || DEBUG_IMX28_UART
@@ -1154,11 +1207,11 @@ config DEBUG_UART_VIRT
 	default 0xfec20000 if DEBUG_DAVINCI_DMx_UART0
 	default 0xfed0c000 if DEBUG_DAVINCI_DA8XX_UART1
 	default 0xfed0d000 if DEBUG_DAVINCI_DA8XX_UART2
-	default 0xfed12000 if ARCH_KIRKWOOD
+	default 0xfed12000 if DEBUG_MVEBU_UART_ALTERNATE && ARCH_KIRKWOOD
 	default 0xfed60000 if DEBUG_RK29_UART0
 	default 0xfed64000 if DEBUG_RK29_UART1 || DEBUG_RK3X_UART2
 	default 0xfed68000 if DEBUG_RK29_UART2 || DEBUG_RK3X_UART3
-	default 0xfedc0000 if ARCH_EP93XX
+	default 0xfedc0000 if DEBUG_EP93XX
 	default 0xfee003f8 if FOOTBRIDGE
 	default 0xfee20000 if DEBUG_NSPIRE_CLASSIC_UART || DEBUG_NSPIRE_CX_UART
 	default 0xfee82340 if ARCH_IOP13XX
@@ -1191,7 +1244,7 @@ config DEBUG_UART_8250_WORD
 config DEBUG_UART_8250_FLOW_CONTROL
 	bool "Enable flow control for 8250 UART"
 	depends on DEBUG_LL_UART_8250 || DEBUG_UART_8250
-	default y if ARCH_EBSA110 || FOOTBRIDGE || ARCH_GEMINI || ARCH_RPC
+	default y if ARCH_EBSA110 || FOOTBRIDGE || DEBUG_GEMINI || ARCH_RPC
 
 config DEBUG_UNCOMPRESS
 	bool

