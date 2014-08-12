Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaHLOMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:12:34 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:36686 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbaHLOMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:12:31 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, gregkh@linuxfoundation.org, jslaby@suse.cz,
        grant.likely@linaro.org, matthias.bgg@gmail.com, alan@linux.intel.com,
        varkabhadram@gmail.com, tklauser@distanz.ch, heiko@sntech.de,
        yingjoe.chen@gmail.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH v4 1/2] tty: serial: 8250: Add Mediatek UART driver
Date: Tue, 12 Aug 2014 16:12:16 +0200
Message-Id: <1407852737-17265-2-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407852737-17265-1-git-send-email-matthias.bgg@gmail.com>
References: <1407852737-17265-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device has a highspeed register which influences the calcualtion of the
divisor. The chip lacks support for some baudrates. When requested, we set the
divisor to the next smaller baudrate and adjust the c_cflag accordingly.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 drivers/tty/serial/8250/8250_mtk.c |  294 ++++++++++++++++++++++++++++++++++++
 drivers/tty/serial/8250/Kconfig    |    7 +
 drivers/tty/serial/8250/Makefile   |    1 +
 3 files changed, 302 insertions(+)
 create mode 100644 drivers/tty/serial/8250/8250_mtk.c

diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
new file mode 100644
index 0000000..1c4b4bf
--- /dev/null
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -0,0 +1,294 @@
+/*
+ * Mediatek 8250 driver.
+ *
+ * Copyright (c) 2014 MundoReader S.L.
+ * Author: Matthias Brugger <matthias.bgg@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/serial_8250.h>
+#include <linux/serial_reg.h>
+
+#include "8250.h"
+
+#define UART_MTK_HIGHS		0x09	/* Highspeed register */
+#define UART_MTK_SAMPLE_COUNT	0x0a	/* Sample count register */
+#define UART_MTK_SAMPLE_POINT	0x0b	/* Sample point register */
+#define MTK_UART_RATE_FIX	0x0d	/* UART Rate Fix Register */
+
+struct mtk8250_data {
+	int			line;
+	struct clk		*clk;
+};
+
+static void
+mtk8250_set_termios(struct uart_port *port, struct ktermios *termios,
+			struct ktermios *old)
+{
+	unsigned long flags;
+	unsigned int baud, quot;
+
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+
+	serial8250_do_set_termios(port, termios, old);
+
+	/*
+	 * Mediatek UARTs use an extra highspeed register (UART_MTK_HIGHS)
+	 *
+	 * We need to recalcualte the quot register, as the claculation depends
+	 * on the vaule in the highspeed register.
+	 *
+	 * Some baudrates are not supported by the chip, so we use the next
+	 * lower rate supported and update termios c_flag.
+	 *
+	 * If highspeed register is set to 3, we need to specify sample count
+	 * and sample point to increase accuracy. If not, we reset the
+	 * registers to their default values.
+	 */
+	baud = uart_get_baud_rate(port, termios, old,
+				  port->uartclk / 16 / 0xffff,
+				  port->uartclk / 16);
+
+	if (baud <= 115200) {
+		serial_port_out(port, UART_MTK_HIGHS, 0x0);
+		quot = uart_get_divisor(port, baud);
+	} else if (baud <= 576000) {
+		serial_port_out(port, UART_MTK_HIGHS, 0x2);
+
+		/* Set to next lower baudrate supported */
+		if ((baud == 500000) || (baud == 576000))
+			baud = 460800;
+		quot = DIV_ROUND_CLOSEST(port->uartclk, 4 * baud);
+	} else {
+		serial_port_out(port, UART_MTK_HIGHS, 0x3);
+
+		/* Set to highest baudrate supported */
+		if (baud >= 1152000)
+			baud = 921600;
+		quot = DIV_ROUND_CLOSEST(port->uartclk, 256 * baud);
+	}
+
+	/*
+	 * Ok, we're now changing the port state.  Do it with
+	 * interrupts disabled.
+	 */
+	spin_lock_irqsave(&port->lock, flags);
+
+	/* set DLAB we have cval saved in up->lcr from the call to the core */
+	serial_port_out(port, UART_LCR, up->lcr | UART_LCR_DLAB);
+	serial_dl_write(up, quot);
+
+	/* reset DLAB */
+	serial_port_out(port, UART_LCR, up->lcr);
+
+	if (baud > 460800) {
+		unsigned int tmp;
+
+		tmp = DIV_ROUND_CLOSEST(port->uartclk, quot * baud);
+		serial_port_out(port, UART_MTK_SAMPLE_COUNT, tmp - 1);
+		serial_port_out(port, UART_MTK_SAMPLE_POINT,
+					(tmp - 2) >> 1);
+	} else {
+		serial_port_out(port, UART_MTK_SAMPLE_COUNT, 0x00);
+		serial_port_out(port, UART_MTK_SAMPLE_POINT, 0xff);
+	}
+
+	spin_unlock_irqrestore(&port->lock, flags);
+	/* Don't rewrite B0 */
+	if (tty_termios_baud_rate(termios))
+		tty_termios_encode_baud_rate(termios, baud, baud);
+}
+
+static void
+mtk8250_do_pm(struct uart_port *port, unsigned int state, unsigned int old)
+{
+	if (!state)
+		pm_runtime_get_sync(port->dev);
+
+	serial8250_do_pm(port, state, old);
+
+	if (state)
+		pm_runtime_put_sync_suspend(port->dev);
+}
+
+static int mtk8250_probe_of(struct platform_device *pdev, struct uart_port *p,
+			   struct mtk8250_data *data)
+{
+	int err;
+	struct device_node *np = pdev->dev.of_node;
+
+	data->clk = of_clk_get(np, 0);
+	if (IS_ERR(data->clk)) {
+		dev_warn(&pdev->dev, "Can't get timer clock\n");
+		return PTR_ERR(data->clk);
+	}
+
+	err = clk_prepare_enable(data->clk);
+	if (err) {
+		dev_warn(&pdev->dev, "Can't prepare clock\n");
+		clk_put(data->clk);
+		return err;
+	}
+	p->uartclk = clk_get_rate(data->clk);
+
+	return 0;
+}
+
+static int mtk8250_probe(struct platform_device *pdev)
+{
+	struct uart_8250_port uart = {};
+	struct resource *regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct resource *irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	struct mtk8250_data *data;
+	int err;
+
+	if (!regs || !irq) {
+		dev_err(&pdev->dev, "no registers/irq defined\n");
+		return -EINVAL;
+	}
+
+	uart.port.membase = devm_ioremap(&pdev->dev, regs->start,
+					 resource_size(regs));
+	if (!uart.port.membase)
+		return -ENOMEM;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	if (pdev->dev.of_node) {
+		err = mtk8250_probe_of(pdev, &uart.port, data);
+		if (err)
+			return err;
+	} else
+		return -ENODEV;
+
+	spin_lock_init(&uart.port.lock);
+	uart.port.mapbase = regs->start;
+	uart.port.irq = irq->start;
+	uart.port.pm = mtk8250_do_pm;
+	uart.port.type = PORT_16550;
+	uart.port.flags = UPF_BOOT_AUTOCONF | UPF_FIXED_PORT;
+	uart.port.dev = &pdev->dev;
+	uart.port.iotype = UPIO_MEM32;
+	uart.port.regshift = 2;
+	uart.port.private_data = data;
+	uart.port.set_termios = mtk8250_set_termios;
+
+	/* Disable Rate Fix function */
+	writel(0x0, uart.port.membase +
+			(MTK_UART_RATE_FIX << uart.port.regshift));
+
+	data->line = serial8250_register_8250_port(&uart);
+	if (data->line < 0)
+		return data->line;
+
+	platform_set_drvdata(pdev, data);
+
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
+	return 0;
+}
+
+static int mtk8250_remove(struct platform_device *pdev)
+{
+	struct mtk8250_data *data = platform_get_drvdata(pdev);
+
+	pm_runtime_get_sync(&pdev->dev);
+
+	serial8250_unregister_port(data->line);
+	if (!IS_ERR(data->clk)) {
+		clk_disable_unprepare(data->clk);
+		clk_put(data->clk);
+	}
+
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int mtk8250_suspend(struct device *dev)
+{
+	struct mtk8250_data *data = dev_get_drvdata(dev);
+
+	serial8250_suspend_port(data->line);
+
+	return 0;
+}
+
+static int mtk8250_resume(struct device *dev)
+{
+	struct mtk8250_data *data = dev_get_drvdata(dev);
+
+	serial8250_resume_port(data->line);
+
+	return 0;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+#ifdef CONFIG_PM_RUNTIME
+static int mtk8250_runtime_suspend(struct device *dev)
+{
+	struct mtk8250_data *data = dev_get_drvdata(dev);
+
+	if (!IS_ERR(data->clk))
+		clk_disable_unprepare(data->clk);
+
+	return 0;
+}
+
+static int mtk8250_runtime_resume(struct device *dev)
+{
+	struct mtk8250_data *data = dev_get_drvdata(dev);
+
+	if (!IS_ERR(data->clk))
+		clk_prepare_enable(data->clk);
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops mtk8250_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(mtk8250_suspend, mtk8250_resume)
+	SET_RUNTIME_PM_OPS(mtk8250_runtime_suspend, mtk8250_runtime_resume,
+				NULL)
+};
+
+static const struct of_device_id mtk8250_of_match[] = {
+	{ .compatible = "mediatek,mt6577-uart" },
+	{ /* Sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, mtk8250_of_match);
+
+static struct platform_driver mtk8250_platform_driver = {
+	.driver = {
+		.name		= "mt6577-uart",
+		.pm		= &mtk8250_pm_ops,
+		.of_match_table	= mtk8250_of_match,
+	},
+	.probe			= mtk8250_probe,
+	.remove			= mtk8250_remove,
+};
+module_platform_driver(mtk8250_platform_driver);
+
+MODULE_AUTHOR("Matthias Brugger");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Mediatek 8250 serial port driver");
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 349ee59..fac34aa 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -298,3 +298,10 @@ config SERIAL_8250_RT288X
 	  If you have a Ralink RT288x/RT305x SoC based board and want to use the
 	  serial port, say Y to this option. The driver can handle up to 2 serial
 	  ports. If unsure, say N.
+
+config SERIAL_8250_MT6577
+	bool "Mediatek serial port support"
+	depends on SERIAL_8250 && ARCH_MEDIATEK
+	help
+	  If you have a Mediatek based board and want to use the
+	  serial port, say Y to this option. If unsure, say N.
diff --git a/drivers/tty/serial/8250/Makefile b/drivers/tty/serial/8250/Makefile
index 36d68d0..6dcb46b 100644
--- a/drivers/tty/serial/8250/Makefile
+++ b/drivers/tty/serial/8250/Makefile
@@ -20,3 +20,4 @@ obj-$(CONFIG_SERIAL_8250_HUB6)		+= 8250_hub6.o
 obj-$(CONFIG_SERIAL_8250_FSL)		+= 8250_fsl.o
 obj-$(CONFIG_SERIAL_8250_DW)		+= 8250_dw.o
 obj-$(CONFIG_SERIAL_8250_EM)		+= 8250_em.o
+obj-$(CONFIG_SERIAL_8250_MT6577)	+= 8250_mtk.o
-- 
1.7.9.5

