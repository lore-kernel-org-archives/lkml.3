Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3FDEdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 00:33:47 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:47169 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3FDEdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 00:33:42 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: arnd@arndb.de, kgene.kim@samsung.com, olof@lixom.net, patches@linaro.org,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v2 3/3] ARM: s5p64x0: Use common uncompress.h part for plat-samsung
Date: Tue,  4 Jun 2013 09:49:12 +0530
Message-Id: <1370319552-17694-4-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370319552-17694-1-git-send-email-tushar.behera@linaro.org>
References: <1370319552-17694-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <tomasz.figa@gmail.com>

Since uart_base can be set dynamically in arch_detect_cpu(), there is no
need to have a copy of all code locally, just to override UART base
address.

This patch removes any duplicate code in uncompress.h variant of s5p64x0
and implements proper arch_detect_cpu() function to initialize UART with
SoC-specific parameters.

While at it, replace hard-coded register address with macro.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
(This patch replaces the original patch in this patchset as it was an
earlier-posted near-identical patch.)

Changes for v2:
* Remove the declaration of uart_base (taken care in plat/uncompress.h)

 arch/arm/mach-s5p64x0/include/mach/uncompress.h |  162 +----------------------
 1 file changed, 6 insertions(+), 156 deletions(-)

diff --git a/arch/arm/mach-s5p64x0/include/mach/uncompress.h b/arch/arm/mach-s5p64x0/include/mach/uncompress.h
index 19e0d64..bc04bd5 100644
--- a/arch/arm/mach-s5p64x0/include/mach/uncompress.h
+++ b/arch/arm/mach-s5p64x0/include/mach/uncompress.h
@@ -14,171 +14,21 @@
 #define __ASM_ARCH_UNCOMPRESS_H
 
 #include <mach/map.h>
+#include <plat/uncompress.h>
 
-/*
- * cannot use commonly <plat/uncompress.h>
- * because uart base of S5P6440 and S5P6450 is different
- */
-
-typedef unsigned int upf_t;	/* cannot include linux/serial_core.h */
-
-/* uart setup */
-
-unsigned int fifo_mask;
-unsigned int fifo_max;
-
-/* forward declerations */
-
-static void arch_detect_cpu(void);
-
-/* defines for UART registers */
-
-#include <plat/regs-serial.h>
-#include <plat/regs-watchdog.h>
-
-/* working in physical space... */
-#undef S3C2410_WDOGREG
-#define S3C2410_WDOGREG(x) ((S3C24XX_PA_WATCHDOG + (x)))
-
-/* how many bytes we allow into the FIFO at a time in FIFO mode */
-#define FIFO_MAX	 (14)
-
-unsigned long uart_base;
-
-static __inline__ void get_uart_base(void)
+static void arch_detect_cpu(void)
 {
 	unsigned int chipid;
 
 	chipid = *(const volatile unsigned int __force *) 0xE0100118;
 
-	uart_base = S3C_UART_OFFSET * CONFIG_S3C_LOWLEVEL_UART_PORT;
-
 	if ((chipid & 0xff000) == 0x50000)
-		uart_base += 0xEC800000;
+		uart_base = S5P6450_PA_UART(CONFIG_S3C_LOWLEVEL_UART_PORT);
 	else
-		uart_base += 0xEC000000;
-}
-
-static __inline__ void uart_wr(unsigned int reg, unsigned int val)
-{
-	volatile unsigned int *ptr;
-
-	get_uart_base();
-	ptr = (volatile unsigned int *)(reg + uart_base);
-	*ptr = val;
-}
-
-static __inline__ unsigned int uart_rd(unsigned int reg)
-{
-	volatile unsigned int *ptr;
-
-	get_uart_base();
-	ptr = (volatile unsigned int *)(reg + uart_base);
-	return *ptr;
-}
-
-/*
- * we can deal with the case the UARTs are being run
- * in FIFO mode, so that we don't hold up our execution
- * waiting for tx to happen...
- */
-
-static void putc(int ch)
-{
-	if (uart_rd(S3C2410_UFCON) & S3C2410_UFCON_FIFOMODE) {
-		int level;
-
-		while (1) {
-			level = uart_rd(S3C2410_UFSTAT);
-			level &= fifo_mask;
-
-			if (level < fifo_max)
-				break;
-		}
-
-	} else {
-		/* not using fifos */
-
-		while ((uart_rd(S3C2410_UTRSTAT) & S3C2410_UTRSTAT_TXE) != S3C2410_UTRSTAT_TXE)
-			barrier();
-	}
+		uart_base = S5P6440_PA_UART(CONFIG_S3C_LOWLEVEL_UART_PORT);
 
-	/* write byte to transmission register */
-	uart_wr(S3C2410_UTXH, ch);
-}
-
-static inline void flush(void)
-{
-}
-
-#define __raw_writel(d, ad)			\
-	do {							\
-		*((volatile unsigned int __force *)(ad)) = (d); \
-	} while (0)
-
-
-#ifdef CONFIG_S3C_BOOT_ERROR_RESET
-
-static void arch_decomp_error(const char *x)
-{
-	putstr("\n\n");
-	putstr(x);
-	putstr("\n\n -- System resetting\n");
-
-	__raw_writel(0x4000, S3C2410_WTDAT);
-	__raw_writel(0x4000, S3C2410_WTCNT);
-	__raw_writel(S3C2410_WTCON_ENABLE | S3C2410_WTCON_DIV128 | S3C2410_WTCON_RSTEN | S3C2410_WTCON_PRESCALE(0x40), S3C2410_WTCON);
-
-	while(1);
-}
-
-#define arch_error arch_decomp_error
-#endif
-
-#ifdef CONFIG_S3C_BOOT_UART_FORCE_FIFO
-static inline void arch_enable_uart_fifo(void)
-{
-	u32 fifocon = uart_rd(S3C2410_UFCON);
-
-	if (!(fifocon & S3C2410_UFCON_FIFOMODE)) {
-		fifocon |= S3C2410_UFCON_RESETBOTH;
-		uart_wr(S3C2410_UFCON, fifocon);
-
-		/* wait for fifo reset to complete */
-		while (1) {
-			fifocon = uart_rd(S3C2410_UFCON);
-			if (!(fifocon & S3C2410_UFCON_RESETBOTH))
-				break;
-		}
-	}
-}
-#else
-#define arch_enable_uart_fifo() do { } while(0)
-#endif
-
-static void arch_decomp_setup(void)
-{
-	/*
-	 * we may need to setup the uart(s) here if we are not running
-	 * on an BAST... the BAST will have left the uarts configured
-	 * after calling linux.
-	 */
-
-	arch_detect_cpu();
-
-	/*
-	 * Enable the UART FIFOs if they where not enabled and our
-	 * configuration says we should turn them on.
-	 */
-
-	arch_enable_uart_fifo();
-}
-
-
-
-static void arch_detect_cpu(void)
-{
-	/* we do not need to do any cpu detection here at the moment. */
+	fifo_mask = S3C2440_UFSTAT_TXMASK;
+	fifo_max = 63 << S3C2440_UFSTAT_TXSHIFT;
 }
 
 #endif /* __ASM_ARCH_UNCOMPRESS_H */
-- 
1.7.9.5

