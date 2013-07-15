Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3GOD50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 23:57:26 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47722 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab3GOD5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 23:57:25 -0400
MIME-Version: 1.0
Date: Mon, 15 Jul 2013 11:57:24 +0800
Message-ID: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
Subject: [PATCH] usb: udc: add gadget state kobject uevent
From: Rong Wang <wr011235813@gmail.com>
To: balbi@ti.com, Greg KH <gregkh@linuxfoundation.org>
Cc: arnd@arndb.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rong.Wang@csr.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    usb: udc: add gadget state kobject uevent

    Add USB_UDC_STATE environment variable in udc uevent
    callback and trigger kobject_uevent in usb_gadget_set_state
    to inform the user-space the state of the gadget.

    Signed-off-by: Rong Wang <Rong.Wang@csr.com>

diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
index ffd8fa5..05715d1 100644
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -101,11 +101,32 @@ EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);

 /* ------------------------------------------------------------------------- */

+/**
+ * usb_gadget_set_state - set usb gadget state
+ * @gadget: gadget device
+ * @state: state defined in USB specification ch9
+ * Context: !in_interrupt()
+ */
 void usb_gadget_set_state(struct usb_gadget *gadget,
                enum usb_device_state state)
 {
+       struct usb_udc          *udc = NULL;
+
        gadget->state = state;
        sysfs_notify(&gadget->dev.kobj, NULL, "status");
+
+       mutex_lock(&udc_lock);
+       list_for_each_entry(udc, &udc_list, list)
+               if (udc->gadget == gadget)
+                       goto found;
+
+       dev_err(gadget->dev.parent, "gadget not registered.\n");
+       mutex_unlock(&udc_lock);
+       return;
+
+found:
+       mutex_unlock(&udc_lock);
+       kobject_uevent(&udc->dev.kobj, KOBJ_CHANGE);
 }
 EXPORT_SYMBOL_GPL(usb_gadget_set_state);

@@ -538,6 +559,15 @@ static int usb_udc_uevent(struct device *dev,
struct kobj_uevent_env *env)
                }
        }

+       if (udc->gadget) {
+               ret = add_uevent_var(env, "USB_UDC_STATE=%s",
+                               usb_state_string(udc->gadget->state));
+               if (ret) {
+                       dev_err(dev, "failed to add uevent USB_UDC_STATE\n");
+                       return ret;
+               }
+       }
+
        return 0;
 }
