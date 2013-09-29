Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3I2T5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:57:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab3I2T17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:27:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Subject: [ 18/49] usb: gadget: fix a bug and a WARN_ON in dummy-hcd
Date: Sun, 29 Sep 2013 12:26:52 -0700
Message-Id: <20130929191604.242548631@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
References: <20130929191603.008825488@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/dummy_hcd.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -923,8 +923,9 @@ static int dummy_udc_stop(struct usb_gad
 	struct dummy_hcd	*dum_hcd = gadget_to_dummy_hcd(g);
 	struct dummy		*dum = dum_hcd->dum;
 
-	dev_dbg(udc_dev(dum), "unregister gadget driver '%s'\n",
-			driver->driver.name);
+	if (driver)
+		dev_dbg(udc_dev(dum), "unregister gadget driver '%s'\n",
+				driver->driver.name);
 
 	dum->driver = NULL;
 
@@ -1000,8 +1001,8 @@ static int dummy_udc_remove(struct platf
 {
 	struct dummy	*dum = platform_get_drvdata(pdev);
 
-	usb_del_gadget_udc(&dum->gadget);
 	device_remove_file(&dum->gadget.dev, &dev_attr_function);
+	usb_del_gadget_udc(&dum->gadget);
 	return 0;
 }
 


