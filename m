Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaG2Q1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:27:33 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:38601 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaG2Q13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:27:29 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Michael Welling <mwelling@ieee.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Joe Schultz <jschultz@xes-inc.com>, Ingo Molnar <mingo@elte.hu>,
        Doug Anderson <dianders@chromium.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 2/2] serial: Add support for Fintek F81216A LPC to 4 UART
Date: Tue, 29 Jul 2014 18:27:22 +0200
Message-Id: <1406651242-20689-2-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406651242-20689-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1406651242-20689-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lets you set the RS485 cappabilites of the device through
TIOCSRS485 and TIOCGRS485 as defined on Documentation/serial/serial-rs485.txt

In order to probe the device, the PNP id and the device id is used.

There is only one device per system, therefore a static mutex is used to
avoid race conditions due to the indirect addressing.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/tty/serial/8250/8250_fintek.c | 231 ++++++++++++++++++++++++++++++++++
 drivers/tty/serial/8250/Kconfig       |   9 ++
 drivers/tty/serial/8250/Makefile      |   1 +
 3 files changed, 241 insertions(+)
 create mode 100644 drivers/tty/serial/8250/8250_fintek.c

diff --git a/drivers/tty/serial/8250/8250_fintek.c b/drivers/tty/serial/8250/8250_fintek.c
new file mode 100644
index 0000000..97e7349
--- /dev/null
+++ b/drivers/tty/serial/8250/8250_fintek.c
@@ -0,0 +1,231 @@
+/*
+ *  Probe for F81216A LPC to 4 UART
+ *
+ *  Based on drivers/tty/serial/8250_pnp.c, by Russell King, et al
+ *
+ *  Copyright (C) 2014 Ricardo Ribalda, Qtechnology A/S
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License.
+ */
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/pnp.h>
+#include <linux/kernel.h>
+#include <linux/serial_core.h>
+#include  "8250.h"
+
+#define ADDR_PORT 0x4E
+#define DATA_PORT 0x4F
+#define ENTRY_KEY 0x77
+#define CHIP_ID1  0x20
+#define CHIP_ID1_VAL 0x02
+#define CHIP_ID2  0x21
+#define CHIP_ID2_VAL 0x16
+#define VENDOR_ID1 0x23
+#define VENDOR_ID1_VAL 0x19
+#define VENDOR_ID2 0x24
+#define VENDOR_ID2_VAL 0x34
+#define LDN 0x7
+
+#define RS485  0xF0
+#define RTS_INVERT BIT(5)
+#define RS485_URA BIT(4)
+#define RXW4C_IRA BIT(3)
+#define TXW4C_IRA BIT(3)
+
+static DEFINE_MUTEX(fintek_mutex);
+
+static int fintek_8250_get_index(resource_size_t base_addr)
+{
+	resource_size_t base[] = {0x3f8, 0x2f8, 0x3e8, 0x2e8};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(base); i++)
+		if (base_addr == base[i])
+			return i;
+
+	return -ENODEV;
+}
+
+static int fintek_8250_check_id(void)
+{
+
+	outb(CHIP_ID1, ADDR_PORT);
+	if (inb(DATA_PORT) != CHIP_ID1_VAL)
+		return -ENODEV;
+
+	outb(CHIP_ID2, ADDR_PORT);
+	if (inb(DATA_PORT) != CHIP_ID2_VAL)
+		return -ENODEV;
+
+	outb(VENDOR_ID1, ADDR_PORT);
+	if (inb(DATA_PORT) != VENDOR_ID1_VAL)
+		return -ENODEV;
+
+	outb(VENDOR_ID2, ADDR_PORT);
+	if (inb(DATA_PORT) != VENDOR_ID2_VAL)
+		return -ENODEV;
+
+	return 0;
+}
+
+int fintek_8250_rs4850_config(struct uart_8250_port *uart,
+			      struct serial_rs485 *rs485)
+{
+	uint8_t config = 0;
+	int index = fintek_8250_get_index(uart->port.iobase);
+
+	if (index < 0)
+		return -EINVAL;
+
+	if (!rs485->flags & SER_RS485_ENABLED)
+		memset(rs485, 0, sizeof(*rs485));
+	else
+		memset(rs485->padding, 0, sizeof(rs485->padding));
+
+	rs485->flags &= SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND |
+			SER_RS485_RTS_AFTER_SEND;
+
+	if (rs485->delay_rts_before_send) {
+		rs485->delay_rts_before_send = 1;
+		config |= TXW4C_IRA;
+	}
+
+	if (rs485->delay_rts_after_send) {
+		rs485->delay_rts_after_send = 1;
+		config |= RXW4C_IRA;
+	}
+
+	if ((!!(rs485->flags & SER_RS485_RTS_ON_SEND)) ==
+			(!!(rs485->flags & SER_RS485_RTS_AFTER_SEND)))
+		rs485->flags &= SER_RS485_ENABLED;
+	else
+		config |= RS485_URA;
+
+	if (rs485->flags & SER_RS485_RTS_ON_SEND)
+		config |= RTS_INVERT;
+
+	mutex_lock(&fintek_mutex);
+	outb(LDN, ADDR_PORT);
+	outb(index, DATA_PORT);
+	outb(RS485, ADDR_PORT);
+	outb(config, DATA_PORT);
+	mutex_unlock(&fintek_mutex);
+
+	return 0;
+}
+
+static int
+fintek_8250_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
+{
+	int line;
+	struct uart_8250_port uart;
+	int ret;
+
+	if (!pnp_port_valid(dev, 0))
+		return -ENODEV;
+
+	if (fintek_8250_get_index(pnp_port_start(dev, 0)) < 0)
+		return -ENODEV;
+
+	/* Enable configuration registers*/
+	mutex_lock(&fintek_mutex);
+	outb(ENTRY_KEY, ADDR_PORT);
+	outb(ENTRY_KEY, ADDR_PORT);
+
+	/*Check ID*/
+	ret = fintek_8250_check_id();
+	mutex_unlock(&fintek_mutex);
+	if (ret)
+		return ret;
+
+	memset(&uart, 0, sizeof(uart));
+	if (!pnp_irq_valid(dev, 0))
+		return -ENODEV;
+	uart.port.irq = pnp_irq(dev, 0);
+	uart.port.iobase = pnp_port_start(dev, 0);
+	uart.port.iotype = UPIO_PORT;
+	uart.rs485_config = fintek_8250_rs4850_config;
+
+	uart.port.flags |= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF;
+	if (pnp_irq_flags(dev, 0) & IORESOURCE_IRQ_SHAREABLE)
+		uart.port.flags |= UPF_SHARE_IRQ;
+	uart.port.uartclk = 1843200;
+	uart.port.dev = &dev->dev;
+
+	line = serial8250_register_8250_port(&uart);
+	if (line < 0)
+		return -ENODEV;
+
+	pnp_set_drvdata(dev, (void *)((long)line + 1));
+	return 0;
+}
+
+static void fintek_8250_remove(struct pnp_dev *dev)
+{
+	long line = (long)pnp_get_drvdata(dev);
+
+	if (line)
+		serial8250_unregister_port(line - 1);
+}
+
+#ifdef CONFIG_PM
+static int fintek_8250_suspend(struct pnp_dev *dev, pm_message_t state)
+{
+	long line = (long)pnp_get_drvdata(dev);
+
+	if (!line)
+		return -ENODEV;
+	serial8250_suspend_port(line - 1);
+	return 0;
+}
+
+static int fintek_8250_resume(struct pnp_dev *dev)
+{
+	long line = (long)pnp_get_drvdata(dev);
+
+	if (!line)
+		return -ENODEV;
+	serial8250_resume_port(line - 1);
+	return 0;
+}
+#else
+#define fintek_8250_suspend NULL
+#define fintek_8250_resume NULL
+#endif /* CONFIG_PM */
+
+static const struct pnp_device_id fintek_dev_table[] = {
+	/* Qtechnology Panel PC / IO1000 */
+	{ "PNP0501"},
+	{}
+};
+
+MODULE_DEVICE_TABLE(pnp, fintek_dev_table);
+
+static struct pnp_driver fintek_8250_driver = {
+	.name		= "8250_fintek",
+	.probe		= fintek_8250_probe,
+	.remove		= fintek_8250_remove,
+	.suspend	= fintek_8250_suspend,
+	.resume		= fintek_8250_resume,
+	.id_table	= fintek_dev_table,
+};
+
+int fintek_8250_init(void)
+{
+	return pnp_register_driver(&fintek_8250_driver);
+}
+module_init(fintek_8250_init);
+
+void fintek_8250_exit(void)
+{
+	pnp_unregister_driver(&fintek_8250_driver);
+}
+module_exit(fintek_8250_exit);
+
+MODULE_DESCRIPTION("Fintek F812164 module");
+MODULE_AUTHOR("Ricardo Ribalda <ricardo.ribalda@gmail.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 349ee59..8b5c40a 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -298,3 +298,12 @@ config SERIAL_8250_RT288X
 	  If you have a Ralink RT288x/RT305x SoC based board and want to use the
 	  serial port, say Y to this option. The driver can handle up to 2 serial
 	  ports. If unsure, say N.
+
+config SERIAL_8250_FINTEK
+	tristate "Support for Fintek F81216A LPC to 4 UART"
+	depends on SERIAL_8250 && PNP
+	help
+	  Selecting this option will add support for the Fintek F81216A
+	  LPC to 4 UART. This device has some RS485 functionality not available
+	  through the PNP driver. If unsure, say N.
+
diff --git a/drivers/tty/serial/8250/Makefile b/drivers/tty/serial/8250/Makefile
index 36d68d0..e08407d 100644
--- a/drivers/tty/serial/8250/Makefile
+++ b/drivers/tty/serial/8250/Makefile
@@ -20,3 +20,4 @@ obj-$(CONFIG_SERIAL_8250_HUB6)		+= 8250_hub6.o
 obj-$(CONFIG_SERIAL_8250_FSL)		+= 8250_fsl.o
 obj-$(CONFIG_SERIAL_8250_DW)		+= 8250_dw.o
 obj-$(CONFIG_SERIAL_8250_EM)		+= 8250_em.o
+obj-$(CONFIG_SERIAL_8250_FINTEK)	+= 8250_fintek.o
-- 
2.0.1

