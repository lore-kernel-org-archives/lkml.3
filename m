Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbaJHUBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:01:40 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:45671 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbaJHT6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:58:19 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] 8250/fintek: Use rs485 handler from serial_core
Date: Wed,  8 Oct 2014 21:57:31 +0200
Message-Id: <1412798258-23655-6-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to remove the handler for rs485 ioctls on serial_8250, all the
drivers must use the implementation on serial_core.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/tty/serial/8250/8250_fintek.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_fintek.c b/drivers/tty/serial/8250/8250_fintek.c
index 1bb28cb..1e6899bc 100644
--- a/drivers/tty/serial/8250/8250_fintek.c
+++ b/drivers/tty/serial/8250/8250_fintek.c
@@ -89,11 +89,11 @@ static int fintek_8250_check_id(void)
 	return 0;
 }
 
-static int fintek_8250_rs4850_config(struct uart_8250_port *uart,
+static int fintek_8250_rs485_config(struct uart_port *port,
 			      struct serial_rs485 *rs485)
 {
 	uint8_t config = 0;
-	int index = fintek_8250_get_index(uart->port.iobase);
+	int index = fintek_8250_get_index(port->iobase);
 
 	if (index < 0)
 		return -EINVAL;
@@ -134,6 +134,8 @@ static int fintek_8250_rs4850_config(struct uart_8250_port *uart,
 	outb(config, DATA_PORT);
 	fintek_8250_exit_key();
 
+	port->rs485 = *rs485;
+
 	return 0;
 }
 
@@ -166,7 +168,7 @@ fintek_8250_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	uart.port.irq = pnp_irq(dev, 0);
 	uart.port.iobase = pnp_port_start(dev, 0);
 	uart.port.iotype = UPIO_PORT;
-	uart.rs485_config = fintek_8250_rs4850_config;
+	uart.port.rs485_config = fintek_8250_rs485_config;
 
 	uart.port.flags |= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF;
 	if (pnp_irq_flags(dev, 0) & IORESOURCE_IRQ_SHAREABLE)
-- 
2.1.1

