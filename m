Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbbAFNsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:48:17 -0500
Received: from down.free-electrons.com ([37.187.137.238]:43739 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754938AbbAFNrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:47:09 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 4/5] usb: atmel_usba_udc: Mask status with enabled irqs
Date: Tue,  6 Jan 2015 14:47:01 +0100
Message-Id: <1420552022-8422-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420552022-8422-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1420552022-8422-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid interpreting useless status flags when we're not waiting for such
events by masking the status variable with the interrupt enabled register
value.

Reported-by: Patrice VILCHEZ <patrice.vilchez@atmel.com>
Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/usb/gadget/udc/atmel_usba_udc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.c b/drivers/usb/gadget/udc/atmel_usba_udc.c
index 55c8dde..bc3a532 100644
--- a/drivers/usb/gadget/udc/atmel_usba_udc.c
+++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
@@ -1612,12 +1612,14 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
 
 	spin_lock(&udc->lock);
 
-	status = usba_readl(udc, INT_STA);
+	status = usba_readl(udc, INT_STA) & usba_readl(udc, INT_ENB);
 	DBG(DBG_INT, "irq, status=%#08x\n", status);
 
 	if (status & USBA_DET_SUSPEND) {
 		toggle_bias(udc, 0);
 		usba_writel(udc, INT_CLR, USBA_DET_SUSPEND);
+		usba_writel(udc, INT_ENB,
+			    usba_readl(udc, INT_ENB) | USBA_WAKE_UP);
 		udc->bias_pulse_needed = true;
 		DBG(DBG_BUS, "Suspend detected\n");
 		if (udc->gadget.speed != USB_SPEED_UNKNOWN
@@ -1631,6 +1633,8 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
 	if (status & USBA_WAKE_UP) {
 		toggle_bias(udc, 1);
 		usba_writel(udc, INT_CLR, USBA_WAKE_UP);
+		usba_writel(udc, INT_ENB,
+			    usba_readl(udc, INT_ENB) & ~USBA_WAKE_UP);
 		DBG(DBG_BUS, "Wake Up CPU detected\n");
 	}
 
-- 
1.9.1

