Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab3FYINE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:13:04 -0400
Received: from 3.mo1.mail-out.ovh.net ([46.105.60.232]:43238 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751687Ab3FYINA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:13:00 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 3/4] usb: gadget: at91_udc: prepare clk before calling enable
Date: Tue, 25 Jun 2013 10:12:56 +0200
Message-Id: <1372147976-4405-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372147702-4074-1-git-send-email-b.brezillon@overkiz.com>
References: <1372147702-4074-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 5864812616608675948
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrkedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrkedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
avoid common clk framework warnings.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/usb/gadget/at91_udc.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 073b938..fce8e4e 100644
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
@@ -1782,12 +1782,14 @@ static int at91udc_probe(struct platform_device *pdev)
 	}
 
 	/* don't do anything until we have both gadget driver and VBUS */
-	clk_enable(udc->iclk);
+	retval = clk_prepare_enable(udc->iclk);
+	if (retval)
+		goto fail1;
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

