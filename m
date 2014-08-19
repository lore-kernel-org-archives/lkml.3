Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbaHSJAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 05:00:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55712 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaHSJAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 05:00:00 -0400
X-AuditID: cbfee61b-f79f86d00000144c-4e-53f3120ee006
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH RESEND v3 09/12] usb: dwc2/gadget: delay enabling irq once
 hardware is configured properly
Date: Tue, 19 Aug 2014 10:54:15 +0200
Message-id: <1408438458-3317-10-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
References: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQV0+oc/BBs8aLC1mvWxnsTh4v96i
	efF6NovLu+awWSxa1spssfbIXXaLRw+3slo8OLyT3YHDY//cNewefVtWMXps2f+Z0eP4je1M
	Hp83yQWwRnHZpKTmZJalFunbJXBlnF2+nLXgOU/F2me7mBsYL3B1MXJySAiYSPw6+oUNwhaT
	uHBvPZDNxSEkMJ1RYuvC/VBOO5PEyXXr2EGq2AR0JLZ8n8AIYosIyEtc33iTBaSIWeAQo8Sr
	O8eYQBLCAjkSL2/NZAWxWQRUJS7uvw5m8wq4SuyaeoURYp2cxMljk8HinEDxt/tmgS0QEnCR
	2Nx6hm0CI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEB9kx6B+OqBotDjAIcjEo8
	vApfPgYLsSaWFVfmAl3Dwawkwuv44lOwEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLp
	iSWp2ampBalFMFkmDk6pBsb5/YwVhgz9B9U1hDPNF3Js3PXn0fEpnbd2lM9mP5TieS1/7XP7
	6v2nF3/y6Uj1aZTdveBqkt5sqZ0+DOnpDPkmV/ZWXLgRrs1ZpbKxXTw+7dz1NcFbVJ0NmvQf
	Ln970IKxYnlxyYpd/rJzC0XTPQR9LmVN2vtn8oO/cd5XLV+Kej+daFv79rgSS3FGoqEWc1Fx
	IgCKADpyLAIAAA==
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
index 1d5e387..619fbff 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3456,13 +3456,6 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 
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
@@ -3500,6 +3493,17 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
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

