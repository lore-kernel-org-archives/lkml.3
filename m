Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbaIIIvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:51:02 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65021 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230AbaIIIon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:44:43 -0400
X-AuditID: cbfee61a-f79e46d00000134f-cd-540ebdf91012
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 5/6] usb: dwc2/gadget: delay enabling irq once hardware is
 configured properly
Date: Tue, 09 Sep 2014 10:44:12 +0200
Message-id: <1410252253-13687-6-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410252253-13687-1-git-send-email-r.baldyga@samsung.com>
References: <1410252253-13687-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jQd2fe/lCDJZ0yFscvF9v0bx4PZvF
	5V1z2CwWLWtltlh75C67xaOHW1ktHhzeye7A7rF/7hp2j74tqxg9tuz/zOhx/MZ2Jo/Pm+QC
	WKO4bFJSczLLUov07RK4Mnr2rmYseM5T8bx/LXsD4wWuLkZODgkBE4mdvXOZIWwxiQv31rOB
	2EIC0xklFr9P6mLkArLbmSRudPxlBEmwCehIbPk+AcwWEZCXuL7xJgtIEbPAPkaJ6Z+2sYMk
	hAUSJK6e/AQ0iYODRUBV4ueVapAwr4CrxL6zK1kglslJnDw2mRXE5hRwk5jf2w+12FWi88la
	xgmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBIfUM6kdjCsbLA4xCnAwKvHwZgTz
	hQixJpYVV+YeYpTgYFYS4b2yGyjEm5JYWZValB9fVJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2
	ampBahFMlomDU6qBsZ5pyiKhjkL2u5N4eA60HNDnP/vDlvf8SZbM/VfVCiflPlYJNeTTVHhQ
	ELZ0onbHTWlGy1uB29J6vn2T3FvQoeD+fO7GT98W3nrqsjXn2o+3njqbl70tYubjqfBsX3W+
	ZmNErb69TlUNz8azSfFap04tYNQSdHmjX3Oi+FCM+LbrjpvlPu+8qsRSnJFoqMVcVJwIALPE
	kwglAgAA
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
index 474eae2..43fd3d5 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3441,13 +3441,6 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 
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
@@ -3495,6 +3488,17 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	s3c_hsotg_init(hsotg);
 	s3c_hsotg_hw_cfg(hsotg);
 
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

