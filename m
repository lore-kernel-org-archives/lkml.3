Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967892AbaLLNRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:17:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34357 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967578AbaLLNRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:17:43 -0500
X-AuditID: cbfee61a-f79c06d000004e71-95-548aeaf561d4
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, peter.chen@freescale.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] usb: gadget: udc-core: call udc_stop() before gadget unbind
Date: Fri, 12 Dec 2014 14:17:28 +0100
Message-id: <1418390248-6254-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t9jAd2vr7pCDKavl7A4eL/eonnxejaL
	2xOnsVlc3jWHzWLRslZmi7VH7rJbHJv9l8niweGd7A4cHv8O9zN57J+7ht2jb8sqRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CVMePKEsaCO1wVW1bcYm9g7ODsYuTkkBAwkbg9o4ERwhaT
	uHBvPVsXIxeHkMAiRonbty+zgiSEBNqZJJb+EAGx2QR0JLZ8nwDWICIgILH+xSV2kAZmgQuM
	Ev/edTJ3MXJwCAv4SLz/kwBSwyKgKnHv40dmEJtXwEXi26UZzBDL5CROHpvMOoGRewEjwypG
	0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4GB5JrWDcWWDxSFGAQ5GJR7eF6ldIUKsiWXFlbmH
	GCU4mJVEeP9GAYV4UxIrq1KL8uOLSnNSiw8xSnOwKInzKtm3hQgJpCeWpGanphakFsFkmTg4
	pRoYjZ8LT/zX8S3yqdWHjPRHCs+fvV90ekuu3r0SjXal3PyenZslZr7OWG4/g5XrbB9T6qOb
	ckyzz72dKLvEyuVMx4Udd+99TJgRuuz0KtGL1cpr9hhetAz286/vsvQ+IcKSdahwWbfylpiZ
	CdfbxbaY6R9fsExm/stvT55cEz1YwMvPu6vtwGx9XiWW4oxEQy3mouJEAJckYfASAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As usb function drivers assumes that all usb request will be completed
before function unbind call, we should supply such behavior. In some
cases ep_disable() won't kill all request effectively, because some
IN requests can be in running state. In such situation it's possible
to have unbind function called before last request completion, which
can cause problems.

For example unbinding f_ecm function while request on 'notify' endpoint
is not completed, ends up NULL pointer dereference in unbind() function.

usb_gadget_udc_stop() call causes completion of all requests so if it's
called before gadget unbind there is no risk that some of requests will
stay uncompleted.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/udc/udc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/udc-core.c
index e31d574..6f0d233 100644
--- a/drivers/usb/gadget/udc/udc-core.c
+++ b/drivers/usb/gadget/udc/udc-core.c
@@ -331,8 +331,8 @@ static void usb_gadget_remove_driver(struct usb_udc *udc)
 
 	usb_gadget_disconnect(udc->gadget);
 	udc->driver->disconnect(udc->gadget);
-	udc->driver->unbind(udc->gadget);
 	usb_gadget_udc_stop(udc);
+	udc->driver->unbind(udc->gadget);
 
 	udc->driver = NULL;
 	udc->dev.driver = NULL;
-- 
1.9.1

