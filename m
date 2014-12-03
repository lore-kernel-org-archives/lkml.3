Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaLCLf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:35:59 -0500
Received: from down.free-electrons.com ([37.187.137.238]:39290 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753097AbaLCLcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:32:16 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 02/11] usb: gadget: at91_udc: Drop uclk clock
Date: Wed,  3 Dec 2014 12:32:01 +0100
Message-Id: <1417606330-17753-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417606330-17753-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417606330-17753-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that at91 system clocks forward set_rate request to their parent we
can remove the uclk clock and directly call clk_set_rate on fclk.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/usb/gadget/udc/at91_udc.c | 27 +++------------------------
 drivers/usb/gadget/udc/at91_udc.h |  2 +-
 2 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/at91_udc.c
index ca6a4b8..4ecb576 100644
--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -870,8 +870,6 @@ static void clk_on(struct at91_udc *udc)
 		return;
 	udc->clocked = 1;
 
-	if (IS_ENABLED(CONFIG_COMMON_CLK))
-		clk_enable(udc->uclk);
 	clk_enable(udc->iclk);
 	clk_enable(udc->fclk);
 }
@@ -884,8 +882,6 @@ static void clk_off(struct at91_udc *udc)
 	udc->gadget.speed = USB_SPEED_UNKNOWN;
 	clk_disable(udc->fclk);
 	clk_disable(udc->iclk);
-	if (IS_ENABLED(CONFIG_COMMON_CLK))
-		clk_disable(udc->uclk);
 }
 
 /*
@@ -1768,25 +1764,17 @@ static int at91udc_probe(struct platform_device *pdev)
 	/* get interface and function clocks */
 	udc->iclk = clk_get(dev, "pclk");
 	udc->fclk = clk_get(dev, "hclk");
-	if (IS_ENABLED(CONFIG_COMMON_CLK))
-		udc->uclk = clk_get(dev, "usb_clk");
-	if (IS_ERR(udc->iclk) || IS_ERR(udc->fclk) ||
-	    (IS_ENABLED(CONFIG_COMMON_CLK) && IS_ERR(udc->uclk))) {
+	if (IS_ERR(udc->iclk) || IS_ERR(udc->fclk)) {
 		DBG("clocks missing\n");
 		retval = -ENODEV;
 		goto fail1;
 	}
 
 	/* don't do anything until we have both gadget driver and VBUS */
-	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
-		clk_set_rate(udc->uclk, 48000000);
-		retval = clk_prepare(udc->uclk);
-		if (retval)
-			goto fail1;
-	}
+	clk_set_rate(udc->fclk, 48000000);
 	retval = clk_prepare(udc->fclk);
 	if (retval)
-		goto fail1a;
+		goto fail1;
 
 	retval = clk_prepare_enable(udc->iclk);
 	if (retval)
@@ -1860,12 +1848,7 @@ fail1c:
 	clk_unprepare(udc->iclk);
 fail1b:
 	clk_unprepare(udc->fclk);
-fail1a:
-	if (IS_ENABLED(CONFIG_COMMON_CLK))
-		clk_unprepare(udc->uclk);
 fail1:
-	if (IS_ENABLED(CONFIG_COMMON_CLK) && !IS_ERR(udc->uclk))
-		clk_put(udc->uclk);
 	if (!IS_ERR(udc->fclk))
 		clk_put(udc->fclk);
 	if (!IS_ERR(udc->iclk))
@@ -1911,15 +1894,11 @@ static int __exit at91udc_remove(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(res->start, resource_size(res));
 
-	if (IS_ENABLED(CONFIG_COMMON_CLK))
-		clk_unprepare(udc->uclk);
 	clk_unprepare(udc->fclk);
 	clk_unprepare(udc->iclk);
 
 	clk_put(udc->iclk);
 	clk_put(udc->fclk);
-	if (IS_ENABLED(CONFIG_COMMON_CLK))
-		clk_put(udc->uclk);
 
 	return 0;
 }
diff --git a/drivers/usb/gadget/udc/at91_udc.h b/drivers/usb/gadget/udc/at91_udc.h
index 0175246..e647d1c 100644
--- a/drivers/usb/gadget/udc/at91_udc.h
+++ b/drivers/usb/gadget/udc/at91_udc.h
@@ -126,7 +126,7 @@ struct at91_udc {
 	unsigned			active_suspend:1;
 	u8				addr;
 	struct at91_udc_data		board;
-	struct clk			*iclk, *fclk, *uclk;
+	struct clk			*iclk, *fclk;
 	struct platform_device		*pdev;
 	struct proc_dir_entry		*pde;
 	void __iomem			*udp_baseaddr;
-- 
1.9.1

