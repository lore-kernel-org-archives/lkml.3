Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaHSJBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 05:01:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15948 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaHSJBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 05:01:02 -0400
X-AuditID: cbfee61b-f79f86d00000144c-ae-53f3124cea4c
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH RESEND v3 11/12] usb: dwc2/gadget: disable clock when it's not
 needed
Date: Tue, 19 Aug 2014 10:54:17 +0200
Message-id: <1408438458-3317-12-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
References: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jQV0foc/BBmf3GFjMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wWjx5uZbV4cHgnuwOHx/65a9g9+rasYvTYsv8zo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DKONYwn6lgKV/F1IU8DYx3ubsYOTkkBEwkfs+dwAxhi0lc
	uLeeDcQWEpjOKLH1NH8XIxeQ3c4ksXLWTBaQBJuAjsSW7xMYQWwRAXmJ6xtvsoAUMQscYpR4
	decYE0hCWCBcYvWCXawgNouAqsTn80fBpvIKuEr872tlhdgmJ3Hy2GQwmxMo/nbfLHaIzS4S
	m1vPsE1g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzi4nknvYFzVYHGIUYCDUYmH
	V+HLx2Ah1sSy4spcoGs4mJVEeB1ffAoW4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9
	sSQ1OzW1ILUIJsvEwSnVwDj/+/pzjzwjM786Cl1+y/36rqTQijfptmv9D8rOvfJySej1Gs45
	W7Zv/9AbtrXvJyfzgukf0xTCfFNkOzsXt/SG7Wp54/z2jnP6yTktR599XJvAbKwfd/iU1KSz
	F5WEvsRf1v+9xXlravE807frQyvaZGZIPOaNL/Bz+zV112zVs8VNTp++H/JRYinOSDTUYi4q
	TgQAbWLOqSoCAAA=
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
index b914365..148ef3c 100644
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

