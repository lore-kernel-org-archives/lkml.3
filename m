Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaFMOTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:19:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34036 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750951AbaFMOTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:19:38 -0400
Date: Fri, 13 Jun 2014 10:19:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Chen <Peter.Chen@freescale.com>
cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Disable bus's drivers_autoprobe before rootfs has mounted
In-Reply-To: <fa47f0c3798b48c781bc0a8c344e6c57@BL2PR03MB226.namprd03.prod.outlook.com>
Message-ID: <Pine.LNX.4.44L0.1406130944460.1059-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Peter Chen wrote:

> OK, we can keep our g_xxx gadget driver just support the basic feature. But
> the bug that causes gadget driver load fail due to udc is probed deferral should
> be fixed, do you think so, we can't wait until configfs has total been ready.

That problem has always existed.  There never has been a time when a
gadget driver could be loaded before the UDC driver was ready.  Does it 
really need to be fixed now?

If you do want to fix the problem, there's a much easier way than what
you posted.  See below.

Alan Stern



Index: usb-3.15/include/linux/usb/gadget.h
===================================================================
--- usb-3.15.orig/include/linux/usb/gadget.h
+++ usb-3.15/include/linux/usb/gadget.h
@@ -821,6 +821,7 @@ static inline int usb_gadget_disconnect(
  * @suspend: Invoked on USB suspend.  May be called in_interrupt.
  * @resume: Invoked on USB resume.  May be called in_interrupt.
  * @driver: Driver model state for this driver.
+ * @probe_list: List of drivers waiting to be probed.
  *
  * Devices are disabled till a gadget driver successfully bind()s, which
  * means the driver will handle setup() requests needed to enumerate (and
@@ -881,6 +882,7 @@ struct usb_gadget_driver {
 
 	/* FIXME support safe rmmod */
 	struct device_driver	driver;
+	struct list_head	probe_list;
 };
 
 
Index: usb-3.15/drivers/usb/gadget/udc-core.c
===================================================================
--- usb-3.15.orig/drivers/usb/gadget/udc-core.c
+++ usb-3.15/drivers/usb/gadget/udc-core.c
@@ -47,8 +47,12 @@ struct usb_udc {
 
 static struct class *udc_class;
 static LIST_HEAD(udc_list);
+static LIST_HEAD(pending_drivers);
 static DEFINE_MUTEX(udc_lock);
 
+static int udc_bind_to_driver(struct usb_udc *udc,
+		struct usb_gadget_driver *driver);
+
 /* ------------------------------------------------------------------------- */
 
 #ifdef	CONFIG_HAS_DMA
@@ -242,6 +246,15 @@ int usb_add_gadget_udc_release(struct de
 
 	usb_gadget_set_state(gadget, USB_STATE_NOTATTACHED);
 
+	while (!list_empty(&pending_drivers)) {
+		struct usb_gadget_driver *driver;
+
+		driver = list_first_entry(&pending_drivers,
+				struct usb_gadget_driver, probe_list);
+		if (udc_bind_to_driver(udc, driver) == 0)
+			break;
+	}
+
 	mutex_unlock(&udc_lock);
 
 	return 0;
@@ -338,6 +351,7 @@ static int udc_bind_to_driver(struct usb
 
 	dev_dbg(&udc->dev, "registering UDC driver [%s]\n",
 			driver->function);
+	list_del_init(&driver->probe_list);
 
 	udc->driver = driver;
 	udc->dev.driver = &driver->driver;
@@ -400,6 +414,7 @@ int usb_gadget_probe_driver(struct usb_g
 		return -EINVAL;
 
 	mutex_lock(&udc_lock);
+	INIT_LIST_HEAD(&driver->probe_list);
 	list_for_each_entry(udc, &udc_list, list) {
 		/* For now we take the first one */
 		if (!udc->driver)
@@ -407,8 +422,9 @@ int usb_gadget_probe_driver(struct usb_g
 	}
 
 	pr_debug("couldn't find an available UDC\n");
+	list_add_tail(&driver->probe_list, &pending_drivers);
 	mutex_unlock(&udc_lock);
-	return -ENODEV;
+	return 0;
 found:
 	ret = udc_bind_to_driver(udc, driver);
 	mutex_unlock(&udc_lock);
@@ -425,6 +441,7 @@ int usb_gadget_unregister_driver(struct
 		return -EINVAL;
 
 	mutex_lock(&udc_lock);
+	list_del(&driver->probe_list);
 	list_for_each_entry(udc, &udc_list, list)
 		if (udc->driver == driver) {
 			usb_gadget_remove_driver(udc);


