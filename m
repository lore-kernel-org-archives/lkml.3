Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbaKRUMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:12:20 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:60457 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbaKRUMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:12:19 -0500
From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
To: jorge.ramirez-ortiz@linaro.org, balbi@ti.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: add USB3 support to the printer driver
Date: Tue, 18 Nov 2014 15:11:54 -0500
Message-Id: <1416341514-28499-2-git-send-email-jorge.ramirez-ortiz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416341514-28499-1-git-send-email-jorge.ramirez-ortiz@linaro.org>
References: <1416341514-28499-1-git-send-email-jorge.ramirez-ortiz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SS descriptors to support the capabilities provided by USB3 controller
drivers; unit tests run using a PLX 3380 [max transfer speed measured of 1Gbps]

This driver shall fallback to lower operating modes when the higher ones are
not available.

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
---
 drivers/usb/gadget/legacy/printer.c | 65 +++++++++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/legacy/printer.c b/drivers/usb/gadget/legacy/printer.c
index 6474081..456730b 100644
--- a/drivers/usb/gadget/legacy/printer.c
+++ b/drivers/usb/gadget/legacy/printer.c
@@ -208,6 +208,43 @@ static struct usb_descriptor_header *hs_printer_function[] = {
 	NULL
 };
 
+/*
+ * Added endpoint descriptors for 3.0 devices
+ */
+
+static struct usb_endpoint_descriptor ss_ep_in_desc = {
+	.bLength =              USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =      USB_DT_ENDPOINT,
+	.bmAttributes =         USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =       cpu_to_le16(1024),
+};
+
+struct usb_ss_ep_comp_descriptor ss_ep_in_comp_desc = {
+	.bLength =              sizeof(ss_ep_in_comp_desc),
+	.bDescriptorType =      USB_DT_SS_ENDPOINT_COMP,
+};
+
+static struct usb_endpoint_descriptor ss_ep_out_desc = {
+	.bLength =              USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType =      USB_DT_ENDPOINT,
+	.bmAttributes =         USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize =       cpu_to_le16(1024),
+};
+
+struct usb_ss_ep_comp_descriptor ss_ep_out_comp_desc = {
+	.bLength =              sizeof(ss_ep_out_comp_desc),
+	.bDescriptorType =      USB_DT_SS_ENDPOINT_COMP,
+};
+
+static struct usb_descriptor_header *ss_printer_function[] = {
+	(struct usb_descriptor_header *) &intf_desc,
+	(struct usb_descriptor_header *) &ss_ep_in_desc,
+	(struct usb_descriptor_header *) &ss_ep_in_comp_desc,
+	(struct usb_descriptor_header *) &ss_ep_out_desc,
+	(struct usb_descriptor_header *) &ss_ep_out_comp_desc,
+	NULL
+};
+
 static struct usb_otg_descriptor otg_descriptor = {
 	.bLength =              sizeof otg_descriptor,
 	.bDescriptorType =      USB_DT_OTG,
@@ -220,7 +257,20 @@ static const struct usb_descriptor_header *otg_desc[] = {
 };
 
 /* maxpacket and other transfer characteristics vary by speed. */
-#define ep_desc(g, hs, fs) (((g)->speed == USB_SPEED_HIGH)?(hs):(fs))
+static inline struct usb_endpoint_descriptor *ep_desc(struct usb_gadget *gadget,
+					struct usb_endpoint_descriptor *fs,
+					struct usb_endpoint_descriptor *hs,
+					struct usb_endpoint_descriptor *ss)
+{
+	switch(gadget->speed) {
+	case USB_SPEED_SUPER:
+		return ss;
+	case USB_SPEED_HIGH:
+		return hs;
+	default:
+		return fs;
+	}
+}
 
 /*-------------------------------------------------------------------------*/
 
@@ -793,11 +843,12 @@ set_printer_interface(struct printer_dev *dev)
 {
 	int			result = 0;
 
-	dev->in_ep->desc = ep_desc(dev->gadget, &hs_ep_in_desc, &fs_ep_in_desc);
+	dev->in_ep->desc = ep_desc(dev->gadget, &fs_ep_in_desc, &hs_ep_in_desc,
+				&ss_ep_in_desc);
 	dev->in_ep->driver_data = dev;
 
-	dev->out_ep->desc = ep_desc(dev->gadget, &hs_ep_out_desc,
-				    &fs_ep_out_desc);
+	dev->out_ep->desc = ep_desc(dev->gadget, &fs_ep_out_desc,
+				    &hs_ep_out_desc, &ss_ep_out_desc);
 	dev->out_ep->driver_data = dev;
 
 	result = usb_ep_enable(dev->in_ep);
@@ -1016,9 +1067,11 @@ autoconf_fail:
 	/* assumes that all endpoints are dual-speed */
 	hs_ep_in_desc.bEndpointAddress = fs_ep_in_desc.bEndpointAddress;
 	hs_ep_out_desc.bEndpointAddress = fs_ep_out_desc.bEndpointAddress;
+	ss_ep_in_desc.bEndpointAddress = fs_ep_in_desc.bEndpointAddress;
+	ss_ep_out_desc.bEndpointAddress = fs_ep_out_desc.bEndpointAddress;
 
 	ret = usb_assign_descriptors(f, fs_printer_function,
-			hs_printer_function, NULL);
+			hs_printer_function, ss_printer_function);
 	if (ret)
 		return ret;
 
@@ -1253,7 +1306,7 @@ static __refdata struct usb_composite_driver printer_driver = {
 	.name           = shortname,
 	.dev            = &device_desc,
 	.strings        = dev_strings,
-	.max_speed      = USB_SPEED_HIGH,
+	.max_speed      = USB_SPEED_SUPER,
 	.bind		= printer_bind,
 	.unbind		= printer_unbind,
 };
-- 
1.9.1

