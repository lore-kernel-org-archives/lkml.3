Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab3JJPpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:45:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52706 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3JJPpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:45:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 048/104] usb: gadget: fix a bug and a WARN_ON in dummy-hcd
Date: Thu, 10 Oct 2013 08:41:36 -0700
Message-Id: <1381419752-29733-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 5f5610f69be3a925b1f79af27150bb7377bc9ad6 upstream.

This patch fixes a NULL pointer dereference and a WARN_ON in
dummy-hcd.  These things were the result of moving to the UDC core
framework, and possibly of changes to that framework.

Now unloading a gadget driver causes the UDC to be stopped after the
gadget driver is unbound, not before.  Therefore the "driver" argument
to dummy_udc_stop() can be NULL, so we must not try to print the
driver's name without checking first.

Also, the UDC framework automatically unregisters the gadget when the
UDC is deleted.  Therefore a sysfs attribute file attached to the
gadget must be removed before the UDC is deleted, not after.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/gadget/dummy_hcd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 8cf0c0f..b693889 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -924,8 +924,9 @@ static int dummy_udc_stop(struct usb_gadget *g,
 	struct dummy_hcd	*dum_hcd = gadget_to_dummy_hcd(g);
 	struct dummy		*dum = dum_hcd->dum;
 
-	dev_dbg(udc_dev(dum), "unregister gadget driver '%s'\n",
-			driver->driver.name);
+	if (driver)
+		dev_dbg(udc_dev(dum), "unregister gadget driver '%s'\n",
+				driver->driver.name);
 
 	dum->gadget.dev.driver = NULL;
 	dum->driver = NULL;
@@ -1016,10 +1017,10 @@ static int dummy_udc_remove(struct platform_device *pdev)
 {
 	struct dummy	*dum = platform_get_drvdata(pdev);
 
-	usb_del_gadget_udc(&dum->gadget);
 	platform_set_drvdata(pdev, NULL);
 	device_remove_file(&dum->gadget.dev, &dev_attr_function);
 	device_unregister(&dum->gadget.dev);
+	usb_del_gadget_udc(&dum->gadget);
 	return 0;
 }
 
-- 
1.8.1.2

