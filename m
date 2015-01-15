Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbbAOWMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:12:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50494 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbbAOWKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:10:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ronald Wahl <ronald.wahl@raritan.com>, Felipe Balbi <balbi@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 03/19] usb: gadget: at91_udc: move prepare clk into process context
Date: Thu, 15 Jan 2015 14:09:39 -0800
Message-Id: <1421359795-11155-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421359795-11155-1-git-send-email-kamal@canonical.com>
References: <1421359795-11155-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt14 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.13-stable: at91_udc.c moved ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/gadget/at91_udc.c | 44 +++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 4cc4fd6..4e8fa75 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -871,12 +871,10 @@ static void clk_on(struct at91_udc *udc)
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
@@ -885,10 +883,10 @@ static void clk_off(struct at91_udc *udc)
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
@@ -1791,14 +1789,24 @@ static int at91udc_probe(struct platform_device *pdev)
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
@@ -1806,7 +1814,7 @@ static int at91udc_probe(struct platform_device *pdev)
 			0, driver_name, udc);
 	if (retval < 0) {
 		DBG("request irq %d failed\n", udc->udp_irq);
-		goto fail1;
+		goto fail1c;
 	}
 	if (gpio_is_valid(udc->board.vbus_pin)) {
 		retval = gpio_request(udc->board.vbus_pin, "udc_vbus");
@@ -1859,6 +1867,13 @@ fail3:
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
@@ -1907,6 +1922,11 @@ static int __exit at91udc_remove(struct platform_device *pdev)
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
1.9.1

