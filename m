Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbbAWRvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:51:46 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:46640 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070AbbAWRvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:51:43 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH 2/2] x86/kernel/earlyprintk: use macros which are already defined
Date: Fri, 23 Jan 2015 23:51:34 +0600
Message-Id: <1422035494-18905-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.3.0.rc1.275.g028c360
In-Reply-To: <1422035451-18795-1-git-send-email-kuleshovmail@gmail.com>
References: <1422035451-18795-1-git-send-email-kuleshovmail@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use macros which are already defined at <linux/serial_reg.h> for earlyprintk.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/kernel/early_printk.c | 40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 01d1c18..99ff7ee 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -7,6 +7,7 @@
 #include <linux/pci_regs.h>
 #include <linux/pci_ids.h>
 #include <linux/errno.h>
+#include <linux/serial_reg.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/fcntl.h>
@@ -78,29 +79,14 @@ static struct console early_vga_console = {

 static int early_serial_base = 0x3f8;  /* ttyS0 */

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
 static int early_serial_putc(unsigned char ch)
 {
 	unsigned timeout = 0xffff;

-	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
+	while ((inb(early_serial_base + UART_LSR) & UART_LSR_THRE) == 0 &&
+	       --timeout)
 		cpu_relax();
-	outb(ch, early_serial_base + TXR);
+	outb(ch, early_serial_base + UART_TX);
 	return timeout ? 0 : -1;
 }

@@ -145,10 +131,10 @@ static __init void early_serial_init(char *s)
 			s++;
 	}

-	outb(0x3, early_serial_base + LCR);	/* 8n1 */
-	outb(0, early_serial_base + IER);	/* no interrupt */
-	outb(0, early_serial_base + FCR);	/* no fifo */
-	outb(0x3, early_serial_base + MCR);	/* DTR + RTS */
+	outb(0x3, early_serial_base + UART_LCR);	/* 8n1 */
+	outb(0, early_serial_base + UART_IER);		/* no interrupt */
+	outb(0, early_serial_base + UART_FCR);		/* no fifo */
+	outb(0x3, early_serial_base + UART_MCR);	/* DTR + RTS */

 	if (*s) {
 		baud = simple_strtoul(s, &e, 0);
@@ -157,11 +143,11 @@ static __init void early_serial_init(char *s)
 	}

 	divisor = 115200 / baud;
-	c = inb(early_serial_base + LCR);
-	outb(c | DLAB, early_serial_base + LCR);
-	outb(divisor & 0xff, early_serial_base + DLL);
-	outb((divisor >> 8) & 0xff, early_serial_base + DLH);
-	outb(c & ~DLAB, early_serial_base + LCR);
+	c = inb(early_serial_base + UART_LCR);
+	outb(c | UART_LCR_DLAB, early_serial_base + UART_LCR);
+	outb(divisor & 0xff, early_serial_base + UART_DLL);
+	outb((divisor >> 8) & 0xff, early_serial_base + UART_DLM);
+	outb(c & ~UART_LCR_DLAB, early_serial_base + UART_LCR);
 }

 static struct console early_serial_console = {
--
2.3.0.rc1.275.g028c360
