Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab3HAGmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 02:42:00 -0400
Received: from 7.mo2.mail-out.ovh.net ([188.165.48.182]:42585 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750936Ab3HAGl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 02:41:59 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH] usb: gadget: at91_udc: add usb_clk for transition to common clk framework
Date: Thu,  1 Aug 2013 08:18:05 +0200
Message-Id: <1375337885-2684-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 18347101932352534725
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrheelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrheelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AT91 PMC (Power Management Controller) provides an USB clock used by
USB Full Speed host (ohci) and USB Full Speed device (udc).
The usb drivers (ohci and udc) must configure this clock to 48Mhz.
This configuration was formely done in mach-at91/clock.c, but this
implementation will be removed when moving to common clk framework.

This patch adds support for usb clock retrieval and configuration, and is
backward compatible with the current at91 clk implementation (if usb clk
is not found, it does not configure/enable it).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/usb/gadget/at91_udc.c |   17 ++++++++++++++++-
 drivers/usb/gadget/at91_udc.h |    2 +-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index fce8e4e..ae06585 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -870,6 +870,11 @@ static void clk_on(struct at91_udc *udc)
 	if (udc->clocked)
 		return;
 	udc->clocked = 1;
+
+	if (!IS_ERR(udc->uclk)) {
+		clk_set_rate(udc->uclk, 48000000);
+		clk_prepare_enable(udc->uclk);
+	}
 	clk_prepare_enable(udc->iclk);
 	clk_prepare_enable(udc->fclk);
 }
@@ -882,6 +887,8 @@ static void clk_off(struct at91_udc *udc)
 	udc->gadget.speed = USB_SPEED_UNKNOWN;
 	clk_disable_unprepare(udc->fclk);
 	clk_disable_unprepare(udc->iclk);
+	if (!IS_ERR(udc->uclk))
+		clk_disable_unprepare(udc->uclk);
 }
 
 /*
@@ -1774,10 +1781,10 @@ static int at91udc_probe(struct platform_device *pdev)
 	/* get interface and function clocks */
 	udc->iclk = clk_get(dev, "udc_clk");
 	udc->fclk = clk_get(dev, "udpck");
+	udc->uclk = clk_get(dev, "usb_clk");
 	if (IS_ERR(udc->iclk) || IS_ERR(udc->fclk)) {
 		DBG("clocks missing\n");
 		retval = -ENODEV;
-		/* NOTE: we "know" here that refcounts on these are NOPs */
 		goto fail1;
 	}
 
@@ -1851,6 +1858,12 @@ fail3:
 fail2:
 	free_irq(udc->udp_irq, udc);
 fail1:
+	if (!IS_ERR(udc->uclk))
+		clk_put(udc->uclk);
+	if (!IS_ERR(udc->fclk))
+		clk_put(udc->fclk);
+	if (!IS_ERR(udc->iclk))
+		clk_put(udc->iclk);
 	iounmap(udc->udp_baseaddr);
 fail0a:
 	if (cpu_is_at91rm9200())
@@ -1894,6 +1907,8 @@ static int __exit at91udc_remove(struct platform_device *pdev)
 
 	clk_put(udc->iclk);
 	clk_put(udc->fclk);
+	if (!IS_ERR(udc->uclk))
+		clk_put(udc->uclk);
 
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

