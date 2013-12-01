Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab3LAG1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 01:27:01 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:59199 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3LAG0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 01:26:53 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org (open list:SERIAL DRIVERS)
Subject: [PATCH 01/11] resolve PXA<->8250 serial device address conflict
Date: Sun,  1 Dec 2013 10:26:14 +0400
Message-Id: <1385879185-22455-2-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PXA serial ports have "standard" UART names (ttyS[0-3]), major
device number (4) and first minor device number (64) by default.

If the system has extra 8250 serial port hardware in addition
to onboard PXA serial ports, default settings produce a device
allocation conflict.

The patch provides a configuration option which can move onboard
ports out of the way of 8250_core by assigning a different (204)
major number and corresponding device names (ttySA[0-3]).

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
 drivers/tty/serial/Kconfig | 19 +++++++++++++++++++
 drivers/tty/serial/pxa.c   | 22 ++++++++++++++++++----
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index a3817ab..328b716 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -419,6 +419,25 @@ config SERIAL_PXA_CONSOLE
 	  your boot loader (lilo or loadlin) about how to pass options to the
 	  kernel at boot time.)
 
+config SERIAL_PXA_AS_TTYSA
+	bool "PXA serial ports with SA-1100 name and major number"
+	depends on SERIAL_PXA
+	default N
+	help
+	  PXA serial ports have "standard" UART names (ttyS[0-3]), major
+	  device number (4) and first minor device number (64) by default.
+
+	  If the system has extra 8250 serial port hardware in addition
+	  to onboard PXA serial ports, default settings produce a device
+	  allocation conflict.
+
+	  Selecting this option will move onboard ports out of the way of
+	  8250_core by assigning a different (204) major number and
+	  corresponding device names (ttySA[0-3]).
+
+	  Say Y here, if you need to support extra 8250 serial port hardware
+	  on a PXA system.
+
 config SERIAL_SA1100
 	bool "SA1100 serial port support"
 	depends on ARCH_SA1100
diff --git a/drivers/tty/serial/pxa.c b/drivers/tty/serial/pxa.c
index f9f20f3..2b5a8ad 100644
--- a/drivers/tty/serial/pxa.c
+++ b/drivers/tty/serial/pxa.c
@@ -593,6 +593,20 @@ serial_pxa_type(struct uart_port *port)
 static struct uart_pxa_port *serial_pxa_ports[4];
 static struct uart_driver serial_pxa_reg;
 
+#ifndef CONFIG_SERIAL_PXA_AS_TTYSA
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
@@ -751,7 +765,7 @@ serial_pxa_console_setup(struct console *co, char *options)
 }
 
 static struct console serial_pxa_console = {
-	.name		= "ttyS",
+	.name		= PXA_TTY_NAME,
 	.write		= serial_pxa_console_write,
 	.device		= uart_console_device,
 	.setup		= serial_pxa_console_setup,
@@ -792,9 +806,9 @@ static struct uart_ops serial_pxa_pops = {
 static struct uart_driver serial_pxa_reg = {
 	.owner		= THIS_MODULE,
 	.driver_name	= "PXA serial",
-	.dev_name	= "ttyS",
-	.major		= TTY_MAJOR,
-	.minor		= 64,
+	.dev_name	= PXA_TTY_NAME,
+	.major		= PXA_TTY_MAJOR,
+	.minor		= PXA_TTY_MINOR,
 	.nr		= 4,
 	.cons		= PXA_CONSOLE,
 };
-- 
1.8.4.2

