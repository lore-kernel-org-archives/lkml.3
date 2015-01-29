Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764481AbbA2DoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:44:14 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:54798 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbbA2BZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:41 -0500
From: Ruslan Bilovol <ruslan.bilovol@gmail.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        gregkh@linuxfoundation.org
Cc: andrzej.p@samsung.com
Subject: [PATCH 1/2] usb: gadget: udc-core: independent registration of gadgets and gadget drivers
Date: Thu, 29 Jan 2015 03:25:33 +0200
Message-Id: <1422494734-9499-2-git-send-email-ruslan.bilovol@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422494734-9499-1-git-send-email-ruslan.bilovol@gmail.com>
References: <1422494734-9499-1-git-send-email-ruslan.bilovol@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change behavior during registration of gadgets and
gadget drivers in udc-core. Instead of previous
approach when for successful probe of usb gadget driver
at least one usb gadget should be already registered
use another one where gadget drivers and gadgets
can be registered in udc-core independently.

Independent registration of gadgets and gadget drivers
is useful for built-in into kernel gadget and gadget
driver case - because it's possible that gadget is
really probed only on late_init stage (due to deferred
probe) whereas gadget driver's probe is silently failed
on module_init stage due to no any UDC added.

Also it is useful for modules case - now there is no
difference what module to insert first: gadget module
or gadget driver one.

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
---
 drivers/usb/gadget/udc/udc-core.c | 113 +++++++++++++++++++++++++++++++++++---
 1 file changed, 105 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/udc-core.c
index e31d574..4c9412b 100644
--- a/drivers/usb/gadget/udc/udc-core.c
+++ b/drivers/usb/gadget/udc/udc-core.c
@@ -43,13 +43,23 @@ struct usb_udc {
 	struct usb_gadget_driver	*driver;
 	struct usb_gadget		*gadget;
 	struct device			dev;
+	bool				bind_by_name;
+	struct list_head		list;
+};
+
+struct pending_gadget_driver {
+	struct usb_gadget_driver	*driver;
+	char				*udc_name;
 	struct list_head		list;
 };
 
 static struct class *udc_class;
 static LIST_HEAD(udc_list);
+static LIST_HEAD(gadget_driver_pending_list);
 static DEFINE_MUTEX(udc_lock);
 
+static int udc_bind_to_driver(struct usb_udc *udc, struct usb_gadget_driver *driver,
+								bool bind_by_name);
 /* ------------------------------------------------------------------------- */
 
 #ifdef	CONFIG_HAS_DMA
@@ -244,6 +254,7 @@ int usb_add_gadget_udc_release(struct device *parent, struct usb_gadget *gadget,
 {
 	struct usb_udc		*udc;
 	int			ret = -ENOMEM;
+	struct pending_gadget_driver *pending;
 
 	udc = kzalloc(sizeof(*udc), GFP_KERNEL);
 	if (!udc)
@@ -288,6 +299,24 @@ int usb_add_gadget_udc_release(struct device *parent, struct usb_gadget *gadget,
 
 	usb_gadget_set_state(gadget, USB_STATE_NOTATTACHED);
 
+	if (!list_empty(&gadget_driver_pending_list)) {
+		pending = list_first_entry(&gadget_driver_pending_list,
+					struct pending_gadget_driver, list);
+
+		if (pending->udc_name) {
+			if (!strcmp(pending->udc_name, dev_name(&udc->dev))) {
+				udc_bind_to_driver(udc, pending->driver, true);
+				list_del(&pending->list);
+				kfree(pending->udc_name);
+				kfree(pending);
+			}
+		} else {
+			udc_bind_to_driver(udc, pending->driver, false);
+			list_del(&pending->list);
+			kfree(pending);
+		}
+	}
+
 	mutex_unlock(&udc_lock);
 
 	return 0;
@@ -364,10 +393,32 @@ found:
 	dev_vdbg(gadget->dev.parent, "unregistering gadget\n");
 
 	list_del(&udc->list);
-	mutex_unlock(&udc_lock);
 
-	if (udc->driver)
+	if (udc->driver) {
+		struct pending_gadget_driver *pending;
+
+		pending = kzalloc(sizeof(*pending), GFP_KERNEL);
+		if (!pending)
+			goto err;
+
+		if (udc->bind_by_name) {
+			pending->udc_name = kstrdup(dev_name(&udc->dev),
+								GFP_KERNEL);
+			if (!pending->udc_name) {
+				kfree(pending);
+				goto err;
+			}
+		}
+
+		pending->driver = udc->driver;
+		list_add_tail(&pending->list, &gadget_driver_pending_list);
+
+		pr_info("udc-core: added [%s] to list of pending drivers\n",
+						pending->driver->function);
+err:
 		usb_gadget_remove_driver(udc);
+	}
+	mutex_unlock(&udc_lock);
 
 	kobject_uevent(&udc->dev.kobj, KOBJ_REMOVE);
 	flush_work(&gadget->work);
@@ -378,7 +429,8 @@ EXPORT_SYMBOL_GPL(usb_del_gadget_udc);
 
 /* ------------------------------------------------------------------------- */
 
-static int udc_bind_to_driver(struct usb_udc *udc, struct usb_gadget_driver *driver)
+static int udc_bind_to_driver(struct usb_udc *udc, struct usb_gadget_driver *driver,
+								bool bind_by_name)
 {
 	int ret;
 
@@ -386,6 +438,7 @@ static int udc_bind_to_driver(struct usb_udc *udc, struct usb_gadget_driver *dri
 			driver->function);
 
 	udc->driver = driver;
+	udc->bind_by_name = bind_by_name;
 	udc->dev.driver = &driver->driver;
 	udc->gadget->dev.driver = &driver->driver;
 
@@ -423,14 +476,34 @@ int usb_udc_attach_driver(const char *name, struct usb_gadget_driver *driver)
 			break;
 	}
 	if (ret) {
-		ret = -ENODEV;
+		struct pending_gadget_driver *pending;
+
+		pending = kzalloc(sizeof(*pending), GFP_KERNEL);
+		if (!pending) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		pending->driver = driver;
+		pending->udc_name = kstrdup(name, GFP_KERNEL);
+		if (!pending->udc_name) {
+			kfree(pending);
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		list_add_tail(&pending->list, &gadget_driver_pending_list);
+
+		pr_info("udc-core: couldn't find the [%s] UDC "
+				"- add [%s] to list of pending drivers\n",
+				name, driver->function);
+		ret = 0;
 		goto out;
 	}
 	if (udc->driver) {
 		ret = -EBUSY;
 		goto out;
 	}
-	ret = udc_bind_to_driver(udc, driver);
+	ret = udc_bind_to_driver(udc, driver, true);
 out:
 	mutex_unlock(&udc_lock);
 	return ret;
@@ -440,6 +513,7 @@ EXPORT_SYMBOL_GPL(usb_udc_attach_driver);
 int usb_gadget_probe_driver(struct usb_gadget_driver *driver)
 {
 	struct usb_udc		*udc = NULL;
+	struct pending_gadget_driver *pending;
 	int			ret;
 
 	if (!driver || !driver->bind || !driver->setup)
@@ -452,11 +526,22 @@ int usb_gadget_probe_driver(struct usb_gadget_driver *driver)
 			goto found;
 	}
 
-	pr_debug("couldn't find an available UDC\n");
+	pending = kzalloc(sizeof(*pending), GFP_KERNEL);
+	if (!pending) {
+		mutex_unlock(&udc_lock);
+		return -ENOMEM;
+	}
+	pending->driver = driver;
+	list_add_tail(&pending->list, &gadget_driver_pending_list);
+
+	pr_info("udc-core: couldn't find an available UDC "
+			"- add [%s] to list of pending drivers\n",
+			driver->function);
+
 	mutex_unlock(&udc_lock);
-	return -ENODEV;
+	return 0;
 found:
-	ret = udc_bind_to_driver(udc, driver);
+	ret = udc_bind_to_driver(udc, driver, false);
 	mutex_unlock(&udc_lock);
 	return ret;
 }
@@ -465,6 +550,7 @@ EXPORT_SYMBOL_GPL(usb_gadget_probe_driver);
 int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
 {
 	struct usb_udc		*udc = NULL;
+	struct pending_gadget_driver *pending = NULL;
 	int			ret = -ENODEV;
 
 	if (!driver || !driver->unbind)
@@ -480,6 +566,17 @@ int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
 			break;
 		}
 
+	if (ret) {
+		list_for_each_entry(pending, &gadget_driver_pending_list, list)
+			if (pending->driver == driver) {
+				list_del(&pending->list);
+				kfree(pending->udc_name);
+				kfree(pending);
+				ret = 0;
+				break;
+			}
+	}
+
 	mutex_unlock(&udc_lock);
 	return ret;
 }
-- 
1.9.1

