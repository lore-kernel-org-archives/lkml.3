Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaDRWVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 18:21:39 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:58386 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaDRWUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 18:20:20 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v2 4/7] tty/serial: pl011: add generic earlycon support
Date: Fri, 18 Apr 2014 17:19:57 -0500
Message-Id: <1397859600-11507-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Add earlycon support for the pl011 serial port. This allows enabling
the pl011 for console when early_params are processed. This is based
on the arm64 earlyprintk support and is intended to replace it.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
---
v2:
- Rework the kernel-parameters.txt description

 Documentation/kernel-parameters.txt |  7 +++++++
 drivers/tty/serial/Kconfig          |  1 +
 drivers/tty/serial/amba-pl011.c     | 30 +++++++++++++++++++++++++++++-
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 03e50b4..15b5fcca 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -890,6 +890,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			which are not unmapped.
 
 	earlycon=	[KNL] Output early console device and options.
+
 		uart[8250],io,<addr>[,options]
 		uart[8250],mmio,<addr>[,options]
 		uart[8250],mmio32,<addr>[,options]
@@ -899,6 +900,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			(mmio) or 32-bit (mmio32).
 			The options are the same as for ttyS, above.
 
+		pl011,<addr>
+			Start an early, polled-mode console on a pl011 serial
+			port at the specified address. The pl011 serial port
+			must already be setup and configured. Options are not
+			yet supported.
+
 	earlyprintk=	[X86,SH,BLACKFIN,ARM]
 			earlyprintk=vga
 			earlyprintk=efi
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 3b7c19b..b1b23c2 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -60,6 +60,7 @@ config SERIAL_AMBA_PL011_CONSOLE
 	bool "Support for console on AMBA serial port"
 	depends on SERIAL_AMBA_PL011=y
 	select SERIAL_CORE_CONSOLE
+	select SERIAL_EARLYCON
 	---help---
 	  Say Y here if you wish to use an AMBA PrimeCell UART as the system
 	  console (the system console is the device which receives all kernel
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index d4eda24..4227c0a 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -303,7 +303,7 @@ static void pl011_dma_probe_initcall(struct device *dev, struct uart_amba_port *
 
 	/* Optionally make use of an RX channel as well */
 	chan = dma_request_slave_channel(dev, "rx");
-	
+
 	if (!chan && plat->dma_rx_param) {
 		chan = dma_request_channel(mask, plat->dma_filter, plat->dma_rx_param);
 
@@ -2045,6 +2045,34 @@ static struct console amba_console = {
 };
 
 #define AMBA_CONSOLE	(&amba_console)
+
+static void pl011_putc(struct uart_port *port, int c)
+{
+	while (readl(port->membase + UART01x_FR) & UART01x_FR_TXFF)
+		;
+	writeb(c, port->membase + UART01x_DR);
+	while (readl(port->membase + UART01x_FR) & UART01x_FR_BUSY)
+		;
+}
+
+static void pl011_early_write(struct console *con, const char *s, unsigned n)
+{
+	struct earlycon_device *dev = con->data;
+
+	uart_console_write(&dev->port, s, n, pl011_putc);
+}
+
+static int __init pl011_early_console_setup(struct earlycon_device *device,
+					    const char *opt)
+{
+	if (!device->port.membase)
+		return -ENODEV;
+
+	device->con->write = pl011_early_write;
+	return 0;
+}
+EARLYCON_DECLARE(pl011, pl011_early_console_setup);
+
 #else
 #define AMBA_CONSOLE	NULL
 #endif
-- 
1.9.1

