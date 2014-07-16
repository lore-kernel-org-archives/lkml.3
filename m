Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbaGPKXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:23:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18062 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932460AbaGPKX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:23:29 -0400
X-AuditID: cbfee61a-f79e46d00000134f-ad-53c65299de7c
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 11/12] usb: dwc2/gadget: disable clock when it's not needed
Date: Wed, 16 Jul 2014 12:22:29 +0200
Message-id: <1405506150-16185-12-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
References: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd2ZQceCDRZM4rGY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9kttk+ZzmTx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CVMe3WdNaCpXwVSy/8ZmpgvMvdxcjJISFgIrHoTzczhC0m
	ceHeerYuRi4OIYHpjBLNL/+yQzjtTBIPj09nAqliE9CR2PJ9AiOILSIgILH+xSWwImaBE4wS
	Hf8vsIEkhAX8JJr6WllAbBYBVYljp2axgti8Am4Su84sg1onJ3Hy2GSwOCdQfM3rZnYQW0jA
	VeL4umVMExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDrBnUjsYVzZYHGIU4GBU
	4uHdEHI0WIg1say4MvcQowQHs5IIr4P/sWAh3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOF
	BNITS1KzU1MLUotgskwcnFINjDV7/oVqJZekvq+5P629Y/3Byti9OWa3Xtbe/yH75/mPd2lT
	i7KOFnjMSYlhyA6XULmao2r2P82hxfWp2aeTsvIza38pe/1I8fOcr/tpuXZln8nkLbZOacmL
	xF+ZbrzHwHYiauZkqy8OsxaYzZrQ0PHus6mDRklOc/zct1t3r571rjTaKbgmVImlOCPRUIu5
	qDgRADg0GgIsAgAA
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
index 1b5e9ff..68b764e 100644
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

