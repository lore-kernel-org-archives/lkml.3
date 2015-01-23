Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbbAWRve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:51:34 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:34752 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070AbbAWRvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:51:31 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH 1/2] x86/boot/earlyprintk: use macros which are already defined
Date: Fri, 23 Jan 2015 23:51:24 +0600
Message-Id: <1422035484-18850-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.3.0.rc1.275.g028c360
In-Reply-To: <1422035451-18795-1-git-send-email-kuleshovmail@gmail.com>
References: <1422035451-18795-1-git-send-email-kuleshovmail@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use macros which are already defined at <linux/serial_reg.h> for early
initialization of serial port and work with it.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/boot/boot.h                 |  1 +
 arch/x86/boot/compressed/misc.c      |  9 +++-----
 arch/x86/boot/compressed/misc.h      |  1 +
 arch/x86/boot/early_serial_console.c | 44 ++++++++++++------------------------
 arch/x86/boot/tty.c                  | 10 +++-----
 5 files changed, 22 insertions(+), 43 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index bd49ec6..f09becb 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -23,6 +23,7 @@
 #include <stdarg.h>
 #include <linux/types.h>
 #include <linux/edd.h>
+#include <linux/serial_reg.h>
 #include <asm/boot.h>
 #include <asm/setup.h>
 #include "bitops.h"
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index dcc1c53..df9bf76 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -156,18 +156,15 @@ static void scroll(void)
 		vidmem[i] = ' ';
 }

-#define XMTRDY          0x20
-
-#define TXR             0       /*  Transmit register (WRITE) */
-#define LSR             5       /*  Line Status               */
 static void serial_putchar(int ch)
 {
 	unsigned timeout = 0xffff;

-	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
+	while ((inb(early_serial_base + UART_LSR) & UART_LSR_THRE) == 0 &&
+	       --timeout)
 		cpu_relax();

-	outb(ch, early_serial_base + TXR);
+	outb(ch, early_serial_base + UART_TX);
 }

 void __putstr(const char *s)
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 24e3e56..3f5eaaa 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -15,6 +15,7 @@
 #include <linux/screen_info.h>
 #include <linux/elf.h>
 #include <linux/io.h>
+#include <linux/serial_reg.h>
 #include <asm/page.h>
 #include <asm/boot.h>
 #include <asm/bootparam.h>
diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
index 5df2869..bcac6b9 100644
--- a/arch/x86/boot/early_serial_console.c
+++ b/arch/x86/boot/early_serial_console.c
@@ -2,22 +2,6 @@

 #define DEFAULT_SERIAL_PORT 0x3f8 /* ttyS0 */

-#define XMTRDY          0x20
-
-#define DLAB		0x80
-
-#define TXR             0       /*  Transmit register (WRITE) */
-#define RXR             0       /*  Receive register  (READ)  */
-#define IER             1       /*  Interrupt Enable          */
-#define IIR             2       /*  Interrupt ID              */
-#define FCR             2       /*  FIFO control              */
-#define LCR             3       /*  Line control              */
-#define MCR             4       /*  Modem control             */
-#define LSR             5       /*  Line Status               */
-#define MSR             6       /*  Modem Status              */
-#define DLL             0       /*  Divisor Latch Low         */
-#define DLH             1       /*  Divisor latch High        */
-
 #define DEFAULT_BAUD 9600

 static void early_serial_init(int port, int baud)
@@ -25,17 +9,17 @@ static void early_serial_init(int port, int baud)
 	unsigned char c;
 	unsigned divisor;

-	outb(0x3, port + LCR);	/* 8n1 */
-	outb(0, port + IER);	/* no interrupt */
-	outb(0, port + FCR);	/* no fifo */
-	outb(0x3, port + MCR);	/* DTR + RTS */
+	outb(0x3, port + UART_LCR);/* 8n1 */
+	outb(0, port + UART_IER); /* no interrupt */
+	outb(0, port + UART_FCR); /* no fifo */
+	outb(0x3, port + UART_MCR);	  /* DTR + RTS */

 	divisor	= 115200 / baud;
-	c = inb(port + LCR);
-	outb(c | DLAB, port + LCR);
-	outb(divisor & 0xff, port + DLL);
-	outb((divisor >> 8) & 0xff, port + DLH);
-	outb(c & ~DLAB, port + LCR);
+	c = inb(port + UART_LCR);
+	outb(c | UART_LCR_DLAB, port + UART_LCR);
+	outb(divisor & 0xff, port + UART_DLL);
+	outb((divisor >> 8) & 0xff, port + UART_DLM);
+	outb(c & ~UART_LCR_DLAB, port + UART_LCR);

 	early_serial_base = port;
 }
@@ -101,11 +85,11 @@ static unsigned int probe_baud(int port)
 	unsigned char lcr, dll, dlh;
 	unsigned int quot;

-	lcr = inb(port + LCR);
-	outb(lcr | DLAB, port + LCR);
-	dll = inb(port + DLL);
-	dlh = inb(port + DLH);
-	outb(lcr, port + LCR);
+	lcr = inb(port + UART_LCR);
+	outb(lcr | UART_LCR_DLAB, port + UART_LCR);
+	dll = inb(port + UART_DLL);
+	dlh = inb(port + UART_DLM);
+	outb(lcr, port + UART_LCR);
 	quot = (dlh << 8) | dll;

 	return BASE_BAUD / quot;
diff --git a/arch/x86/boot/tty.c b/arch/x86/boot/tty.c
index def2451..93ce9d6d 100644
--- a/arch/x86/boot/tty.c
+++ b/arch/x86/boot/tty.c
@@ -17,11 +17,6 @@

 int early_serial_base;

-#define XMTRDY          0x20
-
-#define TXR             0       /*  Transmit register (WRITE) */
-#define LSR             5       /*  Line Status               */
-
 /*
  * These functions are in .inittext so they can be used to signal
  * error during initialization.
@@ -31,10 +26,11 @@ static void __attribute__((section(".inittext"))) serial_putchar(int ch)
 {
 	unsigned timeout = 0xffff;

-	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
+	while ((inb(early_serial_base + UART_LSR) & UART_LSR_THRE) == 0 &&
+	       --timeout)
 		cpu_relax();

-	outb(ch, early_serial_base + TXR);
+	outb(ch, early_serial_base + UART_TX);
 }

 static void __attribute__((section(".inittext"))) bios_putchar(int ch)
--
2.3.0.rc1.275.g028c360
