Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaFWHwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:52:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59252 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaFWHwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:52:04 -0400
X-AuditID: cbfee61a-f79e46d00000134f-6b-53a7dca1c537
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Kamil Debski <k.debski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 01/11] usb: dwc2/gadget: fix phy disable sequence
Date: Mon, 23 Jun 2014 09:51:20 +0200
Message-id: <1403509890-14103-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
References: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jQd2Fd5YHG2y8ZGUx62U7i8XB+/UW
	zYvXs1n8eH2BzeLyrjlsFouWtTJbrD1yl91i+5TpTBYPDu9kd+D02D93DbtH35ZVjB5b9n9m
	9Dh+YzuTx+dNcgGsUVw2Kak5mWWpRfp2CVwZM2/8ZSp4z10x9dkJ5gbGZq4uRk4OCQETicaV
	m9ggbDGJC/fWA9lcHEIC0xklJj1fyALhtDNJNL65wAxSxSagI7Hl+wRGEFtEQEBi/YtL7CBF
	zAJvGSWmnfsG1MHBISzgKPFtfSFIDYuAqsS6j6vANvAKuEqsfveBEWKbnMTJY5NZQWxOATeJ
	9TcXsoPYQkA1i05PY5/AyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnCgPZPawbiy
	weIQowAHoxIPr4bb8mAh1sSy4srcQ4wSHMxKIryNDUAh3pTEyqrUovz4otKc1OJDjNIcLEri
	vAdarQOFBNITS1KzU1MLUotgskwcnFINjJO6tNw3n77Vei+XaWPYjP3rmkPUew4H21zi6C2b
	7a22wN1jwtLsKxtPuLz+bhyvuKzLkffYq58FZ+K6Y4Xc5kzL1F5wjXOL+Dulvk3v37k4pK7N
	+OWwcN39bc/SvXu41r00Y4/bsD9s8s0ZynqpVYkSTDUHz00w/xU+f0Zit7JLV33MnxfPeZRY
	ijMSDbWYi4oTAUDKIL0wAgAA
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

