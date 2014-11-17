Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaKQXT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:19:58 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:62491 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaKQXT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:19:57 -0500
Message-ID: <546A829A.8030106@linaro.org>
Date: Mon, 17 Nov 2014 18:19:54 -0500
From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]  usb: gadget: USB3 support to the legacy printer driver
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds USB3 support to the legacy gadget printer driver.
Applies cleanly on fc14f9c Linux 3.18-rc5.

Please could it be considered for inclusion?

regards,
Jorge



>From f46d9b0d2160b30f14dee104657de865e9e2bc38 Mon Sep 17 00:00:00 2001
From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
Date: Thu, 25 Sep 2014 16:17:20 -0400
Subject: [PATCH] usb: gadget: add USB3 support to the printer driver

Add SS descriptors to support the capabilities provided by USB3 controller
drivers; unit tests run using PLX 3380 [max transfer speed measured of 1Gbps]

This driver will fallback to lower operating modes when the higher ones are
not available.

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
---
 drivers/usb/gadget/legacy/printer.c | 66 +++++++++++++++++++++++++++++++++----
 1 file changed, 60 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/legacy/printer.c b/drivers/usb/gadget/legacy/printer.c
index 6474081..625d905 100644
--- a/drivers/usb/gadget/legacy/printer.c
+++ b/drivers/usb/gadget/legacy/printer.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2003-2005 David Brownell
  * Copyright (C) 2006 Craig W. Nadler
+ * Copyright (C) 2014 Linaro.org
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -208,6 +209,43 @@ static struct usb_descriptor_header *hs_printer_function[] = {
        NULL
 };
 
+/*
+ * Added endpoint descriptors for 3.0 devices
+ */
+
+static struct usb_endpoint_descriptor ss_ep_in_desc = {
+       .bLength =              USB_DT_ENDPOINT_SIZE,
+       .bDescriptorType =      USB_DT_ENDPOINT,
+       .bmAttributes =         USB_ENDPOINT_XFER_BULK,
+       .wMaxPacketSize =       cpu_to_le16(1024),
+};
+
+struct usb_ss_ep_comp_descriptor ss_ep_in_comp_desc = {
+       .bLength =              sizeof(ss_ep_in_comp_desc),
+       .bDescriptorType =      USB_DT_SS_ENDPOINT_COMP,
+};
+
+static struct usb_endpoint_descriptor ss_ep_out_desc = {
+       .bLength =              USB_DT_ENDPOINT_SIZE,
+       .bDescriptorType =      USB_DT_ENDPOINT,
+       .bmAttributes =         USB_ENDPOINT_XFER_BULK,
+       .wMaxPacketSize =       cpu_to_le16(1024),
+};
+
+struct usb_ss_ep_comp_descriptor ss_ep_out_comp_desc = {
+       .bLength =              sizeof(ss_ep_out_comp_desc),
+       .bDescriptorType =      USB_DT_SS_ENDPOINT_COMP,
+};
+
+static struct usb_descriptor_header *ss_printer_function[] = {
+       (struct usb_descriptor_header *) &intf_desc,
+       (struct usb_descriptor_header *) &ss_ep_in_desc,
+       (struct usb_descriptor_header *) &ss_ep_in_comp_desc,
+       (struct usb_descriptor_header *) &ss_ep_out_desc,
+       (struct usb_descriptor_header *) &ss_ep_out_comp_desc,
+       NULL
+};
+
 static struct usb_otg_descriptor otg_descriptor = {
        .bLength =              sizeof otg_descriptor,
        .bDescriptorType =      USB_DT_OTG,
@@ -220,7 +258,20 @@ static const struct usb_descriptor_header *otg_desc[] = {
 };
 
 /* maxpacket and other transfer characteristics vary by speed. */
-#define ep_desc(g, hs, fs) (((g)->speed == USB_SPEED_HIGH)?(hs):(fs))
+static inline struct usb_endpoint_descriptor *ep_desc(struct usb_gadget *gadget,
+                                       struct usb_endpoint_descriptor *fs,
+                                       struct usb_endpoint_descriptor *hs,
+                                       struct usb_endpoint_descriptor *ss)
+{
+       struct usb_endpoint_descriptor *d = fs;
+
+       if (gadget->speed == USB_SPEED_SUPER)
+               d = ss;
+       else if (gadget->speed == USB_SPEED_HIGH)
+               d = hs;
+
+       return d;
+}
 
 /*-------------------------------------------------------------------------*/
 
@@ -793,11 +844,12 @@ set_printer_interface(struct printer_dev *dev)
 {
        int                     result = 0;
 
-       dev->in_ep->desc = ep_desc(dev->gadget, &hs_ep_in_desc, &fs_ep_in_desc);
+       dev->in_ep->desc = ep_desc(dev->gadget, &fs_ep_in_desc, &hs_ep_in_desc,
+                                                               &ss_ep_in_desc);
        dev->in_ep->driver_data = dev;
 
-       dev->out_ep->desc = ep_desc(dev->gadget, &hs_ep_out_desc,
-                                   &fs_ep_out_desc);
+       dev->out_ep->desc = ep_desc(dev->gadget, &fs_ep_out_desc,
+                                       &hs_ep_out_desc, &ss_ep_out_desc);
        dev->out_ep->driver_data = dev;
 
        result = usb_ep_enable(dev->in_ep);
@@ -1016,9 +1068,11 @@ autoconf_fail:
        /* assumes that all endpoints are dual-speed */
        hs_ep_in_desc.bEndpointAddress = fs_ep_in_desc.bEndpointAddress;
        hs_ep_out_desc.bEndpointAddress = fs_ep_out_desc.bEndpointAddress;
+       ss_ep_in_desc.bEndpointAddress = fs_ep_in_desc.bEndpointAddress;
+       ss_ep_out_desc.bEndpointAddress = fs_ep_out_desc.bEndpointAddress;
 
        ret = usb_assign_descriptors(f, fs_printer_function,
-                       hs_printer_function, NULL);
+                                    hs_printer_function, ss_printer_function);
        if (ret)
                return ret;
 
@@ -1253,7 +1307,7 @@ static __refdata struct usb_composite_driver printer_driver = {
        .name           = shortname,
        .dev            = &device_desc,
        .strings        = dev_strings,
-       .max_speed      = USB_SPEED_HIGH,
+       .max_speed      = USB_SPEED_SUPER,
        .bind           = printer_bind,
        .unbind         = printer_unbind,
 };
-- 
1.9.1

