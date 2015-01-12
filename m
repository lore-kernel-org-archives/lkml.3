Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbbALTIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:08:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57478 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbbALSFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ronald Wahl <ronald.wahl@raritan.com>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 040/216] usb: gadget: at91_udc: move prepare clk into process context
Date: Mon, 12 Jan 2015 18:02:37 +0000
Message-Id: <1421085933-32536-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronald Wahl <ronald.wahl@raritan.com>

commit b2ba27a5c56ff7204d8a8684893d64d4afe2cee5 upstream.

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
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/at91_udc.c | 44 +++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index cfd18bcca723..0d685d0b858e 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
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
2.1.4

