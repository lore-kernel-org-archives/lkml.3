Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965Ab3CLXCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:02:52 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:64573 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933673Ab3CLXCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:02:36 -0400
From: Sergey Yanovich <ynvich@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sergey Yanovich <ynvich@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] allow alternative name for PXA serial console
Date: Wed, 13 Mar 2013 03:02:22 +0400
Message-Id: <1363129342-24310-1-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ICP DAS LP-8x4x is an industrial data acquision device. It is based
on PXA270 CPU. The board containsi a lot of (up to 36) standard UARTi
8250i serial ports. System console on the board is provided with
an on-chip PXA serial port. Both modules use /dev/ttyS0 by default.

To solve the collision, PXA ports could be configured with different
name and device numbers.

Signed-off-by: Sergey Yanovich <ynvich@gmail.com>
---
 drivers/tty/serial/Kconfig |   14 ++++++++++++++
 drivers/tty/serial/pxa.c   |   22 ++++++++++++++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 59c23d0..09cf980 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -406,6 +406,20 @@ config SERIAL_PXA_CONSOLE
 	  your boot loader (lilo or loadlin) about how to pass options to the
 	  kernel at boot time.)
 
+config SERIAL_PXA_TTYSA_NAME
+	bool "as /dev/ttySA[0-3]"
+	depends on SERIAL_PXA
+	default N
+	help
+	  If you have enabled the serial port on the Intel XScale PXA
+	  CPU you can make it appear as /dev/ttySA[0-3] in the system.
+
+	  If you say N here (default), the ports will use UART /dev/ttyS[0-3]
+	  names and corresponding major and minor devices numbers.
+
+	  If you say Y here, the ports will have SA-1100 style names and
+	  numbers. It is reqired at least for one PXA based device.
+
 config SERIAL_SA1100
 	bool "SA1100 serial port support"
 	depends on ARCH_SA1100
diff --git a/drivers/tty/serial/pxa.c b/drivers/tty/serial/pxa.c
index 2764828..a7e5e40 100644
--- a/drivers/tty/serial/pxa.c
+++ b/drivers/tty/serial/pxa.c
@@ -619,6 +619,20 @@ serial_pxa_type(struct uart_port *port)
 static struct uart_pxa_port *serial_pxa_ports[4];
 static struct uart_driver serial_pxa_reg;
 
+#ifndef CONFIG_SERIAL_PXA_TTYSA_NAME
+
+#define PXA_TTY_NAME	"ttyS"
+#define PXA_TTY_MAJOR	TTY_MAJOR
+#define PXA_TTY_MINOR	64
+
+#else
+
+#define PXA_TTY_NAME	"ttySA"
+#define PXA_TTY_MAJOR	204
+#define PXA_TTY_MINOR	5
+
+#endif
+
 #ifdef CONFIG_SERIAL_PXA_CONSOLE
 
 #define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
@@ -778,7 +792,7 @@ serial_pxa_console_setup(struct console *co, char *options)
 }
 
 static struct console serial_pxa_console = {
-	.name		= "ttyS",
+	.name		= PXA_TTY_NAME,
 	.write		= serial_pxa_console_write,
 	.device		= uart_console_device,
 	.setup		= serial_pxa_console_setup,
@@ -819,9 +833,9 @@ struct uart_ops serial_pxa_pops = {
 static struct uart_driver serial_pxa_reg = {
 	.owner		= THIS_MODULE,
 	.driver_name	= "PXA serial",
-	.dev_name	= "ttyS",
-	.major		= TTY_MAJOR,
-	.minor		= 64,
+	.dev_name	= PXA_TTY_NAME
+	.major		= PXA_TTY_MAJOR,
+	.minor		= PXA_TTY_MINOR,
 	.nr		= 4,
 	.cons		= PXA_CONSOLE,
 };
-- 
1.7.10.4

