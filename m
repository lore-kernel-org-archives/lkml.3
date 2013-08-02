Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab3HBIhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:37:45 -0400
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:41980 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758017Ab3HBIhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:37:42 -0400
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
Subject: [PATCH v3 2/2] usb: gadget: at91_udc: add usb_clk for transition to common clk framework
Date: Fri,  2 Aug 2013 10:37:34 +0200
Message-Id: <1375432654-1192-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375432408-28371-1-git-send-email-b.brezillon@overkiz.com>
References: <1375432408-28371-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 8129560277551773893
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedriedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedriedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
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
 drivers/usb/gadget/at91_udc.c |   17 +++++++++++++++--
 drivers/usb/gadget/at91_udc.h |    2 +-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index d145cb78..5c7c8bb 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -870,6 +870,11 @@ static void clk_on(struct at91_udc *udc)
 	if (udc->clocked)
 		return;
 	udc->clocked = 1;
+
+	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
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
+	if (IS_ENABLED(CONFIG_COMMON_CLK))
+		clk_disable_unprepare(udc->uclk);
 }
 
 /*
@@ -1774,10 +1781,12 @@ static int at91udc_probe(struct platform_device *pdev)
 	/* get interface and function clocks */
 	udc->iclk = clk_get(dev, "udc_clk");
 	udc->fclk = clk_get(dev, "udpck");
-	if (IS_ERR(udc->iclk) || IS_ERR(udc->fclk)) {
+	if (IS_ENABLED(CONFIG_COMMON_CLK))
+		udc->uclk = clk_get(dev, "usb_clk");
+	if (IS_ERR(udc->iclk) || IS_ERR(udc->fclk) ||
+	    (IS_ENABLED(CONFIG_COMMON_CLK) && IS_ERR(udc->uclk))) {
 		DBG("clocks missing\n");
 		retval = -ENODEV;
-		/* NOTE: we "know" here that refcounts on these are NOPs */
 		goto fail1;
 	}
 
@@ -1851,6 +1860,8 @@ fail3:
 fail2:
 	free_irq(udc->udp_irq, udc);
 fail1:
+	if (IS_ENABLED(CONFIG_COMMON_CLK) && !IS_ERR(udc->uclk))
+		clk_put(udc->uclk);
 	if (!IS_ERR(udc->fclk))
 		clk_put(udc->fclk);
 	if (!IS_ERR(udc->iclk))
@@ -1898,6 +1909,8 @@ static int __exit at91udc_remove(struct platform_device *pdev)
 
 	clk_put(udc->iclk);
 	clk_put(udc->fclk);
+	if (IS_ENABLED(CONFIG_COMMON_CLK))
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

