Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbaGPKWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:22:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17969 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149AbaGPKWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:22:49 -0400
X-AuditID: cbfee61a-f79e46d00000134f-62-53c652779588
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Kamil Debski <k.debski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 01/12] usb: dwc2/gadget: fix phy disable sequence
Date: Wed, 16 Jul 2014 12:22:19 +0200
Message-id: <1405506150-16185-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
References: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jQd2KoGPBBk0BFrNetrNYHLxfb9G8
	eD2bxY/XF9gsLu+aw2axaFkrs8XaI3fZLbZPmc5k8eDwTnYHTo/9c9ewe/RtWcXosWX/Z0aP
	4ze2M3l83iQXwBrFZZOSmpNZllqkb5fAlTHzxl+mgvfcFVOfnWBuYGzm6mLk4JAQMJHYOLeq
	i5ETyBSTuHBvPVsXIxeHkMB0RokFfy8xQjjtTBIbXhxlAaliE9CR2PJ9AiOILSIgILH+xSV2
	kCJmgbeMEtPOfQMrEhZwkdh0/T4TiM0ioCpx6dg5sDivgKvE93/PWSDWyUmcPDaZFcTmFHCT
	WPO6mR3EFgKqOb5uGdMERt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLD7JnUDsaV
	DRaHGAU4GJV4eDeEHA0WYk0sK67MPcQowcGsJMLr4H8sWIg3JbGyKrUoP76oNCe1+BCjNAeL
	kjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVAOjucRk/vzVJ/xiWyTyIhcyOLhN4VknwmTmGx9/
	pm/r9hkdOmem7jxkffrvgbmrOvOe7D/CKcey0FD3roHOVrd5xtfjV67/dX4OL8fvxKV2fOW5
	IToRJVtPXD5aeEfKUKXg9K4VoVMkurJeXVv9ZofRF+Wrl5juGhcv2P3wT6vCSoVPCaJZXyrC
	lFiKMxINtZiLihMB5lDj6C8CAAA=
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

