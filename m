Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaFWHyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:54:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51027 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaFWHyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:54:19 -0400
X-AuditID: cbfee61a-f79e46d00000134f-7c-53a7dd278a7c
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 09/11] usb: dwc2/gadget: delay enabling irq once hardware is
 configured properly
Date: Mon, 23 Jun 2014 09:51:28 +0200
Message-id: <1403509890-14103-10-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
References: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQV31u8uDDVqv8lnMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wW26dMZ7J4cHgnuwOHx/65a9g9+rasYvTYsv8zo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DKWLf2FUvBc56K4wfeMDUwXuDqYuTkkBAwkbiyoJcNwhaT
	uHBvPZDNxSEkMJ1RYual91BOO5PEmpcPGEGq2AR0JLZ8nwBmiwgISKx/cYkdpIhZ4ASjRMf/
	C2CjhAWSJO6v2QtWxCKgKrHl1FIwm1fATaJj2yZmiHVyEiePTWYFsTmB4utvLmQHsYUEXCUW
	nZ7GPoGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4AB7JrWDcWWDxSFGAQ5GJR5e
	DbflwUKsiWXFlbmHGCU4mJVEeBsbgEK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeW
	pGanphakFsFkmTg4pRoYJ11wi36meO/QNwn5lfZLrpukCVz/JzZJ+sadx4+iZ4cdehO9WFtQ
	8+Q8rvt3stf0b+7ccNDEMKDlacU5+c1v7/Gpf0h4/ZV7YbmiRYHJ3lqZL0wHtZUK5SUfbpHa
	sfrLsmlP3a4/1spdetUxctaEci7HvP7Nsnpun92Wr/610GNfub9swdZph5RYijMSDbWYi4oT
	AeGAmIwsAgAA
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

