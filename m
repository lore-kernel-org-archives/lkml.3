Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaJQKeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 06:34:13 -0400
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:49975 "EHLO
	SHSQR01.spreadtrum.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751848AbaJQKeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 06:34:01 -0400
From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
To: <catalin.marinas@arm.com>, <gregkh@linuxfoundation.org>,
        <ijc+devicetree@hellion.org.uk>, <jslaby@suse.cz>,
        <galak@codeaurora.org>, <broonie@linaro.org>, <mark.rutland@arm.com>,
        <m-karicheri2@ti.com>, <pawel.moll@arm.com>, <artagnon@gmail.com>,
        <rrichter@cavium.com>, <robh+dt@kernel.org>, <will.deacon@arm.com>,
        <orsonzhai@gmail.com>, <geng.ren@spreadtrum.com>,
        <zhizhou.zhang@spreadtrum.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <sprdlinux@freelists.org>
Subject: [PATCH v2 5/5] tty/serial: Add earlycon support for Spreadtrum serial driver
Date: Fri, 17 Oct 2014 17:54:25 +0800
Message-ID: <1413539665-11484-6-git-send-email-chunyan.zhang@spreadtrum.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413539665-11484-1-git-send-email-chunyan.zhang@spreadtrum.com>
References: <sprd-1017-v2>
 <1413539665-11484-1-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.0.67.117]
X-ClientProxiedBy: SHCAS02.spreadtrum.com (10.0.1.202) To
 SHMBX01.spreadtrum.com (10.0.1.203)
X-MAIL: SHSQR01.spreadtrum.com s9H9tHxs008649
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add serial driver for spreadtrum sharkl platform with earlycon
support at first.

Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
---
 drivers/tty/serial/Kconfig       |   24 ++++++++++++++
 drivers/tty/serial/Makefile      |    1 +
 drivers/tty/serial/sprd-serial.c |   64 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+)
 create mode 100644 drivers/tty/serial/sprd-serial.c

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 26cec64..33b8f90 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -113,6 +113,30 @@ config SERIAL_SB1250_DUART_CONSOLE
 
 	  If unsure, say Y.
 
+config SERIAL_SPRD
+	tristate "Support for SPRD serial"
+	depends on ARM || ARM64
+	select SERIAL_CORE
+	help
+          This enables the driver for the Spreadtrum's serial.
+
+config SERIAL_SPRD_NR
+        int "Maximum number of sprd serial ports"
+        depends on SERIAL_SPRD
+        default "4"
+
+config SERIAL_SPRD_CONSOLE
+        bool "SPRD UART console support"
+        depends on SERIAL_SPRD=y
+        select SERIAL_CORE_CONSOLE
+	select SERIAL_EARLYCON
+        help
+	  Support for early debug console using Spreadtrum's serial. This enables
+	  the console before standard serial driver is probed. This is enabled
+	  with "earlycon=serial_sprd" on the kernel command line. The console is
+	  enabled when early_param is processed.
+
+
 config SERIAL_ATMEL
 	bool "AT91 / AT32 on-chip serial port support"
 	depends on ARCH_AT91 || AVR32
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index 0080cc3..b16e0d4 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_SERIAL_ARC)	+= arc_uart.o
 obj-$(CONFIG_SERIAL_RP2)	+= rp2.o
 obj-$(CONFIG_SERIAL_FSL_LPUART)	+= fsl_lpuart.o
 obj-$(CONFIG_SERIAL_MEN_Z135)	+= men_z135_uart.o
+obj-$(CONFIG_SERIAL_SPRD) += sprd-serial.o
 
 # GPIOLIB helpers for modem control lines
 obj-$(CONFIG_SERIAL_MCTRL_GPIO)	+= serial_mctrl_gpio.o
diff --git a/drivers/tty/serial/sprd-serial.c b/drivers/tty/serial/sprd-serial.c
new file mode 100644
index 0000000..9ae594f
--- /dev/null
+++ b/drivers/tty/serial/sprd-serial.c
@@ -0,0 +1,64 @@
+/*
+ * Copyright (C) 2012 Spreadtrum Communications Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/console.h>
+#include <linux/init.h>
+#include <linux/serial_core.h>
+#include <linux/of.h>
+
+/*offset*/
+#define UART_TXD	0x0000
+#define UART_RXD	0x0004
+#define UART_STS0	0x0008
+#define UART_STS1	0x000C
+#define UART_IEN	0x0010
+#define UART_ICLR	0x0014
+#define UART_CTL0	0x0018
+#define UART_CTL1	0x001C
+#define UART_CTL2	0x0020
+#define UART_CLKD0	0x0024
+#define UART_CLKD1	0x0028
+#define UART_STS2	0x002C
+
+/*line status */
+#define UART_LSR_TX_OVER	(0x1<<15)
+
+static void serial_sprd_putc(struct uart_port *port, int c)
+{
+	while (!(readl(port->membase + UART_STS0) & UART_LSR_TX_OVER))
+		;
+	writeb(c, port->membase + UART_TXD);
+}
+
+static void serial_sprd_early_write(struct console *con, const char *s,
+				    unsigned n)
+{
+	struct earlycon_device *dev = con->data;
+
+	uart_console_write(&dev->port, s, n, serial_sprd_putc);
+}
+
+static int __init serial_sprd_early_console_setup(
+				struct earlycon_device *device,
+				const char *opt)
+{
+	if (!device->port.membase)
+		return -ENODEV;
+
+	device->con->write = serial_sprd_early_write;
+	return 0;
+}
+EARLYCON_DECLARE(serial_sprd, serial_sprd_early_console_setup);
+OF_EARLYCON_DECLARE(serial_sprd, "sprd,serial",
+		    serial_sprd_early_console_setup);
-- 
1.7.9.5

