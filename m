Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab3EaMD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:03:56 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:40190 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab3EaMDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:03:20 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: arnd@arndb.de, kgene.kim@samsung.com, olof@lixom.net, patches@linaro.org
Subject: [PATCH 3/3] ARM: S5P64X0: Remove duplicate uncompress code
Date: Fri, 31 May 2013 17:19:04 +0530
Message-Id: <1370000944-19786-4-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370000944-19786-1-git-send-email-tushar.behera@linaro.org>
References: <1370000944-19786-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uncompress code in S5P64X0 is almost same as the uncompress code
defined in plat-samsung. Better to reuse that code.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 arch/arm/mach-s5p64x0/include/mach/uncompress.h |  163 ++---------------------
 1 file changed, 8 insertions(+), 155 deletions(-)

diff --git a/arch/arm/mach-s5p64x0/include/mach/uncompress.h b/arch/arm/mach-s5p64x0/include/mach/uncompress.h
index 19e0d64..b28a551 100644
--- a/arch/arm/mach-s5p64x0/include/mach/uncompress.h
+++ b/arch/arm/mach-s5p64x0/include/mach/uncompress.h
@@ -14,171 +14,24 @@
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
+#ifdef DEBUG_LL
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
-
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
+		uart_base = S5P6440_PA_UART(CONFIG_S3C_LOWLEVEL_UART_PORT);
 #else
-#define arch_enable_uart_fifo() do { } while(0)
+	uart_base = NULL;
 #endif
 
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
+	fifo_mask = S3C2440_UFSTAT_TXMASK;
+	fifo_max = 63 << S3C2440_UFSTAT_TXSHIFT;
 }
-
-
-
-static void arch_detect_cpu(void)
-{
-	/* we do not need to do any cpu detection here at the moment. */
-}
-
 #endif /* __ASM_ARCH_UNCOMPRESS_H */
-- 
1.7.9.5

