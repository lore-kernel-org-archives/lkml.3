Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbaGRLjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:39:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25702 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759501AbaGRLjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:39:52 -0400
X-AuditID: cbfee61a-f79e46d00000134f-c3-53c907862e5d
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Kamil Debski <k.debski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 01/12] usb: dwc2/gadget: fix phy disable sequence
Date: Fri, 18 Jul 2014 13:39:26 +0200
Message-id: <1405683577-11226-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
References: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jAd029pPBBhMumFnMetnOYnHwfr1F
	8+L1bBY/Xl9gs7i8aw6bxaJlrcwWa4/cZbfYPmU6k8WDwzvZHTg99s9dw+7Rt2UVo8eW/Z8Z
	PY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfGzBt/mQrec1dMfXaCuYGxmauLkZNDQsBE4vmb
	Y0wQtpjEhXvr2boYuTiEBBYxSiw4upcJwmlnkjh5fhkzSBWbgI7Elu8TGEFsEQEBifUvLrGD
	FDELvGWUmHbuGwtIQljAReL0h0tgRSwCqhK3O36ANfMKuErsXnCIFWKdnMTJY5PBbE4BN4m2
	R/+BejmAtrlKTPvKP4GRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4EB7JrWDcWWD
	xSFGAQ5GJR5ei5vHg4VYE8uKK3MPMUpwMCuJ8GbfBwrxpiRWVqUW5ccXleakFh9ilOZgURLn
	PdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgXH/4rIYZQ/OOwrPzax+kro60PG4kosCS/cJ4nu32
	Cn3RRqnLvypX2x0TWJ8vrplZJxAgHV18xVvrP/eyjI2ye6b4XS2eMIVxTdbCnyFf3m47fyjo
	hc3Enab97f/dRVPuzgyvbQm6uqUnrqFk4p47Zz6IrlkuJCm5a2XistmbOnUib/7O6vliqsRS
	nJFoqMVcVJwIAO+AimUwAgAA
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
index f3c56a2..ccef3a7 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2898,8 +2898,6 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
 
 	spin_lock_irqsave(&hsotg->lock, flags);
 
-	s3c_hsotg_phy_disable(hsotg);
-
 	if (!driver)
 		hsotg->driver = NULL;
 
@@ -3586,7 +3584,6 @@ static int s3c_hsotg_remove(struct platform_device *pdev)
 		usb_gadget_unregister_driver(hsotg->driver);
 	}
 
-	s3c_hsotg_phy_disable(hsotg);
 	if (hsotg->phy)
 		phy_exit(hsotg->phy);
 	clk_disable_unprepare(hsotg->clk);
-- 
1.9.1

