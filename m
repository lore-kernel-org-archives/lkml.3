Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965082AbaGRLkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:40:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45078 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761660AbaGRLk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:40:27 -0400
X-AuditID: cbfee61b-f79f86d00000144c-65-53c907a98652
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 11/12] usb: dwc2/gadget: disable clock when it's not needed
Date: Fri, 18 Jul 2014 13:39:36 +0200
Message-id: <1405683577-11226-12-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
References: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jAd1V7CeDDd71sljMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wW26dMZ7J4cHgnuwOHx/65a9g9+rasYvTYsv8zo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DKOL7mAUvBUr6Kw7/vszQw3uXuYuTkkBAwkei7fYoNwhaT
	uHBvPZgtJLCIUeLmwoAuRi4gu51J4vS2D0wgCTYBHYkt3ycwgtgiAgIS619cYgcpYhY4wSjR
	8f8CWLewgJ/EieZXYDaLgKrE5L7pzCA2r4CbxKbOiUwQ2+QkTh6bzApicwLF2x79Z+li5ADa
	5iox7Sv/BEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCg+uZ9A7GVQ0WhxgFOBiV
	eHgtbh4PFmJNLCuuzD3EKMHBrCTCm30fKMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBA
	emJJanZqakFqEUyWiYNTqoFR9AvbjRmBGr9OLxSVC/8142OtlbSJz8GXaxrTs/73vhK+b+U2
	yXaLWkrrchdp9Uf57502VygcXGDyX2rWeTfFXbN8F8z0nlXoMkdeTJSzPmPhqxdTMhfXvz97
	O2JPAOPrBhPxvP2+hQnBN7vUjhSpFz27/lnqjoV99O2v680Wl+sK2XdeE9mmxFKckWioxVxU
	nAgAEJyciioCAAA=
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
index e74094a..11f038e 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2894,6 +2894,8 @@ static int s3c_hsotg_udc_start(struct usb_gadget *gadget,
 	hsotg->gadget.dev.of_node = hsotg->dev->of_node;
 	hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 
+	clk_enable(hsotg->clk);
+
 	ret = regulator_bulk_enable(ARRAY_SIZE(hsotg->supplies),
 				    hsotg->supplies);
 	if (ret) {
@@ -2942,6 +2944,8 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
 
 	regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies), hsotg->supplies);
 
+	clk_disable(hsotg->clk);
+
 	return 0;
 }
 
@@ -2973,8 +2977,10 @@ static int s3c_hsotg_pullup(struct usb_gadget *gadget, int is_on)
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

