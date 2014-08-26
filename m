Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908AbaHZH3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:29:35 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41848 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933874AbaHZH3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:29:31 -0400
From: kpark3469@gmail.com
To: linux@arm.linux.org.uk
Cc: keun-o.park@windriver.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, afzal.mohd.ma@gmail.com
Subject: [PATCHv2] ARM: debug: uncompress debug support for omap2plus
Date: Tue, 26 Aug 2014 16:28:59 +0900
Message-Id: <1409038140-7433-1-git-send-email-kpark3469@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sahara <keun-o.park@windriver.com>

Since OMAP low-level debug code places data in the .data section,
The symbol DEBUG_UNCOMPRESS was defined with !DEBUG_OMAP2PLUS_UART.
This patch removes the part using data section in debug/omap2plus.S,
so DEBUG_UNCOMPRESS is now available on OMAP system.

Signed-off-by: Sahara <keun-o.park@windriver.com>
Tested-by: Afzal Mohammed <afzal.mohd.ma@gmail.com> (on am335x beagle
bone white)
---
 arch/arm/Kconfig.debug             |    3 +-
 arch/arm/include/debug/omap2plus.S |   96 ++++++++++--------------------------
 2 files changed, 27 insertions(+), 72 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index b11ad54..c0ad3e4 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1220,8 +1220,7 @@ config DEBUG_UART_8250_FLOW_CONTROL
 config DEBUG_UNCOMPRESS
 	bool
 	depends on ARCH_MULTIPLATFORM || ARCH_MSM || PLAT_SAMSUNG
-	default y if DEBUG_LL && !DEBUG_OMAP2PLUS_UART && \
-		     (!DEBUG_TEGRA_UART || !ZBOOT_ROM)
+	default y if DEBUG_LL && (!DEBUG_TEGRA_UART || !ZBOOT_ROM)
 	help
 	  This option influences the normal decompressor output for
 	  multiplatform kernels.  Normally, multiplatform kernels disable
diff --git a/arch/arm/include/debug/omap2plus.S b/arch/arm/include/debug/omap2plus.S
index 6d867ae..0b7ec89 100644
--- a/arch/arm/include/debug/omap2plus.S
+++ b/arch/arm/include/debug/omap2plus.S
@@ -58,115 +58,71 @@
 
 #define UART_OFFSET(addr)	((addr) & 0x00ffffff)
 
-		.pushsection .data
-omap_uart_phys:	.word	0
-omap_uart_virt:	.word	0
-omap_uart_lsr:	.word	0
-		.popsection
-
 		.macro	addruart, rp, rv, tmp
 
-		/* Use omap_uart_phys/virt if already configured */
-10:		adr	\rp, 99f		@ get effective addr of 99f
-		ldr	\rv, [\rp]		@ get absolute addr of 99f
-		sub	\rv, \rv, \rp		@ offset between the two
-		ldr	\rp, [\rp, #4]		@ abs addr of omap_uart_phys
-		sub	\tmp, \rp, \rv		@ make it effective
-		ldr	\rp, [\tmp, #0]		@ omap_uart_phys
-		ldr	\rv, [\tmp, #4]		@ omap_uart_virt
-		cmp	\rp, #0			@ is port configured?
-		cmpne	\rv, #0
-		bne	100f			@ already configured
-
 		/* Configure the UART offset from the phys/virt base */
-#ifdef CONFIG_DEBUG_OMAP2UART1
+#if defined(CONFIG_DEBUG_OMAP2UART1)
 		mov	\rp, #UART_OFFSET(OMAP2_UART1_BASE)	@ omap2/3/4
 		b	98f
-#endif
-#ifdef CONFIG_DEBUG_OMAP2UART2
+#elif defined(CONFIG_DEBUG_OMAP2UART2)
 		mov	\rp, #UART_OFFSET(OMAP2_UART2_BASE)	@ omap2/3/4
 		b	98f
-#endif
-#ifdef CONFIG_DEBUG_OMAP2UART3
+#elif defined(CONFIG_DEBUG_OMAP2UART3)
 		mov	\rp, #UART_OFFSET(OMAP2_UART3_BASE)
 		b	98f
-#endif
-#ifdef CONFIG_DEBUG_OMAP3UART3
+#elif defined(CONFIG_DEBUG_OMAP3UART3)
 		mov	\rp, #UART_OFFSET(OMAP3_UART1_BASE)
 		add	\rp, \rp, #0x00fb0000
 		add	\rp, \rp, #0x00006000		@ OMAP3_UART3_BASE
 		b	98f
-#endif
-#ifdef CONFIG_DEBUG_OMAP4UART3
+#elif defined(CONFIG_DEBUG_OMAP4UART3)
 		mov	\rp, #UART_OFFSET(OMAP4_UART3_BASE)
 		b	98f
-#endif
-#ifdef CONFIG_DEBUG_OMAP3UART4
+#elif defined(CONFIG_DEBUG_OMAP3UART4)
 		mov	\rp, #UART_OFFSET(OMAP3_UART1_BASE)
 		add	\rp, \rp, #0x00fb0000
 		add	\rp, \rp, #0x00028000		@ OMAP3_UART4_BASE
 		b	98f
-#endif
-#ifdef CONFIG_DEBUG_OMAP4UART4
+#elif defined(CONFIG_DEBUG_OMAP4UART4)
 		mov	\rp, #UART_OFFSET(OMAP4_UART4_BASE)
 		b	98f
-#endif
-#ifdef CONFIG_DEBUG_TI81XXUART1
+#elif defined(CONFIG_DEBUG_TI81XXUART1)
 		mov	\rp, #UART_OFFSET(TI81XX_UART1_BASE)
 		b	98f
-#endif
-#ifdef CONFIG_DEBUG_TI81XXUART2
+#elif defined(CONFIG_DEBUG_TI81XXUART2)
 		mov	\rp, #UART_OFFSET(TI81XX_UART2_BASE)
 		b	98f
-#endif
-#ifdef CONFIG_DEBUG_TI81XXUART3
+#elif defined(CONFIG_DEBUG_TI81XXUART3)
 		mov	\rp, #UART_OFFSET(TI81XX_UART3_BASE)
 		b	98f
-#endif
-#ifdef CONFIG_DEBUG_AM33XXUART1
+#elif defined(CONFIG_DEBUG_AM33XXUART1)
 		ldr	\rp, =AM33XX_UART1_BASE
 		and	\rp, \rp, #0x00ffffff
 		b	97f
-#endif
-#ifdef CONFIG_DEBUG_ZOOM_UART
+#elif defined(CONFIG_DEBUG_ZOOM_UART)
 		ldr	\rp, =ZOOM_UART_BASE
-		str	\rp, [\tmp, #0]		@ omap_uart_phys
-		ldr	\rp, =ZOOM_UART_VIRT
-		str	\rp, [\tmp, #4]		@ omap_uart_virt
-		mov	\rp, #(UART_LSR << ZOOM_PORT_SHIFT)
-		str	\rp, [\tmp, #8]		@ omap_uart_lsr
+		ldr	\rv, =ZOOM_UART_VIRT
+		mov	\tmp, #(UART_LSR << ZOOM_PORT_SHIFT)
+		b	100f
+#else
+#error "Error! No proper debug option is defined."
 #endif
-		b	10b
 
 		/* AM33XX: Store both phys and virt address for the uart */
 97:		add	\rp, \rp, #0x44000000	@ phys base
-		str	\rp, [\tmp, #0]		@ omap_uart_phys
-		sub	\rp, \rp, #0x44000000	@ phys base
-		add	\rp, \rp, #0xf9000000	@ virt base
-		str	\rp, [\tmp, #4]		@ omap_uart_virt
-		mov	\rp, #(UART_LSR << OMAP_PORT_SHIFT)
-		str	\rp, [\tmp, #8]		@ omap_uart_lsr
+		sub	\rv, \rp, #0x44000000	@ phys base
+		add	\rv, \rv, #0xf9000000	@ virt base
+		mov	\tmp, #(UART_LSR << OMAP_PORT_SHIFT)
 
-		b	10b
+		b	100f
 
 		/* Store both phys and virt address for the uart */
 98:		add	\rp, \rp, #0x48000000	@ phys base
-		str	\rp, [\tmp, #0]		@ omap_uart_phys
-		sub	\rp, \rp, #0x48000000	@ phys base
-		add	\rp, \rp, #0xfa000000	@ virt base
-		str	\rp, [\tmp, #4]		@ omap_uart_virt
-		mov	\rp, #(UART_LSR << OMAP_PORT_SHIFT)
-		str	\rp, [\tmp, #8]		@ omap_uart_lsr
-
-		b	10b
-
-		.align
-99:		.word	.
-		.word	omap_uart_phys
-		.ltorg
-
-100:		/* Pass the UART_LSR reg address */
-		ldr	\tmp, [\tmp, #8]	@ omap_uart_lsr
+		sub	\rv, \rp, #0x48000000	@ phys base
+		add	\rv, \rv, #0xfa000000	@ virt base
+		mov	\tmp, #(UART_LSR << OMAP_PORT_SHIFT)
+
+100:		/* Add the UART_LSR reg address */
 		add	\rp, \rp, \tmp
 		add	\rv, \rv, \tmp
 		.endm
-- 
1.7.9.5

