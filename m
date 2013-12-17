Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3LQTj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:39:57 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:46012 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3LQTjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:39:53 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        James Cameron <quozl@laptop.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-serial@vger.kernel.org (open list:SERIAL DRIVERS)
Subject: [PATCH v3 12/21] serial: support for 16550A serial ports on LP-8x4x
Date: Tue, 17 Dec 2013 23:37:42 +0400
Message-Id: <1387309071-22382-13-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds support for 3 additional LP-8x4x built-in serial
ports.

The device can also host up to 8 extension cards with 4 serial ports
on each card for a total of 35 ports. However, I don't have
the hardware to test extension cards, so they are not supported, yet.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
   v2..v3
   * no changes (except number 10/16 -> 12/21)

   v0..v2
   * register platform driver instead of platform device
   * use device tree
   * use devm helpers where possible

 .../devicetree/bindings/serial/lp8x4x-serial.txt   |  35 +++++
 arch/arm/boot/dts/pxa27x-lp8x4x.dts                |  25 ++++
 arch/arm/configs/lp8x4x_defconfig                  |   1 +
 drivers/tty/serial/8250/8250_lp8x4x.c              | 162 +++++++++++++++++++++
 drivers/tty/serial/8250/Kconfig                    |  12 ++
 drivers/tty/serial/8250/Makefile                   |   1 +
 6 files changed, 236 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/lp8x4x-serial.txt
 create mode 100644 drivers/tty/serial/8250/8250_lp8x4x.c

diff --git a/Documentation/devicetree/bindings/serial/lp8x4x-serial.txt b/Documentation/devicetree/bindings/serial/lp8x4x-serial.txt
new file mode 100644
index 0000000..eed4ffc
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/lp8x4x-serial.txt
@@ -0,0 +1,35 @@
+UART ports on ICP DAS LP-8x4x
+
+ICP DAS LP-8x4x contains three additional serial ports interfaced via
+Analog Devices ADM213EA chips in addition to 3 serial ports on PXA CPU.
+
+Required properties:
+- compatible : should be "icpdas,uart-lp8x4x"
+
+- reg : should provide 16 byte man IO memory region and 1 byte region for
+	termios
+
+- interrupts : should provide interrupt
+
+- interrupt-parent : should provide a link to interrupt controller either
+		     explicitly and implicitly from a parent node
+
+Examples (from pxa27x-lp8x4x.dts):
+
+		uart@17009050 {
+			compatible = "icpdas,uart-lp8x4x";
+			reg = <0x17009050 0x10
+			       0x17009030 0x02>;
+			interrupt-parent = <&fpga>;
+			interrupts = <13>;
+			status = "okay";
+		};
+
+		uart@17009060 {
+			compatible = "icpdas,uart-lp8x4x";
+			reg = <0x17009060 0x10
+			       0x17009032 0x02>;
+			interrupt-parent = <&fpga>;
+			interrupts = <14>;
+			status = "okay";
+		};
diff --git a/arch/arm/boot/dts/pxa27x-lp8x4x.dts b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
index 78dfd2e..ee0d8b7 100644
--- a/arch/arm/boot/dts/pxa27x-lp8x4x.dts
+++ b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
@@ -155,6 +155,7 @@
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges = <0 5 0x3000000 0x10000>;
+			interrupt-parent = <&fpgairq>;
 
 			rtc@901c {
 				compatible = "ds,rtc-ds1302";
@@ -177,6 +178,30 @@
 				interrupt-controller;
 				status = "okay";
 			};
+
+			uart@9050 {
+				compatible = "icpdas,uart-lp8x4x";
+				reg = <0x9050 0x10
+				       0x9030 0x02>;
+				interrupts = <13>;
+				status = "okay";
+			};
+
+			uart@9060 {
+				compatible = "icpdas,uart-lp8x4x";
+				reg = <0x9060 0x10
+				       0x9032 0x02>;
+				interrupts = <14>;
+				status = "okay";
+			};
+
+			uart@9070 {
+				compatible = "icpdas,uart-lp8x4x";
+				reg = <0x9070 0x10
+				       0x9034 0x02>;
+				interrupts = <15>;
+				status = "okay";
+			};
 		};
 	};
 };
diff --git a/arch/arm/configs/lp8x4x_defconfig b/arch/arm/configs/lp8x4x_defconfig
index 17a4e6f..9116ce1 100644
--- a/arch/arm/configs/lp8x4x_defconfig
+++ b/arch/arm/configs/lp8x4x_defconfig
@@ -112,6 +112,7 @@ CONFIG_SERIAL_8250_EXTENDED=y
 CONFIG_SERIAL_8250_MANY_PORTS=y
 CONFIG_SERIAL_8250_SHARE_IRQ=y
 CONFIG_SERIAL_PXA=y
+CONFIG_SERIAL_8250_LP8X4X=m
 CONFIG_HW_RANDOM=y
 CONFIG_I2C=m
 # CONFIG_I2C_COMPAT is not set
diff --git a/drivers/tty/serial/8250/8250_lp8x4x.c b/drivers/tty/serial/8250/8250_lp8x4x.c
new file mode 100644
index 0000000..ec2f215
--- /dev/null
+++ b/drivers/tty/serial/8250/8250_lp8x4x.c
@@ -0,0 +1,162 @@
+/*  linux/drivers/tty/serial/8250/8250_lp8x4x.c
+ *
+ *  Support for 16550A serial ports on ICP DAS LP-8x4x
+ *
+ *  Copyright (C) 2013 Sergei Ianovich <ynvich@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/serial_8250.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+struct lp8x4x_serial_data {
+	int			line;
+	void			*ios_mem;
+};
+
+static void lp8x4x_serial_set_termios(struct uart_port *port,
+		struct ktermios *termios, struct ktermios *old)
+{
+	unsigned int len;
+	unsigned int baud;
+	struct lp8x4x_serial_data *data = port->private_data;
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
+	iowrite8(len, data->ios_mem);
+
+	serial8250_do_set_termios(port, termios, old);
+}
+
+static struct of_device_id lp8x4x_serial_dt_ids[] = {
+	{ .compatible = "icpdas,uart-lp8x4x", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, lp8x4x_serial_dt_ids);
+
+static int lp8x4x_serial_probe(struct platform_device *pdev)
+{
+	struct uart_8250_port uart = {};
+	struct lp8x4x_serial_data *data;
+	struct resource *mmres, *mires, *irqres;
+	int ret;
+
+	mmres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mires = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	irqres = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!mmres || !mires || !irqres)
+		return -ENODEV;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->ios_mem = devm_ioremap_resource(&pdev->dev, mires);
+	if (!data->ios_mem)
+		return -EFAULT;
+
+	uart.port.iotype = UPIO_MEM;
+	uart.port.mapbase = mmres->start;
+	uart.port.iobase = mmres->start;
+	uart.port.regshift = 1;
+	uart.port.irq = irqres->start;
+	uart.port.flags = UPF_IOREMAP;
+	uart.port.dev = &pdev->dev;
+	uart.port.uartclk = 14745600;
+	uart.port.set_termios = lp8x4x_serial_set_termios;
+	uart.port.private_data = data;
+
+	ret = serial8250_register_8250_port(&uart);
+	if (ret < 0)
+		return ret;
+
+	data->line = ret;
+
+	platform_set_drvdata(pdev, data);
+
+	return 0;
+}
+
+static int lp8x4x_serial_remove(struct platform_device *pdev)
+{
+	struct lp8x4x_serial_data *data = platform_get_drvdata(pdev);
+
+	serial8250_unregister_port(data->line);
+
+	return 0;
+}
+
+static struct platform_driver lp8x4x_serial_driver = {
+	.probe          = lp8x4x_serial_probe,
+	.remove         = lp8x4x_serial_remove,
+
+	.driver		= {
+		.name	= "uart-lp8x4x",
+		.owner	= THIS_MODULE,
+		.of_match_table = lp8x4x_serial_dt_ids,
+	},
+};
+
+module_platform_driver(lp8x4x_serial_driver);
+
+MODULE_AUTHOR("Sergei Ianovich");
+MODULE_DESCRIPTION("8250 serial port module for LP-8x4x");
+MODULE_LICENSE("GPL");
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 81bd7c9..9fb0fbb 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -311,3 +311,15 @@ config SERIAL_PXA
 	  can enable its onboard serial ports by enabling this option.
 
 	  If you choose M here, the module name will be 8250_pxa.
+
+config SERIAL_8250_LP8X4X
+	tristate "Support 16550A ports on ICP DAS LP-8x4x"
+	depends on OF && SERIAL_8250 && SERIAL_8250_MANY_PORTS && ARCH_PXA
+	select LP8X4X_IRQ
+	help
+	  In addition to serial ports on PXA270 SoC, LP-8x4x has 1 dual
+	  RS232/RS485 port, 1 RS485 port and 1 RS232 port.
+
+	  Say N here, unless you plan to run this kernel on a LP-8x4x system.
+
+	  If you choose M here, the module name will be 8250_lp8x4x.
diff --git a/drivers/tty/serial/8250/Makefile b/drivers/tty/serial/8250/Makefile
index b7d1b61..7370bfb 100644
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

