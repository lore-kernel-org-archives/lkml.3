Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761697AbaGRLkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:40:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25764 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761672AbaGRLkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:40:20 -0400
X-AuditID: cbfee61b-f79f86d00000144c-50-53c907a34300
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 09/12] usb: dwc2/gadget: delay enabling irq once hardware is
 configured properly
Date: Fri, 18 Jul 2014 13:39:34 +0200
Message-id: <1405683577-11226-10-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
References: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jAd3F7CeDDaa0S1jMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wW26dMZ7J4cHgnuwOHx/65a9g9+rasYvTYsv8zo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DKWLf2FUvBc56K4wfeMDUwXuDqYuTkkBAwkVh+7wIjhC0m
	ceHeerYuRi4OIYFFjBJ92w+wQjjtTBKH1txgAqliE9CR2PJ9AliHiICAxPoXl9hBipgFTjBK
	dPy/wAaSEBZIlbgzdyOYzSKgKnFs0RZWEJtXwE2i88B0Voh1chInj00GszmB4m2P/rN0MXIA
	bXOVmPaVfwIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYweH1THoH46oGi0OMAhyM
	Sjy8FjePBwuxJpYVV+YeYpTgYFYS4c2+DxTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBI
	ID2xJDU7NbUgtQgmy8TBKdXAuPHhhCcFk91Nqpae6/zLwdyg7bP9+iSJ018yltrcWez+/MVk
	a/8EBuXd4Q3pgVInqhkkdrRncc2MF2y7vnnrg2fa+t83fWh8c2wKh0UpzzvGBTxrCvyuCT0y
	/7daw/Roi3LVk9vL1T3jJBdYXy572bl676R5SUmu09M/L+Nn+vez2sTstBebsBJLcUaioRZz
	UXEiAM+2eSMrAgAA
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

