Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaFWHyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:54:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60800 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbaFWHyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:54:50 -0400
X-AuditID: cbfee61a-f79e46d00000134f-56-53a7dd484436
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 11/11] usb: dwc2/gadget: disable clock when it's not needed
Date: Mon, 23 Jun 2014 09:51:30 +0200
Message-id: <1403509890-14103-12-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
References: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jQV3Pu8uDDfZZW8x62c5icfB+vUXz
	4vVsFpd3zWGzWLSsldli7ZG77Bbbp0xnsnhweCe7A4fH/rlr2D36tqxi9Niy/zOjx/Eb25k8
	Pm+SC2CN4rJJSc3JLEst0rdL4Mq4fHg6W8FSvoork7axNzDe5e5i5OSQEDCRuHv4CiOELSZx
	4d56ti5GLg4hgemMEsf6OtlBEkIC7UwSS35mgthsAjoSW75PAGsQERCQWP/iEjtIA7PACUaJ
	jv8X2EASwgLeErsPbGcCsVkEVCUmLpnOAmLzCrhJ7NqyE2qbnMTJY5NZQWxOoPj6mwuhlrlK
	LDo9jX0CI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHB9UxqB+PKBotDjAIcjEo8
	vBpuy4OFWBPLiitzDzFKcDArifA2NgCFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhP
	LEnNTk0tSC2CyTJxcEo1MEqE//NlOL9l+S0B/6tGi5ZGHTjxKlnKb1KlR8bXt5PVX1b0T1We
	vOvp1LMf4sNu6M4zd1G8KN91b5OO+nMJ/i6p75qvc/3/5uYu+BlyKFI7+KSbTdu9fYkJkzf/
	XFsXq8Ae4XNmt1Jip+jh5ifMVe/9S1TucxevCeaMPLTg9SOzlmZexikGq5VYijMSDbWYi4oT
	AdgP83oqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When device is stopped or suspended clock is not needed so we
can disable it for this time.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 2a7c014..0523bc3 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2884,6 +2884,8 @@ static int s3c_hsotg_udc_start(struct usb_gadget *gadget,
 	hsotg->gadget.dev.of_node = hsotg->dev->of_node;
 	hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 
+	clk_enable(hsotg->clk);
+
 	ret = regulator_bulk_enable(ARRAY_SIZE(hsotg->supplies),
 				    hsotg->supplies);
 	if (ret) {
@@ -2932,6 +2934,8 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
 
 	regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies), hsotg->supplies);
 
+	clk_disable(hsotg->clk);
+
 	return 0;
 }
 
@@ -2963,8 +2967,10 @@ static int s3c_hsotg_pullup(struct usb_gadget *gadget, int is_on)
 	spin_lock_irqsave(&hsotg->lock, flags);
 	if (is_on) {
 		s3c_hsotg_phy_enable(hsotg);
+		clk_enable(hsotg->clk);
 		s3c_hsotg_core_init(hsotg);
 	} else {
+		clk_disable(hsotg->clk);
 		s3c_hsotg_phy_disable(hsotg);
 	}
 
@@ -3640,6 +3646,7 @@ static int s3c_hsotg_suspend(struct platform_device *pdev, pm_message_t state)
 
 		ret = regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies),
 					     hsotg->supplies);
+		clk_disable(hsotg->clk);
 	}
 
 	return ret;
@@ -3654,6 +3661,8 @@ static int s3c_hsotg_resume(struct platform_device *pdev)
 	if (hsotg->driver) {
 		dev_info(hsotg->dev, "resuming usb gadget %s\n",
 			 hsotg->driver->driver.name);
+
+		clk_enable(hsotg->clk);
 		ret = regulator_bulk_enable(ARRAY_SIZE(hsotg->supplies),
 				      hsotg->supplies);
 	}
-- 
1.9.1

