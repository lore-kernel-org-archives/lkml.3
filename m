Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaI2MFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:05:54 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57880 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaI2MFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:05:49 -0400
From: zhang.lyra@gmail.com
To: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org,
        broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com,
        pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com,
        robh+dt@kernel.org, will.deacon@arm.com, orsonzhai@gmail.com,
        geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
Subject: [PATCH 5/6] tty/serial: Add Spreadtrum's serial earlycon
Date: Mon, 29 Sep 2014 20:04:52 +0800
Message-Id: <1411992293-7729-6-git-send-email-zhang.lyra@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "chunyan.zhang" <chunyan.zhang@spreadtrum.com>

Adds earlycon support for the Spreadtrum's serial.

Signed-off-by: chunyan.zhang <chunyan.zhang@spreadtrum.com>
---
 drivers/tty/serial/Kconfig             |   12 ++++++
 drivers/tty/serial/Makefile            |    1 +
 drivers/tty/serial/serial_sprd_early.c |   64 ++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+)
 create mode 100644 drivers/tty/serial/serial_sprd_early.c

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 26cec64..ede16e6 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -85,6 +85,18 @@ config SERIAL_EARLYCON_ARM_SEMIHOST
 	  with "earlycon=smh" on the kernel command line. The console is
 	  enabled when early_param is processed.
 
+config SERIAL_EARLYCON_SPRD
+	bool "Early console using SPRD serial"
+	depends on ARM64
+	select SERIAL_CORE
+	select SERIAL_CORE_CONSOLE
+	select SERIAL_EARLYCON
+	help
+	  Support for early debug console using SPRD serial. This enables
+	  the console before standard serial driver is probed. This is enabled
+	  with "earlycon=serial_sprd" on the kernel command line. The console is
+	  enabled when early_param is processed.
+
 config SERIAL_SB1250_DUART
 	tristate "BCM1xxx on-chip DUART serial support"
 	depends on SIBYTE_SB1xxx_SOC=y
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index 0080cc3..3ea9edc 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_SERIAL_21285) += 21285.o
 
 obj-$(CONFIG_SERIAL_EARLYCON) += earlycon.o
 obj-$(CONFIG_SERIAL_EARLYCON_ARM_SEMIHOST) += earlycon-arm-semihost.o
+obj-$(CONFIG_SERIAL_EARLYCON_SPRD) += serial_sprd_early.o
 
 # These Sparc drivers have to appear before others such as 8250
 # which share ttySx minor node space.  Otherwise console device
diff --git a/drivers/tty/serial/serial_sprd_early.c b/drivers/tty/serial/serial_sprd_early.c
new file mode 100644
index 0000000..059e109
--- /dev/null
+++ b/drivers/tty/serial/serial_sprd_early.c
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
+#define ARM_UART_TXD	0x0000
+#define ARM_UART_RXD	0x0004
+#define ARM_UART_STS0	0x0008
+#define ARM_UART_STS1	0x000C
+#define ARM_UART_IEN	0x0010
+#define ARM_UART_ICLR	0x0014
+#define ARM_UART_CTL0	0x0018
+#define ARM_UART_CTL1	0x001C
+#define ARM_UART_CTL2	0x0020
+#define ARM_UART_CLKD0	0x0024
+#define ARM_UART_CLKD1	0x0028
+#define ARM_UART_STS2	0x002C
+
+/*line status */
+#define UART_LSR_TX_OVER	(0x1<<15)
+
+static void serial_sprd_putc(struct uart_port *port, int c)
+{
+	while (!(readl(port->membase + ARM_UART_STS0) & UART_LSR_TX_OVER))
+		;
+	writeb(c, port->membase + ARM_UART_TXD);
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

