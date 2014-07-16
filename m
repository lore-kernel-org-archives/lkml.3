Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbaGPKXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:23:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38673 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbaGPKXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:23:16 -0400
X-AuditID: cbfee61b-f79f86d00000144c-6d-53c65292885c
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 09/12] usb: dwc2/gadget: delay enabling irq once hardware is
 configured properly
Date: Wed, 16 Jul 2014 12:22:27 +0200
Message-id: <1405506150-16185-10-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
References: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd1JQceCDeb/1LCY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9kttk+ZzmTx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CVsW7tK5aC5zwVxw+8YWpgvMDVxcjJISFgIvHj0SIWCFtM
	4sK99WwgtpDAdEaJ3weNuxi5gOx2Jonuha/AitgEdCS2fJ/ACGKLCAhIrH9xiR2kiFngBKNE
	x/8LYN3CAqkSUw+9YQaxWQRUJRq+n2MHsXkF3CQaWxewQ2yTkzh5bDIriM0JFF/zupkdYrOr
	xPF1y5gmMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcXs+kdzCuarA4xCjAwajE
	w7sh5GiwEGtiWXFl7iFGCQ5mJRFeB/9jwUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJ
	pCeWpGanphakFsFkmTg4pRoYxS4YNCbpq2/+mrLsjGGG7RJxqW17Yzx28Nr3mxeuO7WMceKs
	a/xbznwrOM3CMuHhqsVPtp7+/X7V7dmuh+xmyx/59eTpZXk34y19tvZz9ky5dtxzP5d0psTC
	BdsVSlyOdvcv4Kt/92LWbQZupsQlD0Kvi6Tviu82X3X3/ef5PfkH/8dtNH/HIK3EUpyRaKjF
	XFScCADV2bxWKwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

This patch fixes kernel panic/interrupt storm/etc issues if bootloader
left s3c-hsotg module in enabled state. Now interrupt handler is enabled
only after proper configuration of hardware registers.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index def4900..3435711 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3459,13 +3459,6 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 
 	hsotg->irq = ret;
 
-	ret = devm_request_irq(&pdev->dev, hsotg->irq, s3c_hsotg_irq, 0,
-				dev_name(dev), hsotg);
-	if (ret < 0) {
-		dev_err(dev, "cannot claim IRQ\n");
-		goto err_clk;
-	}
-
 	dev_info(dev, "regs %p, irq %d\n", hsotg->regs, hsotg->irq);
 
 	hsotg->gadget.max_speed = USB_SPEED_HIGH;
@@ -3503,6 +3496,17 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	s3c_hsotg_hw_cfg(hsotg);
 	s3c_hsotg_init(hsotg);
 
+	ret = devm_request_irq(&pdev->dev, hsotg->irq, s3c_hsotg_irq, 0,
+				dev_name(dev), hsotg);
+	if (ret < 0) {
+		s3c_hsotg_phy_disable(hsotg);
+		clk_disable_unprepare(hsotg->clk);
+		regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies),
+				       hsotg->supplies);
+		dev_err(dev, "cannot claim IRQ\n");
+		goto err_clk;
+	}
+
 	/* hsotg->num_of_eps holds number of EPs other than ep0 */
 
 	if (hsotg->num_of_eps == 0) {
-- 
1.9.1

