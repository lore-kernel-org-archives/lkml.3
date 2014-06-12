Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbaFLKis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:38:48 -0400
Received: from smtprelay.synopsys.com ([198.182.44.111]:44107 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932907AbaFLKiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:38:46 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Bolle <pebolle@tiscali.nl>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <Francois.Bedard@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 7/9] serial/arc: inline the probe helper
Date: Thu, 12 Jun 2014 16:01:37 +0530
Message-ID: <1402569099-9900-8-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
References: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 drivers/tty/serial/arc_uart.c | 90 +++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 50 deletions(-)

diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index dc3d5db37dc4..435de4f2af3b 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -496,50 +496,6 @@ static struct uart_ops arc_serial_pops = {
 #endif
 };
 
-static int
-arc_uart_init_one(struct platform_device *pdev, int dev_id)
-{
-	struct device_node *np = pdev->dev.of_node;
-	struct arc_uart_port *uart = &arc_uart_ports[dev_id];
-	struct uart_port *port = &uart->port;
-	u32 val;
-
-	if (of_property_read_u32(np, "clock-frequency", &val)) {
-		dev_err(&pdev->dev, "clock-frequency property NOTset\n");
-		return -EINVAL;
-	}
-	port->uartclk = val;
-
-	if (of_property_read_u32(np, "current-speed", &val)) {
-		dev_err(&pdev->dev, "current-speed property NOT set\n");
-		return -EINVAL;
-	}
-	uart->baud = val;
-
-	port->membase = of_iomap(np, 0);
-	if (!port->membase)
-		/* No point of dev_err since UART itself is hosed here */
-		return -ENXIO;
-
-	port->irq = irq_of_parse_and_map(np, 0);
-
-	port->dev = &pdev->dev;
-	port->iotype = UPIO_MEM;
-	port->flags = UPF_BOOT_AUTOCONF;
-	port->line = dev_id;
-	port->ops = &arc_serial_pops;
-
-	port->fifosize = ARC_UART_TX_FIFO_SIZE;
-
-	/*
-	 * uart_insert_char( ) uses it in decideding whether to ignore a
-	 * char or not. Explicitly setting it here, removes the subtelty
-	 */
-	port->ignore_status_mask = 0;
-
-	return 0;
-}
-
 #ifdef CONFIG_SERIAL_ARC_CONSOLE
 
 static int arc_serial_console_setup(struct console *co, char *options)
@@ -628,8 +584,11 @@ EARLYCON_DECLARE(arc_uart, arc_early_console_setup);
 
 static int arc_serial_probe(struct platform_device *pdev)
 {
-	int rc, dev_id;
 	struct device_node *np = pdev->dev.of_node;
+	struct arc_uart_port *uart;
+	struct uart_port *port;
+	int dev_id;
+	u32 val;
 
 	/* no device tree device */
 	if (!np)
@@ -639,12 +598,43 @@ static int arc_serial_probe(struct platform_device *pdev)
 	if (dev_id < 0)
 		dev_id = 0;
 
-	rc = arc_uart_init_one(pdev, dev_id);
-	if (rc)
-		return rc;
+	uart = &arc_uart_ports[dev_id];
+	port = &uart->port;
+
+	if (of_property_read_u32(np, "clock-frequency", &val)) {
+		dev_err(&pdev->dev, "clock-frequency property NOTset\n");
+		return -EINVAL;
+	}
+	port->uartclk = val;
+
+	if (of_property_read_u32(np, "current-speed", &val)) {
+		dev_err(&pdev->dev, "current-speed property NOT set\n");
+		return -EINVAL;
+	}
+	uart->baud = val;
+
+	port->membase = of_iomap(np, 0);
+	if (!port->membase)
+		/* No point of dev_err since UART itself is hosed here */
+		return -ENXIO;
+
+	port->irq = irq_of_parse_and_map(np, 0);
+
+	port->dev = &pdev->dev;
+	port->iotype = UPIO_MEM;
+	port->flags = UPF_BOOT_AUTOCONF;
+	port->line = dev_id;
+	port->ops = &arc_serial_pops;
+
+	port->fifosize = ARC_UART_TX_FIFO_SIZE;
+
+	/*
+	 * uart_insert_char( ) uses it in decideding whether to ignore a
+	 * char or not. Explicitly setting it here, removes the subtelty
+	 */
+	port->ignore_status_mask = 0;
 
-	rc = uart_add_one_port(&arc_uart_driver, &arc_uart_ports[dev_id].port);
-	return rc;
+	return uart_add_one_port(&arc_uart_driver, &arc_uart_ports[dev_id].port);
 }
 
 static int arc_serial_remove(struct platform_device *pdev)
-- 
1.8.3.2

