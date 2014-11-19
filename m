Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbaKSPha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:37:30 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:33595 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaKSPh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:37:29 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-usb@vger.kernel.org>, <ronald.wahl@raritan.com>,
        Felipe Balbi <balbi@ti.com>, <stable@vger.kernel.org>
Subject: [RESEND PATCH] usb: gadget: at91_udc: move prepare clk into process context
Date: Wed, 19 Nov 2014 16:37:27 +0100
Message-ID: <1416411447-31112-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ronald Wahl <ronald.wahl@raritan.com>

Commit 7628083227b6bc4a7e33d7c381d7a4e558424b6b (usb: gadget: at91_udc:
prepare clk before calling enable) added clock preparation in interrupt
context. This is not allowed as it might sleep. Also setting the clock
rate is unsafe to call from there for the same reason. Move clock
preparation and setting clock rate into process context (at91udc_probe).

Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: <stable@vger.kernel.org> # v3.17+
---
Hi Felipe,

I forgot to answer you on this patch. So I resend it now with the proper
"stable" tag. You can also queue it during this -rc phase if you feel it is
still possible.

Thanks, bye.

 drivers/usb/gadget/udc/at91_udc.c | 44 ++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/at91_udc.c
index 9968f5331fe4..0716c1994e28 100644
--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -870,12 +870,10 @@ static void clk_on(struct at91_udc *udc)
 		return;
 	udc->clocked = 1;
 
-	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
-		clk_set_rate(udc->uclk, 48000000);
-		clk_prepare_enable(udc->uclk);
-	}
-	clk_prepare_enable(udc->iclk);
-	clk_prepare_enable(udc->fclk);
+	if (IS_ENABLED(CONFIG_COMMON_CLK))
+		clk_enable(udc->uclk);
+	clk_enable(udc->iclk);
+	clk_enable(udc->fclk);
 }
 
 static void clk_off(struct at91_udc *udc)
@@ -884,10 +882,10 @@ static void clk_off(struct at91_udc *udc)
 		return;
 	udc->clocked = 0;
 	udc->gadget.speed = USB_SPEED_UNKNOWN;
-	clk_disable_unprepare(udc->fclk);
-	clk_disable_unprepare(udc->iclk);
+	clk_disable(udc->fclk);
+	clk_disable(udc->iclk);
 	if (IS_ENABLED(CONFIG_COMMON_CLK))
-		clk_disable_unprepare(udc->uclk);
+		clk_disable(udc->uclk);
 }
 
 /*
@@ -1780,14 +1778,24 @@ static int at91udc_probe(struct platform_device *pdev)
 	}
 
 	/* don't do anything until we have both gadget driver and VBUS */
+	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
+		clk_set_rate(udc->uclk, 48000000);
+		retval = clk_prepare(udc->uclk);
+		if (retval)
+			goto fail1;
+	}
+	retval = clk_prepare(udc->fclk);
+	if (retval)
+		goto fail1a;
+
 	retval = clk_prepare_enable(udc->iclk);
 	if (retval)
-		goto fail1;
+		goto fail1b;
 	at91_udp_write(udc, AT91_UDP_TXVC, AT91_UDP_TXVC_TXVDIS);
 	at91_udp_write(udc, AT91_UDP_IDR, 0xffffffff);
 	/* Clear all pending interrupts - UDP may be used by bootloader. */
 	at91_udp_write(udc, AT91_UDP_ICR, 0xffffffff);
-	clk_disable_unprepare(udc->iclk);
+	clk_disable(udc->iclk);
 
 	/* request UDC and maybe VBUS irqs */
 	udc->udp_irq = platform_get_irq(pdev, 0);
@@ -1795,7 +1803,7 @@ static int at91udc_probe(struct platform_device *pdev)
 			0, driver_name, udc);
 	if (retval < 0) {
 		DBG("request irq %d failed\n", udc->udp_irq);
-		goto fail1;
+		goto fail1c;
 	}
 	if (gpio_is_valid(udc->board.vbus_pin)) {
 		retval = gpio_request(udc->board.vbus_pin, "udc_vbus");
@@ -1848,6 +1856,13 @@ fail3:
 		gpio_free(udc->board.vbus_pin);
 fail2:
 	free_irq(udc->udp_irq, udc);
+fail1c:
+	clk_unprepare(udc->iclk);
+fail1b:
+	clk_unprepare(udc->fclk);
+fail1a:
+	if (IS_ENABLED(CONFIG_COMMON_CLK))
+		clk_unprepare(udc->uclk);
 fail1:
 	if (IS_ENABLED(CONFIG_COMMON_CLK) && !IS_ERR(udc->uclk))
 		clk_put(udc->uclk);
@@ -1896,6 +1911,11 @@ static int __exit at91udc_remove(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(res->start, resource_size(res));
 
+	if (IS_ENABLED(CONFIG_COMMON_CLK))
+		clk_unprepare(udc->uclk);
+	clk_unprepare(udc->fclk);
+	clk_unprepare(udc->iclk);
+
 	clk_put(udc->iclk);
 	clk_put(udc->fclk);
 	if (IS_ENABLED(CONFIG_COMMON_CLK))
-- 
2.1.3

