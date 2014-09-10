Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaIJKnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:43:13 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51952 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaIJKnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:43:10 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] serial: cadence: Add generic earlycon support
Date: Wed, 10 Sep 2014 12:43:02 +0200
Message-Id: <58f2c9cf267e64f5d7566920844fb2db251e77d2.1410345777.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-31784-1410345782-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-31784-1410345782-0001

Add earlycon support for the cadence serial port.
This is based on recent patches:
"tty/serial: pl011: add generic earlycon support"
(sha1: 0d3c673e7881e691991b2a4745bd4f149603baa2)
"tty/serial: add arm/arm64 semihosting earlycon"
(sha1: d50d7269ebcb438afa346cdffce0f4e2a1b9e831)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 Documentation/kernel-parameters.txt |  6 ++++++
 drivers/tty/serial/Kconfig          |  1 +
 drivers/tty/serial/xilinx_uartps.c  | 19 +++++++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a8eb6afce6a4..97055dc43167 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -921,6 +921,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.

 	earlycon=	[KNL] Output early console device and options.

+		cdns,<addr>
+			Start an early, polled-mode console on a cadence serial
+			port at the specified address. The cadence serial port
+			must already be setup and configured. Options are not
+			yet supported.
+
 		uart[8250],io,<addr>[,options]
 		uart[8250],mmio,<addr>[,options]
 		uart[8250],mmio32,<addr>[,options]
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index b4d61e6bf28c..72fd2b6e2241 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1411,6 +1411,7 @@ config SERIAL_XILINX_PS_UART_CONSOLE
 	bool "Cadence UART console support"
 	depends on SERIAL_XILINX_PS_UART=y
 	select SERIAL_CORE_CONSOLE
+	select SERIAL_EARLYCON
 	help
 	  Enable a Cadence UART port to be the system console.

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 01951d27cc03..675f3fe068f6 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1051,6 +1051,25 @@ static void cdns_uart_console_putchar(struct uart_port *port, int ch)
 	cdns_uart_writel(ch, CDNS_UART_FIFO_OFFSET);
 }

+static void cdns_early_write(struct console *con, const char *s, unsigned n)
+{
+	struct earlycon_device *dev = con->data;
+
+	uart_console_write(&dev->port, s, n, cdns_uart_console_putchar);
+}
+
+static int __init cdns_early_console_setup(struct earlycon_device *device,
+					   const char *opt)
+{
+	if (!device->port.membase)
+		return -ENODEV;
+
+	device->con->write = cdns_early_write;
+
+	return 0;
+}
+EARLYCON_DECLARE(cdns, cdns_early_console_setup);
+
 /**
  * cdns_uart_console_write - perform write operation
  * @co: Console handle
--
1.8.2.3


--=_mimegpg-monstr-desktop-31784-1410345782-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlQQKzYACgkQykllyylKDCECkgCfYxCzp3PEnbcZmUsiO5CbYwc0
glYAn0rlvcH11wHrHqNpoWhB7l5SCp24
=DLG1
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-31784-1410345782-0001--
