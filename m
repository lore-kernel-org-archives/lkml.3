Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab3BKVwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 16:52:09 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:33610 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab3BKVwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 16:52:08 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH] MIPS: early_printk: drop __init annotations
Date: Mon, 11 Feb 2013 23:51:49 +0200
Message-Id: <1360619509-6576-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot use __init for earlyprintk code or data, since the kernel
parameter "keep_bootcon" allows leaving the boot console enabled.

Currently MIPS will crash/hang/die if you use keep_bootcon. The patch
fixes it at least on Lemote FuLoong mini-PC. Changes for other boards
were done based on what I could find with grep...

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/mips/bcm63xx/early_printk.c  |    4 ++--
 arch/mips/kernel/early_printk.c   |    5 ++---
 arch/mips/loongson1/common/prom.c |    2 +-
 arch/mips/sgi-ip27/ip27-console.c |    2 +-
 arch/mips/txx9/generic/setup.c    |    8 ++++----
 5 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/mips/bcm63xx/early_printk.c b/arch/mips/bcm63xx/early_printk.c
index bf353c9..aa8f7f9 100644
--- a/arch/mips/bcm63xx/early_printk.c
+++ b/arch/mips/bcm63xx/early_printk.c
@@ -10,7 +10,7 @@
 #include <bcm63xx_io.h>
 #include <bcm63xx_regs.h>
 
-static void __init wait_xfered(void)
+static void wait_xfered(void)
 {
 	unsigned int val;
 
@@ -22,7 +22,7 @@ static void __init wait_xfered(void)
 	} while (1);
 }
 
-void __init prom_putchar(char c)
+void prom_putchar(char c)
 {
 	wait_xfered();
 	bcm_uart0_writel(c, UART_FIFO_REG);
diff --git a/arch/mips/kernel/early_printk.c b/arch/mips/kernel/early_printk.c
index 9ae813e..9e6440e 100644
--- a/arch/mips/kernel/early_printk.c
+++ b/arch/mips/kernel/early_printk.c
@@ -14,8 +14,7 @@
 
 extern void prom_putchar(char);
 
-static void __init
-early_console_write(struct console *con, const char *s, unsigned n)
+static void early_console_write(struct console *con, const char *s, unsigned n)
 {
 	while (n-- && *s) {
 		if (*s == '\n')
@@ -25,7 +24,7 @@ early_console_write(struct console *con, const char *s, unsigned n)
 	}
 }
 
-static struct console early_console __initdata = {
+static struct console early_console = {
 	.name	= "early",
 	.write	= early_console_write,
 	.flags	= CON_PRINTBUFFER | CON_BOOT,
diff --git a/arch/mips/loongson1/common/prom.c b/arch/mips/loongson1/common/prom.c
index 1f8e49f..54dee09 100644
--- a/arch/mips/loongson1/common/prom.c
+++ b/arch/mips/loongson1/common/prom.c
@@ -73,7 +73,7 @@ void __init prom_free_prom_memory(void)
 
 #define PORT(offset)	(u8 *)(KSEG1ADDR(LS1X_UART0_BASE + offset))
 
-void __init prom_putchar(char c)
+void prom_putchar(char c)
 {
 	int timeout;
 
diff --git a/arch/mips/sgi-ip27/ip27-console.c b/arch/mips/sgi-ip27/ip27-console.c
index 984e561..b952d5b 100644
--- a/arch/mips/sgi-ip27/ip27-console.c
+++ b/arch/mips/sgi-ip27/ip27-console.c
@@ -31,7 +31,7 @@ static inline struct ioc3_uartregs *console_uart(void)
 	return &ioc3->sregs.uarta;
 }
 
-void __init prom_putchar(char c)
+void prom_putchar(char c)
 {
 	struct ioc3_uartregs *uart = console_uart();
 
diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index 560fe89..5524f2c 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -513,19 +513,19 @@ void __init txx9_sio_init(unsigned long baseaddr, int irq,
 }
 
 #ifdef CONFIG_EARLY_PRINTK
-static void __init null_prom_putchar(char c)
+static void null_prom_putchar(char c)
 {
 }
-void (*txx9_prom_putchar)(char c) __initdata = null_prom_putchar;
+void (*txx9_prom_putchar)(char c) = null_prom_putchar;
 
-void __init prom_putchar(char c)
+void prom_putchar(char c)
 {
 	txx9_prom_putchar(c);
 }
 
 static void __iomem *early_txx9_sio_port;
 
-static void __init early_txx9_sio_putchar(char c)
+static void early_txx9_sio_putchar(char c)
 {
 #define TXX9_SICISR	0x0c
 #define TXX9_SITFIFO	0x1c
-- 
1.7.10.4

