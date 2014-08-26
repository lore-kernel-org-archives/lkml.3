Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbaHZDFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 23:05:12 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50011 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbaHZDFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 23:05:10 -0400
From: Scott Yuan <scottzero0@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Scott Yuan <scottzero0@gmail.com>
Subject: [PATCH] 8250: serial device file is out of order
Date: Tue, 26 Aug 2014 11:04:57 +0800
Message-Id: <1409022297-15555-1-git-send-email-scottzero0@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86 architecture, the configuration of serial device maybe get from ACPI
DSDT, but the order of DSDT is not mandatory, result as array serial8250_ports
is out of order. This situation is more obvious in multiple serial port
mainboard. Sort it by unique id that in DSDT will fix it.

Signed-off-by: Scott Yuan <scottzero0@gmail.com>
---
 drivers/pnp/pnpacpi/core.c          |  1 +
 drivers/tty/serial/8250/8250_core.c | 40 ++++++++++++++++++++++++++++++++++++-
 drivers/tty/serial/8250/8250_pnp.c  | 12 +++++++++++
 include/linux/pnp.h                 |  1 +
 include/linux/serial_8250.h         |  2 ++
 5 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index a5c6cb7..84b518e 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -254,6 +254,7 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
 		return -ENOMEM;
 
 	dev->data = device;
+	dev->is_acpi = 1;
 	/* .enabled means the device can decode the resources */
 	dev->active = device->status.enabled;
 	if (acpi_has_method(device->handle, "_SRS"))
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 7a91c6d..0e5ece5 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -3221,6 +3221,41 @@ static struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port *
 	return NULL;
 }
 
+static struct uart_8250_port *
+serial8250_find_match_sorted_port(struct uart_port *port)
+{
+	int i, j;
+	struct uart_8250_port *uart;
+
+	uart = container_of(port, struct uart_8250_port, port);
+
+	/*
+	 * We need sorted array serial8250_ports, it is sort by ACPI
+	 * device unique id, so find an apropriate position to insert.
+	 */
+	for (i = 0; i < nr_uarts; i++) {
+		if (serial8250_ports[i].uid == 0 ||
+			uart->uid < serial8250_ports[i].uid)
+			break;
+	}
+
+	/*
+	 * If current uid that in serial8250_ports is big than port uid,
+	 * then move 8250 port data.
+	 */
+	if (i < nr_uarts - 1 &&
+		uart->uid < serial8250_ports[i].uid) {
+		memmove(&serial8250_ports[i+1], &serial8250_ports[i],
+			(nr_uarts - i - 1) * sizeof(struct uart_8250_port));
+
+		/* modify port.line, since data moved */
+		for (j = i + 1; j < nr_uarts; j++)
+			serial8250_ports[j].port.line += 1;
+	}
+	serial8250_ports[i].uid = uart->uid;
+	return &serial8250_ports[i];
+}
+
 /**
  *	serial8250_register_8250_port - register a serial port
  *	@up: serial port template
@@ -3244,7 +3279,10 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 
 	mutex_lock(&serial_mutex);
 
-	uart = serial8250_find_match_or_unused(&up->port);
+	if (up->is_acpi)
+		uart = serial8250_find_match_sorted_port(&up->port);
+	else
+		uart = serial8250_find_match_or_unused(&up->port);
 	if (uart && uart->port.type != PORT_8250_CIR) {
 		if (uart->port.dev)
 			uart_remove_one_port(&serial8250_reg, &uart->port);
diff --git a/drivers/tty/serial/8250/8250_pnp.c b/drivers/tty/serial/8250/8250_pnp.c
index 682a2fb..c880ed3 100644
--- a/drivers/tty/serial/8250/8250_pnp.c
+++ b/drivers/tty/serial/8250/8250_pnp.c
@@ -15,6 +15,8 @@
 #include <linux/pci.h>
 #include <linux/pnp.h>
 #include <linux/string.h>
+#include <acpi/acpi.h>
+#include <acpi/acpi_bus.h>
 #include <linux/kernel.h>
 #include <linux/serial_core.h>
 #include <linux/bitops.h>
@@ -427,6 +429,8 @@ static int
 serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 {
 	struct uart_8250_port uart;
+	struct acpi_device *acpi_dev;
+	char *serial_uid;
 	int ret, line, flags = dev_id->driver_data;
 
 	if (flags & UNKNOWN_DEV) {
@@ -451,6 +455,14 @@ serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	} else
 		return -ENODEV;
 
+	if (dev->is_acpi) {
+		acpi_dev = dev->data;
+		serial_uid = acpi_dev->pnp.unique_id;
+		uart.is_acpi = 1;
+		if (kstrtoint(serial_uid, 10, &uart.uid))
+			return -EINVAL;
+	}
+
 #ifdef SERIAL_DEBUG_PNP
 	printk(KERN_DEBUG
 		"Setup PNP port: port %x, mem 0x%lx, irq %d, type %d\n",
diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index 195aafc..d745f14 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -245,6 +245,7 @@ struct pnp_dev {
 	u64 dma_mask;
 	unsigned int number;		/* used as an index, must be unique */
 	int status;
+	unsigned char is_acpi;		/* is acpi device */
 
 	struct list_head global_list;	/* node in global list of devices */
 	struct list_head protocol_list;	/* node in list of device's protocol */
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index af47a8a..8f1e1bd 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -74,7 +74,9 @@ struct uart_8250_port {
 	struct list_head	list;		/* ports on this IRQ */
 	unsigned short		capabilities;	/* port capabilities */
 	unsigned short		bugs;		/* port bugs */
+	int			uid;		/* ACPI device unique id */
 	unsigned int		tx_loadsz;	/* transmit fifo load size */
+	unsigned char		is_acpi;	/* is acpi device */
 	unsigned char		acr;
 	unsigned char		ier;
 	unsigned char		lcr;
-- 
1.9.1

