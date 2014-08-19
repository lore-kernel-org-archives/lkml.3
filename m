Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaHSIzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:55:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54733 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaHSIzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:55:39 -0400
X-AuditID: cbfee61a-f79e46d00000134f-1f-53f31109e2eb
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Kamil Debski <k.debski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH RESEND v3 01/12] usb: dwc2/gadget: fix phy disable sequence
Date: Tue, 19 Aug 2014 10:54:07 +0200
Message-id: <1408438458-3317-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
References: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jQV1Owc/BBhM3K1nMetnOYnHwfr1F
	8+L1bBY/Xl9gs7i8aw6bxaJlrcwWa4/cZbd49HArq8WDwzvZHTg99s9dw+7Rt2UVo8eW/Z8Z
	PY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfGp74nzAXvuStWzJzM2sDYzNXFyMEhIWAicW5b
	bhcjJ5ApJnHh3nq2LkYuDiGB6YwSXe9+QzntTBInz7UxgVSxCehIbPk+gRHEFhGQl7i+8SYL
	SBGzwHNGiTPrJ7KCTBUW8Jb42JQOUsMioCrxr+crC4jNK+AiMevzHTaIbXISJ49NZgWxOQVc
	Jd7um8UOYgsB1WxuPcM2gZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgMHsmtYNx
	ZYPFIUYBDkYlHl6FLx+DhVgTy4orcw8xSnAwK4nwOr74FCzEm5JYWZValB9fVJqTWnyIUZqD
	RUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qBcQdrcp7KXL7gNP5zzl3SFrMUMiZuuxne5zBz
	zjRhibd+j03WcTratO70CJ/9+yy3dkYDc90dycyNMsJqrK96Qu68/2ZzI8TnzSpnuXrN7vpp
	wef/9r5RYlh3+4tzkJmTR+U868rVHOcLjpdcqdodP6NQav1MLt5lgnc9DrlMmHAh7+L3X75f
	lViKMxINtZiLihMB0ymS3S8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kamil Debski <k.debski@samsung.com>

When the driver is removed s3c_hsotg_phy_disable is called three times
instead of once. This results in decreasing of the phy reference counter
below zero and thus consecutive inserts of the module fails.

This patch removes calls to s3c_hsotg_phy_disable from s3c_hsotg_remove
and s3c_hsotg_udc_stop.

s3c_hsotg_udc_stop is called from udc-core.c only after
usb_gadget_disconnect, which in turn calls s3c_hsotg_pullup, which
already calls s3c_hsotg_phy_disable.

s3c_hsotg_remove must be called only after udc_stop, so there is no
point in disabling phy once again there.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 0ba9c33..d27417e 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2897,8 +2897,6 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
 
 	spin_lock_irqsave(&hsotg->lock, flags);
 
-	s3c_hsotg_phy_disable(hsotg);
-
 	if (!driver)
 		hsotg->driver = NULL;
 
@@ -3582,7 +3580,6 @@ static int s3c_hsotg_remove(struct platform_device *pdev)
 		usb_gadget_unregister_driver(hsotg->driver);
 	}
 
-	s3c_hsotg_phy_disable(hsotg);
 	if (hsotg->phy)
 		phy_exit(hsotg->phy);
 	clk_disable_unprepare(hsotg->clk);
-- 
1.9.1

