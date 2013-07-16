Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab3GPPKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:10:36 -0400
Received: from 14.mo1.mail-out.ovh.net ([178.32.97.215]:48657 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932546Ab3GPPKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:10:33 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v3 4/7] USB: gadget: atmel_usba: prepare clk before calling enable
Date: Tue, 16 Jul 2013 17:10:26 +0200
Message-Id: <1373987426-24338-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373986995-23899-1-git-send-email-b.brezillon@overkiz.com>
References: <1373986995-23899-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 7082473365406185580
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
avoid common clk framework warnings.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/usb/gadget/atmel_usba_udc.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 1d97222..f018017 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -1772,6 +1772,7 @@ out:
 static int atmel_usba_start(struct usb_gadget *gadget,
 		struct usb_gadget_driver *driver)
 {
+	int ret = 0;
 	struct usba_udc *udc = container_of(gadget, struct usba_udc, gadget);
 	unsigned long flags;
 
@@ -1781,8 +1782,14 @@ static int atmel_usba_start(struct usb_gadget *gadget,
 	udc->driver = driver;
 	spin_unlock_irqrestore(&udc->lock, flags);
 
-	clk_enable(udc->pclk);
-	clk_enable(udc->hclk);
+	ret = clk_prepare_enable(udc->pclk);
+	if (ret)
+		goto out;
+	ret = clk_prepare_enable(udc->hclk);
+	if (ret) {
+		clk_disable_unprepare(udc->pclk);
+		goto out;
+	}
 
 	DBG(DBG_GADGET, "registered driver `%s'\n", driver->driver.name);
 
@@ -1797,9 +1804,11 @@ static int atmel_usba_start(struct usb_gadget *gadget,
 		usba_writel(udc, CTRL, USBA_ENABLE_MASK);
 		usba_writel(udc, INT_ENB, USBA_END_OF_RESET);
 	}
+
+out:
 	spin_unlock_irqrestore(&udc->lock, flags);
 
-	return 0;
+	return ret;
 }
 
 static int atmel_usba_stop(struct usb_gadget *gadget,
@@ -1822,8 +1831,8 @@ static int atmel_usba_stop(struct usb_gadget *gadget,
 
 	udc->driver = NULL;
 
-	clk_disable(udc->hclk);
-	clk_disable(udc->pclk);
+	clk_disable_unprepare(udc->hclk);
+	clk_disable_unprepare(udc->pclk);
 
 	DBG(DBG_GADGET, "unregistered driver `%s'\n", driver->driver.name);
 
@@ -2022,10 +2031,14 @@ static int __init usba_udc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, udc);
 
 	/* Make sure we start from a clean slate */
-	clk_enable(pclk);
+	ret = clk_prepare_enable(pclk);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to enable pclk, aborting.\n");
+		goto err_clk_enable;
+	}
 	toggle_bias(0);
 	usba_writel(udc, CTRL, USBA_DISABLE_MASK);
-	clk_disable(pclk);
+	clk_disable_unprepare(pclk);
 
 	if (pdev->dev.of_node)
 		udc->usba_ep = atmel_udc_of_init(pdev, udc);
@@ -2081,6 +2094,7 @@ err_add_udc:
 	free_irq(irq, udc);
 err_request_irq:
 err_alloc_ep:
+err_clk_enable:
 	iounmap(udc->fifo);
 err_map_fifo:
 	iounmap(udc->regs);
-- 
1.7.9.5

