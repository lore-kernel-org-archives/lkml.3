Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3LAG2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 01:28:30 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:39309 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3LAG2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 01:28:23 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-serial@vger.kernel.org (open list:SERIAL DRIVERS)
Subject: [PATCH 05/11] serial: support for 16550 serial ports on LP-8x4x
Date: Sun,  1 Dec 2013 10:26:18 +0400
Message-Id: <1385879185-22455-6-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds support for 3 additional LP-8x4x built-in serial
ports.

The device can also host up to 8 extension cards with 4 serial ports
on each card for a total of 35 ports. However, I don't have
the hardware to test extension cards, so they are not supported, yet.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
 arch/arm/configs/lp8x4x_defconfig       |   1 +
 arch/arm/mach-pxa/include/mach/lp8x4x.h |   6 ++
 drivers/tty/serial/8250/8250_lp8x4x.c   | 181 ++++++++++++++++++++++++++++++++
 drivers/tty/serial/8250/Kconfig         |  11 ++
 drivers/tty/serial/8250/Makefile        |   1 +
 5 files changed, 200 insertions(+)
 create mode 100644 drivers/tty/serial/8250/8250_lp8x4x.c

diff --git a/arch/arm/configs/lp8x4x_defconfig b/arch/arm/configs/lp8x4x_defconfig
index 03c85bc..d297a67 100644
--- a/arch/arm/configs/lp8x4x_defconfig
+++ b/arch/arm/configs/lp8x4x_defconfig
@@ -1141,6 +1141,7 @@ CONFIG_SERIAL_8250_NR_UARTS=36
 CONFIG_SERIAL_8250_RUNTIME_UARTS=36
 CONFIG_SERIAL_8250_EXTENDED=y
 CONFIG_SERIAL_8250_MANY_PORTS=y
+CONFIG_SERIAL_8250_LP8X4X=m
 CONFIG_SERIAL_8250_SHARE_IRQ=y
 # CONFIG_SERIAL_8250_DETECT_IRQ is not set
 # CONFIG_SERIAL_8250_RSA is not set
diff --git a/arch/arm/mach-pxa/include/mach/lp8x4x.h b/arch/arm/mach-pxa/include/mach/lp8x4x.h
index a49df22..4d5474e 100644
--- a/arch/arm/mach-pxa/include/mach/lp8x4x.h
+++ b/arch/arm/mach-pxa/include/mach/lp8x4x.h
@@ -50,6 +50,12 @@
 #define LP8X4X_CLRFALLINT	LP8X4X_P2V(0x1700901a)
 #define LP8X4X_RWRTC		LP8X4X_P2V(0x1700901c)
 #define LP8X4X_SRAMBANK		0x1700901e
+#define LP8X4X_TTYS0_QUIRK	0x17009030
+#define LP8X4X_TTYS1_QUIRK	0x17009032
+#define LP8X4X_TTYS2_QUIRK	0x17009034
+#define LP8X4X_TTYS0_IOMEM	0x17009050
+#define LP8X4X_TTYS1_IOMEM	0x17009060
+#define LP8X4X_TTYS2_IOMEM	0x17009070
 #define LP8X4X_SRAM		0x1700a000
 
 /* board specific IRQs */
diff --git a/drivers/tty/serial/8250/8250_lp8x4x.c b/drivers/tty/serial/8250/8250_lp8x4x.c
new file mode 100644
index 0000000..27b01f0b
--- /dev/null
+++ b/drivers/tty/serial/8250/8250_lp8x4x.c
@@ -0,0 +1,181 @@
+/*  linux/drivers/tty/serial/8250/8250_lp8x4x.c
+ *
+ *  Support for 16550 serial ports on ICP DAS LP-8x4x
+ *
+ *  Copyright (C) 2013 Sergei Ianovich <ynvich@gmail.com>
+ *  Framework taken from linux/drivers/tty/serial/8250/8250_accent.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/delay.h>
+#include <linux/serial_8250.h>
+#include <mach/lp8x4x.h>
+#include <linux/io.h>
+
+#define QUIRK_PORT(_base, _irq)					\
+	{							\
+		.iobase		= _base,			\
+		.membase	= (void *) _base,		\
+		.mapbase	= _base,			\
+		.irq		= _irq,				\
+		.uartclk	= 14745600,			\
+		.regshift	= 1,				\
+		.iotype		= UPIO_MEM,			\
+		.flags		= UPF_IOREMAP,			\
+		.set_termios	= lp8x4x_set_termios,		\
+		.serial_in	= lp8x4x_serial_in,		\
+		.serial_out	= lp8x4x_serial_out,		\
+	}
+
+static void lp8x4x_set_termios(struct uart_port *port,
+		struct ktermios *termios, struct ktermios *old)
+{
+	unsigned int len;
+	unsigned int baud;
+
+	switch (termios->c_cflag & CSIZE) {
+	case CS5:
+		len = 7;
+		break;
+	case CS6:
+		len = 8;
+		break;
+	case CS7:
+		len = 9;
+		break;
+	default:
+	case CS8:
+		len = 10;
+		break;
+	}
+
+	if (termios->c_cflag & CSTOPB)
+		len++;
+	if (termios->c_cflag & PARENB)
+		len++;
+	if (!(termios->c_cflag & PARODD))
+		len++;
+#ifdef CMSPAR
+	if (termios->c_cflag & CMSPAR)
+		len++;
+#endif
+
+	len -= 9;
+	len &= 3;
+	len <<= 3;
+	/*
+	 * Ask the core to calculate the divisor for us.
+	 */
+	baud = uart_get_baud_rate(port, termios, old,
+				  port->uartclk / 16 / 0xffff,
+				  port->uartclk / 16);
+	switch (baud) {
+	case 2400:
+		len |= 1;
+	case 4800:
+		len |= 2;
+	case 19200:
+		len |= 4;
+	case 38400:
+		len |= 5;
+	case 57600:
+		len |= 6;
+	case 115200:
+		len |= 7;
+	case 9600:
+	default:
+		len |= 3;
+	};
+	iowrite8(len, port->private_data);
+
+	serial8250_do_set_termios(port, termios, old);
+}
+
+static unsigned int lp8x4x_serial_in(struct uart_port *p, int offset)
+{
+	unsigned int b;
+	udelay(30);
+	offset = offset << p->regshift;
+	b = readb(p->membase + offset);
+	return b;
+}
+
+static void lp8x4x_serial_out(struct uart_port *p, int offset, int value)
+{
+	offset = offset << p->regshift;
+	writeb(value, p->membase + offset);
+}
+
+static struct plat_serial8250_port lp8x4x_data[] = {
+	QUIRK_PORT(LP8X4X_TTYS0_IOMEM, LP8X4X_TTYS0_IRQ),
+	QUIRK_PORT(LP8X4X_TTYS1_IOMEM, LP8X4X_TTYS1_IRQ),
+	QUIRK_PORT(LP8X4X_TTYS2_IOMEM, LP8X4X_TTYS2_IRQ),
+	{ },
+};
+
+/* Total number of ports can be 35. The first 3 ports are on
+ * the device, the rest are on extension slots. Only the first 3
+ * require termios quirk */
+#define LP8X4X_QUIRK_PORTS	3
+
+static unsigned int extra_mem[LP8X4X_QUIRK_PORTS] = {
+	LP8X4X_TTYS0_QUIRK,
+	LP8X4X_TTYS1_QUIRK,
+	LP8X4X_TTYS2_QUIRK
+};
+
+static int request_and_remap(int i)
+{
+	if (!request_mem_region(extra_mem[i], 1, "serial"))
+		return -EBUSY;
+
+	lp8x4x_data[i].private_data = ioremap(extra_mem[i], 1);
+	if (lp8x4x_data[i].private_data)
+		return 0;
+
+	release_mem_region(extra_mem[i], 1);
+	return -ENODEV;
+}
+
+static void release_and_unmap(int i)
+{
+	iounmap((void *) lp8x4x_data[i].private_data);
+	release_mem_region(extra_mem[i], 1);
+}
+
+static struct platform_device lp8x4x_device = {
+	.name			= "serial8250",
+	.id			= PLAT8250_DEV_ACCENT,
+	.dev			= {
+		.platform_data	= lp8x4x_data,
+	},
+};
+
+static int __init lp8x4x_init(void)
+{
+	int i = 0;
+	int err = 0;
+
+	for (i = 0; i < LP8X4X_QUIRK_PORTS; i++) {
+		err = request_and_remap(i);
+		if (err == 0)
+			continue;
+
+		for (; i >= 0; i--)
+			release_and_unmap(i);
+		lp8x4x_device.dev.platform_data = NULL;
+		return err;
+	}
+	return platform_device_register(&lp8x4x_device);
+}
+
+module_init(lp8x4x_init);
+
+MODULE_AUTHOR("Sergei Ianovich");
+MODULE_DESCRIPTION("8250 serial port module for LP-8x4x");
+MODULE_LICENSE("GPL");
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index f3b306e..30b9af4 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -237,6 +237,17 @@ config SERIAL_8250_HUB6
 	  To compile this driver as a module, choose M here: the module
 	  will be called 8250_hub6.
 
+config SERIAL_8250_LP8X4X
+	tristate "Support 8250 ports on ICP DAS LP-8x4x"
+	depends on SERIAL_8250 != n && SERIAL_8250_MANY_PORTS && MACH_LP8X4X
+	help
+	  In addition on serial ports on PXA270 SoC, LP-8x4x has 1 dual
+	  RS232/RS485 port, 1 RS485 port and 1 RS232 port serial ports.
+
+	  Say N here, unless you plan to run this kernel on a LP-8x4x system.
+
+	  If you choose M, the module will be called 8250_lp8x4x.
+
 #
 # Misc. options/drivers.
 #
diff --git a/drivers/tty/serial/8250/Makefile b/drivers/tty/serial/8250/Makefile
index 36d68d0..451c558 100644
--- a/drivers/tty/serial/8250/Makefile
+++ b/drivers/tty/serial/8250/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_SERIAL_8250_ACCENT)	+= 8250_accent.o
 obj-$(CONFIG_SERIAL_8250_BOCA)		+= 8250_boca.o
 obj-$(CONFIG_SERIAL_8250_EXAR_ST16C554)	+= 8250_exar_st16c554.o
 obj-$(CONFIG_SERIAL_8250_HUB6)		+= 8250_hub6.o
+obj-$(CONFIG_SERIAL_8250_LP8X4X)	+= 8250_lp8x4x.o
 obj-$(CONFIG_SERIAL_8250_FSL)		+= 8250_fsl.o
 obj-$(CONFIG_SERIAL_8250_DW)		+= 8250_dw.o
 obj-$(CONFIG_SERIAL_8250_EM)		+= 8250_em.o
-- 
1.8.4.2

