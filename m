Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbaDWPDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:03:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57226 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173AbaDWPBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:01:15 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <marcel@holtmann.org>, <gustavo@padovan.org>, <johan.hedberg@gmail.com>,
        <jslaby@suse.cz>, <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 09/13] tty: serial: omap: switch over to devm_ioremap_resource
Date: Wed, 23 Apr 2014 09:58:33 -0500
Message-ID: <1398265117-11793-9-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.2.459.g68773ac
In-Reply-To: <1398265117-11793-1-git-send-email-balbi@ti.com>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just using helper function to remove some duplicated
code a bit. While at that, also move allocation of
struct uart_omap_port higher in the code so that
we return much earlier in case of no memory.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index cb45e88..b46aaf3 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1644,6 +1644,7 @@ static int serial_omap_probe(struct platform_device *pdev)
 	struct omap_uart_port_info *omap_up_info = dev_get_platdata(&pdev->dev);
 	struct uart_omap_port *up;
 	struct resource *mem;
+	void __iomem *base;
 	int uartirq = 0;
 	int wakeirq = 0;
 	int ret;
@@ -1662,17 +1663,14 @@ static int serial_omap_probe(struct platform_device *pdev)
 			return -EPROBE_DEFER;
 	}
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		dev_err(&pdev->dev, "no mem resource?\n");
-		return -ENODEV;
-	}
+	up = devm_kzalloc(&pdev->dev, sizeof(*up), GFP_KERNEL);
+	if (!up)
+		return -ENOMEM;
 
-	if (!devm_request_mem_region(&pdev->dev, mem->start, resource_size(mem),
-				pdev->dev.driver->name)) {
-		dev_err(&pdev->dev, "memory region already claimed\n");
-		return -EBUSY;
-	}
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	if (gpio_is_valid(omap_up_info->DTR_gpio) &&
 	    omap_up_info->DTR_present) {
@@ -1686,10 +1684,6 @@ static int serial_omap_probe(struct platform_device *pdev)
 			return ret;
 	}
 
-	up = devm_kzalloc(&pdev->dev, sizeof(*up), GFP_KERNEL);
-	if (!up)
-		return -ENOMEM;
-
 	if (gpio_is_valid(omap_up_info->DTR_gpio) &&
 	    omap_up_info->DTR_present) {
 		up->DTR_gpio = omap_up_info->DTR_gpio;
@@ -1732,14 +1726,7 @@ static int serial_omap_probe(struct platform_device *pdev)
 
 	sprintf(up->name, "OMAP UART%d", up->port.line);
 	up->port.mapbase = mem->start;
-	up->port.membase = devm_ioremap(&pdev->dev, mem->start,
-						resource_size(mem));
-	if (!up->port.membase) {
-		dev_err(&pdev->dev, "can't ioremap UART\n");
-		ret = -ENOMEM;
-		goto err_ioremap;
-	}
-
+	up->port.membase = base;
 	up->port.flags = omap_up_info->flags;
 	up->port.uartclk = omap_up_info->uartclk;
 	if (!up->port.uartclk) {
@@ -1786,7 +1773,6 @@ static int serial_omap_probe(struct platform_device *pdev)
 err_add_port:
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-err_ioremap:
 err_rs485:
 err_port_line:
 	dev_err(&pdev->dev, "[UART%d]: failure [%s]: %d\n",
-- 
1.9.2.459.g68773ac

