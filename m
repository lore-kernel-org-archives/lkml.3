Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab3FGSIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:08:25 -0400
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:51586 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755813Ab3FGSIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:08:22 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [RFC PATCH 32/50] usb: gadget: at91_udc: prepare clk before calling enable
Date: Fri,  7 Jun 2013 20:08:18 +0200
Message-Id: <1370628498-2584-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 2460935722804017180
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
avoid common clk framework warnings.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/usb/gadget/at91_udc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 073b938..ad03b6b 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -870,8 +870,8 @@ static void clk_on(struct at91_udc *udc)
 	if (udc->clocked)
 		return;
 	udc->clocked = 1;
-	clk_enable(udc->iclk);
-	clk_enable(udc->fclk);
+	clk_prepare_enable(udc->iclk);
+	clk_prepare_enable(udc->fclk);
 }
 
 static void clk_off(struct at91_udc *udc)
@@ -880,8 +880,8 @@ static void clk_off(struct at91_udc *udc)
 		return;
 	udc->clocked = 0;
 	udc->gadget.speed = USB_SPEED_UNKNOWN;
-	clk_disable(udc->fclk);
-	clk_disable(udc->iclk);
+	clk_disable_unprepare(udc->fclk);
+	clk_disable_unprepare(udc->iclk);
 }
 
 /*
@@ -1782,12 +1782,12 @@ static int at91udc_probe(struct platform_device *pdev)
 	}
 
 	/* don't do anything until we have both gadget driver and VBUS */
-	clk_enable(udc->iclk);
+	clk_prepare_enable(udc->iclk);
 	at91_udp_write(udc, AT91_UDP_TXVC, AT91_UDP_TXVC_TXVDIS);
 	at91_udp_write(udc, AT91_UDP_IDR, 0xffffffff);
 	/* Clear all pending interrupts - UDP may be used by bootloader. */
 	at91_udp_write(udc, AT91_UDP_ICR, 0xffffffff);
-	clk_disable(udc->iclk);
+	clk_disable_unprepare(udc->iclk);
 
 	/* request UDC and maybe VBUS irqs */
 	udc->udp_irq = platform_get_irq(pdev, 0);
-- 
1.7.9.5

