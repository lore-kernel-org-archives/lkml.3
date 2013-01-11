Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab3AKGVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 01:21:14 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:55437 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab3AKGVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 01:21:11 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3/4] serial/arc-uart: platform_data order changed
Date: Fri, 11 Jan 2013 11:50:22 +0530
Message-ID: <1357885223-19243-4-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357885223-19243-1-git-send-email-vgupta@synopsys.com>
References: <1357885223-19243-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* is_emulated is now 1st element, rather than last
* also tucked all platform data refs together

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/arc_uart.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 9de26ba..2db6410 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -533,7 +533,12 @@ arc_uart_init_one(struct platform_device *pdev, int dev_id)
 	struct arc_uart_port *uart = &arc_uart_ports[dev_id];
 
 	plat_data = ((unsigned long *)(pdev->dev.platform_data));
-	uart->baud = plat_data[0];
+	if (!plat_data)
+		return -ENODEV;
+
+	uart->is_emulated = !!plat_data[0];	/* workaround ISS bug */
+	uart->port.uartclk = plat_data[1];
+	uart->baud = plat_data[2];
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -556,7 +561,6 @@ arc_uart_init_one(struct platform_device *pdev, int dev_id)
 	uart->port.line = dev_id;
 	uart->port.ops = &arc_serial_pops;
 
-	uart->port.uartclk = plat_data[1];
 	uart->port.fifosize = ARC_UART_TX_FIFO_SIZE;
 
 	/*
@@ -565,9 +569,6 @@ arc_uart_init_one(struct platform_device *pdev, int dev_id)
 	 */
 	uart->port.ignore_status_mask = 0;
 
-	/* Real Hardware vs. emulated to work around a bug */
-	uart->is_emulated = !!plat_data[2];
-
 	return 0;
 }
 
-- 
1.7.4.1

