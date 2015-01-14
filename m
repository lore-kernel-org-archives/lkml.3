Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbbANQXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:23:31 -0500
Received: from down.free-electrons.com ([37.187.137.238]:45292 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754051AbbANQWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:22:22 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH 09/12] usb: gadget: at91_udc: Simplify probe and remove functions
Date: Wed, 14 Jan 2015 17:22:01 +0100
Message-Id: <1421252524-24452-10-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Brezillon <boris.brezillon@free-electrons.com>

Make use of devm_ functions to simplify probe and remove code.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/usb/gadget/udc/at91_udc.c | 116 +++++++++++++-------------------------
 1 file changed, 39 insertions(+), 77 deletions(-)

diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/at91_udc.c
index be7e16037ac4..4dba2c65dfd4 100644
--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -1710,15 +1710,6 @@ static int at91udc_probe(struct platform_device *pdev)
 	int		retval;
 	struct resource	*res;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
-
-	if (!request_mem_region(res->start, resource_size(res), driver_name)) {
-		DBG("someone's using UDC memory\n");
-		return -EBUSY;
-	}
-
 	/* init software state */
 	udc = &controller;
 	udc->gadget.dev.parent = dev;
@@ -1731,13 +1722,13 @@ static int at91udc_probe(struct platform_device *pdev)
 	if (cpu_is_at91rm9200()) {
 		if (!gpio_is_valid(udc->board.pullup_pin)) {
 			DBG("no D+ pullup?\n");
-			retval = -ENODEV;
-			goto fail0;
+			return -ENODEV;
 		}
-		retval = gpio_request(udc->board.pullup_pin, "udc_pullup");
+		retval = devm_gpio_request(dev, udc->board.pullup_pin,
+					   "udc_pullup");
 		if (retval) {
 			DBG("D+ pullup is busy\n");
-			goto fail0;
+			return retval;
 		}
 		gpio_direction_output(udc->board.pullup_pin,
 				udc->board.pullup_active_low);
@@ -1756,32 +1747,32 @@ static int at91udc_probe(struct platform_device *pdev)
 		udc->ep[3].maxpacket = 64;
 	}
 
-	udc->udp_baseaddr = ioremap(res->start, resource_size(res));
-	if (!udc->udp_baseaddr) {
-		retval = -ENOMEM;
-		goto fail0a;
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	udc->udp_baseaddr = devm_ioremap_resource(dev, res);
+	if (IS_ERR(udc->udp_baseaddr))
+		return PTR_ERR(udc->udp_baseaddr);
 
 	udc_reinit(udc);
 
 	/* get interface and function clocks */
-	udc->iclk = clk_get(dev, "pclk");
-	udc->fclk = clk_get(dev, "hclk");
-	if (IS_ERR(udc->iclk) || IS_ERR(udc->fclk)) {
-		DBG("clocks missing\n");
-		retval = -ENODEV;
-		goto fail1;
-	}
+	udc->iclk = devm_clk_get(dev, "pclk");
+	if (IS_ERR(udc->iclk))
+		return PTR_ERR(udc->iclk);
+
+	udc->fclk = devm_clk_get(dev, "hclk");
+	if (IS_ERR(udc->fclk))
+		return PTR_ERR(udc->fclk);
 
 	/* don't do anything until we have both gadget driver and VBUS */
 	clk_set_rate(udc->fclk, 48000000);
 	retval = clk_prepare(udc->fclk);
 	if (retval)
-		goto fail1;
+		return retval;
 
 	retval = clk_prepare_enable(udc->iclk);
 	if (retval)
-		goto fail1b;
+		goto err_unprepare_fclk;
+
 	at91_udp_write(udc, AT91_UDP_TXVC, AT91_UDP_TXVC_TXVDIS);
 	at91_udp_write(udc, AT91_UDP_IDR, 0xffffffff);
 	/* Clear all pending interrupts - UDP may be used by bootloader. */
@@ -1790,18 +1781,21 @@ static int at91udc_probe(struct platform_device *pdev)
 
 	/* request UDC and maybe VBUS irqs */
 	udc->udp_irq = platform_get_irq(pdev, 0);
-	retval = request_irq(udc->udp_irq, at91_udc_irq,
-			0, driver_name, udc);
-	if (retval < 0) {
+	retval = devm_request_irq(dev, udc->udp_irq, at91_udc_irq, 0,
+				  driver_name, udc);
+	if (retval) {
 		DBG("request irq %d failed\n", udc->udp_irq);
-		goto fail1c;
+		goto err_unprepare_iclk;
 	}
+
 	if (gpio_is_valid(udc->board.vbus_pin)) {
-		retval = gpio_request(udc->board.vbus_pin, "udc_vbus");
-		if (retval < 0) {
+		retval = devm_gpio_request(dev, udc->board.vbus_pin,
+					   "udc_vbus");
+		if (retval) {
 			DBG("request vbus pin failed\n");
-			goto fail2;
+			goto err_unprepare_iclk;
 		}
+
 		gpio_direction_input(udc->board.vbus_pin);
 
 		/*
@@ -1818,12 +1812,13 @@ static int at91udc_probe(struct platform_device *pdev)
 			mod_timer(&udc->vbus_timer,
 				  jiffies + VBUS_POLL_TIMEOUT);
 		} else {
-			if (request_irq(gpio_to_irq(udc->board.vbus_pin),
-					at91_vbus_irq, 0, driver_name, udc)) {
+			retval = devm_request_irq(dev,
+					gpio_to_irq(udc->board.vbus_pin),
+					at91_vbus_irq, 0, driver_name, udc);
+			if (retval) {
 				DBG("request vbus irq %d failed\n",
 				    udc->board.vbus_pin);
-				retval = -EBUSY;
-				goto fail3;
+				goto err_unprepare_iclk;
 			}
 		}
 	} else {
@@ -1832,44 +1827,27 @@ static int at91udc_probe(struct platform_device *pdev)
 	}
 	retval = usb_add_gadget_udc(dev, &udc->gadget);
 	if (retval)
-		goto fail4;
+		goto err_unprepare_iclk;
 	dev_set_drvdata(dev, udc);
 	device_init_wakeup(dev, 1);
 	create_debug_file(udc);
 
 	INFO("%s version %s\n", driver_name, DRIVER_VERSION);
 	return 0;
-fail4:
-	if (gpio_is_valid(udc->board.vbus_pin) && !udc->board.vbus_polled)
-		free_irq(gpio_to_irq(udc->board.vbus_pin), udc);
-fail3:
-	if (gpio_is_valid(udc->board.vbus_pin))
-		gpio_free(udc->board.vbus_pin);
-fail2:
-	free_irq(udc->udp_irq, udc);
-fail1c:
+
+err_unprepare_iclk:
 	clk_unprepare(udc->iclk);
-fail1b:
+err_unprepare_fclk:
 	clk_unprepare(udc->fclk);
-fail1:
-	if (!IS_ERR(udc->fclk))
-		clk_put(udc->fclk);
-	if (!IS_ERR(udc->iclk))
-		clk_put(udc->iclk);
-	iounmap(udc->udp_baseaddr);
-fail0a:
-	if (cpu_is_at91rm9200())
-		gpio_free(udc->board.pullup_pin);
-fail0:
-	release_mem_region(res->start, resource_size(res));
+
 	DBG("%s probe failed, %d\n", driver_name, retval);
+
 	return retval;
 }
 
 static int __exit at91udc_remove(struct platform_device *pdev)
 {
 	struct at91_udc *udc = platform_get_drvdata(pdev);
-	struct resource *res;
 	unsigned long	flags;
 
 	DBG("remove\n");
@@ -1884,25 +1862,9 @@ static int __exit at91udc_remove(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 0);
 	remove_debug_file(udc);
-	if (gpio_is_valid(udc->board.vbus_pin)) {
-		free_irq(gpio_to_irq(udc->board.vbus_pin), udc);
-		gpio_free(udc->board.vbus_pin);
-	}
-	free_irq(udc->udp_irq, udc);
-	iounmap(udc->udp_baseaddr);
-
-	if (cpu_is_at91rm9200())
-		gpio_free(udc->board.pullup_pin);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
 	clk_unprepare(udc->fclk);
 	clk_unprepare(udc->iclk);
 
-	clk_put(udc->iclk);
-	clk_put(udc->fclk);
-
 	return 0;
 }
 
-- 
2.1.0

