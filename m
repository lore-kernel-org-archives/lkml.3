Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbaIIIqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:46:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11179 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaIIIp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:45:27 -0400
X-AuditID: cbfee61b-f79f86d00000144c-80-540ebe26b360
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 6/6] usb: dwc2/gadget: disable clock when it's not needed
Date: Tue, 09 Sep 2014 10:44:57 +0200
Message-id: <1410252297-13738-7-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
References: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e+xoK7aPr4Qg5+/pSwO3q+3aF68ns3i
	8q45bBaLlrUyWzx6uJXV4sHhnewObB77565h9+jbsorRY8v+z4wex29sZ/L4vEkugDWKyyYl
	NSezLLVI3y6BK6Pt92nWgqV8FYs+eTQw3uXuYuTkkBAwkXj6/ioThC0mceHeerYuRi4OIYHp
	jBL/f25jBUkICbQzSTy5GgliswnoSGz5PoERxBYRkJe4vvEmC0gDs0A/o8TK2YuBHA4OYQFP
	iZ4OSZAaFgFViTt7P7GD2LwCrhJbNzWzQCyTkzh5bDLYfE4BN4k/x76wQ+xylfg3ZxrLBEbe
	BYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCw+iZ9A7GVQ0WhxgFOBiVeHgzgvlChFgT
	y4orcw8xSnAwK4nwXtkNFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1
	CCbLxMEp1cC4/GX6m29bnZLj9vefaWS4M7tPMtA0WfuQ6XG9SbfW/3zMa7mwtuj72+06F9pv
	Sm4PTWIPZuyILdN4N7EyKthZZ5r3pmjL6z8aOvqf6nHm8F6tOxt0NPjxtc/LdyW8j3tfoVn4
	8kdrCmdv8QvFYuXwY4+WvVmsr98dc/3+goiNNpvqfpTOPBWnxFKckWioxVxUnAgAOS8JMh8C	AAA=
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
index 29d7561..94f7a3f 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2893,6 +2893,8 @@ static int s3c_hsotg_udc_start(struct usb_gadget *gadget,
 	hsotg->gadget.dev.of_node = hsotg->dev->of_node;
 	hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 
+	clk_enable(hsotg->clk);
+
 	ret = regulator_bulk_enable(ARRAY_SIZE(hsotg->supplies),
 				    hsotg->supplies);
 	if (ret) {
@@ -2941,6 +2943,8 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
 
 	regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies), hsotg->supplies);
 
+	clk_disable(hsotg->clk);
+
 	return 0;
 }
 
@@ -2972,8 +2976,10 @@ static int s3c_hsotg_pullup(struct usb_gadget *gadget, int is_on)
 	spin_lock_irqsave(&hsotg->lock, flags);
 	if (is_on) {
 		s3c_hsotg_phy_enable(hsotg);
+		clk_enable(hsotg->clk);
 		s3c_hsotg_core_init(hsotg);
 	} else {
+		clk_disable(hsotg->clk);
 		s3c_hsotg_phy_disable(hsotg);
 	}
 
@@ -3636,6 +3642,7 @@ static int s3c_hsotg_suspend(struct platform_device *pdev, pm_message_t state)
 
 		ret = regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies),
 					     hsotg->supplies);
+		clk_disable(hsotg->clk);
 	}
 
 	return ret;
@@ -3650,6 +3657,8 @@ static int s3c_hsotg_resume(struct platform_device *pdev)
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

