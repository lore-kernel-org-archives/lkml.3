Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab3AKGV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 01:21:59 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:58789 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab3AKGV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 01:21:58 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/4] serial/arc-uart: Don't index with -ve platform_device->id
Date: Fri, 11 Jan 2013 11:50:20 +0530
Message-ID: <1357885223-19243-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357885223-19243-1-git-send-email-vgupta@synopsys.com>
References: <1357885223-19243-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

probe routine could index into port[] with -ve index. The check in
arc_uart_init_one() was too late.

This came to light when trying to port driver to CONFIG_OF, where
bydefault of-core code sets -ve platform dev id and in absence of
DT serial aliases, driver would use the -ve index.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/arc_uart.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 3e0b3fa..8089dc3 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -526,15 +526,11 @@ static struct uart_ops arc_serial_pops = {
 };
 
 static int
-arc_uart_init_one(struct platform_device *pdev, struct arc_uart_port *uart)
+arc_uart_init_one(struct platform_device *pdev, int dev_id)
 {
 	struct resource *res, *res2;
 	unsigned long *plat_data;
-
-	if (pdev->id < 0 || pdev->id >= CONFIG_SERIAL_ARC_NR_PORTS) {
-		dev_err(&pdev->dev, "Wrong uart platform device id.\n");
-		return -ENOENT;
-	}
+	struct arc_uart_port *uart = &arc_uart_ports[dev_id];
 
 	plat_data = ((unsigned long *)(pdev->dev.platform_data));
 	uart->baud = plat_data[0];
@@ -557,7 +553,7 @@ arc_uart_init_one(struct platform_device *pdev, struct arc_uart_port *uart)
 	uart->port.dev = &pdev->dev;
 	uart->port.iotype = UPIO_MEM;
 	uart->port.flags = UPF_BOOT_AUTOCONF;
-	uart->port.line = pdev->id;
+	uart->port.line = dev_id;
 	uart->port.ops = &arc_serial_pops;
 
 	uart->port.uartclk = plat_data[1];
@@ -657,9 +653,14 @@ static struct __initdata console arc_early_serial_console = {
 
 static int arc_serial_probe_earlyprintk(struct platform_device *pdev)
 {
-	arc_early_serial_console.index = pdev->id;
+	int dev_id = pdev->id < 0 ? 0 : pdev->id;
+	int rc;
 
-	arc_uart_init_one(pdev, &arc_uart_ports[pdev->id]);
+	arc_early_serial_console.index = dev_id;
+
+	rc = arc_uart_init_one(pdev, dev_id);
+	if (rc)
+		panic("early console init failed\n");
 
 	arc_serial_console_setup(&arc_early_serial_console, NULL);
 
@@ -675,18 +676,18 @@ static int arc_serial_probe_earlyprintk(struct platform_device *pdev)
 
 static int arc_serial_probe(struct platform_device *pdev)
 {
-	struct arc_uart_port *uart;
-	int rc;
+	int rc, dev_id;
 
 	if (is_early_platform_device(pdev))
 		return arc_serial_probe_earlyprintk(pdev);
 
-	uart = &arc_uart_ports[pdev->id];
-	rc = arc_uart_init_one(pdev, uart);
+	dev_id = pdev->id < 0 ? 0 : pdev->id;
+	rc = arc_uart_init_one(pdev, dev_id);
 	if (rc)
 		return rc;
 
-	return uart_add_one_port(&arc_uart_driver, &uart->port);
+	rc = uart_add_one_port(&arc_uart_driver, &arc_uart_ports[dev_id].port);
+	return rc;
 }
 
 static int arc_serial_remove(struct platform_device *pdev)
-- 
1.7.4.1

