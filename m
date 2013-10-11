Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab3JKKmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:42:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58383 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597Ab3JKKme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 013/100] usb: gadget: fix a bug and a WARN_ON in dummy-hcd
Date: Fri, 11 Oct 2013 11:40:43 +0100
Message-Id: <1381488130-30235-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/dummy_hcd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 4ad1f1c..1e0f8cd 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -921,8 +921,9 @@ static int dummy_udc_stop(struct usb_gadget *g,
 	struct dummy_hcd	*dum_hcd = gadget_to_dummy_hcd(g);
 	struct dummy		*dum = dum_hcd->dum;
 
-	dev_dbg(udc_dev(dum), "unregister gadget driver '%s'\n",
-			driver->driver.name);
+	if (driver)
+		dev_dbg(udc_dev(dum), "unregister gadget driver '%s'\n",
+				driver->driver.name);
 
 	dum->driver = NULL;
 
@@ -1011,9 +1012,9 @@ static int dummy_udc_remove(struct platform_device *pdev)
 {
 	struct dummy	*dum = platform_get_drvdata(pdev);
 
-	usb_del_gadget_udc(&dum->gadget);
 	platform_set_drvdata(pdev, NULL);
 	device_remove_file(&dum->gadget.dev, &dev_attr_function);
+	usb_del_gadget_udc(&dum->gadget);
 	device_unregister(&dum->gadget.dev);
 	return 0;
 }
-- 
1.8.3.2

