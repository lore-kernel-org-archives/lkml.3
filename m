Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaAPEdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:33:40 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45793 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaAPEdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:33:37 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>
Subject: [PATCH 11/15] w1: ds2490 USB setup fixes
Date: Wed, 15 Jan 2014 22:29:22 -0600
Message-Id: <1389846566-28862-12-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389846566-28862-1-git-send-email-David@Fries.net>
References: <1389846566-28862-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:33:30 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling usb_reset_configuration after usb_set_interface resets the
interface that was just selected, so call reset first.
Using alternative 3 greatly speeds the one wire search.
alt 0 or 1, 10ms int, 23.16 seconds
alt 2 or 3,  1ms int, 2.99 to 3.05 seconds

Use usb_interrupt_msg not usb_bulk_msg as it is an interrupt pipe
(bulk worked, it was just technically the wrong call).

Signed-off-by: David Fries <David@Fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/masters/ds2490.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 6a3d0a1..cd59e12 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -252,7 +252,8 @@ static int ds_recv_status_nodump(struct ds_device *dev, struct ds_status *st,
 	memset(st, 0, sizeof(*st));
 
 	count = 0;
-	err = usb_bulk_msg(dev->udev, usb_rcvbulkpipe(dev->udev, dev->ep[EP_STATUS]), buf, size, &count, 100);
+	err = usb_interrupt_msg(dev->udev, usb_rcvintpipe(dev->udev,
+		dev->ep[EP_STATUS]), buf, size, &count, 100);
 	if (err < 0) {
 		printk(KERN_ERR "Failed to read 1-wire data from 0x%x: err=%d.\n", dev->ep[EP_STATUS], err);
 		return err;
@@ -917,7 +918,7 @@ static int ds_probe(struct usb_interface *intf,
 	struct usb_endpoint_descriptor *endpoint;
 	struct usb_host_interface *iface_desc;
 	struct ds_device *dev;
-	int i, err;
+	int i, err, alt;
 
 	dev = kmalloc(sizeof(struct ds_device), GFP_KERNEL);
 	if (!dev) {
@@ -935,20 +936,25 @@ static int ds_probe(struct usb_interface *intf,
 
 	usb_set_intfdata(intf, dev);
 
-	err = usb_set_interface(dev->udev, intf->altsetting[0].desc.bInterfaceNumber, 3);
+	err = usb_reset_configuration(dev->udev);
 	if (err) {
-		printk(KERN_ERR "Failed to set alternative setting 3 for %d interface: err=%d.\n",
-				intf->altsetting[0].desc.bInterfaceNumber, err);
+		dev_err(&dev->udev->dev,
+			"Failed to reset configuration: err=%d.\n", err);
 		goto err_out_clear;
 	}
 
-	err = usb_reset_configuration(dev->udev);
+	/* alternative 3, 1ms interrupt (greatly speeds search), 64 byte bulk */
+	alt = 3;
+	err = usb_set_interface(dev->udev,
+		intf->altsetting[alt].desc.bInterfaceNumber, alt);
 	if (err) {
-		printk(KERN_ERR "Failed to reset configuration: err=%d.\n", err);
+		dev_err(&dev->udev->dev, "Failed to set alternative setting %d "
+			"for %d interface: err=%d.\n", alt,
+			intf->altsetting[alt].desc.bInterfaceNumber, err);
 		goto err_out_clear;
 	}
 
-	iface_desc = &intf->altsetting[0];
+	iface_desc = &intf->altsetting[alt];
 	if (iface_desc->desc.bNumEndpoints != NUM_EP-1) {
 		printk(KERN_INFO "Num endpoints=%d. It is not DS9490R.\n", iface_desc->desc.bNumEndpoints);
 		err = -EINVAL;
-- 
1.7.10.4

