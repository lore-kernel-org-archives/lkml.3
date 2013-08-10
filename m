Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab3HJHcV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 03:32:21 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:34735 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932323Ab3HJHcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 03:32:19 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] tty: ar933x_uart: convert to use devm_* functions
Date: Sat, 10 Aug 2013 09:32:15 +0200
Message-Id: <1376119935-2509-1-git-send-email-juhosg@openwrt.org>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_* functions in order to simplify cleanup
paths.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/tty/serial/ar933x_uart.c |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/serial/ar933x_uart.c b/drivers/tty/serial/ar933x_uart.c
index 27f20c5..470993e 100644
--- a/drivers/tty/serial/ar933x_uart.c
+++ b/drivers/tty/serial/ar933x_uart.c
@@ -652,19 +652,18 @@ static int ar933x_uart_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	up = kzalloc(sizeof(struct ar933x_uart_port), GFP_KERNEL);
+	up = devm_kzalloc(&pdev->dev, sizeof(struct ar933x_uart_port),
+			  GFP_KERNEL);
 	if (!up)
 		return -ENOMEM;
 
 	port = &up->port;
-	port->mapbase = mem_res->start;
 
-	port->membase = ioremap(mem_res->start, AR933X_UART_REGS_SIZE);
-	if (!port->membase) {
-		ret = -ENOMEM;
-		goto err_free_up;
-	}
+	port->membase = devm_ioremap_resource(&pdev->dev, mem_res);
+	if (IS_ERR(port->membase))
+		return PTR_ERR(port->membase);
 
+	port->mapbase = mem_res->start;
 	port->line = id;
 	port->irq = irq_res->start;
 	port->dev = &pdev->dev;
@@ -686,16 +685,10 @@ static int ar933x_uart_probe(struct platform_device *pdev)
 
 	ret = uart_add_one_port(&ar933x_uart_driver, &up->port);
 	if (ret)
-		goto err_unmap;
+		return ret;
 
 	platform_set_drvdata(pdev, up);
 	return 0;
-
-err_unmap:
-	iounmap(up->port.membase);
-err_free_up:
-	kfree(up);
-	return ret;
 }
 
 static int ar933x_uart_remove(struct platform_device *pdev)
@@ -705,11 +698,8 @@ static int ar933x_uart_remove(struct platform_device *pdev)
 	up = platform_get_drvdata(pdev);
 	platform_set_drvdata(pdev, NULL);
 
-	if (up) {
+	if (up)
 		uart_remove_one_port(&ar933x_uart_driver, &up->port);
-		iounmap(up->port.membase);
-		kfree(up);
-	}
 
 	return 0;
 }
-- 
1.7.10
