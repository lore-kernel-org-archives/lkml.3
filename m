Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaLPXQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:16:38 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:60693 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaLPXQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:16:36 -0500
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: hcd: add OTG ID signal sensing
Date: Wed, 17 Dec 2014 02:16:31 +0300
Message-ID: <3663198.HSrURZGche@wasted.cogentembedded.com>
Organization: Cogent Embedded Inc.
User-Agent: KMail/4.14.3 (Linux/3.17.4-200.fc20.x86_64; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the Renesas R8A7791 SoC based boards there's MAX3355 USB OTG chip and mini-AB
USB connector corresponding to USB port 0 driven either by EHCI/OHCI or  Renesas
USBHS gadget controller. And we'd like the  host/gadget drivers to work based on
the cable type connected. An 'extcon' driver for MAX3355 has been written, so we
only need to bind  to it via device tree which I'm doing in this patch.

I wasn't able to find a solution better than checking the cable type at the host
driver probe time and refusing to drive a host if B-cable is connected.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
The patch is against the 'usb-next' branch of Greg KH's 'usb.git' repo.
It needs the recent 'extcon' core in order to properly handle probe deferral.  

 drivers/usb/core/hcd.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

Index: usb/drivers/usb/core/hcd.c
===================================================================
--- usb.orig/drivers/usb/core/hcd.c
+++ usb/drivers/usb/core/hcd.c
@@ -42,6 +42,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
 
+#include <linux/extcon.h>
 #include <linux/phy/phy.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
@@ -2632,6 +2633,23 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	int retval;
 	struct usb_device *rhdev;
 
+	if (IS_ENABLED(CONFIG_EXTCON) &&
+	    of_property_read_bool(hcd->self.controller->of_node, "extcon")) {
+		struct extcon_dev *edev;
+
+		edev = extcon_get_edev_by_phandle(hcd->self.controller, 0);
+		if (IS_ERR(edev))
+			return PTR_ERR(edev);
+
+		retval = extcon_get_cable_state(edev, "USB-HOST");
+		if (!retval) {
+			dev_err(hcd->self.controller,
+				"OTG B-cable plugged in, host driver won't load\n");
+			return -EINVAL;
+		} else if (retval < 0)
+			return retval;
+	}
+
 	if (IS_ENABLED(CONFIG_USB_PHY) && !hcd->usb_phy) {
 		struct usb_phy *phy = usb_get_phy_dev(hcd->self.controller, 0);
 

