Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab3GQPtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:49:42 -0400
Received: from 13.mo1.mail-out.ovh.net ([178.33.253.128]:42754 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755452Ab3GQPtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:49:40 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 27/42] usb: gadget: at91_udc: add usb_clk for transition to common clk framework
Date: Wed, 17 Jul 2013 17:49:23 +0200
Message-Id: <1374076163-20332-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 13612692824020318316
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AT91 PMC (Power Management Controller) provides an USB clock used by
USB Full Speed host (ohci) and USB Full Speed device (udc).
The usb drivers (ohci and udc) must configure this clock to 48Mhz.
This configuration was formely done in mach-at91/clock.c, but this
implementation will be removed when moving to common clk framework.

This patch add support for usb clock retrieval and configuration.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/usb/gadget/at91_udc.c |   31 ++++++++++++++++++++++++++-----
 drivers/usb/gadget/at91_udc.h |    2 +-
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index fce8e4e..05aac04 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -870,6 +870,8 @@ static void clk_on(struct at91_udc *udc)
 	if (udc->clocked)
 		return;
 	udc->clocked = 1;
+	clk_set_rate(udc->uclk, 48000000);
+	clk_prepare_enable(udc->uclk);
 	clk_prepare_enable(udc->iclk);
 	clk_prepare_enable(udc->fclk);
 }
@@ -882,6 +884,7 @@ static void clk_off(struct at91_udc *udc)
 	udc->gadget.speed = USB_SPEED_UNKNOWN;
 	clk_disable_unprepare(udc->fclk);
 	clk_disable_unprepare(udc->iclk);
+	clk_disable_unprepare(udc->uclk);
 }
 
 /*
@@ -1773,18 +1776,28 @@ static int at91udc_probe(struct platform_device *pdev)
 
 	/* get interface and function clocks */
 	udc->iclk = clk_get(dev, "udc_clk");
-	udc->fclk = clk_get(dev, "udpck");
-	if (IS_ERR(udc->iclk) || IS_ERR(udc->fclk)) {
-		DBG("clocks missing\n");
+	if (IS_ERR(udc->iclk)) {
+		DBG("interface clock missing\n");
 		retval = -ENODEV;
-		/* NOTE: we "know" here that refcounts on these are NOPs */
 		goto fail1;
 	}
+	udc->fclk = clk_get(dev, "udpck");
+	if (IS_ERR(udc->fclk)) {
+		DBG("function clock missing\n");
+		retval = -ENODEV;
+		goto fail1a;
+	}
+	udc->uclk = clk_get(dev, "usb_clk");
+	if (IS_ERR(udc->uclk)) {
+		DBG("usb clock missing\n");
+		retval = -ENODEV;
+		goto fail1b;
+	}
 
 	/* don't do anything until we have both gadget driver and VBUS */
 	retval = clk_prepare_enable(udc->iclk);
 	if (retval)
-		goto fail1;
+		goto fail1c;
 	at91_udp_write(udc, AT91_UDP_TXVC, AT91_UDP_TXVC_TXVDIS);
 	at91_udp_write(udc, AT91_UDP_IDR, 0xffffffff);
 	/* Clear all pending interrupts - UDP may be used by bootloader. */
@@ -1850,6 +1863,13 @@ fail3:
 		gpio_free(udc->board.vbus_pin);
 fail2:
 	free_irq(udc->udp_irq, udc);
+
+fail1c:
+	clk_put(udc->uclk);
+fail1b:
+	clk_put(udc->fclk);
+fail1a:
+	clk_put(udc->iclk);
 fail1:
 	iounmap(udc->udp_baseaddr);
 fail0a:
@@ -1894,6 +1914,7 @@ static int __exit at91udc_remove(struct platform_device *pdev)
 
 	clk_put(udc->iclk);
 	clk_put(udc->fclk);
+	clk_put(udc->uclk);
 
 	return 0;
 }
diff --git a/drivers/usb/gadget/at91_udc.h b/drivers/usb/gadget/at91_udc.h
index e647d1c..0175246 100644
--- a/drivers/usb/gadget/at91_udc.h
+++ b/drivers/usb/gadget/at91_udc.h
@@ -126,7 +126,7 @@ struct at91_udc {
 	unsigned			active_suspend:1;
 	u8				addr;
 	struct at91_udc_data		board;
-	struct clk			*iclk, *fclk;
+	struct clk			*iclk, *fclk, *uclk;
 	struct platform_device		*pdev;
 	struct proc_dir_entry		*pde;
 	void __iomem			*udp_baseaddr;
-- 
1.7.9.5

