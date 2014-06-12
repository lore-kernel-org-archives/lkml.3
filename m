Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbaFLKd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:33:27 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:44049 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238AbaFLKdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:33:20 -0400
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
Subject: [PATCH 6/9] serial/arc: remove last remanants of platform data
Date: Thu, 12 Jun 2014 16:01:36 +0530
Message-ID: <1402569099-9900-7-git-send-email-vgupta@synopsys.com>
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
 drivers/tty/serial/arc_uart.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 2ffaf099691a..dc3d5db37dc4 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -37,8 +37,8 @@
 #include <linux/tty_flip.h>
 #include <linux/serial_core.h>
 #include <linux/io.h>
-#include <linux/of.h>
-#include <linux/of_platform.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
 
 /*************************************
  * ARC UART Hardware Specs
@@ -499,11 +499,9 @@ static struct uart_ops arc_serial_pops = {
 static int
 arc_uart_init_one(struct platform_device *pdev, int dev_id)
 {
-	struct resource *res, *res2;
+	struct device_node *np = pdev->dev.of_node;
 	struct arc_uart_port *uart = &arc_uart_ports[dev_id];
 	struct uart_port *port = &uart->port;
-
-	struct device_node *np = pdev->dev.of_node;
 	u32 val;
 
 	if (of_property_read_u32(np, "clock-frequency", &val)) {
@@ -518,21 +516,13 @@ arc_uart_init_one(struct platform_device *pdev, int dev_id)
 	}
 	uart->baud = val;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
-	res2 = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res2)
-		return -ENODEV;
-
-	port->mapbase = res->start;
-	port->membase = ioremap_nocache(res->start, resource_size(res));
+	port->membase = of_iomap(np, 0);
 	if (!port->membase)
 		/* No point of dev_err since UART itself is hosed here */
 		return -ENXIO;
 
-	port->irq = res2->start;
+	port->irq = irq_of_parse_and_map(np, 0);
+
 	port->dev = &pdev->dev;
 	port->iotype = UPIO_MEM;
 	port->flags = UPF_BOOT_AUTOCONF;
-- 
1.8.3.2

